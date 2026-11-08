-- P0251: narrow quest reward claim replacement, supported non-choice only.
-- The Blizzard QuestFrame stays shown; full mouse subtree and alpha are
-- restored BEFORE invoking the native completion handler.
local _, Logres = ...
local Control = {}
Logres.QuestCompletionControl = Control

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret ~= true
end

local function numeric(fn, expected)
    if type(fn) ~= "function" then return false end
    local ok, value = pcall(fn)
    return ok and ordinary(value) and type(value) == "number"
        and value == expected
end

local function shown(frame)
    if not frame or type(frame.IsShown) ~= "function" then return false end
    local ok, value = pcall(frame.IsShown, frame)
    return ok and ordinary(value) and value == true
end

function Control.New(dialogue, actionRoot)
    return setmetatable({
        dialogue = dialogue, actionRoot = actionRoot,
        applied = false, snapshot = nil, stockModule = nil,
        expectedQuestID = nil, lastReason = "initialize",
        choiceCount = 0, selectedChoiceIndex = nil,
        applyCount = 0, restoreCount = 0, blockedCount = 0,
        clickCount = 0, claimCalls = 0, lastResult = "not-attempted",
    }, { __index = Control })
end

-- All native choice counts are treated as potentially secret.
function Control:ReadChoiceCount()
    if type(GetNumQuestChoices) ~= "function" then
        return nil, "choice-count-api-unavailable"
    end
    local ok, count = pcall(GetNumQuestChoices)
    if not ok or not ordinary(count) or type(count) ~= "number"
        or count ~= math.floor(count) or count < 0 or count > 6
    then return nil, "choice-count-unsafe-or-overflow" end
    return count, "ordinary-choice-count"
end

function Control:Gate()
    local dialogue = self.dialogue
    if not dialogue.moduleEnabled or not dialogue.immersionEnabled
        or not dialogue.presentationShown or not dialogue.completionActive
        or dialogue.lastPresentationReason ~= "QUEST_COMPLETE"
    then return false, "not-active-completion" end
    if type(InCombatLockdown) ~= "function" then
        return false, "combat-api-unavailable" end
    local ok, inCombat = pcall(InCombatLockdown)
    if not ok or not ordinary(inCombat) or inCombat ~= false then
        return false, "combat-or-unknown" end
    if type(GetQuestID) ~= "function" then
        return false, "quest-id-api-unavailable" end
    local idOK, questID = pcall(GetQuestID)
    if not idOK or not ordinary(questID) or type(questID) ~= "number"
        or questID ~= dialogue.lastQuestID or questID <= 0
    then return false, "quest-identity-mismatch" end
    local choiceCount, choiceReason = self:ReadChoiceCount()
    if choiceCount == nil then return false, choiceReason end
    if choiceCount == 0 then
        -- Retain P0251's exact no-choice guard and native action route.
        if not numeric(GetNumQuestChoices, 0) then
            return false, "choices-or-unknown" end
    else
        -- Only a complete one-to-one, already-guarded presentation may
        -- replace Blizzard choice interaction. Missing cards fail open.
        if dialogue.completionRewardOverflow == true
            or type(dialogue.completionRewardCards) ~= "table"
        then return false, "choice-cards-incomplete" end
        local seen = {}
        for _, card in ipairs(dialogue.completionRewardCards) do
            local index = card.nativeChoiceIndex
            if index ~= nil then
                if type(index) ~= "number" or index ~= math.floor(index)
                    or index < 1 or index > choiceCount or seen[index]
                then return false, "choice-index-invalid" end
                seen[index] = true
            end
        end
        for index = 1, choiceCount do
            if not seen[index] then
                return false, "choice-card-missing"
            end
        end
        if not _G.QuestInfoFrame then
            return false, "native-choice-owner-unavailable"
        end
    end
    -- Native completion may require an expensive-quest confirmation.
    -- Keep that path in Blizzard; do not bypass the confirmation popup.
    if not numeric(GetQuestMoneyToGet, 0) then
        return false, "cost-or-unknown" end
    if type(_G.QuestRewardCompleteButton_OnClick) ~= "function" then
        return false, "native-handler-unavailable" end
    if not shown(_G.QuestFrame) or not shown(_G.QuestFrameRewardPanel)
        or not shown(_G.QuestFrameCompleteQuestButton)
    then return false, "native-reward-not-shown" end
    local button = _G.QuestFrameCompleteQuestButton
    if type(button.IsEnabled) ~= "function" then
        return false, "native-enabled-api-unavailable" end
    local enabledOK, enabled = pcall(button.IsEnabled, button)
    if not enabledOK or not ordinary(enabled) or enabled ~= true then
        return false, "native-button-disabled" end
    return true, "supported", choiceCount
