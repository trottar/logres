local _, Logres = ...

local compassStyle =
    (Logres.Theme and Logres.Theme.compass) or {}
local compassAssets = compassStyle.assets or {}
local compassLabels = compassStyle.labels or {}
local labelContrast = compassStyle.labelContrast or {}
local cardinalShadow = labelContrast.cardinalShadow or { 0.02, 0.02, 0.02, 0.95 }
local intercardinalShadow = labelContrast.intercardinalShadow or { 0.02, 0.02, 0.02, 0.91 }
local labelShadowOffset = labelContrast.shadowOffset or { 1, -1 }
local baselineStyle = compassStyle.baseline or {}
local centerStyle = compassStyle.center or {}
local tickStyle = compassStyle.ticks or {}
local cardinalTickStyle = tickStyle.cardinal or {}
local intercardinalTickStyle = tickStyle.intercardinal or {}
local manualWaypointStyle = compassStyle.manualWaypoint or {}
local questStyle = compassStyle.questDestination or {}
local poiStyle = compassStyle.localPOI or {}
local trackingStyle = compassStyle.tracking or {}
-- These are only possible historical service sites, not live tracking blips.
local SERVICE_MARKER_STYLE = {
    flight = { name = "Possible flight master: ", r = 0.52, g = 0.79, b = 0.98 },
    inn = { name = "Possible innkeeper: ", r = 0.97, g = 0.75, b = 0.44 },
    repair = { name = "Possible repair: ", r = 0.70, g = 0.83, b = 0.71 },
}

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
local MANUAL_DEPTH_CLOSE_RADIUS_FACTOR =
    manualWaypointStyle.depthCloseRadiusFactor or 0.50
local MANUAL_DEPTH_NEAR_RADIUS_FACTOR =
    manualWaypointStyle.depthNearRadiusFactor or 1.00
local MANUAL_DEPTH_MEDIUM_RADIUS_FACTOR =
    manualWaypointStyle.depthMediumRadiusFactor or 4.00
local MANUAL_DEPTH_FAR_RADIUS_FACTOR =
    manualWaypointStyle.depthFarRadiusFactor or 8.00
local MANUAL_DEPTH_CLOSE_SCALE =
    manualWaypointStyle.depthCloseScale or 1.20
local MANUAL_DEPTH_NEAR_SCALE =
    manualWaypointStyle.depthNearScale or 1.05
local MANUAL_DEPTH_MEDIUM_SCALE =
    manualWaypointStyle.depthMediumScale or 0.85
local MANUAL_DEPTH_FAR_SCALE =
    manualWaypointStyle.depthFarScale or 0.70
local MANUAL_RENDER_SCALE_MIN =
    manualWaypointStyle.renderScaleMin or 0.70
local MANUAL_RENDER_SCALE_MAX =
    manualWaypointStyle.renderScaleMax or 1.28

local CARDINAL_LABEL_COLOR =
    labelContrast.cardinal or compassLabels.cardinal or { 0.94, 0.84, 0.62, 0.96 }
local INTERCARDINAL_LABEL_COLOR =
    labelContrast.intercardinal or compassLabels.intercardinal or { 0.72, 0.68, 0.60, 0.82 }

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

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function interpolateDepthScale(
    ratio,
    startRatio,
    endRatio,
    startScale,
    endScale
)
    local span = endRatio - startRatio

    if span <= 0 then
        return startScale
    end

    local progress = (ratio - startRatio) / span
    return startScale + progress * (endScale - startScale)
end

