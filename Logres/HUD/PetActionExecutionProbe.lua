local _, Logres = ...

local ActionButton = Logres.ActionButton
local MAX_PET_SLOTS = 10
local COLUMNS = 5
local ROWS = 2

local Probe = Logres:RegisterModule("PetActionExecutionProbe", {
    autoEnable = true,
})

local PET_EVENTS = {
    "PET_BAR_UPDATE",
    "PET_BAR_UPDATE_COOLDOWN",
    "PET_BAR_UPDATE_USABLE",
    "PET_UI_UPDATE",
}

local function hasSecretChecker()
    return type(issecretvalue) == "function"
end

local function isSecret(value)
    if not hasSecretChecker() then
        return true
    end

    local ok, result = pcall(issecretvalue, value)
    if not ok then
        return true
    end

    return result == true
end

local function ordinaryBoolean(value)
    if isSecret(value) then
        return nil, "secret"
    end
    if value == nil then
        return nil, "absent"
    end
    if type(value) ~= "boolean" then
        return nil, "invalid"
    end
    return value, "ordinary"
end

local function safePetHasActionBar(self)
    if type(PetHasActionBar) ~= "function" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "PetHasActionBar:api-unavailable"
        return nil, "failure"
    end

    local ok, raw = pcall(PetHasActionBar)
    if not ok then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "PetHasActionBar:call-failed"
        return nil, "failure"
    end

    if isSecret(raw) then
        self.secretSkipCount = self.secretSkipCount + 1
        self.lastSecret = "pet.hasActionBar"
        return nil, "secret"
    end

    if type(raw) ~= "boolean" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "pet.hasActionBar:unexpected-" .. type(raw)
        return nil, "failure"
    end

    return raw, "ordinary"
end

function Probe:ResetAttempt()
    self.pendingAttempt = false
    self.postClickSeen = false
    self.attemptCount = 0
    self.clickCount = 0
    self.lastClickedSlot = nil
    self.lastClickButton = nil
    self.preActive = nil
    self.postActive = nil
    self.preActiveState = nil
    self.postActiveState = nil
    self.preAutocast = nil
    self.postAutocast = nil
    self.preAutocastState = nil
    self.postAutocastState = nil
    self.followupEventCount = 0
    self.lastFollowupEvent = nil
    self.activeStateChanged = false
    self.autocastStateChanged = false
end

function Probe:ConfigureSecureButtons()
    if InCombatLockdown() then
        self.pendingConfigure = true
        self.lastSetupReason = "combat-lockdown"
        return false, self.lastSetupReason
    end

    for slot = 1, MAX_PET_SLOTS do
        if not ActionButton.RegisterPet(self.buttons[slot], slot) then
            self.failureCount = self.failureCount + 1
            self.lastFailure = "register-pet-slot:" .. tostring(slot)
            self.configured = false
            return false, self.lastFailure
        end
    end

    self.configured = true
    self.pendingConfigure = false
    self.lastSetupReason = "configured"
    return true, self.lastSetupReason
end

function Probe:CaptureActiveState(slot)
    if type(GetPetActionInfo) ~= "function" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "GetPetActionInfo:api-unavailable"
        return nil, "failure"
    end

    local ok, _rawName, _rawTexture, _rawIsToken, rawIsActive =
        pcall(GetPetActionInfo, slot)
    if not ok then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "GetPetActionInfo:call-failed"
        return nil, "failure"
    end

    local value, state = ordinaryBoolean(rawIsActive)
    if state == "secret" then
        self.secretSkipCount = self.secretSkipCount + 1
        self.lastSecret = "pet.isActive"
    elseif state == "invalid" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "pet.isActive:unexpected-" .. type(rawIsActive)
    end

    return value, state
end

function Probe:CaptureAutocastState(slot)
    if type(GetPetActionInfo) ~= "function" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "GetPetActionInfo:api-unavailable"
        return nil, "failure"
    end

    local ok, _name, _texture, _isToken, _isActive,
        rawAllowed, rawEnabled = pcall(GetPetActionInfo, slot)
    if not ok then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "GetPetActionInfo:call-failed"
        return nil, "failure"
    end

    local allowed, allowedState = ordinaryBoolean(rawAllowed)
    if allowedState == "secret" then
        self.secretSkipCount = self.secretSkipCount + 1
        self.lastSecret = "pet.autoCastAllowed"
        return nil, "secret"
    end
    if allowedState == "invalid" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "pet.autoCastAllowed:unexpected-" .. type(rawAllowed)
        return nil, "failure"
    end
    if allowed ~= true then
        return nil, "not-capable"
    end

    local enabled, enabledState = ordinaryBoolean(rawEnabled)
    if enabledState == "secret" then
        self.secretSkipCount = self.secretSkipCount + 1
        self.lastSecret = "pet.autoCastEnabled"
    elseif enabledState == "invalid" then
        self.failureCount = self.failureCount + 1
        self.lastFailure = "pet.autoCastEnabled:unexpected-" .. type(rawEnabled)
    end

    return enabled, enabledState