end

function Control:Restore(reason)
    -- Remove Logres interaction first; never leave a duplicate claim target.
    self.actionRoot:Hide()
    self.actionRoot:EnableMouse(false)
    if not self.applied then
        self.choiceCount = 0
        self.selectedChoiceIndex = nil
        self.lastReason = reason or "already-restored"
        return true
    end
    local module, snapshot = self.stockModule, self.snapshot
    local ok = module and snapshot and pcall(
        module.RestoreOfferPresentation, module, snapshot
    )
    if not ok then
        local emergencyOK, restored = module and snapshot and pcall(
            module.EmergencyRestoreOfferPresentation, module, snapshot
        )
        ok = emergencyOK and restored == true
    end
    if not ok then
        self.lastReason = "restore-failed"
        self.lastResult = "stock-restoration-failed"
        return false
    end
    self.applied = false
    self.stockModule = nil
    self.snapshot = nil
    self.expectedQuestID = nil
    self.choiceCount = 0
    self.selectedChoiceIndex = nil
    self.restoreCount = self.restoreCount + 1
    self.lastReason = reason or "restored"
    return true
end

function Control:Activate()
    if self.applied then return true, "applied" end
    self.actionRoot:Hide()
    local supported, reason, choiceCount = self:Gate()
    if not supported then
        self.blockedCount = self.blockedCount + 1
        self.lastReason = reason
        return false, reason
    end
    local ok, module = pcall(Logres.GetModule, Logres, "QuestOfferStockSuppression")
    if not ok or not module
        or type(module.CaptureOfferPresentation) ~= "function"
        or type(module.SuppressOfferPresentation) ~= "function"
        or type(module.RestoreOfferPresentation) ~= "function"
    then
        self.lastReason = "stock-restoration-unavailable"
        return false, self.lastReason
    end
    local captureOK, snapshot, captureReason = pcall(
        module.CaptureOfferPresentation, module
    )
    if not captureOK or not snapshot or not snapshot.mouseFrames then
        self.lastReason = captureReason or "stock-capture-unavailable"
        return false, self.lastReason
    end
    -- Do not suppress any potentially protected frame, even outside combat.
    for i = 1, #snapshot.mouseFrames do
        local frame = snapshot.mouseFrames[i].frame
        if type(frame.IsProtected) ~= "function" then
            self.lastReason = "protected-status-unavailable"
            return false, self.lastReason
        end
        local protectOK, protected = pcall(frame.IsProtected, frame)
        if not protectOK or not ordinary(protected) or protected ~= false then
            self.lastReason = "protected-or-unknown-child"
            return false, self.lastReason
        end
    end
    self.stockModule = module
    self.snapshot = snapshot
    local suppressOK = pcall(module.SuppressOfferPresentation, module, snapshot)
    if not suppressOK then
        self.applied = true  -- force restoration of any partial mutation
        self:Restore("suppression-failed")
        self.lastReason = "suppression-failed"
        return false, "suppression-failed"
    end
    self.applied = true
    self.choiceCount = choiceCount or 0
    self.selectedChoiceIndex = nil
    self.expectedQuestID = self.dialogue.lastQuestID
    self.applyCount = self.applyCount + 1
    self.lastReason = "applied"
    -- Native capture is already established. Own a real hit-test root only
    -- while the existing Complete Quest button is actionable.
    self.actionRoot:EnableMouse(true)
    self.actionRoot:Show()
    return true, "applied"
end

