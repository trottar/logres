local _, Logres = ...

local WORLD_TARGET = 5
local CITY_TARGET = 5
local COMBAT_TARGET = 15
local TRANSITION_DURATION = 2.5
local TRANSITION_TIMEOUT_EXTRA = 0.75
local TARGET_TOLERANCE = 0.25

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function readZoom()
    if type(GetCameraZoom) ~= "function" then
        return nil, "GetCameraZoom unavailable", false
    end

    local ok, value = pcall(GetCameraZoom)
    if not ok then
        return nil, tostring(value), false
    end

    if isSecret(value) then
        return nil, "GetCameraZoom returned secret value", true
    end

    if type(value) ~= "number" then
        return nil, "GetCameraZoom returned non-number", false
    end

    return value, nil, false
end

local function readZoomSpeed()
    if type(GetCVar) ~= "function" then
        return nil, "GetCVar unavailable", false
    end

    local ok, value = pcall(GetCVar, "cameraZoomSpeed")
    if not ok then
        return nil, tostring(value), false
    end

    if isSecret(value) then
        return nil, "cameraZoomSpeed returned secret value", true
    end

    local numberValue = tonumber(value)
    if not numberValue or numberValue <= 0 then
        return nil, "cameraZoomSpeed unavailable or invalid", false
    end

    return numberValue, nil, false
end

local function readBoolean(func, ...)
    if type(func) ~= "function" then
        return nil, "required boolean API unavailable", false
    end

    local ok, value = pcall(func, ...)
    if not ok then
        return nil, tostring(value), false
    end

    if isSecret(value) then
        return nil, "required boolean API returned secret value", true
    end

    return value and true or false, nil, false
end

local function queryDynamicCamLoaded()
    if C_AddOns and type(C_AddOns.IsAddOnLoaded) == "function" then
        local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, "DynamicCam")
        if ok then
            if isSecret(loaded) then
                return false, false, "C_AddOns-secret"
            end
            return loaded and true or false, true, "C_AddOns"
        end
    end

    if type(IsAddOnLoaded) == "function" then
        local ok, loaded = pcall(IsAddOnLoaded, "DynamicCam")
        if ok then
            if isSecret(loaded) then
                return false, false, "legacy-secret"
            end
            return loaded and true or false, true, "legacy"
        end
    end

    return false, false, "unavailable"
end

local function stopMotion()
    local firstError
    local calls = {
        { MoveViewOutStart, 0 },
        { MoveViewInStart, 0 },
        { MoveViewInStop },
        { MoveViewOutStop },
    }

    for index = 1, #calls do
        local call = calls[index]
        local func = call[1]
        local ok, callError

        if type(func) ~= "function" then
            if not firstError then
                firstError = "camera stop API unavailable"
            end
        elseif call[2] ~= nil then
            ok, callError = pcall(func, call[2])
            if not ok and not firstError then
                firstError = tostring(callError)
            end
        else
            ok, callError = pcall(func)
            if not ok and not firstError then
                firstError = tostring(callError)
            end
        end
    end

    return firstError == nil, firstError
end

local Controller = Logres:RegisterModule("CameraWorldCombat", {
    OnInitialize = function(self)
        local frame = CreateFrame("Frame")
        frame:Hide()

        self.frame = frame
        self.moduleEnabled = false
        self.apiAvailable = false
        self.ownsContext = false
        self.selectedContext = "none"
        self.transitionActive = false
        self.transitionContext = nil
        self.transitionStartZoom = nil
        self.transitionTargetZoom = nil
        self.transitionStartTime = nil
        self.transitionDirection = nil
        self.lastCurrentZoom = nil
        self.lastFinalZoom = nil
        self.lastZoomSpeed = nil
        self.lastTransitionElapsed = nil
        self.lastTargetReached = false
        self.lastAction = "initialize"
        self.lastReason = "initialize"
        self.lastStopReason = nil
        self.lastBlockedReason = nil
        self.lastError = nil
        self.lastSecret = false
        self.lastLiveCombat = false
        self.lastLockdown = false
        self.lastCachedCombat = false
        self.lastCombatMismatch = false
        self.lastResting = false
        self.lastStateRevision = 0
        self.lastDynamicCamLoaded = false
        self.lastDynamicCamStatusKnown = false
        self.lastDynamicCamStatusSource = nil
        self.reconcileCount = 0
        self.transitionStartCount = 0
        self.transitionCompleteCount = 0
        self.transitionStopCount = 0
        self.noOpCount = 0
        self.blockedCount = 0
        self.relinquishCount = 0
        self.failureCount = 0
    end,

    OnEnable = function(self)
        self.moduleEnabled = true

        self:SubscribeState(function(_, _, _, reason)
            self:Reconcile("state:" .. tostring(reason))
        end)

        self:Reconcile("enable")
    end,

    OnDisable = function(self)
        self.moduleEnabled = false
        self.ownsContext = false
        self.selectedContext = "none"
        self:StopTransition("module-disabled", false)
        self.lastAction = "disabled"
        self.lastReason = "module-disabled"
    end,
})