end

function Probe:RefreshPresentation()
    local hasBar, barState = safePetHasActionBar(self)
    self.petHasActionBar = hasBar
    self.petBarState = barState
    self.occupiedCount = 0

    for slot = 1, MAX_PET_SLOTS do
        local state = ActionButton.UpdatePet(self.buttons[slot], slot)
        if state and state.occupied == true then
            self.occupiedCount = self.occupiedCount + 1
        end
    end

    return hasBar == true and self.occupiedCount > 0
end

function Probe:AfterSecureClick(slot, mouseButton)
    self.pendingAttempt = true
    self.postClickSeen = true
    self.attemptCount = self.attemptCount + 1
    self.clickCount = self.clickCount + 1
    self.lastClickedSlot = slot
    self.lastClickButton = mouseButton
    self.followupEventCount = 0
    self.lastFollowupEvent = nil

    local baselineActive = self.baselineActive and self.baselineActive[slot] or nil
    local baselineActiveState = self.baselineActiveState
        and self.baselineActiveState[slot] or nil
    self.preActive = baselineActive
    self.preActiveState = baselineActiveState
    self.postActive, self.postActiveState = self:CaptureActiveState(slot)

    if baselineActiveState == "ordinary"
        and self.postActiveState == "ordinary"
        and baselineActive ~= self.postActive
    then
        self.activeStateChanged = true
    end

    if mouseButton == "RightButton" then
        local current = self.buttons and self.buttons[slot]
        self.lastAutocastSlot = slot
        if current and current.petAutocastMacroReady == true then
            self.autocastToggleCount = self.autocastToggleCount + 1
            self.lastAutocastReason = "secure-macro"
        else
            self.lastAutocastReason = "not-autocast-capable"
        end
        local baselineAutocast = self.baselineAutocast
            and self.baselineAutocast[slot] or nil
        local baselineAutocastState = self.baselineAutocastState
            and self.baselineAutocastState[slot] or nil
        self.preAutocast = baselineAutocast
        self.preAutocastState = baselineAutocastState
        self.postAutocast, self.postAutocastState =
            self:CaptureAutocastState(slot)

        if baselineAutocastState == "ordinary"
            and self.postAutocastState == "ordinary"
            and baselineAutocast ~= self.postAutocast
        then
            self.autocastStateChanged = true
        end
    end

    self:RefreshPresentation()
end

function Probe:CaptureFollowup(event)
    if not self.pendingAttempt or not self.lastClickedSlot then
        return
    end

    self.followupEventCount = self.followupEventCount + 1
    self.lastFollowupEvent = event

    local slot = self.lastClickedSlot
    local active, activeState = self:CaptureActiveState(slot)
    self.postActive = active
    self.postActiveState = activeState

    local baselineActive = self.baselineActive and self.baselineActive[slot] or nil
    local baselineActiveState = self.baselineActiveState
        and self.baselineActiveState[slot] or nil
    if baselineActiveState == "ordinary"
        and activeState == "ordinary"
        and baselineActive ~= active
    then
        self.activeStateChanged = true
    end

    if self.lastClickButton == "RightButton" then
        local autocast, autocastState = self:CaptureAutocastState(slot)
        self.postAutocast = autocast
        self.postAutocastState = autocastState

        local baselineAutocast = self.baselineAutocast
            and self.baselineAutocast[slot] or nil
        local baselineAutocastState = self.baselineAutocastState
            and self.baselineAutocastState[slot] or nil
        if baselineAutocastState == "ordinary"
            and autocastState == "ordinary"
            and baselineAutocast ~= autocast
        then
            self.autocastStateChanged = true
        end
    end
end

function Probe:ApplyLayout()
    if InCombatLockdown() then
        return false
    end

    self.cluster:ClearAllPoints()
    self.cluster:SetPoint("CENTER", UIParent, "CENTER", -375, -160)

    local bound =
        Logres.Layout.Bind(
            self.cluster,
            "classPet",
            "CENTER",
            "CENTER"
        )

    if bound then
        self.layoutAnchor = "classPet"
    else
        self.layoutAnchor = "lower-left-fallback"
    end

    return true
end

