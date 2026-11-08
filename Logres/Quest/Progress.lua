local _, Logres = ...

local PULSE_SECONDS = 3.0
local MAX_OBJECTIVES = 8
local MAX_PRESENTATION_ROWS = 2
local TEXT_LIMIT = 86
local PRESENTATION_WIDTH = 520
local PRESENTATION_HEIGHT = 32
local FALLBACK_Y = -5
local PREVIEW_TEXT = "PREVIEW · Objective progress · 3/10"

-- Only known, numbered quest-objective information messages are candidates.
-- In particular, ERR_QUEST_UNKNOWN_COMPLETE has no objective identity and
-- must remain Blizzard-owned. IDs are resolved by name per client build.
local NATIVE_OBJECTIVE_INFO = {
    { id = "LE_GAME_ERR_QUEST_ADD_KILL_SII", format = "ERR_QUEST_ADD_KILL_SII" },
    { id = "LE_GAME_ERR_QUEST_ADD_FOUND_SII", format = "ERR_QUEST_ADD_FOUND_SII" },
    { id = "LE_GAME_ERR_QUEST_ADD_ITEM_SII", format = "ERR_QUEST_ADD_ITEM_SII" },
    { id = "LE_GAME_ERR_QUEST_ADD_PLAYER_KILL_SII", format = "ERR_QUEST_ADD_PLAYER_KILL_SII" },
    { id = "LE_GAME_ERR_QUEST_OBJECTIVE_COMPLETE_S", format = "ERR_QUEST_OBJECTIVE_COMPLETE_S" },
}

local Progress = Logres:RegisterModule("QuestObjectiveProgress", {
    autoEnable = true,
})

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function trimText(value, limit)
    if #value <= limit then
        return value
    end

    return value:sub(1, limit - 3) .. "..."
end

local function readField(value, expectedType, label, allowNil)
    if value == nil then
        if allowNil then
            return nil, nil, false
        end

        return nil, label .. "-missing", false
    end

    if isSecret(value) then
        return nil, label .. "-secret", true
    end

    if type(value) ~= expectedType then
        return nil, label .. "-invalid", false
    end

    return value, nil, false
end

-- This is an *identity-gated presentation* filter, never an error-frame hide.
-- Unknown types and all failures pass through the original Blizzard method.
local function knownNativeObjectiveFormat(messageType)
    if isSecret(messageType) or type(messageType) ~= "number" then
        return nil
    end
    for _, entry in ipairs(NATIVE_OBJECTIVE_INFO) do
        local id = _G[entry.id]
        if id ~= nil and not isSecret(id) and type(id) == "number"
            and id == messageType then
            return _G[entry.format], entry.id == "LE_GAME_ERR_QUEST_OBJECTIVE_COMPLETE_S"
        end
    end
    return nil
end

