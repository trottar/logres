local _, Logres = ...

local PROBE_DELTA = 0.75
local PROBE_LEG_DURATION = 0.40
local PROBE_TIMEOUT_EXTRA = 0.35
local TARGET_TOLERANCE = 0.25
local MIN_MOVEMENT = 0.20

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

local function queryDynamicCamLoaded()
    if C_AddOns and type(C_AddOns.IsAddOnLoaded) == "function" then
        local ok, loaded = pcall(C_AddOns.IsAddOnLoaded, "DynamicCam")
        if ok then
            return loaded and true or false, true, "C_AddOns"
        end
    end

    if type(IsAddOnLoaded) == "function" then
        local ok, loaded = pcall(IsAddOnLoaded, "DynamicCam")
        if ok then
            return loaded and true or false, true, "legacy"
        end
    end

    return false, false, "unavailable"
end

local function readCombatSignals()
    if type(UnitAffectingCombat) ~= "function" then
        return nil, nil, "UnitAffectingCombat unavailable", false
    end

    if type(InCombatLockdown) ~= "function" then
        return nil, nil, "InCombatLockdown unavailable", false
    end

    local combatOK, combatValue =
        pcall(UnitAffectingCombat, "player")

    if not combatOK then
        return nil, nil, tostring(combatValue), false
    end

    if isSecret(combatValue) then
        return nil, nil, "UnitAffectingCombat returned secret value", true
    end

    local lockdownOK, lockdownValue = pcall(InCombatLockdown)

    if not lockdownOK then
        return nil, nil, tostring(lockdownValue), false
    end

    if isSecret(lockdownValue) then
        return nil, nil, "InCombatLockdown returned secret value", true
    end

    return
        combatValue and true or false,
        lockdownValue and true or false,
        nil,
        false
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

        if type(func) == "function" then
            local ok, callError

            if call[2] ~= nil then
                ok, callError = pcall(func, call[2])
            else
                ok, callError = pcall(func)
            end

            if not ok and not firstError then
                firstError = tostring(callError)
            end
        elseif not firstError then
            firstError = "camera stop API unavailable"
        end
    end

    return firstError == nil, firstError
end

local Probe = Logres:RegisterModule("CameraCapabilityProbe", {
    autoEnable = false,

    OnInitialize = function(self)
        local frame = CreateFrame("Frame")
        frame:Hide()

        self.frame = frame
        self.running = false
        self.phase = "idle"
        self.lastState = "idle"
        self.lastReported = true
        self.lastError = nil
        self.lastSecret = false
        self.lastCombat = false
        self.lastCombatLockdown = false
        self.lastCachedCombat = false
        self.lastCombatMismatch = false
        self.lastDynamicCamLoaded = false
        self.lastDynamicCamStatusKnown = false
        self.lastDynamicCamStatusSource = nil
        self.lastAPIAvailable = false
        self.lastZoomSpeed = nil
        self.startZoom = nil
        self.targetZoom = nil
        self.turnZoom = nil
        self.finalZoom = nil
        self.outboundElapsed = nil
        self.returnElapsed = nil
        self.targetReached = false
        self.moved = false
        self.restored = false
        self.runCount = 0
        self.passCount = 0
        self.failCount = 0
    end,
})

function Probe:ResetTransient()
    self.lastError = nil
    self.lastSecret = false
    self.lastCombat = false
    self.lastCombatLockdown = false
    self.lastCachedCombat = false
    self.lastCombatMismatch = false
    self.lastAPIAvailable = false
    self.lastZoomSpeed = nil
    self.startZoom = nil
    self.targetZoom = nil
    self.turnZoom = nil
    self.finalZoom = nil
    self.outboundElapsed = nil
    self.returnElapsed = nil
    self.targetReached = false
    self.moved = false
    self.restored = false
    self.legStartTime = nil
    self.legStartZoom = nil
    self.legTargetZoom = nil
end

function Probe:StopFrame()
    if self.frame then
        self.frame:SetScript("OnUpdate", nil)
        self.frame:Hide()
    end
end

