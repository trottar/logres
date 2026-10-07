local _, Logres = ...

local WORLD_TARGET = 5
local CITY_TARGET = 5
local COMBAT_TARGET = 15
local TAXI_TARGET = 50
local TELEPORT_TARGET = 20
local INTERACTION_TARGET = 5
local FISHING_TARGET = 50
local GATHERING_TARGET = 5

local TRANSITION_DURATION = 2.5
local TAXI_TRANSITION_DURATION = 5
local TELEPORT_TRANSITION_DURATION = 5
local FISHING_TRANSITION_DURATION = 2
local GATHERING_TRANSITION_DURATION = 3
local FISHING_EXIT_DELAY = 1
local TARGET_TOLERANCE = 0.25
local CAMERA_DISTANCE_SCALE = 15
local NOMINAL_FRAME_INTERVAL = 1 / 60

-- Source-backed zoom engine constants from mpstark/LibCamera
-- c0b23135a0b24fbca24b41cb53dd7afc9114e352.
local LIBCAMERA_SOURCE_COMMIT =
    "c0b23135a0b24fbca24b41cb53dd7afc9114e352"
local LIBCAMERA_MAX_POS_ERROR = 0.5
local LIBCAMERA_REBASE_PRECISION = 0.005
local LIBCAMERA_REBASE_MAX_ITERATIONS = 100
local LIBCAMERA_CORRECTION_DURATION = 0.1
local LIBCAMERA_CORRECTION_TOLERANCE = 0.05

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

local function readZoomSpeedState()
    if type(GetCVar) ~= "function" then
        return nil, nil, "GetCVar unavailable", false
    end

    local ok, value = pcall(GetCVar, "cameraZoomSpeed")
    if not ok then
        return nil, nil, tostring(value), false
    end

    if isSecret(value) then
        return nil, nil, "cameraZoomSpeed returned secret value", true
    end

    local numberValue = tonumber(value)
    if not numberValue or numberValue <= 0 then
        return nil, nil, "cameraZoomSpeed unavailable or invalid", false
    end

    return value, numberValue, nil, false
end

local function setCameraZoomSpeed(value)
    if type(SetCVar) ~= "function" then
        return false, "SetCVar unavailable"
    end

    local ok, callError = pcall(SetCVar, "cameraZoomSpeed", value)
    if not ok then
        return false, tostring(callError)
    end

    return true, nil
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

local function transitionDurationForContext(
    context,
    teleportDuration
)
    if context == "taxi" then
        return TAXI_TRANSITION_DURATION
    end
    if context == "teleport" then
        if type(teleportDuration) == "number" and teleportDuration > 0 then
            return teleportDuration
        end
        return TELEPORT_TRANSITION_DURATION
    end
    if context == "fishing" then
        return FISHING_TRANSITION_DURATION
    end
    if context == "gathering" then
        return GATHERING_TRANSITION_DURATION
    end
    if context == "afk" then
        return 0
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
        self.manualZoomContext = nil
        self.transitionActive = false
        self.transitionContext = nil
        self.transitionStartZoom = nil
        self.transitionRequestedZoom = nil
        self.transitionEffectiveTargetZoom = nil
        self.transitionDuration = nil
        self.transitionEasingName = nil
        self.lastTransitionEasingName = nil
        self.transitionArmZoom = nil
        self.transitionArmTime = nil
        self.transitionStartTime = nil
        self.transitionFirstUpdateDelay = nil
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
        self.transitionRebaseCount = 0
        self.transitionRebaseIterationCount = 0
        self.transitionCorrectionCount = 0
        self.transitionCorrectionActive = false
        self.transitionCorrectionTriggered = false
        self.transitionCorrectionOldZoomSpeed = nil
        self.transitionCorrectionEndTime = nil
        self.transitionCorrectionLastZoom = nil
        self.lastRebaseFromElapsed = nil
        self.lastRebaseToElapsed = nil
        self.lastCorrectionZoomSpeed = nil
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

        self.lastProfileTeleport = false
        self.lastProfileTeleportDuration = nil
        self.lastProfileAFK = false
        self.lastProfileGathering = false
        self.lastProfileInteraction = false
        self.lastProfileFishing = false
        self.profileSecretSkips = 0
        self.profileReadFailures = 0
        self.lastProfileSecretSource = nil
        self.lastProfileError = nil

        self.fishingHoldUntil = nil
        self.fishingHoldSatisfied = false
        self.fishingHoldCount = 0
        self.lastFishingHoldRemaining = nil

        self.lastDynamicCamLoaded = false
        self.lastDynamicCamStatusKnown = false
        self.lastDynamicCamStatusSource = nil
        self.lastCameraDistanceTargetFactor = nil
        self.profileBehavior = Logres.CameraProfileBehavior
        if self.profileBehavior then
            self.profileBehavior:Initialize(self)
        end

        self.reactiveZoom = Logres.CameraReactiveZoom
        if self.reactiveZoom then
            self.reactiveZoom:Initialize(self)
        end

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
        self.manualZoomContext = nil
        self.fishingHoldUntil = nil
        self.fishingHoldSatisfied = false
        self.lastFishingHoldRemaining = nil
        self:StopTransition("module-disabled", false)

        if self.reactiveZoom then
            local reactiveOK, reactiveError =
                self.reactiveZoom:Release()
            if not reactiveOK then
                self.lastError = reactiveError
                self.failureCount = self.failureCount + 1
            end
        end

        if self.profileBehavior then
            local behaviorOK, behaviorError =
                self.profileBehavior:Release()
            if not behaviorOK then
                self.lastError = behaviorError
                self.failureCount = self.failureCount + 1
            end
        end

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
        SetCVar,
        CameraZoomIn,
        CameraZoomOut,
        UnitAffectingCombat,
        InCombatLockdown,
        MoveViewInStart,
        MoveViewInStop,
        MoveViewOutStart,
        MoveViewOutStop,
        MoveViewLeftStart,
        MoveViewLeftStop,
        MoveViewRightStart,
        MoveViewRightStop,
        MoveViewUpStart,
        MoveViewUpStop,
        MoveViewDownStart,
        MoveViewDownStop,
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

