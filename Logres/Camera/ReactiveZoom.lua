local _, Logres = ...

-- Source-backed reactive mouse-wheel semantics adapted from DynamicCam
-- MouseZoom.lua at this pinned commit. The captured RPG profile overrides the
-- standard always-add and max-time values; the remaining values use the pinned
-- DynamicCam defaults.
local SOURCE_DYNAMICCAM_COMMIT =
    "ae586a9c973c3f868c10440358d4a6e8c2fab5ff"

local REACTIVE_ZOOM_ENABLED = true
local REACTIVE_ADD_ALWAYS = 0.1000000000000001
local REACTIVE_ADD_QUICK = 2.5
local REACTIVE_QUICK_THRESHOLD = 1.2
local REACTIVE_MAX_TIME = 2.5
local REACTIVE_EASING = "OutQuad"
local CAMERA_DISTANCE_SCALE = 15
local DEFAULT_FRAME_INTERVAL = 1 / 60

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function readZoom()
    if type(GetCameraZoom) ~= "function" then
        return nil, false, "GetCameraZoom unavailable"
    end

    local ok, value = pcall(GetCameraZoom)
    if not ok then
        return nil, false, tostring(value)
    end

    if isSecret(value) then
        return nil, true, "GetCameraZoom returned secret value"
    end

    if type(value) ~= "number" then
        return nil, false, "GetCameraZoom returned non-number"
    end

    return value, false, nil
end

local function readPositiveCVarNumber(name)
    if type(GetCVar) ~= "function" then
        return nil, false, "GetCVar unavailable"
    end

    local ok, value = pcall(GetCVar, name)
    if not ok then
        return nil, false, tostring(value)
    end

    if isSecret(value) then
        return nil, true, name .. " returned secret value"
    end

    local numberValue = tonumber(value)
    if not numberValue or numberValue <= 0 then
        return nil, false, name .. " unavailable or invalid"
    end

    return numberValue, false, nil
end

local ReactiveZoom = {}

function ReactiveZoom:Initialize(controller)
    if self.initialized then
        self.controller = controller
        return
    end

    self.controller = controller
    self.frame = CreateFrame("Frame")
    self.frame:Hide()

    self.zoomInWrapper = function(increments)
        return self:HandleZoom(true, increments)
    end
    self.zoomOutWrapper = function(increments)
        return self:HandleZoom(false, increments)
    end

    self.active = false
    self.originalZoomIn = nil
    self.originalZoomOut = nil
    self.reactiveZoomTarget = nil
    self.secondsPerFrame = DEFAULT_FRAME_INTERVAL

    self.nonReactiveZoomStarted = false
    self.nonReactiveZoomInProgress = false
    self.nonReactiveZoomStartValue = nil
    self.lastZoomForCorrection = nil

    self.acquireCount = 0
    self.releaseCount = 0
    self.wheelTickCount = 0
    self.quickZoomCount = 0
    self.directionResetCount = 0
    self.nativeZoomCount = 0
    self.targetCorrectionCount = 0
    self.secretSkipCount = 0
    self.fallbackCount = 0
    self.failureCount = 0
    self.hookConflictCount = 0

    self.lastHookConflict = false
    self.lastCurrentZoom = nil
    self.lastTargetZoom = nil
    self.lastDuration = nil
    self.lastDirection = nil
    self.lastIncrement = nil
    self.lastAction = "initialize"
    self.lastError = nil
    self.lastSecret = false

    self.initialized = true
end

function ReactiveZoom:IsActive()
    return self.active == true
end

function ReactiveZoom:SetFrameActive(active)
    if active then
        self.frame:SetScript("OnUpdate", function(_, elapsed)
            self:OnUpdate(elapsed)
        end)
        self.frame:Show()
        return
    end

    self.frame:SetScript("OnUpdate", nil)
    self.frame:Hide()
end

function ReactiveZoom:RecordFailure(message)
    self.failureCount = self.failureCount + 1
    self.lastError = tostring(message or "reactive zoom failure")
    self.lastAction = "failure"
    return false, self.lastError
end

function ReactiveZoom:ValidateAPIs()
    if type(GetCameraZoom) ~= "function" then
        return false, "GetCameraZoom unavailable"
    end
    if type(GetCVar) ~= "function" then
        return false, "GetCVar unavailable"
    end
    if type(_G.CameraZoomIn) ~= "function" then
        return false, "CameraZoomIn unavailable"
    end
    if type(_G.CameraZoomOut) ~= "function" then
        return false, "CameraZoomOut unavailable"
    end
    return true, nil
end

