local _, Logres = ...

local compassStyle =
    (Logres.Theme and Logres.Theme.compass) or {}
local compassAssets = compassStyle.assets or {}
local compassLabels = compassStyle.labels or {}
local baselineStyle = compassStyle.baseline or {}
local centerStyle = compassStyle.center or {}
local tickStyle = compassStyle.ticks or {}
local cardinalTickStyle = tickStyle.cardinal or {}
local intercardinalTickStyle = tickStyle.intercardinal or {}
local manualWaypointStyle = compassStyle.manualWaypoint or {}

local UPDATE_INTERVAL = 0.05
local WAYPOINT_UPDATE_INTERVAL = 0.15
local COMPASS_WIDTH = compassStyle.width or 400
local COMPASS_HEIGHT = compassStyle.height or 54
local TAPE_WIDTH = compassStyle.tapeWidth or 360
local TAPE_Y = compassStyle.tapeY or -4
local VISIBLE_HALF_ANGLE = compassStyle.visibleHalfAngle or 100
local EDGE_FADE_START = compassStyle.edgeFadeStart or 78
local PIXELS_PER_DEGREE = TAPE_WIDTH / (VISIBLE_HALF_ANGLE * 2)

local BASELINE_HEIGHT = baselineStyle.height or 8
local CENTER_WIDTH = centerStyle.width or 8
local CENTER_HEIGHT = centerStyle.height or 24

local CARDINAL_TICK_WIDTH = cardinalTickStyle.width or 7
local CARDINAL_TICK_HEIGHT = cardinalTickStyle.height or 16
local CARDINAL_LABEL_GAP = cardinalTickStyle.labelGap or 3

local INTERCARDINAL_TICK_WIDTH = intercardinalTickStyle.width or 5
local INTERCARDINAL_TICK_HEIGHT = intercardinalTickStyle.height or 11
local INTERCARDINAL_LABEL_GAP = intercardinalTickStyle.labelGap or 3

local MANUAL_WIDTH = manualWaypointStyle.width or 12
local MANUAL_HEIGHT = manualWaypointStyle.height or 20
local MANUAL_ALPHA = manualWaypointStyle.alpha or 0.95
local MANUAL_FOCUS_ANGLE = manualWaypointStyle.focusAngle or 8
local MANUAL_FOCUS_SCALE = manualWaypointStyle.focusScale or 1.07

local CARDINAL_LABEL_COLOR =
    compassLabels.cardinal or { 0.94, 0.84, 0.62, 0.96 }
local INTERCARDINAL_LABEL_COLOR =
    compassLabels.intercardinal or { 0.72, 0.68, 0.60, 0.82 }