function Controller:RestoreSourceCorrectionZoomSpeed()
    local restoreToken =
        self.transitionCorrectionOldZoomSpeed

    self.transitionCorrectionOldZoomSpeed = nil
    self.transitionCorrectionActive = false
    self.transitionCorrectionTriggered = false
    self.transitionCorrectionEndTime = nil
    self.transitionCorrectionLastZoom = nil

    if restoreToken == nil then
        return true, nil
    end

    return setCameraZoomSpeed(restoreToken)
end

function Controller:BeginSourceCorrection(currentZoom, now)
    local requestedTargetZoom =
        self.transitionRequestedZoom

    if type(requestedTargetZoom) ~= "number" then
        return false, "source correction target unavailable"
    end

    local restoreToken
    local zoomSpeed
    local speedError
    local speedSecret

    restoreToken,
    zoomSpeed,
    speedError,
    speedSecret = readZoomSpeedState()

    if restoreToken == nil then
        self.lastSecret = speedSecret and true or false
        return false, speedError
    end

    local change = requestedTargetZoom - currentZoom
    local correctionSpeed = math.min(
        50,
        math.abs(change / LIBCAMERA_CORRECTION_DURATION)
    )

    local stopOK, stopError = stopMotion()
    if not stopOK then
        return false, stopError
    end

    local setOK, setError =
        setCameraZoomSpeed(correctionSpeed)
    if not setOK then
        return false, setError
    end

    self.transitionCorrectionOldZoomSpeed = restoreToken
    self.transitionCorrectionActive = true
    self.transitionCorrectionTriggered = false
    self.transitionCorrectionEndTime =
        now + LIBCAMERA_CORRECTION_DURATION
    self.transitionCorrectionLastZoom = currentZoom
    self.transitionCorrectionCount =
        self.transitionCorrectionCount + 1
    self.lastCorrectionZoomSpeed = correctionSpeed
    self.lastAction = "source-correction-started"

    return true, "source-correction-started"
end

function Controller:ServiceSourceCorrection(now, currentZoom)
    local requestedTargetZoom =
        self.transitionRequestedZoom

    if type(requestedTargetZoom) ~= "number"
        or self.transitionCorrectionEndTime == nil
    then
        return false, "source correction state invalid"
    end

    if not self.transitionCorrectionTriggered then
        local change = requestedTargetZoom - currentZoom
        local zoomFunc
        local amount

        if change > 0 then
            zoomFunc = CameraZoomOut
            amount = change
        elseif change < 0 then
            zoomFunc = CameraZoomIn
            amount = -change
        end

        if zoomFunc ~= nil and amount ~= nil then
            local ok, callError =
                pcall(zoomFunc, amount, true)
            if not ok then
                return false, tostring(callError)
            end
        end

        self.transitionCorrectionTriggered = true

        local refreshedZoom
        local zoomError
        local zoomSecret

        refreshedZoom,
        zoomError,
        zoomSecret = readZoom()

        if refreshedZoom == nil then
            self.lastSecret = zoomSecret and true or false
            return false, zoomError
        end

        currentZoom = refreshedZoom
    end

    local lastValue = self.transitionCorrectionLastZoom
    local change = requestedTargetZoom - currentZoom
    local goingWrongWay = false

    if type(lastValue) == "number" then
        local originalChange =
            requestedTargetZoom - self.transitionStartZoom

        goingWrongWay =
            (originalChange > 0 and lastValue > currentZoom)
            or (
                originalChange < 0
                and lastValue < currentZoom
            )
    end

    self.transitionCorrectionLastZoom = currentZoom
    self.lastCurrentZoom = currentZoom

    local timeOver =
        self.transitionCorrectionEndTime < now

    if not timeOver and not goingWrongWay then
        return true, "source-correction-driving"
    end

    local restoreOK, restoreError =
        self:RestoreSourceCorrectionZoomSpeed()

    local stopOK, stopError = stopMotion()
    if not restoreOK then
        return false, restoreError
    end
    if not stopOK then
        return false, stopError
    end

    local elapsed = 0
    if self.transitionStartTime ~= nil then
        elapsed = now - self.transitionStartTime
    end

    self:FinishTransition(
        currentZoom,
        elapsed,
        timeOver
    )
    return true, "source-correction-complete"