function ReactiveZoom:Acquire()
    if self.active then
        return true, nil
    end

    local apiOK, apiError = self:ValidateAPIs()
    if not apiOK then
        return self:RecordFailure(apiError)
    end

    local currentZoom, zoomSecret, zoomError = readZoom()
    if currentZoom == nil then
        self.lastSecret = zoomSecret and true or false
        if zoomSecret then
            self.secretSkipCount = self.secretSkipCount + 1
        end
        return self:RecordFailure(zoomError)
    end

    local originalZoomIn = _G.CameraZoomIn
    local originalZoomOut = _G.CameraZoomOut

    self.originalZoomIn = originalZoomIn
    self.originalZoomOut = originalZoomOut
    self.reactiveZoomTarget = currentZoom
    self.lastZoomForCorrection = currentZoom
    self.lastCurrentZoom = currentZoom
    self.lastTargetZoom = currentZoom
    self.lastDuration = nil
    self.lastDirection = nil
    self.lastIncrement = nil
    self.lastHookConflict = false
    self.lastError = nil
    self.lastSecret = false

    _G.CameraZoomIn = self.zoomInWrapper
    _G.CameraZoomOut = self.zoomOutWrapper

    if _G.CameraZoomIn ~= self.zoomInWrapper
        or _G.CameraZoomOut ~= self.zoomOutWrapper
    then
        _G.CameraZoomIn = originalZoomIn
        _G.CameraZoomOut = originalZoomOut
        self.originalZoomIn = nil
        self.originalZoomOut = nil
        return self:RecordFailure("reactive zoom hook install failed")
    end

    self.active = true
    self.acquireCount = self.acquireCount + 1
    self.lastAction = "acquired"
    self:SetFrameActive(true)
    return true, nil
end

function ReactiveZoom:Release()
    if not self.initialized then
        return true, nil
    end

    self:SetFrameActive(false)

    local hadState = self.active
        or self.originalZoomIn ~= nil
        or self.originalZoomOut ~= nil

    local conflict = false

    if self.originalZoomIn ~= nil then
        if _G.CameraZoomIn == self.zoomInWrapper then
            _G.CameraZoomIn = self.originalZoomIn
        else
            conflict = true
        end
    end

    if self.originalZoomOut ~= nil then
        if _G.CameraZoomOut == self.zoomOutWrapper then
            _G.CameraZoomOut = self.originalZoomOut
        else
            conflict = true
        end
    end

    if conflict then
        self.hookConflictCount = self.hookConflictCount + 1
    end
    self.lastHookConflict = conflict

    self.active = false
    self.originalZoomIn = nil
    self.originalZoomOut = nil
    self.reactiveZoomTarget = nil
    self.nonReactiveZoomStarted = false
    self.nonReactiveZoomInProgress = false
    self.nonReactiveZoomStartValue = nil
    self.lastZoomForCorrection = nil

    if hadState then
        self.releaseCount = self.releaseCount + 1
    end
    self.lastAction = conflict and "released-conflict" or "released"

    return true, nil
end

function ReactiveZoom:CallOriginal(
    zoomIn,
    increments,
    startZoom,
    action
)
    local func = zoomIn and self.originalZoomIn or self.originalZoomOut
    if type(func) ~= "function" then
        return self:RecordFailure("captured native zoom function unavailable")
    end

    if type(startZoom) == "number" then
        self.nonReactiveZoomStarted = true
        self.nonReactiveZoomInProgress = false
        self.nonReactiveZoomStartValue = startZoom
    else
        self.nonReactiveZoomStarted = false
        self.nonReactiveZoomInProgress = false
        self.nonReactiveZoomStartValue = nil
        self.reactiveZoomTarget = nil
    end

    local ok, callError = pcall(func, increments)
    if not ok then
        self.nonReactiveZoomStarted = false
        self.nonReactiveZoomInProgress = false
        self.nonReactiveZoomStartValue = nil
        return self:RecordFailure(callError)
    end

    self.nativeZoomCount = self.nativeZoomCount + 1
    self.lastAction = action or "native-zoom"
    return true, nil
end

function ReactiveZoom:FailOpenNative(
    zoomIn,
    increments,
    startZoom,
    reason,
    secret
)
    self.fallbackCount = self.fallbackCount + 1
    self.lastSecret = secret and true or false
    if secret then
        self.secretSkipCount = self.secretSkipCount + 1
    end
    self.lastError = reason
    return self:CallOriginal(
        zoomIn,
        increments,
        startZoom,
        "native-fallback"
    )
end

