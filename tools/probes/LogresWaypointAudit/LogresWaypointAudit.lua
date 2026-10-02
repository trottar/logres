local addonName = ...

local frame = CreateFrame("Frame")
local MAX_SNAPSHOTS = 200

local trackedEvents = {
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "SUPER_TRACKING_CHANGED",
    "SUPER_TRACKING_PATH_UPDATED",
    "USER_WAYPOINT_UPDATED",
}

local function pack(...)
    return { n = select("#", ...), ... }
end

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function scalarRecord(value)
    local result = {
        present = value ~= nil,
        secret = false,
    }

    if value == nil then
        return result
    end

    result.secret = isSecret(value)

    if result.secret then
        return result
    end

    local valueType = type(value)
    result.type = valueType

    if valueType == "number"
        or valueType == "string"
        or valueType == "boolean"
    then
        result.value = value
    end

    return result
end

local function callScalars(label, func, ...)
    local result = {
        label = label,
        available = type(func) == "function",
        ok = false,
        returns = {},
    }

    if not result.available then
        return result
    end

    local values = pack(pcall(func, ...))
    result.ok = values[1] and true or false

    if not result.ok then
        result.error = "call failed"
        return result
    end

    for index = 2, values.n do
        result.returns[#result.returns + 1] = scalarRecord(values[index])
    end

    return result
end

local function vectorRecord(value)
    local result = {
        present = value ~= nil,
        secret = false,
        xy_ok = false,
    }

    if value == nil then
        return result
    end

    result.secret = isSecret(value)

    if result.secret then
        return result
    end

    if type(value.GetXY) == "function" then
        local values = pack(pcall(value.GetXY, value))
        result.xy_ok = values[1] and true or false

        if not result.xy_ok then
            result.error = "GetXY failed"
            return result
        end

        result.x = scalarRecord(values[2])
        result.y = scalarRecord(values[3])
        return result
    end

    result.x = scalarRecord(value.x)
    result.y = scalarRecord(value.y)

    result.xy_ok =
        result.x.present == true
        and result.x.secret == false
        and result.x.type == "number"
        and result.y.present == true
        and result.y.secret == false
        and result.y.type == "number"

    if not result.xy_ok then
        result.error = "XY unavailable"
    end

    return result
end

local function usableNumber(record)
    return record
        and record.present == true
        and record.secret == false
        and record.type == "number"
        and type(record.value) == "number"
end

local function mapBearing(playerPosition, destinationPosition)
    local result = {
        available = type(math.atan2) == "function",
        ok = false,
    }

    if not result.available
        or not playerPosition
        or not destinationPosition
        or not usableNumber(playerPosition.x)
        or not usableNumber(playerPosition.y)
        or not usableNumber(destinationPosition.x)
        or not usableNumber(destinationPosition.y)
    then
        return result
    end

    local dx = destinationPosition.x.value - playerPosition.x.value
    local dy = destinationPosition.y.value - playerPosition.y.value

    result.ok = true
    result.dx = dx
    result.dy = dy

    -- UI map coordinates are left-to-right for X and top-to-bottom for Y.
    -- Clockwise compass degrees from map north therefore use atan2(dx, -dy).
    result.degrees =
        (math.deg(math.atan2(dx, -dy)) + 360) % 360

    return result
end

local function worldPositionRecord(mapID, mapPosition)
    local result = {
        available = C_Map
            and type(C_Map.GetWorldPosFromMapPos) == "function"
            or false,
        ok = false,
    }

    if not result.available
        or type(mapID) ~= "number"
        or mapPosition == nil
        or isSecret(mapPosition)
    then
        return result
    end

    local values = pack(
        pcall(C_Map.GetWorldPosFromMapPos, mapID, mapPosition)
    )

    result.ok = values[1] and true or false

    if not result.ok then
        result.error = "GetWorldPosFromMapPos failed"
        return result
    end

    result.continentID = scalarRecord(values[2])
    result.position = vectorRecord(values[3])
    return result
end

local function candidateBearings(playerWorld, destinationWorld)
    local result = {
        available = type(math.atan2) == "function",
        ok = false,
    }

    if not result.available
        or not playerWorld
        or not destinationWorld
        or not playerWorld.position
        or not destinationWorld.position
        or not usableNumber(playerWorld.continentID)
        or not usableNumber(destinationWorld.continentID)
        or playerWorld.continentID.value ~= destinationWorld.continentID.value
        or not usableNumber(playerWorld.position.x)
        or not usableNumber(playerWorld.position.y)
        or not usableNumber(destinationWorld.position.x)
        or not usableNumber(destinationWorld.position.y)
    then
        return result
    end

    local dx = destinationWorld.position.x.value - playerWorld.position.x.value
    local dy = destinationWorld.position.y.value - playerWorld.position.y.value

    result.ok = true
    result.sameContinent = true
    result.dx = dx
    result.dy = dy

    -- E.3 deliberately records both axis hypotheses. Runtime visual proof
    -- chooses the valid world-axis convention; the probe does not assume it.
    result.plusYNorth =
        (math.deg(math.atan2(dx, dy)) + 360) % 360
    result.minusYNorth =
        (math.deg(math.atan2(dx, -dy)) + 360) % 360

    return result
end

local function playerNavigationState()
    local result = {
        mapID = scalarRecord(nil),
        mapPosition = vectorRecord(nil),
        world = {
            available = false,
            ok = false,
        },
    }

    if not C_Map or type(C_Map.GetBestMapForUnit) ~= "function" then
        result.error = "GetBestMapForUnit unavailable"
        return result
    end

    local mapCall = pack(pcall(C_Map.GetBestMapForUnit, "player"))

    if not mapCall[1] then
        result.error = "GetBestMapForUnit failed"
        return result
    end

    result.mapID = scalarRecord(mapCall[2])

    if not usableNumber(result.mapID) then
        return result
    end

    if type(C_Map.GetPlayerMapPosition) ~= "function" then
        result.error = "GetPlayerMapPosition unavailable"
        return result
    end

    local positionCall = pack(
        pcall(C_Map.GetPlayerMapPosition, result.mapID.value, "player")
    )

    if not positionCall[1] then
        result.error = "GetPlayerMapPosition failed"
        return result
    end

    result.mapPosition = vectorRecord(positionCall[2])

    if positionCall[2] ~= nil and not isSecret(positionCall[2]) then
        result.world = worldPositionRecord(
            result.mapID.value,
            positionCall[2]
        )
    end

    return result
end

local function userWaypointState(player)
    local result = {
        available = C_Map
            and type(C_Map.GetUserWaypoint) == "function"
            or false,
        call_ok = false,
        present = false,
        secret = false,
    }

    result.superTracking = callScalars(
        "C_SuperTrack.IsSuperTrackingUserWaypoint",
        C_SuperTrack and C_SuperTrack.IsSuperTrackingUserWaypoint
    )

    if not result.available then
        return result
    end

    local values = pack(pcall(C_Map.GetUserWaypoint))
    result.call_ok = values[1] and true or false

    if not result.call_ok then
        result.error = "GetUserWaypoint failed"
        return result
    end

    local point = values[2]
    result.present = point ~= nil

    if point == nil then
        return result
    end

    result.secret = isSecret(point)

    if result.secret then
        return result
    end

    result.mapID = scalarRecord(point.uiMapID)
    result.z = scalarRecord(point.z)
    result.mapPosition = vectorRecord(point.position)

    result.positionForPlayerMap = {
        available = C_Map
            and type(C_Map.GetUserWaypointPositionForMap) == "function"
            or false,
        call_ok = false,
        position = vectorRecord(nil),
    }

    if result.positionForPlayerMap.available
        and usableNumber(player.mapID)
    then
        local mapPositionCall = pack(
            pcall(
                C_Map.GetUserWaypointPositionForMap,
                player.mapID.value
            )
        )

        result.positionForPlayerMap.call_ok =
            mapPositionCall[1] and true or false

        if result.positionForPlayerMap.call_ok then
            result.positionForPlayerMap.position =
                vectorRecord(mapPositionCall[2])
            result.mapBearing = mapBearing(
                player.mapPosition,
                result.positionForPlayerMap.position
            )
        else
            result.positionForPlayerMap.error =
                "GetUserWaypointPositionForMap failed"
        end
    end

    if usableNumber(result.mapID)
        and point.position ~= nil
        and not isSecret(point.position)
    then
        result.world = worldPositionRecord(
            result.mapID.value,
            point.position
        )
        result.bearings = candidateBearings(player.world, result.world)
    end

    return result
end

local function questWaypointState(player)
    local result = {
        superTrackedQuest = callScalars(
            "C_SuperTrack.GetSuperTrackedQuestID",
            C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID
        ),
        isSuperTrackingQuest = callScalars(
            "C_SuperTrack.IsSuperTrackingQuest",
            C_SuperTrack and C_SuperTrack.IsSuperTrackingQuest
        ),
        waypoint = {
            available = C_QuestLog
                and type(C_QuestLog.GetNextWaypoint) == "function"
                or false,
            call_ok = false,
            present = false,
        },
    }

    local questReturn = result.superTrackedQuest.returns[1]

    if not result.superTrackedQuest.ok
        or not usableNumber(questReturn)
        or questReturn.value <= 0
        or not result.waypoint.available
    then
        return result
    end

    result.questID = questReturn

    local values = pack(
        pcall(C_QuestLog.GetNextWaypoint, questReturn.value)
    )

    result.waypoint.call_ok = values[1] and true or false

    if not result.waypoint.call_ok then
        result.waypoint.error = "GetNextWaypoint failed"
        return result
    end

    result.waypoint.mapID = scalarRecord(values[2])
    result.waypoint.x = scalarRecord(values[3])
    result.waypoint.y = scalarRecord(values[4])

    result.waypoint.present =
        usableNumber(result.waypoint.mapID)
        and usableNumber(result.waypoint.x)
        and usableNumber(result.waypoint.y)

    if not result.waypoint.present
        or type(CreateVector2D) ~= "function"
    then
        result.waypoint.createVector2DAvailable =
            type(CreateVector2D) == "function"
        return result
    end

    result.waypoint.createVector2DAvailable = true

    local vectorCall = pack(
        pcall(
            CreateVector2D,
            result.waypoint.x.value,
            result.waypoint.y.value
        )
    )

    result.waypoint.vector_ok = vectorCall[1] and true or false

    if not result.waypoint.vector_ok
        or vectorCall[2] == nil
        or isSecret(vectorCall[2])
    then
        return result
    end

    result.waypoint.mapPosition = vectorRecord(vectorCall[2])
    result.waypoint.world = worldPositionRecord(
        result.waypoint.mapID.value,
        vectorCall[2]
    )
    result.waypoint.bearings = candidateBearings(
        player.world,
        result.waypoint.world
    )

    return result
end

local function apiPresence()
    return {
        GetUserWaypoint =
            C_Map and type(C_Map.GetUserWaypoint) == "function" or false,
        GetUserWaypointPositionForMap =
            C_Map
            and type(C_Map.GetUserWaypointPositionForMap) == "function"
            or false,
        GetWorldPosFromMapPos =
            C_Map
            and type(C_Map.GetWorldPosFromMapPos) == "function"
            or false,
        GetPlayerMapPosition =
            C_Map
            and type(C_Map.GetPlayerMapPosition) == "function"
            or false,
        GetSuperTrackedQuestID =
            C_SuperTrack
            and type(C_SuperTrack.GetSuperTrackedQuestID) == "function"
            or false,
        IsSuperTrackingQuest =
            C_SuperTrack
            and type(C_SuperTrack.IsSuperTrackingQuest) == "function"
            or false,
        IsSuperTrackingUserWaypoint =
            C_SuperTrack
            and type(C_SuperTrack.IsSuperTrackingUserWaypoint) == "function"
            or false,
        GetNextWaypoint =
            C_QuestLog
            and type(C_QuestLog.GetNextWaypoint) == "function"
            or false,
        CreateVector2D = type(CreateVector2D) == "function",
        atan2 = type(math.atan2) == "function",
        issecretvalue = type(issecretvalue) == "function",
    }
end

local function snapshot(reason)
    if not LogresWaypointAuditDB then
        return
    end

    local version, build, _, interfaceVersion = GetBuildInfo()
    local inInstance, instanceType = IsInInstance()

    local player = playerNavigationState()
    local row = {
        reason = reason or "manual",
        time = type(time) == "function" and time() or nil,
        build = {
            version = scalarRecord(version),
            build = scalarRecord(build),
            interfaceVersion = scalarRecord(interfaceVersion),
        },
        context = {
            inInstance = scalarRecord(inInstance),
            instanceType = scalarRecord(instanceType),
        },
        apiPresence = apiPresence(),
        eventRegistration = LogresWaypointAuditDB.eventRegistration,
        eventCounts = LogresWaypointAuditDB.eventCounts,
        player = player,
    }

    row.userWaypoint = userWaypointState(player)
    row.quest = questWaypointState(player)

    table.insert(LogresWaypointAuditDB.snapshots, row)

    while #LogresWaypointAuditDB.snapshots > MAX_SNAPSHOTS do
        table.remove(LogresWaypointAuditDB.snapshots, 1)
    end

    LogresWaypointAuditDB.lastReason = row.reason
end

local function boolText(value)
    return value and "true" or "false"
end

local function valueText(record)
    if not record or not record.present then
        return "nil"
    end

    if record.secret then
        return "<secret>"
    end

    if record.value == nil then
        return "<non-scalar>"
    end

    return tostring(record.value)
end

local function vectorText(record)
    if not record or not record.present then
        return "nil"
    end

    if record.secret then
        return "<secret>"
    end

    if not record.xy_ok then
        return "<unavailable>"
    end

    return string.format(
        "%s,%s",
        valueText(record.x),
        valueText(record.y)
    )
end

local function worldText(world)
    if not world or not world.ok then
        return "nil"
    end

    return string.format(
        "continent=%s xy=%s",
        valueText(world.continentID),
        vectorText(world.position)
    )
end

local function mapBearingText(bearing)
    if not bearing or not bearing.ok then
        return "nil"
    end

    return string.format(
        "dxy=%.5f,%.5f bearing=%.1f",
        bearing.dx,
        bearing.dy,
        bearing.degrees
    )
end

local function bearingText(bearings)
    if not bearings or not bearings.ok then
        return "nil"
    end

    return string.format(
        "dxy=%.2f,%.2f plusYNorth=%.1f minusYNorth=%.1f",
        bearings.dx,
        bearings.dy,
        bearings.plusYNorth,
        bearings.minusYNorth
    )
end

local function reportLine(output, message)
    if type(output) == "function" then
        output(message)
        return
    end

    print(message)
end

local function printReport(output)
    if not LogresWaypointAuditDB
        or #LogresWaypointAuditDB.snapshots == 0
    then
        reportLine(output, "LogresWaypointAudit: no snapshots")
        return
    end

    local row = LogresWaypointAuditDB.snapshots[
        #LogresWaypointAuditDB.snapshots
    ]

    reportLine(
        output,
        string.format(
            "LWPA reason=%s instance=%s/%s",
            tostring(row.reason),
            valueText(row.context.inInstance),
            valueText(row.context.instanceType)
        )
    )

    reportLine(
        output,
        string.format(
            "LWPA player map=%s pos=%s world=%s",
            valueText(row.player.mapID),
            vectorText(row.player.mapPosition),
            worldText(row.player.world)
        )
    )

    local user = row.userWaypoint

    reportLine(
        output,
        string.format(
            "LWPA user present=%s secret=%s map=%s pointPos=%s playerMapPos=%s mapBearing=%s world=%s worldCandidates=%s",
            boolText(user.present),
            boolText(user.secret),
            valueText(user.mapID),
            vectorText(user.mapPosition),
            vectorText(
                user.positionForPlayerMap
                and user.positionForPlayerMap.position
            ),
            mapBearingText(user.mapBearing),
            worldText(user.world),
            bearingText(user.bearings)
        )
    )

    local quest = row.quest
    local waypoint = quest.waypoint

    reportLine(
        output,
        string.format(
            "LWPA quest id=%s tracked=%s waypoint=%s map=%s xy=%s,%s world=%s bearing=%s",
            quest.questID and valueText(quest.questID) or "nil",
            quest.isSuperTrackingQuest.returns[1]
                and valueText(quest.isSuperTrackingQuest.returns[1])
                or "nil",
            boolText(waypoint.present),
            valueText(waypoint.mapID),
            valueText(waypoint.x),
            valueText(waypoint.y),
            worldText(waypoint.world),
            bearingText(waypoint.bearings)
        )
    )

    local registration = LogresWaypointAuditDB.eventRegistration or {}
    local counts = LogresWaypointAuditDB.eventCounts or {}

    reportLine(
        output,
        string.format(
            "LWPA events SUPER_TRACKING_CHANGED=%s/%d SUPER_TRACKING_PATH_UPDATED=%s/%d USER_WAYPOINT_UPDATED=%s/%d",
            boolText(registration.SUPER_TRACKING_CHANGED),
            counts.SUPER_TRACKING_CHANGED or 0,
            boolText(registration.SUPER_TRACKING_PATH_UPDATED),
            counts.SUPER_TRACKING_PATH_UPDATED or 0,
            boolText(registration.USER_WAYPOINT_UPDATED),
            counts.USER_WAYPOINT_UPDATED or 0
        )
    )
end

function LogresWaypointAudit_Run(output)
    snapshot("developer-panel")
    printReport(output)
    return true
end

local function printStatus()
    local count = LogresWaypointAuditDB
        and #LogresWaypointAuditDB.snapshots
        or 0

    print(
        string.format(
            "LogresWaypointAudit: snapshots=%d last=%s",
            count,
            tostring(
                LogresWaypointAuditDB
                and LogresWaypointAuditDB.lastReason
                or "nil"
            )
        )
    )

    printReport()
end

SLASH_LOGRESWAYPOINTAUDIT1 = "/lwpa"
SlashCmdList.LOGRESWAYPOINTAUDIT = function(message)
    local command = (message or ""):lower():match("^%s*(.-)%s*$")

    if command == "" or command == "status" then
        printStatus()
        return
    end

    if command == "snapshot" then
        snapshot("manual")
        printReport()
        return
    end

    if command == "report" then
        printReport()
        return
    end

    if command == "clear" then
        LogresWaypointAuditDB.snapshots = {}
        LogresWaypointAuditDB.eventCounts = {}
        LogresWaypointAuditDB.lastReason = nil
        print("LogresWaypointAudit: snapshots/event counts cleared")
        return
    end

    print(
        "LogresWaypointAudit commands: /lwpa status | snapshot | report | clear"
    )
end

frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, ...)
    if event == "ADDON_LOADED" then
        local loaded = ...

        if loaded ~= addonName then
            return
        end

        LogresWaypointAuditDB = LogresWaypointAuditDB or {}
        LogresWaypointAuditDB.schema = 1
        LogresWaypointAuditDB.snapshots =
            LogresWaypointAuditDB.snapshots or {}
        LogresWaypointAuditDB.eventCounts =
            LogresWaypointAuditDB.eventCounts or {}
        LogresWaypointAuditDB.eventRegistration = {}

        for _, candidate in ipairs(trackedEvents) do
            local ok = pcall(frame.RegisterEvent, frame, candidate)
            LogresWaypointAuditDB.eventRegistration[candidate] =
                ok and true or false
        end

        print(
            "LogresWaypointAudit loaded. Use /lwpa snapshot and /lwpa report."
        )
        return
    end

    if not LogresWaypointAuditDB then
        return
    end

    LogresWaypointAuditDB.eventCounts[event] =
        (LogresWaypointAuditDB.eventCounts[event] or 0) + 1

    snapshot(event)
end)