end

function Controller:StopTransition(reason, countAsStop)
    local wasActive = self.transitionActive

    local restoreOK, restoreError =
        self:RestoreSourceCorrectionZoomSpeed()
    local stopOK, stopError = stopMotion()

    self.transitionActive = false
    self.transitionContext = nil
    self.transitionDirection = nil
    self.transitionStartTime = nil
    self.transitionEasingName = nil
    self:SetAnimationActive(self.fishingHoldUntil ~= nil)
    self.lastStopReason = reason

    if wasActive and countAsStop ~= false then
        self.transitionStopCount = self.transitionStopCount + 1
    end

    if not restoreOK then
        self.lastError = restoreError
        self.failureCount = self.failureCount + 1
        self.lastAction = "stop-failed"
        return false, restoreError
    end

    if not stopOK then
        self.lastError = stopError
        self.failureCount = self.failureCount + 1
        self.lastAction = "stop-failed"
        return false, stopError
    end

    return true, nil
end

function Controller:MarkReactiveManualZoom()
    if self.ownsContext
        and self.selectedContext ~= nil
        and self.selectedContext ~= "none"
    then
        self.manualZoomContext = self.selectedContext
    end
end

function Controller:BeginReactiveZoomTransition(
    currentZoom,
    targetZoom,
    transitionDuration,
    easingName
)
    if not self.moduleEnabled or not self.ownsContext then
        return false, "camera controller does not own context"
    end

    if self.transitionActive then
        local stopOK, stopError =
            self:StopTransition("reactive-zoom-restart", true)
        if not stopOK then
            return false, stopError
        end
    end

    self:MarkReactiveManualZoom()

    return self:BeginTransition(
        "reactive",
        currentZoom,
        targetZoom,
        targetZoom,
        transitionDuration,
        easingName or "OutQuad"
    )
end

function Controller:Relinquish(reason, blocked)
    local hadOwnership = self.ownsContext or self.transitionActive
    self.fishingHoldUntil = nil
    self.fishingHoldSatisfied = false
    self.lastFishingHoldRemaining = nil
    self:StopTransition(reason, self.transitionActive)

    if self.reactiveZoom then
        local reactiveOK, reactiveError =
            self.reactiveZoom:Release()
        if not reactiveOK and self.lastError == nil then
            self.lastError = reactiveError
            self.failureCount = self.failureCount + 1
        end
    end

    if self.profileBehavior then
        local behaviorOK, behaviorError =
            self.profileBehavior:Release()
        if not behaviorOK and self.lastError == nil then
            self.lastError = behaviorError
            self.failureCount = self.failureCount + 1
        end
    end

    self.ownsContext = false
    self.selectedContext = "none"
    self.manualZoomContext = nil
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
    self.lastCombatMismatch = self.lastLiveCombat ~= self.lastCachedCombat
    self.lastResting = state.resting == true

    local profileContexts = Logres.CameraProfileContexts
    if type(profileContexts) ~= "table"
        or type(profileContexts.ReadSnapshot) ~= "function"
    then
        return nil, "profile-contexts-unavailable", false
    end

    local snapshot = profileContexts:ReadSnapshot()
    self.lastProfileTeleport = snapshot.teleport == true
    self.lastProfileTeleportDuration = snapshot.teleportDuration
    self.lastProfileAFK = snapshot.afk == true
    self.lastProfileGathering = snapshot.gathering == true
    self.lastProfileInteraction = snapshot.interaction == true
    self.lastProfileFishing = snapshot.fishing == true
    self.profileSecretSkips = snapshot.secretSkips or 0
    self.profileReadFailures = snapshot.readFailures or 0
    self.lastProfileSecretSource = snapshot.lastSecretSource
    self.lastProfileError = snapshot.lastError

    if not state.initialized then
        return "none", "state-uninitialized", false
    end

    -- Captured profile priorities:
    -- Taxi 1000 > Teleport 130 > AFK/Gathering 120 >
    -- Interaction 110 > Combat 50 > Fishing 20 > City 1 > World 0.
    if state.onTaxi then
        return "taxi", "taxi", false
    end
    if snapshot.teleport then
        return "teleport", "teleport-cast", false
    end
    if snapshot.afk then
        return "afk", "afk", false
    end
    if snapshot.gathering then
        return "gathering", "gathering-cast", false
    end
    if snapshot.interaction then
        return "interaction", "npc-interaction", false
    end
    if not state.inInstance and liveCombat then
        return "combat", "live-combat", false
    end
    if snapshot.fishing then
        return "fishing", "fishing-channel", false
    end
    if state.resting then
        return "city", "resting-city", false
    end
    if state.inInstance then
        return "none", "no-enabled-instance-profile", false
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

-- Source-backed equivalents of the ordinary LibCamera eased zoom path.
local function easeInOutQuad(t, beginValue, change, duration)
    t = t / duration * 2
    if t < 1 then
        return change / 2 * (t * t) + beginValue
    end

    return
        -change / 2 * ((t - 1) * (t - 3) - 1)
        + beginValue
end