function ReactiveZoom:StopOwnedTransition(reason)
    local controller = self.controller
    if controller == nil or controller.transitionActive ~= true then
        return true, nil
    end

    return controller:StopTransition(reason, true)
end

function ReactiveZoom:HandleZoom(zoomIn, increments)
    if not self.active then
        local func = zoomIn and self.originalZoomIn or self.originalZoomOut
        if type(func) == "function" then
            return pcall(func, increments)
        end
        return false, "reactive zoom inactive"
    end

    if isSecret(increments) then
        self.reactiveZoomTarget = nil
        return self:FailOpenNative(
            zoomIn,
            increments,
            nil,
            "CameraZoom increment returned secret value",
            true
        )
    end

    increments = increments or 1

    if type(increments) ~= "number" then
        self.reactiveZoomTarget = nil
        return self:FailOpenNative(
            zoomIn,
            increments,
            nil,
            "CameraZoom increment is non-number",
            false
        )
    end

    if increments == 0 then
        self.lastAction = "ignored-zero-increment"
        return true, nil
    end

    local currentZoom, zoomSecret, zoomError = readZoom()
    if currentZoom == nil then
        self.reactiveZoomTarget = nil
        return self:FailOpenNative(
            zoomIn,
            increments,
            nil,
            zoomError,
            zoomSecret
        )
    end

    self.lastCurrentZoom = currentZoom
    self.lastSecret = false

    if increments ~= 1 then
        return self:CallOriginal(
            zoomIn,
            increments,
            currentZoom,
            "native-non-wheel"
        )
    end

    if not REACTIVE_ZOOM_ENABLED then
        return self:CallOriginal(
            zoomIn,
            increments + REACTIVE_ADD_ALWAYS,
            currentZoom,
            "native-reactive-disabled"
        )
    end

    local controller = self.controller
    if controller == nil
        or controller.moduleEnabled ~= true
        or controller.ownsContext ~= true
    then
        return self:FailOpenNative(
            zoomIn,
            increments,
            currentZoom,
            "camera controller does not own context",
            false
        )
    end

    controller:MarkReactiveManualZoom()

    local zoomSpeed, speedSecret, speedError =
        readPositiveCVarNumber("cameraZoomSpeed")
    if zoomSpeed == nil then
        return self:FailOpenNative(
            zoomIn,
            increments,
            currentZoom,
            speedError,
            speedSecret
        )
    end

    local scaledIncrements = increments + REACTIVE_ADD_ALWAYS
    local target = self.reactiveZoomTarget

    if type(target) == "number"
        and math.abs(target - currentZoom) > REACTIVE_QUICK_THRESHOLD
    then
        scaledIncrements = scaledIncrements + REACTIVE_ADD_QUICK
        self.quickZoomCount = self.quickZoomCount + 1
    end

    if zoomIn then
        if type(target) == "number" and target > currentZoom then
            target = nil
            self.directionResetCount = self.directionResetCount + 1
        end
    else
        if type(target) == "number" and target < currentZoom then
            target = nil
            self.directionResetCount = self.directionResetCount + 1
        end
    end

    target = target or currentZoom

    local nativeIncrements = scaledIncrements

    if zoomIn then
        if target - scaledIncrements < 0 then
            if target > 0 then
                nativeIncrements = currentZoom
            end
            target = 0
        else
            target = target - scaledIncrements
        end
    else
        if currentZoom == 0 then
            self.reactiveZoomTarget = target
            self.wheelTickCount = self.wheelTickCount + 1
            self.lastDirection = "out"
            self.lastIncrement = 0.05
            self.lastTargetZoom = target
            self.lastDuration = 0

            local stopOK, stopError =
                self:StopOwnedTransition("reactive-first-person-exit")
            if not stopOK then
                return self:RecordFailure(stopError)
            end

            return self:CallOriginal(
                false,
                0.05,
                currentZoom,
                "native-first-person-exit"
            )
        end

        local distanceFactor, distanceSecret, distanceError =
            readPositiveCVarNumber("cameraDistanceMaxZoomFactor")
        if distanceFactor == nil then
            return self:FailOpenNative(
                false,
                increments,
                currentZoom,
                distanceError,
                distanceSecret
            )
        end

        target = math.min(
            distanceFactor * CAMERA_DISTANCE_SCALE,
            target + scaledIncrements
        )
    end

    self.reactiveZoomTarget = target
    self.wheelTickCount = self.wheelTickCount + 1
    self.lastDirection = zoomIn and "in" or "out"
    self.lastIncrement = scaledIncrements
    self.lastTargetZoom = target

    if target == currentZoom then
        self.lastDuration = 0
        self.lastAction = "reactive-limit-noop"
        return true, nil
    end

    local zoomTime = math.min(
        REACTIVE_MAX_TIME,
        math.abs(target - currentZoom) / zoomSpeed
    )
    self.lastDuration = zoomTime

    if zoomTime < self.secondsPerFrame then
        local stopOK, stopError =
            self:StopOwnedTransition("reactive-native-short-hop")
        if not stopOK then
            return self:RecordFailure(stopError)
        end

        return self:CallOriginal(
            zoomIn,
            nativeIncrements,
            currentZoom,
            "native-short-hop"
        )
    end

    local beginOK, beginError =
        controller:BeginReactiveZoomTransition(
            currentZoom,
            target,
            zoomTime,
            REACTIVE_EASING
        )
    if not beginOK then
        return self:RecordFailure(beginError)
    end

    self.lastAction = "reactive-transition"
    self.lastError = nil
    return true, nil
