local _, Logres = ...

local WORLD_TARGET = 5
local CITY_TARGET = 5
local COMBAT_TARGET = 15
local TAXI_TARGET = 50
local TRANSITION_DURATION = 2.5
local TAXI_TRANSITION_DURATION = 5
local TRANSITION_TIMEOUT_EXTRA = 0.75
local TARGET_TOLERANCE = 0.25
local CAMERA_DISTANCE_SCALE = 15
local NOMINAL_FRAME_INTERVAL = 1 / 60

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

local function readCameraDistanceFactor()
    if type(GetCVar) ~= "function" then
        return nil, nil, "GetCVar unavailable", false
    end

    local ok, value = pcall(GetCVar, "cameraDistanceMaxZoomFactor")
    if not ok then
        return nil, nil, tostring(value), false
    end

    if isSecret(value) then
        return nil, nil, "cameraDistanceMaxZoomFactor returned secret value", true
    end

    local factor = tonumber(value)
    if not factor or factor <= 0 then
        return nil, nil, "cameraDistanceMaxZoomFactor unavailable or invalid", false
    end

    return factor, factor * CAMERA_DISTANCE_SCALE, nil, false
end

local function transitionDurationForContext(context)
    if context == "taxi" then
        return TAXI_TRANSITION_DURATION
    end

    return TRANSITION_DURATION
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

local function stopMotionDirection(direction)
    local startFunc
    local stopFunc

    if direction == "in" then
        startFunc = MoveViewInStart
        stopFunc = MoveViewInStop
    elseif direction == "out" then
        startFunc = MoveViewOutStart
        stopFunc = MoveViewOutStop
    else
        return false, "invalid camera motion direction"
    end

    local startOK, startError = pcall(startFunc, 0)
    if not startOK then
        return false, tostring(startError)
    end

    local stopOK, stopError = pcall(stopFunc)
    if not stopOK then
        return false, tostring(stopError)
    end

    return true, nil
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
        self.transitionRequestedZoom = nil
        self.transitionEffectiveTargetZoom = nil
        self.transitionDuration = nil
        self.transitionStartTime = nil
        self.transitionDirection = nil
        self.transitionSampleCount = 0
        self.transitionTowardCount = 0
        self.transitionAwayCount = 0
        self.transitionFlatCount = 0
        self.transitionMinZoom = nil
        self.transitionMaxZoom = nil
        self.transitionPreviousZoom = nil
        self.transitionInCommandCount = 0
        self.transitionOutCommandCount = 0
        self.transitionDirectionSwitchCount = 0
        self.transitionMaxAbsPositionError = 0
        self.lastExpectedZoom = nil
        self.lastPositionError = nil
        self.lastObservedDirection = nil
        self.lastObservedDelta = nil
        self.lastCommandDirection = nil
        self.lastCommandFactor = nil
        self.lastCurrentZoom = nil
        self.lastFinalZoom = nil
        self.lastZoomSpeed = nil
        self.lastCameraDistanceFactor = nil
        self.lastCameraDistanceCeiling = nil
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
        return "taxi", "taxi", false
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

local function boundedVelocity(value, limit)
    if value > limit then
        return limit
    end
    if value < -limit then
        return -limit
    end
    return value
end

local function transitionExpectedZoom(
    startZoom,
    targetZoom,
    duration,
    elapsed
)
    if duration <= 0 then
        return targetZoom
    end

    local progress = elapsed / duration
    if progress < 0 then
        progress = 0
    elseif progress > 1 then
        progress = 1
    end

    local eased
    if progress < 0.5 then
        eased = 2 * progress * progress
    else
        local inverse = -2 * progress + 2
        eased = 1 - ((inverse * inverse) / 2)
    end

    return startZoom + ((targetZoom - startZoom) * eased)
end