local function rowMatchesNativeText(row, format, message)
    if isSecret(format) or type(format) ~= "string" then
        return false
    end
    if isSecret(message) or type(message) ~= "string" then
        return false
    end
    local name = row.text
    if isSecret(name) or type(name) ~= "string" then return false end
    -- Objective text from GetQuestObjectives can already include the N/M
    -- suffix. Accept it only when it is the same sanitized numeric progress.
    local fulfilled, required = row.fulfilled, row.required
    if isSecret(fulfilled) or isSecret(required)
        or type(fulfilled) ~= "number" or type(required) ~= "number"
        or fulfilled < 0 or required <= 0 then return false end
    local count = string.format("%.0f/%.0f", fulfilled, required)
    local stem = name
    if name:sub(-#count) == count then
        stem = name:sub(1, #name - #count):gsub("[%s:]+$", "")
    end
    if message == name then return true end
    -- The source supports both "/" objectives and localized formatted
    -- quest progress. If the format is incompatible, fail open.
    local formatted, expected = pcall(string.format, format, stem, fulfilled, required)
    if formatted and expected == message then return true end
    if row.finished == true then
        formatted, expected = pcall(string.format, format, stem)
        if formatted and expected == message then return true end
    end
    return false
end

function Progress:ShouldSuppressNativeObjective(messageType, message)
    if not self.moduleEnabled or not self.immersionEnabled
        or self.previewMode or not self.timerAvailable then return false end
    local format, completionOnly = knownNativeObjectiveFormat(messageType)
    if format == nil then return false end
    if isSecret(message) or type(message) ~= "string" then return false end
    -- A native info message may precede QUEST_LOG_UPDATE. Resample the
    -- addon-owned quest source once; this uses the normal baseline/diff gate,
    -- not native Blizzard frame visibility or any periodic polling.
    self:Refresh("native-objective-info", false)
    if not self.pulseShown or not self.nativePulseRows
        or self.nativePulseQuestID ~= self.currentQuestID then return false end
    for _, row in ipairs(self.nativePulseRows) do
        if (not completionOnly or row.finished == true)
            and rowMatchesNativeText(row, format, message) then
            self.nativeObjectiveSuppressed = self.nativeObjectiveSuppressed + 1
            self.lastNativeObjectiveDecision = "matched-owned-pulse"
            return true
        end
    end
    return false
end

function Progress:InstallNativeObjectiveGate()
    if self.nativeInfoFrame then return true end
    local frame = _G.UIErrorsFrame
    if frame == nil or isSecret(frame) then
        self.lastNativeObjectiveDecision = "frame-unavailable"
        return false
    end
    if type(InCombatLockdown) ~= "function" or InCombatLockdown() then
        self.lastNativeObjectiveDecision = "combat-or-lockdown-unavailable"
        return false
    end
    local prior = frame.ShouldDisplayMessageType
    if isSecret(prior) or type(prior) ~= "function" then
        self.lastNativeObjectiveDecision = "message-policy-unavailable"
        return false
    end
    local function scopedPolicy(owner, messageType, message)
        -- Never replace Blizzard's blacklist, throttle, or other decisions.
        local ok, nativeDecision = pcall(prior, owner, messageType, message)
        if not ok then return true end -- preserve information on failure
        if isSecret(nativeDecision) or nativeDecision ~= true then
            return nativeDecision
        end
        if isSecret(owner) or owner ~= frame then return nativeDecision end
        local success, suppress = pcall(self.ShouldSuppressNativeObjective,
            self, messageType, message)
        if success and suppress == true then return false end
        return nativeDecision
    end
    local ok = pcall(function() frame.ShouldDisplayMessageType = scopedPolicy end)
    if not ok or isSecret(frame.ShouldDisplayMessageType)
        or frame.ShouldDisplayMessageType ~= scopedPolicy then
        self.lastNativeObjectiveDecision = "policy-install-unavailable"
        return false
    end
    self.nativeInfoFrame = frame
    self.nativeInfoPrior = prior
    self.nativeInfoPolicy = scopedPolicy
    self.lastNativeObjectiveDecision = "scoped-policy-installed"
    return true
end

function Progress:RestoreNativeObjectiveGate()
    local frame = self.nativeInfoFrame
    if frame then
        if type(InCombatLockdown) ~= "function" or InCombatLockdown() then
            -- The still-installed policy is inert when the module is disabled.
            self.lastNativeObjectiveDecision = "combat-restoration-deferred-inert"
            return false
        end
        if not isSecret(frame) and not isSecret(frame.ShouldDisplayMessageType)
            and frame.ShouldDisplayMessageType == self.nativeInfoPolicy then
            pcall(function() frame.ShouldDisplayMessageType = self.nativeInfoPrior end)
        end
    end
    self.nativeInfoFrame = nil
    self.nativeInfoPolicy = nil
    self.nativeInfoPrior = nil
    return true
end

function Progress:HidePulse(reason)
    self.pulseGeneration = self.pulseGeneration + 1
    self.pulseShown = false
    self.nativePulseRows = nil
    self.nativePulseQuestID = nil

    if self.root then
        self.root:Hide()
    end

    if reason then
        self.lastPresentationReason = reason
    end
end

function Progress:ClearBaseline(reason, errorText, secretObserved)
    self.currentQuestID = nil
    self.baselineRows = nil
    self.baselineRowCount = 0
    self.lastSampleReason = reason
    self.lastError = errorText
    self.lastSecret = secretObserved and true or false
    self:HidePulse(reason)
end

function Progress:ReadActiveQuestID()
    self.superTrackedAPIAvailable =
        C_SuperTrack ~= nil
        and type(C_SuperTrack.GetSuperTrackedQuestID) == "function"

    self.selectedQuestAPIAvailable =
        C_QuestLog ~= nil
        and type(C_QuestLog.GetSelectedQuest) == "function"

    if self.superTrackedAPIAvailable then
        local ok, questID =
            pcall(C_SuperTrack.GetSuperTrackedQuestID)

        if not ok then
            return nil,
                "super-track-call-failed",
                "GetSuperTrackedQuestID call failed",
                false
        end

        if questID ~= nil then
            if isSecret(questID) then
                return nil,
                    "super-track-secret",
                    nil,
                    true
            end

            if type(questID) ~= "number" then
                return nil,
                    "super-track-invalid",
                    "GetSuperTrackedQuestID returned non-number",
                    false
            end

            if questID < 0 then
                return nil,
                    "super-track-invalid",
                    "GetSuperTrackedQuestID returned negative ID",
                    false
            end

            if questID > 0 then
                return questID, "super-tracked", nil, false
            end
        end
    end

    if self.selectedQuestAPIAvailable then
        local ok, questID =
            pcall(C_QuestLog.GetSelectedQuest)

        if not ok then
            return nil,
                "selected-quest-call-failed",
                "GetSelectedQuest call failed",
                false
        end

        if questID ~= nil then
            if isSecret(questID) then
                return nil,
                    "selected-quest-secret",
                    nil,
                    true
            end

            if type(questID) ~= "number" then
                return nil,
                    "selected-quest-invalid",
                    "GetSelectedQuest returned non-number",
                    false
            end

            if questID < 0 then
                return nil,
                    "selected-quest-invalid",
                    "GetSelectedQuest returned negative ID",
                    false
            end

            if questID > 0 then
                return questID, "selected-quest", nil, false
            end
        end
    end

    if not self.superTrackedAPIAvailable
        and not self.selectedQuestAPIAvailable
    then
        return nil,
            "quest-id-api-unavailable",
            "quest identity APIs unavailable",
            false
    end

    return nil, "no-active-quest", nil, false
end

function Progress:ReadObjectives(questID)
    self.objectiveAPIAvailable =
        C_QuestLog ~= nil
        and type(C_QuestLog.GetQuestObjectives) == "function"

    if not self.objectiveAPIAvailable then
        return nil,
            "objective-api-unavailable",
            "GetQuestObjectives unavailable",
            false
    end

    local ok, objectives =
        pcall(C_QuestLog.GetQuestObjectives, questID)

    if not ok then
        return nil,
            "objective-call-failed",
            "GetQuestObjectives call failed",
            false
    end

    if objectives == nil then
        return nil, "objectives-unavailable", nil, false
    end

    if isSecret(objectives) then
        return nil, "objectives-secret", nil, true
    end

    if type(objectives) ~= "table" then
        return nil,
            "objectives-invalid",
            "GetQuestObjectives returned non-table",
            false
    end

    local rows = {}

    for index, objective in ipairs(objectives) do
        if index > MAX_OBJECTIVES then
            return nil,
                "objective-count-exceeds-limit",
                "objective count exceeds production limit",
                false
        end

        if isSecret(objective) then
            return nil,
                "objective-row-secret",
                nil,
                true
        end

        if type(objective) ~= "table" then
            return nil,
                "objective-row-invalid",
                "objective row is not a table",
                false
        end

        local text, textError, textSecret =
            readField(
                objective.text,
                "string",
                "objective-text",
                false
            )

        if textError then
            return nil, textError, nil, textSecret
        end

        if text == "" then
            return nil, "objective-text-empty", nil, false
        end

        local finished, finishedError, finishedSecret =
            readField(
                objective.finished,
                "boolean",
                "objective-finished",
                true
            )

        if finishedError then
            return nil,
                finishedError,
                nil,
                finishedSecret
        end

        local fulfilled, fulfilledError, fulfilledSecret =
            readField(
                objective.numFulfilled,
                "number",
                "objective-fulfilled",
                true
            )

        if fulfilledError then
            return nil,
                fulfilledError,
                nil,
                fulfilledSecret
        end

        local required, requiredError, requiredSecret =
            readField(
                objective.numRequired,
                "number",
                "objective-required",
                true
            )

        if requiredError then
            return nil,
                requiredError,
                nil,
                requiredSecret
        end

        if fulfilled ~= nil and fulfilled < 0 then
            return nil,
                "objective-fulfilled-negative",
                "objective fulfilled count is negative",
                false
        end

        if required ~= nil and required < 0 then
            return nil,
                "objective-required-negative",
                "objective required count is negative",
                false
        end

        rows[#rows + 1] = {
            text = text,
            finished = finished,
            fulfilled = fulfilled,
            required = required,
        }
    end

    if #rows == 0 then
        return rows, "objectives-empty", nil, false
    end

    return rows, "objectives-ready", nil, false
end

function Progress:SetBaseline(questID, rows, reason)
    self.currentQuestID = questID
    self.baselineRows = rows
    self.baselineRowCount = #rows
    self.baselineCaptureCount =
        self.baselineCaptureCount + 1
    self.lastSampleReason = reason or "baseline"
    self.lastError = nil
    self.lastSecret = false
end

function Progress:StableObjectiveText(row)
    local label = row.text

    if type(row.fulfilled) == "number"
        and type(row.required) == "number"
        and row.required > 0
    then
        local prefix = string.format(
            "%.0f/%.0f",
            row.fulfilled,
            row.required
        )
        local prefixLength = #prefix

        if label:sub(1, prefixLength) == prefix then
            local nextCharacter =
                label:sub(
                    prefixLength + 1,
                    prefixLength + 1
                )

            if nextCharacter == " " then
                local remainder =
                    label:sub(prefixLength + 1)

                label =
                    remainder:gsub("^%s+", "")
            end
        end
    end

    return label
end

function Progress:NormalizeObjectiveLabel(row)
    return trimText(
        self:StableObjectiveText(row),
        TEXT_LIMIT
    )
end

function Progress:FormatRow(row)
    local label =
        self:NormalizeObjectiveLabel(row)

    if row.finished == true then
        return label .. "  ·  Complete"
    end

    if type(row.fulfilled) == "number"
        and type(row.required) == "number"
        and row.required > 0
    then
        return string.format(
            "%s  ·  %.0f/%.0f",
            label,
            row.fulfilled,
            row.required
        )
    end

    return nil
end

function Progress:FindChangedRows(previousRows, currentRows)
    local changed = {}
    local changedRows = {}
    local completed = false
    local maximum =
        math.max(#previousRows, #currentRows)

    for index = 1, maximum do
        local previous = previousRows[index]
        local current = currentRows[index]

        if previous and current then
            local previousIdentity =
                self:StableObjectiveText(previous)
            local currentIdentity =
                self:StableObjectiveText(current)

            if previousIdentity == currentIdentity then
                local countChanged =
                    type(previous.fulfilled) == "number"
                    and type(current.fulfilled) == "number"
                    and type(previous.required) == "number"
                    and type(current.required) == "number"
                    and (
                        previous.fulfilled ~= current.fulfilled
                        or previous.required ~= current.required
                    )

                local finishedChanged =
                    type(previous.finished) == "boolean"
                    and type(current.finished) == "boolean"
                    and previous.finished ~= current.finished

                if countChanged or finishedChanged then
                    local line = self:FormatRow(current)

                    if line then
                        changed[#changed + 1] = line
                        changedRows[#changedRows + 1] = current

                        if finishedChanged and current.finished == true then
                            completed = true
                        end
                    end
                end
            end
        end
    end

    self.pendingNativeRows = changedRows
    return changed, completed
end

function Progress:PresentLines(lines, reason, completed)
    if not self.moduleEnabled then
        self:HidePulse("module-disabled")
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePulse("immersion-off")
        return true, "suppressed-immersion-off"
    end

    if not self.timerAvailable then
        self:HidePulse("timer-unavailable")
        return false, "timer-unavailable"
    end

    local visible = {}
    local count = math.min(
        #lines,
        MAX_PRESENTATION_ROWS
    )

    for index = 1, count do
        visible[#visible + 1] = lines[index]
    end

    if #visible == 0 then
        return false, "no-presentable-change"
    end

    self.pulseGeneration = self.pulseGeneration + 1
    self.nativePulseRows = nil
    self.nativePulseQuestID = nil
    local generation = self.pulseGeneration

    Logres.ContextVisual.SetComplete(
        self.contextSurface,
        completed == true
    )
    self.lastCompletionPresentation = completed == true

    self.text:SetText(table.concat(visible, "\n"))
    self.root:Show()
    self.pulseShown = true
    self.lastPresentationReason =
        reason or "objective-change"

    C_Timer.After(PULSE_SECONDS, function()
        if not self.moduleEnabled then
            return
        end

        if self.pulseGeneration ~= generation then
            return
        end

        self.pulseShown = false
        self.nativePulseRows = nil
        self.nativePulseQuestID = nil
        self.root:Hide()
        self.lastPresentationReason = "timeout"
    end)

    return true, "shown"
end

function Progress:Refresh(reason, forceBaseline)
    local questID, questReason, questError, questSecret =
        self:ReadActiveQuestID()

    if questID == nil then
        self:ClearBaseline(
            questReason or reason or "no-active-quest",
            questError,
            questSecret
        )
        return false
    end

    local rows, objectiveReason, objectiveError, objectiveSecret =
        self:ReadObjectives(questID)

    if rows == nil then
        self:ClearBaseline(
            objectiveReason or reason or "objectives-unavailable",
            objectiveError,
            objectiveSecret
        )
        return false
    end

    self.lastError = nil
    self.lastSecret = false
    self.lastSampleReason =
        reason or objectiveReason or questReason or "refresh"

    local identityChanged =
        self.currentQuestID ~= questID

    if forceBaseline
        or identityChanged
        or self.baselineRows == nil
    then
        if identityChanged then
            self:HidePulse("quest-identity-changed")
        end

        self:SetBaseline(
            questID,
            rows,
            reason or "baseline"
        )
        return true
    end

    local changed, completed =
        self:FindChangedRows(
            self.baselineRows,
            rows
        )

    self.currentQuestID = questID
    self.baselineRows = rows
    self.baselineRowCount = #rows

    if #changed == 0 then
        return true
    end

    self.meaningfulChangeCount =
        self.meaningfulChangeCount + #changed

    if not self.immersionEnabled then
        self.suppressedCount =
            self.suppressedCount + 1
        self:HidePulse("objective-change-immersion-off")
        return true
    end

    self.pulseCount = self.pulseCount + 1
    local displayed, state = self:PresentLines(
        changed,
        reason or "objective-change",
        completed
    )
    if displayed and state == "shown" then
        self.nativePulseRows = {}
        for index = 1, math.min(#changedRows, MAX_PRESENTATION_ROWS) do
            self.nativePulseRows[index] = changedRows[index]
        end
        self.nativePulseQuestID = questID
    end

    return true
end

function Progress:ApplyPreferences(preferences)
    self.immersionEnabled =
        preferences.immersionEnabled == true

    if not self.immersionEnabled then
        self:HidePulse("immersion-off")
    end
end

function Progress:BuildCurrentPreviewLines()
    local questID =
        self:ReadActiveQuestID()

    if questID == nil then
        return nil
    end

    local rows =
        self:ReadObjectives(questID)

    if rows == nil then
        return nil
    end

    local lines = {}
    local completed = false
    local count =
        math.min(
            #rows,
            MAX_PRESENTATION_ROWS
        )

    for index = 1, count do
        local line =
            self:FormatRow(rows[index])

        if line then
            lines[#lines + 1] = line

            if rows[index].finished == true then
                completed = true
            end
        end
    end

    if #lines == 0 then
        return nil
    end

    return lines, completed
end

function Progress:ShowPreview()
    if not self.moduleEnabled then
        return false, "module-disabled"
    end

    self.previewCount = self.previewCount + 1

    if not self.immersionEnabled then
        self:HidePulse("immersion-off")
        return true, "suppressed-immersion-off"
    end

    local lines, completed =
        self:BuildCurrentPreviewLines()

    if lines then
        local ok, state =
            self:PresentLines(
                lines,
                "preview-current",
                completed
            )

        if ok and state == "shown" then
            return true, "shown-current"
        end

        return ok, state
    end

    local ok, state =
        self:PresentLines(
            { PREVIEW_TEXT },
            "preview-fallback",
            false
        )

    if ok and state == "shown" then
        return true, "shown-fallback"
    end

    return ok, state
end

function Progress:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.root ~= nil,
        textReady = self.text ~= nil,
        contextVisualReady = self.contextSurface ~= nil,
        lastCompletionPresentation = self.lastCompletionPresentation == true,
        eventFrameReady = self.eventFrame ~= nil,
        timerAvailable = self.timerAvailable == true,
        objectiveAPIAvailable =
            self.objectiveAPIAvailable == true,
        superTrackedAPIAvailable =
            self.superTrackedAPIAvailable == true,
        selectedQuestAPIAvailable =
            self.selectedQuestAPIAvailable == true,
        immersionEnabled = self.immersionEnabled == true,

        questLogEventRegistered =
            self.eventRegistration.QUEST_LOG_UPDATE == true,
        questWatchEventRegistered =
            self.eventRegistration.QUEST_WATCH_UPDATE == true,
        superTrackingEventRegistered =
            self.eventRegistration.SUPER_TRACKING_CHANGED == true,
        worldEventRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,

        questLogEventCount = self.questLogEventCount,
        questWatchEventCount = self.questWatchEventCount,
        superTrackingEventCount =
            self.superTrackingEventCount,
        worldEventCount = self.worldEventCount,

        baselineCaptureCount =
            self.baselineCaptureCount,
        meaningfulChangeCount =
            self.meaningfulChangeCount,
        pulseCount = self.pulseCount,
        suppressedCount = self.suppressedCount,
        previewCount = self.previewCount,

        currentQuestID = self.currentQuestID,
        baselineRowCount = self.baselineRowCount,
        pulseShown = self.pulseShown == true,
        nativeObjectiveGateInstalled = self.nativeInfoFrame ~= nil,
        nativeObjectiveSuppressed = self.nativeObjectiveSuppressed,
        lastNativeObjectiveDecision = self.lastNativeObjectiveDecision,

        lastSecret = self.lastSecret == true,
        lastSampleReason = self.lastSampleReason,
        lastPresentationReason =
            self.lastPresentationReason,
        lastError = self.lastError,
    }
end

function Progress:OnInitialize()
    self.moduleEnabled = false
    self.immersionEnabled = false

    self.objectiveAPIAvailable =
        C_QuestLog ~= nil
        and type(C_QuestLog.GetQuestObjectives) == "function"
    self.superTrackedAPIAvailable =
        C_SuperTrack ~= nil
        and type(C_SuperTrack.GetSuperTrackedQuestID) == "function"
    self.selectedQuestAPIAvailable =
        C_QuestLog ~= nil
        and type(C_QuestLog.GetSelectedQuest) == "function"
    self.timerAvailable =
        C_Timer ~= nil
        and type(C_Timer.After) == "function"

    self.currentQuestID = nil
    self.baselineRows = nil
    self.baselineRowCount = 0

    self.questLogEventCount = 0
    self.questWatchEventCount = 0
    self.superTrackingEventCount = 0
    self.worldEventCount = 0

    self.baselineCaptureCount = 0
    self.meaningfulChangeCount = 0
    self.pulseCount = 0
    self.suppressedCount = 0
    self.previewCount = 0
    self.pulseGeneration = 0
    self.pulseShown = false
    self.nativePulseRows = nil
    self.nativePulseQuestID = nil
    self.nativeInfoFrame = nil
    self.nativeInfoPrior = nil
    self.nativeInfoPolicy = nil
    self.nativeObjectiveSuppressed = 0
    self.lastNativeObjectiveDecision = "not-installed"

    self.lastSecret = false
    self.lastSampleReason = "initialize"
    self.lastPresentationReason = "initialize"
    self.lastError = nil

    local surface = Logres.ContextVisual.Create(
        UIParent,
        "LogresQuestObjectiveProgress",
        "objective"
    )
    local root = surface.root
    root:SetSize(
        PRESENTATION_WIDTH,
        PRESENTATION_HEIGHT
    )

    root:SetPoint(
        "CENTER",
        UIParent,
        "CENTER",
        0,
        FALLBACK_Y
    )
    Logres.Layout.Bind(root, "contextObjective", "CENTER", "CENTER")
    root:SetFrameStrata("BACKGROUND")
    root:EnableMouse(false)
    root:Hide()

    local text = surface.text

    self.root = root
    self.text = text
    self.contextSurface = surface
    self.lastCompletionPresentation = false

    local eventFrame = CreateFrame("Frame")
    local events = {
        "QUEST_LOG_UPDATE",
        "QUEST_WATCH_UPDATE",
        "SUPER_TRACKING_CHANGED",
        "PLAYER_ENTERING_WORLD",
    }

    self.eventRegistration = {}

    for index = 1, #events do
        local event = events[index]
        local ok = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )

        self.eventRegistration[event] =
            ok and true or false
    end

    eventFrame:SetScript("OnEvent", function(_, event)
        if not self.moduleEnabled then
            return
        end

        if event == "QUEST_LOG_UPDATE" then
            self.questLogEventCount =
                self.questLogEventCount + 1
            self:Refresh(event, false)
            return
        end

        if event == "QUEST_WATCH_UPDATE" then
            self.questWatchEventCount =
                self.questWatchEventCount + 1
            self:Refresh(event, false)
            return
        end

        if event == "SUPER_TRACKING_CHANGED" then
            self.superTrackingEventCount =
                self.superTrackingEventCount + 1
            self:Refresh(event, true)
            return
        end

        if event == "PLAYER_ENTERING_WORLD" then
            self.worldEventCount =
                self.worldEventCount + 1
            self:Refresh(event, true)
        end
    end)

    self.eventFrame = eventFrame
end

function Progress:OnEnable()
    self.moduleEnabled = true

    self:SubscribePreferences(function(preferences)
        self:ApplyPreferences(preferences)
    end)

    self:ApplyPreferences(Logres:GetPreferences())
    self:Refresh("enable", true)
    self:InstallNativeObjectiveGate()
end

function Progress:OnDisable()
    self.moduleEnabled = false
    self:RestoreNativeObjectiveGate()
    self:ClearBaseline(
        "module-disabled",
        nil,
        false
    )
end

-- P0357: command-invoked, addon-owned F.6 structural diagnostic.
function Progress:RunDevObjectiveProgressCheck(emit)
    local status =
        Logres:GetModuleStatus("QuestObjectiveProgress")
    local progress =
        Logres:GetModule("QuestObjectiveProgress")
    local debugStatus = progress:GetDebugStatus()

    local identityAPIAvailable =
        debugStatus.superTrackedAPIAvailable == true
        or debugStatus.selectedQuestAPIAvailable == true

    local baselineCoherent =
        (
            debugStatus.currentQuestID == nil
            and debugStatus.baselineRowCount == 0
        )
        or (
            type(debugStatus.currentQuestID) == "number"
            and debugStatus.currentQuestID > 0
            and type(debugStatus.baselineRowCount) == "number"
            and debugStatus.baselineRowCount >= 0
        )

    local policyCoherent =
        debugStatus.immersionEnabled == true
        or debugStatus.pulseShown == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.textReady == true
        and debugStatus.eventFrameReady == true
        and debugStatus.timerAvailable == true
        and debugStatus.objectiveAPIAvailable == true
        and identityAPIAvailable
        and debugStatus.questLogEventRegistered == true
        and debugStatus.questWatchEventRegistered == true
        and debugStatus.superTrackingEventRegistered == true
        and debugStatus.worldEventRegistered == true
        and baselineCoherent
        and policyCoherent
        and debugStatus.lastError == nil

    emit(string.format(
        "Logres objectiveprogresscheck: %s (initialized=%s enabled=%s module=%s immersion=%s api=%s identityAPI=%s timer=%s events=%s/%s/%s/%s eventCounts=%s/%s/%s/%s baselines=%s changes=%s pulses=%s suppressed=%s previews=%s shown=%s questID=%s rows=%s secret=%s sampleReason=%s presentationReason=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.objectiveAPIAvailable),
        tostring(identityAPIAvailable),
        tostring(debugStatus.timerAvailable),
        tostring(debugStatus.questLogEventRegistered),
        tostring(debugStatus.questWatchEventRegistered),
        tostring(debugStatus.superTrackingEventRegistered),
        tostring(debugStatus.worldEventRegistered),
        tostring(debugStatus.questLogEventCount),
        tostring(debugStatus.questWatchEventCount),
        tostring(debugStatus.superTrackingEventCount),
        tostring(debugStatus.worldEventCount),
        tostring(debugStatus.baselineCaptureCount),
        tostring(debugStatus.meaningfulChangeCount),
        tostring(debugStatus.pulseCount),
        tostring(debugStatus.suppressedCount),
        tostring(debugStatus.previewCount),
        tostring(debugStatus.pulseShown),
        tostring(debugStatus.currentQuestID),
        tostring(debugStatus.baselineRowCount),
        tostring(debugStatus.lastSecret),
        tostring(debugStatus.lastSampleReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError)
    ))
end