function Controller:SetAnimationActive(active)
    if active then
        self.frame:SetScript("OnUpdate", function()
            self:OnUpdate()
        end)
        self.frame:Show()
        return
    end

    self.frame:SetScript("OnUpdate", nil)
    self.frame:Hide()
end

function Controller:ValidateAPIs()
    local required = {
        GetCameraZoom,
        GetCVar,
        UnitAffectingCombat,
        InCombatLockdown,
        MoveViewInStart,
        MoveViewInStop,
        MoveViewOutStart,
        MoveViewOutStop,
    }

    for index = 1, #required do
        if type(required[index]) ~= "function" then
            self.apiAvailable = false
            return false, "required camera API unavailable"
        end
    end

    self.apiAvailable = true
    return true, nil
end

function Controller:StopTransition(reason, countAsStop)
    local wasActive = self.transitionActive
    local stopOK, stopError = stopMotion()

    self.transitionActive = false
    self.transitionContext = nil
    self.transitionDirection = nil
    self.transitionStartTime = nil
    self:SetAnimationActive(false)
    self.lastStopReason = reason

    if wasActive and countAsStop ~= false then
        self.transitionStopCount = self.transitionStopCount + 1
    end

    if not stopOK then
        self.lastError = stopError
        self.failureCount = self.failureCount + 1
        self.lastAction = "stop-failed"
        return false, stopError
    end

    return true, nil
end

function Controller:Relinquish(reason, blocked)
    local hadOwnership = self.ownsContext or self.transitionActive
    self:StopTransition(reason, self.transitionActive)
    self.ownsContext = false
    self.selectedContext = "none"
    self.lastReason = reason

    if blocked then
        self.lastAction = "blocked"
        self.lastBlockedReason = reason
        self.blockedCount = self.blockedCount + 1
    else
        self.lastAction = "relinquished"
        self.lastBlockedReason = nil
        if hadOwnership then
            self.relinquishCount = self.relinquishCount + 1
        end
    end
end

function Controller:ReadContext()
    local state = Logres:GetState()
    self.lastStateRevision = state.revision or 0
    self.lastCachedCombat = state.combat == true

    local liveCombat, combatError, combatSecret =
        readBoolean(UnitAffectingCombat, "player")
    if liveCombat == nil then
        return nil, combatError, combatSecret
    end

    local lockdown, lockdownError, lockdownSecret =
        readBoolean(InCombatLockdown)
    if lockdown == nil then
        return nil, lockdownError, lockdownSecret
    end

    self.lastLiveCombat = liveCombat
    self.lastLockdown = lockdown
    self.lastCombatMismatch =
        self.lastLiveCombat ~= self.lastCachedCombat
    self.lastResting = state.resting == true

    if not state.initialized then
        return "none", "state-uninitialized", false
    end

    if state.inInstance then
        return "none", "outside-slice:instance", false
    end

    if state.onTaxi then
        return "none", "outside-slice:taxi", false
    end

    if state.interacting then
        return "none", "outside-slice:interaction", false
    end

    if liveCombat then
        return "combat", "live-combat", false
    end

    if state.resting then
        return "city", "resting-city", false
    end

    return "world", "world", false
end

function Controller:CheckCoexistence()
    local loaded, known, source = queryDynamicCamLoaded()
    self.lastDynamicCamLoaded = loaded
    self.lastDynamicCamStatusKnown = known
    self.lastDynamicCamStatusSource = source

    if not known then
        return false, "dynamiccam-status-unknown"
    end

    if loaded then
        return false, "dynamiccam-loaded"
    end

    local probe = Logres:GetModule("CameraCapabilityProbe")
    local probeStatus = probe:GetDebugStatus()
    if probeStatus.running then
        return false, "camera-probe-running"
    end

    return true, nil
