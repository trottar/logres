local _, Logres = ...

local SOURCE_DYNAMICCAM_COMMIT =
    "ae586a9c973c3f868c10440358d4a6e8c2fab5ff"
local SOURCE_LIBCAMERA_COMMIT =
    "c0b23135a0b24fbca24b41cb53dd7afc9114e352"

local NOMINAL_FRAME_INTERVAL = 1 / 60
local ZOOM_EPSILON = 0.01

local STANDARD_FIXED_CVARS = {
    cameraZoomSpeed = 15.5,
    test_cameraDynamicPitch = 1,
    test_cameraDynamicPitchBaseFovPad = 0.75,
    test_cameraDynamicPitchBaseFovPadDownScale = 1,
    test_cameraDynamicPitchBaseFovPadFlying = 0.5,
    test_cameraDynamicPitchSmartPivotCutoffDist = 25,
    test_cameraTargetFocusEnemyEnable = 1,
    test_cameraTargetFocusEnemyStrengthPitch = 0.5,
    test_cameraTargetFocusEnemyStrengthYaw = 0.75,
    test_cameraTargetFocusInteractEnable = 1,
    test_cameraTargetFocusInteractStrengthPitch = 0.5,
    test_cameraTargetFocusInteractStrengthYaw = 0.75,
}

local OWNED_CVARS = {
    "cameraDistanceMaxZoomFactor",
    "cameraZoomSpeed",
    "test_cameraDynamicPitch",
    "test_cameraDynamicPitchBaseFovPad",
    "test_cameraDynamicPitchBaseFovPadDownScale",
    "test_cameraDynamicPitchBaseFovPadFlying",
    "test_cameraDynamicPitchSmartPivotCutoffDist",
    "test_cameraOverShoulder",
    "test_cameraTargetFocusEnemyEnable",
    "test_cameraTargetFocusEnemyStrengthPitch",
    "test_cameraTargetFocusEnemyStrengthYaw",
    "test_cameraTargetFocusInteractEnable",
    "test_cameraTargetFocusInteractStrengthPitch",
    "test_cameraTargetFocusInteractStrengthYaw",
}

local ROTATIONS = {
    taxi = {
        kind = "continuous",
        speed = -20,
        rotateBack = true,
    },
    teleport = {
        kind = "continuous",
        speed = 15,
        rotateBack = true,
    },
    interaction = {
        kind = "degrees",
        yaw = -45,
        pitch = 0,
        rotateBack = true,
    },
    fishing = {
        kind = "degrees",
        yaw = 10,
        pitch = 10,
        rotateBack = true,
    },
    gathering = {
        kind = "degrees",
        yaw = -15,
        pitch = 15,
        rotateBack = true,
    },
}