function Probe:FailImmediate(reason, secret)
    stopMotion()
    self:StopFrame()
    self.running = false
    self.phase = "idle"
    self.lastState = "fail"
    self.lastError = tostring(reason)
    self.lastSecret = secret and true or false
    self.lastReported = true
    self.failCount = self.failCount + 1
    return false, self.lastError
end

function Probe:Finish()
    local stopOK, stopError = stopMotion()
    self:StopFrame()
    self.running = false
    self.phase = "idle"

    if not stopOK and not self.lastError then
        self.lastError = stopError
    end

    local finalZoom, finalError, finalSecret = readZoom()
    if finalZoom == nil then
        if finalSecret then
            self.lastSecret = true
        end

        if not self.lastError then
            self.lastError = finalError
        end
    else
        self.finalZoom = finalZoom
    end

    if type(self.turnZoom) == "number"
        and type(self.startZoom) == "number"
    then
        self.moved =
            math.abs(self.turnZoom - self.startZoom) >= MIN_MOVEMENT
    end

    if type(self.turnZoom) == "number"
        and type(self.targetZoom) == "number"
    then
        self.targetReached =
            math.abs(self.turnZoom - self.targetZoom) <= TARGET_TOLERANCE
    end

    if type(self.finalZoom) == "number"
        and type(self.startZoom) == "number"
    then
        self.restored =
            math.abs(self.finalZoom - self.startZoom) <= TARGET_TOLERANCE
    end

    local passed =
        self.lastError == nil
        and self.lastSecret == false
        and self.moved == true
        and self.targetReached == true
        and self.restored == true

    if passed then
        self.lastState = "pass"
        self.passCount = self.passCount + 1
    else
        self.lastState = "fail"
        self.failCount = self.failCount + 1

        if not self.lastError then
            self.lastError = "movement/target/restoration tolerance failed"
        end
    end

    self.lastReported = false
end

function Probe:BeginLeg(targetZoom, phase)
    local currentZoom, zoomError, zoomSecret = readZoom()
    if currentZoom == nil then
        if zoomSecret then
            self.lastSecret = true
        end

        self.lastError = zoomError
        self:Finish()
        return false
    end

    local delta = targetZoom - currentZoom

    if math.abs(delta) <= 0.01 then
        if phase == "outbound" then
            self.turnZoom = currentZoom
            return self:BeginLeg(self.startZoom, "return")
        end

        self.finalZoom = currentZoom
        self:Finish()
        return true
    end

    local desiredUnitsPerSecond =
        math.abs(delta) / PROBE_LEG_DURATION
    local factor =
        desiredUnitsPerSecond / self.lastZoomSpeed

    local stopOK, stopError = stopMotion()
    if not stopOK then
        self.lastError = stopError
        self:Finish()
        return false
    end

    local moveFunc
    if delta > 0 then
        moveFunc = MoveViewOutStart
    else
        moveFunc = MoveViewInStart
    end

    local ok, moveError = pcall(moveFunc, factor)
    if not ok then
        self.lastError = tostring(moveError)
        self:Finish()
        return false
    end

    self.phase = phase
    self.legStartTime = GetTime()
    self.legStartZoom = currentZoom
    self.legTargetZoom = targetZoom
    return true
end

function Probe:OnUpdate()
    if not self.running then
        return
    end

    local currentZoom, zoomError, zoomSecret = readZoom()
    if currentZoom == nil then
        if zoomSecret then
            self.lastSecret = true
        end

        self.lastError = zoomError
        self:Finish()
        return
    end

    local elapsed = GetTime() - self.legStartTime
    local delta = self.legTargetZoom - self.legStartZoom
    local reached =
        (delta > 0 and currentZoom >= self.legTargetZoom)
        or (delta < 0 and currentZoom <= self.legTargetZoom)
    local timedOut =
        elapsed >= (PROBE_LEG_DURATION + PROBE_TIMEOUT_EXTRA)

    if not reached and not timedOut then
        return
    end

    local stopOK, stopError = stopMotion()
    if not stopOK and not self.lastError then
        self.lastError = stopError
    end

    if self.phase == "outbound" then
        self.turnZoom = currentZoom
        self.outboundElapsed = elapsed

        self:BeginLeg(self.startZoom, "return")
        return
    end

    if self.phase == "return" then
        self.finalZoom = currentZoom
        self.returnElapsed = elapsed
        self:Finish()
    end