local function manualWaypointDepthScaleForDistance(distanceYards, viewRadiusYards)
    if type(distanceYards) ~= "number"
        or type(viewRadiusYards) ~= "number"
        or viewRadiusYards <= 0
    then
        return 1, nil, nil
    end

    local ratio = distanceYards / viewRadiusYards

    if ratio <= MANUAL_DEPTH_CLOSE_RADIUS_FACTOR then
        return MANUAL_DEPTH_CLOSE_SCALE, "close", ratio
    end

    if ratio <= MANUAL_DEPTH_NEAR_RADIUS_FACTOR then
        return interpolateDepthScale(
            ratio,
            MANUAL_DEPTH_CLOSE_RADIUS_FACTOR,
            MANUAL_DEPTH_NEAR_RADIUS_FACTOR,
            MANUAL_DEPTH_CLOSE_SCALE,
            MANUAL_DEPTH_NEAR_SCALE
        ), "near", ratio
    end

    if ratio <= MANUAL_DEPTH_MEDIUM_RADIUS_FACTOR then
        return interpolateDepthScale(
            ratio,
            MANUAL_DEPTH_NEAR_RADIUS_FACTOR,
            MANUAL_DEPTH_MEDIUM_RADIUS_FACTOR,
            MANUAL_DEPTH_NEAR_SCALE,
            MANUAL_DEPTH_MEDIUM_SCALE
        ), "medium", ratio
    end

    if ratio <= MANUAL_DEPTH_FAR_RADIUS_FACTOR then
        return interpolateDepthScale(
            ratio,
            MANUAL_DEPTH_MEDIUM_RADIUS_FACTOR,
            MANUAL_DEPTH_FAR_RADIUS_FACTOR,
            MANUAL_DEPTH_MEDIUM_SCALE,
            MANUAL_DEPTH_FAR_SCALE
        ), "far", ratio
    end

    return MANUAL_DEPTH_FAR_SCALE, "far", ratio
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
        self.waypointSourceMapID = nil
        self.waypointDistanceAPIAvailable = false
        self.waypointDistanceAvailable = false
        self.waypointDistanceYards = nil
        self.waypointViewRadiusAPIAvailable = false
        self.waypointViewRadiusAvailable = false
        self.waypointViewRadiusYards = nil
        self.waypointDistanceRadiusRatio = nil
        self.waypointDepthBand = nil
        self.waypointDepthScale = 1
        self.waypointRenderScale = nil
        self.waypointElapsed = 0
        self.lastWaypointDistanceReason = "initialize"
        self.lastWaypointDistanceError = nil
        self.lastWaypointDepthReason = "initialize"
        self.lastWaypointDepthError = nil
        self.lastWaypointReason = "initialize"
        self.lastWaypointError = nil

        self.artworkPreview = false
        self.artworkPreviewShown = false
        self.availableQuestPoiShown = 0
        self.availableQuestPoiCandidates = 0
        self.availableQuestPoiReason = "initialize"
        self.questDestinationShown = 0
        self.questDestinationCandidates = 0
        self.trackingShown = 0
        self.trackingCandidates = 0
        self.dbServiceCandidateShown = 0
        self.dbServiceCandidateCount = 0
        self.dbServiceStatus = "not-started"
        self.updateActive = false
        self.elapsed = 0
        self.lastReason = "initialize"
        self.lastError = nil

        local frame = CreateFrame("Frame", "LogresCompassFrame", UIParent)
        frame:SetSize(COMPASS_WIDTH, COMPASS_HEIGHT)
        frame:SetPoint("TOP", UIParent, "TOP", 0, -48)
        Logres.Layout.Bind(frame, "navigation", "TOP", "TOP")
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
        -- These three addon-owned glyphs have no live source. The developer
        -- preview demonstrates sheet-12 lane/scale fidelity without inventing
        -- quest/POI/tracking world positions or changing the real compass.
        self.artworkPreviewMarkers = {}
        local roles = {
            { "questDestination", compassAssets.questDestination, questStyle, "BOTTOM", 67, TAPE_Y },
            { "localPOI", compassAssets.localPOI, poiStyle, "CENTER", -75, TAPE_Y },
            { "tracking", compassAssets.tracking, trackingStyle, "TOP", 113, TAPE_Y },
        }
        for index = 1, #roles do
            local role = roles[index]
            local glyph = frame:CreateTexture(nil, "OVERLAY")
            glyph:SetTexture(role[2])
            glyph:SetSize(role[3].width or 9, role[3].height or 9)
            glyph:SetPoint(role[4], frame, "CENTER", role[5], role[6])
            glyph:SetAlpha(role[3].alpha or 0.90)
            glyph:Hide()
            self.artworkPreviewMarkers[role[1]] = glyph
        end
        local previewCaption = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        previewCaption:SetPoint("TOP", frame, "BOTTOM", 0, -2)
        previewCaption:SetText("COMPASS ART PREVIEW · NOT LIVE NAVIGATION")
        previewCaption:SetTextColor(0.84, 0.73, 0.56, 0.90)
        previewCaption:Hide()
        self.artworkPreviewCaption = previewCaption
        -- P0220: live, source-backed *local POI* glyphs; no new controls or
        -- use of the Blizzard map canvas or its protected pin presentation.
        self.availableQuestPoiMarkers = {}
        for index = 1, 8 do
            local glyph = frame:CreateTexture(nil, "OVERLAY")
            glyph:SetTexture(compassAssets.localPOI)
            glyph:SetSize(poiStyle.width or 9, poiStyle.height or 9)
            glyph:SetAlpha(poiStyle.alpha or 0.90)
            glyph:Hide()
            self.availableQuestPoiMarkers[index] = glyph
        end
        local poiFocus = frame:CreateFontString(
            nil, "OVERLAY", "GameFontHighlightSmall"
        )
        poiFocus:SetPoint("TOP", frame, "CENTER", 0, -15)
        poiFocus:SetTextColor(0.94, 0.86, 0.69, 0.95)
        poiFocus:SetShadowColor(0.01, 0.01, 0.01, 0.95)
        poiFocus:SetShadowOffset(1, -1)
        poiFocus:Hide()
        self.availableQuestPoiFocus = poiFocus
        -- Independent finite service pool: flight masters qualify even if an
        -- NPC has NEVER offered a quest and the quest POI pool is full.
        self.serviceMarkers = {}
        for index = 1, 4 do
            local glyph = frame:CreateTexture(nil, "OVERLAY")
            glyph:SetTexture(compassAssets.localPOI)
            glyph:SetSize(poiStyle.width or 9, poiStyle.height or 9)
            glyph:SetAlpha((poiStyle.alpha or 0.90) * 0.65)
            glyph:Hide()
            self.serviceMarkers[index] = glyph
        end
        self.questDestinationMarkers = {}
        for index=1,4 do
            local glyph=frame:CreateTexture(nil,"OVERLAY")
            glyph:SetTexture(compassAssets.questDestination)
            glyph:SetSize(questStyle.width or 14,questStyle.height or 22)
            glyph:SetAlpha(questStyle.alpha or 0.95)
            glyph:Hide()
            self.questDestinationMarkers[index]=glyph
        end
        self.trackingMarkers = {}
        for index=1,4 do
            local glyph=frame:CreateTexture(nil,"OVERLAY")
            glyph:SetTexture(compassAssets.tracking)
            glyph:SetSize(trackingStyle.width or 8,trackingStyle.height or 8)
            glyph:SetAlpha(trackingStyle.alpha or 0.86)
            glyph:Hide()
            self.trackingMarkers[index]=glyph
        end
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
            -- Shadow changes glyph legibility only; tick bearings, placement,
            -- fade math and screen-space geometry remain untouched.
            local shadowColor =
                definition.cardinal and cardinalShadow or intercardinalShadow
            label:SetShadowColor(
                shadowColor[1], shadowColor[2],
                shadowColor[3], shadowColor[4]
            )
            label:SetShadowOffset(
                labelShadowOffset[1], labelShadowOffset[2]
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
        self.artworkPreview = false
        self:ClearWaypointPresentation("module-disabled")
        self:ClearPresentation("module-disabled")
    end,
})

