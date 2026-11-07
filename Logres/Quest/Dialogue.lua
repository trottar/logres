local _, Logres = ...

local PREVIEW_SECONDS = 30.0
local MAX_REWARD_CARDS = 6
local PAGE_CHAR_LIMIT = 420

local Dialogue = Logres:RegisterModule("QuestDialogue", {
    autoEnable = true,
})

local theme = Logres.Theme or {}
local panelConfig = Logres.PanelConfigs.quest
local dialogueStyle = panelConfig.presentation
local dialogueAssets = dialogueStyle.assets or {}
local dialogueColors = dialogueStyle.colors or {}

local offerStyle = theme.questOfferControls or {}
local offerAssets = offerStyle.assets or {}
local offerColors = offerStyle.colors or {}

-- Production style values come from editable parameter / theme files.
local DEFAULT_STYLE = panelConfig.presentation
local DEFAULT_COLORS = Logres.Theme.panelSurface.colors
local DEFAULT_OFFER_STYLE = theme.questOfferControls
local DEFAULT_OFFER_COLORS = theme.questOfferControls.colors

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

local function buildPages(text)
    return Logres.NPCNarrativePages.Build(text, PAGE_CHAR_LIMIT)
end

local function setFontColor(fontString, color)
    fontString:SetTextColor(
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
    local button = Logres.NPCDecisionVisual.CreateButton(
        parent, kind, label, offerStyleValue, offerColor, offerAssets
    )
    button:SetScript("OnClick", function()
        owner:RecordCompletionInput("dispatch")
        -- Visual samples never dispatch to real quest offer or claim handlers,
        -- even when this exact button is reused for live completion.
        if owner.offerActionPreview then
            owner:HandleOfferAction(kind)
            return
        end
        -- Progress Continue is a separate native transition, never a reward claim.
        if kind == "accept" and owner.progressActive and owner.progressOwned then
            owner:HandleProgressContinue()
            return
        end
        -- The original Accept button also serves guarded completion.
        -- This is the exact same visual and input object, not a clone.
        if kind == "accept" and owner.completionActive
            and owner.completionFallbackActive then
            owner:HandleCompletionFallback()
        elseif kind == "accept" and owner.completionActive
            and owner.completionControl
            and owner.completionControl.applied
        then
            owner:HandleCompletionAction()
        else
            owner:HandleOfferAction(kind)
        end
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
    -- Completion owns this same action root while its native stock snapshot
    -- is suppressed. Paging must never hide the guarded action.
    if self.completionControl and self.completionControl.applied then
        return
    end
    if self.progressOwned then return end
    if self.completionFallbackActive then return end
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
        -- P0255: the very same Accept/Decline action pair belongs within
        -- the Logres narrative panel, not floating below its border.
        self.root:SetHeight(391)
        self.offerActionRoot:ClearAllPoints()
        self.offerActionRoot:SetPoint(
            "TOP", self.root, "BOTTOM", 0,
            offerStyleValue("y") + offerStyleValue("height") + 2
        )
        -- Restore the original Accept position/label whenever an offer owns
        -- this frame; the existing factory supplies all visual styling.
        self.acceptButton.label:SetText("Accept")
        self.acceptButton:ClearAllPoints()
        self.acceptButton:SetPoint(
            "CENTER", self.offerActionRoot, "CENTER",
            -(offerStyleValue("buttonWidth") + offerStyleValue("buttonGap")) / 2,
            9
        )
        self.acceptButton:Show()
        self.declineButton:Show()
        self.offerActionRoot:EnableMouse(true)
        self.offerActionRoot:Show()
    else
        -- Retain the original, out-of-panel idle anchor for the next
        -- presentation; no stock or secure input is changed here.
        self.offerActionRoot:ClearAllPoints()
        self.offerActionRoot:SetPoint(
            "TOP", self.root, "BOTTOM", 0, offerStyleValue("y")
        )
        self.offerActionRoot:Hide()
        self.offerActionRoot:EnableMouse(false)
        if not self.completionActive then
            self.root:SetHeight(styleValue("height"))
        end
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
        local message = "Preview only"
        if self.lastPresentationReason == "reward-preview"
            and self.rewardPreviewChoiceCount > 0
        then
            if self.rewardPreviewSelected then
                message = "Choice " .. self.rewardPreviewSelected
                    .. " selected (preview only)"
            else
                message = "Select a reward first (preview only)"
            end
        end
        self:SetOfferActionFeedback(message)
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

    -- P0387: this ordinary identity belongs to the clicked offer, not the
    -- next offer Blizzard may open before QUEST_ACCEPTED is delivered.
    -- Set before native dispatch so synchronous events see the same token.
    self.pendingAcceptedOfferQuestID =
        kind == "accept" and detail.questID or nil
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

    self.pendingAcceptedOfferQuestID = nil
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


-- P0379: observe only this addon-owned button; do not re-route native claims.
local function readOwnedFrameValue(frame, method)
    if not frame or type(frame[method]) ~= "function"
        or type(issecretvalue) ~= "function" then return nil end
    local ok, value = pcall(frame[method], frame)
    if not ok then return nil end
    local classified, secret = pcall(issecretvalue, value)
    if not classified or secret ~= false then return nil end
    if type(value) == "boolean" or type(value) == "number" then
        return value
    end
    return nil
end

-- P0384: capture only the addon-owned button, label and user cursor.
-- The HUD screen map is not a runtime quest-button hitbox map. The saved
-- sample remains available to Report Bug after native completion closes UI.
local function captureCompletionInputMap(button, phase)
    if not button or not button.label then return nil end
    local report = { phase = phase,
        buttonLeft = readOwnedFrameValue(button, "GetLeft"),
        buttonRight = readOwnedFrameValue(button, "GetRight"),
        buttonTop = readOwnedFrameValue(button, "GetTop"),
        buttonBottom = readOwnedFrameValue(button, "GetBottom"),
        labelLeft = readOwnedFrameValue(button.label, "GetLeft"),
        labelRight = readOwnedFrameValue(button.label, "GetRight"),
        labelTop = readOwnedFrameValue(button.label, "GetTop"),
        labelBottom = readOwnedFrameValue(button.label, "GetBottom"),
        scale = readOwnedFrameValue(button, "GetEffectiveScale"),
    }
    -- GetCursorPosition is a user-input API, not a Blizzard frame probe.
    -- Every potentially secret-capable result is classified BEFORE use.
    if type(GetCursorPosition) == "function"
        and type(issecretvalue) == "function" then
        local ok, rawX, rawY = pcall(GetCursorPosition)
        if ok then
            local checkedX, secretX = pcall(issecretvalue, rawX)
            local checkedY, secretY = pcall(issecretvalue, rawY)
            if checkedX and checkedY and secretX == false and secretY == false
                and type(rawX) == "number" and type(rawY) == "number"
                and rawX == rawX and rawY == rawY
                and math.abs(rawX) < 1000000 and math.abs(rawY) < 1000000
            then
                report.cursorPixelsX, report.cursorPixelsY = rawX, rawY
                if type(report.scale) == "number" and report.scale > 0 then
                    report.cursorX = rawX / report.scale
                    report.cursorY = rawY / report.scale
                end
            end
        end
    end
    return report
end

function Dialogue:RecordCompletionInput(phase)
    if not self.completionActive or self.offerActionPreview then return end
    local counters = self.completionInputCounters
    if not counters or counters[phase] == nil then return end
    counters[phase] = counters[phase] + 1
    self.lastCompletionInput = phase
    if phase == "enter" or phase == "down" then
        local map = captureCompletionInputMap(self.acceptButton, phase)
        if phase == "enter" then self.lastCompletionEnterMap = map
        else self.lastCompletionDownMap = map end
    end
    Logres:TraceEvent("quest", "completion-input-" .. phase,
        {reason = self.completionFallbackActive and "stock-fallback"
            or "logres-owned", result = "observed"})
end

function Dialogue:CompletionInputStatus()
    local counts = self.completionInputCounters or {}
    return {
        enterCount = counts.enter or 0,
        leaveCount = counts.leave or 0,
        downCount = counts.down or 0,
        upCount = counts.up or 0,
        dispatchCount = counts.dispatch or 0,
        lastInput = self.lastCompletionInput or "none",
        buttonShown = readOwnedFrameValue(self.acceptButton, "IsShown"),
        buttonVisible = readOwnedFrameValue(self.acceptButton, "IsVisible"),
        buttonMouseEnabled = readOwnedFrameValue(self.acceptButton, "IsMouseEnabled"),
        buttonLeft = readOwnedFrameValue(self.acceptButton, "GetLeft"),
        buttonRight = readOwnedFrameValue(self.acceptButton, "GetRight"),
        buttonTop = readOwnedFrameValue(self.acceptButton, "GetTop"),
        buttonBottom = readOwnedFrameValue(self.acceptButton, "GetBottom"),
        buttonLevel = readOwnedFrameValue(self.acceptButton, "GetFrameLevel"),
        actionRootShown = readOwnedFrameValue(self.completionActionRoot, "IsShown"),
        actionRootMouseEnabled = readOwnedFrameValue(self.completionActionRoot, "IsMouseEnabled"),
        -- These retained samples survive dismissal; no native frame reads.
        enterMap = self.lastCompletionEnterMap,
        downMap = self.lastCompletionDownMap,
    }
end

-- P0381: the quest progress stage is not the reward/claim stage.
-- Native QuestFrame is captured and restored with the existing stock adapter.
local function ordinaryProgress(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function nativeProgressFrame(name)
    local ok, frame = pcall(function() return _G[name] end)
    if not ok or not ordinaryProgress(frame) or not frame then return nil end
    return frame
end

local function nativeProgressFlag(frame, name)
    if not frame then return false end
    local found, method = pcall(function() return frame[name] end)
    if not found or not ordinaryProgress(method) or type(method) ~= "function" then
        return false
    end
    local ok, value = pcall(method, frame)
    return ok and ordinaryProgress(value) and value == true
end

function Dialogue:ProgressGate()
    if not self.moduleEnabled or not self.immersionEnabled
        or not self.progressActive or not self.presentationShown
        or self.lastPresentationReason ~= "QUEST_PROGRESS"
    then return false, "inactive-progress" end
    if not ordinaryProgress(C_Timer) or type(C_Timer) ~= "table"
        or not ordinaryProgress(C_Timer.After)
        or type(C_Timer.After) ~= "function" then
        return false, "native-transition-fallback-unavailable"
    end
    if type(InCombatLockdown) ~= "function" or type(GetQuestID) ~= "function"
        or type(IsQuestCompletable) ~= "function"
        or not ordinaryProgress(_G.QuestProgressCompleteButton_OnClick)
        or type(_G.QuestProgressCompleteButton_OnClick) ~= "function" then
        return false, "progress-api-unavailable"
    end
    local combatOK, combat = pcall(InCombatLockdown)
    if not combatOK or not ordinaryProgress(combat) or combat ~= false then
        return false, "combat-or-secret"
    end
    local idOK, questID = pcall(GetQuestID)
    if not idOK or not ordinaryProgress(questID) or type(questID) ~= "number"
        or questID <= 0 or questID ~= self.lastQuestID then
        return false, "progress-identity-changed"
    end
    local readyOK, ready = pcall(IsQuestCompletable)
    if not readyOK or not ordinaryProgress(ready) or ready ~= true then
        return false, "progress-not-completable"
    end
    if not nativeProgressFlag(nativeProgressFrame("QuestFrame"), "IsShown")
        or not nativeProgressFlag(nativeProgressFrame("QuestFrameProgressPanel"), "IsShown")
        or not nativeProgressFlag(nativeProgressFrame("QuestFrameCompleteButton"), "IsShown")
        or not nativeProgressFlag(nativeProgressFrame("QuestFrameCompleteButton"), "IsEnabled")
    then return false, "native-continue-not-usable" end
    return true, "progress-supported"
end

function Dialogue:RestoreProgressStock(reason)
    self.offerActionRoot:Hide()
    if not self.progressOwned then
        self.progressContinuePending = false
        return true, "stock-owned"
    end
    local module, snapshot = self.progressStockModule, self.progressStockSnapshot
    local ok = module and snapshot and pcall(
        module.RestoreOfferPresentation, module, snapshot)
    if not ok then
        local emergencyOK, emergencyResult = module and snapshot and pcall(
            module.EmergencyRestoreOfferPresentation, module, snapshot)
        ok = emergencyOK and emergencyResult == true
    end
    if not ok then
        Logres:TraceEvent("quest", "progress-restore-failed",
            {reason = reason or "unknown"})
        self:SetOfferActionFeedback("Native Continue unavailable. Try /reload.")
        return false, "progress-stock-restoration-failed"
    end
    self.progressOwned = false
    self.progressStockModule = nil
    self.progressStockSnapshot = nil
    self.progressContinuePending = false
    Logres:TraceEvent("quest", "progress-restored",
        {reason = reason or "stock-restored"})
    return true, "restored"
end

function Dialogue:UpdateProgressPagePresentation()
    if not self.progressOwned or not self.progressActive
        or not self.presentationShown then return end
    if self.currentPage ~= #self.pages then
        self.root:SetHeight(styleValue("height"))
        self.offerActionRoot:Hide()
        self.offerActionRoot:EnableMouse(false)
        return
    end
    self.root:SetHeight(391)
    self.declineButton:Hide()
    self.acceptButton.label:SetText("Continue")
    self.acceptButton:Show()
    self.offerActionRoot:EnableMouse(true)
    self.offerActionRoot:Show()
end

function Dialogue:ActivateProgressContinue()
    local eligible, reason = self:ProgressGate()
    if not eligible then return false, reason end
    local ok, module = pcall(Logres.GetModule, Logres, "QuestOfferStockSuppression")
    if not ok or not module
        or type(module.CaptureOfferPresentation) ~= "function"
        or type(module.SuppressOfferPresentation) ~= "function"
        or type(module.RestoreOfferPresentation) ~= "function"
        or type(module.EmergencyRestoreOfferPresentation) ~= "function" then
        return false, "native-restoration-unavailable"
    end
    local captureOK, snapshot = pcall(module.CaptureOfferPresentation, module)
    if not captureOK or not snapshot or type(snapshot.mouseFrames) ~= "table" then
        return false, "progress-stock-capture-failed"
    end
    -- Only proven nonprotected native children may be temporarily parked.
    for index = 1, #snapshot.mouseFrames do
        local frame = snapshot.mouseFrames[index].frame
        if not ordinaryProgress(frame) then return false, "native-child-secret" end
        local methodOK, check = pcall(function() return frame.IsProtected end)
        if not methodOK or not ordinaryProgress(check) or type(check) ~= "function" then
            return false, "native-protection-unavailable"
        end
        local protectOK, protected = pcall(check, frame)
        if not protectOK or not ordinaryProgress(protected) or protected ~= false then
            return false, "protected-or-unknown-child"
        end
    end
    -- Capture succeeded, so a failed partial suppression can be rolled back.
    self.progressStockModule, self.progressStockSnapshot = module, snapshot
    self.progressOwned = true
    if not pcall(module.SuppressOfferPresentation, module, snapshot) then
        local restored = self:RestoreProgressStock("progress-suppress-rollback")
        return false, restored and "progress-suppress-failed" or "progress-rollback-failed"
    end
    Dialogue.PositionCompletionActionVisual(self)
    local level = readOwnedFrameValue(self.root, "GetFrameLevel")
    if level then self.offerActionRoot:SetFrameLevel(level + 8) end
    self.acceptButton:EnableMouse(true)
    self.acceptButton:ClearAllPoints()
    self.acceptButton:SetPoint("CENTER", self.offerActionRoot, "CENTER", 0, 9)
    self:UpdateProgressPagePresentation()
    Logres:TraceEvent("quest", "progress-owned", {questID = self.lastQuestID})
    return true, "progress-owned"
end

function Dialogue:HandleProgressContinue()
    if self.progressContinuePending then
        return false, "transition-already-requested"
    end
    local eligible, reason = self:ProgressGate()
    if not self.progressOwned or not eligible then
        if self:RestoreProgressStock("progress-guard-blocked") then
            self:HidePresentation("progress-native-fallback")
        end
        return false, reason or "progress-not-owned"
    end
    -- Keep the already captured, nonprotected stock subtree parked while
    -- Blizzard's native handler advances the progress lifecycle. Removing the
    -- Logres panel and restoring native alpha BEFORE the handler caused the
    -- observed visible Blizzard pop during the transition.
    self.progressContinuePending = true
    self.progressContinueSerial = self.progressContinueSerial + 1
    local serial = self.progressContinueSerial
    self.offerActionRoot:Hide() -- prevent a second click in flight
    local called = pcall(_G.QuestProgressCompleteButton_OnClick)
    if not called then
        if self:RestoreProgressStock("progress-native-call-failed") then
            self:HidePresentation("progress-native-call-failed")
        end
        Logres:TraceEvent("quest", "progress-continue-requested",
            {result = "native-call-failed"})
        return false, "native-call-failed"
    end
    -- QUEST_FINISHED or QUEST_COMPLETE restores the native snapshot on the
    -- ordinary ClearActiveDetail path before releasing replacement input.
    -- A single bounded fallback handles a native call without either event;
    -- no OnUpdate or repeated polling, no permanent hidden stock controls.
    local scheduled = pcall(C_Timer.After, 1.5, function()
        if self.progressContinuePending and self.progressContinueSerial == serial
            and self.progressOwned then
            if self:RestoreProgressStock("progress-transition-timeout") then
                self:HidePresentation("progress-transition-timeout")
            end
            Logres:TraceEvent("quest", "progress-transition-timeout",
                {result = "stock-fallback-requested"})
        end
    end)
    if not scheduled then
        if self:RestoreProgressStock("progress-timer-unavailable") then
            self:HidePresentation("progress-timer-unavailable")
        end
        return false, "native-transition-timeout-unavailable"
    end
    Logres:TraceEvent("quest", "progress-continue-requested",
        {result = "native-transition-invoked"})
    return true, "native-transition-invoked"
end

function Dialogue:HandleCompletionAction()
    if not self.completionControl then
        return false, "control-unavailable"
    end
    return self.completionControl:Click()
end

function Dialogue:ShowCompletionStockFallback(reason)
    if not self.completionActive or not self.presentationShown then
        return false, "completion-not-active"
    end
    if self.completionControl and self.completionControl.applied then
        if not self.completionControl:Restore("fallback-requested") then
            self:SetOfferActionFeedback("Native controls unavailable. Try /reload.")
            return false, "stock-restoration-failed"
        end
    end
    self.completionFallbackActive = true
    if self.rewardVisual then self.rewardVisual:ClearLiveChoiceHandler() end
    Dialogue.PositionCompletionActionVisual(self)
    if #self.completionRewardCards == 0 then self.root:SetHeight(391) end
    self.offerActionRoot:EnableMouse(true)
    self.acceptButton.label:SetText("Finish in Blizzard")
    self.acceptButton:ClearAllPoints()
    self.acceptButton:SetPoint("CENTER", self.offerActionRoot, "CENTER", 0, 9)
    self.acceptButton:Show()
    if self.currentPage == #self.pages then self.offerActionRoot:Show() end
    self:SetOfferActionFeedback("Use Blizzard controls to finish this quest.")
    Logres:TraceEvent("quest", "completion-stock-action",
        {questID = self.lastQuestID, reason = reason or "unsupported"})
    return true, "native-fallback-ready"
end

function Dialogue:HandleLiveRewardChoice(index)
    if not self.completionControl or not self.completionActive
        or not self.completionControl.applied then
        return false, "choice-controller-not-active"
    end
    local ok, reason = self.completionControl:SelectChoice(index)
    if ok and self.rewardVisual then
        self.rewardVisual:SetLiveChoiceHandler(function(choice)
            self:HandleLiveRewardChoice(choice)
        end, self.completionControl.selectedChoiceIndex)
        self:SetOfferActionFeedback("Reward selected. Complete Quest to claim.")
    elseif not ok then
        self:ShowCompletionStockFallback(reason)
    end
    return ok, reason
end

function Dialogue:HandleCompletionFallback()
    if not self.completionActive or not self.completionFallbackActive then
        return false, "fallback-not-active"
    end
    Logres:TraceEvent("quest", "completion-native-fallback-requested",
        {questID = self.lastQuestID})
    return self:HidePresentation("completion-native-fallback")
end
function Dialogue:HidePresentation(reason)
    -- Restore native progress mouse ownership before dismissing replacement.
    if not self:RestoreProgressStock(reason or "progress-hidden") then
        return false, "progress-restoration-pending"
    end
    -- Other dialogue/immersion callbacks can independently dismiss the view.
    -- Do not leave its SHOWN native source stranded offscreen on those exits.
    if self.optionSession and self.optionSession.liveReadOnly == true
        and Logres.NPCGossipStockParking
        and Logres.NPCGossipStockParking.IsParked() then
        local restored = Logres.NPCGossipStockParking.RequestExit(
            reason or "dialogue-hidden")
        if not restored then return false, "stock-restoration-pending" end
    end
    if Logres.QuestGreetingControl and Logres.QuestGreetingControl.IsParked() then
        local restored = Logres.QuestGreetingControl.Restore(
            reason or "dialogue-greeting-hidden")
        if not restored then return false, "greeting-restoration-pending" end
    end
    if self.completionControl then
        self.completionControl:Restore(reason or "hide-presentation")
    end
    self:RequestStockOfferSuppression(
        false,
        reason or "hide-presentation"
    )

    local wasPresented = self.presentationShown == true
    self.presentationGeneration =
        self.presentationGeneration + 1
    self.presentationShown = false
    self.progressActive = false
    self.completionActive = false
    self.completionFallbackActive = false
    self.pendingCompletionItem = nil
    self.completionRewardCards = {}
    self.completionRewardOverflow = false
    self.completionRewardFooter = nil
    self.completionRewardText = nil
    if self.rewardVisual then self.rewardVisual:Reset() end
    self.rewardPreviewSelected = nil
    self.rewardPreviewChoiceCount = 0
    self.rewardPreviewChoiceState = "inactive"
    if self.optionSession then self.optionSession:Reset() end
    self.pages = {}
    self.currentPage = 0

    if self.root then
        self.root:Hide()
    end

    if self.offerActionRoot then
        self.offerActionRoot:Hide()
        self.offerActionRoot:EnableMouse(false)
    end

    self.offerActionsEnabled = false
    self.offerActionPreview = false
    self.offerActionPending = false

    if reason then
        self.lastPresentationReason = reason
    end
    if wasPresented then
        Logres:TraceEvent("quest", "presentation-dismissed",
            {reason = reason or "unclassified"})
    end
    return true, "hidden"
end

-- P0266: the same Goodbye action is visible on every narrative/reward/NPC
-- option presentation. It always hands control back to native stock first.
function Dialogue:Goodbye()
    if not self.moduleEnabled or not self.presentationShown then
        return false, "no-presentation"
    end
    self.goodbyeClicks = self.goodbyeClicks + 1
    if self.optionSession and self.optionSession.active then
        return self.optionSession:Goodbye()
    end
    self:HidePresentation("goodbye")
    return true, "closed"
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
    -- Keep only the immediately observed ordinary completion across a
    -- preference toggle. Every actual lifecycle exit invalidates it.
    if reason ~= "QUEST_COMPLETE" then
        self.activeCompletion = nil
    end
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

-- P0381: ordinary native progress only; Blizzard owns Continue on fallback.
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
        local owned, progressReason = self:ActivateProgressContinue()
        if owned then
            self.progressShownCount = self.progressShownCount + 1
            self.presentationCount = self.presentationCount + 1
            self.lastProgressReason = "logres-continue-owned"
        else
            -- Unsupported stages get only usable Blizzard progress controls.
            if self:HidePresentation("progress-stock-owned") then
                self.progressSkippedCount = self.progressSkippedCount + 1
            end
            self.lastProgressReason = progressReason or "stock-continue"
            Logres:TraceEvent("quest", "progress-stock-fallback",
                {reason = self.lastProgressReason})
        end
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
local function ordinaryRewardNumber(label, fn, ...)
    if type(fn) ~= "function" then
        return nil, label .. "-api-unavailable"
    end
    local ok, value = pcall(fn, ...)
    if not ok then return nil, label .. "-read-failed" end
    if isSecret(value) then return nil, label .. "-secret" end
    if type(value) ~= "number" or value ~= value or value == math.huge
        or value < 0 or value > 100000000
    then
        return nil, label .. "-invalid"
    end
    return math.floor(value), nil
end

-- Cards are ordinary, read-only source results; never retain secret-capable
-- name, count, texture, or item ID in the visual model.
local function completionRewardCard(kind, name, icon, quantity, itemID)
    if isSecret(name) or isSecret(quantity) then return nil end
    if type(name) ~= "string" or name == ""
        or type(quantity) ~= "number" or quantity ~= quantity
        or quantity < 1 or quantity > 9999
    then return nil end
    local displayIcon = nil
    if not isSecret(icon) and type(icon) == "number" and icon == icon
        and icon > 0 and icon < 1000000000
    then
        displayIcon = icon
    elseif not isSecret(icon) and type(icon) == "string"
        and icon ~= "" and #icon < 256 then
        displayIcon = icon
    elseif not isSecret(itemID) and type(itemID) == "number"
        and itemID == itemID
        and itemID > 0 and itemID < 10000000
        and type(GetItemIcon) == "function"
    then
        local ok, cachedIcon = pcall(GetItemIcon, itemID)
        if ok and not isSecret(cachedIcon) then
            if type(cachedIcon) == "number" and cachedIcon > 0
                and cachedIcon < 1000000000
            then
                displayIcon = cachedIcon
            elseif type(cachedIcon) == "string" and cachedIcon ~= ""
                and #cachedIcon < 256
            then
                displayIcon = cachedIcon
            end
        end
    end
    -- Item identity remains ordinary and read-only; reward purchasing is native.
    local safeItemID = nil
    if not isSecret(itemID) and type(itemID)=="number"
        and itemID==itemID and itemID==math.floor(itemID)
        and itemID>0 and itemID<10000000 then
        safeItemID = itemID
    end
    return {
        kind = kind,
        name = name,
        quantity = math.floor(quantity),
        icon = displayIcon,
        itemID = safeItemID,
    }
end

-- GetQuestItemLink is available in Forever; no link means a safe ID-only fallback.
local function ordinaryQuestRewardLink(kind, index)
    if type(GetQuestItemLink)~="function" then return nil end
    local ok, link = pcall(GetQuestItemLink, kind, index)
    if not ok or isSecret(link) or type(link)~="string" then return nil end
    if #link<10 or #link>2048 or not link:find("|Hitem:",1,true) then
        return nil
    end
    return link
end

local function readCompletionRewardCard(kind, index)
    if type(GetQuestItemInfo) ~= "function" then return nil end
    local ok, name, icon, quantity, _, _, itemID =
        pcall(GetQuestItemInfo, kind, index)
    if not ok then return nil end
    local card = completionRewardCard(kind, name, icon, quantity, itemID)
    if card then
        card.itemLink = ordinaryQuestRewardLink(kind,index)
        -- Preserve the native reward slot index even when other cards
        -- are omitted. Visual list ordinals are never claim indices.
        if kind == "choice" then card.nativeChoiceIndex = index end
    end
    return card
end

function Dialogue:ReadCompletionRewardSummary()
    -- A small, supplemental summary; no choice selection or claim actions.
    local xp, xpReason = ordinaryRewardNumber("reward-xp", GetRewardXP)
    local choices, choiceReason = ordinaryRewardNumber("reward-choices", GetNumQuestChoices)
    local rewards, countReason = ordinaryRewardNumber("reward-count", GetNumQuestRewards)
    -- P0244: quest-log money is keyed to the already-validated NPC quest ID.
    -- Missing/unavailable/secret source is not interpreted as zero payout.
    local money, moneyReason = ordinaryRewardNumber(
        "reward-money", GetQuestLogRewardMoney, self.lastQuestID
    )
    local itemText = nil
    local reason = "complete-reward-source"
    self.completionRewardCards = {}
    self.completionRewardOverflow = false
    local footerMetrics = {}
    -- Only the active, identified single-item completion may wait for cache.
    self.pendingCompletionItem = nil
    -- P0247: observe the earliest blocked read gate; never inspect secrets.
    self.lastCompletionItemGate = "reward-source-unavailable"

    if choices == nil or rewards == nil then
        reason = choiceReason or countReason or "reward-source-unavailable"
    elseif choices > 0 then
        reason = "choice-uses-blizzard"
        self.lastCompletionItemGate = "choice-reward"
    elseif rewards == 1 then
        self.lastCompletionItemGate = "item-api-unavailable"
        if type(GetQuestItemInfo) == "function" then
            local ok, name, texture, quantity, _, _, itemID =
                pcall(GetQuestItemInfo, "reward", 1)
            -- Read-only source gate telemetry, including the no-request path.
            -- Examine no field until its secret-capable status is checked.
            self.lastCompletionItemGate = "item-call-failed"
            if ok then
                if isSecret(name) then
                    self.lastCompletionItemGate = "name-secret"
                elseif isSecret(quantity) then
                    self.lastCompletionItemGate = "quantity-secret"
                elseif type(quantity) ~= "number" or quantity ~= quantity
                    or quantity < 1 or quantity > 9999
                then
                    self.lastCompletionItemGate = "quantity-invalid"
                elseif type(name) == "string" and name ~= "" then
                    self.lastCompletionItemGate = "name-ordinary"
                elseif isSecret(itemID) then
                    self.lastCompletionItemGate = "item-id-secret"
                elseif type(itemID) ~= "number" or itemID ~= itemID
                    or itemID < 1 or itemID > 10000000
                    or itemID ~= math.floor(itemID)
                then
                    self.lastCompletionItemGate = "item-id-invalid"
                elseif type(GetItemInfo) ~= "function" then
                    self.lastCompletionItemGate = "cache-api-unavailable"
                elseif self.eventRegistration.GET_ITEM_INFO_RECEIVED ~= true
                    and self.eventRegistration.ITEM_DATA_LOAD_RESULT ~= true
                then
                    self.lastCompletionItemGate = "cache-events-unavailable"
                else
                    self.lastCompletionItemGate = "cache-eligible"
                end
            end
            if ok and not isSecret(name) and not isSecret(quantity)
                and type(quantity) == "number" and quantity == quantity
                and quantity >= 1 and quantity <= 9999
            then
                local resolvedName = name
                local nameSource = "quest"
                -- P0245: a quest reward can expose a stable ordinary item ID
                -- while its immediate name/link are uncached. One read-only
                -- cache lookup at QUEST_COMPLETE; no timers or retries.
                if (type(resolvedName) ~= "string" or resolvedName == "")
                    and not isSecret(itemID)
                    and type(itemID) == "number" and itemID == itemID
                    and itemID >= 1 and itemID <= 10000000
                    and itemID == math.floor(itemID)
                    and type(GetItemInfo) == "function"
                then
                    -- Capture only an ordinary ID and quantity; never retain
                    -- a secret-capable source value across event boundaries.
                    if self.eventRegistration.GET_ITEM_INFO_RECEIVED == true
                        or self.eventRegistration.ITEM_DATA_LOAD_RESULT == true
                    then
                        self.pendingCompletionItem = {
                            itemID = itemID,
                            quantity = math.floor(quantity),
                            icon = (not isSecret(texture)) and texture or nil,
                        }
                    end
                    local cacheOK, cacheName = pcall(GetItemInfo, itemID)
                    if not cacheOK then
                        self.lastCompletionItemGate = "cache-call-failed"
                    elseif isSecret(cacheName) then
                        self.lastCompletionItemGate = "cache-name-secret"
                    elseif type(cacheName) ~= "string" or cacheName == "" then
                        self.lastCompletionItemGate = "cache-empty"
                    else
                        self.lastCompletionItemGate = "cache-name-ready"
                    end
                    if cacheOK and not isSecret(cacheName)
                        and type(cacheName) == "string" and cacheName ~= ""
                    then
                        resolvedName = cacheName
                        nameSource = "item-cache"
                    end
                end
                if type(resolvedName) == "string" and resolvedName ~= "" then
                    self.pendingCompletionItem = nil
                    itemText = resolvedName .. " x" .. tostring(math.floor(quantity))
                    local card = completionRewardCard(
                        "reward", resolvedName, texture, quantity, itemID
                    )
                    if card then
                        card.itemLink = ordinaryQuestRewardLink("reward",1)
                        self.completionRewardCards[1] = card
                    end
                    reason = nameSource == "item-cache"
                        and "guaranteed-item-cache"
                        or "guaranteed-item-ordinary"
                else
                    reason = "guaranteed-item-unavailable"
                end
            else
                reason = "guaranteed-item-unavailable"
            end
        else
            reason = "item-api-unavailable"
        end
    elseif rewards > 1 then
        reason = "multiple-rewards-use-blizzard"
        self.lastCompletionItemGate = "multiple-items"
    elseif rewards == 0 then
        reason = "xp-only-or-no-items"
        self.lastCompletionItemGate = "no-guaranteed-items"
    end

    -- Multiple guaranteed/choice sources share the same bounded card layout.
    -- These are not clickable; the Blizzard quest panel retains selection/claim.
    if rewards ~= nil and choices ~= nil
        and (rewards > 1 or choices > 0)
    then
        self.completionRewardCards = {}
        local cards = self.completionRewardCards
        local reads = 0
        for i = 1, math.min(rewards, MAX_REWARD_CARDS) do
            reads = reads + 1
            local card = readCompletionRewardCard("reward", i)
            if card then cards[#cards + 1] = card end
        end
        for i = 1, math.min(choices, MAX_REWARD_CARDS - reads) do
            reads = reads + 1
            local card = readCompletionRewardCard("choice", i)
            if card then cards[#cards + 1] = card end
        end
        self.completionRewardOverflow = rewards + choices > MAX_REWARD_CARDS
    end

    local label = itemText or "Review rewards in Blizzard quest window"
    if xp ~= nil and xp > 0 then
        -- Two brief rows within the already-owned 50px narrative footer.
        label = label .. " | " .. tostring(xp) .. " XP"
        footerMetrics[#footerMetrics + 1] = tostring(xp) .. " XP"
    elseif xpReason then
        reason = reason .. "/" .. xpReason
    end
    if money ~= nil and money > 0 then
        -- Currency in copper: 10000 = gold, 100 = silver.
        -- Only an ordinary, finite, guarded number reaches this arithmetic.
        local gold = math.floor(money / 10000)
        local silver = math.floor((money % 10000) / 100)
        local copper = money % 100
        local amounts = {}
        if gold > 0 then amounts[#amounts + 1] = tostring(gold) .. "g" end
        if silver > 0 then amounts[#amounts + 1] = tostring(silver) .. "s" end
        if copper > 0 then amounts[#amounts + 1] = tostring(copper) .. "c" end
        label = label .. " | " .. table.concat(amounts, " ")
        footerMetrics[#footerMetrics + 1] = table.concat(amounts, " ")
    end
    local rewardFooter = #footerMetrics > 0
        and table.concat(footerMetrics, " | ")
        or "Review rewards in Blizzard quest window"
    if self.completionRewardOverflow then
        rewardFooter = rewardFooter .. " | More rewards in Blizzard window"
    end
    if choices ~= nil and choices > 0 then
        rewardFooter = rewardFooter .. "\nChoose and complete in Blizzard quest window"
    else
        rewardFooter = rewardFooter .. "\nComplete using Blizzard quest controls"
    end
    return label .. "\nComplete using Blizzard quest controls", reason,
        itemText ~= nil, money, moneyReason or (money ~= nil and "ordinary" or "unknown"), rewardFooter
end

-- P0257 R1: one component geometry for guarded live and inert preview.
-- Caller determines ownership; the helper touches Logres-owned frames only.
function Dialogue:PositionCompletionActionVisual()
    self.offerActionRoot:ClearAllPoints()
    self.offerActionRoot:SetPoint(
        "TOP", self.root, "BOTTOM", 0,
        offerStyleValue("y") + 64
    )
end

-- P0385: QUEST_GREETING is the separate QuestFrame greeting path used by
-- NPCs offering multiple quests. Sample ordinary source data at the event;
-- never park or suppress the Blizzard QuestFrame on unverified coverage.
local function greetingOrdinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function greetingCount(fn)
    if not greetingOrdinary(fn) or type(fn) ~= "function" then
        return nil, "count-api-unavailable"
    end
    local ok, value = pcall(fn)
    if not ok or not greetingOrdinary(value) or type(value) ~= "number"
        or value ~= math.floor(value) or value < 0 or value > 24 then
        return nil, "count-not-ordinary-or-overflow"
    end
    return value, "ordinary"
end

local function greetingTitlesReady(count, fn)
    if not greetingOrdinary(fn) or type(fn) ~= "function" then
        return false, "title-api-unavailable"
    end
    for index = 1, count do
        local ok, title = pcall(fn, index)
        if not ok or not greetingOrdinary(title) or type(title) ~= "string"
            or title == "" or #title > 2048 then
            return false, "title-not-ordinary"
        end
    end
    return true, "titles-ordinary"
end

function Dialogue:ObserveQuestGreeting()
    self.greetingEventCount = self.greetingEventCount + 1
    local available, availableStatus = greetingCount(GetNumAvailableQuests)
    local active, activeStatus = greetingCount(GetNumActiveQuests)
    local status = "counts-ordinary"
    if available == nil then status = "available-" .. availableStatus
    elseif active == nil then status = "active-" .. activeStatus
    else
        local availableReady, aReason = greetingTitlesReady(available, GetAvailableTitle)
        local activeReady, bReason = greetingTitlesReady(active, GetActiveTitle)
        if not availableReady then status = "available-" .. aReason
        elseif not activeReady then status = "active-" .. bReason
        else
            local textOK, greeting = false, nil
            if greetingOrdinary(GetGreetingText) and type(GetGreetingText) == "function" then
                textOK, greeting = pcall(GetGreetingText)
            end
            if not textOK or not greetingOrdinary(greeting)
                or type(greeting) ~= "string" or #greeting > 2048 then
                status = "greeting-text-unavailable"
            else
                status = "ordinary-quest-greeting-ready"
            end
        end
    end
    self.lastGreetingAvailable = available
    self.lastGreetingActive = active
    self.lastGreetingStatus = status
    Logres:TraceEvent("quest", "greeting-observed", {
        available = available, active = active, result = status,
    })
    -- P0386: only a complete ordinary list with native selectors and
    -- restorable nonprotected QuestFrame may obtain Logres ownership.
    if status == "ordinary-quest-greeting-ready" then
        local owned, why = Logres.QuestGreetingControl.TryShow(self)
        self.lastGreetingPresentationReason = why
        Logres:TraceEvent("quest", "greeting-ownership-result", {
            result = owned and "logres-owned" or "native-stock-owned",
            reason = why,
        })
    end
end

function Dialogue:HandleQuestComplete()
    Logres:TraceEvent("quest", "completion-observed",
        {source = self.restoringCompletion and "preference" or "native-event"})
    -- A preference restore may re-render, but is NOT a new QUEST_COMPLETE.
    if not self.restoringCompletion then
        self.completeEventCount = self.completeEventCount + 1
    end
    self:ClearActiveDetail("QUEST_COMPLETE")
    self.lastCompletionEnterMap = nil
    self.lastCompletionDownMap = nil
    local completion, reason, secret = self:ReadCompletion()
    if not completion then
        self.activeCompletion = nil
        self.completionSkippedCount = self.completionSkippedCount + 1
        self.lastCompletionReason = reason or "completion-unavailable"
        self.lastCompletionSecret = secret == true
        Logres:TraceEvent("quest", "completion-unavailable",
            {reason = reason or "source-unavailable"})
        return
    end

    -- ReadCompletion validated every field as ordinary before we cache an
    -- identity token. Never retain a secret-capable native value.
    self.activeCompletion = {
        questID = completion.questID,
        title = completion.title,
    }
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

    local rewardSummary, rewardReason, rewardIdentified,
        rewardMoney, rewardMoneyReason, rewardFooter = self:ReadCompletionRewardSummary()
    -- P0257: production's guarded reader and preview fixture produce the
    -- same plain reward presentation model for the same view renderer.
    local rewardModel = Logres.QuestRewardModel.FromLive(
        self.completionRewardCards, rewardFooter
    )
    self.lastCompletionRewardReason = rewardReason
    self.lastCompletionRewardIdentified = rewardIdentified == true
    self.lastCompletionRewardMoney = rewardMoney
    self.lastCompletionRewardMoneyReason = rewardMoneyReason
    self.completionRewardText = rewardSummary
    local shown, state = self:PresentText(
        completion.title, completion.body, rewardSummary, "QUEST_COMPLETE",
        false, false, false
    )
    Logres:TraceEvent("quest", "completion-presentation",
        {questID = completion.questID, result = shown and state or "not-shown"})
    if shown and state == "shown" then
        self.completionActive = true
        self.completionShownCount = self.completionShownCount + 1
        self.presentationCount = self.presentationCount + 1
        self.lastCompletionReason = "shown"
        self:UpdatePageControls()
        if self.rewardVisual and #rewardModel.cards > 0 then
            self.rewardVisual:Present(self.completionRewardCards, rewardFooter)
        end
        self.completionRewardFooter = rewardModel.footer
        if self.completionControl then
            -- Hide the two offer actions before attempting native suppression.
            -- Only a supported, captured completion may show the shared Accept.
            self.acceptButton:Hide()
            self.declineButton:Hide()
            local applied, controlReason = self.completionControl:Activate()
            self.completionFallbackActive = not applied
            Logres:TraceEvent("quest",
                applied and "completion-owned" or "completion-stock-fallback",
                {questID = completion.questID, reason = controlReason})
            if applied then
                -- The existing Accept button was correct all along; the
                -- shared action root was BELOW the opaque panel. Move that
                -- same button inside the lower panel, as in the approved art.
                -- The no-item completion also needs enough panel height to
                -- keep its footer and the internal action from overlapping.
                if #self.completionRewardCards == 0 then
                    self.root:SetHeight(391)
                end
                self:PositionCompletionActionVisual()
                -- Raise only this owned action over addon reward art/option siblings.
                -- No Blizzard frame strata or protected state is changed.
                local actionLevel = readOwnedFrameValue(self.root, "GetFrameLevel")
                if actionLevel then
                    self.offerActionRoot:SetFrameLevel(actionLevel + 8)
                    self.acceptButton:SetFrameLevel(actionLevel + 9)
                end
                self.acceptButton:EnableMouse(true)
                self.acceptButton.label:SetText("Complete Quest")
                self.acceptButton:ClearAllPoints()
                self.acceptButton:SetPoint(
                    "CENTER", self.offerActionRoot, "CENTER", 0, 9
                )
                self.acceptButton:Show()
                -- The actionable Logres button already communicates the
                -- next step. Keep reward amounts, not a duplicate instruction.
                local ownedFooter = rewardFooter:gsub(
                    "\nComplete using Blizzard quest controls", ""
                )
                ownedFooter = ownedFooter:gsub(
                    "\nChoose and complete in Blizzard quest window", ""
                )
                self.completionRewardFooter = ownedFooter
                if self.rewardVisual and #self.completionRewardCards > 0 then
                    self.rewardVisual:Present(self.completionRewardCards, ownedFooter)
                else
                    self.objectiveText:SetText(ownedFooter)
                end
            else
                -- Unsupported or ambiguous native state gets an
                -- explicit usable stock handoff, never a dead-end GUI.
                self:ShowCompletionStockFallback(controlReason)
            end
        end
        -- PresentText() starts on page one; refresh after stock ownership
        -- and card/footers are known, then on every explicit page change.
        self:UpdateCompletionPagePresentation()
        local pending = self.pendingCompletionItem
        local fallback = "Review rewards in Blizzard quest window"
        if pending and type(rewardSummary) == "string"
            and rewardSummary:sub(1, #fallback) == fallback
        then
            -- The suffix contains only authored text, guarded XP and money.
            pending.suffix = rewardSummary:sub(#fallback + 1)
            pending.generation = self.presentationGeneration
            pending.questID = completion.questID
            self.lastCompletionItemCacheState = "awaiting-data"
            -- One request, only for the active ordinary reward. The client
            -- sends ITEM_DATA_LOAD_RESULT; GetItemInfo may independently
            -- send GET_ITEM_INFO_RECEIVED. No timer or polling is installed.
            if type(C_Item) == "table"
                and type(C_Item.RequestLoadItemDataByID) == "function"
            then
                self.completionItemRequests = self.completionItemRequests + 1
                local requestOK = pcall(
                    C_Item.RequestLoadItemDataByID, pending.itemID
                )
                if not requestOK then
                    self.lastCompletionItemCacheState = "request-failed"
                end
            end
        else
            self.pendingCompletionItem = nil
        end
    else
        self.pendingCompletionItem = nil
        self.completionSkippedCount = self.completionSkippedCount + 1
        self.lastCompletionReason = state or "presentation-unavailable"
    end
    self.lastCompletionSecret = false
end

function Dialogue:HandleCompletionItemData(eventItemID, success)
    local pending = self.pendingCompletionItem
    if not pending then return end
    self.completionItemSignals = self.completionItemSignals + 1

    -- Both event payload values are treated as secret-capable. Never compare
    -- or stringify one until its non-secret status is established.
    if isSecret(eventItemID) or isSecret(success) then
        self.lastCompletionItemCacheState = "event-secret"
        self.pendingCompletionItem = nil
        return
    end
    if type(eventItemID) ~= "number" or eventItemID ~= pending.itemID then
        return
    end
    if success == false then
        self.lastCompletionItemCacheState = "event-failed"
        self.pendingCompletionItem = nil
        return
    end
    if not self.moduleEnabled or not self.immersionEnabled
        or not self.completionActive or not self.presentationShown
        or self.presentationGeneration ~= pending.generation
        or self.lastQuestID ~= pending.questID
    then
        self.lastCompletionItemCacheState = "stale-completion"
        self.pendingCompletionItem = nil
        return
    end

    -- Resolve only ordinary item text for the same active completion.
    local ok, name = pcall(GetItemInfo, pending.itemID)
    if not ok or isSecret(name) then
        self.lastCompletionItemCacheState = "event-read-unavailable"
        self.pendingCompletionItem = nil
        return
    end
    if type(name) ~= "string" or name == "" then
        self.lastCompletionItemCacheState = "event-name-unavailable"
        self.pendingCompletionItem = nil
        return
    end
    if self.objectiveText and type(pending.suffix) == "string" then
        self.objectiveText:SetText(
            name .. " x" .. tostring(pending.quantity) .. pending.suffix
        )
        -- Convert the text fallback into the identical portrait row if
        -- metadata eventually arrives for this still-active completion.
        local card = completionRewardCard(
            "reward", name, pending.icon, pending.quantity, pending.itemID
        )
        if card and self.rewardVisual then
            self.completionRewardCards = { card }
            self.rewardVisual:Present(
                self.completionRewardCards, self.completionRewardFooter
            )
            self:UpdateCompletionPagePresentation()
        end
        self.completionItemResolvedCount = self.completionItemResolvedCount + 1
        self.lastCompletionRewardReason = "guaranteed-item-event"
        self.lastCompletionRewardIdentified = true
        self.lastCompletionItemCacheState = "resolved"
    end
    self.pendingCompletionItem = nil
end

function Dialogue:UpdatePageControls()
    return Logres.NPCNarrativePages.Paint(
        self,
        colorValue("pageActive"),
        colorValue("pageInactive")
    )
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
    Logres.NPCNarrativePages.ShowBody(self, index)
    self:UpdatePageControls()
    self:UpdateOfferControls()
    self:UpdateCompletionPagePresentation()
    self:UpdateProgressPagePresentation()
    if self.optionSession then
        self.optionSession:OnNarrativePageChanged()
    end

    return true, "page-shown"
end

-- P0255: rewards and the guarded claim action belong to the final
-- narrative page. Only addon-owned textures/frames are changed here;
-- the native stock suppression snapshot is never altered by paging.
function Dialogue:UpdateCompletionPagePresentation()
    if not self.completionActive or not self.presentationShown then
        return
    end
    local finalPage = self.currentPage == #self.pages
    self.objectiveHeader:SetShown(finalPage)
    self.objectiveText:SetShown(finalPage)
    if not finalPage then
        if self.rewardVisual then
            for i = 1, #self.rewardVisual.slots do
                self.rewardVisual.slots[i]:Hide()
            end
        end
        self.root:SetHeight(styleValue("height"))
        if (self.completionControl and self.completionControl.applied)
            or self.completionFallbackActive then
            self.completionActionRoot:Hide()
        end
        return
    end
    if self.rewardVisual and #self.completionRewardCards > 0 then
        self.rewardVisual:Present(
            self.completionRewardCards, self.completionRewardFooter
        )
        self.objectiveText:Show()
    else
        self.objectiveText:SetText(
            self.completionRewardText or self.completionRewardFooter or ""
        )
        if self.completionControl and self.completionControl.applied then
            self.root:SetHeight(391)
        end
    end
    if self.completionControl and self.completionControl.applied then
        self.completionActionRoot:Show()
        if self.rewardVisual and self.completionControl.choiceCount > 0 then
            self.rewardVisual:SetLiveChoiceHandler(function(index)
                self:HandleLiveRewardChoice(index)
            end, self.completionControl.selectedChoiceIndex)
        end
    elseif self.completionFallbackActive then
        self.completionActionRoot:Show()
    end
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

    if self.completionControl then
        self.completionControl:Restore("new-presentation")
    end
    self.presentationGeneration =
        self.presentationGeneration + 1
    local generation =
        self.presentationGeneration

    if self.rewardVisual then self.rewardVisual:Reset() end
    self.rewardPreviewSelected = nil
    self.rewardPreviewChoiceCount = 0
    self.rewardPreviewChoiceState = "inactive"
    if self.optionSession then
        if reason == "npc-options-preview"
            or reason == "npc-options-read-only"
            or reason == "npc-quest-greeting" then
            self.optionView:Clear()
        else
            self.optionSession:Reset()
        end
    end
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
        if reason == "QUEST_COMPLETE" or reason == "reward-preview" then
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
    Logres:TraceEvent("quest", "presentation-presented",
        {reason = self.lastPresentationReason,
         result = previewMode and "preview" or "live"})
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

function Dialogue:PresentNarrativeModel(model)
    return self:PresentText(
        model.title,
        model.body,
        model.objective,
        model.reason,
        model.autoHide,
        model.action == "offer",
        model.previewOnly
    )
end

-- P0387: Forever's QUEST_ACCEPTED carries the accepted questID
-- (Classic variants may prefix a quest-log index). Classify the final
-- payload as ordinary BEFORE reading its type or comparing with addon data.
local function ordinaryAcceptedEventQuestID(...)
    local count = select("#", ...)
    if (count ~= 1 and count ~= 2)
        or type(issecretvalue) ~= "function" then return nil end
    local candidate = select(count, ...)
    local ok, secret = pcall(issecretvalue, candidate)
    if not ok or secret ~= false then return nil end
    if type(candidate) ~= "number" or candidate <= 0
        or candidate ~= candidate or candidate == math.huge then
        return nil
    end
    return candidate
end

-- Only a proven Logres-owned, already-presented *different* offer may
-- survive the late acceptance of the preceding offer. Both QuestDialogue
-- and QuestOfferStockSuppression consult this same predicate, independently
-- of event handler ordering. A missing/secret event identity fails open.
function Dialogue:ShouldPreserveNewOfferOnAccepted(...)
    local detail = self.activeDetail
    local pending = self.pendingAcceptedOfferQuestID
    if not detail or not pending or not self.presentationShown
        or not self.offerActionsEnabled or self.offerActionPreview
        or detail.questID == pending then return false end
    local accepted = ordinaryAcceptedEventQuestID(...)
    return accepted ~= nil and accepted == pending
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

    local model = Logres.NPCNarrativeModel.FromLive(
        detail.title, detail.body, detail.objective,
        "QUEST_DETAIL", "offer"
    )
    self:PresentNarrativeModel(model)
end

-- P0251 R3: a preference toggle does not emit QUEST_COMPLETE again.
-- Resume only when the same native reward screen and ordinary quest identity
-- are still active; otherwise leave Blizzard visible and discard the token.
function Dialogue:RestoreCompletionAfterImmersion()
    local active = self.activeCompletion
    if not active then return false, "no-completion-token" end
    if type(issecretvalue) ~= "function" then
        self.activeCompletion = nil
        return false, "secret-gate-unavailable"
    end
    for index = 1, 2 do
        local frame
        if index == 1 then
            frame = _G.QuestFrame
        else
            frame = _G.QuestFrameRewardPanel
        end
        if not frame or type(frame.IsShown) ~= "function" then
            self.activeCompletion = nil
            return false, "native-frame-unavailable"
        end
        local shownOK, isShown = pcall(frame.IsShown, frame)
        if not shownOK or isSecret(isShown) or isShown ~= true then
            self.activeCompletion = nil
            return false, "native-reward-not-shown"
        end
    end
    local current = self:ReadCompletion()
    if not current or current.questID ~= active.questID
        or current.title ~= active.title
    then
        self.activeCompletion = nil
        return false, "completion-identity-changed"
    end
    self.restoringCompletion = true
    local renderOK = pcall(self.HandleQuestComplete, self)
    self.restoringCompletion = false
    if not renderOK then
        -- Restore stock before withdrawing a partially prepared replacement.
        self:ClearActiveDetail("completion-restore-failed")
        return false, "completion-restore-failed"
    end
    return self.completionActive == true, self.lastCompletionReason
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
    elseif not wasImmersionEnabled and self.activeCompletion ~= nil then
        self:RestoreCompletionAfterImmersion()
    end
end

-- P0261 N1: existing long sample, new short and generic NPC samples use
-- the identical production view. All preview action dispatch stays inert.
function Dialogue:ShowNarrativePreview(mode)
    if not self.moduleEnabled then
        return false, "module-disabled"
    end
    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return true, "suppressed-immersion-off"
    end
    if self.completionActive then
        return false, "active-completion"
    end
    local model, reason = Logres.NPCNarrativeModel.Preview(mode)
    if not model then return false, reason end
    self.previewCount = self.previewCount + 1
    return self:PresentNarrativeModel(model)
end

function Dialogue:ShowPreview()
    return self:ShowNarrativePreview("long")
end

-- Only authored preview ordinals reach this handler. Gameplay/stock reward
-- claiming remains deliberately outside the view and this controller.
function Dialogue:ChooseRewardPreview(index)
    if not self.moduleEnabled or not self.immersionEnabled
        or not self.presentationShown or not self.offerActionPreview
        or self.lastPresentationReason ~= "reward-preview"
        or self.completionActive or not self.rewardVisual
    then
        self.rewardPreviewChoiceState = "blocked-stale-preview"
        return false, "not-active-reward-preview"
    end
    local ok, reason = self.rewardVisual:SelectPreviewChoice(index)
    if not ok then
        self.rewardPreviewChoiceState = reason
        return false, reason
    end
    self.rewardPreviewSelected = index
    self.rewardPreviewChoiceClicks = self.rewardPreviewChoiceClicks + 1
    self.rewardPreviewChoiceState = "selected"
    self:SetOfferActionFeedback(
        "Choice " .. index .. " selected (preview only)"
    )
    return true, reason
end

-- P0257: one data contract and ONE production renderer. The synthetic
-- fixture has no quest identity and never obtains native reward control.
function Dialogue:ShowRewardPreview(mode)
    if not self.moduleEnabled then return false, "module-disabled" end
    if not self.immersionEnabled then return false, "immersion-off" end
    if self.completionActive then return false, "active-completion" end
    local model, errorReason = Logres.QuestRewardModel.Preview(mode)
    if not model then return false, errorReason end

    -- The same normalization used by guarded live reward reads supplies the
    -- optional correct potion icon when item cache metadata is present.
    for index = 1, #model.cards do
        local card = model.cards[index]
        if card.itemID then
            local normalized = completionRewardCard(
                card.kind, card.name, nil, card.quantity, card.itemID
            )
            if normalized and normalized.icon then
                card.icon = normalized.icon
            end
        end
    end
    local ok, state = self:PresentText(
        model.title, model.body, "Preview only", "reward-preview",
        true, false, true
    )
    if ok and state == "shown" and self.rewardVisual then
        self.rewardVisual:Present(model.cards, model.footer)
        if model.selectablePreviewChoices then
            self.rewardPreviewChoiceCount = self.rewardVisual.choiceCount
            self.rewardPreviewChoiceState = "awaiting-choice"
            self.rewardVisual:SetPreviewChoiceHandler(function(index)
                self:ChooseRewardPreview(index)
            end)
        else
            self.rewardPreviewChoiceState = "no-choices"
        end
        if model.action == "preview-complete" then
            -- IDENTICAL button object and completion geometry as production,
            -- but the click is intercepted by offerActionPreview above.
            self:PositionCompletionActionVisual()
            self.acceptButton.label:SetText("Complete Quest")
            self.acceptButton:ClearAllPoints()
            self.acceptButton:SetPoint(
                "CENTER", self.offerActionRoot, "CENTER", 0, 9
            )
            self.declineButton:Hide()
            self.acceptButton:Show()
            self.offerActionRoot:Show()
        end
    end
    return ok, state
end

-- P0265: four substantial interactive NPC option scenarios through one
-- shared narrative/view/controller pipeline; synthetic inputs NEVER call gossip.
function Dialogue:ShowOptionPreview(mode)
    if not self.moduleEnabled then return false, "module-disabled" end
    if not self.immersionEnabled then return false, "immersion-off" end
    if self.completionActive then return false, "active-completion" end
    if not self.optionSession then return false, "option-session-unavailable" end
    local model, reason = Logres.NPCOptionModel.Preview(mode)
    if not model then return false, reason end
    self.previewCount = self.previewCount + 1
    return self.optionSession:Start(mode, model)
end

-- P0317: use the already accepted NPC options/narrative visual for real
-- ordinary gossip source. Native choices remain Blizzard-owned.
-- Same accepted narrative/list component as live gossip, but QuestFrame
-- greeting uses its own native selector and native stock parking policy.
function Dialogue:ShowReadOnlyQuestGreeting(model)
    if not self.moduleEnabled or not self.immersionEnabled then
        return false, "immersion-disabled"
    end
    if self.completionActive or self.progressActive or self.activeDetail
        or self.presentationShown then return false, "another-view-active" end
    if not self.optionSession or not model or model.questGreeting ~= true then
        return false, "quest-greeting-model-unavailable" end
    return self.optionSession:StartReadOnly(model)
end

function Dialogue:ShowReadOnlyGossip(model)
    if not self.moduleEnabled then return false, "module-disabled" end
    if not self.immersionEnabled then return false, "immersion-off" end
    if self.completionActive or self.progressActive or self.activeDetail then
        return false, "quest-in-progress"
    end
    if self.presentationShown
        and self.lastPresentationReason ~= "npc-options-read-only" then
        return false, "another-presentation-active"
    end
    if not self.optionSession then return false, "option-session-unavailable" end
    return self.optionSession:StartReadOnly(model)
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

        questGreetingRegistered =
            self.eventRegistration.QUEST_GREETING == true,
        greetingEventCount = self.greetingEventCount,
        lastGreetingAvailable = self.lastGreetingAvailable,
        lastGreetingActive = self.lastGreetingActive,
        lastGreetingStatus = self.lastGreetingStatus,
        lastGreetingPresentationReason = self.lastGreetingPresentationReason,
        greetingStockParked = Logres.QuestGreetingControl.IsParked(),
        questDetailRegistered =
            self.eventRegistration.QUEST_DETAIL == true,
        questAcceptedRegistered =
            self.eventRegistration.QUEST_ACCEPTED == true,
        questFinishedRegistered =
            self.eventRegistration.QUEST_FINISHED == true,
        questTurnedInRegistered =
            self.eventRegistration.QUEST_TURNED_IN == true,
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
        turninEventCount = self.turninEventCount,
        lastTurninQuestID = self.lastTurninQuestID,
        optionSession = self.optionSession and self.optionSession:Debug(),
        goodbyeClicks = self.goodbyeClicks,
        completionRewardCards = #self.completionRewardCards,
        completionRewardOverflow = self.completionRewardOverflow == true,
        rewardPreviewChoiceCount = self.rewardPreviewChoiceCount,
        rewardPreviewChoiceClicks = self.rewardPreviewChoiceClicks,
        rewardPreviewSelected = self.rewardPreviewSelected,
        rewardPreviewChoiceState = self.rewardPreviewChoiceState,
        completionInput = self:CompletionInputStatus(),
        completionControl = self.completionControl and
            self.completionControl:GetDebugStatus() or nil,
        itemInfoRegistered = self.eventRegistration.GET_ITEM_INFO_RECEIVED == true,
        itemDataRegistered = self.eventRegistration.ITEM_DATA_LOAD_RESULT == true,
        completionItemPending = self.pendingCompletionItem ~= nil,
        completionItemSignals = self.completionItemSignals,
        completionItemResolvedCount = self.completionItemResolvedCount,
        completionItemRequests = self.completionItemRequests,
        lastCompletionItemCacheState = self.lastCompletionItemCacheState,
        lastCompletionItemGate = self.lastCompletionItemGate,
        lastCompletionRewardReason = self.lastCompletionRewardReason,
        lastCompletionRewardIdentified = self.lastCompletionRewardIdentified == true,
        lastCompletionRewardMoney = self.lastCompletionRewardMoney,
        lastCompletionRewardMoneyReason = self.lastCompletionRewardMoneyReason,
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
        rootShown = self.root ~= nil and self.root:IsShown() or false,
        rootShowCount = self.rootShowCount,
        rootHideCount = self.rootHideCount,

        offerControlsReady =
            self.offerActionRoot ~= nil
            and self.declineButton ~= nil
            and self.acceptButton ~= nil
            and self.offerActionFeedback ~= nil,
        offerControlsShown =
            self.offerActionRoot ~= nil
            and self.offerActionRoot:IsVisible()
            and self.acceptButton ~= nil
            and self.acceptButton:IsVisible()
            and self.declineButton ~= nil
            and self.declineButton:IsVisible()
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
    self.greetingEventCount = 0
    self.lastGreetingAvailable = nil
    self.lastGreetingActive = nil
    self.lastGreetingStatus = "not-observed"
    self.lastGreetingPresentationReason = "not-attempted"
    self.completeEventCount = 0
    self.completionShownCount = 0
    self.completionSkippedCount = 0
    self.completionActive = false
    self.completionFallbackActive = false
    self.rewardPreviewChoiceCount = 0
    self.rewardPreviewChoiceClicks = 0
    self.goodbyeClicks = 0
    self.rewardPreviewSelected = nil
    self.rewardPreviewChoiceState = "not-observed"
    self.activeCompletion = nil
    self.restoringCompletion = false
    self.completionRewardCards = {}
    self.completionRewardOverflow = false
    self.completionRewardFooter = nil
    self.completionRewardText = nil
    self.pendingCompletionItem = nil
    self.completionItemSignals = 0
    self.completionItemResolvedCount = 0
    self.completionItemRequests = 0
    self.lastCompletionItemCacheState = "not-observed"
    self.lastCompletionItemGate = "not-observed"
    self.lastCompletionReason = "not-observed"
    self.lastCompletionRewardReason = "not-observed"
    self.lastCompletionRewardMoney = nil
    self.lastCompletionRewardMoneyReason = "not-observed"
    self.lastCompletionRewardIdentified = false
    self.lastCompletionSecret = false
    self.progressActive = false
    self.progressOwned = false
    self.progressStockModule = nil
    self.progressStockSnapshot = nil
    self.progressContinuePending = false
    self.progressContinueSerial = 0
    self.lastProgressReason = "not-observed"
    self.lastProgressSecret = false
    self.pendingAcceptedOfferQuestID = nil
    self.acceptedEventCount = 0
    self.finishedEventCount = 0
    self.worldEventCount = 0
    self.turninEventCount = 0
    self.lastTurninQuestID = nil

    self.presentationCount = 0
    self.suppressedCount = 0
    self.previewCount = 0
    self.restoreCount = 0
    self.presentationGeneration = 0
    self.presentationShown = false
    self.rootShowCount = 0
    self.rootHideCount = 0

    self.completionInputCounters = {
        enter = 0, leave = 0, down = 0, up = 0, dispatch = 0
    }
    self.lastCompletionInput = "none"
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
        panelConfig.placement.point,
        UIParent,
        panelConfig.placement.relativePoint,
        panelConfig.placement.x,
        panelConfig.placement.y
    )
    Logres.Layout.Bind(root, panelConfig.placement.key,
        panelConfig.placement.point, panelConfig.placement.relativePoint)
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()
    -- P0375: observe this addon-owned root; never hook Blizzard frames.
    root:HookScript("OnShow", function()
        self.rootShowCount = self.rootShowCount + 1
        Logres:TraceEvent("quest", "root-onshow",
            {reason = self.lastPresentationReason or "unclassified",
             applied = self.presentationShown == true})
    end)
    root:HookScript("OnHide", function()
        -- The action root is a UIParent sibling: never strand a clickable
        -- Logres action after an external parent-panel hide.
        if self.offerActionRoot then self.offerActionRoot:Hide() end
        self.rootHideCount = self.rootHideCount + 1
        Logres:TraceEvent("quest", "root-onhide",
            {reason = self.lastPresentationReason or "unclassified",
             applied = self.presentationShown == true})
    end)

    -- Independent upper-corner dismissal. Keep original Accept/Decline and
    -- protected stock restoration paths intact; no additional quest action.
    local goodbyeButton = CreateFrame("Button", nil, root)
    goodbyeButton:SetSize(78, 24)
    goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)
    goodbyeButton:RegisterForClicks("LeftButtonUp")
    local goodbyeText = goodbyeButton:CreateFontString(
        nil, "OVERLAY", "GameFontHighlightSmall"
    )
    goodbyeText:SetAllPoints(goodbyeButton)
    goodbyeText:SetText("Goodbye")
    goodbyeText:SetTextColor(0.97, 0.78, 0.44, 1)
    local goodbyeLine = goodbyeButton:CreateTexture(nil, "ARTWORK")
    goodbyeLine:SetTexture("Interface\\Buttons\\WHITE8x8")
    goodbyeLine:SetHeight(1)
    goodbyeLine:SetPoint("BOTTOMLEFT", goodbyeButton, "BOTTOMLEFT", 5, 0)
    goodbyeLine:SetPoint("BOTTOMRIGHT", goodbyeButton, "BOTTOMRIGHT", -5, 0)
    goodbyeLine:SetVertexColor(0.77, 0.60, 0.32, 0.72)
    goodbyeButton:SetScript("OnEnter", function()
        goodbyeText:SetTextColor(1.00, 0.87, 0.56, 1)
    end)
    goodbyeButton:SetScript("OnLeave", function()
        goodbyeText:SetTextColor(0.97, 0.78, 0.44, 1)
    end)
    goodbyeButton:SetScript("OnClick", function()
        self:Goodbye()
    end)
    self.goodbyeButton = goodbyeButton

    -- Shared panel renderer: identical art/geometry to previous accepted Quest.
    Logres.PanelSurface.Paint(root, panelConfig.surface,
        styleValue("width"), styleValue("height"))

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

    -- Installed after the objective text so every state can reset its anchors.
    self.rewardVisual = Logres.QuestRewardVisual.New(root, objectiveText)
    self.optionView = Logres.NPCOptionList.New(root)
    self.optionSession = Logres.NPCOptionSession.New(self, self.optionView)

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

    -- P0383: isolate the same live Accept/Continue/Complete button from the
    -- dialogue panel's disabled mouse ancestry. This is addon-owned UI only;
    -- it is anchored to the panel and shown solely by explicit action gates.
    local offerActionRoot =
        CreateFrame(
            "Frame",
            nil,
            UIParent
        )
    offerActionRoot:SetFrameStrata("HIGH")
    -- A UIParent sibling has no inherited dialogue level. Preserve the
    -- panel-relative hit priority for Accept/Decline as well as completion.
    local ownedLevel = readOwnedFrameValue(root, "GetFrameLevel")
    if ownedLevel then offerActionRoot:SetFrameLevel(ownedLevel + 8) end
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


    -- P0379: additive observations; visual and action OnClick owners stay intact.
    acceptButton:HookScript("OnEnter", function()
        self:RecordCompletionInput("enter")
    end)
    acceptButton:HookScript("OnLeave", function()
        self:RecordCompletionInput("leave")
    end)
    acceptButton:HookScript("OnMouseDown", function()
        self:RecordCompletionInput("down")
    end)
    acceptButton:HookScript("OnMouseUp", function()
        self:RecordCompletionInput("up")
    end)

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

    -- P0253: the same physical Accept button/root handles supported quest
    -- completion. There is no second frame, rule, label, or art treatment.
    self.completionActionRoot = offerActionRoot
    self.completionButton = acceptButton
    self.completionControl = Logres.QuestCompletionControl.New(
        self, self.completionActionRoot
    )

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
        "QUEST_GREETING",
        "QUEST_DETAIL",
        "QUEST_PROGRESS",
        "QUEST_COMPLETE",
        "GET_ITEM_INFO_RECEIVED",
        "ITEM_DATA_LOAD_RESULT",
        "GOSSIP_CLOSED",
        "QUEST_ACCEPTED",
        "QUEST_FINISHED",
        "QUEST_TURNED_IN",
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
        function(_, event, ...)
            if not self.moduleEnabled then
                return
            end

            if event == "QUEST_GREETING" then
                self:ObserveQuestGreeting()
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

            if event == "GET_ITEM_INFO_RECEIVED"
                or event == "ITEM_DATA_LOAD_RESULT"
            then
                self:HandleCompletionItemData(select(1, ...), select(2, ...))
                return
            end

            if event == "GOSSIP_CLOSED" then
                if self.progressActive or self.completionActive then
                    self:ClearActiveDetail("GOSSIP_CLOSED")
                elseif self.activeCompletion ~= nil then
                    self:ClearActiveDetail("GOSSIP_CLOSED")
                end
                return
            end

            if event == "QUEST_ACCEPTED" then
                self.acceptedEventCount =
                    self.acceptedEventCount + 1
                if self:ShouldPreserveNewOfferOnAccepted(...) then
                    -- Keep the prior identity until this event finishes;
                    -- another addon event handler may run after ours.
                    Logres:TraceEvent("quest", "late-accepted-preserved", {
                        questID = self.pendingAcceptedOfferQuestID,
                        activeQuestID = self.activeDetail.questID,
                        result = "new-offer-retained",
                    })
                    return
                end
                self.pendingAcceptedOfferQuestID = nil
                self:ClearActiveDetail(
                    "QUEST_ACCEPTED"
                )
                return
            end

            if event == "QUEST_TURNED_IN" then
                -- Event payload may be secret: never examine until proven ordinary.
                self.turninEventCount = self.turninEventCount + 1
                local questID = select(1, ...)
                local valid = false
                if type(issecretvalue) == "function" then
                    local ok, secret = pcall(issecretvalue, questID)
                    valid = ok and secret == false
                end
                local ordinaryQuestID = nil
                if valid and type(questID) == "number" and questID > 0 then
                    ordinaryQuestID = questID
                end
                self.lastTurninQuestID = ordinaryQuestID
                Logres:TraceEvent("quest", "turnin-event",
                    {questID = ordinaryQuestID, source = "QUEST_TURNED_IN",
                     result = ordinaryQuestID and "identified" or "opaque"})
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
                self.pendingAcceptedOfferQuestID = nil
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
    self.pendingAcceptedOfferQuestID = nil
    self:ClearActiveDetail(
        "module-disabled"
    )
end
