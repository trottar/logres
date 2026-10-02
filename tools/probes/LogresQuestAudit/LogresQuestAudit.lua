local addonName = ...

local frame = CreateFrame("Frame")
local MAX_SNAPSHOTS = 60
local MAX_OBJECTIVES = 8

local trackedEvents = {
    "QUEST_DETAIL",
    "QUEST_PROGRESS",
    "QUEST_COMPLETE",
    "QUEST_FINISHED",
    "QUEST_ACCEPTED",
    "QUEST_TURNED_IN",
    "QUEST_LOG_UPDATE",
    "QUEST_WATCH_LIST_CHANGED",
    "QUEST_WATCH_UPDATE",
    "SUPER_TRACKING_CHANGED",
    "PLAYER_XP_UPDATE",
    "UPDATE_EXHAUSTION",
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

local function usableNumber(record)
    return record
        and record.present == true
        and record.secret == false
        and record.type == "number"
        and type(record.value) == "number"
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
        result.returns[#result.returns + 1] =
            scalarRecord(values[index])
    end

    return result
end

local function readVectorXY(value)
    local result = {
        present = value ~= nil,
        secret = false,
        ok = false,
    }

    if value == nil then
        return result
    end

    result.secret = isSecret(value)

    if result.secret then
        return result
    end

    local x
    local y

    if type(value.GetXY) == "function" then
        local values = pack(pcall(value.GetXY, value))

        if not values[1] then
            result.error = "GetXY failed"
            return result
        end

        x = values[2]
        y = values[3]
    else
        x = value.x
        y = value.y
    end

    result.x = scalarRecord(x)
    result.y = scalarRecord(y)

    result.ok =
        usableNumber(result.x)
        and usableNumber(result.y)

    return result
end

local function ensureDB()
    LogresQuestAuditDB = LogresQuestAuditDB or {}

    local db = LogresQuestAuditDB
    db.schema = 1
    db.eventCounts = db.eventCounts or {}
    db.eventRegistration = db.eventRegistration or {}
    db.lastEvents = db.lastEvents or {}
    db.snapshots = db.snapshots or {}

    return db
end

local function recordText(record)
    if not record or not record.present then
        return "nil"
    end

    if record.secret then
        return "<secret>"
    end

    if record.value == nil then
        return "<non-scalar>"
    end

    local text = tostring(record.value)

    if record.type == "string" then
        text = text:gsub("[\r\n]+", " ")

        if #text > 80 then
            text = text:sub(1, 77) .. "..."
        end
    end

    return text
end

local function firstReturn(call)
    return call and call.returns and call.returns[1] or nil
end

local function firstText(call)
    return recordText(firstReturn(call))
end

local function boolText(value)
    return value and "true" or "false"
end

local function captureInteraction(reason)
    local db = ensureDB()

    db.lastInteraction = {
        reason = reason,
        time = type(time) == "function" and time() or nil,
        questID = callScalars(
            "GetQuestID",
            GetQuestID
        ),
        title = callScalars(
            "GetTitleText",
            GetTitleText
        ),
        questText = callScalars(
            "GetQuestText",
            GetQuestText
        ),
        objectiveText = callScalars(
            "GetObjectiveText",
            GetObjectiveText
        ),
        progressText = callScalars(
            "GetProgressText",
            GetProgressText
        ),
        rewardText = callScalars(
            "GetRewardText",
            GetRewardText
        ),
        rewardXP = callScalars(
            "GetRewardXP",
            GetRewardXP
        ),
        numChoices = callScalars(
            "GetNumQuestChoices",
            GetNumQuestChoices
        ),
        numRewards = callScalars(
            "GetNumQuestRewards",
            GetNumQuestRewards
        ),
    }
end

local function captureXP()
    return {
        current = callScalars(
            "UnitXP",
            UnitXP,
            "player"
        ),
        maximum = callScalars(
            "UnitXPMax",
            UnitXPMax,
            "player"
        ),
        rested = callScalars(
            "GetXPExhaustion",
            GetXPExhaustion
        ),
        experiencePreset = callScalars(
            "C_GameRules.GetForeverExperiencePreset",
            C_GameRules
                and C_GameRules.GetForeverExperiencePreset
        ),
    }
end

local function captureQuestObjectives(questID)
    local result = {
        available =
            C_QuestLog
            and type(C_QuestLog.GetQuestObjectives) == "function"
            or false,
        ok = false,
        present = false,
        secret = false,
        objectives = {},
    }

    if not result.available or type(questID) ~= "number" then
        return result
    end

    local values = pack(
        pcall(C_QuestLog.GetQuestObjectives, questID)
    )

    result.ok = values[1] and true or false

    if not result.ok then
        result.error = "GetQuestObjectives failed"
        return result
    end

    local objectives = values[2]
    result.present = objectives ~= nil

    if objectives == nil then
        return result
    end

    result.secret = isSecret(objectives)

    if result.secret then
        return result
    end

    if type(objectives) ~= "table" then
        result.error = "objectives invalid"
        return result
    end

    for index, objective in ipairs(objectives) do
        if index > MAX_OBJECTIVES then
            break
        end

        local row = {
            present = objective ~= nil,
            secret = false,
        }

        if objective ~= nil then
            row.secret = isSecret(objective)

            if not row.secret and type(objective) == "table" then
                row.text = scalarRecord(objective.text)
                row.type = scalarRecord(objective.type)
                row.finished = scalarRecord(objective.finished)
                row.numFulfilled =
                    scalarRecord(objective.numFulfilled)
                row.numRequired =
                    scalarRecord(objective.numRequired)
            end
        end

        result.objectives[#result.objectives + 1] = row
    end

    return result
end

local function playerMapState()
    local result = {
        mapID = scalarRecord(nil),
        position = {
            present = false,
            secret = false,
            ok = false,
        },
    }

    if not C_Map
        or type(C_Map.GetBestMapForUnit) ~= "function"
        or type(C_Map.GetPlayerMapPosition) ~= "function"
    then
        result.error = "player map APIs unavailable"
        return result
    end

    local mapValues = pack(
        pcall(C_Map.GetBestMapForUnit, "player")
    )

    if not mapValues[1] then
        result.error = "GetBestMapForUnit failed"
        return result
    end

    result.mapID = scalarRecord(mapValues[2])

    if not usableNumber(result.mapID) then
        return result
    end

    local positionValues = pack(
        pcall(
            C_Map.GetPlayerMapPosition,
            result.mapID.value,
            "player"
        )
    )

    if not positionValues[1] then
        result.error = "GetPlayerMapPosition failed"
        return result
    end

    result.position = readVectorXY(positionValues[2])
    return result
end

local function questWaypointState(questID, playerMap)
    local result = {
        questID = scalarRecord(questID),
        nextWaypoint = callScalars(
            "C_QuestLog.GetNextWaypoint",
            C_QuestLog and C_QuestLog.GetNextWaypoint,
            questID
        ),
        nextWaypointText = callScalars(
            "C_QuestLog.GetNextWaypointText",
            C_QuestLog and C_QuestLog.GetNextWaypointText,
            questID
        ),
        forPlayerMap = {
            available =
                C_QuestLog
                and type(C_QuestLog.GetNextWaypointForMap)
                    == "function"
                or false,
            ok = false,
        },
        bearing = {
            available = type(math.atan2) == "function",
            ok = false,
        },
    }

    if type(questID) ~= "number"
        or not result.forPlayerMap.available
        or not usableNumber(playerMap.mapID)
    then
        return result
    end

    local values = pack(
        pcall(
            C_QuestLog.GetNextWaypointForMap,
            questID,
            playerMap.mapID.value
        )
    )

    result.forPlayerMap.ok = values[1] and true or false

    if not result.forPlayerMap.ok then
        result.forPlayerMap.error =
            "GetNextWaypointForMap failed"
        return result
    end

    result.forPlayerMap.x = scalarRecord(values[2])
    result.forPlayerMap.y = scalarRecord(values[3])

    if not result.bearing.available
        or not playerMap.position.ok
        or not usableNumber(result.forPlayerMap.x)
        or not usableNumber(result.forPlayerMap.y)
    then
        return result
    end

    local dx =
        result.forPlayerMap.x.value
        - playerMap.position.x.value
    local dy =
        result.forPlayerMap.y.value
        - playerMap.position.y.value

    result.bearing.ok = true
    result.bearing.dx = dx
    result.bearing.dy = dy
    result.bearing.degrees =
        (math.deg(math.atan2(dx, -dy)) + 360) % 360

    return result
end

local function captureQuestState()
    local result = {
        selected = callScalars(
            "C_QuestLog.GetSelectedQuest",
            C_QuestLog and C_QuestLog.GetSelectedQuest
        ),
        superTracked = callScalars(
            "C_SuperTrack.GetSuperTrackedQuestID",
            C_SuperTrack and C_SuperTrack.GetSuperTrackedQuestID
        ),
        activeQuestID = scalarRecord(nil),
        playerMap = playerMapState(),
    }

    local superTracked = firstReturn(result.superTracked)
    local selected = firstReturn(result.selected)

    if usableNumber(superTracked) and superTracked.value > 0 then
        result.activeQuestID = scalarRecord(superTracked.value)
    elseif usableNumber(selected) and selected.value > 0 then
        result.activeQuestID = scalarRecord(selected.value)
    end

    if not usableNumber(result.activeQuestID) then
        return result
    end

    local questID = result.activeQuestID.value

    result.title = callScalars(
        "C_QuestLog.GetTitleForQuestID",
        C_QuestLog and C_QuestLog.GetTitleForQuestID,
        questID
    )
    result.complete = callScalars(
        "C_QuestLog.IsComplete",
        C_QuestLog and C_QuestLog.IsComplete,
        questID
    )
    result.failed = callScalars(
        "C_QuestLog.IsFailed",
        C_QuestLog and C_QuestLog.IsFailed,
        questID
    )
    result.readyForTurnIn = callScalars(
        "C_QuestLog.ReadyForTurnIn",
        C_QuestLog and C_QuestLog.ReadyForTurnIn,
        questID
    )
    result.objectives = captureQuestObjectives(questID)
    result.waypoint = questWaypointState(
        questID,
        result.playerMap
    )

    return result
end

local function apiPresence()
    return {
        questID = type(GetQuestID) == "function",
        questTitle = type(GetTitleText) == "function",
        questText = type(GetQuestText) == "function",
        objectiveText = type(GetObjectiveText) == "function",
        progressText = type(GetProgressText) == "function",
        rewardText = type(GetRewardText) == "function",
        questObjectives =
            C_QuestLog
            and type(C_QuestLog.GetQuestObjectives) == "function"
            or false,
        selectedQuest =
            C_QuestLog
            and type(C_QuestLog.GetSelectedQuest) == "function"
            or false,
        nextWaypoint =
            C_QuestLog
            and type(C_QuestLog.GetNextWaypoint) == "function"
            or false,
        nextWaypointForMap =
            C_QuestLog
            and type(C_QuestLog.GetNextWaypointForMap) == "function"
            or false,
        superTrackedQuest =
            C_SuperTrack
            and type(C_SuperTrack.GetSuperTrackedQuestID) == "function"
            or false,
        unitXP = type(UnitXP) == "function",
        unitXPMax = type(UnitXPMax) == "function",
        restedXP = type(GetXPExhaustion) == "function",
        foreverExperiencePreset =
            C_GameRules
            and type(C_GameRules.GetForeverExperiencePreset)
                == "function"
            or false,
        issecretvalue = type(issecretvalue) == "function",
    }
end

local function captureSnapshot(reason)
    local db = ensureDB()
    local version, build, _, interfaceVersion = GetBuildInfo()

    local row = {
        reason = reason or "manual",
        time = type(time) == "function" and time() or nil,
        build = {
            version = scalarRecord(version),
            build = scalarRecord(build),
            interfaceVersion = scalarRecord(interfaceVersion),
        },
        apiPresence = apiPresence(),
        xp = captureXP(),
        quest = captureQuestState(),
        eventCounts = db.eventCounts,
        eventRegistration = db.eventRegistration,
        lastInteraction = db.lastInteraction,
        lastEvents = db.lastEvents,
    }

    db.snapshots[#db.snapshots + 1] = row

    while #db.snapshots > MAX_SNAPSHOTS do
        table.remove(db.snapshots, 1)
    end

    db.lastReason = row.reason
    return row
end

local function eventSummary(db, event)
    return string.format(
        "%s=%s/%s",
        event,
        boolText(db.eventRegistration[event] == true),
        tostring(db.eventCounts[event] or 0)
    )
end

local function objectiveSummary(objectives)
    if not objectives then
        return "nil"
    end

    if not objectives.available then
        return "<api-unavailable>"
    end

    if not objectives.ok then
        return "<call-failed>"
    end

    if not objectives.present then
        return "nil"
    end

    if objectives.secret then
        return "<secret>"
    end

    local parts = {}

    for index = 1, #objectives.objectives do
        local row = objectives.objectives[index]

        if row.secret then
            parts[#parts + 1] =
                tostring(index) .. ":<secret>"
        else
            parts[#parts + 1] = string.format(
                "%s:%s [%s/%s done=%s]",
                tostring(index),
                recordText(row.text),
                recordText(row.numFulfilled),
                recordText(row.numRequired),
                recordText(row.finished)
            )
        end
    end

    if #parts == 0 then
        return "<empty>"
    end

    return table.concat(parts, " | ")
end

local function waypointText(quest)
    if not quest
        or not quest.waypoint
        or not usableNumber(quest.activeQuestID)
    then
        return "quest=nil"
    end

    local waypoint = quest.waypoint
    local nextReturns = waypoint.nextWaypoint.returns

    local nextMap = nextReturns and nextReturns[1]
    local nextX = nextReturns and nextReturns[2]
    local nextY = nextReturns and nextReturns[3]

    local forMapX =
        waypoint.forPlayerMap
        and waypoint.forPlayerMap.x
    local forMapY =
        waypoint.forPlayerMap
        and waypoint.forPlayerMap.y

    local bearing = "nil"

    if waypoint.bearing and waypoint.bearing.ok then
        bearing = string.format(
            "%.1f",
            waypoint.bearing.degrees
        )
    end

    return string.format(
        "quest=%s next=%s/%s/%s playerMap=%s forMap=%s,%s bearing=%s text=%s",
        recordText(quest.activeQuestID),
        recordText(nextMap),
        recordText(nextX),
        recordText(nextY),
        recordText(quest.playerMap.mapID),
        recordText(forMapX),
        recordText(forMapY),
        bearing,
        firstText(waypoint.nextWaypointText)
    )
end

local function interactionLine(interaction)
    if not interaction then
        return "LQA interaction last=nil"
    end

    return string.format(
        "LQA interaction last=%s id=%s title=%s quest=%s objective=%s progress=%s reward=%s rewardXP=%s choices=%s rewards=%s",
        tostring(interaction.reason),
        firstText(interaction.questID),
        firstText(interaction.title),
        firstText(interaction.questText),
        firstText(interaction.objectiveText),
        firstText(interaction.progressText),
        firstText(interaction.rewardText),
        firstText(interaction.rewardXP),
        firstText(interaction.numChoices),
        firstText(interaction.numRewards)
    )
end

local function printReport(output)
    local emit = type(output) == "function"
        and output
        or print
    local db = ensureDB()
    local snapshot = db.snapshots[#db.snapshots]

    if not snapshot then
        snapshot = captureSnapshot("report")
    end

    local quest = snapshot.quest
    local xp = snapshot.xp

    emit(string.format(
        "LQA reason=%s build=%s/%s interface=%s",
        tostring(snapshot.reason),
        recordText(snapshot.build.version),
        recordText(snapshot.build.build),
        recordText(snapshot.build.interfaceVersion)
    ))

    emit(string.format(
        "LQA api npc=%s/%s/%s/%s/%s/%s quest=%s/%s waypoint=%s/%s super=%s xp=%s/%s/%s preset=%s secret=%s",
        boolText(snapshot.apiPresence.questID),
        boolText(snapshot.apiPresence.questTitle),
        boolText(snapshot.apiPresence.questText),
        boolText(snapshot.apiPresence.objectiveText),
        boolText(snapshot.apiPresence.progressText),
        boolText(snapshot.apiPresence.rewardText),
        boolText(snapshot.apiPresence.questObjectives),
        boolText(snapshot.apiPresence.selectedQuest),
        boolText(snapshot.apiPresence.nextWaypoint),
        boolText(snapshot.apiPresence.nextWaypointForMap),
        boolText(snapshot.apiPresence.superTrackedQuest),
        boolText(snapshot.apiPresence.unitXP),
        boolText(snapshot.apiPresence.unitXPMax),
        boolText(snapshot.apiPresence.restedXP),
        boolText(snapshot.apiPresence.foreverExperiencePreset),
        boolText(snapshot.apiPresence.issecretvalue)
    ))

    emit(string.format(
        "LQA xp current=%s max=%s rested=%s preset=%s",
        firstText(xp.current),
        firstText(xp.maximum),
        firstText(xp.rested),
        firstText(xp.experiencePreset)
    ))

    emit(string.format(
        "LQA quest selected=%s super=%s active=%s title=%s complete=%s failed=%s ready=%s",
        firstText(quest.selected),
        firstText(quest.superTracked),
        recordText(quest.activeQuestID),
        quest.title and firstText(quest.title) or "nil",
        quest.complete and firstText(quest.complete) or "nil",
        quest.failed and firstText(quest.failed) or "nil",
        quest.readyForTurnIn
            and firstText(quest.readyForTurnIn)
            or "nil"
    ))

    emit(
        "LQA objectives "
        .. objectiveSummary(quest.objectives)
    )

    emit(
        "LQA waypoint "
        .. waypointText(quest)
    )

    emit(interactionLine(snapshot.lastInteraction))

    emit(string.format(
        "LQA events quest %s %s %s %s %s %s",
        eventSummary(db, "QUEST_DETAIL"),
        eventSummary(db, "QUEST_PROGRESS"),
        eventSummary(db, "QUEST_COMPLETE"),
        eventSummary(db, "QUEST_ACCEPTED"),
        eventSummary(db, "QUEST_TURNED_IN"),
        eventSummary(db, "QUEST_LOG_UPDATE")
    ))

    emit(string.format(
        "LQA events tracking %s %s %s xp %s %s",
        eventSummary(db, "QUEST_WATCH_LIST_CHANGED"),
        eventSummary(db, "QUEST_WATCH_UPDATE"),
        eventSummary(db, "SUPER_TRACKING_CHANGED"),
        eventSummary(db, "PLAYER_XP_UPDATE"),
        eventSummary(db, "UPDATE_EXHAUSTION")
    ))
end

function LogresQuestAudit_Run(output)
    captureSnapshot("developer-panel")
    printReport(output)
end

SLASH_LOGRESQUESTAUDIT1 = "/lqa"
SlashCmdList.LOGRESQUESTAUDIT = function()
    captureSnapshot("slash")
    printReport()
end

local db = ensureDB()

for _, event in ipairs(trackedEvents) do
    local ok = pcall(
        frame.RegisterEvent,
        frame,
        event
    )

    db.eventRegistration[event] = ok and true or false

    if db.eventCounts[event] == nil then
        db.eventCounts[event] = 0
    end
end

frame:SetScript("OnEvent", function(_, event, ...)
    local currentDB = ensureDB()
    currentDB.eventCounts[event] =
        (currentDB.eventCounts[event] or 0) + 1

    local eventRecord = {
        time = type(time) == "function" and time() or nil,
        payload = {},
    }

    local values = pack(...)

    for index = 1, values.n do
        eventRecord.payload[index] =
            scalarRecord(values[index])
    end

    currentDB.lastEvents[event] = eventRecord

    if event == "QUEST_DETAIL"
        or event == "QUEST_PROGRESS"
        or event == "QUEST_COMPLETE"
    then
        captureInteraction(event)
    end
end)
