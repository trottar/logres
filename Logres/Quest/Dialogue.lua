local _, Logres = ...

local DISPLAY_SECONDS = 10.0
local BODY_LIMIT = 420
local OBJECTIVE_LIMIT = 180

local Dialogue = Logres:RegisterModule("QuestDialogue", {
    autoEnable = true,
})

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function trimText(value, limit)
    if #value <= limit then
        return value
    end

    return value:sub(1, limit - 3) .. "..."
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

function Dialogue:HidePresentation(reason)
    self.presentationGeneration =
        self.presentationGeneration + 1
    self.presentationShown = false

    if self.root then
        self.root:Hide()
    end

    if reason then
        self.lastPresentationReason = reason
    end
end

function Dialogue:ClearFailure(reason, errorText, secretObserved)
    self.lastReason = reason
    self.lastError = errorText
    self.lastSecret = secretObserved and true or false
    self:HidePresentation(reason)
end

function Dialogue:ReadDetail()
    self.apiAvailable =
        type(GetQuestID) == "function"
        and type(GetTitleText) == "function"
        and type(GetQuestText) == "function"
        and type(GetObjectiveText) == "function"

    if not self.apiAvailable then
        return nil, "quest-detail-api-unavailable", false
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
        readString("objective", GetObjectiveText)

    if objectiveError then
        return nil, objectiveError, objectiveSecret
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

function Dialogue:PresentText(title, body, objective, reason)
    if not self.moduleEnabled then
        self:HidePresentation("module-disabled")
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return true, "suppressed-immersion-off"
    end

    if not self.timerAvailable then
        self:HidePresentation("timer-unavailable")
        return false, "timer-unavailable"
    end

    self.presentationGeneration =
        self.presentationGeneration + 1
    local generation = self.presentationGeneration

    self.titleText:SetText(title)
    self.bodyText:SetText(body)
    self.objectiveText:SetText(objective)

    self.root:Show()
    self.presentationShown = true
    self.lastPresentationReason = reason or "presentation"

    C_Timer.After(DISPLAY_SECONDS, function()
        if not self.moduleEnabled then
            return
        end

        if self.presentationGeneration ~= generation then
            return
        end

        self.presentationShown = false
        self.root:Hide()
        self.lastPresentationReason = "timeout"
    end)

    return true, "shown"
end

function Dialogue:HandleQuestDetail()
    self.detailEventCount = self.detailEventCount + 1

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

    self.lastQuestID = detail.questID
    self.lastHadBody = detail.body ~= ""
    self.lastHadObjective = detail.objective ~= ""
    self.lastSecret = false
    self.lastError = nil
    self.lastReason = "QUEST_DETAIL"

    local body =
        trimText(detail.body, BODY_LIMIT)
    local objective =
        trimText(detail.objective, OBJECTIVE_LIMIT)

    if objective ~= "" then
        objective = "Objective: " .. objective
    end

    if not self.immersionEnabled then
        self.suppressedCount = self.suppressedCount + 1
        self:HidePresentation("quest-detail-immersion-off")
        return
    end

    self.presentationCount =
        self.presentationCount + 1

    self:PresentText(
        detail.title,
        body,
        objective,
        "QUEST_DETAIL"
    )
end

function Dialogue:ApplyPreferences(preferences)
    self.immersionEnabled =
        preferences.immersionEnabled == true

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
    end
end

function Dialogue:ShowPreview()
    if not self.moduleEnabled then
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return true, "suppressed-immersion-off"
    end

    self.previewCount = self.previewCount + 1

    return self:PresentText(
        "A Quiet Request",
        "The road ahead is uncertain. Listen carefully, then decide how you wish to proceed.",
        "Objective: Speak with the traveler beyond the ridge.",
        "preview"
    )
end