local function easeOutQuad(t, beginValue, change, duration)
    t = t / duration
    return -change * t * (t - 2) + beginValue
end

local function easingForName(name)
    if name == "OutQuad" then
        return easeOutQuad
    end

    return easeInOutQuad
end

local function transitionExpectedZoom(
    easingFunc,
    startZoom,
    targetZoom,
    duration,
    elapsed
)
    if duration <= 0 then
        return targetZoom
    end

    local t = elapsed
    if t < 0 then
        t = 0
    elseif t > duration then
        t = duration
    end

    return easingFunc(
        t,
        startZoom,
        targetZoom - startZoom,
        duration
    )
end

local function getEaseVelocity(
    easingFunc,
    increment,
    t,
    beginValue,
    change,
    duration
)
    local halfIncrement = increment / 2

    if t > halfIncrement
        and (t + halfIncrement < duration)
    then
        return (
            easingFunc(
                t + halfIncrement,
                beginValue,
                change,
                duration
            )
            - easingFunc(
                t - halfIncrement,
                beginValue,
                change,
                duration
            )
        ) / increment
    end

    if t < halfIncrement
        and (t + increment < duration)
    then
        return (
            easingFunc(
                t + increment,
                beginValue,
                change,
                duration
            )
            - easingFunc(
                t,
                beginValue,
                change,
                duration
            )
        ) / increment
    end

    if t + halfIncrement > duration then
        return (
            easingFunc(
                t,
                beginValue,
                change,
                duration
            )
            - easingFunc(
                t - increment,
                beginValue,
                change,
                duration
            )
        ) / increment
    end

    return nil
end

local function rebaseEaseTime(
    easingFunc,
    precision,
    currentValue,
    t,
    beginValue,
    change,
    duration
)
    local expectedValue =
        easingFunc(t, beginValue, change, duration)
    local tPrime = t
    local difference = currentValue - expectedValue
    local step = math.min(duration - t, duration / 12)
    local lastWasForward
    local iterations = 0

    while math.abs(difference) > precision
        and iterations < LIBCAMERA_REBASE_MAX_ITERATIONS
    do
        if step <= 0 then
            break
        end

        local forward =
            (difference > 0 and change > 0)
            or (difference < 0 and change < 0)

        if forward then
            if lastWasForward ~= nil
                and not lastWasForward
            then
                step = step / 2
            end

            tPrime = tPrime + step
            lastWasForward = true
        else
            if lastWasForward then
                step = step / 2
            end

            tPrime = tPrime - step
            lastWasForward = false
        end

        expectedValue =
            easingFunc(
                tPrime,
                beginValue,
                change,
                duration
            )
        difference = currentValue - expectedValue
        iterations = iterations + 1
    end

    return tPrime, iterations
end

