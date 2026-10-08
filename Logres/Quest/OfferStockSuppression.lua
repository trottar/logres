local _, Logres = ...

local SOURCE_COMMIT = "15666a6e67938a1ab5caf041406464251db111ca"

local RESTORE_EVENTS = {
    QUEST_ACCEPTED = true,
    QUEST_FINISHED = true,
    QUEST_PROGRESS = true,
    QUEST_COMPLETE = true,
    PLAYER_ENTERING_WORLD = true,
}

local Suppression =
    Logres:RegisterModule("QuestOfferStockSuppression", {
        autoEnable = true,
    })

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return true
    end

    local ok, secret = pcall(issecretvalue, value)
    if not ok then
        return true
    end

    return secret == true
end

local function safeBoolean(label, func, ...)
    if type(func) ~= "function" then
        return nil, label .. "-api-unavailable", false
    end

    local ok, value = pcall(func, ...)
    if not ok then
        return nil, label .. "-call-failed", false
    end

    if isSecret(value) then
        return nil, label .. "-secret", true
    end

    if type(value) ~= "boolean" then
        return nil, label .. "-invalid", false
    end

    return value, nil, false
end

local function readShown(frame, label)
    if not frame or type(frame.IsShown) ~= "function" then
        return nil, label .. "-shown-unavailable", false
    end

    return safeBoolean(label .. "-shown", frame.IsShown, frame)
end

local function readMouse(frame, label)
    if not frame or type(frame.IsMouseEnabled) ~= "function" then
        return nil, label .. "-mouse-unavailable", false
    end

    return safeBoolean(label .. "-mouse", frame.IsMouseEnabled, frame)
end

local function protectedInCombat(frame)
    local inCombat, combatError, combatSecret =
        safeBoolean("combat", InCombatLockdown)

    if inCombat == nil then
        return nil, combatError, combatSecret
    end

    if not inCombat then
        return false, nil, false
    end

    if not frame or type(frame.IsProtected) ~= "function" then
        return nil, "protected-api-unavailable", false
    end

    local protected, protectedError, protectedSecret =
        safeBoolean("protected", frame.IsProtected, frame)

    if protected == nil then
        return nil, protectedError, protectedSecret
    end

    return protected, nil, false
end

function Suppression:GetFrames()
    return _G.QuestFrameDetailPanel,
        _G.QuestFrameAcceptButton,
        _G.QuestFrameDeclineButton
end

function Suppression:RecordUnsupported(reason, secretObserved)
    self.requestedEnabled = false
    self.pending = false
    self.lastSupportReason = reason
    self.lastReason = reason
    self.unsupportedCount = self.unsupportedCount + 1

    if secretObserved then
        self.secretBlockCount = self.secretBlockCount + 1
    end
end

function Suppression:CheckSupportedOffer()
    local detailPanel, acceptButton, declineButton = self:GetFrames()

    if not detailPanel or not acceptButton or not declineButton then
        return false, "stock-controls-unavailable", false, false
    end

    local panelShown, panelError, panelSecret =
        readShown(detailPanel, "detail-panel")

    if panelShown == nil then
        return false, panelError, panelSecret, false
    end

    if not panelShown then
        return false, "detail-panel-not-shown", false, true
    end

    local autoAccept, autoError, autoSecret =
        safeBoolean("auto-accept", QuestGetAutoAccept)

    if autoAccept == nil then
        return false, autoError, autoSecret, false
    end

    if autoAccept then
        return false, "auto-accept-offer", false, false
    end

    local pvp, pvpError, pvpSecret =
        safeBoolean("pvp-offer", QuestFlagsPVP)

    if pvp == nil then
        return false, pvpError, pvpSecret, false
    end

    if pvp then
        return false, "pvp-confirmation-required", false, false
    end

    local acceptShown, acceptShownError, acceptShownSecret =
        readShown(acceptButton, "accept")
    if acceptShown == nil then
        return false, acceptShownError, acceptShownSecret, false
    end

    local declineShown, declineShownError, declineShownSecret =
        readShown(declineButton, "decline")
    if declineShown == nil then
        return false, declineShownError, declineShownSecret, false
    end

    if not acceptShown or not declineShown then
        return false, "stock-buttons-not-shown", false, false
    end

    local acceptProtected, acceptProtectedError, acceptProtectedSecret =
        protectedInCombat(acceptButton)
    if acceptProtected == nil then
        return false, acceptProtectedError, acceptProtectedSecret, false
    end

    local declineProtected, declineProtectedError, declineProtectedSecret =
        protectedInCombat(declineButton)
    if declineProtected == nil then
        return false, declineProtectedError, declineProtectedSecret, false
    end

    if acceptProtected or declineProtected then
        return false, "combat-protected", false, true
    end

    return true, "supported", false, false