function Compass:UpdateArtworkPreview()
    local shown = self.artworkPreview == true
        and self.policyEligible == true
        and self.presentationActive == true
    if self.artworkPreviewShown == shown then
        return
    end
    self.artworkPreviewShown = shown
    for _, glyph in pairs(self.artworkPreviewMarkers) do
        glyph:SetShown(shown)
    end
    self.artworkPreviewCaption:SetShown(shown)
end

-- Source and eligibility are handled by NavigationSourceProbe. Compass
-- consumes only ordinary, addon-owned snapshots; a heading/POI marker is
-- never reconstructed from Blizzard secret/protected view-state objects.
function Compass:ClearAvailableQuestPOIs(reason)
    self.availableQuestPoiShown = 0
    self.availableQuestPoiCandidates = 0
    self.availableQuestPoiReason = reason or "source-unavailable"
    self.dbNearbyStatus = "unavailable"
    self.dbNearbyCount = 0
    self.dbCandidateShown = 0
    self.dbServiceStatus = "unavailable"
    self.dbServiceCandidateCount = 0
    self.dbServiceCandidateShown = 0
    self.questDestinationShown = 0
    self.questDestinationCandidates = 0
    self.focusedQuestID = nil
    self.focusedQuestDistanceYards = nil
    self.focusedQuestRenderScale = nil
    self.focusedQuestDepthBand = nil
    self.trackingShown = 0
    self.trackingCandidates = 0
    for _, pool in ipairs({self.availableQuestPoiMarkers,self.questDestinationMarkers,self.trackingMarkers,self.serviceMarkers}) do
        for index=1,#pool do pool[index]:Hide() end
    end
    self.availableQuestPoiFocus:Hide()