local function transitionVelocity(
    startZoom,
    targetZoom,
    duration,
    elapsed,
    currentZoom
)
    local change = targetZoom - startZoom
    if change == 0 then
        return 0
    end

    if duration <= 0 then
        return (targetZoom - currentZoom) / NOMINAL_FRAME_INTERVAL
    end

    local maxVelocity = (math.abs(change) * 2) / duration
    local crossedTarget =
        (change > 0 and currentZoom > targetZoom)
        or (change < 0 and currentZoom < targetZoom)
    local remainingTime = duration - elapsed

    if crossedTarget
        or remainingTime <= (2 * NOMINAL_FRAME_INTERVAL)
    then
        return boundedVelocity(
            (targetZoom - currentZoom) / NOMINAL_FRAME_INTERVAL,
            maxVelocity
        )
    end

    local progress = elapsed / duration
    if progress < 0 then
        progress = 0
    elseif progress > 1 then
        progress = 1
    end

    local slopeScale
    if progress < 0.5 then
        slopeScale = 4 * progress
    else
        slopeScale = 4 * (1 - progress)
    end

    return (change / duration) * slopeScale
end

function Controller:BeginTransition(
    context,
    currentZoom,
    requestedTargetZoom,
    effectiveTargetZoom,
    transitionDuration
)
    local stopOK, stopError = stopMotion()
    if not stopOK then
        self.lastError = stopError
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-failed"
        self:Relinquish("pre-transition-stop-failed", false)
        return false, stopError
    end

    self.lastZoomSpeed = nil
    self.lastCurrentZoom = currentZoom
    self.lastFinalZoom = nil
    self.lastTransitionElapsed = nil
    self.lastTargetReached = false
    self.transitionActive = true
    self.transitionContext = context
    self.transitionStartZoom = currentZoom
    self.transitionRequestedZoom = requestedTargetZoom
    self.transitionEffectiveTargetZoom = effectiveTargetZoom
    self.transitionDuration = transitionDuration
    self.transitionStartTime = GetTime()
    self.transitionDirection = nil
    self.transitionSampleCount = 0
    self.transitionTowardCount = 0
    self.transitionAwayCount = 0
    self.transitionFlatCount = 0
    self.transitionMinZoom = currentZoom
    self.transitionMaxZoom = currentZoom
    self.transitionPreviousZoom = currentZoom
    self.transitionInCommandCount = 0
    self.transitionOutCommandCount = 0
    self.transitionDirectionSwitchCount = 0
    self.transitionMaxAbsPositionError = 0
    self.lastExpectedZoom = currentZoom
    self.lastPositionError = 0
    self.lastObservedDirection = "flat"
    self.lastObservedDelta = 0
    self.lastCommandDirection = nil
    self.lastCommandFactor = nil
    self.transitionStartCount = self.transitionStartCount + 1
    self.lastAction = "transition-started"
    self.lastReason = context
    self:SetAnimationActive(true)

    return true, "transition-started"
end

function Controller:ApplyTransitionMotion(currentZoom, elapsed)
    local startZoom = self.transitionStartZoom
    local requestedTargetZoom = self.transitionRequestedZoom
    local transitionDuration = self.transitionDuration

    if type(startZoom) ~= "number"
        or type(requestedTargetZoom) ~= "number"
        or type(transitionDuration) ~= "number"
    then
        self.lastError = "camera transition state invalid"
        self.failureCount = self.failureCount + 1
        self:Relinquish("transition-state-invalid", false)
        return false, self.lastError
    end

    local velocity = transitionVelocity(
        startZoom,
        requestedTargetZoom,
        transitionDuration,
        elapsed,
        currentZoom
    )

    if math.abs(velocity) < 0.0001 then
        return true, "transition-waiting"
    end

    local zoomSpeed, speedError, speedSecret = readZoomSpeed()
    if zoomSpeed == nil then
        self.lastSecret = speedSecret and true or false
        self.lastError = speedError
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-failed"
        self:Relinquish("zoom-speed-failed", false)
        return false, speedError
    end

    local moveFunc
    local direction
    if velocity > 0 then
        moveFunc = MoveViewOutStart
        direction = "out"
    else
        moveFunc = MoveViewInStart
        direction = "in"
    end

    local previousDirection = self.transitionDirection
    if previousDirection ~= nil and previousDirection ~= direction then
        local switchOK, switchError = stopMotionDirection(previousDirection)
        if not switchOK then
            self.lastError = switchError
            self.failureCount = self.failureCount + 1
            self.lastAction = "transition-failed"
            self:Relinquish("direction-switch-stop-failed", false)
            return false, switchError
        end

        self.transitionDirectionSwitchCount =
            self.transitionDirectionSwitchCount + 1
    end

    local factor = math.abs(velocity) / zoomSpeed
    self.lastCommandDirection = direction
    self.lastCommandFactor = factor
    if direction == "in" then
        self.transitionInCommandCount = self.transitionInCommandCount + 1
    else
        self.transitionOutCommandCount = self.transitionOutCommandCount + 1
    end

    local ok, moveError = pcall(moveFunc, factor)
    if not ok then
        self.lastError = tostring(moveError)
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-failed"
        self:Relinquish("move-update-failed", false)
        return false, self.lastError
    end

    self.lastZoomSpeed = zoomSpeed
    self.transitionDirection = direction
    return true, "transition-driving"