function Dialogue:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.root ~= nil,
        titleReady = self.titleText ~= nil,
        bodyReady = self.bodyText ~= nil,
        objectiveReady = self.objectiveText ~= nil,
        eventFrameReady = self.eventFrame ~= nil,
        timerAvailable = self.timerAvailable == true,
        apiAvailable = self.apiAvailable == true,
        immersionEnabled = self.immersionEnabled == true,

        questDetailRegistered =
            self.eventRegistration.QUEST_DETAIL == true,
        questAcceptedRegistered =
            self.eventRegistration.QUEST_ACCEPTED == true,
        questFinishedRegistered =
            self.eventRegistration.QUEST_FINISHED == true,
        worldRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,

        detailEventCount = self.detailEventCount,
        acceptedEventCount = self.acceptedEventCount,
        finishedEventCount = self.finishedEventCount,
        worldEventCount = self.worldEventCount,

        presentationCount = self.presentationCount,
        suppressedCount = self.suppressedCount,
        previewCount = self.previewCount,
        presentationShown = self.presentationShown == true,

        lastQuestID = self.lastQuestID,
        lastHadBody = self.lastHadBody == true,
        lastHadObjective = self.lastHadObjective == true,
        lastSecret = self.lastSecret == true,
        lastReason = self.lastReason,
        lastPresentationReason = self.lastPresentationReason,
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
    self.acceptedEventCount = 0
    self.finishedEventCount = 0
    self.worldEventCount = 0

    self.presentationCount = 0
    self.suppressedCount = 0
    self.previewCount = 0
    self.presentationGeneration = 0
    self.presentationShown = false

    self.lastQuestID = nil
    self.lastHadBody = false
    self.lastHadObjective = false
    self.lastSecret = false
    self.lastReason = "initialize"
    self.lastPresentationReason = "initialize"
    self.lastError = nil

    local root = CreateFrame(
        "Frame",
        "LogresQuestDialogue",
        UIParent
    )
    root:SetSize(560, 220)
    root:SetPoint(
        "TOP",
        UIParent,
        "TOP",
        0,
        -125
    )
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()

    local titleText = root:CreateFontString(
        "LogresQuestDialogueTitle",
        "OVERLAY",
        "GameFontHighlightLarge"
    )
    titleText:SetPoint("TOP", root, "TOP", 0, 0)
    titleText:SetSize(540, 28)
    titleText:SetJustifyH("CENTER")
    titleText:SetJustifyV("TOP")
    titleText:SetTextColor(0.92, 0.78, 0.46, 0.98)
    titleText:SetShadowColor(0, 0, 0, 0.90)
    titleText:SetShadowOffset(1, -1)

    local bodyText = root:CreateFontString(
        "LogresQuestDialogueBody",
        "OVERLAY",
        "GameFontHighlight"
    )
    bodyText:SetPoint("TOP", root, "TOP", 0, -38)
    bodyText:SetSize(520, 118)
    bodyText:SetJustifyH("CENTER")
    bodyText:SetJustifyV("TOP")
    bodyText:SetTextColor(0.94, 0.92, 0.86, 0.96)
    bodyText:SetShadowColor(0, 0, 0, 0.90)
    bodyText:SetShadowOffset(1, -1)

    local objectiveText = root:CreateFontString(
        "LogresQuestDialogueObjective",
        "OVERLAY",
        "GameFontNormal"
    )
    objectiveText:SetPoint("TOP", root, "TOP", 0, -165)
    objectiveText:SetSize(520, 44)
    objectiveText:SetJustifyH("CENTER")
    objectiveText:SetJustifyV("TOP")
    objectiveText:SetTextColor(0.82, 0.72, 0.50, 0.94)
    objectiveText:SetShadowColor(0, 0, 0, 0.90)
    objectiveText:SetShadowOffset(1, -1)

    self.root = root
    self.titleText = titleText
    self.bodyText = bodyText
    self.objectiveText = objectiveText

    local eventFrame = CreateFrame("Frame")
    local events = {
        "QUEST_DETAIL",
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

    eventFrame:SetScript("OnEvent", function(_, event)
        if not self.moduleEnabled then
            return
        end

        if event == "QUEST_DETAIL" then
            self:HandleQuestDetail()
            return
        end

        if event == "QUEST_ACCEPTED" then
            self.acceptedEventCount =
                self.acceptedEventCount + 1
            self:HidePresentation("QUEST_ACCEPTED")
            return
        end

        if event == "QUEST_FINISHED" then
            self.finishedEventCount =
                self.finishedEventCount + 1
            self:HidePresentation("QUEST_FINISHED")
            return
        end

        if event == "PLAYER_ENTERING_WORLD" then
            self.worldEventCount =
                self.worldEventCount + 1
            self:HidePresentation("PLAYER_ENTERING_WORLD")
        end
    end)

    self.eventFrame = eventFrame
end

function Dialogue:OnEnable()
    self.moduleEnabled = true

    self:SubscribePreferences(function(preferences)
        self:ApplyPreferences(preferences)
    end)

    self:ApplyPreferences(Logres:GetPreferences())
end

function Dialogue:OnDisable()
    self.moduleEnabled = false
    self:HidePresentation("module-disabled")
end
