local _, Logres = ...

local PREVIEW_SECONDS = 30.0
local PAGE_CHAR_LIMIT = 420

local Dialogue = Logres:RegisterModule("QuestDialogue", {
    autoEnable = true,
})

local theme = Logres.Theme or {}
local dialogueStyle = theme.questDialogue or {}
local dialogueAssets = dialogueStyle.assets or {}
local dialogueColors = dialogueStyle.colors or {}

local offerStyle = theme.questOfferControls or {}
local offerAssets = offerStyle.assets or {}
local offerColors = offerStyle.colors or {}

local DEFAULT_STYLE = {
    width = 640,
    height = 320,
    x = 0,
    y = -110,
    titleWidth = 560,
    bodyWidth = 548,
    bodyHeight = 134,
    objectiveWidth = 548,
    objectiveHeight = 50,
    titleFont = "GameFontHighlightLarge",
    bodyFont = "GameFontHighlight",
    objectiveHeaderFont = "GameFontNormalSmall",
    objectiveFont = "GameFontNormal",
    pageFont = "GameFontHighlightSmall",
}

local DEFAULT_COLORS = {
    title = { 0.94, 0.83, 0.60, 1.00 },
    body = { 0.92, 0.89, 0.81, 0.97 },
    objectiveHeader = { 0.66, 0.50, 0.28, 0.95 },
    objective = { 0.84, 0.76, 0.60, 0.97 },
    page = { 0.64, 0.56, 0.43, 0.90 },
    pageActive = { 0.92, 0.78, 0.48, 1.00 },
    pageInactive = { 0.34, 0.30, 0.24, 0.55 },
}

local DEFAULT_OFFER_STYLE = {
    width = 410,
    height = 62,
    y = -4,
    buttonWidth = 150,
    buttonHeight = 38,
    buttonGap = 42,
    font = "GameFontHighlightLarge",
    feedbackFont = "GameFontHighlightSmall",
}

local DEFAULT_OFFER_COLORS = {
    decline = { 0.86, 0.82, 0.73, 0.96 },
    accept = { 0.96, 0.72, 0.24, 1.00 },
    hover = { 1.00, 0.86, 0.48, 1.00 },
    pressed = { 0.78, 0.55, 0.18, 1.00 },
    feedback = { 0.72, 0.64, 0.50, 0.92 },
}

local function styleValue(name)
    local value = dialogueStyle[name]

    if value ~= nil then
        return value
    end

    return DEFAULT_STYLE[name]
end

local function colorValue(name)
    return dialogueColors[name] or DEFAULT_COLORS[name]
end

local function offerStyleValue(name)
    local value = offerStyle[name]

    if value ~= nil then
        return value
    end

    return DEFAULT_OFFER_STYLE[name]
end

local function offerColor(name)
    return offerColors[name] or DEFAULT_OFFER_COLORS[name]
end

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function readString(label, func)
    if type(func) ~= "function" then
        return nil, label .. "-api-unavailable", false
    end

    local ok, value = pcall(func)

    if not ok then
        return nil, label .. "-call-failed", false
    end

    if isSecret(value) then
        return nil, label .. "-secret", true
    end

    if value == nil then
        return "", nil, false
    end

    if type(value) ~= "string" then
        return nil, label .. "-invalid", false
    end

    return value, nil, false
end

local function readQuestID()
    if type(GetQuestID) ~= "function" then
        return nil, "quest-id-api-unavailable", false
    end

    local ok, questID = pcall(GetQuestID)

    if not ok then
        return nil, "quest-id-call-failed", false
    end

    if isSecret(questID) then
        return nil, "quest-id-secret", true
    end

    if questID == nil then
        return nil, nil, false
    end

    if type(questID) ~= "number" then
        return nil, "quest-id-invalid", false
    end

    return questID, nil, false
end