-- Ordinals come only from the guarded live reward card model, not
-- native frame geometry or an untrusted caller-supplied item ID.
function Control:SelectChoice(index)
    if not self.applied or self.choiceCount < 1
        or type(index) ~= "number" or index ~= math.floor(index)
        or index < 1 or index > self.choiceCount
    then return false, "choice-unavailable" end
    local supported, reason, count = self:Gate()
    if not supported or count ~= self.choiceCount then
        self:Restore("choice-gate-changed")
        return false, reason or "choice-gate-changed"
    end
    self.selectedChoiceIndex = index
    Logres:TraceEvent("quest", "completion-choice-selected",
        {questID = self.dialogue.lastQuestID, choiceIndex = index})
    return true, "choice-selected"
end

function Control:Click()
    self.clickCount = self.clickCount + 1
    local supported, reason, choiceCount = self:Gate()
    if not self.applied or not supported
        or self.expectedQuestID ~= self.dialogue.lastQuestID
    then
        self:Restore("stale-claim")
        self.lastResult = reason or "not-applied"
        Logres:TraceEvent("quest", "completion-click-deferred",
            {reason = self.lastResult})
        self.dialogue:ShowCompletionStockFallback(self.lastResult)
        return false, self.lastResult
    end
    -- An unselected reward can never be claimed. Leave the Logres
    -- selection view usable rather than dismissing it on this click.
    local selectedChoiceIndex = self.selectedChoiceIndex
    if choiceCount ~= (self.choiceCount or 0) then
        self:Restore("choice-count-changed")
        return false, "choice-count-changed"
    end
    if choiceCount > 0 and (type(selectedChoiceIndex) ~= "number"
        or selectedChoiceIndex < 1 or selectedChoiceIndex > choiceCount)
    then
        self.lastResult = "choose-reward-first"
        self.dialogue:SetOfferActionFeedback("Select a reward before completing.")
        Logres:TraceEvent("quest", "completion-choice-required",
            {questID = self.dialogue.lastQuestID})
        return false, self.lastResult
    end
    -- Restore native alpha and EVERY captured mouse target before any claim.
    if not self:Restore("claim-invoked") then
        return false, "restore-failed"
    end
    -- Native visual restoration is intentionally BEFORE this handler under
    -- the P0251/P0377 contract. Journal the request to distinguish a short
    -- stock turn-in flash from an unexpected frame owner; no frame probing.
    Logres:TraceEvent("quest", "claim-stock-restore-requested",
        {questID = self.dialogue.lastQuestID, result = "before-native-handler"})
    -- The Forever native handler reads QuestInfoFrame.itemChoice.
    -- Write only an explicitly selected, bounded addon-owned index
    -- after stock restoration, without inspecting native value/state.
    if choiceCount > 0 then
        local selectedOK = pcall(function()
            _G.QuestInfoFrame.itemChoice = selectedChoiceIndex
        end)
        if not selectedOK then
            self.lastResult = "native-choice-handoff-failed"
            Logres:TraceEvent("quest", "completion-choice-handoff",
                {result = self.lastResult})
            self.dialogue:ShowCompletionStockFallback(self.lastResult)
            return false, self.lastResult
        end
    end
    self.claimCalls = self.claimCalls + 1
    local generation = self.dialogue.presentationGeneration
    local ok = pcall(_G.QuestRewardCompleteButton_OnClick)
    if ok and self.dialogue.presentationGeneration == generation then
        -- Stock was fully restored for the native call. Hold the old pane
        -- only if the client is still waiting for its asynchronous reply.
        self.dialogue:BeginNativeQuestHandoff("claim")
    end
    self.lastResult = ok and "native-handler-invoked" or "native-handler-failed"
    Logres:TraceEvent("quest", "completion-click-result",
        {result = self.lastResult})
    if not ok then self.dialogue:ShowCompletionStockFallback(self.lastResult) end
    return ok, self.lastResult
end

function Control:GetDebugStatus()
    return {
        applied = self.applied,
        shown = self.applied and self.actionRoot:IsShown() or false,
        snapshot = self.snapshot ~= nil, source = "native-handler",
        lastReason = self.lastReason, lastResult = self.lastResult,
        applyCount = self.applyCount, restoreCount = self.restoreCount,
        blockedCount = self.blockedCount, clickCount = self.clickCount,
        choiceCount = self.choiceCount,
        selectedChoiceIndex = self.selectedChoiceIndex,
        claimCalls = self.claimCalls,
    }
end