end

function Controller:BeginTransition(context, currentZoom, targetZoom)
    local zoomSpeed, speedError, speedSecret = readZoomSpeed()
    if zoomSpeed == nil then
        self.lastSecret = speedSecret and true or false
        self.lastError = speedError
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-failed"
        self:Relinquish("zoom-speed-failed", false)
        return false, speedError
    end

    local delta = targetZoom - currentZoom
    local desiredUnitsPerSecond =
        math.abs(delta) / TRANSITION_DURATION
    local factor = desiredUnitsPerSecond / zoomSpeed

    local stopOK, stopError = stopMotion()
    if not stopOK then
        self.lastError = stopError
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-failed"
        self:Relinquish("pre-transition-stop-failed", false)
        return false, stopError
    end

    local moveFunc
    local direction
    if delta > 0 then
        moveFunc = MoveViewOutStart
        direction = "out"
    else
        moveFunc = MoveViewInStart
        direction = "in"
    end

    local ok, moveError = pcall(moveFunc, factor)
    if not ok then
        self.lastError = tostring(moveError)
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-failed"
        self:Relinquish("move-start-failed", false)
        return false, self.lastError
    end

    self.lastZoomSpeed = zoomSpeed
    self.lastCurrentZoom = currentZoom
    self.lastFinalZoom = nil
    self.lastTransitionElapsed = nil
    self.lastTargetReached = false
    self.transitionActive = true
    self.transitionContext = context
    self.transitionStartZoom = currentZoom
    self.transitionTargetZoom = targetZoom
    self.transitionStartTime = GetTime()
    self.transitionDirection = direction
    self.transitionStartCount = self.transitionStartCount + 1
    self.lastAction = "transition-started"
    self.lastReason = context
    self:SetAnimationActive(true)

    return true, "transition-started"
end

function Controller:FinishTransition(currentZoom, elapsed, timedOut)
    local targetZoom = self.transitionTargetZoom
    local stopOK, stopError = self:StopTransition(
        timedOut and "transition-timeout" or "transition-complete",
        false
    )

    self.lastFinalZoom = currentZoom
    self.lastTransitionElapsed = elapsed
    self.lastTargetReached =
        type(targetZoom) == "number"
        and math.abs(currentZoom - targetZoom) <= TARGET_TOLERANCE

    if not stopOK then
        self.lastAction = "transition-failed"
        return
    end

    if timedOut and not self.lastTargetReached then
        self.lastError = "camera transition timed out before target"
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-timeout"
        return
    end

    self.lastError = nil
    self.transitionCompleteCount = self.transitionCompleteCount + 1
    self.lastAction = "transition-complete"
end

function Controller:OnUpdate()
    if not self.transitionActive then
        self:SetAnimationActive(false)
        return
    end

    local currentZoom, zoomError, zoomSecret = readZoom()
    if currentZoom == nil then
        self.lastSecret = zoomSecret and true or false
        self.lastError = zoomError
        self.failureCount = self.failureCount + 1
        self:Relinquish("transition-read-failed", false)
        return
    end

    local elapsed = GetTime() - self.transitionStartTime
    local targetZoom = self.transitionTargetZoom
    local delta = targetZoom - self.transitionStartZoom
    local reached =
        math.abs(currentZoom - targetZoom) <= TARGET_TOLERANCE
        or (delta > 0 and currentZoom >= targetZoom)
        or (delta < 0 and currentZoom <= targetZoom)
    local timedOut =
        elapsed >= (TRANSITION_DURATION + TRANSITION_TIMEOUT_EXTRA)

    if reached or timedOut then
        self:FinishTransition(currentZoom, elapsed, timedOut)
    end
end