local function appendPage(pages, text)
    if text == "" then
        return
    end

    pages[#pages + 1] = text
end

local function addParagraphWords(
    pages,
    current,
    paragraph
)
    local prefix =
        current == "" and "" or "\n\n"

    for word in paragraph:gmatch("%S+") do
        local separator =
            current == "" and "" or " "
        local candidate

        if prefix ~= "" then
            candidate =
                current
                .. prefix
                .. word
            prefix = ""
        else
            candidate =
                current
                .. separator
                .. word
        end

        if #candidate > PAGE_CHAR_LIMIT
            and current ~= ""
        then
            appendPage(pages, current)
            current = word
        else
            current = candidate
        end
    end

    return current
end

local function buildPages(text)
    if text == "" then
        return { "" }
    end

    local pages = {}
    local current = ""
    local sawParagraph = false

    for paragraph in (text .. "\n"):gmatch("(.-)\n") do
        if paragraph ~= "" then
            sawParagraph = true
            current = addParagraphWords(
                pages,
                current,
                paragraph
            )
        end
    end

    if current ~= "" then
        appendPage(pages, current)
    end

    if not sawParagraph or #pages == 0 then
        pages[1] = text
    end

    return pages
end

local function setFontColor(fontString, color)
    fontString:SetTextColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
end

local function setOfferVisual(button, color)
    button.label:SetTextColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
    button.rule:SetVertexColor(
        color[1],
        color[2],
        color[3],
        color[4]
    )
end

local function createOfferButton(
    owner,
    parent,
    kind,
    label
)
    local button = CreateFrame(
        "Button",
        nil,
        parent
    )
    button:SetSize(
        offerStyleValue("buttonWidth"),
        offerStyleValue("buttonHeight")
    )
    button:EnableMouse(true)
    button:RegisterForClicks("LeftButtonUp")

    local text = button:CreateFontString(
        nil,
        "OVERLAY",
        offerStyleValue("font")
    )
    text:SetPoint("CENTER", button, "CENTER", 0, 3)
    text:SetText(label)
    text:SetJustifyH("CENTER")
    text:SetShadowColor(0, 0, 0, 0.90)
    text:SetShadowOffset(1, -1)

    local rule = button:CreateTexture(
        nil,
        "ARTWORK"
    )
    rule:SetTexture(
        offerAssets.rule
        or "Interface\\Buttons\\WHITE8x8"
    )
    rule:SetSize(
        offerStyleValue("buttonWidth"),
        12
    )
    rule:SetPoint(
        "TOP",
        text,
        "BOTTOM",
        0,
        -2
    )

    button.label = text
    button.rule = rule
    button.kind = kind

    local normalColor =
        kind == "accept"
        and offerColor("accept")
        or offerColor("decline")

    setOfferVisual(button, normalColor)

    button:SetScript("OnEnter", function()
        setOfferVisual(
            button,
            offerColor("hover")
        )
    end)

    button:SetScript("OnLeave", function()
        setOfferVisual(
            button,
            normalColor
        )
    end)

    button:SetScript("OnMouseDown", function()
        setOfferVisual(
            button,
            offerColor("pressed")
        )
    end)

    button:SetScript("OnMouseUp", function()
        setOfferVisual(
            button,
            offerColor("hover")
        )
    end)

    button:SetScript("OnClick", function()
        owner:HandleOfferAction(kind)
    end)

    return button
end

function Dialogue:SetOfferActionFeedback(text)
    if text == nil or text == "" then
        self.offerActionFeedback:ClearText()
        self.offerActionFeedback:Hide()
        return
    end

    self.offerActionFeedback:SetText(text)
    self.offerActionFeedback:Show()
end

function Dialogue:RequestStockOfferSuppression(enabled, reason)
    local ok, suppression = pcall(
        Logres.GetModule,
        Logres,
        "QuestOfferStockSuppression"
    )

    if not ok
        or not suppression
        or type(suppression.RequestEnabled) ~= "function"
    then
        self.stockOfferSuppressionApplied = false
        self.lastStockOfferSuppressionResult =
            "suppression-module-unavailable"
        return false, "suppression-module-unavailable"
    end

    local callOK, applied, result = pcall(
        suppression.RequestEnabled,
        suppression,
        enabled == true,
        reason
    )

    if not callOK then
        self.stockOfferSuppressionApplied = false
        self.lastStockOfferSuppressionResult =
            "suppression-request-failed"
        return false, "suppression-request-failed"
    end

    self.stockOfferSuppressionApplied =
        enabled == true and applied == true
    self.lastStockOfferSuppressionResult = result

    return self.stockOfferSuppressionApplied, result
end

function Dialogue:UpdateOfferControls()
    local pageCount = #self.pages
    local finalPage =
        pageCount <= 1
        or self.currentPage == pageCount

    self.offerControlsFinalPage = finalPage

    local baseEligible =
        self.moduleEnabled
        and self.immersionEnabled
        and self.presentationShown
        and self.offerActionsEnabled

    local previewEligible =
        baseEligible
        and self.offerActionPreview
        and finalPage

    local productionEligible =
        baseEligible
        and not self.offerActionPreview

    local stockApplied = false

    if productionEligible then
        stockApplied = select(1,
            self:RequestStockOfferSuppression(
                true,
                "dialogue-offer"
            )
        )
    else
        self:RequestStockOfferSuppression(
            false,
            "dialogue-offer-not-owned"
        )
    end

    local shouldShow =
        previewEligible
        or (stockApplied and finalPage)

    if shouldShow then
        self.offerActionRoot:Show()
    else
        self.offerActionRoot:Hide()
    end
end

function Dialogue:HandleOfferAction(kind)
    self.offerActionClickCount =
        self.offerActionClickCount + 1
    self.lastOfferActionKind = kind

    if self.offerActionPreview then
        self.lastOfferActionResult =
            "preview-only"
        self.lastOfferActionError = nil
        self:SetOfferActionFeedback(
            "Preview only"
        )
        return true, "preview-only"
    end

    local detail = self.activeDetail

    if not detail then
        self.lastOfferActionResult =
            "blocked"
        self.lastOfferActionError =
            "no-active-detail"
        self:SetOfferActionFeedback(
            "Use the standard quest controls."
        )
        return false, "no-active-detail"
    end

    local actionRuntime =
        Logres:GetModule(
            "QuestOfferActionProbe"
        )
    local ok, reason =
        actionRuntime:TriggerProductionAction(
            kind,
            detail.questID,
            detail.title
        )

    if ok then
        self:RequestStockOfferSuppression(
            false,
            "offer-action-started"
        )
        self.offerActionsEnabled = false
        self.offerActionPending = true
        self.lastOfferActionResult =
            "started"
        self.lastOfferActionError = nil
        self:SetOfferActionFeedback(nil)
        self.offerActionRoot:Hide()
        return true, reason
    end

    self:RequestStockOfferSuppression(
        false,
        "offer-action-blocked"
    )
    self.offerActionsEnabled = false
    self.offerActionPending = false
    self.lastOfferActionResult =
        "blocked"
    self.lastOfferActionError = reason
    self:SetOfferActionFeedback(
        "Use the standard quest controls."
    )
    self.offerActionRoot:Hide()

    return false, reason
end

function Dialogue:HidePresentation(reason)
    self:RequestStockOfferSuppression(
        false,
        reason or "hide-presentation"
    )

    self.presentationGeneration =
        self.presentationGeneration + 1
    self.presentationShown = false
    self.progressActive = false
    self.completionActive = false
    self.pages = {}
    self.currentPage = 0

    if self.root then
        self.root:Hide()
    end

    if self.offerActionRoot then
        self.offerActionRoot:Hide()
    end

    self.offerActionsEnabled = false
    self.offerActionPreview = false
    self.offerActionPending = false

    if reason then
        self.lastPresentationReason = reason
    end
end

function Dialogue:ClearFailure(
    reason,
    errorText,
    secretObserved
)
    self.lastReason = reason
    self.lastError = errorText
    self.lastSecret =
        secretObserved and true or false
    self.activeDetail = nil
    self:HidePresentation(reason)
end

function Dialogue:ClearActiveDetail(reason)
    self.activeDetail = nil
    self:HidePresentation(reason)
end

function Dialogue:ReadDetail()
    self.apiAvailable =
        type(GetQuestID) == "function"
        and type(GetTitleText) == "function"
        and type(GetQuestText) == "function"
        and type(GetObjectiveText) == "function"

    if not self.apiAvailable then
        return nil,
            "quest-detail-api-unavailable",
            false
    end

    local questID, questIDError, questIDSecret =
        readQuestID()

    if questIDError then
        return nil, questIDError, questIDSecret
    end

    local title, titleError, titleSecret =
        readString("title", GetTitleText)

    if titleError then
        return nil, titleError, titleSecret
    end

    local body, bodyError, bodySecret =
        readString("body", GetQuestText)

    if bodyError then
        return nil, bodyError, bodySecret
    end

    local objective, objectiveError, objectiveSecret =
        readString(
            "objective",
            GetObjectiveText
        )

    if objectiveError then
        return nil,
            objectiveError,
            objectiveSecret
    end

    if title == "" then
        return nil, "title-empty", false
    end

    return {
        questID = questID,
        title = title,
        body = body,
        objective = objective,
    }, nil, false
end

-- P0241: show only actual ordinary quest-progress text; Blizzard owns Continue.
function Dialogue:ReadProgress()
    if type(GetQuestID) ~= "function"
        or type(GetTitleText) ~= "function"
        or type(GetProgressText) ~= "function"
    then
        return nil, "progress-api-unavailable", false
    end

    local questID, idError, idSecret = readQuestID()
    if idError then return nil, idError, idSecret end
    if questID == nil or questID <= 0
        or questID ~= questID or questID == math.huge
    then
        return nil, "progress-id-unavailable", false
    end

    local title, titleError, titleSecret = readString("progress-title", GetTitleText)
    if titleError then return nil, titleError, titleSecret end
    if title == "" then return nil, "progress-title-empty", false end

    local body, bodyError, bodySecret = readString("progress-text", GetProgressText)
    if bodyError then return nil, bodyError, bodySecret end
    if body == "" then return nil, "progress-text-empty", false end

    return { questID = questID, title = title, body = body }, nil, false
end

function Dialogue:HandleQuestProgress()
    self.progressEventCount = self.progressEventCount + 1
    -- Drop previous offer identity/actions before inspecting another lifecycle stage.
    self:ClearActiveDetail("QUEST_PROGRESS")
    local progress, reason, secret = self:ReadProgress()
    if not progress then
        self.progressSkippedCount = self.progressSkippedCount + 1
        self.lastProgressReason = reason or "progress-unavailable"
        self.lastProgressSecret = secret == true
        return
    end

    self.lastQuestID = progress.questID
    self.lastHadBody = true
    self.lastHadObjective = false
    self.lastReason = "QUEST_PROGRESS"
    self.lastSecret = false
    self.lastError = nil

    if not self.immersionEnabled then
        self.suppressedCount = self.suppressedCount + 1
        self.lastProgressReason = "immersion-off"
        return
    end

    local shown, state = self:PresentText(
        progress.title, progress.body, "", "QUEST_PROGRESS",
        false, false, false
    )
    if shown and state == "shown" then
        self.progressActive = true
        self.progressShownCount = self.progressShownCount + 1
        self.presentationCount = self.presentationCount + 1
        self.lastProgressReason = "shown"
    else
        self.progressSkippedCount = self.progressSkippedCount + 1
        self.lastProgressReason = state or "presentation-unavailable"
    end
    self.lastProgressSecret = false
end

-- P0242: narrative only for a naturally observed completion context.
-- Reward identity/choice/claim remain entirely Blizzard-owned.
function Dialogue:ReadCompletion()
    if type(GetQuestID) ~= "function"
        or type(GetTitleText) ~= "function"
        or type(GetRewardText) ~= "function"
    then
        return nil, "completion-api-unavailable", false
    end

    local questID, idError, idSecret = readQuestID()
    if idError then return nil, idError, idSecret end
    if questID == nil or questID <= 0
        or questID ~= questID or questID == math.huge
    then
        return nil, "completion-id-unavailable", false
    end

    local title, titleError, titleSecret = readString("completion-title", GetTitleText)
    if titleError then return nil, titleError, titleSecret end
    if title == "" then return nil, "completion-title-empty", false end

    local body, bodyError, bodySecret = readString("completion-text", GetRewardText)
    if bodyError then return nil, bodyError, bodySecret end
    if body == "" then return nil, "completion-text-empty", false end

    return { questID = questID, title = title, body = body }, nil, false
end

-- P0243: bounded ordinary reward labels only. Never infer a missing item or choice.
local function ordinaryRewardNumber(label, fn)
    if type(fn) ~= "function" then
        return nil, label .. "-api-unavailable"
    end
    local ok, value = pcall(fn)
    if not ok then return nil, label .. "-read-failed" end
    if isSecret(value) then return nil, label .. "-secret" end
    if type(value) ~= "number" or value ~= value or value == math.huge
        or value < 0 or value > 100000000
    then
        return nil, label .. "-invalid"
    end
    return math.floor(value), nil
end

function Dialogue:ReadCompletionRewardSummary()
    -- A small, supplemental summary; no choice selection or claim actions.
    local xp, xpReason = ordinaryRewardNumber("reward-xp", GetRewardXP)
    local choices, choiceReason = ordinaryRewardNumber("reward-choices", GetNumQuestChoices)
    local rewards, countReason = ordinaryRewardNumber("reward-count", GetNumQuestRewards)
    local itemText = nil
    local reason = "complete-reward-source"

    if choices == nil or rewards == nil then
        reason = choiceReason or countReason or "reward-source-unavailable"
    elseif choices > 0 then
        reason = "choice-uses-blizzard"
    elseif rewards == 1 then
        if type(GetQuestItemInfo) == "function" then
            local ok, name, _, quantity = pcall(GetQuestItemInfo, "reward", 1)
            if ok and not isSecret(name) and not isSecret(quantity)
                and type(name) == "string" and name ~= ""
                and type(quantity) == "number" and quantity == quantity
                and quantity >= 1 and quantity <= 9999
            then
                itemText = name .. " x" .. tostring(math.floor(quantity))
                reason = "guaranteed-item-ordinary"
            else
                reason = "guaranteed-item-unavailable"
            end
        else
            reason = "item-api-unavailable"
        end
    elseif rewards > 1 then
        reason = "multiple-rewards-use-blizzard"
    elseif rewards == 0 then
        reason = "xp-only-or-no-items"
    end

    local label = itemText or "Review rewards in Blizzard quest window"
    if xp ~= nil and xp > 0 then
        -- Two brief rows within the already-owned 50px narrative footer.
        label = label .. " | " .. tostring(xp) .. " XP"
    elseif xpReason then
        reason = reason .. "/" .. xpReason
    end
    return label .. "\nComplete using Blizzard quest controls", reason,
        itemText ~= nil
end

function Dialogue:HandleQuestComplete()
    self.completeEventCount = self.completeEventCount + 1
    self:ClearActiveDetail("QUEST_COMPLETE")
    local completion, reason, secret = self:ReadCompletion()
    if not completion then
        self.completionSkippedCount = self.completionSkippedCount + 1
        self.lastCompletionReason = reason or "completion-unavailable"
        self.lastCompletionSecret = secret == true
        return
    end

    self.lastQuestID = completion.questID
    self.lastHadBody = true
    self.lastHadObjective = false
    self.lastReason = "QUEST_COMPLETE"
    self.lastSecret = false
    self.lastError = nil
    if not self.immersionEnabled then
        self.suppressedCount = self.suppressedCount + 1
        self.lastCompletionReason = "immersion-off"
        return
    end

    local rewardSummary, rewardReason, rewardIdentified =
        self:ReadCompletionRewardSummary()
    self.lastCompletionRewardReason = rewardReason
    self.lastCompletionRewardIdentified = rewardIdentified == true
    local shown, state = self:PresentText(
        completion.title, completion.body, rewardSummary, "QUEST_COMPLETE",
        false, false, false
    )
    if shown and state == "shown" then
        self.completionActive = true
        self.completionShownCount = self.completionShownCount + 1
        self.presentationCount = self.presentationCount + 1
        self.lastCompletionReason = "shown"
    else
        self.completionSkippedCount = self.completionSkippedCount + 1
        self.lastCompletionReason = state or "presentation-unavailable"
    end
    self.lastCompletionSecret = false
end

function Dialogue:UpdatePageControls()
    local pageCount = #self.pages
    local current = self.currentPage

    if pageCount <= 1 then
        self.pageIndicator:Hide()
        self.previousButton:Hide()
        self.nextButton:Hide()
        return
    end

    self.pageIndicator:SetFormattedText(
        "%d / %d",
        current,
        pageCount
    )
    self.pageIndicator:Show()

    local activeColor =
        colorValue("pageActive")
    local inactiveColor =
        colorValue("pageInactive")

    if current > 1 then
        self.previousTexture:SetVertexColor(
            activeColor[1],
            activeColor[2],
            activeColor[3],
            activeColor[4]
        )
        self.previousButton:Show()
    else
        self.previousTexture:SetVertexColor(
            inactiveColor[1],
            inactiveColor[2],
            inactiveColor[3],
            inactiveColor[4]
        )
        self.previousButton:Hide()
    end

    if current < pageCount then
        self.nextTexture:SetVertexColor(
            activeColor[1],
            activeColor[2],
            activeColor[3],
            activeColor[4]
        )
        self.nextButton:Show()
    else
        self.nextTexture:SetVertexColor(
            inactiveColor[1],
            inactiveColor[2],
            inactiveColor[3],
            inactiveColor[4]
        )
        self.nextButton:Hide()
    end
end

function Dialogue:SetPage(index)
    if type(index) ~= "number" then
        return false, "page-invalid"
    end

    local pageCount = #self.pages

    if pageCount == 0 then
        return false, "page-empty"
    end

    if index < 1 then
        index = 1
    elseif index > pageCount then
        index = pageCount
    end

    self.currentPage = index
    self.lastCurrentPage = index
    self.bodyText:SetText(
        self.pages[index] or ""
    )
    self:UpdatePageControls()
    self:UpdateOfferControls()

    return true, "page-shown"
end

function Dialogue:PreviousPage()
    return self:SetPage(
        self.currentPage - 1
    )
end

function Dialogue:NextPage()
    return self:SetPage(
        self.currentPage + 1
    )
end

function Dialogue:PresentText(
    title,
    body,
    objective,
    reason,
    autoHide,
    showOfferActions,
    previewMode
)
    if not self.moduleEnabled then
        self:HidePresentation("module-disabled")
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return true, "suppressed-immersion-off"
    end

    if autoHide and not self.timerAvailable then
        self:HidePresentation("timer-unavailable")
        return false, "timer-unavailable"
    end

    self.presentationGeneration =
        self.presentationGeneration + 1
    local generation =
        self.presentationGeneration

    self.pages = buildPages(body)
    self.progressActive = false
    self.completionActive = false
    self.currentPage = 1
    self.offerActionsEnabled =
        showOfferActions == true
    self.offerActionPreview =
        previewMode == true
    self.offerActionPending = false
    self.lastOfferActionError = nil
    self:SetOfferActionFeedback(nil)

    self.titleText:SetText(title)

    if objective ~= "" then
        if reason == "QUEST_COMPLETE" then
            self.objectiveHeader:SetText("REWARDS")
        else
            self.objectiveHeader:SetText("OBJECTIVE")
        end
        self.objectiveHeader:Show()
        self.objectiveText:SetText(objective)
        self.objectiveText:Show()
    else
        self.objectiveHeader:Hide()
        self.objectiveText:ClearText()
        self.objectiveText:Hide()
    end

    self:SetPage(1)

    self.root:Show()
    self.presentationShown = true
    self.lastPresentationReason =
        reason or "presentation"
    self.lastPageCount = #self.pages
    self.lastCurrentPage = self.currentPage
    self:UpdateOfferControls()

    if autoHide then
        C_Timer.After(PREVIEW_SECONDS, function()
            if not self.moduleEnabled then
                return
            end

            if self.presentationGeneration ~= generation then
                return
            end

            self.presentationShown = false
            self.root:Hide()
            self.lastPresentationReason =
                "preview-timeout"
        end)
    end

    return true, "shown"
end

function Dialogue:HandleQuestDetail()
    self.detailEventCount =
        self.detailEventCount + 1

    local detail, errorText, secretObserved =
        self:ReadDetail()

    if not detail then
        self:ClearFailure(
            "QUEST_DETAIL",
            errorText,
            secretObserved
        )
        return
    end

    self.activeDetail = detail

    self.lastQuestID = detail.questID
    self.lastHadBody = detail.body ~= ""
    self.lastHadObjective =
        detail.objective ~= ""
    self.lastSecret = false
    self.lastError = nil
    self.lastReason = "QUEST_DETAIL"

    if not self.immersionEnabled then
        self.suppressedCount =
            self.suppressedCount + 1
        self:HidePresentation(
            "quest-detail-immersion-off"
        )
        return
    end

    self.presentationCount =
        self.presentationCount + 1

    self:PresentText(
        detail.title,
        detail.body,
        detail.objective,
        "QUEST_DETAIL",
        false,
        true,
        false
    )
end

function Dialogue:ApplyPreferences(preferences)
    local wasImmersionEnabled =
        self.immersionEnabled == true

    self.immersionEnabled =
        preferences.immersionEnabled == true

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return
    end

    if not wasImmersionEnabled
        and self.activeDetail ~= nil
    then
        local detail = self.activeDetail

        self.restoreCount =
            self.restoreCount + 1
        self.presentationCount =
            self.presentationCount + 1

        self:PresentText(
            detail.title,
            detail.body,
            detail.objective,
            "immersion-on-restore",
            false,
            true,
            false
        )
    end
end

function Dialogue:ShowPreview()
    if not self.moduleEnabled then
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return true,
            "suppressed-immersion-off"
    end

    self.previewCount =
        self.previewCount + 1

    return self:PresentText(
        "The Lost Standard",
        "The road from the old watchtower has grown quiet. Travelers who once crossed the ridge at dusk now turn back before the first milestone. A patrol found signs of a struggle near the ruined wall, but no one returned with the standard that marked the northern post.\n\nThe captain asks that you follow the broken road, search the stones beyond the ridge, and recover what remains of the watch. If the raiders still hold the pass, drive them out before returning to town.\n\nThere may be more to the silence than simple banditry. Keep your eyes on the valley as you climb.",
        "Recover the lost standard beyond the northern ridge and return it to the captain.",
        "preview",
        true,
        true,
        true
    )
end

function Dialogue:GetDebugStatus()
    return {
        moduleEnabled =
            self.moduleEnabled == true,
        rootReady = self.root ~= nil,
        titleReady =
            self.titleText ~= nil,
        bodyReady =
            self.bodyText ~= nil,
        objectiveReady =
            self.objectiveText ~= nil,
        pageControlsReady =
            self.pageIndicator ~= nil
            and self.previousButton ~= nil
            and self.nextButton ~= nil,
        eventFrameReady =
            self.eventFrame ~= nil,
        timerAvailable =
            self.timerAvailable == true,
        apiAvailable =
            self.apiAvailable == true,
        immersionEnabled =
            self.immersionEnabled == true,

        questDetailRegistered =
            self.eventRegistration.QUEST_DETAIL == true,
        questAcceptedRegistered =
            self.eventRegistration.QUEST_ACCEPTED == true,
        questFinishedRegistered =
            self.eventRegistration.QUEST_FINISHED == true,
        worldRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,
        progressRegistered = self.eventRegistration.QUEST_PROGRESS == true,
        completeRegistered = self.eventRegistration.QUEST_COMPLETE == true,
        gossipClosedRegistered = self.eventRegistration.GOSSIP_CLOSED == true,
        progressEventCount = self.progressEventCount,
        progressShownCount = self.progressShownCount,
        progressSkippedCount = self.progressSkippedCount,
        completeEventCount = self.completeEventCount,
        completionShownCount = self.completionShownCount,
        completionSkippedCount = self.completionSkippedCount,
        completionActive = self.completionActive == true,
        lastCompletionRewardReason = self.lastCompletionRewardReason,
        lastCompletionRewardIdentified = self.lastCompletionRewardIdentified == true,
        lastCompletionReason = self.lastCompletionReason,
        lastCompletionSecret = self.lastCompletionSecret == true,
        progressActive = self.progressActive == true,
        lastProgressReason = self.lastProgressReason,
        lastProgressSecret = self.lastProgressSecret == true,

        detailEventCount =
            self.detailEventCount,
        acceptedEventCount =
            self.acceptedEventCount,
        finishedEventCount =
            self.finishedEventCount,
        worldEventCount =
            self.worldEventCount,

        presentationCount =
            self.presentationCount,
        suppressedCount =
            self.suppressedCount,
        previewCount =
            self.previewCount,
        restoreCount =
            self.restoreCount,
        activeDetailCached =
            self.activeDetail ~= nil,
        presentationShown =
            self.presentationShown == true,

        offerControlsReady =
            self.offerActionRoot ~= nil
            and self.declineButton ~= nil
            and self.acceptButton ~= nil
            and self.offerActionFeedback ~= nil,
        offerControlsShown =
            self.offerActionRoot ~= nil
            and self.offerActionRoot:IsVisible()
            or false,
        offerActionsEnabled =
            self.offerActionsEnabled == true,
        offerControlsFinalPage =
            self.offerControlsFinalPage == true,
        offerActionPreview =
            self.offerActionPreview == true,
        offerActionPending =
            self.offerActionPending == true,
        offerActionClickCount =
            self.offerActionClickCount,
        lastOfferActionKind =
            self.lastOfferActionKind,
        lastOfferActionResult =
            self.lastOfferActionResult,
        lastOfferActionError =
            self.lastOfferActionError,
        stockOfferSuppressionApplied =
            self.stockOfferSuppressionApplied == true,
        lastStockOfferSuppressionResult =
            self.lastStockOfferSuppressionResult,

        pageCount = #self.pages,
        currentPage = self.currentPage,
        lastPageCount = self.lastPageCount,
        lastCurrentPage =
            self.lastCurrentPage,

        lastQuestID = self.lastQuestID,
        lastHadBody =
            self.lastHadBody == true,
        lastHadObjective =
            self.lastHadObjective == true,
        lastSecret =
            self.lastSecret == true,
        lastReason = self.lastReason,
        lastPresentationReason =
            self.lastPresentationReason,
        lastError = self.lastError,
    }
end

function Dialogue:OnInitialize()
    self.moduleEnabled = false
    self.immersionEnabled = false

    self.apiAvailable =
        type(GetQuestID) == "function"
        and type(GetTitleText) == "function"
        and type(GetQuestText) == "function"
        and type(GetObjectiveText) == "function"

    self.timerAvailable =
        C_Timer ~= nil
        and type(C_Timer.After) == "function"

    self.detailEventCount = 0
    self.progressEventCount = 0
    self.progressShownCount = 0
    self.progressSkippedCount = 0
    self.completeEventCount = 0
    self.completionShownCount = 0
    self.completionSkippedCount = 0
    self.completionActive = false
    self.lastCompletionReason = "not-observed"
    self.lastCompletionRewardReason = "not-observed"
    self.lastCompletionRewardIdentified = false
    self.lastCompletionSecret = false
    self.progressActive = false
    self.lastProgressReason = "not-observed"
    self.lastProgressSecret = false
    self.acceptedEventCount = 0
    self.finishedEventCount = 0
    self.worldEventCount = 0

    self.presentationCount = 0
    self.suppressedCount = 0
    self.previewCount = 0
    self.restoreCount = 0
    self.presentationGeneration = 0
    self.presentationShown = false

    self.offerActionsEnabled = false
    self.offerActionPreview = false
    self.offerActionPending = false
    self.offerControlsFinalPage = false
    self.offerActionClickCount = 0
    self.lastOfferActionKind = nil
    self.lastOfferActionResult = "initialize"
    self.lastOfferActionError = nil
    self.stockOfferSuppressionApplied = false
    self.lastStockOfferSuppressionResult = "initialize"

    self.pages = {}
    self.currentPage = 0
    self.lastPageCount = 0
    self.lastCurrentPage = 0

    self.activeDetail = nil
    self.lastQuestID = nil
    self.lastHadBody = false
    self.lastHadObjective = false
    self.lastSecret = false
    self.lastReason = "initialize"
    self.lastPresentationReason =
        "initialize"
    self.lastError = nil

    local root = CreateFrame(
        "Frame",
        "LogresQuestDialogue",
        UIParent
    )
    root:SetSize(
        styleValue("width"),
        styleValue("height")
    )
    root:SetPoint(
        "TOP",
        UIParent,
        "TOP",
        styleValue("x"),
        styleValue("y")
    )
    Logres.Layout.Bind(root, "questDialogue", "TOP", "TOP")
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()

    local panel =
        root:CreateTexture(
            nil,
            "BACKGROUND"
        )
    panel:SetAllPoints(root)
    panel:SetTexture(
        dialogueAssets.panel
        or "Interface\\Buttons\\WHITE8x8"
    )

    local titleText = root:CreateFontString(
        "LogresQuestDialogueTitle",
        "OVERLAY",
        styleValue("titleFont")
    )
    titleText:SetPoint(
        "TOP",
        root,
        "TOP",
        0,
        -18
    )
    titleText:SetSize(
        styleValue("titleWidth"),
        30
    )
    titleText:SetJustifyH("CENTER")
    titleText:SetJustifyV("TOP")
    titleText:SetShadowColor(
        0,
        0,
        0,
        0.90
    )
    titleText:SetShadowOffset(1, -1)
    setFontColor(
        titleText,
        colorValue("title")
    )

    local divider =
        root:CreateTexture(
            nil,
            "ARTWORK"
        )
    divider:SetSize(
        styleValue("width") - 72,
        18
    )
    divider:SetPoint(
        "TOP",
        root,
        "TOP",
        0,
        -48
    )
    divider:SetTexture(
        dialogueAssets.divider
        or "Interface\\Buttons\\WHITE8x8"
    )

    local bodyText = root:CreateFontString(
        "LogresQuestDialogueBody",
        "OVERLAY",
        styleValue("bodyFont")
    )
    bodyText:SetPoint(
        "TOP",
        root,
        "TOP",
        0,
        -67
    )
    bodyText:SetSize(
        styleValue("bodyWidth"),
        styleValue("bodyHeight")
    )
    bodyText:SetJustifyH("LEFT")
    bodyText:SetJustifyV("TOP")
    bodyText:SetWordWrap(true)
    bodyText:SetShadowColor(
        0,
        0,
        0,
        0.88
    )
    bodyText:SetShadowOffset(1, -1)
    setFontColor(
        bodyText,
        colorValue("body")
    )

    local objectiveHeader =
        root:CreateFontString(
            nil,
            "OVERLAY",
            styleValue(
                "objectiveHeaderFont"
            )
        )
    objectiveHeader:SetPoint(
        "TOPLEFT",
        root,
        "TOPLEFT",
        46,
        -214
    )
    objectiveHeader:SetText("OBJECTIVE")
    objectiveHeader:SetJustifyH("LEFT")
    setFontColor(
        objectiveHeader,
        colorValue("objectiveHeader")
    )

    local objectiveText =
        root:CreateFontString(
            "LogresQuestDialogueObjective",
            "OVERLAY",
            styleValue("objectiveFont")
        )
    objectiveText:SetPoint(
        "TOP",
        root,
        "TOP",
        0,
        -233
    )
    objectiveText:SetSize(
        styleValue("objectiveWidth"),
        styleValue("objectiveHeight")
    )
    objectiveText:SetJustifyH("LEFT")
    objectiveText:SetJustifyV("TOP")
    objectiveText:SetWordWrap(true)
    objectiveText:SetShadowColor(
        0,
        0,
        0,
        0.88
    )
    objectiveText:SetShadowOffset(1, -1)
    setFontColor(
        objectiveText,
        colorValue("objective")
    )

    local pageIndicator =
        root:CreateFontString(
            nil,
            "OVERLAY",
            styleValue("pageFont")
        )
    pageIndicator:SetPoint(
        "BOTTOM",
        root,
        "BOTTOM",
        0,
        17
    )
    pageIndicator:SetWidth(90)
    pageIndicator:SetJustifyH("CENTER")
    setFontColor(
        pageIndicator,
        colorValue("page")
    )
    pageIndicator:Hide()

    local previousButton =
        CreateFrame(
            "Button",
            nil,
            root
        )
    previousButton:SetSize(28, 28)
    previousButton:SetPoint(
        "RIGHT",
        pageIndicator,
        "LEFT",
        -10,
        0
    )
    previousButton:Hide()

    local previousTexture =
        previousButton:CreateTexture(
            nil,
            "ARTWORK"
        )
    previousTexture:SetAllPoints(
        previousButton
    )
    previousTexture:SetTexture(
        dialogueAssets.pageChevron
        or "Interface\\Buttons\\WHITE8x8"
    )
    previousTexture:SetTexCoord(
        1,
        0,
        0,
        1
    )

    previousButton:SetScript(
        "OnClick",
        function()
            self:PreviousPage()
        end
    )

    local nextButton =
        CreateFrame(
            "Button",
            nil,
            root
        )
    nextButton:SetSize(28, 28)
    nextButton:SetPoint(
        "LEFT",
        pageIndicator,
        "RIGHT",
        10,
        0
    )
    nextButton:Hide()

    local nextTexture =
        nextButton:CreateTexture(
            nil,
            "ARTWORK"
        )
    nextTexture:SetAllPoints(nextButton)
    nextTexture:SetTexture(
        dialogueAssets.pageChevron
        or "Interface\\Buttons\\WHITE8x8"
    )

    nextButton:SetScript(
        "OnClick",
        function()
            self:NextPage()
        end
    )

    local offerActionRoot =
        CreateFrame(
            "Frame",
            nil,
            root
        )
    offerActionRoot:SetSize(
        offerStyleValue("width"),
        offerStyleValue("height")
    )
    offerActionRoot:SetPoint(
        "TOP",
        root,
        "BOTTOM",
        0,
        offerStyleValue("y")
    )
    offerActionRoot:EnableMouse(false)
    offerActionRoot:Hide()

    local declineButton =
        createOfferButton(
            self,
            offerActionRoot,
            "decline",
            "Decline"
        )
    declineButton:SetPoint(
        "CENTER",
        offerActionRoot,
        "CENTER",
        (
            offerStyleValue("buttonWidth")
            + offerStyleValue("buttonGap")
        ) / 2,
        9
    )

    local acceptButton =
        createOfferButton(
            self,
            offerActionRoot,
            "accept",
            "Accept"
        )
    acceptButton:SetPoint(
        "CENTER",
        offerActionRoot,
        "CENTER",
        -(
            offerStyleValue("buttonWidth")
            + offerStyleValue("buttonGap")
        ) / 2,
        9
    )

    local offerActionFeedback =
        offerActionRoot:CreateFontString(
            nil,
            "OVERLAY",
            offerStyleValue("feedbackFont")
        )
    offerActionFeedback:SetPoint(
        "BOTTOM",
        offerActionRoot,
        "BOTTOM",
        0,
        0
    )
    offerActionFeedback:SetWidth(
        offerStyleValue("width")
    )
    offerActionFeedback:SetJustifyH("CENTER")
    setFontColor(
        offerActionFeedback,
        offerColor("feedback")
    )
    offerActionFeedback:Hide()

    self.root = root
    self.panel = panel
    self.titleText = titleText
    self.divider = divider
    self.bodyText = bodyText
    self.objectiveHeader =
        objectiveHeader
    self.objectiveText =
        objectiveText
    self.pageIndicator =
        pageIndicator
    self.previousButton =
        previousButton
    self.previousTexture =
        previousTexture
    self.nextButton = nextButton
    self.nextTexture = nextTexture
    self.offerActionRoot = offerActionRoot
    self.declineButton = declineButton
    self.acceptButton = acceptButton
    self.offerActionFeedback =
        offerActionFeedback

    local eventFrame = CreateFrame("Frame")
    local events = {
        "QUEST_DETAIL",
        "QUEST_PROGRESS",
        "QUEST_COMPLETE",
        "GOSSIP_CLOSED",
        "QUEST_ACCEPTED",
        "QUEST_FINISHED",
        "PLAYER_ENTERING_WORLD",
    }

    self.eventRegistration = {}

    for index = 1, #events do
        local event = events[index]
        local ok = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )

        self.eventRegistration[event] =
            ok and true or false
    end

    eventFrame:SetScript(
        "OnEvent",
        function(_, event)
            if not self.moduleEnabled then
                return
            end

            if event == "QUEST_DETAIL" then
                self:HandleQuestDetail()
                return
            end

            if event == "QUEST_PROGRESS" then
                self:HandleQuestProgress()
                return
            end

            if event == "QUEST_COMPLETE" then
                self:HandleQuestComplete()
                return
            end

            if event == "GOSSIP_CLOSED" then
                if self.progressActive or self.completionActive then
                    self:ClearActiveDetail("GOSSIP_CLOSED")
                end
                return
            end

            if event == "QUEST_ACCEPTED" then
                self.acceptedEventCount =
                    self.acceptedEventCount + 1
                self:ClearActiveDetail(
                    "QUEST_ACCEPTED"
                )
                return
            end

            if event == "QUEST_FINISHED" then
                self.finishedEventCount =
                    self.finishedEventCount + 1
                self:ClearActiveDetail(
                    "QUEST_FINISHED"
                )
                return
            end

            if event ==
                "PLAYER_ENTERING_WORLD"
            then
                self.worldEventCount =
                    self.worldEventCount + 1
                self:ClearActiveDetail(
                    "PLAYER_ENTERING_WORLD"
                )
            end
        end
    )

    self.eventFrame = eventFrame
end

function Dialogue:OnEnable()
    self.moduleEnabled = true

    self:SubscribePreferences(function(preferences)
        self:ApplyPreferences(preferences)
    end)

    self:ApplyPreferences(
        Logres:GetPreferences()
    )
end

function Dialogue:OnDisable()
    self.moduleEnabled = false
    self:ClearActiveDetail(
        "module-disabled"
    )
end
