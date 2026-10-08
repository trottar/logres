local _, Logres = ...

local MAX_OBJECTIVES = 8
local PREVIEW_NORMAL = "normal"
local PREVIEW_COMPLETE = "complete"

local ActiveQuest = Logres:RegisterModule("ActiveQuest", {
    autoEnable = true,
})

local theme = Logres.Theme or {}
local activeStyle = theme.activeQuest or {}
local activeAssets = activeStyle.assets or {}
local activeColors = activeStyle.colors or {}
local percentageStyle = theme.percentageBar or {}
local percentageAssets = percentageStyle.assets or {}

local DEFAULT_STYLE = {
    width = 320,
    minHeight = 136,
    headerHeight = 86,
    rowHeight = 42,
    rowGap = 6,
    bottomPadding = 14,
    x = -360,
    y = -150,
    titleWidth = 258,
    titleFont = "GameFontNormalLarge",
    ambientFont = "GameFontHighlightSmall",
    objectiveFont = "GameFontHighlightSmall",
    objectiveTextWidth = 250,
}

local DEFAULT_COLORS = {
    title = { 0.94, 0.84, 0.62, 1.00 },
    ambient = { 0.70, 0.64, 0.51, 0.94 },
    objective = { 0.82, 0.76, 0.64, 0.96 },
    complete = { 0.94, 0.72, 0.32, 1.00 },
    progress = { 0.63, 0.45, 0.16, 1.00 },
    progressComplete = { 0.82, 0.64, 0.24, 1.00 },
    hover = { 0.86, 0.72, 0.44, 0.10 },
    unknown = { 0.44, 0.33, 0.18, 0.72 },
}

local function styleValue(name)
    local value = activeStyle[name]
    if value ~= nil then
        return value
    end
    return DEFAULT_STYLE[name]
end

local function colorValue(name)
    return activeColors[name] or DEFAULT_COLORS[name]
end

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function copyColor(value, fallback)
    if type(value) ~= "table" then
        return fallback
    end

    return {
        value[1] or fallback[1],
        value[2] or fallback[2],
        value[3] or fallback[3],
        value[4] or fallback[4],
    }
end

local function clampPercent(value)
    if value < 0 then
        return 0
    end
    if value > 100 then
        return 100
    end
    return value
end

local function readQuestTitle(questID)
    if not C_QuestLog
        or type(C_QuestLog.GetTitleForQuestID) ~= "function"
    then
        return nil, "title-api-unavailable", nil, false
    end

    local ok, title =
        pcall(C_QuestLog.GetTitleForQuestID, questID)

    if not ok then
        return nil,
            "title-call-failed",
            "GetTitleForQuestID call failed",
            false
    end

    if title == nil then
        return nil, "title-unavailable", nil, false
    end

    if isSecret(title) then
        return nil, "title-secret", nil, true
    end

    if type(title) ~= "string" or title == "" then
        return nil,
            "title-invalid",
            "GetTitleForQuestID returned invalid title",
            false
    end

    return title, "title-ready", nil, false
end

local function readQuestFlag(label, func, questID)
    if type(func) ~= "function" then
        return nil, label .. "-api-unavailable", nil, false
    end

    local ok, value = pcall(func, questID)

    if not ok then
        return nil,
            label .. "-call-failed",
            label .. " call failed",
            false
    end

    if value == nil then
        return nil, label .. "-unavailable", nil, false
    end

    if isSecret(value) then
        return nil, label .. "-secret", nil, true
    end

    if type(value) ~= "boolean" then
        return nil,
            label .. "-invalid",
            label .. " returned non-boolean",
            false
    end

    return value, label .. "-ready", nil, false
end

local function percentageSpec()
    return percentageStyle.normal or {
        trackWidth = 142,
        trackHeight = 12,
        frameHeight = 18,
        textWidth = 34,
        textGap = 8,
        diamondSize = 10,
        font = "GameFontNormal",
    }
end