end

function Compass:RefreshAvailableQuestPOIs(reason)
    self:ClearAvailableQuestPOIs("source-unavailable")
    if not self.policyEligible or not self.presentationActive
        or type(self.headingDegrees) ~= "number"
        or self.artworkPreview == true then return end
    local source = Logres:GetModule("NavigationSourceProbe")
    if not source or source.moduleEnabled ~= true
        or type(source.currentMapID) ~= "number"
        or type(source.mapWidth) ~= "number"
        or type(source.mapHeight) ~= "number"
        or source.mapWidth <= 0 or source.mapHeight <= 0
        or type(source.availableQuestRows) ~= "table"
    then self.availableQuestPoiReason = "source-not-ready"; return end
    if not C_Map or type(C_Map.GetBestMapForUnit) ~= "function"
        or type(C_Map.GetPlayerMapPosition) ~= "function"
    then self.availableQuestPoiReason = "map-api-unavailable"; return end
    local okMap,mapID=pcall(C_Map.GetBestMapForUnit,"player")
    if not okMap or isSecret(mapID) or type(mapID)~="number"
        or mapID~=source.currentMapID
    then self.availableQuestPoiReason="map-mismatch-or-secret"; return end
    local okPlayer,position=pcall(C_Map.GetPlayerMapPosition,mapID,"player")
    if not okPlayer then self.availableQuestPoiReason="player-position-call-failed"; return end
    local px,py,vectorError=readVectorXY(position)
    if vectorError then self.availableQuestPoiReason=vectorError; return end
    local radius
    if C_Minimap and type(C_Minimap.GetViewRadius)=="function" then
        local okRadius, value=pcall(C_Minimap.GetViewRadius)
        if okRadius and not isSecret(value) and type(value)=="number"
            and value>0 then radius=value end
    end
    local localPOIs,majorQuests,tracked={},{},{}
    local services={}
    -- SourceProbe sampled a non-secret, ordinary super-track ID. A missing
    -- focus is not permission to silently choose the nearest other quest.
    local focusedQuestID = source.superTrackedQuestID
    if type(focusedQuestID) ~= "number" or focusedQuestID <= 0 then
        focusedQuestID = nil
    end
    self.focusedQuestID = focusedQuestID
    local seenQuest={}
    local function add(row,role,key)
        if type(row)~="table" then return end
        local dx,dy
        if row.potential == true then
            -- Provider canonical-map positions have already been compared to
            -- the player in that same canonical map's world-yard frame.
            if type(row.dxYards)~="number" or type(row.dyYards)~="number" then return end
            dx,dy=row.dxYards,row.dyYards
        else
            if type(row.x)~="number" or type(row.y)~="number"
                or row.x<0 or row.x>1 or row.y<0 or row.y>1 then return end
            dx=(row.x-px)*source.mapWidth
            dy=(row.y-py)*source.mapHeight
        end
        local distance=math.sqrt(dx*dx+dy*dy)
        local cap=row.potential == true and 50
            or (radius and (role=="quest" and radius*8 or radius))
        if not cap or distance<=0 or distance>cap then return end
        local bearing=(math.deg(math.atan2(dx,-dy))+360)%360
        local relative=normalizeRelativeDegrees(bearing-self.headingDegrees)
        local magnitude=math.abs(relative)
        if magnitude>VISIBLE_HALF_ANGLE then return end
        local serviceStyle = role=="service" and SERVICE_MARKER_STYLE[row.serviceKind] or nil
        if role=="service" and not serviceStyle then return end
        local candidate={distance=distance,relative=relative,magnitude=magnitude,
            x=relative*PIXELS_PER_DEGREE,
            name=serviceStyle and (serviceStyle.name .. tostring(row.name))
                or (row.potential == true and ("Possible quest giver: " .. tostring(row.name)) or row.name),
            potential=row.potential == true, sortKey=tostring(key),
            serviceKind=role=="service" and row.serviceKind or nil}
        if role=="quest" then majorQuests[#majorQuests+1]=candidate
        elseif role=="tracking" then tracked[#tracked+1]=candidate
        elseif role=="service" then services[#services+1]=candidate
        else localPOIs[#localPOIs+1]=candidate end
    end
    -- QuestPOIMapInfo.isQuestStart is authoritative only with ordinary
    -- accepted/completed state already validated by NavigationSourceProbe.
    if type(source.questMapRows)=="table" then
        for index=1,#source.questMapRows do
            local row=source.questMapRows[index]
            if row.role=="poi" or (
                row.role=="quest" and row.questID==focusedQuestID
                and focusedQuestID ~= nil
            ) then
                seenQuest[row.questID]=true
                add(row,row.role,"map"..tostring(row.questID))
            end
        end
    end
    -- Earlier quest-line feed remains a fallback, deduped by quest ID.
    for index=1,#source.availableQuestRows do
        local row=source.availableQuestRows[index]
        if row.eligible==true and type(row.questID)=="number"
            and not seenQuest[row.questID] then
            seenQuest[row.questID]=true
            add(row,"poi","line"..tostring(row.questID))
        end
    end
    if type(source.areaPoiRows)=="table" then
        for index=1,#source.areaPoiRows do
            local row=source.areaPoiRows[index]
            add(row,"poi","area"..tostring(row.id or index))
        end
    end
    if type(source.vignetteRows)=="table" then
        for index=1,#source.vignetteRows do
            local row=source.vignetteRows[index]
            add(row,row.role=="tracking" and "tracking" or "poi","vignette"..tostring(index))
        end
    end
    -- Existing native positioned points always take precedence over a
    -- historical QuestieDB candidate in the finite eight-glyph pool.
    local db = Logres:GetModule("QuestieDBNearby")
    if db and db.moduleEnabled == true and type(db.GetNearbyRows) == "function" then
        local dbRows, dbStatus, serviceRows = db:GetNearbyRows(mapID,px,py,source.mapWidth,source.mapHeight)
        self.dbNearbyStatus = dbStatus
        self.dbServiceStatus = db.serviceStatus or "unavailable"
        if type(serviceRows) == "table" then
            for index=1,#serviceRows do
                local row=serviceRows[index]
                if type(row)=="table" and type(row.npcID)=="number" then
                    add(row,"service","service"..tostring(row.npcID))
                end
            end
        end
        if type(dbRows) == "table" then
            self.dbNearbyCount = #dbRows
            for index=1,#dbRows do
                local row=dbRows[index]
                if type(row) == "table" and type(row.npcID)=="number"
                    and not seenQuest[row.questID] then
                    add(row,"poi","db"..tostring(row.npcID))
                end
            end
        end
    end
    local function nearestFirst(a,b)
        if a.potential ~= b.potential then return b.potential == true end
        if a.distance==b.distance then return a.sortKey < b.sortKey end
        return a.distance < b.distance
    end
    table.sort(localPOIs,nearestFirst)
    table.sort(majorQuests,nearestFirst)
    table.sort(tracked,nearestFirst)
    -- Service rows retain bounded provider order: flight, inn, repair.
    self.dbServiceCandidateCount = #services
    self.availableQuestPoiCandidates=#localPOIs
    self.questDestinationCandidates=#majorQuests
    self.trackingCandidates=#tracked
    self.availableQuestPoiReason="ordinary-positioned-candidates"
    local closestFocus=nil
    local focusDegrees=8
    local function paint(items,pool,roleStyle,role)
        local used={}
        for index=1,math.min(#items,#pool) do
            local candidate=items[index]
            local lane=0
            for j=1,#used do
                if math.abs(candidate.x-used[j].x)<10 then
                    lane=math.max(lane,used[j].lane+1)
                end
            end
            lane=math.min(lane,2)
            used[#used+1]={x=candidate.x,lane=lane}
            -- Exact horizontal bearing is never displaced for collision control.
            local y = TAPE_Y + lane * 9
            if role=="quest" then y=TAPE_Y+16+lane*9
            elseif role=="tracking" then y=TAPE_Y-12-lane*9
            elseif role=="service" then y=TAPE_Y+5+lane*9 end
            local glyph=pool[index]
            glyph:ClearAllPoints()
            glyph:SetPoint("CENTER",self.frame,"CENTER",candidate.x,y)
            if role=="quest" then
                -- The same proven radius-normalized depth curve as the
                -- manual waypoint; size only, never shift the true bearing.
                local scale, band = manualWaypointDepthScaleForDistance(candidate.distance, radius)
                scale = clamp(scale, MANUAL_RENDER_SCALE_MIN, MANUAL_RENDER_SCALE_MAX)
                glyph:SetSize((roleStyle.width or 10)*scale,
                    (roleStyle.height or 18)*scale)
                self.focusedQuestDistanceYards = candidate.distance
                self.focusedQuestRenderScale = scale
                self.focusedQuestDepthBand = band
            end
            if role=="service" then
                local style = SERVICE_MARKER_STYLE[candidate.serviceKind]
                glyph:SetVertexColor(style.r, style.g, style.b, 1)
            end
            glyph:SetAlpha((roleStyle.alpha or 0.90)
                * edgeFadeForMagnitude(candidate.magnitude)
                * (candidate.potential and 0.55 or 1))
            glyph:Show()
            if role=="quest" then self.questDestinationShown=self.questDestinationShown+1
            elseif role=="tracking" then self.trackingShown=self.trackingShown+1
            elseif role=="service" then self.dbServiceCandidateShown=self.dbServiceCandidateShown+1
            else
                self.availableQuestPoiShown=self.availableQuestPoiShown+1
                if candidate.potential then self.dbCandidateShown=self.dbCandidateShown+1 end
            end
            if candidate.magnitude<=focusDegrees and type(candidate.name)=="string"
                and (not closestFocus or candidate.distance<closestFocus.distance) then
                closestFocus=candidate
            end
        end
    end
    paint(majorQuests,self.questDestinationMarkers,questStyle,"quest")
    paint(localPOIs,self.availableQuestPoiMarkers,poiStyle,"poi")
    paint(services,self.serviceMarkers,poiStyle,"service")
    paint(tracked,self.trackingMarkers,trackingStyle,"tracking")
    if closestFocus then
        local fade=1-closestFocus.magnitude/focusDegrees
        self.availableQuestPoiFocus:SetText(closestFocus.name)
        self.availableQuestPoiFocus:SetAlpha(fade*fade)
        self.availableQuestPoiFocus:Show()
    end
end

function Compass:SetArtworkPreview(enabled)
    self.artworkPreview = enabled == true
    self:UpdateArtworkPreview()
    return true, self.artworkPreview and "preview-on" or "preview-off"
end

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

function Compass:ClearWaypointDepth(reason, errorText)
    self.waypointViewRadiusAvailable = false
    self.waypointViewRadiusYards = nil
    self.waypointDistanceRadiusRatio = nil
    self.waypointDepthBand = nil
    self.waypointDepthScale = 1
    self.waypointRenderScale = nil
    self.lastWaypointDepthReason = reason or "depth-unavailable"
    self.lastWaypointDepthError = errorText
end

function Compass:ClearWaypointDistance(reason, errorText)
    self.waypointDistanceAvailable = false
    self.waypointDistanceYards = nil
    self:ClearWaypointDepth(reason or "distance-unavailable", errorText)
    self.lastWaypointDistanceReason = reason or "distance-unavailable"
    self.lastWaypointDistanceError = errorText
end

function Compass:ClearWaypointPresentation(reason, errorText)
    self.waypointSourcePresent = false
    self.waypointBearingAvailable = false
    self.waypointBearingDegrees = nil
    self.waypointRelativeDegrees = nil
    self.waypointMapID = nil
    self.waypointSourceMapID = nil
    self:ClearWaypointDistance(reason or "waypoint-unavailable")
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
    self:ClearAvailableQuestPOIs("presentation-unavailable")
    self:UpdateArtworkPreview()
    self.frame:Hide()
end

function Compass:RefreshWaypointDistance(
    mapID,
    waypointSourceMapID,
    playerX,
    playerY,
    destinationX,
    destinationY
)
    self.waypointDistanceAPIAvailable =
        C_Map ~= nil
        and type(C_Map.GetMapWorldSize) == "function"
    self.waypointViewRadiusAPIAvailable =
        C_Minimap ~= nil
        and type(C_Minimap.GetViewRadius) == "function"

    self:ClearWaypointDistance("distance-unavailable")

    if not self.waypointDistanceAPIAvailable then
        self:ClearWaypointDistance(
            "distance-api-unavailable",
            "GetMapWorldSize unavailable"
        )
        return false
    end

    if type(mapID) ~= "number"
        or type(waypointSourceMapID) ~= "number"
    then
        self:ClearWaypointDistance("distance-map-unavailable")
        return false
    end

    if waypointSourceMapID ~= mapID then
        self:ClearWaypointDistance("distance-map-mismatch")
        return false
    end

    if type(playerX) ~= "number"
        or type(playerY) ~= "number"
        or type(destinationX) ~= "number"
        or type(destinationY) ~= "number"
    then
        self:ClearWaypointDistance(
            "distance-position-invalid",
            "ordinary position inputs unavailable"
        )
        return false
    end

    local sizeOK, width, height = pcall(C_Map.GetMapWorldSize, mapID)

    if not sizeOK then
        self:ClearWaypointDistance(
            "distance-map-size-call-failed",
            "GetMapWorldSize call failed"
        )
        return false
    end

    if isSecret(width) or isSecret(height) then
        self:ClearWaypointDistance("distance-map-size-secret")
        return false
    end

    if type(width) ~= "number"
        or type(height) ~= "number"
        or width <= 0
        or height <= 0
    then
        self:ClearWaypointDistance(
            "distance-map-size-invalid",
            "GetMapWorldSize returned invalid dimensions"
        )
        return false
    end

    local dxYards = (destinationX - playerX) * width
    local dyYards = (destinationY - playerY) * height
    local distanceYards =
        math.sqrt(dxYards * dxYards + dyYards * dyYards)

    if type(distanceYards) ~= "number"
        or distanceYards ~= distanceYards
        or distanceYards < 0
    then
        self:ClearWaypointDistance(
            "distance-invalid",
            "distance arithmetic returned invalid result"
        )
        return false
    end

    self.waypointDistanceAvailable = true
    self.waypointDistanceYards = distanceYards
    self.lastWaypointDistanceReason = "distance-available"
    self.lastWaypointDistanceError = nil

    if not self.waypointViewRadiusAPIAvailable then
        self:ClearWaypointDepth(
            "view-radius-api-unavailable",
            "GetViewRadius unavailable"
        )
        return true
    end

    local radiusOK, viewRadiusYards = pcall(C_Minimap.GetViewRadius)

    if not radiusOK then
        self:ClearWaypointDepth(
            "view-radius-call-failed",
            "GetViewRadius call failed"
        )
        return true
    end

    if isSecret(viewRadiusYards) then
        self:ClearWaypointDepth("view-radius-secret")
        return true
    end

    if type(viewRadiusYards) ~= "number"
        or viewRadiusYards <= 0
    then
        self:ClearWaypointDepth(
            "view-radius-invalid",
            "GetViewRadius returned invalid yards"
        )
        return true
    end

    local depthScale, band, ratio =
        manualWaypointDepthScaleForDistance(
            distanceYards,
            viewRadiusYards
        )

    self.waypointViewRadiusAvailable = true
    self.waypointViewRadiusYards = viewRadiusYards
    self.waypointDistanceRadiusRatio = ratio
    self.waypointDepthBand = band
    self.waypointDepthScale = depthScale
    self.lastWaypointDepthReason = "depth-available"
    self.lastWaypointDepthError = nil
    return true
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
    self.waypointRenderScale = nil

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
    local angularScale =
        manualWaypointScaleForMagnitude(magnitude)
    local depthScale =
        type(self.waypointDepthScale) == "number"
        and self.waypointDepthScale
        or 1
    local scale = clamp(
        angularScale * depthScale,
        MANUAL_RENDER_SCALE_MIN,
        MANUAL_RENDER_SCALE_MAX
    )

    self.waypointRenderScale = scale

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

    self.waypointDistanceAPIAvailable =
        C_Map ~= nil
        and type(C_Map.GetMapWorldSize) == "function"
    self.waypointViewRadiusAPIAvailable =
        C_Minimap ~= nil
        and type(C_Minimap.GetViewRadius) == "function"

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
    self.waypointSourceMapID = nil
    self:ClearWaypointDistance("distance-source-pending")

    local waypointMapOK, rawWaypointSourceMapID = pcall(function()
        return waypoint.uiMapID
    end)

    if not waypointMapOK then
        self:ClearWaypointDistance(
            "waypoint-map-read-failed",
            "waypoint uiMapID read failed"
        )
    elseif isSecret(rawWaypointSourceMapID) then
        self:ClearWaypointDistance("waypoint-map-secret")
    elseif type(rawWaypointSourceMapID) == "number" then
        self.waypointSourceMapID = rawWaypointSourceMapID
    else
        self:ClearWaypointDistance(
            "waypoint-map-invalid",
            "waypoint uiMapID unavailable or invalid"
        )
    end

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

    if type(self.waypointSourceMapID) == "number" then
        self:RefreshWaypointDistance(
            mapID,
            self.waypointSourceMapID,
            playerX,
            playerY,
            destinationX,
            destinationY
        )
    end

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
    self:UpdateArtworkPreview()
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
    self:RefreshAvailableQuestPOIs(reason or "policy")
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
        self:RefreshAvailableQuestPOIs("onupdate")
    end
end

function Compass:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.frame ~= nil,
        rootShown = self.frame ~= nil and self.frame:IsShown() or false,
        directionCount = #self.directionWidgets,
        artworkPreview = self.artworkPreview == true,
        artworkPreviewShown = self.artworkPreviewShown == true,
        availableQuestPoiShown = self.availableQuestPoiShown,
        availableQuestPoiCandidates = self.availableQuestPoiCandidates,
        availableQuestPoiReason = self.availableQuestPoiReason,
        dbNearbyStatus = self.dbNearbyStatus,
        dbNearbyCount = self.dbNearbyCount,
        dbCandidateShown = self.dbCandidateShown,
        dbServiceStatus = self.dbServiceStatus,
        dbServiceCandidateCount = self.dbServiceCandidateCount,
        dbServiceCandidateShown = self.dbServiceCandidateShown,
        questDestinationShown = self.questDestinationShown,
        questDestinationCandidates = self.questDestinationCandidates,
        focusedQuestID = self.focusedQuestID,
        focusedQuestDistanceYards = self.focusedQuestDistanceYards,
        focusedQuestRenderScale = self.focusedQuestRenderScale,
        focusedQuestDepthBand = self.focusedQuestDepthBand,
        trackingShown = self.trackingShown,
        trackingCandidates = self.trackingCandidates,

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
        waypointSourceMapID = self.waypointSourceMapID,
        waypointDistanceAPIAvailable = self.waypointDistanceAPIAvailable == true,
        waypointDistanceAvailable = self.waypointDistanceAvailable == true,
        waypointDistanceYards = self.waypointDistanceYards,
        waypointViewRadiusAPIAvailable = self.waypointViewRadiusAPIAvailable == true,
        waypointViewRadiusAvailable = self.waypointViewRadiusAvailable == true,
        waypointViewRadiusYards = self.waypointViewRadiusYards,
        waypointDistanceRadiusRatio = self.waypointDistanceRadiusRatio,
        waypointDepthBand = self.waypointDepthBand,
        waypointDepthScale = self.waypointDepthScale,
        waypointRenderScale = self.waypointRenderScale,
        lastWaypointDistanceReason = self.lastWaypointDistanceReason,
        lastWaypointDistanceError = self.lastWaypointDistanceError,
        lastWaypointDepthReason = self.lastWaypointDepthReason,
        lastWaypointDepthError = self.lastWaypointDepthError,
        lastWaypointReason = self.lastWaypointReason,
        lastWaypointError = self.lastWaypointError,

        lastReason = self.lastReason,
        lastError = self.lastError,
    }
end