function Probe:Arm()
    if InCombatLockdown() then
        self.lastArmReason = "combat-lockdown"
        return false, self.lastArmReason
    end

    local configured = self:ConfigureSecureButtons()
    if not configured then
        self.lastArmReason = self.lastSetupReason
        return false, self.lastArmReason
    end

    self:ApplyLayout()

    self.failureCount = 0
    self.secretSkipCount = 0
    self.lastFailure = nil
    self.lastSecret = nil
    self.autocastToggleCount = 0
    self.lastAutocastSlot = nil
    self.lastAutocastReason = nil
    self.baselineActive = {}
    self.baselineActiveState = {}
    self.baselineAutocast = {}
    self.baselineAutocastState = {}
    self:ResetAttempt()

    local available = self:RefreshPresentation()
    if not available then
        self.lastArmReason = self.petBarState == "ordinary"
            and "pet-action-bar-absent-or-empty"
            or "pet-action-bar-unavailable"
        self.armed = false
        self.cluster:Hide()
        return false, self.lastArmReason
    end

    self.baselineActive = {}
    self.baselineActiveState = {}
    self.baselineAutocast = {}
    self.baselineAutocastState = {}
    for slot = 1, MAX_PET_SLOTS do
        self.baselineActive[slot], self.baselineActiveState[slot] =
            self:CaptureActiveState(slot)
        self.baselineAutocast[slot], self.baselineAutocastState[slot] =
            self:CaptureAutocastState(slot)
    end

    self.armCount = self.armCount + 1
    self.armed = true
    self.lastArmReason = "armed"
    self.cluster:Show()
    return true, self.lastArmReason
end

function Probe:Check()
    if self.lastClickedSlot then
        local slot = self.lastClickedSlot
        local active, activeState = self:CaptureActiveState(slot)
        self.postActive = active
        self.postActiveState = activeState

        local baselineActive = self.baselineActive and self.baselineActive[slot] or nil
        local baselineActiveState = self.baselineActiveState
            and self.baselineActiveState[slot] or nil
        if baselineActiveState == "ordinary"
            and activeState == "ordinary"
            and baselineActive ~= active
        then
            self.activeStateChanged = true
        end

        if self.lastClickButton == "RightButton" then
            local autocast, autocastState = self:CaptureAutocastState(slot)
            self.postAutocast = autocast
            self.postAutocastState = autocastState
            local baselineAutocast = self.baselineAutocast
                and self.baselineAutocast[slot] or nil
            local baselineAutocastState = self.baselineAutocastState
                and self.baselineAutocastState[slot] or nil
            if baselineAutocastState == "ordinary"
                and autocastState == "ordinary"
                and baselineAutocast ~= autocast
            then
                self.autocastStateChanged = true
            end
        end
    end

    self:RefreshPresentation()
    return self:GetResultState()
end

function Probe:HideProbe()
    if InCombatLockdown() then
        self.lastHideReason = "combat-lockdown"
        return false, self.lastHideReason
    end

    self.cluster:Hide()
    self.armed = false
    self.pendingAttempt = false
    self.lastHideReason = "hidden"
    return true, self.lastHideReason
end

function Probe:GetResultState()
    if self.failureCount > 0 then
        return "FAIL"
    end
    if self.petBarState == "ordinary" and self.petHasActionBar ~= true then
        return "DEFERRED"
    end
    if not self.armed then
        return "READY"
    end
    if self.clickCount == 0 then
        return "READY"
    end
    if self.postClickSeen
        and self.followupEventCount > 0
        and (self.activeStateChanged or self.autocastStateChanged)
    then
        return "PASS"
    end
    return "PENDING"
end

function Probe:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled,
        configured = self.configured,
        pendingConfigure = self.pendingConfigure,
        armed = self.armed,
        visible = self.cluster and self.cluster:IsShown() or false,
        layoutAnchor = self.layoutAnchor,
        armCount = self.armCount,
        attemptCount = self.attemptCount,
        clickCount = self.clickCount,
        lastClickedSlot = self.lastClickedSlot,
        lastClickButton = self.lastClickButton,
        followupEventCount = self.followupEventCount,
        lastFollowupEvent = self.lastFollowupEvent,
        preActive = self.preActive,
        postActive = self.postActive,
        preActiveState = self.preActiveState,
        postActiveState = self.postActiveState,
        activeStateChanged = self.activeStateChanged,
        preAutocast = self.preAutocast,
        postAutocast = self.postAutocast,
        preAutocastState = self.preAutocastState,
        postAutocastState = self.postAutocastState,
        autocastStateChanged = self.autocastStateChanged,
        petHasActionBar = self.petHasActionBar,
        occupiedCount = self.occupiedCount,
        autocastToggleCount = self.autocastToggleCount,
        lastAutocastSlot = self.lastAutocastSlot,
        lastAutocastReason = self.lastAutocastReason,
        secretSkipCount = self.secretSkipCount,
        failureCount = self.failureCount,
        lastSecret = self.lastSecret,
        lastFailure = self.lastFailure,
        combat = InCombatLockdown(),
        result = self:GetResultState(),
    }