end

function Suppression:CaptureButton(frame, label)
    if not frame
        or type(frame.GetAlpha) ~= "function"
        or type(frame.SetAlpha) ~= "function"
        or type(frame.EnableMouse) ~= "function"
    then
        return nil, label .. "-mutation-api-unavailable"
    end

    local mouseEnabled, mouseError, mouseSecret =
        readMouse(frame, label)

    if mouseEnabled == nil then
        if mouseSecret then
            self.secretBlockCount = self.secretBlockCount + 1
        end
        return nil, mouseError
    end

    local alphaOK, alpha = pcall(frame.GetAlpha, frame)
    if not alphaOK then
        return nil, label .. "-alpha-read-failed"
    end

    -- Alpha may be secret-capable. It is captured only as an opaque restoration
    -- token and is never inspected, compared, formatted, counted, or persisted.
    return {
        frame = frame,
        alpha = alpha,
        mouseEnabled = mouseEnabled,
        label = label,
    }, nil
end

function Suppression:CaptureSnapshot()
    local _, acceptButton, declineButton = self:GetFrames()

    local acceptSnapshot, acceptError =
        self:CaptureButton(acceptButton, "accept")
    if not acceptSnapshot then
        return nil, acceptError
    end

    local declineSnapshot, declineError =
        self:CaptureButton(declineButton, "decline")
    if not declineSnapshot then
        return nil, declineError
    end

    return {
        accept = acceptSnapshot,
        decline = declineSnapshot,
    }, nil
end

function Suppression:SuppressButton(snapshot)
    snapshot.frame:SetAlpha(0)
    snapshot.frame:EnableMouse(false)
end

function Suppression:RestoreButton(snapshot)
    snapshot.frame:SetAlpha(snapshot.alpha)
    snapshot.frame:EnableMouse(snapshot.mouseEnabled)
end

function Suppression:EmergencyRestoreButton(snapshot)
    local frame = snapshot and snapshot.frame
    if not frame then
        return false
    end

    local ok = pcall(function()
        frame:SetAlpha(1)
        frame:EnableMouse(true)
    end)

    return ok == true
end

function Suppression:EmergencyRestore(snapshot)
    if not snapshot then
        return false
    end

    local acceptOK = self:EmergencyRestoreButton(snapshot.accept)
    local declineOK = self:EmergencyRestoreButton(snapshot.decline)

    if acceptOK and declineOK then
        self.emergencyRestoreCount = self.emergencyRestoreCount + 1
        return true
    end

    return false
end

function Suppression:ApplySuppression(reason)
    if self.appliedEnabled then
        self.pending = false
        self.lastReason = reason or "already-applied"
        self.lastError = nil
        return true, "applied"
    end

    local supported, supportReason, secretObserved, retryable =
        self:CheckSupportedOffer()

    self.lastSupportReason = supportReason

    if not supported then
        if retryable then
            self.pending = true
            self.lastReason = supportReason
            if secretObserved then
                self.secretBlockCount = self.secretBlockCount + 1
            end
            return false, supportReason
        end

        self:RecordUnsupported(supportReason, secretObserved)
        return false, supportReason
    end

    local snapshot, snapshotError = self:CaptureSnapshot()
    if not snapshot then
        self.requestedEnabled = false
        self.pending = false
        self.failureCount = self.failureCount + 1
        self.lastReason = "capture-failed"
        self.lastError = snapshotError
        return false, "capture-failed"
    end

    local ok, suppressError = pcall(function()
        self:SuppressButton(snapshot.accept)
        self:SuppressButton(snapshot.decline)
    end)

    if not ok then
        local restored = pcall(function()
            self:RestoreButton(snapshot.accept)
            self:RestoreButton(snapshot.decline)
        end)

        if not restored then
            self:EmergencyRestore(snapshot)
        end

        self.requestedEnabled = false
        self.pending = false
        self.failureCount = self.failureCount + 1
        self.lastReason = "suppression-failed"
        self.lastError = tostring(suppressError)
        return false, "suppression-failed"
    end

    self.snapshot = snapshot
    self.appliedEnabled = true
    self.pending = false
    self.applyCount = self.applyCount + 1
    self.lastReason = reason or "applied"
    self.lastError = nil
    return true, "applied"
end