end

function ReactiveZoom:OnUpdate(elapsed)
    if not self.active then
        self:SetFrameActive(false)
        return
    end

    if not isSecret(elapsed) then
        if type(elapsed) == "number" and elapsed > 0 then
            self.secondsPerFrame = elapsed
        end
    end

    local currentZoom, zoomSecret, zoomError = readZoom()
    if currentZoom == nil then
        self.lastSecret = zoomSecret and true or false
        if zoomSecret then
            self.secretSkipCount = self.secretSkipCount + 1
        end
        self:RecordFailure(zoomError)
        if self.controller and self.controller.moduleEnabled then
            self.controller:Relinquish(
                "reactive-zoom-correction-read-failed",
                false
            )
        end
        return
    end

    if self.nonReactiveZoomStarted
        and self.nonReactiveZoomStartValue ~= currentZoom
    then
        self.nonReactiveZoomInProgress = true
        self.nonReactiveZoomStarted = false
    elseif self.nonReactiveZoomInProgress
        and self.lastZoomForCorrection == currentZoom
    then
        self.nonReactiveZoomInProgress = false
    end

    local controllerZooming =
        self.controller ~= nil
        and self.controller.transitionActive == true

    if not controllerZooming
        and not self.nonReactiveZoomStarted
        and not self.nonReactiveZoomInProgress
        and self.reactiveZoomTarget ~= nil
        and self.reactiveZoomTarget ~= currentZoom
    then
        self.reactiveZoomTarget = currentZoom
        self.lastTargetZoom = currentZoom
        self.targetCorrectionCount = self.targetCorrectionCount + 1
        self.lastAction = "target-corrected"
    end

    self.lastCurrentZoom = currentZoom
    self.lastZoomForCorrection = currentZoom
end

function ReactiveZoom:GetDebugStatus()
    return {
        sourceDynamicCamCommit = SOURCE_DYNAMICCAM_COMMIT,
        enabled = REACTIVE_ZOOM_ENABLED,
        addIncrementsAlways = REACTIVE_ADD_ALWAYS,
        addIncrements = REACTIVE_ADD_QUICK,
        incAddDifference = REACTIVE_QUICK_THRESHOLD,
        maxZoomTime = REACTIVE_MAX_TIME,
        easing = REACTIVE_EASING,
        active = self.active,
        hooked = self.active
            and _G.CameraZoomIn == self.zoomInWrapper
            and _G.CameraZoomOut == self.zoomOutWrapper,
        target = self.reactiveZoomTarget,
        secondsPerFrame = self.secondsPerFrame,
        nonReactiveZoomStarted = self.nonReactiveZoomStarted,
        nonReactiveZoomInProgress = self.nonReactiveZoomInProgress,
        acquireCount = self.acquireCount,
        releaseCount = self.releaseCount,
        wheelTickCount = self.wheelTickCount,
        quickZoomCount = self.quickZoomCount,
        directionResetCount = self.directionResetCount,
        nativeZoomCount = self.nativeZoomCount,
        targetCorrectionCount = self.targetCorrectionCount,
        secretSkipCount = self.secretSkipCount,
        fallbackCount = self.fallbackCount,
        failureCount = self.failureCount,
        hookConflictCount = self.hookConflictCount,
        lastHookConflict = self.lastHookConflict,
        lastCurrentZoom = self.lastCurrentZoom,
        lastTargetZoom = self.lastTargetZoom,
        lastDuration = self.lastDuration,
        lastDirection = self.lastDirection,
        lastIncrement = self.lastIncrement,
        lastAction = self.lastAction,
        lastError = self.lastError,
        lastSecret = self.lastSecret,
    }
end

Logres.CameraReactiveZoom = ReactiveZoom