local DIRECTIONS = {
    { label = "N", degrees = 0, cardinal = true },
    { label = "NE", degrees = 45, cardinal = false },
    { label = "E", degrees = 90, cardinal = true },
    { label = "SE", degrees = 135, cardinal = false },
    { label = "S", degrees = 180, cardinal = true },
    { label = "SW", degrees = 225, cardinal = false },
    { label = "W", degrees = 270, cardinal = true },
    { label = "NW", degrees = 315, cardinal = false },
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function normalizeRelativeDegrees(value)
    return ((value + 180) % 360) - 180
end

local function headingFromFacing(facing)
    return (360 - math.deg(facing)) % 360
end

local function edgeFadeForMagnitude(magnitude)
    if magnitude <= EDGE_FADE_START then
        return 1
    end

    if magnitude >= VISIBLE_HALF_ANGLE then
        return 0
    end

    return math.max(
        0,
        (VISIBLE_HALF_ANGLE - magnitude)
            / (VISIBLE_HALF_ANGLE - EDGE_FADE_START)
    )
end

local function manualWaypointScaleForMagnitude(magnitude)
    if magnitude >= MANUAL_FOCUS_ANGLE then
        return 1
    end

    local focus =
        1 - (magnitude / MANUAL_FOCUS_ANGLE)

    return 1 + focus * (MANUAL_FOCUS_SCALE - 1)
end

local function readVectorXY(value)
    if value == nil then
        return nil, nil, "position-unavailable"
    end

    if isSecret(value) then
        return nil, nil, "position-secret"
    end

    local x
    local y

    if type(value.GetXY) == "function" then
        local ok
        ok, x, y = pcall(value.GetXY, value)

        if not ok then
            return nil, nil, "position-getxy-failed"
        end
    else
        x = value.x
        y = value.y
    end

    if isSecret(x) or isSecret(y) then
        return nil, nil, "position-component-secret"
    end

    if type(x) ~= "number" or type(y) ~= "number" then
        return nil, nil, "position-component-invalid"
    end

    return x, y, nil
end

local Compass = Logres:RegisterModule("Compass", {
    OnInitialize = function(self)
        self.moduleEnabled = false
        self.policyEligible = false
        self.immersionEnabled = false
        self.context = "unknown"

        self.facingAPIAvailable = type(GetPlayerFacing) == "function"
        self.facingAvailable = false
        self.presentationActive = false
        self.headingDegrees = nil

        self.waypointAPIAvailable = false
        self.waypointEventRegistered = false
        self.waypointSourcePresent = false
        self.waypointBearingAvailable = false
        self.waypointBearingDegrees = nil
        self.waypointRelativeDegrees = nil
        self.waypointMarkerShown = false
        self.waypointMapID = nil
        self.waypointElapsed = 0
        self.lastWaypointReason = "initialize"
        self.lastWaypointError = nil

        self.updateActive = false
        self.elapsed = 0
        self.lastReason = "initialize"
        self.lastError = nil

        local frame = CreateFrame("Frame", "LogresCompassFrame", UIParent)
        frame:SetSize(COMPASS_WIDTH, COMPASS_HEIGHT)
        frame:SetPoint("TOP", UIParent, "TOP", 0, -48)
        frame:SetFrameStrata("MEDIUM")
        frame:EnableMouse(false)
        frame:Hide()

        local baseline = frame:CreateTexture(nil, "BACKGROUND")
        baseline:SetSize(TAPE_WIDTH, BASELINE_HEIGHT)
        baseline:SetPoint("CENTER", frame, "CENTER", 0, TAPE_Y)
        baseline:SetTexture(compassAssets.baseline)

        local center = frame:CreateTexture(nil, "OVERLAY")
        center:SetSize(CENTER_WIDTH, CENTER_HEIGHT)
        center:SetPoint("BOTTOM", frame, "CENTER", 0, TAPE_Y)
        center:SetTexture(compassAssets.center)

        local waypointMarker = frame:CreateTexture(nil, "OVERLAY")
        waypointMarker:SetSize(MANUAL_WIDTH, MANUAL_HEIGHT)
        waypointMarker:SetTexture(compassAssets.manualWaypoint)
        waypointMarker:SetAlpha(MANUAL_ALPHA)
        waypointMarker:Hide()

        self.frame = frame
        self.baseline = baseline
        self.centerMarker = center
        self.waypointMarker = waypointMarker
        self.directionWidgets = {}

        for index = 1, #DIRECTIONS do
            local definition = DIRECTIONS[index]

            local tick = frame:CreateTexture(nil, "ARTWORK")

            if definition.cardinal then
                tick:SetSize(
                    CARDINAL_TICK_WIDTH,
                    CARDINAL_TICK_HEIGHT
                )
                tick:SetTexture(compassAssets.cardinalTick)
            else
                tick:SetSize(
                    INTERCARDINAL_TICK_WIDTH,
                    INTERCARDINAL_TICK_HEIGHT
                )
                tick:SetTexture(compassAssets.intercardinalTick)
            end

            local label = frame:CreateFontString(
                nil,
                "OVERLAY",
                definition.cardinal
                    and "GameFontNormal"
                    or "GameFontHighlightSmall"
            )
            label:SetText(definition.label)

            local labelColor =
                definition.cardinal
                and CARDINAL_LABEL_COLOR
                or INTERCARDINAL_LABEL_COLOR

            label:SetTextColor(
                labelColor[1],
                labelColor[2],
                labelColor[3],
                labelColor[4]
            )

            self.directionWidgets[index] = {
                definition = definition,
                tick = tick,
                label = label,
            }
        end

        local waypointEventFrame = CreateFrame("Frame")
        local registered = pcall(
            waypointEventFrame.RegisterEvent,
            waypointEventFrame,
            "USER_WAYPOINT_UPDATED"
        )

        self.waypointEventRegistered = registered and true or false

        waypointEventFrame:SetScript("OnEvent", function(_, event)
            if not self.moduleEnabled or not self.policyEligible then
                return
            end

            self:RefreshWaypointBearing(event)
        end)

        self.waypointEventFrame = waypointEventFrame

        self.onUpdateHandler = function(_, elapsed)
            self:OnUpdate(elapsed)
        end
    end,

    OnEnable = function(self)
        self.moduleEnabled = true

        self:SubscribeState(function()
            self:ReconcilePolicy("state")
        end)

        self:SubscribePreferences(function()
            self:ReconcilePolicy("preference")
        end)

        self:ReconcilePolicy("enable")
    end,

    OnDisable = function(self)
        self.moduleEnabled = false
        self.policyEligible = false
        self:SetUpdateActive(false)
        self:ClearWaypointPresentation("module-disabled")
        self:ClearPresentation("module-disabled")
    end,
})

function Compass:SetUpdateActive(enabled)
    enabled = enabled and true or false

    if self.updateActive == enabled then
        return
    end

    self.updateActive = enabled
    self.elapsed = 0
    self.waypointElapsed = 0

    if enabled then
        self.frame:SetScript("OnUpdate", self.onUpdateHandler)
    else
        self.frame:SetScript("OnUpdate", nil)
    end
end

function Compass:SetWaypointMarkerShown(shown)
    shown = shown and true or false

    self.waypointMarkerShown = shown

    if shown then
        self.waypointMarker:Show()
    else
        self.waypointMarker:Hide()
    end
end

function Compass:ClearWaypointPresentation(reason, errorText)
    self.waypointSourcePresent = false
    self.waypointBearingAvailable = false
    self.waypointBearingDegrees = nil
    self.waypointRelativeDegrees = nil
    self.waypointMapID = nil
    self.lastWaypointReason = reason or "waypoint-unavailable"
    self.lastWaypointError = errorText
    self:SetWaypointMarkerShown(false)
end

function Compass:ClearPresentation(reason, errorText)
    self.facingAvailable = false
    self.presentationActive = false
    self.headingDegrees = nil
    self.waypointRelativeDegrees = nil
    self.lastReason = reason or "unavailable"
    self.lastError = errorText
    self:SetWaypointMarkerShown(false)
    self.frame:Hide()
end

function Compass:UpdateTape(headingDegrees)
    for index = 1, #self.directionWidgets do
        local widget = self.directionWidgets[index]
        local offset = normalizeRelativeDegrees(
            widget.definition.degrees - headingDegrees
        )
        local magnitude = math.abs(offset)

        if magnitude <= VISIBLE_HALF_ANGLE then
            local x = offset * PIXELS_PER_DEGREE
            local fade = edgeFadeForMagnitude(magnitude)
            local labelGap =
                widget.definition.cardinal
                and CARDINAL_LABEL_GAP
                or INTERCARDINAL_LABEL_GAP

            widget.tick:ClearAllPoints()
            widget.tick:SetPoint(
                "CENTER",
                self.frame,
                "CENTER",
                x,
                TAPE_Y
            )
            widget.tick:SetAlpha(fade)
            widget.tick:Show()

            widget.label:ClearAllPoints()
            widget.label:SetPoint(
                "BOTTOM",
                widget.tick,
                "TOP",
                0,
                labelGap
            )
            widget.label:SetAlpha(fade)
            widget.label:Show()
        else
            widget.tick:Hide()
            widget.label:Hide()
        end
    end
end

function Compass:UpdateWaypointMarker()
    self:SetWaypointMarkerShown(false)
    self.waypointRelativeDegrees = nil

    if not self.presentationActive
        or type(self.headingDegrees) ~= "number"
        or not self.waypointBearingAvailable
        or type(self.waypointBearingDegrees) ~= "number"
    then
        return
    end

    local relative = normalizeRelativeDegrees(
        self.waypointBearingDegrees - self.headingDegrees
    )

    self.waypointRelativeDegrees = relative

    local magnitude = math.abs(relative)

    if magnitude > VISIBLE_HALF_ANGLE then
        return
    end

    local x = relative * PIXELS_PER_DEGREE
    local edgeAlpha =
        MANUAL_ALPHA * edgeFadeForMagnitude(magnitude)
    local scale =
        manualWaypointScaleForMagnitude(magnitude)

    self.waypointMarker:ClearAllPoints()
    self.waypointMarker:SetPoint(
        "BOTTOM",
        self.frame,
        "CENTER",
        x,
        TAPE_Y
    )
    self.waypointMarker:SetSize(
        MANUAL_WIDTH * scale,
        MANUAL_HEIGHT * scale
    )
    self.waypointMarker:SetAlpha(edgeAlpha)

    self:SetWaypointMarkerShown(true)
end

function Compass:RefreshWaypointBearing(reason)
    self.waypointAPIAvailable =
        C_Map ~= nil
        and type(C_Map.GetBestMapForUnit) == "function"
        and type(C_Map.GetPlayerMapPosition) == "function"
        and type(C_Map.GetUserWaypoint) == "function"
        and type(C_Map.GetUserWaypointPositionForMap) == "function"
        and type(math.atan2) == "function"

    if not self.policyEligible then
        self:ClearWaypointPresentation(reason or "policy-ineligible")
        return false
    end

    if not self.waypointAPIAvailable then
        self:ClearWaypointPresentation(
            "waypoint-api-unavailable",
            "required waypoint API unavailable"
        )
        return false
    end

    local waypointOK, waypoint = pcall(C_Map.GetUserWaypoint)

    if not waypointOK then
        self:ClearWaypointPresentation(
            "waypoint-call-failed",
            "GetUserWaypoint call failed"
        )
        return false
    end

    if isSecret(waypoint) then
        self:ClearWaypointPresentation("waypoint-secret")
        return false
    end

    if waypoint == nil then
        self:ClearWaypointPresentation("waypoint-absent")
        return true
    end

    self.waypointSourcePresent = true

    local mapOK, mapID = pcall(C_Map.GetBestMapForUnit, "player")

    if not mapOK then
        self:ClearWaypointPresentation(
            "player-map-call-failed",
            "GetBestMapForUnit call failed"
        )
        return false
    end

    if isSecret(mapID) then
        self:ClearWaypointPresentation("player-map-secret")
        return false
    end

    if type(mapID) ~= "number" then
        self:ClearWaypointPresentation("player-map-unavailable")
        return false
    end

    local playerOK, playerPosition = pcall(
        C_Map.GetPlayerMapPosition,
        mapID,
        "player"
    )

    if not playerOK then
        self:ClearWaypointPresentation(
            "player-position-call-failed",
            "GetPlayerMapPosition call failed"
        )
        return false
    end

    local playerX, playerY, playerError =
        readVectorXY(playerPosition)

    if playerError then
        self:ClearWaypointPresentation(playerError)
        return false
    end

    local destinationOK, destinationPosition = pcall(
        C_Map.GetUserWaypointPositionForMap,
        mapID
    )

    if not destinationOK then
        self:ClearWaypointPresentation(
            "waypoint-position-call-failed",
            "GetUserWaypointPositionForMap call failed"
        )
        return false
    end

    local destinationX, destinationY, destinationError =
        readVectorXY(destinationPosition)

    if destinationError then
        self:ClearWaypointPresentation(destinationError)
        return false
    end

    local dx = destinationX - playerX
    local dy = destinationY - playerY

    if dx == 0 and dy == 0 then
        self:ClearWaypointPresentation("waypoint-coincident")
        return true
    end

    local bearingDegrees =
        (math.deg(math.atan2(dx, -dy)) + 360) % 360

    self.waypointSourcePresent = true
    self.waypointBearingAvailable = true
    self.waypointBearingDegrees = bearingDegrees
    self.waypointMapID = mapID
    self.lastWaypointReason = reason or "waypoint-refresh"
    self.lastWaypointError = nil

    self:UpdateWaypointMarker()
    return true
end

function Compass:RefreshHeading(reason)
    if not self.policyEligible then
        self:ClearPresentation(reason or "policy-ineligible")
        return false
    end

    self.facingAPIAvailable = type(GetPlayerFacing) == "function"

    if not self.facingAPIAvailable then
        self:ClearPresentation(
            "facing-api-unavailable",
            "GetPlayerFacing unavailable"
        )
        return false
    end

    local ok, facing = pcall(GetPlayerFacing)

    if not ok then
        self:ClearPresentation(
            "facing-call-failed",
            "GetPlayerFacing call failed"
        )
        return false
    end

    if isSecret(facing) then
        self:ClearPresentation("facing-secret")
        return false
    end

    if facing == nil then
        self:ClearPresentation("facing-unavailable")
        return false
    end

    if type(facing) ~= "number" then
        self:ClearPresentation("facing-invalid")
        return false
    end

    local headingDegrees = headingFromFacing(facing)

    self:UpdateTape(headingDegrees)

    self.facingAvailable = true
    self.presentationActive = true
    self.headingDegrees = headingDegrees
    self.lastReason = reason or "heading-refresh"
    self.lastError = nil

    self:UpdateWaypointMarker()
    self.frame:Show()
    return true
end

function Compass:ReconcilePolicy(reason)
    local preferences = Logres:GetPreferences()
    local state = Logres:GetState()

    self.immersionEnabled = preferences.immersionEnabled == true
    self.context = state.context

    self.policyEligible =
        self.moduleEnabled == true
        and self.immersionEnabled == true
        and self.context == "world"

    if not self.policyEligible then
        self:SetUpdateActive(false)

        if not self.moduleEnabled then
            self:ClearWaypointPresentation("module-disabled")
            self:ClearPresentation("module-disabled")
        elseif not self.immersionEnabled then
            self:ClearWaypointPresentation("immersion-off")
            self:ClearPresentation("immersion-off")
        else
            local contextReason = "context-" .. tostring(self.context)
            self:ClearWaypointPresentation(contextReason)
            self:ClearPresentation(contextReason)
        end

        return
    end

    -- World context is the only context in which navigation samples are used.
    -- If a sample is temporarily unavailable, keep the throttled sampler alive
    -- so capability can recover without inventing heading or waypoint state.
    self:SetUpdateActive(true)
    self:RefreshHeading(reason or "policy")
    self:RefreshWaypointBearing(reason or "policy")
end

function Compass:OnUpdate(elapsed)
    if not self.policyEligible then
        return
    end

    self.elapsed = self.elapsed + elapsed
    self.waypointElapsed = self.waypointElapsed + elapsed

    if self.elapsed >= UPDATE_INTERVAL then
        self.elapsed = self.elapsed % UPDATE_INTERVAL
        self:RefreshHeading("onupdate")
    end

    if self.waypointElapsed >= WAYPOINT_UPDATE_INTERVAL then
        self.waypointElapsed =
            self.waypointElapsed % WAYPOINT_UPDATE_INTERVAL
        self:RefreshWaypointBearing("onupdate")
    end
end

function Compass:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.frame ~= nil,
        rootShown = self.frame ~= nil and self.frame:IsShown() or false,
        directionCount = #self.directionWidgets,

        immersionEnabled = self.immersionEnabled == true,
        context = self.context,
        policyEligible = self.policyEligible == true,

        facingAPIAvailable = self.facingAPIAvailable == true,
        facingAvailable = self.facingAvailable == true,
        updateActive = self.updateActive == true,

        presentationActive = self.presentationActive == true,
        headingDegrees = self.headingDegrees,

        waypointAPIAvailable = self.waypointAPIAvailable == true,
        waypointEventRegistered = self.waypointEventRegistered == true,
        waypointSourcePresent = self.waypointSourcePresent == true,
        waypointBearingAvailable = self.waypointBearingAvailable == true,
        waypointBearingDegrees = self.waypointBearingDegrees,
        waypointRelativeDegrees = self.waypointRelativeDegrees,
        waypointMarkerReady = self.waypointMarker ~= nil,
        waypointMarkerShown = self.waypointMarkerShown == true,
        waypointMapID = self.waypointMapID,
        lastWaypointReason = self.lastWaypointReason,
        lastWaypointError = self.lastWaypointError,

        lastReason = self.lastReason,
        lastError = self.lastError,
    }
end
