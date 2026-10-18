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
        applyCount = 0, restoreCount = 0, blockedCount = 0,
        clickCount = 0, claimCalls = 0, lastResult = "not-attempted",
    }, { __index = Control })
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
    if not numeric(GetNumQuestChoices, 0) then
        return false, "choices-or-unknown" end
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
    return true, "supported"
end

function Control:Restore(reason)
    -- Remove Logres interaction first; never leave a duplicate claim target.
    self.actionRoot:Hide()
    if not self.applied then
        self.lastReason = reason or "already-restored"
        return true
    end
    local module, snapshot = self.stockModule, self.snapshot
    local ok = module and snapshot and pcall(
        module.RestoreOfferPresentation, module, snapshot
    )
    if not ok then
        ok = module and snapshot and pcall(
            module.EmergencyRestoreOfferPresentation, module, snapshot
        )
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
    self.restoreCount = self.restoreCount + 1
    self.lastReason = reason or "restored"
    return true
end

function Control:Activate()
    if self.applied then return true, "applied" end
    self.actionRoot:Hide()
    local supported, reason = self:Gate()
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
    self.expectedQuestID = self.dialogue.lastQuestID
    self.applyCount = self.applyCount + 1
    self.lastReason = "applied"
    self.actionRoot:Show()
    return true, "applied"
end

function Control:Click()
    self.clickCount = self.clickCount + 1
    local supported, reason = self:Gate()
    if not self.applied or not supported
        or self.expectedQuestID ~= self.dialogue.lastQuestID
    then
        self:Restore("stale-claim")
        self.lastResult = reason or "not-applied"
        return false, self.lastResult
    end
    -- Restore native alpha and EVERY captured mouse target before any claim.
    if not self:Restore("claim-invoked") then
        return false, "restore-failed"
    end
    self.claimCalls = self.claimCalls + 1
    local ok = pcall(_G.QuestRewardCompleteButton_OnClick)
    self.lastResult = ok and "native-handler-invoked" or "native-handler-failed"
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
        claimCalls = self.claimCalls,
    }
end
