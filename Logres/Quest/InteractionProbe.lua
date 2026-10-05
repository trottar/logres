local _, Logres = ...

local MAX_ROWS = 4
local TEXT_LIMIT = 96

local Probe = Logres:RegisterModule("QuestInteractionProbe", {
    autoEnable = true,
})

local CAPTURE_EVENTS = {
    GOSSIP_SHOW = true,
    QUEST_DETAIL = true,
    QUEST_PROGRESS = true,
    QUEST_COMPLETE = true,
}

local TRACKED_EVENTS = {
    "GOSSIP_SHOW",
    "GOSSIP_CLOSED",
    "QUEST_DETAIL",
    "QUEST_PROGRESS",
    "QUEST_COMPLETE",
    "QUEST_FINISHED",
}

local STATE_REASONS = {
    "GOSSIP_SHOW",
    "QUEST_DETAIL",
    "QUEST_PROGRESS",
    "QUEST_COMPLETE",
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function pack(...)
    return {
        n = select("#", ...),
        ...,
    }
end

local function truncateText(value)
    if #value <= TEXT_LIMIT then
        return value
    end

    return value:sub(1, TEXT_LIMIT - 3) .. "..."
end

local function scalarRecord(value)
    local secret = isSecret(value)

    if secret then
        return {
            present = true,
            secret = true,
        }
    end

    if value == nil then
        return {
            present = false,
            secret = false,
        }
    end

    local valueType = type(value)
    local record = {
        present = true,
        secret = false,
        valueType = valueType,
    }

    if valueType == "string" then
        record.value = truncateText(value)
    elseif valueType == "number"
        or valueType == "boolean"
    then
        record.value = value
    end

    return record
end

local function recordText(record)
    if not record then
        return "nil"
    end

    if record.secret == true then
        return "<secret>"
    end

    if record.present ~= true then
        return "nil"
    end

    if record.valueType == "string" then
        if record.value == "" then
            return "<empty>"
        end

        return record.value or "<string>"
    end

    if record.valueType == "number"
        or record.valueType == "boolean"
    then
        return tostring(record.value)
    end

    return "<" .. tostring(record.valueType or "value") .. ">"
end

local function firstRecord(call)
    if not call
        or type(call.returns) ~= "table"
    then
        return nil
    end

    return call.returns[1]
end

local function recordNumber(record)
    if not record
        or record.secret == true
        or record.present ~= true
        or record.valueType ~= "number"
    then
        return nil
    end

    return record.value
end

local function callScalars(label, func, ...)
    local result = {
        label = label,
        available = type(func) == "function",
        ok = false,
        callFailed = false,
        returns = {},
    }

    if not result.available then
        return result
    end

    local values = pack(pcall(func, ...))
    result.ok = values[1] == true
    result.callFailed = not result.ok

    if not result.ok then
        result.error = scalarRecord(values[2])
        return result
    end

    for index = 2, values.n do
        result.returns[#result.returns + 1] =
            scalarRecord(values[index])
    end

    return result
end

local function sanitizeGossipQuestRow(value)
    if type(value) ~= "table" then
        return {
            invalidType = type(value),
        }
    end

    return {
        questID = scalarRecord(value.questID),
        title = scalarRecord(value.title),
        questLevel = scalarRecord(value.questLevel),
        isTrivial = scalarRecord(value.isTrivial),
        frequency = scalarRecord(value.frequency),
        repeatable = scalarRecord(value.repeatable),
        isComplete = scalarRecord(value.isComplete),
    }
end

local function sanitizeGossipOptionRow(value)
    if type(value) ~= "table" then
        return {
            invalidType = type(value),
        }
    end

    return {
        gossipOptionID = scalarRecord(value.gossipOptionID),
        name = scalarRecord(value.name),
        status = scalarRecord(value.status),
        spellID = scalarRecord(value.spellID),
        orderIndex = scalarRecord(value.orderIndex),
        failureDescription =
            scalarRecord(value.failureDescription),
    }
end

local function sanitizeCurrencyRow(value)
    if type(value) ~= "table" then
        return {
            invalidType = type(value),
        }
    end

    return {
        name = scalarRecord(value.name),
        currencyID = scalarRecord(value.currencyID),
        quality = scalarRecord(value.quality),
        baseRewardAmount =
            scalarRecord(value.baseRewardAmount),
        bonusRewardAmount =
            scalarRecord(value.bonusRewardAmount),
        totalRewardAmount =
            scalarRecord(value.totalRewardAmount),
    }
end

local function sanitizeSpellID(value)
    return {
        spellID = scalarRecord(value),
    }
end

local function captureRows(label, func, rowReader, ...)
    local result = {
        label = label,
        available = type(func) == "function",
        ok = false,
        callFailed = false,
        present = false,
        secret = false,
        rows = {},
        truncated = false,
    }

    if not result.available then
        return result
    end

    local values = pack(pcall(func, ...))
    result.ok = values[1] == true
    result.callFailed = not result.ok

    if not result.ok then
        result.error = scalarRecord(values[2])
        return result
    end

    local raw = values[2]
    local rawSecret = isSecret(raw)
    result.secret = rawSecret

    if rawSecret then
        result.present = true
        return result
    end

    if raw == nil then
        return result
    end

    result.present = true

    if type(raw) ~= "table" then
        result.invalidType = type(raw)
        return result
    end

    for index = 1, MAX_ROWS do
        local row = raw[index]
        local rowSecret = isSecret(row)

        if rowSecret then
            result.rows[#result.rows + 1] = {
                present = true,
                secret = true,
            }
        elseif row == nil then
            break
        else
            result.rows[#result.rows + 1] = {
                present = true,
                secret = false,
                value = rowReader(row),
            }
        end
    end

    local extra = raw[MAX_ROWS + 1]
    local extraSecret = isSecret(extra)

    if extraSecret then
        result.truncated = true
    elseif extra ~= nil then
        result.truncated = true
    end

    return result
end

local function captureQuestItems(kind, countRecord)
    local result = {
        kind = kind,
        infoAvailable =
            type(GetQuestItemInfo) == "function",
        linkAvailable =
            type(GetQuestItemLink) == "function",
        rows = {},
        truncated = false,
    }

    local count = recordNumber(countRecord)

    if count == nil
        or count < 0
        or not result.infoAvailable
    then
        return result
    end

    local limit = math.min(count, MAX_ROWS)
    result.truncated = count > MAX_ROWS

    for index = 1, limit do
        local info = callScalars(
            "GetQuestItemInfo",
            GetQuestItemInfo,
            kind,
            index
        )
        local link = callScalars(
            "GetQuestItemLink",
            GetQuestItemLink,
            kind,
            index
        )

        result.rows[#result.rows + 1] = {
            index = index,
            info = info,
            link = link,
            name = info.returns[1],
            texture = info.returns[2],
            count = info.returns[3],
            quality = info.returns[4],
            isUsable = info.returns[5],
            itemID = info.returns[6],
            itemLink = link.returns[1],
        }
    end

    return result
end

local function interactionQuestID(interaction)
    if not interaction then
        return nil
    end

    return recordNumber(firstRecord(interaction.questID))
end

local function captureInteraction()
    local interaction = {
        questID = callScalars(
            "GetQuestID",
            GetQuestID
        ),
        title = callScalars(
            "GetTitleText",
            GetTitleText
        ),
        detailText = callScalars(
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
        choiceCount = callScalars(
            "GetNumQuestChoices",
            GetNumQuestChoices
        ),
        rewardCount = callScalars(
            "GetNumQuestRewards",
            GetNumQuestRewards
        ),
    }

    interaction.choiceItems = captureQuestItems(
        "choice",
        firstRecord(interaction.choiceCount)
    )
    interaction.rewardItems = captureQuestItems(
        "reward",
        firstRecord(interaction.rewardCount)
    )

    local questID = interactionQuestID(interaction)

    if type(questID) == "number"
        and questID > 0
    then
        interaction.currencies = captureRows(
            "C_QuestInfoSystem.GetQuestRewardCurrencies",
            C_QuestInfoSystem
                and C_QuestInfoSystem.GetQuestRewardCurrencies,
            sanitizeCurrencyRow,
            questID
        )
        interaction.spells = captureRows(
            "C_QuestInfoSystem.GetQuestRewardSpells",
            C_QuestInfoSystem
                and C_QuestInfoSystem.GetQuestRewardSpells,
            sanitizeSpellID,
            questID
        )
    else
        interaction.currencies = {
            label =
                "C_QuestInfoSystem.GetQuestRewardCurrencies",
            available =
                C_QuestInfoSystem
                and type(
                    C_QuestInfoSystem.GetQuestRewardCurrencies
                ) == "function"
                or false,
            ok = false,
            callFailed = false,
            present = false,
            secret = false,
            rows = {},
            deferred = "quest-id-unavailable",
        }
        interaction.spells = {
            label =
                "C_QuestInfoSystem.GetQuestRewardSpells",
            available =
                C_QuestInfoSystem
                and type(
                    C_QuestInfoSystem.GetQuestRewardSpells
                ) == "function"
                or false,
            ok = false,
            callFailed = false,
            present = false,
            secret = false,
            rows = {},
            deferred = "quest-id-unavailable",
        }
    end

    return interaction
end

local function captureGossip()
    return {
        availableQuests = captureRows(
            "C_GossipInfo.GetAvailableQuests",
            C_GossipInfo
                and C_GossipInfo.GetAvailableQuests,
            sanitizeGossipQuestRow
        ),
        activeQuests = captureRows(
            "C_GossipInfo.GetActiveQuests",
            C_GossipInfo
                and C_GossipInfo.GetActiveQuests,
            sanitizeGossipQuestRow
        ),
        options = captureRows(
            "C_GossipInfo.GetOptions",
            C_GossipInfo
                and C_GossipInfo.GetOptions,
            sanitizeGossipOptionRow
        ),
    }
end

local function containsSecret(value, seen)
    if type(value) ~= "table" then
        return false
    end

    seen = seen or {}

    if seen[value] then
        return false
    end

    seen[value] = true

    if value.secret == true then
        return true
    end

    for _, child in pairs(value) do
        if type(child) == "table"
            and containsSecret(child, seen)
        then
            return true
        end
    end

    return false
end

local function countCallFailures(value, seen)
    if type(value) ~= "table" then
        return 0
    end

    seen = seen or {}

    if seen[value] then
        return 0
    end

    seen[value] = true

    local count =
        value.callFailed == true and 1 or 0

    for _, child in pairs(value) do
        if type(child) == "table" then
            count =
                count
                + countCallFailures(child, seen)
        end
    end

    return count
end

local function rowsText(capture)
    if not capture then
        return "nil"
    end

    if capture.secret == true then
        return "<secret>"
    end

    if capture.present ~= true then
        return "0"
    end

    local text = tostring(#capture.rows)

    if capture.truncated == true then
        text = text .. "+"
    end

    return text
end

local function mutationPresence()
    return {
        accept =
            type(AcceptQuest) == "function",
        decline =
            type(DeclineQuest) == "function",
        continue =
            type(CompleteQuest) == "function",
        reward =
            type(GetQuestReward) == "function",
        selectAvailable =
            C_GossipInfo
            and type(
                C_GossipInfo.SelectAvailableQuest
            ) == "function"
            or false,
        selectActive =
            C_GossipInfo
            and type(
                C_GossipInfo.SelectActiveQuest
            ) == "function"
            or false,
        selectOption =
            C_GossipInfo
            and type(
                C_GossipInfo.SelectOption
            ) == "function"
            or false,
        selectOptionByIndex =
            C_GossipInfo
            and type(
                C_GossipInfo.SelectOptionByIndex
            ) == "function"
            or false,
    }
end

local function readPresence()
    return {
        questID =
            type(GetQuestID) == "function",
        title =
            type(GetTitleText) == "function",
        detailText =
            type(GetQuestText) == "function",
        objectiveText =
            type(GetObjectiveText) == "function",
        progressText =
            type(GetProgressText) == "function",
        rewardText =
            type(GetRewardText) == "function",
        rewardXP =
            type(GetRewardXP) == "function",
        choiceCount =
            type(GetNumQuestChoices) == "function",
        rewardCount =
            type(GetNumQuestRewards) == "function",
        itemInfo =
            type(GetQuestItemInfo) == "function",
        itemLink =
            type(GetQuestItemLink) == "function",
        rewardCurrencies =
            C_QuestInfoSystem
            and type(
                C_QuestInfoSystem.GetQuestRewardCurrencies
            ) == "function"
            or false,
        rewardSpells =
            C_QuestInfoSystem
            and type(
                C_QuestInfoSystem.GetQuestRewardSpells
            ) == "function"
            or false,
        gossipAvailable =
            C_GossipInfo
            and type(
                C_GossipInfo.GetAvailableQuests
            ) == "function"
            or false,
        gossipActive =
            C_GossipInfo
            and type(
                C_GossipInfo.GetActiveQuests
            ) == "function"
            or false,
        gossipOptions =
            C_GossipInfo
            and type(
                C_GossipInfo.GetOptions
            ) == "function"
            or false,
    }
end

local function interactionSummary(interaction)
    if not interaction then
        return "interaction=none"
    end

    return string.format(
        "quest=%s title=%s detail=%s objective=%s progress=%s rewardText=%s rewardXP=%s choices=%s rewards=%s currencies=%s spells=%s",
        recordText(firstRecord(interaction.questID)),
        recordText(firstRecord(interaction.title)),
        recordText(firstRecord(interaction.detailText)),
        recordText(firstRecord(interaction.objectiveText)),
        recordText(firstRecord(interaction.progressText)),
        recordText(firstRecord(interaction.rewardText)),
        recordText(firstRecord(interaction.rewardXP)),
        recordText(firstRecord(interaction.choiceCount)),
        recordText(firstRecord(interaction.rewardCount)),
        rowsText(interaction.currencies),
        rowsText(interaction.spells)
    )
end

local function gossipSummary(gossip)
    if not gossip then
        return "gossip=none"
    end

    return string.format(
        "gossipAvailable=%s gossipActive=%s gossipOptions=%s",
        rowsText(gossip.availableQuests),
        rowsText(gossip.activeQuests),
        rowsText(gossip.options)
    )
end

local function appendItemLines(lines, label, items)
    if not items then
        return
    end

    for index = 1, #items.rows do
        local row = items.rows[index]

        lines[#lines + 1] = string.format(
            "%s[%s] name=%s count=%s quality=%s usable=%s itemID=%s link=%s",
            label,
            tostring(row.index),
            recordText(row.name),
            recordText(row.count),
            recordText(row.quality),
            recordText(row.isUsable),
            recordText(row.itemID),
            recordText(row.itemLink)
        )
    end
end

local function appendCurrencyLines(lines, capture)
    if not capture then
        return
    end

    for index = 1, #capture.rows do
        local row = capture.rows[index]

        if row.secret == true then
            lines[#lines + 1] =
                "currency[" .. tostring(index) .. "]=<secret>"
        elseif row.value then
            lines[#lines + 1] = string.format(
                "currency[%s] name=%s id=%s quality=%s total=%s",
                tostring(index),
                recordText(row.value.name),
                recordText(row.value.currencyID),
                recordText(row.value.quality),
                recordText(
                    row.value.totalRewardAmount
                )
            )
        end
    end
end

local function appendSpellLines(lines, capture)
    if not capture then
        return
    end

    for index = 1, #capture.rows do
        local row = capture.rows[index]

        if row.secret == true then
            lines[#lines + 1] =
                "spell[" .. tostring(index) .. "]=<secret>"
        elseif row.value then
            lines[#lines + 1] = string.format(
                "spell[%s] id=%s",
                tostring(index),
                recordText(row.value.spellID)
            )
        end
    end
end

local function appendGossipQuestLines(
    lines,
    label,
    capture
)
    if not capture then
        return
    end

    for index = 1, #capture.rows do
        local row = capture.rows[index]

        if row.secret == true then
            lines[#lines + 1] =
                label
                .. "["
                .. tostring(index)
                .. "]=<secret>"
        elseif row.value then
            lines[#lines + 1] = string.format(
                "%s[%s] questID=%s title=%s complete=%s repeatable=%s",
                label,
                tostring(index),
                recordText(row.value.questID),
                recordText(row.value.title),
                recordText(row.value.isComplete),
                recordText(row.value.repeatable)
            )
        end
    end
end

local function appendGossipOptionLines(lines, capture)
    if not capture then
        return
    end

    for index = 1, #capture.rows do
        local row = capture.rows[index]

        if row.secret == true then
            lines[#lines + 1] =
                "option[" .. tostring(index) .. "]=<secret>"
        elseif row.value then
            lines[#lines + 1] = string.format(
                "option[%s] id=%s order=%s status=%s name=%s failure=%s",
                tostring(index),
                recordText(
                    row.value.gossipOptionID
                ),
                recordText(row.value.orderIndex),
                recordText(row.value.status),
                recordText(row.value.name),
                recordText(
                    row.value.failureDescription
                )
            )
        end
    end
end

function Probe:CaptureSnapshot(reason)
    self.captureSequence =
        self.captureSequence + 1

    local snapshot = {
        sequence = self.captureSequence,
        reason = reason,
    }

    if reason == "manual"
        or reason == "GOSSIP_SHOW"
    then
        snapshot.gossip = captureGossip()
    end

    if reason == "manual"
        or reason == "QUEST_DETAIL"
        or reason == "QUEST_PROGRESS"
        or reason == "QUEST_COMPLETE"
    then
        snapshot.interaction = captureInteraction()
    end

    snapshot.secretObserved =
        containsSecret(snapshot)
    snapshot.callFailureCount =
        countCallFailures(snapshot)

    self.captureCount = self.captureCount + 1
    self.lastSnapshot = snapshot
    self.lastCaptureReason = reason
    self.lastByReason[reason] = snapshot

    return snapshot
end

function Probe:CaptureManual()
    if not self.moduleEnabled then
        return false, "module-disabled"
    end

    self.manualCount = self.manualCount + 1
    self:CaptureSnapshot("manual")

    return true, "captured"
end

function Probe:GetDebugStatus()
    local mutations = mutationPresence()
    local reads = readPresence()

    return {
        moduleEnabled = self.moduleEnabled == true,
        eventFrameReady = self.eventFrame ~= nil,
        captureCount = self.captureCount,
        manualCount = self.manualCount,
        mutationCallCount = self.mutationCallCount,
        lastEvent = self.lastEvent,
        lastCaptureReason = self.lastCaptureReason,

        gossipShowRegistered =
            self.eventRegistration.GOSSIP_SHOW == true,
        gossipClosedRegistered =
            self.eventRegistration.GOSSIP_CLOSED == true,
        questDetailRegistered =
            self.eventRegistration.QUEST_DETAIL == true,
        questProgressRegistered =
            self.eventRegistration.QUEST_PROGRESS == true,
        questCompleteRegistered =
            self.eventRegistration.QUEST_COMPLETE == true,
        questFinishedRegistered =
            self.eventRegistration.QUEST_FINISHED == true,

        gossipShowCount =
            self.eventCounts.GOSSIP_SHOW or 0,
        gossipClosedCount =
            self.eventCounts.GOSSIP_CLOSED or 0,
        questDetailCount =
            self.eventCounts.QUEST_DETAIL or 0,
        questProgressCount =
            self.eventCounts.QUEST_PROGRESS or 0,
        questCompleteCount =
            self.eventCounts.QUEST_COMPLETE or 0,
        questFinishedCount =
            self.eventCounts.QUEST_FINISHED or 0,

        mutationAPIs = mutations,
        readAPIs = reads,

        detailObserved =
            self.lastByReason.QUEST_DETAIL ~= nil,
        progressObserved =
            self.lastByReason.QUEST_PROGRESS ~= nil,
        completeObserved =
            self.lastByReason.QUEST_COMPLETE ~= nil,
        gossipObserved =
            self.lastByReason.GOSSIP_SHOW ~= nil,
    }
end

function Probe:GetDiagnosticLines()
    local lines = {}
    local debugStatus = self:GetDebugStatus()
    local reads = debugStatus.readAPIs
    local mutations = debugStatus.mutationAPIs

    lines[#lines + 1] = string.format(
        "events registered/count gossip=%s/%s closed=%s/%s detail=%s/%s progress=%s/%s complete=%s/%s finished=%s/%s",
        tostring(debugStatus.gossipShowRegistered),
        tostring(debugStatus.gossipShowCount),
        tostring(debugStatus.gossipClosedRegistered),
        tostring(debugStatus.gossipClosedCount),
        tostring(debugStatus.questDetailRegistered),
        tostring(debugStatus.questDetailCount),
        tostring(debugStatus.questProgressRegistered),
        tostring(debugStatus.questProgressCount),
        tostring(debugStatus.questCompleteRegistered),
        tostring(debugStatus.questCompleteCount),
        tostring(debugStatus.questFinishedRegistered),
        tostring(debugStatus.questFinishedCount)
    )

    lines[#lines + 1] = string.format(
        "readAPIs quest=%s/%s/%s/%s/%s/%s reward=%s/%s/%s item=%s/%s currencies=%s spells=%s gossip=%s/%s/%s",
        tostring(reads.questID),
        tostring(reads.title),
        tostring(reads.detailText),
        tostring(reads.objectiveText),
        tostring(reads.progressText),
        tostring(reads.rewardText),
        tostring(reads.rewardXP),
        tostring(reads.choiceCount),
        tostring(reads.rewardCount),
        tostring(reads.itemInfo),
        tostring(reads.itemLink),
        tostring(reads.rewardCurrencies),
        tostring(reads.rewardSpells),
        tostring(reads.gossipAvailable),
        tostring(reads.gossipActive),
        tostring(reads.gossipOptions)
    )

    lines[#lines + 1] = string.format(
        "mutationAPIs present accept=%s decline=%s continue=%s reward=%s gossipAvailable=%s gossipActive=%s option=%s optionByIndex=%s invoked=%s",
        tostring(mutations.accept),
        tostring(mutations.decline),
        tostring(mutations.continue),
        tostring(mutations.reward),
        tostring(mutations.selectAvailable),
        tostring(mutations.selectActive),
        tostring(mutations.selectOption),
        tostring(mutations.selectOptionByIndex),
        tostring(debugStatus.mutationCallCount)
    )

    for index = 1, #STATE_REASONS do
        local reason = STATE_REASONS[index]
        local snapshot = self.lastByReason[reason]

        if snapshot then
            lines[#lines + 1] = string.format(
                "%s seq=%s secret=%s failures=%s %s %s",
                reason,
                tostring(snapshot.sequence),
                tostring(snapshot.secretObserved),
                tostring(snapshot.callFailureCount),
                interactionSummary(snapshot.interaction),
                gossipSummary(snapshot.gossip)
            )
        end
    end

    local rewardSnapshot =
        self.lastByReason.QUEST_COMPLETE
        or self.lastByReason.QUEST_DETAIL
        or self.lastByReason.QUEST_PROGRESS
        or self.lastByReason.manual

    if rewardSnapshot
        and rewardSnapshot.interaction
    then
        appendItemLines(
            lines,
            "choice",
            rewardSnapshot.interaction.choiceItems
        )
        appendItemLines(
            lines,
            "reward",
            rewardSnapshot.interaction.rewardItems
        )
        appendCurrencyLines(
            lines,
            rewardSnapshot.interaction.currencies
        )
        appendSpellLines(
            lines,
            rewardSnapshot.interaction.spells
        )
    end

    local gossipSnapshot =
        self.lastByReason.GOSSIP_SHOW
        or self.lastByReason.manual

    if gossipSnapshot
        and gossipSnapshot.gossip
    then
        appendGossipQuestLines(
            lines,
            "available",
            gossipSnapshot.gossip.availableQuests
        )
        appendGossipQuestLines(
            lines,
            "active",
            gossipSnapshot.gossip.activeQuests
        )
        appendGossipOptionLines(
            lines,
            gossipSnapshot.gossip.options
        )
    end

    return lines
end

function Probe:OnInitialize()
    self.moduleEnabled = false
    self.eventFrame = nil
    self.eventRegistration = {}
    self.eventCounts = {}
    self.lastByReason = {}
    self.captureSequence = 0
    self.captureCount = 0
    self.manualCount = 0
    self.mutationCallCount = 0
    self.lastEvent = "initialize"
    self.lastCaptureReason = nil
    self.lastSnapshot = nil

    local eventFrame = CreateFrame("Frame")

    for index = 1, #TRACKED_EVENTS do
        local event = TRACKED_EVENTS[index]
        local ok = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )

        self.eventRegistration[event] =
            ok and true or false
        self.eventCounts[event] = 0
    end

    eventFrame:SetScript("OnEvent", function(_, event)
        if not self.moduleEnabled then
            return
        end

        self.lastEvent = event
        self.eventCounts[event] =
            (self.eventCounts[event] or 0) + 1

        if CAPTURE_EVENTS[event] then
            self:CaptureSnapshot(event)
        end
    end)

    self.eventFrame = eventFrame
end

function Probe:OnEnable()
    self.moduleEnabled = true
end

function Probe:OnDisable()
    self.moduleEnabled = false
end