end

function Controller:FinishTransition(currentZoom, elapsed, timedOut)
    local transitionContext = self.transitionContext
    local targetZoom = self.transitionEffectiveTargetZoom
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

    if timedOut
        and not self.lastTargetReached
        and transitionContext ~= "taxi"
    then
        self.lastError = "camera transition timed out before target"
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-timeout"
        return
    end

    self.lastError = nil
    self.transitionCompleteCount = self.transitionCompleteCount + 1
    if timedOut
        and transitionContext == "taxi"
        and not self.lastTargetReached
    then
        self.lastAction = "transition-complete-limited"
    else
        self.lastAction = "transition-complete"
    end
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
    local requestedTargetZoom = self.transitionRequestedZoom

    self.transitionSampleCount = self.transitionSampleCount + 1
    if self.transitionMinZoom == nil or currentZoom < self.transitionMinZoom then
        self.transitionMinZoom = currentZoom
    end
    if self.transitionMaxZoom == nil or currentZoom > self.transitionMaxZoom then
        self.transitionMaxZoom = currentZoom
    end

    local previousZoom = self.transitionPreviousZoom
    if type(previousZoom) == "number"
        and type(requestedTargetZoom) == "number"
    then
        local delta = currentZoom - previousZoom
        local previousDistance = math.abs(previousZoom - requestedTargetZoom)
        local currentDistance = math.abs(currentZoom - requestedTargetZoom)
        self.lastObservedDelta = delta

        if delta > 0.0001 then
            self.lastObservedDirection = "out"
        elseif delta < -0.0001 then
            self.lastObservedDirection = "in"
        else
            self.lastObservedDirection = "flat"
        end

        if currentDistance + 0.0001 < previousDistance then
            self.transitionTowardCount = self.transitionTowardCount + 1
        elseif currentDistance > previousDistance + 0.0001 then
            self.transitionAwayCount = self.transitionAwayCount + 1
        else
            self.transitionFlatCount = self.transitionFlatCount + 1
        end
    end
    self.transitionPreviousZoom = currentZoom

    if type(self.transitionStartZoom) == "number"
        and type(requestedTargetZoom) == "number"
        and type(self.transitionDuration) == "number"
    then
        local expectedZoom = transitionExpectedZoom(
            self.transitionStartZoom,
            requestedTargetZoom,
            self.transitionDuration,
            elapsed
        )
        local positionError = currentZoom - expectedZoom
        self.lastExpectedZoom = expectedZoom
        self.lastPositionError = positionError
        local absoluteError = math.abs(positionError)
        if absoluteError > self.transitionMaxAbsPositionError then
            self.transitionMaxAbsPositionError = absoluteError
        end
    end

    local atRequested =
        type(requestedTargetZoom) == "number"
        and math.abs(currentZoom - requestedTargetZoom) <= TARGET_TOLERANCE

    local timeoutExtra = TRANSITION_TIMEOUT_EXTRA
    if self.transitionContext == "taxi" then
        timeoutExtra = 0
    end

    local timedOut =
        elapsed >= (self.transitionDuration + timeoutExtra)

    if atRequested or timedOut then
        self:FinishTransition(currentZoom, elapsed, timedOut)
        return
    end

    self.lastCurrentZoom = currentZoom
    local motionOK = self:ApplyTransitionMotion(currentZoom, elapsed)
    if not motionOK then
        return
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

    local requestedTargetZoom = WORLD_TARGET
    if context == "combat" then
        requestedTargetZoom = COMBAT_TARGET
    elseif context == "city" then
        requestedTargetZoom = CITY_TARGET
    elseif context == "taxi" then
        requestedTargetZoom = TAXI_TARGET
    end

    local effectiveTargetZoom = requestedTargetZoom
    local transitionDuration = transitionDurationForContext(context)

    if context == "taxi" then
        local cameraDistanceFactor
        local cameraDistanceCeiling
        local distanceError
        local distanceSecret

        cameraDistanceFactor,
        cameraDistanceCeiling,
        distanceError,
        distanceSecret = readCameraDistanceFactor()

        if cameraDistanceFactor == nil then
            self.lastSecret = distanceSecret and true or false
            self.lastError = distanceError
            self.failureCount = self.failureCount + 1
            self:Relinquish("taxi-camera-distance-read-failed", false)
            return false, distanceError
        end

        self.lastCameraDistanceFactor = cameraDistanceFactor
        self.lastCameraDistanceCeiling = cameraDistanceCeiling
        effectiveTargetZoom = math.min(
            requestedTargetZoom,
            cameraDistanceCeiling
        )
    end

    if self.transitionActive
        and self.transitionContext == context
        and self.transitionRequestedZoom == requestedTargetZoom
        and self.transitionEffectiveTargetZoom == effectiveTargetZoom
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
    self.transitionRequestedZoom = requestedTargetZoom
    self.transitionEffectiveTargetZoom = effectiveTargetZoom
    self.transitionDuration = transitionDuration

    local needsTransition =
        (context == "world" and currentZoom > WORLD_TARGET)
        or (context == "city" and currentZoom > CITY_TARGET)
        or (context == "combat" and currentZoom < COMBAT_TARGET)
        or (context == "taxi" and currentZoom < requestedTargetZoom)

    if not needsTransition then
        self.noOpCount = self.noOpCount + 1
        self.lastAction = "noop"
        self.lastTargetReached = true
        return true, "noop"
    end

    return self:BeginTransition(
        context,
        currentZoom,
        requestedTargetZoom,
        effectiveTargetZoom,
        transitionDuration
    )
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
        transitionRequestedZoom = self.transitionRequestedZoom,
        transitionEffectiveTargetZoom = self.transitionEffectiveTargetZoom,
        transitionDuration = self.transitionDuration,
        transitionDirection = self.transitionDirection,
        transitionSampleCount = self.transitionSampleCount,
        transitionTowardCount = self.transitionTowardCount,
        transitionAwayCount = self.transitionAwayCount,
        transitionFlatCount = self.transitionFlatCount,
        transitionMinZoom = self.transitionMinZoom,
        transitionMaxZoom = self.transitionMaxZoom,
        transitionMaxAbsPositionError = self.transitionMaxAbsPositionError,
        transitionInCommandCount = self.transitionInCommandCount,
        transitionOutCommandCount = self.transitionOutCommandCount,
        transitionDirectionSwitchCount = self.transitionDirectionSwitchCount,
        lastExpectedZoom = self.lastExpectedZoom,
        lastPositionError = self.lastPositionError,
        lastObservedDirection = self.lastObservedDirection,
        lastObservedDelta = self.lastObservedDelta,
        lastCommandDirection = self.lastCommandDirection,
        lastCommandFactor = self.lastCommandFactor,
        lastCurrentZoom = self.lastCurrentZoom,
        lastFinalZoom = self.lastFinalZoom,
        lastZoomSpeed = self.lastZoomSpeed,
        lastCameraDistanceFactor = self.lastCameraDistanceFactor,
        lastCameraDistanceCeiling = self.lastCameraDistanceCeiling,
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