function Controller:Reconcile(reason)
    if not self.moduleEnabled then
        return false, "camera controller disabled"
    end

    self.reconcileCount = self.reconcileCount + 1
    self.lastReason = tostring(reason or "reconcile")
    self.lastError = nil
    self.lastSecret = false
    self.lastBlockedReason = nil

    local apiOK, apiError = self:ValidateAPIs()
    if not apiOK then
        self.lastError = apiError
        self.failureCount = self.failureCount + 1
        self:Relinquish("api-unavailable", false)
        return false, apiError
    end

    local coexistenceOK, coexistenceReason = self:CheckCoexistence()
    if not coexistenceOK then
        self:Relinquish(coexistenceReason, true)
        return false, coexistenceReason
    end

    local context, contextReason, contextSecret = self:ReadContext()
    if context == nil then
        self.lastSecret = contextSecret and true or false
        self.lastError = contextReason
        self.failureCount = self.failureCount + 1
        self:Relinquish("context-read-failed", false)
        return false, contextReason
    end

    if context == "none" then
        self:Relinquish(contextReason, false)
        return true, contextReason
    end

    local targetZoom = WORLD_TARGET
    if context == "combat" then
        targetZoom = COMBAT_TARGET
    elseif context == "city" then
        targetZoom = CITY_TARGET
    end

    if self.transitionActive
        and self.transitionContext == context
        and self.transitionTargetZoom == targetZoom
    then
        self.selectedContext = context
        self.ownsContext = true
        self.lastAction = "transition-continues"
        return true, "transition-continues"
    end

    if self.transitionActive then
        local stopOK, stopError = self:StopTransition(
            "context-reconcile",
            true
        )
        if not stopOK then
            self:Relinquish("context-stop-failed", false)
            return false, stopError
        end
    end

    self.selectedContext = context
    self.ownsContext = true

    local currentZoom, zoomError, zoomSecret = readZoom()
    if currentZoom == nil then
        self.lastSecret = zoomSecret and true or false
        self.lastError = zoomError
        self.failureCount = self.failureCount + 1
        self:Relinquish("zoom-read-failed", false)
        return false, zoomError
    end

    self.lastCurrentZoom = currentZoom
    self.transitionTargetZoom = targetZoom

    local needsTransition =
        (context == "world" and currentZoom > WORLD_TARGET)
        or (context == "city" and currentZoom > CITY_TARGET)
        or (context == "combat" and currentZoom < COMBAT_TARGET)

    if not needsTransition then
        self.noOpCount = self.noOpCount + 1
        self.lastAction = "noop"
        self.lastTargetReached = true
        return true, "noop"
    end

    return self:BeginTransition(context, currentZoom, targetZoom)
end

function Controller:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled,
        apiAvailable = self.apiAvailable,
        ownsContext = self.ownsContext,
        selectedContext = self.selectedContext,
        transitionActive = self.transitionActive,
        transitionContext = self.transitionContext,
        transitionStartZoom = self.transitionStartZoom,
        transitionTargetZoom = self.transitionTargetZoom,
        transitionDirection = self.transitionDirection,
        lastCurrentZoom = self.lastCurrentZoom,
        lastFinalZoom = self.lastFinalZoom,
        lastZoomSpeed = self.lastZoomSpeed,
        lastTransitionElapsed = self.lastTransitionElapsed,
        lastTargetReached = self.lastTargetReached,
        lastAction = self.lastAction,
        lastReason = self.lastReason,
        lastStopReason = self.lastStopReason,
        lastBlockedReason = self.lastBlockedReason,
        lastError = self.lastError,
        lastSecret = self.lastSecret,
        lastLiveCombat = self.lastLiveCombat,
        lastLockdown = self.lastLockdown,
        lastCachedCombat = self.lastCachedCombat,
        lastCombatMismatch = self.lastCombatMismatch,
        lastResting = self.lastResting,
        lastStateRevision = self.lastStateRevision,
        lastDynamicCamLoaded = self.lastDynamicCamLoaded,
        lastDynamicCamStatusKnown = self.lastDynamicCamStatusKnown,
        lastDynamicCamStatusSource = self.lastDynamicCamStatusSource,
        reconcileCount = self.reconcileCount,
        transitionStartCount = self.transitionStartCount,
        transitionCompleteCount = self.transitionCompleteCount,
        transitionStopCount = self.transitionStopCount,
        noOpCount = self.noOpCount,
        blockedCount = self.blockedCount,
        relinquishCount = self.relinquishCount,
        failureCount = self.failureCount,
    }
end

local function reconcileFromEvent(event, ...)
    if not Controller:IsEnabled() then
        return
    end

    if event == "ADDON_LOADED" then
        local loadedAddon = ...
        if loadedAddon ~= "DynamicCam" then
            return
        end
    end

    Controller:Reconcile(event)
end

Logres:RegisterEvent("PLAYER_REGEN_DISABLED", reconcileFromEvent)
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", reconcileFromEvent)
Logres:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED", reconcileFromEvent)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", reconcileFromEvent)
Logres:RegisterEvent("ADDON_LOADED", reconcileFromEvent)