end

function Probe:GetDiagnosticLines()
    local status = self:GetDebugStatus()
    return {
        string.format(
            "cluster=configured:%s armed:%s visible:%s anchor:%s occupied:%s combat:%s",
            tostring(status.configured),
            tostring(status.armed),
            tostring(status.visible),
            tostring(status.layoutAnchor),
            tostring(status.occupiedCount),
            tostring(status.combat)
        ),
        string.format(
            "attempt=attempts:%s clicks:%s slot:%s button:%s pre:%s/%s post:%s/%s changed:%s",
            tostring(status.attemptCount),
            tostring(status.clickCount),
            tostring(status.lastClickedSlot),
            tostring(status.lastClickButton),
            tostring(status.preActive),
            tostring(status.preActiveState),
            tostring(status.postActive),
            tostring(status.postActiveState),
            tostring(status.activeStateChanged)
        ),
        string.format(
            "autocast=clicks:%s slot:%s pre:%s/%s post:%s/%s changed:%s",
            tostring(status.autocastToggleCount),
            tostring(status.lastAutocastSlot),
            tostring(status.preAutocast),
            tostring(status.preAutocastState),
            tostring(status.postAutocast),
            tostring(status.postAutocastState),
            tostring(status.autocastStateChanged)
        ),
        string.format(
            "followup=events:%s last:%s postClick:%s secretSkips:%s failures:%s lastSecret:%s lastFailure:%s",
            tostring(status.followupEventCount),
            tostring(status.lastFollowupEvent),
            tostring(self.postClickSeen),
            tostring(status.secretSkipCount),
            tostring(status.failureCount),
            tostring(status.lastSecret),
            tostring(status.lastFailure)
        ),
    }
end

Probe.OnInitialize = function(self)
    self.moduleEnabled = false
    self.buttons = {}
    self.configured = false
    self.pendingConfigure = false
    self.armed = false
    self.armCount = 0
    self.failureCount = 0
    self.secretSkipCount = 0
    self.lastFailure = nil
    self.lastSecret = nil
    self.petHasActionBar = nil
    self.petBarState = nil
    self.occupiedCount = 0
    self.autocastToggleCount = 0
    self.lastAutocastSlot = nil
    self.lastAutocastReason = nil
    self:ResetAttempt()

    local cluster = ActionButton.CreateCluster(
        "LogresPetActionExecutionProbeCluster",
        COLUMNS,
        ROWS,
        0,
        0,
        1
    )
    self.cluster = cluster
    self:ApplyLayout()
    cluster:Hide()

    for slot = 1, MAX_PET_SLOTS do
        local button = ActionButton.Create(
            "LogresPetActionExecutionButton" .. slot,
            cluster,
            slot,
            COLUMNS
        )

        ActionButton.SetHotkeyLabel(button, "")

        button:HookScript("PostClick", function(current, mouseButton)
            if mouseButton == "LeftButton" or mouseButton == "RightButton" then
                self:AfterSecureClick(current.petActionSlot, mouseButton)
            end
        end)

        self.buttons[slot] = button
    end

    local eventFrame = CreateFrame("Frame")
    eventFrame:SetScript("OnEvent", function(_, event, unit)
        if event == "PLAYER_REGEN_ENABLED" then
            if self.pendingConfigure then
                self:ConfigureSecureButtons()
            end
            return
        end

        if event == "UNIT_PET" and unit ~= "player" then
            return
        end

        if self.armed then
            self:RefreshPresentation()
        end
        self:CaptureFollowup(event)
    end)

    self.eventFrame = eventFrame
end

Probe.OnEnable = function(self)
    self.moduleEnabled = true

    for index = 1, #PET_EVENTS do
        self.eventFrame:RegisterEvent(PET_EVENTS[index])
    end
    self.eventFrame:RegisterUnitEvent("UNIT_PET", "player")
    self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

    self:OwnCleanup(function()
        self.eventFrame:UnregisterAllEvents()
    end)

    self:ConfigureSecureButtons()
end

Probe.OnDisable = function(self)
    self.moduleEnabled = false

    if not InCombatLockdown() then
        self.cluster:Hide()
        self.armed = false
    end
end