function Controller:BeginTransition(
    context,
    currentZoom,
    requestedTargetZoom,
    effectiveTargetZoom,
    transitionDuration,
    easingName
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
    self.transitionEasingName = easingName or "InOutQuad"
    self.lastTransitionEasingName = self.transitionEasingName
    self.transitionArmZoom = currentZoom
    self.transitionArmTime = GetTime()
    self.transitionStartTime = nil
    self.transitionFirstUpdateDelay = nil
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
    self.transitionRebaseCount = 0
    self.transitionRebaseIterationCount = 0
    self.transitionCorrectionCount = 0
    self.transitionCorrectionActive = false
    self.transitionCorrectionTriggered = false
    self.transitionCorrectionOldZoomSpeed = nil
    self.transitionCorrectionEndTime = nil
    self.transitionCorrectionLastZoom = nil
    self.lastRebaseFromElapsed = nil
    self.lastRebaseToElapsed = nil
    self.lastCorrectionZoomSpeed = nil
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

    local speed
    if transitionDuration <= 0 then
        speed =
            (requestedTargetZoom - currentZoom)
            / NOMINAL_FRAME_INTERVAL
    elseif transitionDuration - elapsed
        > (2 * NOMINAL_FRAME_INTERVAL)
    then
        speed = getEaseVelocity(
            easingForName(self.transitionEasingName),
            NOMINAL_FRAME_INTERVAL,
            elapsed,
            startZoom,
            requestedTargetZoom - startZoom,
            transitionDuration
        )
    else
        -- LibCamera uses a direct linear correction for the final two frames.
        speed =
            (requestedTargetZoom - currentZoom)
            / NOMINAL_FRAME_INTERVAL
    end

    if speed == nil or math.abs(speed) < 0.0001 then
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
    if speed > 0 then
        moveFunc = MoveViewOutStart
        direction = "out"
    else
        moveFunc = MoveViewInStart
        direction = "in"
    end

    local previousDirection = self.transitionDirection
    if previousDirection ~= nil and previousDirection ~= direction then
        local switchOK, switchError =
            stopMotionDirection(previousDirection)
        if not switchOK then
            self.lastError = switchError
            self.failureCount = self.failureCount + 1
            self.lastAction = "transition-failed"
            self:Relinquish(
                "direction-switch-stop-failed",
                false
            )
            return false, switchError
        end

        self.transitionDirectionSwitchCount =
            self.transitionDirectionSwitchCount + 1
    end

    local factor = math.abs(speed) / zoomSpeed
    self.lastCommandDirection = direction
    self.lastCommandFactor = factor
    if direction == "in" then
        self.transitionInCommandCount =
            self.transitionInCommandCount + 1
    else
        self.transitionOutCommandCount =
            self.transitionOutCommandCount + 1
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

local function contextTarget(context)
    if context == "world" then
        return WORLD_TARGET
    end
    if context == "city" then
        return CITY_TARGET
    end
    if context == "combat" then
        return COMBAT_TARGET
    end
    if context == "taxi" then
        return TAXI_TARGET
    end
    if context == "teleport" then
        return TELEPORT_TARGET
    end
    if context == "interaction" then
        return INTERACTION_TARGET
    end
    if context == "fishing" then
        return FISHING_TARGET
    end
    if context == "gathering" then
        return GATHERING_TARGET
    end
    return nil
end

local function contextZoomDirection(context)
    if context == "world"
        or context == "city"
        or context == "interaction"
        or context == "gathering"
    then
        return "in"
    end

    if context == "combat"
        or context == "taxi"
        or context == "teleport"
        or context == "fishing"
    then
        return "out"
    end

    return nil
end

local function contextAllowsEngineClamp(context)
    return context == "taxi"
        or context == "teleport"
        or context == "fishing"
end

local function contextAllowsLimitedTarget(context)
    return contextAllowsEngineClamp(context)
end

function Controller:ResolveContextDelay(context, reason)
    if context == "fishing" then
        self.fishingHoldUntil = nil
        self.fishingHoldSatisfied = false
        self.lastFishingHoldRemaining = nil
        return context, reason
    end

    if self.selectedContext ~= "fishing" then
        self.fishingHoldUntil = nil
        self.fishingHoldSatisfied = false
        self.lastFishingHoldRemaining = nil
        return context, reason
    end

    if self.fishingHoldSatisfied then
        self.fishingHoldSatisfied = false
        self.lastFishingHoldRemaining = 0
        return context, reason
    end

    local now = GetTime()
    if self.fishingHoldUntil == nil then
        self.fishingHoldUntil = GetTime() + FISHING_EXIT_DELAY
        self.fishingHoldCount = self.fishingHoldCount + 1
        self:SetAnimationActive(true)
    end

    local remaining = self.fishingHoldUntil - now
    if remaining > 0 then
        self.lastFishingHoldRemaining = remaining
        return "fishing", "fishing-exit-delay"
    end

    self.fishingHoldUntil = nil
    self.lastFishingHoldRemaining = 0
    return context, reason
end

function Controller:FinishTransition(currentZoom, elapsed, timedOut)
    local transitionContext = self.transitionContext
    local targetZoom = self.transitionEffectiveTargetZoom
    local stopReason =
        timedOut
        and "transition-timeout"
        or "transition-complete"

    local stopOK, stopError =
        self:StopTransition(stopReason, false)

    self.lastFinalZoom = currentZoom
    self.lastTransitionElapsed = elapsed
    self.lastTargetReached =
        type(targetZoom) == "number"
        and math.abs(currentZoom - targetZoom)
            <= TARGET_TOLERANCE

    if not stopOK then
        self.lastAction = "transition-failed"
        return
    end

    if not self.lastTargetReached
        and not contextAllowsLimitedTarget(
            transitionContext
        )
    then
        self.lastError =
            "camera transition ended before target"
        self.failureCount = self.failureCount + 1
        self.lastAction = "transition-target-miss"
        return
    end

    self.lastError = nil
    self.transitionCompleteCount =
        self.transitionCompleteCount + 1

    if not self.lastTargetReached
        and contextAllowsLimitedTarget(
            transitionContext
        )
    then
        self.lastAction =
            "transition-complete-limited"
    else
        self.lastAction = "transition-complete"
    end
end

function Controller:OnUpdate()
    local now = GetTime()

    if self.fishingHoldUntil ~= nil then
        local remaining = self.fishingHoldUntil - now
        if remaining > 0 then
            self.lastFishingHoldRemaining = remaining
        else
            self.fishingHoldUntil = nil
            self.fishingHoldSatisfied = true
            self.lastFishingHoldRemaining = 0
            self:Reconcile("fishing-delay-expired")
            now = GetTime()
        end
    end

    if not self.transitionActive then
        if self.fishingHoldUntil == nil then
            self:SetAnimationActive(false)
        end
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

    if self.transitionStartTime == nil then
        self.transitionStartTime = now
        if type(self.transitionArmTime) == "number" then
            self.transitionFirstUpdateDelay =
                now - self.transitionArmTime
        else
            self.transitionFirstUpdateDelay = nil
        end

        self.transitionStartZoom = currentZoom
        self.lastCurrentZoom = currentZoom
        self.transitionMinZoom = currentZoom
        self.transitionMaxZoom = currentZoom
        self.transitionPreviousZoom = currentZoom
        self.lastExpectedZoom = currentZoom
        self.lastPositionError = 0
    end

    local elapsed = now - self.transitionStartTime
    local requestedTargetZoom =
        self.transitionRequestedZoom

    self.transitionSampleCount =
        self.transitionSampleCount + 1

    if self.transitionMinZoom == nil
        or currentZoom < self.transitionMinZoom
    then
        self.transitionMinZoom = currentZoom
    end

    if self.transitionMaxZoom == nil
        or currentZoom > self.transitionMaxZoom
    then
        self.transitionMaxZoom = currentZoom
    end

    local previousZoom = self.transitionPreviousZoom
    if type(previousZoom) == "number"
        and type(requestedTargetZoom) == "number"
    then
        local delta = currentZoom - previousZoom
        local previousDistance =
            math.abs(
                previousZoom - requestedTargetZoom
            )
        local currentDistance =
            math.abs(
                currentZoom - requestedTargetZoom
            )

        self.lastObservedDelta = delta

        if delta > 0.0001 then
            self.lastObservedDirection = "out"
        elseif delta < -0.0001 then
            self.lastObservedDirection = "in"
        else
            self.lastObservedDirection = "flat"
        end

        if currentDistance + 0.0001
            < previousDistance
        then
            self.transitionTowardCount =
                self.transitionTowardCount + 1
        elseif currentDistance
            > previousDistance + 0.0001
        then
            self.transitionAwayCount =
                self.transitionAwayCount + 1
        else
            self.transitionFlatCount =
                self.transitionFlatCount + 1
        end
    end

    self.transitionPreviousZoom = currentZoom

    if self.transitionCorrectionActive then
        local correctionOK, correctionError =
            self:ServiceSourceCorrection(
                now,
                currentZoom
            )

        if not correctionOK then
            self.lastError = correctionError
            self.failureCount =
                self.failureCount + 1
            self.lastAction =
                "source-correction-failed"
            self:Relinquish(
                "source-correction-failed",
                false
            )
        end
        return
    end

    local startZoom = self.transitionStartZoom
    local transitionDuration =
        self.transitionDuration

    if type(startZoom) ~= "number"
        or type(requestedTargetZoom) ~= "number"
        or type(transitionDuration) ~= "number"
    then
        self.lastError =
            "camera transition state invalid"
        self.failureCount =
            self.failureCount + 1
        self:Relinquish(
            "transition-state-invalid",
            false
        )
        return
    end

    local change =
        requestedTargetZoom - startZoom
    local beyondPosition =
        (change > 0
            and currentZoom >= requestedTargetZoom)
        or (
            change < 0
            and currentZoom <= requestedTargetZoom
        )

    if not beyondPosition
        and self.transitionStartTime
            + transitionDuration
            > now
    then
        local expectedZoom =
            transitionExpectedZoom(
                easingForName(self.transitionEasingName),
                startZoom,
                requestedTargetZoom,
                transitionDuration,
                elapsed
            )
        local positionError =
            currentZoom - expectedZoom

        self.lastExpectedZoom = expectedZoom
        self.lastPositionError = positionError

        local absoluteError =
            math.abs(positionError)
        if absoluteError
            > self.transitionMaxAbsPositionError
        then
            self.transitionMaxAbsPositionError =
                absoluteError
        end

        if self.transitionSampleCount > 1
            and absoluteError
                > LIBCAMERA_MAX_POS_ERROR
        then
            local rebasedElapsed
            local rebaseIterations

            rebasedElapsed,
            rebaseIterations = rebaseEaseTime(
                easingForName(self.transitionEasingName),
                LIBCAMERA_REBASE_PRECISION,
                currentZoom,
                elapsed,
                startZoom,
                change,
                transitionDuration
            )

            if rebasedElapsed > 0
                and rebasedElapsed
                    < transitionDuration
            then
                local elapsedDifference =
                    rebasedElapsed - elapsed

                self.transitionStartTime =
                    self.transitionStartTime
                    - elapsedDifference
                self.transitionRebaseCount =
                    self.transitionRebaseCount + 1
                self.transitionRebaseIterationCount =
                    self.transitionRebaseIterationCount
                    + rebaseIterations
                self.lastRebaseFromElapsed =
                    elapsed

                elapsed =
                    now
                    - self.transitionStartTime

                self.lastRebaseToElapsed =
                    elapsed
                expectedZoom =
                    transitionExpectedZoom(
                        startZoom,
                        requestedTargetZoom,
                        transitionDuration,
                        elapsed
                    )
                self.lastExpectedZoom =
                    expectedZoom
                self.lastPositionError =
                    currentZoom - expectedZoom
            end
        end

        self.lastCurrentZoom = currentZoom

        local motionOK =
            self:ApplyTransitionMotion(
                currentZoom,
                elapsed
            )
        if not motionOK then
            return
        end

        return
    end

    local stopOK, stopError = stopMotion()
    if not stopOK then
        self.lastError = stopError
        self.failureCount =
            self.failureCount + 1
        self:Relinquish(
            "source-transition-stop-failed",
            false
        )
        return
    end

    if math.abs(
        currentZoom - requestedTargetZoom
    ) > LIBCAMERA_CORRECTION_TOLERANCE
    then
        local correctionOK, correctionError =
            self:BeginSourceCorrection(
                currentZoom,
                now
            )

        if not correctionOK then
            self.lastError = correctionError
            self.failureCount =
                self.failureCount + 1
            self.lastAction =
                "source-correction-failed"
            self:Relinquish(
                "source-correction-start-failed",
                false
            )
        end
        return
    end

    self:FinishTransition(
        currentZoom,
        elapsed,
        false
    )
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

    context, contextReason = self:ResolveContextDelay(context, contextReason)

    if context == "none" then
        self:Relinquish(contextReason, false)
        return true, contextReason
    end

    local reactiveZoom = self.reactiveZoom
    if reactiveZoom == nil then
        self.lastError = "reactive zoom adapter unavailable"
        self.failureCount = self.failureCount + 1
        self:Relinquish("reactive-zoom-unavailable", false)
        return false, self.lastError
    end

    if not reactiveZoom:IsActive() then
        local reactiveOK, reactiveError = reactiveZoom:Acquire()
        if not reactiveOK then
            self.lastError = reactiveError
            self.failureCount = self.failureCount + 1
            self:Relinquish("reactive-zoom-acquire-failed", false)
            return false, reactiveError
        end
    end

    local requestedTargetZoom = contextTarget(context)
    local effectiveTargetZoom = requestedTargetZoom
    local transitionDuration = transitionDurationForContext(
        context,
        self.lastProfileTeleportDuration
    )

    local previousContext = self.selectedContext
    if previousContext ~= context then
        self.manualZoomContext = nil
    end

    local behavior = self.profileBehavior
    local behaviorWasInactive = false

    if behavior then
        behaviorWasInactive =
            not behavior:IsActive()

        if behaviorWasInactive then
            local acquireOK, acquireError =
                behavior:Acquire()
            if not acquireOK then
                self.lastError = acquireError
                self.failureCount = self.failureCount + 1
                self:Relinquish(
                    "profile-behavior-acquire-failed",
                    false
                )
                return false, acquireError
            end
        end

        if behaviorWasInactive
            or previousContext ~= context
        then
            local behaviorOldContext =
                previousContext ~= "none"
                and previousContext
                or nil
            local behaviorDuration =
                behaviorWasInactive
                and 0
                or transitionDuration

            local behaviorOK, behaviorError =
                behavior:ChangeContext(
                    behaviorOldContext,
                    context,
                    behaviorDuration
                )
            if not behaviorOK then
                self.lastError = behaviorError
                self.failureCount = self.failureCount + 1
                self:Relinquish(
                    "profile-behavior-change-failed",
                    false
                )
                return false, behaviorError
            end
        end
    end

    self.lastCameraDistanceFactor = nil
    self.lastCameraDistanceTargetFactor = nil
    self.lastCameraDistanceCeiling = nil

    if requestedTargetZoom ~= nil and contextAllowsEngineClamp(context) then
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
            self:Relinquish(context .. "-camera-distance-read-failed", false)
            return false, distanceError
        end

        self.lastCameraDistanceFactor = cameraDistanceFactor

        local targetDistanceFactor
        if behavior then
            targetDistanceFactor =
                behavior:GetTargetMaxDistanceFactor(
                    context
                )
        end

        if type(targetDistanceFactor) == "number" then
            self.lastCameraDistanceTargetFactor =
                targetDistanceFactor
            cameraDistanceCeiling =
                targetDistanceFactor
                * CAMERA_DISTANCE_SCALE
        end

        self.lastCameraDistanceCeiling = cameraDistanceCeiling
        effectiveTargetZoom = math.min(requestedTargetZoom, cameraDistanceCeiling)
    end

    if self.transitionActive
        and self.transitionContext == "reactive"
        and self.manualZoomContext == context
    then
        self.selectedContext = context
        self.ownsContext = true
        self.lastAction = "reactive-transition-continues"
        return true, "reactive-transition-continues"
    end

    if self.transitionActive
        and self.transitionContext == context
        and self.transitionRequestedZoom == requestedTargetZoom
        and self.transitionEffectiveTargetZoom == effectiveTargetZoom
        and self.transitionDuration == transitionDuration
    then
        self.selectedContext = context
        self.ownsContext = true
        self.lastAction = "transition-continues"
        return true, "transition-continues"
    end

    if self.transitionActive then
        local stopOK, stopError = self:StopTransition("context-reconcile", true)
        if not stopOK then
            self:Relinquish("context-stop-failed", false)
            return false, stopError
        end
    end

    self.selectedContext = context
    self.ownsContext = true

    if self.manualZoomContext == context then
        self.noOpCount = self.noOpCount + 1
        self.lastAction = "noop-reactive-manual"
        return true, "noop-reactive-manual"
    end

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

    if requestedTargetZoom == nil then
        self.noOpCount = self.noOpCount + 1
        self.lastAction = "noop-profile"
        self.lastTargetReached = true
        return true, "noop-profile"
    end

    local direction = contextZoomDirection(context)
    local needsTransition =
        (direction == "in" and currentZoom > requestedTargetZoom)
        or (direction == "out" and currentZoom < requestedTargetZoom)

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
        transitionEasingName = self.transitionEasingName,
        lastTransitionEasingName = self.lastTransitionEasingName,
        manualZoomContext = self.manualZoomContext,
        transitionArmZoom = self.transitionArmZoom,
        transitionFirstUpdateDelay = self.transitionFirstUpdateDelay,
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
        transitionRebaseCount = self.transitionRebaseCount,
        transitionRebaseIterationCount = self.transitionRebaseIterationCount,
        transitionCorrectionCount = self.transitionCorrectionCount,
        transitionCorrectionActive = self.transitionCorrectionActive,
        lastRebaseFromElapsed = self.lastRebaseFromElapsed,
        lastRebaseToElapsed = self.lastRebaseToElapsed,
        lastCorrectionZoomSpeed = self.lastCorrectionZoomSpeed,
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
        lastCameraDistanceTargetFactor = self.lastCameraDistanceTargetFactor,
        lastCameraDistanceCeiling = self.lastCameraDistanceCeiling,
        profileBehavior = self.profileBehavior
            and self.profileBehavior:GetDebugStatus()
            or nil,
        reactiveZoom = self.reactiveZoom
            and self.reactiveZoom:GetDebugStatus()
            or nil,
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

        lastProfileTeleport = self.lastProfileTeleport,
        lastProfileTeleportDuration = self.lastProfileTeleportDuration,
        lastProfileAFK = self.lastProfileAFK,
        lastProfileGathering = self.lastProfileGathering,
        lastProfileInteraction = self.lastProfileInteraction,
        lastProfileFishing = self.lastProfileFishing,
        profileSecretSkips = self.profileSecretSkips,
        profileReadFailures = self.profileReadFailures,
        lastProfileSecretSource = self.lastProfileSecretSource,
        lastProfileError = self.lastProfileError,
        fishingHoldActive = self.fishingHoldUntil ~= nil,
        fishingHoldCount = self.fishingHoldCount,
        lastFishingHoldRemaining = self.lastFishingHoldRemaining,

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

local function reconcilePlayerSpellEvent(event, unit)
    if unit ~= nil and unit ~= "player" then
        return
    end
    reconcileFromEvent(event)
end

local function reconcilePlayerFlagsEvent(event, unit)
    if unit ~= nil and unit ~= "player" then
        return
    end
    reconcileFromEvent(event)
end

Logres:RegisterEvent("PLAYER_REGEN_DISABLED", reconcileFromEvent)
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", reconcileFromEvent)
Logres:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED", reconcileFromEvent)
Logres:RegisterEvent("PLAYER_ENTERING_WORLD", reconcileFromEvent)
Logres:RegisterEvent("ADDON_LOADED", reconcileFromEvent)

Logres:RegisterEvent("PLAYER_FLAGS_CHANGED", reconcilePlayerFlagsEvent)

Logres:RegisterEvent("UNIT_SPELLCAST_START", reconcilePlayerSpellEvent)
Logres:RegisterEvent("UNIT_SPELLCAST_STOP", reconcilePlayerSpellEvent)
Logres:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", reconcilePlayerSpellEvent)
Logres:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START", reconcilePlayerSpellEvent)
Logres:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP", reconcilePlayerSpellEvent)
Logres:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE", reconcilePlayerSpellEvent)
Logres:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", reconcilePlayerSpellEvent)

Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", reconcileFromEvent)
Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", reconcileFromEvent)
Logres:RegisterEvent("PLAYER_TARGET_CHANGED", reconcileFromEvent)

Logres:RegisterEvent("AUCTION_HOUSE_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("AUCTION_HOUSE_SHOW", reconcileFromEvent)
Logres:RegisterEvent("BANKFRAME_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("BANKFRAME_OPENED", reconcileFromEvent)
Logres:RegisterEvent("CLOSE_TABARD_FRAME", reconcileFromEvent)
Logres:RegisterEvent("GOSSIP_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("GOSSIP_SHOW", reconcileFromEvent)
Logres:RegisterEvent("GUILD_REGISTRAR_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("GUILD_REGISTRAR_SHOW", reconcileFromEvent)
Logres:RegisterEvent("MERCHANT_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("MERCHANT_SHOW", reconcileFromEvent)
Logres:RegisterEvent("OPEN_TABARD_FRAME", reconcileFromEvent)
Logres:RegisterEvent("PET_STABLE_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("PET_STABLE_SHOW", reconcileFromEvent)
Logres:RegisterEvent("QUEST_COMPLETE", reconcileFromEvent)
Logres:RegisterEvent("QUEST_DETAIL", reconcileFromEvent)
Logres:RegisterEvent("QUEST_FINISHED", reconcileFromEvent)
Logres:RegisterEvent("QUEST_GREETING", reconcileFromEvent)
Logres:RegisterEvent("QUEST_PROGRESS", reconcileFromEvent)
Logres:RegisterEvent("SHIPMENT_CRAFTER_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("SHIPMENT_CRAFTER_OPENED", reconcileFromEvent)
Logres:RegisterEvent("TRAINER_CLOSED", reconcileFromEvent)
Logres:RegisterEvent("TRAINER_SHOW", reconcileFromEvent)
Logres:RegisterEvent("TRANSMOGRIFY_CLOSE", reconcileFromEvent)
Logres:RegisterEvent("TRANSMOGRIFY_OPEN", reconcileFromEvent)