local Behavior = {
    initialized = false,
    active = false,
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function readCVarToken(name)
    if type(GetCVar) ~= "function" then
        return nil, false, "GetCVar unavailable"
    end

    local ok, value = pcall(GetCVar, name)
    if not ok then
        return nil, false, tostring(value)
    end

    return value, isSecret(value), nil
end

local function readCVarNumber(name)
    local token, secret, readError = readCVarToken(name)
    if token == nil then
        return nil, secret, readError
    end

    if secret then
        return nil, true, name .. " returned secret value"
    end

    local numberValue = tonumber(token)
    if numberValue == nil then
        return nil, false, name .. " returned non-number"
    end

    return numberValue, false, nil
end

local function writeCVar(name, value)
    if type(SetCVar) ~= "function" then
        return false, "SetCVar unavailable"
    end

    local ok, callError = pcall(SetCVar, name, value)
    if not ok then
        return false, tostring(callError)
    end

    return true, nil
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

local function easeInOutQuad(t, beginValue, change, duration)
    if duration <= 0 then
        return beginValue + change
    end

    local scaled = t / duration * 2
    if scaled < 1 then
        return change / 2 * scaled * scaled + beginValue
    end

    scaled = scaled - 1
    return
        -change / 2 * (scaled * (scaled - 2) - 1)
        + beginValue
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
        and t + halfIncrement < duration
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
        and t + increment < duration
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

    return 0
end

local function shoulderCurve(context, zoom)
    local target = 1
    if context == "interaction" then
        target = -2
    end

    if zoom <= 2 then
        return 0
    end

    if zoom >= 7 then
        return target
    end

    return target * ((zoom - 2) / 5)
end

local function safeStart(func, factor)
    local ok, callError = pcall(func, factor)
    if not ok then
        return false, tostring(callError)
    end
    return true, nil
end

local function safeStop(startFunc, stopFunc)
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

local function stopYawMotion()
    local leftOK, leftError =
        safeStop(MoveViewLeftStart, MoveViewLeftStop)
    if not leftOK then
        return false, leftError
    end

    local rightOK, rightError =
        safeStop(MoveViewRightStart, MoveViewRightStop)
    if not rightOK then
        return false, rightError
    end

    return true, nil
end

local function stopPitchMotion()
    local upOK, upError =
        safeStop(MoveViewUpStart, MoveViewUpStop)
    if not upOK then
        return false, upError
    end

    local downOK, downError =
        safeStop(MoveViewDownStart, MoveViewDownStop)
    if not downOK then
        return false, downError
    end

    return true, nil
end

function Behavior:Initialize(controller)
    if self.initialized then
        self.controller = controller
        return
    end

    self.controller = controller
    self.frame = CreateFrame("Frame")
    self.frame:Hide()

    self.originalCvars = {}
    self.originalCvarSecret = {}
    self.originalDistanceFactor = nil

    self.context = nil
    self.lastZoom = nil

    self.settingsTransition = nil
    self.settingsCaptureCount = 0
    self.settingsApplyCount = 0
    self.settingsRestoreCount = 0
    self.settingsFailureCount = 0
    self.settingsSecretSkips = 0
    self.lastSettingsError = nil
    self.lastShoulderOffset = nil
    self.lastDistanceFactor = nil
    self.lastDistanceTargetFactor = nil

    self.yawMode = nil
    self.yawBeginTime = nil
    self.yawDuration = nil
    self.yawEndValue = nil
    self.yawLastValue = nil
    self.yawContinuousSpeed = nil
    self.yawContinuousElapsed = nil
    self.yawLastSpeed = nil
    self.yawLastTime = nil
    self.yawCoasting = false

    self.pitchMode = nil
    self.pitchBeginTime = nil
    self.pitchDuration = nil
    self.pitchEndValue = nil
    self.pitchLastValue = nil

    self.rotationStartCount = 0
    self.rotationReturnCount = 0
    self.rotationStopCount = 0
    self.rotationFailureCount = 0
    self.lastRotationError = nil
    self.lastRotationContext = nil
    self.lastRotationKind = nil
    self.lastReturnYaw = nil
    self.lastReturnPitch = nil

    self.initialized = true
end

function Behavior:IsActive()
    return self.active == true
end

function Behavior:ValidateAPIs()
    local required = {
        GetCameraZoom,
        GetCVar,
        SetCVar,
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
            return false, "required profile behavior API unavailable"
        end
    end

    return true, nil
end

function Behavior:SetFrameActive(active)
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

function Behavior:RecordFailure(kind, message)
    local text = tostring(message or "unknown profile behavior failure")

    if kind == "rotation" then
        self.rotationFailureCount =
            self.rotationFailureCount + 1
        self.lastRotationError = text
    else
        self.settingsFailureCount =
            self.settingsFailureCount + 1
        self.lastSettingsError = text
    end

    return false, text
end

function Behavior:CaptureSettings()
    self.originalCvars = {}
    self.originalCvarSecret = {}
    self.originalDistanceFactor = nil

    for index = 1, #OWNED_CVARS do
        local name = OWNED_CVARS[index]
        local token, secret, readError =
            readCVarToken(name)

        if token == nil then
            return self:RecordFailure(
                "settings",
                readError
            )
        end

        self.originalCvars[name] = token
        self.originalCvarSecret[name] =
            secret and true or false

        if secret then
            self.settingsSecretSkips =
                self.settingsSecretSkips + 1
        elseif name == "cameraDistanceMaxZoomFactor" then
            local numberValue = tonumber(token)
            if numberValue ~= nil and numberValue > 0 then
                self.originalDistanceFactor = numberValue
            end
        end
    end

    self.settingsCaptureCount =
        self.settingsCaptureCount + 1
    return true, nil
end

function Behavior:RestoreSettings()
    local firstError = nil

    for index = #OWNED_CVARS, 1, -1 do
        local name = OWNED_CVARS[index]
        local token = self.originalCvars[name]

        if token ~= nil then
            local ok, restoreError =
                writeCVar(name, token)
            if not ok and firstError == nil then
                firstError = restoreError
            end
        end
    end

    self.settingsTransition = nil
    self.lastZoom = nil
    self.lastShoulderOffset = nil
    self.lastDistanceFactor = nil
    self.lastDistanceTargetFactor = nil

    if next(self.originalCvars) ~= nil then
        self.settingsRestoreCount =
            self.settingsRestoreCount + 1
    end

    self.originalCvars = {}
    self.originalCvarSecret = {}
    self.originalDistanceFactor = nil

    if firstError ~= nil then
        return self:RecordFailure(
            "settings",
            firstError
        )
    end

    return true, nil
end

function Behavior:ApplyFixedSettings()
    for name, value in pairs(STANDARD_FIXED_CVARS) do
        local ok, setError =
            writeCVar(name, value)
        if not ok then
            return self:RecordFailure(
                "settings",
                setError
            )
        end
        self.settingsApplyCount =
            self.settingsApplyCount + 1
    end

    return true, nil
end

function Behavior:GetTargetMaxDistanceFactor(context)
    if not self.active then
        return nil
    end

    if self.originalDistanceFactor == nil then
        return nil
    end

    if context == "city" then
        return 1
    end

    return self.originalDistanceFactor
end

function Behavior:ApplyDistanceFactor(value)
    if value == nil then
        return true, nil
    end

    local ok, setError =
        writeCVar(
            "cameraDistanceMaxZoomFactor",
            value
        )
    if not ok then
        return self:RecordFailure(
            "settings",
            setError
        )
    end

    self.lastDistanceFactor = value
    self.settingsApplyCount =
        self.settingsApplyCount + 1
    return true, nil
end

function Behavior:ApplyShoulderOffset(value)
    local ok, setError =
        writeCVar(
            "test_cameraOverShoulder",
            value
        )
    if not ok then
        return self:RecordFailure(
            "settings",
            setError
        )
    end

    self.lastShoulderOffset = value
    self.settingsApplyCount =
        self.settingsApplyCount + 1
    return true, nil
end

function Behavior:BeginSettingsTransition(
    oldContext,
    newContext,
    duration
)
    local zoom, zoomSecret, zoomError = readZoom()
    if zoom == nil then
        if zoomSecret then
            self.settingsSecretSkips =
                self.settingsSecretSkips + 1
        end
        return self:RecordFailure(
            "settings",
            zoomError
        )
    end

    local currentShoulder
    local shoulderSecret
    local shoulderError

    currentShoulder,
    shoulderSecret,
    shoulderError =
        readCVarNumber("test_cameraOverShoulder")

    if currentShoulder == nil then
        if shoulderSecret then
            self.settingsSecretSkips =
                self.settingsSecretSkips + 1
            currentShoulder =
                shoulderCurve(newContext, zoom)
        else
            return self:RecordFailure(
                "settings",
                shoulderError
            )
        end
    end

    local currentDistance
    local distanceSecret
    local distanceError

    currentDistance,
    distanceSecret,
    distanceError =
        readCVarNumber(
            "cameraDistanceMaxZoomFactor"
        )

    if currentDistance == nil
        and distanceSecret
    then
        self.settingsSecretSkips =
            self.settingsSecretSkips + 1
    elseif currentDistance == nil then
        return self:RecordFailure(
            "settings",
            distanceError
        )
    end

    local targetShoulder =
        shoulderCurve(newContext, zoom)
    local targetDistance =
        self:GetTargetMaxDistanceFactor(newContext)

    self.context = newContext
    self.lastDistanceTargetFactor = targetDistance

    if duration == nil or duration <= 0 then
        self.settingsTransition = nil

        local shoulderOK, shoulderSetError =
            self:ApplyShoulderOffset(
                targetShoulder
            )
        if not shoulderOK then
            return false, shoulderSetError
        end

        if targetDistance ~= nil then
            local distanceOK, distanceSetError =
                self:ApplyDistanceFactor(
                    targetDistance
                )
            if not distanceOK then
                return false, distanceSetError
            end
        end

        self.lastZoom = zoom
        return true, nil
    end

    local interrupted =
        self.settingsTransition ~= nil

    self.settingsTransition = {
        startTime = GetTime(),
        duration = duration,
        oldContext = oldContext,
        newContext = newContext,
        interruptedShoulder =
            interrupted and currentShoulder or nil,
        startDistance = currentDistance,
        targetDistance = targetDistance,
    }

    self.lastZoom = zoom
    return true, nil
end

function Behavior:ServiceSettings(now)
    local zoom, zoomSecret, zoomError = readZoom()
    if zoom == nil then
        if zoomSecret then
            self.settingsSecretSkips =
                self.settingsSecretSkips + 1
        end
        return self:RecordFailure(
            "settings",
            zoomError
        )
    end

    local transition = self.settingsTransition
    local targetShoulder =
        shoulderCurve(self.context, zoom)

    if transition ~= nil then
        local elapsed =
            now - transition.startTime
        local duration =
            transition.duration

        if elapsed >= duration then
            self.settingsTransition = nil

            local shoulderOK, shoulderError =
                self:ApplyShoulderOffset(
                    targetShoulder
                )
            if not shoulderOK then
                return false, shoulderError
            end

            if transition.targetDistance ~= nil then
                local distanceOK, distanceError =
                    self:ApplyDistanceFactor(
                        transition.targetDistance
                    )
                if not distanceOK then
                    return false, distanceError
                end
            end
        else
            local blend =
                easeInOutQuad(
                    elapsed,
                    0,
                    1,
                    duration
                )

            local shoulderStart
            if transition.interruptedShoulder ~= nil then
                shoulderStart =
                    transition.interruptedShoulder
            else
                shoulderStart =
                    shoulderCurve(
                        transition.oldContext,
                        zoom
                    )
            end

            local shoulderEnd =
                shoulderCurve(
                    transition.newContext,
                    zoom
                )

            local shoulderValue =
                shoulderStart
                + (
                    shoulderEnd
                    - shoulderStart
                ) * blend

            local shoulderOK, shoulderError =
                self:ApplyShoulderOffset(
                    shoulderValue
                )
            if not shoulderOK then
                return false, shoulderError
            end

            if transition.startDistance ~= nil
                and transition.targetDistance ~= nil
            then
                local distanceValue =
                    transition.startDistance
                    + (
                        transition.targetDistance
                        - transition.startDistance
                    ) * blend

                local distanceOK, distanceError =
                    self:ApplyDistanceFactor(
                        distanceValue
                    )
                if not distanceOK then
                    return false, distanceError
                end
            end
        end
    elseif self.lastZoom == nil
        or math.abs(zoom - self.lastZoom)
            >= ZOOM_EPSILON
    then
        local shoulderOK, shoulderError =
            self:ApplyShoulderOffset(
                targetShoulder
            )
        if not shoulderOK then
            return false, shoulderError
        end
    end

    self.lastZoom = zoom
    return true, nil
end

function Behavior:GetYawSpeed()
    local value, secret, readError =
        readCVarNumber("cameraYawMoveSpeed")
    if value == nil then
        if secret then
            self.settingsSecretSkips =
                self.settingsSecretSkips + 1
        end
        return nil, readError
    end

    if value == 0 then
        return nil, "cameraYawMoveSpeed is zero"
    end

    return value, nil
end

function Behavior:GetPitchSpeed()
    local value, secret, readError =
        readCVarNumber("cameraPitchMoveSpeed")
    if value == nil then
        if secret then
            self.settingsSecretSkips =
                self.settingsSecretSkips + 1
        end
        return nil, readError
    end

    if value == 0 then
        return nil, "cameraPitchMoveSpeed is zero"
    end

    return value, nil
end

function Behavior:StopYawing()
    local yawAmount = nil

    if self.yawMode == "ease" then
        yawAmount = self.yawLastValue
    elseif self.yawMode == "continuous" then
        yawAmount = self.yawContinuousElapsed
    end

    self.yawMode = nil
    self.yawBeginTime = nil
    self.yawDuration = nil
    self.yawEndValue = nil
    self.yawLastValue = nil
    self.yawContinuousSpeed = nil
    self.yawContinuousElapsed = nil
    self.yawLastSpeed = nil
    self.yawLastTime = nil
    self.yawCoasting = false

    local ok, stopError = stopYawMotion()
    if not ok then
        self:RecordFailure(
            "rotation",
            stopError
        )
    end

    return yawAmount
end

function Behavior:StopPitching()
    local pitchAmount = nil

    if self.pitchMode == "ease" then
        pitchAmount = self.pitchLastValue
    end

    self.pitchMode = nil
    self.pitchBeginTime = nil
    self.pitchDuration = nil
    self.pitchEndValue = nil
    self.pitchLastValue = nil

    local ok, stopError = stopPitchMotion()
    if not ok then
        self:RecordFailure(
            "rotation",
            stopError
        )
    end

    return pitchAmount
end

function Behavior:StopRotating()
    local yaw = self:StopYawing()
    local pitch = self:StopPitching()
    self.rotationStopCount =
        self.rotationStopCount + 1
    return yaw, pitch
end

function Behavior:StartYawDegrees(
    amount,
    duration,
    isReturn
)
    if amount == 0 then
        return true, nil
    end

    self:StopYawing()

    self.yawMode = "ease"
    self.yawBeginTime = nil
    self.yawDuration =
        duration == 0 and 0.05 or duration
    self.yawEndValue = amount
    self.yawLastValue = 0
    self.lastRotationKind =
        isReturn and "yaw-return" or "yaw-degrees"

    return true, nil
end

function Behavior:StartPitchDegrees(
    amount,
    duration,
    isReturn
)
    if amount == 0 then
        return true, nil
    end

    self:StopPitching()

    self.pitchMode = "ease"
    self.pitchBeginTime = nil
    self.pitchDuration =
        duration == 0 and 0.05 or duration
    self.pitchEndValue = amount
    self.pitchLastValue = 0
    self.lastRotationKind =
        isReturn
        and "pitch-return"
        or "pitch-degrees"

    return true, nil
end

function Behavior:StartContinuousYaw(
    speed,
    duration
)
    self:StopYawing()

    self.yawMode = "continuous"
    self.yawBeginTime = nil
    self.yawDuration = duration or 0
    self.yawContinuousSpeed = speed
    self.yawContinuousElapsed = 0
    self.yawLastSpeed = nil
    self.yawLastTime = nil
    self.yawCoasting = false
    self.lastRotationKind = "continuous"

    return true, nil
end

function Behavior:StartRotation(
    context,
    duration
)
    local rotation = ROTATIONS[context]
    if rotation == nil then
        return true, nil
    end

    self.rotationStartCount =
        self.rotationStartCount + 1
    self.lastRotationContext = context
    self.lastRotationError = nil

    if rotation.kind == "continuous" then
        return self:StartContinuousYaw(
            rotation.speed,
            duration
        )
    end

    local yawOK, yawError =
        self:StartYawDegrees(
            rotation.yaw or 0,
            duration,
            false
        )
    if not yawOK then
        return false, yawError
    end

    local pitchOK, pitchError =
        self:StartPitchDegrees(
            rotation.pitch or 0,
            duration,
            false
        )
    if not pitchOK then
        return false, pitchError
    end

    return true, nil
end

function Behavior:StopRotation(
    context,
    duration,
    rotateBack
)
    local rotation = ROTATIONS[context]
    if rotation == nil then
        self:StopRotating()
        return true, nil
    end

    if rotateBack ~= true
        or rotation.rotateBack ~= true
    then
        self:StopRotating()
        return true, nil
    end

    if rotation.kind == "continuous" then
        local yaw = self:StopYawing()
        self:StopPitching()

        if type(yaw) == "number" then
            local yawBack = yaw % 360
            if yawBack > 180 then
                yawBack = yawBack - 360
            end

            if yawBack ~= 0 then
                self.rotationReturnCount =
                    self.rotationReturnCount + 1
                self.lastReturnYaw = -yawBack
                return self:StartYawDegrees(
                    -yawBack,
                    duration,
                    true
                )
            end
        end

        return true, nil
    end

    local wasRotating =
        self.yawMode ~= nil
        or self.pitchMode ~= nil

    local yaw, pitch =
        self:StopRotating()

    local returnYaw
    local returnPitch

    if wasRotating then
        returnYaw = yaw
        returnPitch = pitch
    else
        returnYaw = rotation.yaw or 0
        returnPitch = rotation.pitch or 0
    end

    if type(returnYaw) == "number"
        and returnYaw ~= 0
    then
        self.rotationReturnCount =
            self.rotationReturnCount + 1
        self.lastReturnYaw = -returnYaw
        self:StartYawDegrees(
            -returnYaw,
            duration,
            true
        )
    end

    if type(returnPitch) == "number"
        and returnPitch ~= 0
    then
        self.rotationReturnCount =
            self.rotationReturnCount + 1
        self.lastReturnPitch = -returnPitch
        self:StartPitchDegrees(
            -returnPitch,
            duration,
            true
        )
    end

    return true, nil
end

function Behavior:ServiceYaw(now)
    if self.yawMode == nil then
        return true, nil
    end

    local yawSpeed, speedError =
        self:GetYawSpeed()
    if yawSpeed == nil then
        return self:RecordFailure(
            "rotation",
            speedError
        )
    end

    if self.yawMode == "continuous" then
        self.yawBeginTime =
            self.yawBeginTime or now

        if self.yawLastSpeed ~= nil
            and self.yawLastTime ~= nil
        then
            self.yawContinuousElapsed =
                self.yawContinuousElapsed
                + self.yawLastSpeed
                    * (now - self.yawLastTime)
        end

        self.yawLastTime = now

        local elapsed =
            now - self.yawBeginTime
        local speed =
            self.yawContinuousSpeed

        if self.yawDuration > 0
            and elapsed < self.yawDuration
        then
            speed =
                self.yawContinuousSpeed
                * elapsed
                / self.yawDuration
        else
            self.yawCoasting = true
        end

        self.yawLastSpeed = speed

        if speed > 0 then
            return safeStart(
                MoveViewRightStart,
                speed / yawSpeed
            )
        elseif speed < 0 then
            return safeStart(
                MoveViewLeftStart,
                -speed / yawSpeed
            )
        end

        return true, nil
    end

    self.yawBeginTime =
        self.yawBeginTime or now

    local elapsed =
        now - self.yawBeginTime
    local duration =
        self.yawDuration

    if elapsed < duration then
        local speed =
            getEaseVelocity(
                easeInOutQuad,
                NOMINAL_FRAME_INTERVAL,
                elapsed,
                0,
                self.yawEndValue,
                duration
            )

        self.yawLastValue =
            easeInOutQuad(
                elapsed,
                0,
                self.yawEndValue,
                duration
            )

        if speed > 0 then
            return safeStart(
                MoveViewRightStart,
                speed / yawSpeed
            )
        elseif speed < 0 then
            return safeStart(
                MoveViewLeftStart,
                -speed / yawSpeed
            )
        end

        return true, nil
    end

    self.yawLastValue = nil
    self.yawMode = nil
    local stopOK, stopError =
        stopYawMotion()
    if not stopOK then
        return self:RecordFailure(
            "rotation",
            stopError
        )
    end

    return true, nil
end

function Behavior:ServicePitch(now)
    if self.pitchMode == nil then
        return true, nil
    end

    local pitchSpeed, speedError =
        self:GetPitchSpeed()
    if pitchSpeed == nil then
        return self:RecordFailure(
            "rotation",
            speedError
        )
    end

    self.pitchBeginTime =
        self.pitchBeginTime or now

    local elapsed =
        now - self.pitchBeginTime
    local duration =
        self.pitchDuration

    if elapsed < duration then
        local speed =
            getEaseVelocity(
                easeInOutQuad,
                NOMINAL_FRAME_INTERVAL,
                elapsed,
                0,
                self.pitchEndValue,
                duration
            )

        self.pitchLastValue =
            easeInOutQuad(
                elapsed,
                0,
                self.pitchEndValue,
                duration
            )

        if speed > 0 then
            return safeStart(
                MoveViewUpStart,
                speed / pitchSpeed
            )
        elseif speed < 0 then
            return safeStart(
                MoveViewDownStart,
                -speed / pitchSpeed
            )
        end

        return true, nil
    end

    self.pitchLastValue = nil
    self.pitchMode = nil
    local stopOK, stopError =
        stopPitchMotion()
    if not stopOK then
        return self:RecordFailure(
            "rotation",
            stopError
        )
    end

    return true, nil
end

function Behavior:ChangeContext(
    oldContext,
    newContext,
    transitionDuration
)
    if not self.active then
        return false, "profile behavior is not active"
    end

    if oldContext == newContext then
        return true, nil
    end

    self.lastRotationError = nil
    self.lastSettingsError = nil

    if oldContext ~= nil
        and oldContext ~= "none"
    then
        local stopOK, stopError =
            self:StopRotation(
                oldContext,
                transitionDuration,
                true
            )
        if not stopOK then
            return false, stopError
        end
    else
        self:StopRotating()
    end

    local settingsOK, settingsError =
        self:BeginSettingsTransition(
            oldContext,
            newContext,
            transitionDuration
        )
    if not settingsOK then
        return false, settingsError
    end

    local rotationOK, rotationError =
        self:StartRotation(
            newContext,
            transitionDuration
        )
    if not rotationOK then
        return false, rotationError
    end

    self.context = newContext
    return true, nil
end

function Behavior:Acquire()
    if self.active then
        return true, nil
    end

    local apiOK, apiError =
        self:ValidateAPIs()
    if not apiOK then
        return self:RecordFailure(
            "settings",
            apiError
        )
    end

    self.settingsSecretSkips = 0
    self.lastSettingsError = nil
    self.lastRotationError = nil

    local captureOK, captureError =
        self:CaptureSettings()
    if not captureOK then
        return false, captureError
    end

    local fixedOK, fixedError =
        self:ApplyFixedSettings()
    if not fixedOK then
        self:RestoreSettings()
        return false, fixedError
    end

    self.active = true
    self:SetFrameActive(true)
    return true, nil
end

function Behavior:Release()
    if not self.initialized then
        return true, nil
    end

    self:StopRotating()
    self.settingsTransition = nil
    self.context = nil
    self.active = false
    self:SetFrameActive(false)

    return self:RestoreSettings()
end

function Behavior:OnUpdate()
    if not self.active then
        self:SetFrameActive(false)
        return
    end

    local now = GetTime()

    local settingsOK, settingsError =
        self:ServiceSettings(now)
    if not settingsOK then
        if self.controller
            and self.controller.moduleEnabled
        then
            self.controller:Relinquish(
                "profile-settings-failed",
                false
            )
        end
        return
    end

    local yawOK, yawError =
        self:ServiceYaw(now)
    if not yawOK then
        if self.controller
            and self.controller.moduleEnabled
        then
            self.controller:Relinquish(
                "profile-yaw-failed",
                false
            )
        end
        return
    end

    local pitchOK, pitchError =
        self:ServicePitch(now)
    if not pitchOK then
        if self.controller
            and self.controller.moduleEnabled
        then
            self.controller:Relinquish(
                "profile-pitch-failed",
                false
            )
        end
    end
end

function Behavior:GetDebugStatus()
    return {
        sourceDynamicCamCommit =
            SOURCE_DYNAMICCAM_COMMIT,
        sourceLibCameraCommit =
            SOURCE_LIBCAMERA_COMMIT,
        active = self.active,
        context = self.context,

        settingsCaptureCount =
            self.settingsCaptureCount,
        settingsApplyCount =
            self.settingsApplyCount,
        settingsRestoreCount =
            self.settingsRestoreCount,
        settingsFailureCount =
            self.settingsFailureCount,
        settingsSecretSkips =
            self.settingsSecretSkips,
        lastSettingsError =
            self.lastSettingsError,
        lastShoulderOffset =
            self.lastShoulderOffset,
        lastDistanceFactor =
            self.lastDistanceFactor,
        lastDistanceTargetFactor =
            self.lastDistanceTargetFactor,
        originalDistanceFactor =
            self.originalDistanceFactor,

        yawMode = self.yawMode,
        pitchMode = self.pitchMode,
        yawContinuousSpeed =
            self.yawContinuousSpeed,
        yawContinuousElapsed =
            self.yawContinuousElapsed,
        yawEndValue = self.yawEndValue,
        pitchEndValue = self.pitchEndValue,

        rotationStartCount =
            self.rotationStartCount,
        rotationReturnCount =
            self.rotationReturnCount,
        rotationStopCount =
            self.rotationStopCount,
        rotationFailureCount =
            self.rotationFailureCount,
        lastRotationError =
            self.lastRotationError,
        lastRotationContext =
            self.lastRotationContext,
        lastRotationKind =
            self.lastRotationKind,
        lastReturnYaw =
            self.lastReturnYaw,
        lastReturnPitch =
            self.lastReturnPitch,
    }
end

Logres.CameraProfileBehavior = Behavior