local function createProgressBar(parent)
    local spec = percentageSpec()
    local trackColor = copyColor(
        percentageStyle.trackColor,
        { 0.012, 0.010, 0.008, 0.94 }
    )
    local borderColor = copyColor(
        percentageStyle.borderColor,
        { 0.45, 0.32, 0.15, 0.96 }
    )
    local textColor = copyColor(
        percentageStyle.textColor,
        { 0.94, 0.90, 0.80, 1.00 }
    )
    local diamondSize = spec.diamondSize or 10
    local totalWidth =
        (spec.trackWidth or 142)
        + diamondSize

    local frame = CreateFrame("Frame", nil, parent)
    frame:SetSize(totalWidth, spec.frameHeight or 18)
    frame:EnableMouse(false)

    local status = CreateFrame("StatusBar", nil, frame)
    status:SetPoint("LEFT", frame, "LEFT", diamondSize / 2, 0)
    status:SetSize(spec.trackWidth or 142, spec.trackHeight or 12)
    status:SetMinMaxValues(0, 100)
    status:SetValue(0)
    status:SetStatusBarTexture(
        percentageAssets.fill
            or "Interface\\Buttons\\WHITE8x8"
    )

    local track = status:CreateTexture(nil, "BACKGROUND")
    track:SetAllPoints(status)
    track:SetColorTexture(
        trackColor[1],
        trackColor[2],
        trackColor[3],
        trackColor[4]
    )

    local function borderTexture()
        local texture = status:CreateTexture(nil, "BORDER")
        texture:SetColorTexture(
            borderColor[1],
            borderColor[2],
            borderColor[3],
            borderColor[4]
        )
        return texture
    end

    local top = borderTexture()
    top:SetPoint("TOPLEFT", status, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", status, "TOPRIGHT", 0, 0)
    top:SetHeight(1)

    local bottom = borderTexture()
    bottom:SetPoint("BOTTOMLEFT", status, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", status, "BOTTOMRIGHT", 0, 0)
    bottom:SetHeight(1)

    local leftEdge = borderTexture()
    leftEdge:SetPoint("TOPLEFT", status, "TOPLEFT", 0, 0)
    leftEdge:SetPoint("BOTTOMLEFT", status, "BOTTOMLEFT", 0, 0)
    leftEdge:SetWidth(1)

    local rightEdge = borderTexture()
    rightEdge:SetPoint("TOPRIGHT", status, "TOPRIGHT", 0, 0)
    rightEdge:SetPoint("BOTTOMRIGHT", status, "BOTTOMRIGHT", 0, 0)
    rightEdge:SetWidth(1)

    local leftDiamond = frame:CreateTexture(nil, "ARTWORK")
    leftDiamond:SetSize(diamondSize, diamondSize)
    leftDiamond:SetPoint("CENTER", status, "LEFT", 0, 0)
    leftDiamond:SetTexture(
        percentageAssets.diamond
            or "Interface\\Buttons\\WHITE8x8"
    )

    local rightDiamond = frame:CreateTexture(nil, "ARTWORK")
    rightDiamond:SetSize(diamondSize, diamondSize)
    rightDiamond:SetPoint("CENTER", status, "RIGHT", 0, 0)
    rightDiamond:SetTexture(
        percentageAssets.diamond
            or "Interface\\Buttons\\WHITE8x8"
    )

    frame.status = status
    frame.leftDiamond = leftDiamond
    frame.rightDiamond = rightDiamond

    return frame
end

local function setProgressBarColor(bar, color)
    bar.status:SetStatusBarColor(
        color[1],
        color[2],
        color[3],
        color[4] or 1
    )
    bar.leftDiamond:SetVertexColor(
        color[1],
        color[2],
        color[3],
        color[4] or 1
    )
    bar.rightDiamond:SetVertexColor(
        color[1],
        color[2],
        color[3],
        color[4] or 1
    )
end

function ActiveQuest:HidePresentation(reason)
    if self.root then
        self.root:Hide()
    end

    self.presentationShown = false
    self.displayRows = {}

    if GameTooltip and type(GameTooltip.Hide) == "function" then
        GameTooltip:Hide()
    end

    if reason then
        self.lastPresentationReason = reason
    end
end

function ActiveQuest:ReadLiveSnapshot()
    local progress = Logres:GetModule("QuestObjectiveProgress")

    local questID, sourceReason, sourceError, sourceSecret =
        progress:ReadActiveQuestID()

    if questID == nil then
        return nil,
            sourceReason or "no-active-quest",
            sourceError,
            sourceSecret
    end

    local rows, rowReason, rowError, rowSecret =
        progress:ReadObjectives(questID)

    if rows == nil then
        return nil,
            rowReason or "objectives-unavailable",
            rowError,
            rowSecret
    end

    local title, titleReason, titleError, titleSecret =
        readQuestTitle(questID)

    if title == nil then
        return nil,
            titleReason,
            titleError,
            titleSecret
    end

    local complete, completeReason, completeError, completeSecret =
        readQuestFlag(
            "quest-complete",
            C_QuestLog and C_QuestLog.IsComplete,
            questID
        )

    if completeError or completeSecret then
        return nil,
            completeReason,
            completeError,
            completeSecret
    end

    local ready, readyReason, readyError, readySecret =
        readQuestFlag(
            "quest-ready",
            C_QuestLog and C_QuestLog.ReadyForTurnIn,
            questID
        )

    if readyError or readySecret then
        return nil,
            readyReason,
            readyError,
            readySecret
    end

    return {
        questID = questID,
        source = sourceReason,
        title = title,
        rows = rows,
        complete = complete,
        ready = ready,
        preview = false,
    }, "live-ready", nil, false
end

function ActiveQuest:BuildPreviewSnapshot(mode)
    if mode == PREVIEW_COMPLETE then
        return {
            questID = 0,
            source = "preview-complete",
            title = "PREVIEW · Active Quest",
            rows = {
                {
                    text = "Defeat the invading raiders",
                    finished = true,
                    fulfilled = 8,
                    required = 8,
                },
                {
                    text = "Recover the stolen supplies",
                    finished = true,
                    fulfilled = 1,
                    required = 1,
                },
            },
            complete = true,
            ready = true,
            preview = true,
        }
    end

    return {
        questID = 0,
        source = "preview-normal",
        title = "PREVIEW · Active Quest",
        rows = {
            {
                text = "Defeat the invading raiders",
                finished = false,
                fulfilled = 3,
                required = 10,
            },
            {
                text = "Secure the eastern road",
                finished = true,
                fulfilled = 1,
                required = 1,
            },
            {
                text = "Recover the stolen supplies",
                finished = false,
                fulfilled = 0,
                required = 4,
            },
        },
        complete = false,
        ready = false,
        preview = true,
    }
end

function ActiveQuest:PercentForRow(row)
    if not isSecret(row.finished)
        and row.finished == true
    then
        return 100
    end

    if isSecret(row.fulfilled)
        or isSecret(row.required)
    then
        return nil
    end

    if type(row.fulfilled) == "number"
        and type(row.required) == "number"
        and row.required > 0
    then
        return clampPercent(
            (row.fulfilled / row.required) * 100
        )
    end

    return nil
end

function ActiveQuest:AmbientPhrase(snapshot)
    if snapshot.ready == true then
        return "Ready to return."
    end

    if snapshot.complete == true then
        return "The task is complete."
    end

    local anyFinished = false
    local anyProgress = false
    local anyMeasurable = false

    for index = 1, #snapshot.rows do
        local row = snapshot.rows[index]

        if not isSecret(row.finished)
            and row.finished == true
        then
            anyFinished = true
        end

        if not isSecret(row.fulfilled)
            and not isSecret(row.required)
            and type(row.fulfilled) == "number"
            and type(row.required) == "number"
            and row.required > 0
        then
            anyMeasurable = true

            if row.fulfilled > 0 then
                anyProgress = true
            end
        end
    end

    if anyFinished then
        return "The work advances."
    end

    if anyProgress then
        return "Progress is underway."
    end

    if anyMeasurable then
        return "The work lies ahead."
    end

    return nil
end

function ActiveQuest:ShowInspection(index)
    local row = self.displayRows[index]

    if not row or not GameTooltip then
        return
    end

    local progress = Logres:GetModule("QuestObjectiveProgress")
    local label = progress:StableObjectiveText(row)

    GameTooltip:SetOwner(self.rows[index].hit, "ANCHOR_LEFT")
    GameTooltip:SetText(label)

    if not isSecret(row.fulfilled)
        and not isSecret(row.required)
        and type(row.fulfilled) == "number"
        and type(row.required) == "number"
        and row.required > 0
    then
        GameTooltip:AddLine(
            string.format(
                "%.0f / %.0f",
                row.fulfilled,
                row.required
            )
        )
    elseif not isSecret(row.finished)
        and row.finished == true
    then
        GameTooltip:AddLine("Complete")
    end

    GameTooltip:Show()

    local hover = self.rows[index].hover
    local color = colorValue("hover")
    hover:SetColorTexture(
        color[1],
        color[2],
        color[3],
        color[4]
    )
    hover:Show()
end

function ActiveQuest:HideInspection(index)
    if GameTooltip and type(GameTooltip.Hide) == "function" then
        GameTooltip:Hide()
    end

    if self.rows[index] then
        self.rows[index].hover:Hide()
    end
end

function ActiveQuest:Render(snapshot, reason)
    local progress =
        Logres:GetModule("QuestObjectiveProgress")
    local titleColor = colorValue("title")
    local completeVisual =
        snapshot.ready == true
        or snapshot.complete == true
    local ambientColor =
        completeVisual
        and colorValue("complete")
        or colorValue("ambient")

    self.title:SetText(snapshot.title)
    self.title:SetTextColor(
        titleColor[1],
        titleColor[2],
        titleColor[3],
        titleColor[4]
    )

    local phrase = self:AmbientPhrase(snapshot)
    if phrase then
        self.ambient:SetText(phrase)
        self.ambient:SetTextColor(
            ambientColor[1],
            ambientColor[2],
            ambientColor[3],
            ambientColor[4]
        )
        self.ambient:Show()
    else
        self.ambient:ClearText()
        self.ambient:Hide()
    end

    local glyphColor =
        completeVisual
        and colorValue("complete")
        or colorValue("title")

    self.glyph:SetVertexColor(
        glyphColor[1],
        glyphColor[2],
        glyphColor[3],
        glyphColor[4]
    )

    self.displayRows = {}

    local visibleCount =
        math.min(#snapshot.rows, MAX_OBJECTIVES)

    for index = 1, MAX_OBJECTIVES do
        local visual = self.rows[index]
        local row = snapshot.rows[index]

        if index <= visibleCount and row then
            self.displayRows[index] = row
            visual.hit:Show()

            local finished =
                not isSecret(row.finished)
                and row.finished == true
            local objectiveColor =
                finished
                and colorValue("complete")
                or colorValue("objective")

            visual.label:SetText(
                progress:NormalizeObjectiveLabel(row)
            )
            visual.label:SetTextColor(
                objectiveColor[1],
                objectiveColor[2],
                objectiveColor[3],
                objectiveColor[4]
            )
            visual.label:Show()

            local percent = self:PercentForRow(row)

            if percent ~= nil then
                visual.unknown:Hide()
                visual.bar.status:SetValue(percent)
                local progressColor =
                    finished
                    and colorValue("progressComplete")
                    or colorValue("progress")

                setProgressBarColor(
                    visual.bar,
                    progressColor
                )
                visual.bar:Show()
            else
                visual.bar:Hide()
                local unknownColor = colorValue("unknown")
                visual.unknown:SetColorTexture(
                    unknownColor[1],
                    unknownColor[2],
                    unknownColor[3],
                    unknownColor[4]
                )
                visual.unknown:Show()
            end
        else
            visual.hit:Hide()
            visual.label:Hide()
            visual.bar:Hide()
            visual.unknown:Hide()
            visual.hover:Hide()
        end
    end

    local rowHeight = styleValue("rowHeight")
    local rowGap = styleValue("rowGap")
    local rowsHeight = 0

    if visibleCount > 0 then
        rowsHeight =
            visibleCount * rowHeight
            + (visibleCount - 1) * rowGap
    end

    local totalHeight = math.max(
        styleValue("minHeight"),
        styleValue("headerHeight")
            + rowsHeight
            + styleValue("bottomPadding")
    )

    self.root:SetHeight(totalHeight)
    self.root:Show()

    self.presentationShown = true
    self.presentationCount = self.presentationCount + 1
    self.lastQuestID =
        snapshot.preview and nil or snapshot.questID
    self.lastSource = snapshot.source
    self.lastRowCount = #snapshot.rows
    self.lastVisibleRowCount = visibleCount
    self.lastComplete = snapshot.complete == true
    self.lastReady = snapshot.ready == true
    self.lastTitleReady = true
    self.lastSecret = false
    self.lastError = nil
    self.lastPresentationReason = reason or snapshot.source

    return true, "shown"
end

function ActiveQuest:Refresh(reason)
    self.refreshCount = self.refreshCount + 1
    self.lastReason = reason or "refresh"

    if not self.moduleEnabled then
        self:HidePresentation("module-disabled")
        return false, "module-disabled"
    end

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return true, "suppressed-immersion-off"
    end

    if not self.activeQuestEnabled then
        self:HidePresentation("feature-off")
        return true, "suppressed-feature-off"
    end

    local snapshot
    local state
    local errorText
    local secretObserved

    if self.previewMode then
        snapshot =
            self:BuildPreviewSnapshot(self.previewMode)
        state = "preview-" .. self.previewMode
    else
        snapshot, state, errorText, secretObserved =
            self:ReadLiveSnapshot()
    end

    if not snapshot then
        self.lastQuestID = nil
        self.lastSource = state
        self.lastRowCount = 0
        self.lastVisibleRowCount = 0
        self.lastComplete = false
        self.lastReady = false
        self.lastTitleReady = false
        self.lastSecret = secretObserved and true or false
        self.lastError = errorText
        self:HidePresentation(state or "unavailable")

        if errorText or secretObserved then
            return false, state or "unavailable"
        end

        return true, state or "unavailable"
    end

    return self:Render(
        snapshot,
        reason or state
    )
end

function ActiveQuest:SetPreviewMode(mode)
    if mode == nil
        or mode == "live"
        or mode == "off"
    then
        self.previewMode = nil
        return self:Refresh("preview-live")
    end

    if mode ~= PREVIEW_NORMAL
        and mode ~= PREVIEW_COMPLETE
    then
        return false, "invalid-preview-mode"
    end

    self.previewMode = mode
    self.previewCount = self.previewCount + 1
    return self:Refresh("preview-" .. mode)
end

function ActiveQuest:ApplyPreferences(preferences)
    self.immersionEnabled =
        preferences.immersionEnabled == true
    self.activeQuestEnabled =
        preferences.activeQuestEnabled == true

    if not self.immersionEnabled then
        self:HidePresentation("immersion-off")
        return
    end

    if not self.activeQuestEnabled then
        self:HidePresentation("feature-off")
        return
    end

    self:Refresh("preference-change")
end

function ActiveQuest:GetDebugStatus()
    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.root ~= nil,
        titleReady = self.title ~= nil,
        ambientReady = self.ambient ~= nil,
        rowsReady =
            self.rows ~= nil
            and #self.rows == MAX_OBJECTIVES,
        eventFrameReady = self.eventFrame ~= nil,
        titleAPIAvailable =
            C_QuestLog ~= nil
            and type(C_QuestLog.GetTitleForQuestID) == "function",
        completeAPIAvailable =
            C_QuestLog ~= nil
            and type(C_QuestLog.IsComplete) == "function",
        readyAPIAvailable =
            C_QuestLog ~= nil
            and type(C_QuestLog.ReadyForTurnIn) == "function",
        tooltipAvailable = GameTooltip ~= nil,
        immersionEnabled = self.immersionEnabled == true,
        activeQuestEnabled = self.activeQuestEnabled == true,
        previewMode = self.previewMode,
        presentationShown = self.presentationShown == true,
        presentationCount = self.presentationCount,
        previewCount = self.previewCount,
        refreshCount = self.refreshCount,
        questLogEventCount = self.questLogEventCount,
        questWatchEventCount = self.questWatchEventCount,
        questWatchListEventCount =
            self.questWatchListEventCount,
        superTrackingEventCount =
            self.superTrackingEventCount,
        worldEventCount = self.worldEventCount,
        lastQuestID = self.lastQuestID,
        lastSource = self.lastSource,
        lastRowCount = self.lastRowCount,
        lastVisibleRowCount = self.lastVisibleRowCount,
        lastComplete = self.lastComplete == true,
        lastReady = self.lastReady == true,
        lastTitleReady = self.lastTitleReady == true,
        lastSecret = self.lastSecret == true,
        lastReason = self.lastReason,
        lastPresentationReason =
            self.lastPresentationReason,
        lastError = self.lastError,
        questLogEventRegistered =
            self.eventRegistration.QUEST_LOG_UPDATE == true,
        questWatchEventRegistered =
            self.eventRegistration.QUEST_WATCH_UPDATE == true,
        questWatchListEventRegistered =
            self.eventRegistration.QUEST_WATCH_LIST_CHANGED == true,
        superTrackingEventRegistered =
            self.eventRegistration.SUPER_TRACKING_CHANGED == true,
        worldEventRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,
    }
end

function ActiveQuest:OnInitialize()
    self.moduleEnabled = false
    self.immersionEnabled = false
    self.activeQuestEnabled = true
    self.previewMode = nil
    self.presentationShown = false
    self.presentationCount = 0
    self.previewCount = 0
    self.refreshCount = 0
    self.questLogEventCount = 0
    self.questWatchEventCount = 0
    self.questWatchListEventCount = 0
    self.superTrackingEventCount = 0
    self.worldEventCount = 0
    self.lastQuestID = nil
    self.lastSource = "initialize"
    self.lastRowCount = 0
    self.lastVisibleRowCount = 0
    self.lastComplete = false
    self.lastReady = false
    self.lastTitleReady = false
    self.lastSecret = false
    self.lastReason = "initialize"
    self.lastPresentationReason = "initialize"
    self.lastError = nil
    self.displayRows = {}

    local root = CreateFrame(
        "Frame",
        "LogresActiveQuest",
        UIParent
    )
    root:SetSize(
        styleValue("width"),
        styleValue("minHeight")
    )
    root:SetPoint(
        "TOPRIGHT",
        UIParent,
        "TOPRIGHT",
        styleValue("x"),
        styleValue("y")
    )
    Logres.Layout.Bind(root, "activeQuest", "TOPRIGHT", "TOPRIGHT")
    root:SetFrameStrata("MEDIUM")
    root:SetClampedToScreen(true)
    root:EnableMouse(false)
    root:Hide()

    local panel = root:CreateTexture(nil, "BACKGROUND")
    panel:SetAllPoints(root)
    panel:SetTexture(
        activeAssets.panel
            or "Interface\\Buttons\\WHITE8x8"
    )

    local glyph = root:CreateTexture(nil, "ARTWORK")
    glyph:SetSize(28, 28)
    glyph:SetPoint("TOPLEFT", root, "TOPLEFT", 14, -12)
    glyph:SetTexture(
        activeAssets.glyph
            or "Interface\\Buttons\\WHITE8x8"
    )

    local title = root:CreateFontString(
        nil,
        "OVERLAY",
        styleValue("titleFont")
    )
    title:SetPoint(
        "TOPLEFT",
        root,
        "TOPLEFT",
        48,
        -13
    )
    title:SetWidth(styleValue("titleWidth"))
    title:SetHeight(34)
    title:SetJustifyH("LEFT")
    title:SetJustifyV("TOP")
    title:SetWordWrap(true)
    title:SetShadowColor(0, 0, 0, 0.90)
    title:SetShadowOffset(1, -1)

    local ambient = root:CreateFontString(
        nil,
        "OVERLAY",
        styleValue("ambientFont")
    )
    ambient:SetPoint(
        "TOPLEFT",
        root,
        "TOPLEFT",
        48,
        -50
    )
    ambient:SetWidth(styleValue("titleWidth"))
    ambient:SetJustifyH("LEFT")
    ambient:SetWordWrap(false)
    ambient:SetShadowColor(0, 0, 0, 0.85)
    ambient:SetShadowOffset(1, -1)

    local divider = root:CreateTexture(nil, "ARTWORK")
    divider:SetSize(styleValue("width") - 28, 16)
    divider:SetPoint("TOP", root, "TOP", 0, -69)
    divider:SetTexture(
        activeAssets.divider
            or "Interface\\Buttons\\WHITE8x8"
    )

    self.root = root
    self.panel = panel
    self.glyph = glyph
    self.title = title
    self.ambient = ambient
    self.divider = divider
    self.rows = {}

    local rowHeight = styleValue("rowHeight")
    local rowGap = styleValue("rowGap")
    local firstY = -styleValue("headerHeight")

    for index = 1, MAX_OBJECTIVES do
        local rowIndex = index
        local hit = CreateFrame("Frame", nil, root)
        hit:SetSize(
            styleValue("width") - 28,
            rowHeight
        )
        hit:SetPoint(
            "TOP",
            root,
            "TOP",
            0,
            firstY
                - ((index - 1) * (rowHeight + rowGap))
        )
        hit:EnableMouse(true)
        hit:Hide()

        local hover =
            hit:CreateTexture(nil, "BACKGROUND")
        hover:SetAllPoints(hit)
        hover:Hide()

        local label = hit:CreateFontString(
            nil,
            "OVERLAY",
            styleValue("objectiveFont")
        )
        label:SetPoint(
            "TOP",
            hit,
            "TOP",
            0,
            -1
        )
        label:SetWidth(
            styleValue("objectiveTextWidth")
        )
        label:SetHeight(16)
        label:SetJustifyH("LEFT")
        label:SetJustifyV("TOP")
        label:SetWordWrap(false)
        label:SetShadowColor(0, 0, 0, 0.85)
        label:SetShadowOffset(1, -1)
        label:Hide()

        local bar = createProgressBar(hit)
        bar:SetPoint(
            "BOTTOM",
            hit,
            "BOTTOM",
            0,
            2
        )

        local unknown =
            hit:CreateTexture(nil, "ARTWORK")
        unknown:SetSize(122, 1)
        unknown:SetPoint(
            "BOTTOM",
            hit,
            "BOTTOM",
            0,
            8
        )
        unknown:Hide()

        hit:SetScript("OnEnter", function()
            self:ShowInspection(rowIndex)
        end)
        hit:SetScript("OnLeave", function()
            self:HideInspection(rowIndex)
        end)

        self.rows[index] = {
            hit = hit,
            hover = hover,
            label = label,
            bar = bar,
            unknown = unknown,
        }
    end

    local eventFrame = CreateFrame("Frame")
    local events = {
        "QUEST_LOG_UPDATE",
        "QUEST_WATCH_UPDATE",
        "QUEST_WATCH_LIST_CHANGED",
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
        elseif event == "QUEST_WATCH_UPDATE" then
            self.questWatchEventCount =
                self.questWatchEventCount + 1
        elseif event == "QUEST_WATCH_LIST_CHANGED" then
            self.questWatchListEventCount =
                self.questWatchListEventCount + 1
        elseif event == "SUPER_TRACKING_CHANGED" then
            self.superTrackingEventCount =
                self.superTrackingEventCount + 1
        elseif event == "PLAYER_ENTERING_WORLD" then
            self.worldEventCount =
                self.worldEventCount + 1
        end

        self:Refresh(event)
    end)

    self.eventFrame = eventFrame
end

function ActiveQuest:OnEnable()
    self.moduleEnabled = true

    self:SubscribePreferences(function(preferences)
        self:ApplyPreferences(preferences)
    end)

    self:ApplyPreferences(Logres:GetPreferences())
end

function ActiveQuest:OnDisable()
    self.moduleEnabled = false
    self.previewMode = nil
    self:HidePresentation("module-disabled")
end