function Suppression:Restore(reason)
    self.requestedEnabled = false
    self.pending = false

    if not self.appliedEnabled then
        self.snapshot = nil
        self.lastReason = reason or "already-restored"
        self.lastError = nil
        return true, "restored"
    end

    local snapshot = self.snapshot
    if not snapshot then
        self.appliedEnabled = false
        self.failureCount = self.failureCount + 1
        self.lastReason = "restore-missing-snapshot"
        self.lastError = "active suppression had no restoration snapshot"
        return false, "restore-missing-snapshot"
    end

    local ok, restoreError = pcall(function()
        self:RestoreButton(snapshot.accept)
        self:RestoreButton(snapshot.decline)
    end)

    if not ok then
        local emergency = self:EmergencyRestore(snapshot)
        self.appliedEnabled = not emergency
        self.snapshot = emergency and nil or snapshot
        self.failureCount = self.failureCount + 1
        self.lastReason = emergency
            and "restore-emergency-fail-open"
            or "restore-failed"
        self.lastError = tostring(restoreError)
        return emergency, self.lastReason
    end

    self.appliedEnabled = false
    self.snapshot = nil
    self.restoreCount = self.restoreCount + 1
    self.lastReason = reason or "restored"
    self.lastError = nil
    return true, "restored"
end

function Suppression:RequestEnabled(enabled, reason)
    if enabled ~= true then
        return self:Restore(reason or "request-off")
    end

    self.requestedEnabled = true
    return self:ApplySuppression(reason or "request-on")
end

function Suppression:NotifyDialogue()
    local ok, dialogue = pcall(
        Logres.GetModule,
        Logres,
        "QuestDialogue"
    )

    if not ok
        or not dialogue
        or type(dialogue.UpdateOfferControls) ~= "function"
    then
        return
    end

    pcall(dialogue.UpdateOfferControls, dialogue)
end

function Suppression:Reconcile(reason)
    if not self.requestedEnabled then
        return false, "not-requested"
    end

    local applied, result = self:ApplySuppression(reason)
    if applied then
        self:NotifyDialogue()
    end

    return applied, result
end

function Suppression:GetDebugStatus()
    local _, acceptButton, declineButton = self:GetFrames()

    return {
        moduleEnabled = self:IsEnabled(),
        sourceCommit = SOURCE_COMMIT,
        requestedEnabled = self.requestedEnabled == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        snapshotReady = self.snapshot ~= nil,
        detailHooked = self.detailHooked == true,
        eventFrameReady = self.eventFrame ~= nil,
        acceptFound = acceptButton ~= nil,
        declineFound = declineButton ~= nil,
        applyCount = self.applyCount,
        restoreCount = self.restoreCount,
        unsupportedCount = self.unsupportedCount,
        secretBlockCount = self.secretBlockCount,
        failureCount = self.failureCount,
        emergencyRestoreCount = self.emergencyRestoreCount,
        lastSupportReason = self.lastSupportReason,
        lastReason = self.lastReason,
        lastError = self.lastError,
    }
end

function Suppression:OnInitialize()
    self.requestedEnabled = false
    self.appliedEnabled = false
    self.pending = false
    self.snapshot = nil
    self.detailHooked = false

    self.applyCount = 0
    self.restoreCount = 0
    self.unsupportedCount = 0
    self.secretBlockCount = 0
    self.failureCount = 0
    self.emergencyRestoreCount = 0

    self.lastSupportReason = "initialize"
    self.lastReason = "initialize"
    self.lastError = nil

    local detailPanel = _G.QuestFrameDetailPanel
    if detailPanel
        and type(detailPanel.HookScript) == "function"
    then
        detailPanel:HookScript("OnShow", function()
            self:Reconcile("detail-panel-onshow")
        end)

        detailPanel:HookScript("OnHide", function()
            if self.appliedEnabled or self.requestedEnabled then
                self:Restore("detail-panel-onhide")
            end
        end)

        self.detailHooked = true
    end

    local eventFrame = CreateFrame("Frame")
    eventFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_REGEN_ENABLED" then
            if self.pending and self.requestedEnabled then
                self:Reconcile("combat-ended")
            end
            return
        end

        if RESTORE_EVENTS[event]
            and (self.appliedEnabled or self.requestedEnabled)
        then
            self:Restore("event:" .. event)
        end
    end)
    self.eventFrame = eventFrame
end

function Suppression:OnEnable()
    self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.eventFrame:RegisterEvent("QUEST_ACCEPTED")
    self.eventFrame:RegisterEvent("QUEST_FINISHED")
    self.eventFrame:RegisterEvent("QUEST_PROGRESS")
    self.eventFrame:RegisterEvent("QUEST_COMPLETE")
    self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    self:OwnCleanup(function()
        self.eventFrame:UnregisterAllEvents()
    end)
end

function Suppression:OnDisable()
    local restored, result = self:Restore("module-disabled")
    if not restored then
        Logres:DevPrint(
            "QuestOfferStockSuppression restore failed: "
            .. tostring(self.lastError or result)
        )
    end
end
