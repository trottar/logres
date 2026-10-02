local _, Logres = ...

local PULSE_SECONDS = 3.0
local MAX_OBJECTIVES = 8
local MAX_PRESENTATION_ROWS = 2
local TEXT_LIMIT = 86
local PRESENTATION_WIDTH = 520
local PRESENTATION_HEIGHT = 32
local PRESENTATION_GAP = 6
local FALLBACK_Y = -5
local PREVIEW_TEXT = "PREVIEW · Objective progress · 3/10"

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

function Progress:HidePulse(reason)
    self.pulseGeneration = self.pulseGeneration + 1
    self.pulseShown = false

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
                    end
                end
            end
        end
    end

    return changed
end

function Progress:PresentLines(lines, reason)
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
    local generation = self.pulseGeneration

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

    local changed =
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
    self:PresentLines(
        changed,
        reason or "objective-change"
    )

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
        end
    end

    if #lines == 0 then
        return nil
    end

    return lines
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

    local lines =
        self:BuildCurrentPreviewLines()

    if lines then
        local ok, state =
            self:PresentLines(
                lines,
                "preview-current"
            )

        if ok and state == "shown" then
            return true, "shown-current"
        end

        return ok, state
    end

    local ok, state =
        self:PresentLines(
            { PREVIEW_TEXT },
            "preview-fallback"
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

    self.lastSecret = false
    self.lastSampleReason = "initialize"
    self.lastPresentationReason = "initialize"
    self.lastError = nil

    local root = CreateFrame(
        "Frame",
        "LogresQuestObjectiveProgress",
        UIParent
    )
    root:SetSize(
        PRESENTATION_WIDTH,
        PRESENTATION_HEIGHT
    )

    local targetAnchor = _G.LogresHUDTarget

    if targetAnchor then
        root:SetPoint(
            "BOTTOM",
            targetAnchor,
            "TOP",
            0,
            PRESENTATION_GAP
        )
    else
        root:SetPoint(
            "CENTER",
            UIParent,
            "CENTER",
            0,
            FALLBACK_Y
        )
    end
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()

    local text = root:CreateFontString(
        "LogresQuestObjectiveProgressText",
        "OVERLAY",
        "GameFontHighlight"
    )
    text:SetAllPoints(root)
    text:SetJustifyH("CENTER")
    text:SetJustifyV("MIDDLE")
    text:SetTextColor(0.88, 0.78, 0.54, 0.96)
    text:SetShadowColor(0, 0, 0, 0.90)
    text:SetShadowOffset(1, -1)
    text:ClearText()

    self.root = root
    self.text = text

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
end

function Progress:OnDisable()
    self.moduleEnabled = false
    self:ClearBaseline(
        "module-disabled",
        nil,
        false
    )
end