end

function Probe:StartProbe()
    if self.running then
        return false, "probe already running"
    end

    self:ResetTransient()

    local productionController = Logres:GetModule("CameraWorldCombat")
    if productionController:IsEnabled() then
        return self:FailImmediate(
            "production camera controller enabled; disable it before manual camera probe",
            false
        )
    end

    local dynamicCamLoaded, statusKnown, statusSource =
        queryDynamicCamLoaded()

    self.lastDynamicCamLoaded = dynamicCamLoaded
    self.lastDynamicCamStatusKnown = statusKnown
    self.lastDynamicCamStatusSource = statusSource

    if not statusKnown then
        return self:FailImmediate(
            "cannot verify whether DynamicCam is loaded",
            false
        )
    end

    if dynamicCamLoaded then
        return self:FailImmediate(
            "DynamicCam is loaded; disable it for isolated camera proof",
            false
        )
    end

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
            return self:FailImmediate(
                "required camera API unavailable",
                false
            )
        end
    end

    self.lastAPIAvailable = true

    local zoomSpeed, speedError, speedSecret = readZoomSpeed()
    if zoomSpeed == nil then
        return self:FailImmediate(speedError, speedSecret)
    end

    local startZoom, zoomError, zoomSecret = readZoom()
    if startZoom == nil then
        return self:FailImmediate(zoomError, zoomSecret)
    end

    self.lastZoomSpeed = zoomSpeed
    self.startZoom = startZoom

    if startZoom >= PROBE_DELTA then
        self.targetZoom = startZoom - PROBE_DELTA
    else
        self.targetZoom = startZoom + PROBE_DELTA
    end

    local state = Logres:GetState()
    local combatEngaged, combatLockdown, combatError, combatSecret =
        readCombatSignals()

    if combatEngaged == nil then
        return self:FailImmediate(combatError, combatSecret)
    end

    self.lastCombat = combatEngaged
    self.lastCombatLockdown = combatLockdown
    self.lastCachedCombat = state.combat == true
    self.lastCombatMismatch =
        self.lastCombat ~= self.lastCachedCombat

    self.runCount = self.runCount + 1
    self.lastState = "running"
    self.lastReported = true
    self.running = true

    self.frame:SetScript("OnUpdate", function()
        self:OnUpdate()
    end)
    self.frame:Show()

    if not self:BeginLeg(self.targetZoom, "outbound") then
        return false, self.lastError
    end

    return true, "started"
end

function Probe:HandlePanelAction()
    if self.running then
        return "running", nil
    end

    if (
        self.lastState == "pass"
        or self.lastState == "fail"
    ) and not self.lastReported then
        return "result", nil
    end

    local ok, reason = self:StartProbe()
    if ok then
        return "started", reason
    end

    return "blocked", reason
end

function Probe:MarkReported()
    self.lastReported = true
end

function Probe:GetDebugStatus()
    return {
        running = self.running,
        phase = self.phase,
        lastState = self.lastState,
        lastReported = self.lastReported,
        lastError = self.lastError,
        lastSecret = self.lastSecret,
        lastCombat = self.lastCombat,
        lastCombatLockdown = self.lastCombatLockdown,
        lastCachedCombat = self.lastCachedCombat,
        lastCombatMismatch = self.lastCombatMismatch,
        lastDynamicCamLoaded = self.lastDynamicCamLoaded,
        lastDynamicCamStatusKnown = self.lastDynamicCamStatusKnown,
        lastDynamicCamStatusSource = self.lastDynamicCamStatusSource,
        lastAPIAvailable = self.lastAPIAvailable,
        lastZoomSpeed = self.lastZoomSpeed,
        startZoom = self.startZoom,
        targetZoom = self.targetZoom,
        turnZoom = self.turnZoom,
        finalZoom = self.finalZoom,
        outboundElapsed = self.outboundElapsed,
        returnElapsed = self.returnElapsed,
        targetReached = self.targetReached,
        moved = self.moved,
        restored = self.restored,
        runCount = self.runCount,
        passCount = self.passCount,
        failCount = self.failCount,
    }
end
