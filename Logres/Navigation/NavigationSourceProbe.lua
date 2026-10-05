local _, Logres = ...

local MAX_TRACKING_TYPES = 48
local MAX_AREA_POIS = 24
local ERROR_TEXT_LIMIT = 96

local Probe = Logres:RegisterModule("NavigationSourceProbe", {
    autoEnable = true,
})

local EVENTS = {
    "MINIMAP_UPDATE_TRACKING",
    "AREA_POIS_UPDATED",
    "SUPER_TRACKING_CHANGED",
    "SUPER_TRACKING_PATH_UPDATED",
    "QUEST_LOG_UPDATE",
    "PLAYER_MAP_CHANGED",
    "PLAYER_ENTERING_WORLD",
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

local function truncateText(value)
    if #value <= ERROR_TEXT_LIMIT then
        return value
    end

    return value:sub(1, ERROR_TEXT_LIMIT - 3) .. "..."
end

local function safeErrorText(value)
    if isSecret(value) then
        return "secret-error"
    end

    if value == nil then
        return "unknown-error"
    end

    local valueType = type(value)

    if valueType ~= "string" then
        return valueType .. "-error"
    end

    return truncateText(value)
end

local function boolText(value)
    if value == nil then
        return "-"
    end

    return value and "true" or "false"
end

local function numberText(value)
    if type(value) ~= "number" then
        return "-"
    end

    return string.format("%.2f", value)
end

local function ordinaryField(owner, value, expectedType, label)
    if isSecret(value) then
        owner.secretSkipCount = owner.secretSkipCount + 1
        owner.lastSecret = label
        return nil, "secret"
    end

    if value == nil then
        return nil, "absent"
    end

    if expectedType and type(value) ~= expectedType then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":unexpected-" .. type(value)
        return nil, "invalid"
    end

    return value, "ordinary"
end

local function call(owner, label, api, ...)
    if type(api) ~= "function" then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":api-unavailable"
        return false, nil
    end

    local ok, a, b, c = pcall(api, ...)

    if not ok then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":" .. safeErrorText(a)
        return false, nil
    end

    return true, a, b, c
end

local function readVector(owner, label, value)
    local vector, state = ordinaryField(owner, value, nil, label)

    if state ~= "ordinary" then
        return nil, nil, state
    end

    local getXY = vector.GetXY

    if type(getXY) ~= "function" then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":GetXY-unavailable"
        return nil, nil, "invalid"
    end

    local ok, x, y = pcall(getXY, vector)

    if not ok then
        owner.failureCount = owner.failureCount + 1
        owner.lastFailure = label .. ":" .. safeErrorText(x)
        return nil, nil, "invalid"
    end

    local ordinaryX, stateX =
        ordinaryField(owner, x, "number", label .. ".x")
    local ordinaryY, stateY =
        ordinaryField(owner, y, "number", label .. ".y")

    if stateX ~= "ordinary" or stateY ~= "ordinary" then
        return nil, nil, stateX ~= "ordinary" and stateX or stateY
    end

    return ordinaryX, ordinaryY, "ordinary"
end

local function apiPresence()
    return {
        secretChecker = hasSecretChecker(),
        trackingCount =
            C_Minimap
            and type(C_Minimap.GetNumTrackingTypes) == "function"
            or false,
        trackingInfo =
            C_Minimap
            and type(C_Minimap.GetTrackingInfo) == "function"
            or false,
        trackingFilter =
            C_Minimap
            and type(C_Minimap.GetTrackingFilter) == "function"
            or false,
        viewRadius =
            C_Minimap
            and type(C_Minimap.GetViewRadius) == "function"
            or false,
        minimapMap =
            C_Minimap
            and type(C_Minimap.GetUiMapID) == "function"
            or false,
        bestMap =
            C_Map
            and type(C_Map.GetBestMapForUnit) == "function"
            or false,
        playerPosition =
            C_Map
            and type(C_Map.GetPlayerMapPosition) == "function"
            or false,
        mapWorldSize =
            C_Map
            and type(C_Map.GetMapWorldSize) == "function"
            or false,
        areaPoiList =
            C_AreaPoiInfo
            and type(C_AreaPoiInfo.GetAreaPOIForMap) == "function"
            or false,
        areaPoiInfo =
            C_AreaPoiInfo
            and type(C_AreaPoiInfo.GetAreaPOIInfo) == "function"
            or false,
        superAnything =
            C_SuperTrack
            and type(C_SuperTrack.IsSuperTrackingAnything) == "function"
            or false,
        superQuest =
            C_SuperTrack
            and type(C_SuperTrack.IsSuperTrackingQuest) == "function"
            or false,
        superUser =
            C_SuperTrack
            and type(C_SuperTrack.IsSuperTrackingUserWaypoint) == "function"
            or false,
        superQuestID =
            C_SuperTrack
            and type(C_SuperTrack.GetSuperTrackedQuestID) == "function"
            or false,
        navigation =
            C_Navigation
            and type(C_Navigation.GetNextWaypointForMap) == "function"
            or false,
        questWaypoint =
            C_QuestLog
            and type(C_QuestLog.GetNextWaypoint) == "function"
            or false,
        questWaypointMap =
            C_QuestLog
            and type(C_QuestLog.GetNextWaypointForMap) == "function"
            or false,
    }
end

local function apiReady(api)
    return api.secretChecker
        and api.trackingCount
        and api.trackingInfo
        and api.trackingFilter
        and api.viewRadius
        and api.minimapMap
        and api.bestMap
        and api.playerPosition
        and api.mapWorldSize
        and api.areaPoiList
        and api.areaPoiInfo
        and api.superAnything
        and api.superQuest
        and api.superUser
        and api.superQuestID
        and api.navigation
        and api.questWaypoint
        and api.questWaypointMap
end

function Probe:ResetCaptureState(reason)
    self.lastReason = reason
    self.failureCount = 0
    self.secretSkipCount = 0
    self.lastFailure = nil
    self.lastSecret = nil

    self.currentMapID = nil
    self.minimapMapID = nil
    self.playerX = nil
    self.playerY = nil
    self.mapWidth = nil
    self.mapHeight = nil
    self.viewRadius = nil

    self.trackingCount = nil
    self.trackingScanned = 0
    self.trackingActive = 0
    self.trackingTruncated = false
    self.trackingRows = {}

    self.areaPoiScanned = 0
    self.areaPoiOrdinary = 0
    self.areaPoiWithinRadius = 0
    self.areaPoiTruncated = false
    self.areaPoiRows = {}

    self.superTrackingAnything = nil
    self.superTrackingQuest = nil
    self.superTrackingUserWaypoint = nil
    self.superTrackedQuestID = nil

    self.navigationAvailable = false
    self.navigationX = nil
    self.navigationY = nil
    self.navigationDescription = nil
    self.navigationDistanceYards = nil

    self.questWaypointAvailable = false
    self.questWaypointMapID = nil
    self.questWaypointX = nil
    self.questWaypointY = nil
    self.questWaypointDistanceYards = nil

    self.questWaypointForMapAvailable = false
    self.questWaypointForMapX = nil
    self.questWaypointForMapY = nil
    self.questWaypointForMapDistanceYards = nil
end

function Probe:ReadMap()
    local okMap, mapID = call(
        self,
        "C_Map.GetBestMapForUnit",
        C_Map and C_Map.GetBestMapForUnit,
        "player"
    )

    if okMap then
        self.currentMapID =
            ordinaryField(self, mapID, "number", "currentMapID")
    end

    local okMini, minimapMapID = call(
        self,
        "C_Minimap.GetUiMapID",
        C_Minimap and C_Minimap.GetUiMapID
    )

    if okMini then
        self.minimapMapID =
            ordinaryField(self, minimapMapID, "number", "minimapMapID")
    end

    local okRadius, radius = call(
        self,
        "C_Minimap.GetViewRadius",
        C_Minimap and C_Minimap.GetViewRadius
    )

    if okRadius then
        self.viewRadius =
            ordinaryField(self, radius, "number", "viewRadius")
    end

    if type(self.currentMapID) ~= "number" then
        return
    end

    local okPlayer, playerPosition = call(
        self,
        "C_Map.GetPlayerMapPosition",
        C_Map and C_Map.GetPlayerMapPosition,
        self.currentMapID,
        "player"
    )

    if okPlayer then
        self.playerX, self.playerY =
            readVector(self, "playerPosition", playerPosition)
    end

    local okSize, width, height = call(
        self,
        "C_Map.GetMapWorldSize",
        C_Map and C_Map.GetMapWorldSize,
        self.currentMapID
    )

    if okSize then
        self.mapWidth =
            ordinaryField(self, width, "number", "mapWidth")
        self.mapHeight =
            ordinaryField(self, height, "number", "mapHeight")
    end
end

function Probe:DistanceYards(x, y)
    if type(x) ~= "number"
        or type(y) ~= "number"
        or type(self.playerX) ~= "number"
        or type(self.playerY) ~= "number"
        or type(self.mapWidth) ~= "number"
        or type(self.mapHeight) ~= "number"
        or self.mapWidth <= 0
        or self.mapHeight <= 0
    then
        return nil
    end

    local dx = (x - self.playerX) * self.mapWidth
    local dy = (y - self.playerY) * self.mapHeight
    return math.sqrt(dx * dx + dy * dy)
end

function Probe:ReadTracking()
    local okCount, rawCount = call(
        self,
        "C_Minimap.GetNumTrackingTypes",
        C_Minimap and C_Minimap.GetNumTrackingTypes
    )

    if not okCount then
        return
    end

    local count, state =
        ordinaryField(self, rawCount, "number", "trackingCount")

    if state ~= "ordinary" then
        return
    end

    count = math.max(0, math.floor(count))
    self.trackingCount = count
    self.trackingScanned = math.min(count, MAX_TRACKING_TYPES)
    self.trackingTruncated = count > MAX_TRACKING_TYPES

    for index = 1, self.trackingScanned do
        local row = { index = index }

        local okInfo, info = call(
            self,
            "C_Minimap.GetTrackingInfo",
            C_Minimap and C_Minimap.GetTrackingInfo,
            index
        )

        if okInfo then
            local ordinaryInfo, infoState =
                ordinaryField(self, info, nil, "trackingInfo")

            if infoState == "ordinary" then
                row.name =
                    ordinaryField(
                        self,
                        ordinaryInfo.name,
                        "string",
                        "trackingInfo.name"
                    )
                row.active =
                    ordinaryField(
                        self,
                        ordinaryInfo.active,
                        "boolean",
                        "trackingInfo.active"
                    )
                row.kind =
                    ordinaryField(
                        self,
                        ordinaryInfo.type,
                        "string",
                        "trackingInfo.type"
                    )
                row.subType =
                    ordinaryField(
                        self,
                        ordinaryInfo.subType,
                        "number",
                        "trackingInfo.subType"
                    )
                row.spellID =
                    ordinaryField(
                        self,
                        ordinaryInfo.spellID,
                        "number",
                        "trackingInfo.spellID"
                    )

                if row.active == true then
                    self.trackingActive = self.trackingActive + 1
                end
            end
        end

        local okFilter, filter = call(
            self,
            "C_Minimap.GetTrackingFilter",
            C_Minimap and C_Minimap.GetTrackingFilter,
            index
        )

        if okFilter then
            local ordinaryFilter, filterState =
                ordinaryField(self, filter, nil, "trackingFilter")

            if filterState == "ordinary" then
                row.filterID =
                    ordinaryField(
                        self,
                        ordinaryFilter.filterID,
                        "number",
                        "trackingFilter.filterID"
                    )
                row.filterSpellID =
                    ordinaryField(
                        self,
                        ordinaryFilter.spellID,
                        "number",
                        "trackingFilter.spellID"
                    )
            end
        end

        self.trackingRows[#self.trackingRows + 1] = row
    end
end

function Probe:ReadAreaPOIs()
    if type(self.currentMapID) ~= "number" then
        return
    end

    local okList, ids = call(
        self,
        "C_AreaPoiInfo.GetAreaPOIForMap",
        C_AreaPoiInfo and C_AreaPoiInfo.GetAreaPOIForMap,
        self.currentMapID
    )

    if not okList then
        return
    end

    local ordinaryIDs, listState =
        ordinaryField(self, ids, nil, "areaPoiIDs")

    if listState ~= "ordinary" then
        return
    end

    for index = 1, MAX_AREA_POIS do
        local rawID = ordinaryIDs[index]

        if isSecret(rawID) then
            self.secretSkipCount = self.secretSkipCount + 1
            self.lastSecret = "areaPoiID"
        elseif rawID == nil then
            return
        elseif type(rawID) ~= "number" then
            self.failureCount = self.failureCount + 1
            self.lastFailure = "areaPoiID:unexpected-" .. type(rawID)
            return
        else
            self.areaPoiScanned = self.areaPoiScanned + 1

            local okInfo, info = call(
                self,
                "C_AreaPoiInfo.GetAreaPOIInfo",
                C_AreaPoiInfo and C_AreaPoiInfo.GetAreaPOIInfo,
                self.currentMapID,
                rawID
            )

            if okInfo then
                local ordinaryInfo, infoState =
                    ordinaryField(self, info, nil, "areaPoiInfo")

                if infoState == "ordinary" then
                    local row = { id = rawID }
                    row.name =
                        ordinaryField(
                            self,
                            ordinaryInfo.name,
                            "string",
                            "areaPoiInfo.name"
                        )
                    row.x, row.y =
                        readVector(
                            self,
                            "areaPoiInfo.position",
                            ordinaryInfo.position
                        )

                    if type(row.x) == "number"
                        and type(row.y) == "number"
                    then
                        self.areaPoiOrdinary =
                            self.areaPoiOrdinary + 1
                        row.distanceYards =
                            self:DistanceYards(row.x, row.y)

                        if type(row.distanceYards) == "number"
                            and type(self.viewRadius) == "number"
                            and self.viewRadius >= 0
                            and row.distanceYards <= self.viewRadius
                        then
                            row.withinViewRadius = true
                            self.areaPoiWithinRadius =
                                self.areaPoiWithinRadius + 1
                        else
                            row.withinViewRadius = false
                        end
                    end

                    self.areaPoiRows[#self.areaPoiRows + 1] = row
                end
            end
        end
    end

    self.areaPoiTruncated = true
end

function Probe:ReadSuperTracking()
    local okAnything, anything = call(
        self,
        "C_SuperTrack.IsSuperTrackingAnything",
        C_SuperTrack and C_SuperTrack.IsSuperTrackingAnything
    )

    if okAnything then
        self.superTrackingAnything =
            ordinaryField(
                self,
                anything,
                "boolean",
                "superTrackingAnything"
            )
    end

    local okQuest, isQuest = call(
        self,
        "C_SuperTrack.IsSuperTrackingQuest",
        C_SuperTrack and C_SuperTrack.IsSuperTrackingQuest
    )

    if okQuest then
        self.superTrackingQuest =
            ordinaryField(
                self,
                isQuest,
                "boolean",
                "superTrackingQuest"
            )
    end

    local okUser, isUser = call(
        self,
        "C_SuperTrack.IsSuperTrackingUserWaypoint",
        C_SuperTrack and C_SuperTrack.IsSuperTrackingUserWaypoint
    )

    if okUser then
        self.superTrackingUserWaypoint =
            ordinaryField(
                self,
                isUser,
                "boolean",
                "superTrackingUserWaypoint"
            )
    end

    local okQuestID, questID = call(
        self,
        "C_SuperTrack.GetSuperTrackedQuestID",
        C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID
    )

    if okQuestID then
        self.superTrackedQuestID =
            ordinaryField(
                self,
                questID,
                "number",
                "superTrackedQuestID"
            )
    end
end

function Probe:ReadNavigation()
    if type(self.currentMapID) ~= "number" then
        return
    end

    local okNav, x, y, description = call(
        self,
        "C_Navigation.GetNextWaypointForMap",
        C_Navigation and C_Navigation.GetNextWaypointForMap,
        self.currentMapID
    )

    if okNav then
        local ordinaryX, stateX =
            ordinaryField(self, x, "number", "navigation.x")
        local ordinaryY, stateY =
            ordinaryField(self, y, "number", "navigation.y")
        local ordinaryDescription =
            ordinaryField(
                self,
                description,
                "string",
                "navigation.description"
            )

        if stateX == "ordinary" and stateY == "ordinary" then
            self.navigationAvailable = true
            self.navigationX = ordinaryX
            self.navigationY = ordinaryY
            self.navigationDescription = ordinaryDescription
            self.navigationDistanceYards =
                self:DistanceYards(ordinaryX, ordinaryY)
        end
    end

    if self.superTrackingQuest ~= true
        or type(self.superTrackedQuestID) ~= "number"
        or self.superTrackedQuestID <= 0
    then
        return
    end

    local questID = self.superTrackedQuestID
    local okQuest, questMapID, qx, qy = call(
        self,
        "C_QuestLog.GetNextWaypoint",
        C_QuestLog and C_QuestLog.GetNextWaypoint,
        questID
    )

    if okQuest then
        local ordinaryMap, mapState =
            ordinaryField(
                self,
                questMapID,
                "number",
                "questWaypoint.mapID"
            )
        local ordinaryX, stateX =
            ordinaryField(self, qx, "number", "questWaypoint.x")
        local ordinaryY, stateY =
            ordinaryField(self, qy, "number", "questWaypoint.y")

        if mapState == "ordinary"
            and stateX == "ordinary"
            and stateY == "ordinary"
        then
            self.questWaypointAvailable = true
            self.questWaypointMapID = ordinaryMap
            self.questWaypointX = ordinaryX
            self.questWaypointY = ordinaryY

            if ordinaryMap == self.currentMapID then
                self.questWaypointDistanceYards =
                    self:DistanceYards(ordinaryX, ordinaryY)
            end
        end
    end

    local okQuestMap, mqx, mqy = call(
        self,
        "C_QuestLog.GetNextWaypointForMap",
        C_QuestLog and C_QuestLog.GetNextWaypointForMap,
        questID,
        self.currentMapID
    )

    if okQuestMap then
        local ordinaryX, stateX =
            ordinaryField(
                self,
                mqx,
                "number",
                "questWaypointForMap.x"
            )
        local ordinaryY, stateY =
            ordinaryField(
                self,
                mqy,
                "number",
                "questWaypointForMap.y"
            )

        if stateX == "ordinary" and stateY == "ordinary" then
            self.questWaypointForMapAvailable = true
            self.questWaypointForMapX = ordinaryX
            self.questWaypointForMapY = ordinaryY
            self.questWaypointForMapDistanceYards =
                self:DistanceYards(ordinaryX, ordinaryY)
        end
    end
end

function Probe:Capture(reason)
    self.captureCount = self.captureCount + 1
    self:ResetCaptureState(reason)

    self:ReadMap()
    self:ReadTracking()
    self:ReadAreaPOIs()
    self:ReadSuperTracking()
    self:ReadNavigation()

    return self:GetDebugStatus()
end

function Probe:CaptureManual()
    self.manualCount = self.manualCount + 1
    return self:Capture("manual")
end

function Probe:GetDiagnosticLines()
    local lines = {
        string.format(
            "map=%s minimapMap=%s player=%s,%s worldSize=%s,%s viewRadius=%s",
            tostring(self.currentMapID or "-"),
            tostring(self.minimapMapID or "-"),
            numberText(self.playerX),
            numberText(self.playerY),
            numberText(self.mapWidth),
            numberText(self.mapHeight),
            numberText(self.viewRadius)
        ),
        string.format(
            "tracking=count:%s scanned:%s active:%s truncated:%s",
            tostring(self.trackingCount or "-"),
            tostring(self.trackingScanned),
            tostring(self.trackingActive),
            boolText(self.trackingTruncated)
        ),
        string.format(
            "areaPOI=scanned:%s positioned:%s withinRadius:%s truncated:%s",
            tostring(self.areaPoiScanned),
            tostring(self.areaPoiOrdinary),
            tostring(self.areaPoiWithinRadius),
            boolText(self.areaPoiTruncated)
        ),
        string.format(
            "super=anything:%s quest:%s userWaypoint:%s questID:%s navigation:%s navDistance:%s questWaypoint:%s/%s questDistance:%s/%s",
            boolText(self.superTrackingAnything),
            boolText(self.superTrackingQuest),
            boolText(self.superTrackingUserWaypoint),
            tostring(self.superTrackedQuestID or "-"),
            boolText(self.navigationAvailable),
            numberText(self.navigationDistanceYards),
            boolText(self.questWaypointAvailable),
            boolText(self.questWaypointForMapAvailable),
            numberText(self.questWaypointDistanceYards),
            numberText(self.questWaypointForMapDistanceYards)
        ),
        string.format(
            "secretSkips=%s failures=%s lastSecret=%s lastFailure=%s",
            tostring(self.secretSkipCount),
            tostring(self.failureCount),
            tostring(self.lastSecret or "-"),
            tostring(self.lastFailure or "-")
        ),
    }

    for index = 1, #self.trackingRows do
        local row = self.trackingRows[index]
        lines[#lines + 1] = string.format(
            "tracking[%s] active=%s name=%s type=%s subType=%s filterID=%s spellID=%s/%s",
            tostring(row.index),
            boolText(row.active),
            tostring(row.name or "-"),
            tostring(row.kind or "-"),
            tostring(row.subType or "-"),
            tostring(row.filterID or "-"),
            tostring(row.spellID or "-"),
            tostring(row.filterSpellID or "-")
        )
    end

    for index = 1, #self.areaPoiRows do
        local row = self.areaPoiRows[index]
        lines[#lines + 1] = string.format(
            "areaPOI[%s] id=%s name=%s pos=%s,%s distance=%s withinRadius=%s",
            tostring(index),
            tostring(row.id),
            tostring(row.name or "-"),
            numberText(row.x),
            numberText(row.y),
            numberText(row.distanceYards),
            boolText(row.withinViewRadius)
        )
    end

    return lines
end

function Probe:GetDebugStatus()
    local api = apiPresence()

    return {
        moduleEnabled = self.moduleEnabled == true,
        eventFrameReady = self.eventFrame ~= nil,
        secretCheckerAvailable = api.secretChecker,
        requiredAPIReady = apiReady(api),

        minimapTrackingRegistered =
            self.eventRegistration.MINIMAP_UPDATE_TRACKING == true,
        areaPoisRegistered =
            self.eventRegistration.AREA_POIS_UPDATED == true,
        superTrackingRegistered =
            self.eventRegistration.SUPER_TRACKING_CHANGED == true,
        superTrackingPathRegistered =
            self.eventRegistration.SUPER_TRACKING_PATH_UPDATED == true,
        questLogRegistered =
            self.eventRegistration.QUEST_LOG_UPDATE == true,
        playerMapRegistered =
            self.eventRegistration.PLAYER_MAP_CHANGED == true,
        enteringWorldRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,

        minimapTrackingEvents =
            self.eventCounts.MINIMAP_UPDATE_TRACKING or 0,
        areaPoisEvents =
            self.eventCounts.AREA_POIS_UPDATED or 0,
        superTrackingEvents =
            self.eventCounts.SUPER_TRACKING_CHANGED or 0,
        superTrackingPathEvents =
            self.eventCounts.SUPER_TRACKING_PATH_UPDATED or 0,
        questLogEvents =
            self.eventCounts.QUEST_LOG_UPDATE or 0,
        playerMapEvents =
            self.eventCounts.PLAYER_MAP_CHANGED or 0,
        enteringWorldEvents =
            self.eventCounts.PLAYER_ENTERING_WORLD or 0,

        captureCount = self.captureCount,
        manualCount = self.manualCount,
        lastReason = self.lastReason,
        failureCount = self.failureCount,
        secretSkipCount = self.secretSkipCount,
        lastFailure = self.lastFailure,
        lastSecret = self.lastSecret,

        currentMapID = self.currentMapID,
        minimapMapID = self.minimapMapID,
        playerPositionAvailable =
            type(self.playerX) == "number"
            and type(self.playerY) == "number",
        mapWorldSizeAvailable =
            type(self.mapWidth) == "number"
            and type(self.mapHeight) == "number",
        viewRadius = self.viewRadius,

        trackingCount = self.trackingCount,
        trackingScanned = self.trackingScanned,
        trackingActive = self.trackingActive,
        trackingTruncated = self.trackingTruncated,

        areaPoiScanned = self.areaPoiScanned,
        areaPoiOrdinary = self.areaPoiOrdinary,
        areaPoiWithinRadius = self.areaPoiWithinRadius,
        areaPoiTruncated = self.areaPoiTruncated,

        superTrackingAnything = self.superTrackingAnything,
        superTrackingQuest = self.superTrackingQuest,
        superTrackingUserWaypoint = self.superTrackingUserWaypoint,
        superTrackedQuestID = self.superTrackedQuestID,

        navigationAvailable = self.navigationAvailable,
        navigationDistanceYards = self.navigationDistanceYards,
        questWaypointAvailable = self.questWaypointAvailable,
        questWaypointForMapAvailable =
            self.questWaypointForMapAvailable,
        questWaypointDistanceYards =
            self.questWaypointDistanceYards,
        questWaypointForMapDistanceYards =
            self.questWaypointForMapDistanceYards,
    }
end

function Probe:OnInitialize()
    self.moduleEnabled = false
    self.captureCount = 0
    self.manualCount = 0
    self.eventCounts = {}
    self.eventRegistration = {}
    self:ResetCaptureState("initialize")

    local eventFrame = CreateFrame("Frame")

    for index = 1, #EVENTS do
        local event = EVENTS[index]
        self.eventCounts[event] = 0
        self.eventRegistration[event] = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )
    end

    eventFrame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled ~= true then
            return
        end

        self.eventCounts[event] =
            (self.eventCounts[event] or 0) + 1

        self:Capture(event)
    end)

    self.eventFrame = eventFrame
end

function Probe:OnEnable()
    self.moduleEnabled = true
    self:Capture("enable")
end

function Probe:OnDisable()
    self.moduleEnabled = false
end
