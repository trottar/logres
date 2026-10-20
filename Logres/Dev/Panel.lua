local _, Logres = ...

local PANEL_WIDTH = 620
local PANEL_HEIGHT = 590
local TAB_WIDTH = 52
local TAB_HEIGHT = 24
local TAB_GAP = 0
local BUTTON_WIDTH = 180
local BUTTON_HEIGHT = 24
local BUTTON_GAP_X = 8
local BUTTON_GAP_Y = 6
local BUTTON_COLUMNS = 3
local MAX_ACTIONS_PER_PHASE = BUTTON_COLUMNS * 6
local PREVIEW_PAGE_SIZE = MAX_ACTIONS_PER_PHASE
local DEFAULT_PHASE = "G"

local MAX_DIAGNOSTIC_RUNS = 100
local MAX_DIAGNOSTIC_LINES = 120

local PHASES = {
    { id = "0", title = "Phase 0 — Foundation" },
    { id = "A", title = "Phase A — Core State Engine" },
    { id = "B", title = "Phase B — Core HUD" },
    { id = "C", title = "Phase C — Action Interface" },
    { id = "D", title = "Phase D — Immersion Controller" },
    { id = "E", title = "Phase E — Compass and Navigation" },
    { id = "F", title = "Phase F — Quest Experience" },
    { id = "G", title = "Phase G — Cinematic Camera" },
    { id = "H", title = "Phase H — Integration and Polish" },
    { id = "P", title = "Previews — All UI Areas" },
    { id = "M", title = "UI Mapping — Element Index" },
}

local PHASE_BY_ID = {}
for index = 1, #PHASES do
    PHASE_BY_ID[PHASES[index].id] = PHASES[index]
end

local function ensureDiagnosticsDB()
    LogresDiagnosticsDB = LogresDiagnosticsDB or {}
    LogresDiagnosticsDB.schema = 1
    LogresDiagnosticsDB.runs = LogresDiagnosticsDB.runs or {}
    return LogresDiagnosticsDB
end

local createH2PanelBox

local Panel = Logres:RegisterModule("DevPanel", {
    OnInitialize = function(self)
        ensureDiagnosticsDB()

        local frame = CreateFrame("Frame", "LogresDevPanel", UIParent)
        frame:SetSize(PANEL_WIDTH, PANEL_HEIGHT)
        frame:SetPoint("CENTER", UIParent, "CENTER", 0, 40)
        frame:SetFrameStrata("DIALOG")
        frame:SetClampedToScreen(true)
        frame:EnableMouse(true)
        frame:SetMovable(true)
        frame:RegisterForDrag("LeftButton")
        frame:SetScript("OnDragStart", function(current)
            current:StartMoving()
        end)
        frame:SetScript("OnDragStop", function(current)
            current:StopMovingOrSizing()
        end)

        local background = frame:CreateTexture(nil, "BACKGROUND")
        background:SetAllPoints(frame)
        background:SetColorTexture(0.035, 0.03, 0.025, 0.96)

        local topBorder = frame:CreateTexture(nil, "BORDER")
        topBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        topBorder:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
        topBorder:SetHeight(1)
        topBorder:SetColorTexture(0.45, 0.36, 0.22, 0.95)

        local bottomBorder = frame:CreateTexture(nil, "BORDER")
        bottomBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
        bottomBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        bottomBorder:SetHeight(1)
        bottomBorder:SetColorTexture(0.22, 0.18, 0.12, 0.95)

        local leftBorder = frame:CreateTexture(nil, "BORDER")
        leftBorder:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
        leftBorder:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 0)
        leftBorder:SetWidth(1)
        leftBorder:SetColorTexture(0.32, 0.26, 0.17, 0.95)

        local rightBorder = frame:CreateTexture(nil, "BORDER")
        rightBorder:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
        rightBorder:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 0)
        rightBorder:SetWidth(1)
        rightBorder:SetColorTexture(0.32, 0.26, 0.17, 0.95)

        local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        title:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -16)
        title:SetText("Logres Control / Diagnostics")

        local version = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        version:SetPoint("LEFT", title, "RIGHT", 10, 0)
        version:SetText(tostring(Logres.VERSION))

        local subtitle = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        subtitle:SetText("Developer validation surface; organized by roadmap phase.")

        local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)

        local tabHost = CreateFrame("Frame", nil, frame)
        tabHost:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -64)
        tabHost:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -18, -64)
        tabHost:SetHeight(TAB_HEIGHT)

        local phaseTitle = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        phaseTitle:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -98)

        local buttonHost = CreateFrame("Frame", nil, frame)
        buttonHost:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -124)
        buttonHost:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -18, -124)
        buttonHost:SetHeight(180)

        local emptyLabel = buttonHost:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        emptyLabel:SetPoint("TOPLEFT", buttonHost, "TOPLEFT", 2, -8)
        emptyLabel:SetText("No diagnostics registered for this phase yet.")
        emptyLabel:Hide()

        local resultsBackground = frame:CreateTexture(nil, "ARTWORK")
        resultsBackground:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -320)
        resultsBackground:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -18, 44)
        resultsBackground:SetColorTexture(0.015, 0.012, 0.01, 0.88)

        local results = CreateFrame("ScrollingMessageFrame", nil, frame)
        results:SetPoint("TOPLEFT", resultsBackground, "TOPLEFT", 8, -8)
        results:SetPoint("BOTTOMRIGHT", resultsBackground, "BOTTOMRIGHT", -8, 8)
        results:SetFontObject(GameFontHighlightSmall)
        results:SetJustifyH("LEFT")
        results:SetFading(false)
        results:SetMaxLines(120)
        results:SetInsertMode("BOTTOM")

        local clearButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        clearButton:SetSize(90, 22)
        clearButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -18, 12)
        clearButton:SetText("Clear")
        clearButton:SetScript("OnClick", function()
            results:Clear()
        end)

        local hint = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        hint:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 17)
        hint:SetText("Panel runs auto-save to LogresDiagnosticsDB on /reload/logout.")

        -- H.2 uses a dedicated panel subview instead of displacing one of the
        -- fifteen existing Phase H actions or requiring a slash-only workflow.
        local h2MapButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        h2MapButton:SetSize(100, 22)
        h2MapButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -264, -96)
        h2MapButton:SetText("H.2 Map")
        h2MapButton:SetScript("OnClick", function()
            self:SetH2MapMode(not self.h2MapMode)
        end)
        h2MapButton:Hide()

        local mapHost = CreateFrame("Frame", nil, frame)
        mapHost:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -124)
        mapHost:SetSize(PANEL_WIDTH - 36, 424)
        mapHost:EnableMouse(false)
        local canvas = CreateFrame("Frame", nil, mapHost)
        canvas:SetSize(552, 310.5) -- 16:9 miniature UIParent viewport
        canvas:SetPoint("TOP", mapHost, "TOP", 0, -4)
        canvas:EnableMouse(false)
        local canvasBG = canvas:CreateTexture(nil, "BACKGROUND")
        canvasBG:SetAllPoints(canvas)
        canvasBG:SetColorTexture(0.018, 0.022, 0.03, 0.97)
        -- Ten-percent grid helps estimate the viewport proportions in game.
        for index = 1, 9 do
            local vertical = canvas:CreateTexture(nil, "BORDER")
            vertical:SetColorTexture(0.24, 0.29, 0.35, 0.45)
            vertical:SetPoint("TOPLEFT", canvas, "TOPLEFT", 552 * index / 10, 0)
            vertical:SetSize(1, 310.5)
            local horizontal = canvas:CreateTexture(nil, "BORDER")
            horizontal:SetColorTexture(0.24, 0.29, 0.35, 0.45)
            horizontal:SetPoint("TOPLEFT", canvas, "TOPLEFT", 0, -310.5 * index / 10)
            horizontal:SetSize(552, 1)
        end
        local planned, measured = {}, {}
        for index = 1, 13 do
            planned[index] = createH2PanelBox(canvas, 0.30, 0.66, 1.0, 0.07, true)
            measured[index] = createH2PanelBox(canvas, 1.0, 0.72, 0.22, 0.025, false)
        end
        local legend = mapHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        legend:SetPoint("TOPLEFT", canvas, "BOTTOMLEFT", 0, -6)
        legend:SetText("BLUE approved v4 regions      GOLD actual Logres frame bounds")
        local info = mapHost:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        info:SetPoint("TOPLEFT", legend, "BOTTOMLEFT", 0, -4)
        info:SetText("Awaiting geometry measurements")
        local overlayInfo = mapHost:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        overlayInfo:SetPoint("TOPLEFT", info, "BOTTOMLEFT", 0, -4)
        overlayInfo:SetText("Overlay OFF · use Overlay ON, then close panel for screenshot")
        local mapControls = {
            { "Overlay ON", function() self:SetH2OverlayVisible(true) end },
            { "Overlay OFF", function() self:SetH2OverlayVisible(false) end },
            { "Refresh Map", function() self:RefreshH2Map() end },
            { "Layout Check", function()
                self:RunCommand("layoutcheck")
                self:RefreshH2Map()
                self.h2MapOverlayInfo:SetText("Layout Check saved; return to diagnostics for full lines")
            end },
        }
        for index = 1, #mapControls do
            local definition = mapControls[index]
            local button = CreateFrame("Button", nil, mapHost, "UIPanelButtonTemplate")
            button:SetSize(132, 23)
            button:SetPoint("BOTTOMLEFT", mapHost, "BOTTOMLEFT", (index - 1) * 144, 0)
            button:SetText(definition[1])
            button:SetScript("OnClick", definition[2])
        end
        mapHost:Hide()

        self.h2MapButton = h2MapButton
        self.h2MapHost = mapHost
        self.h2MapCanvas = canvas
        self.h2MapPlanned = planned
        self.h2MapMeasured = measured
        self.h2MapInfo = info
        self.h2MapOverlayInfo = overlayInfo
        self.resultsBackground = resultsBackground
        self.clearButton = clearButton
        self.hint = hint
        self.h2MapMode = false

        self.frame = frame
        self.tabHost = tabHost
        self.phaseTitle = phaseTitle
        self.buttonHost = buttonHost
        self.emptyLabel = emptyLabel
        self.results = results
        self.phaseTabs = {}
        self.actionButtons = {}
        self.activePhase = DEFAULT_PHASE
        self.previewPage = 1
        self:CreatePreviewPager(frame)
        -- M tab owns no Blizzard control; only an independent highlight overlay.
        self.mappingHideButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        self.mappingHideButton:SetSize(120, 22)
        self.mappingHideButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -264, -96)
        self.mappingHideButton:SetText("Hide Highlight")
        self.mappingHideButton:SetScript("OnClick", function()
            local ok, reason = Logres.MappingInspector.Hide()
            local run = self:BeginDiagnosticRun("mapping hide")
            self:AddResult("Logres mapping highlight: " .. (ok and "PASS" or "DEFERRED")
                .. " (" .. tostring(reason) .. ")", run)
        end)
        self.mappingHideButton:Hide()

        self:CreatePhaseTabs()
        self:SetActivePhase(DEFAULT_PHASE)

        if UISpecialFrames then
            UISpecialFrames[#UISpecialFrames + 1] = frame:GetName()
        end
    end,

    OnEnable = function(self)
        self.frame:Show()
        self:SetActivePhase(self.activePhase or DEFAULT_PHASE)
        self:RunCommand("status")
    end,

    OnDisable = function(self)
        self.frame:Hide()
    end,
})

function Panel:BeginDiagnosticRun(command)
    local db = ensureDiagnosticsDB()
    local run = {
        command = tostring(command),
        time = type(time) == "function" and time() or nil,
        lines = {},
    }

    db.runs[#db.runs + 1] = run

    while #db.runs > MAX_DIAGNOSTIC_RUNS do
        table.remove(db.runs, 1)
    end

    db.lastCommand = run.command
    db.lastTime = run.time
    return run
end

function Panel:AddResult(message, run)
    local text = tostring(message)
    self.results:AddMessage(text)

    if not run then
        return
    end

    run.lines[#run.lines + 1] = text

    while #run.lines > MAX_DIAGNOSTIC_LINES do
        table.remove(run.lines, 1)
    end
end

function Panel:RunCommand(command)
    local run = self:BeginDiagnosticRun(command)
    self:AddResult("> /logres " .. tostring(command), run)

    Logres:RunDevCommand(command, function(line)
        self:AddResult(line, run)
    end)
end

-- The preview collection intentionally lives in a single tab, but more than
-- 18 visual states require paging instead of offscreen, unreachable buttons.
function Panel:CreatePreviewPager(frame)
    self.previewPrevious = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    self.previewPrevious:SetSize(66, 22)
    self.previewPrevious:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -176, -94)
    self.previewPrevious:SetText("Previous")
    self.previewPrevious:SetScript("OnClick", function()
        self.previewPage = math.max(1, self.previewPage - 1)
        self:RefreshActionButtons()
    end)
    self.previewNext = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    self.previewNext:SetSize(66, 22)
    self.previewNext:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -94)
    self.previewNext:SetText("Next")
    self.previewNext:SetScript("OnClick", function()
        self.previewPage = self.previewPage + 1
        self:RefreshActionButtons()
    end)
    self.previewPageLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.previewPageLabel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -93, -98)
    self.previewPageLabel:SetWidth(74)
    self.previewPageLabel:SetJustifyH("CENTER")
    self.previewPrevious:Hide()
    self.previewNext:Hide()
    self.previewPageLabel:Hide()
end

function Panel:UpdatePreviewPager(total)
    local show = self.activePhase == "P" or self.activePhase == "H"
    show = show or self.activePhase == "M"
    self.previewPrevious:SetShown(show)
    self.previewNext:SetShown(show)
    self.previewPageLabel:SetShown(show)
    if not show then return end
    local pages = math.max(1, math.ceil(total / PREVIEW_PAGE_SIZE))
    self.previewPage = math.max(1, math.min(self.previewPage, pages))
    self.previewPageLabel:SetText(tostring(self.previewPage) .. " / " .. tostring(pages))
    self.previewPrevious:SetEnabled(self.previewPage > 1)
    self.previewNext:SetEnabled(self.previewPage < pages)
end

function Panel:CreatePhaseTabs()
    for index = 1, #PHASES do
        local definition = PHASES[index]
        local button = CreateFrame("Button", nil, self.tabHost, "UIPanelButtonTemplate")
        button:SetSize(TAB_WIDTH, TAB_HEIGHT)
        button:SetPoint(
            "TOPLEFT",
            self.tabHost,
            "TOPLEFT",
            (index - 1) * (TAB_WIDTH + TAB_GAP),
            0
        )
        button:SetText(definition.id)
        button:SetScript("OnClick", function()
            self:SetActivePhase(definition.id)
        end)
        self.phaseTabs[index] = {
            definition = definition,
            button = button,
        }
    end
end

function Panel:RefreshPhaseTabs()
    for index = 1, #self.phaseTabs do
        local tab = self.phaseTabs[index]
        if tab.definition.id == self.activePhase then
            tab.button:LockHighlight()
        else
            tab.button:UnlockHighlight()
        end
    end
end

function Panel:SetActivePhase(phase)
    if not PHASE_BY_ID[phase] then
        phase = DEFAULT_PHASE
    end

    if self.h2MapMode and phase ~= "H" then
        self:SetH2MapMode(false)
    end
    if (phase == "P" or phase == "H") and self.activePhase ~= phase then
        self.previewPage = 1
    end
    if phase == "M" and self.activePhase ~= "M" then
        self.previewPage = 1
    end
    self.activePhase = phase
    self.h2MapButton:SetShown(phase == "H")
    self.mappingHideButton:SetShown(phase == "M")
    self.phaseTitle:SetText(PHASE_BY_ID[phase].title)
    self:RefreshPhaseTabs()
    self:RefreshActionButtons()
end

-- P0279 M tab: independently paginated, read-only verification overlay.
function Panel:RunMappingSelection(entry)
    local run = self:BeginDiagnosticRun("mapping " .. entry.id)
    self:AddResult("Logres mapping: " .. entry.id .. " | service=" .. entry.service
        .. " role=" .. entry.role .. " | source=" .. entry.evidence
        .. " | " .. entry.state .. " | path=" .. (entry.nativePath or "UNMAPPED"), run)
    local ok, why = Logres.MappingInspector.Highlight(entry.id)
    self:AddResult("Logres mapping highlight: " .. (ok and "PASS" or "DEFERRED")
        .. " (" .. tostring(why) .. ")", run)
end

function Panel:RefreshMappingButtons()
    local entries = Logres.MappingInspector.Entries()
    self:UpdatePreviewPager(#entries)
    self.emptyLabel:SetShown(#entries == 0)
    local first = (self.previewPage - 1) * PREVIEW_PAGE_SIZE + 1
    local last = math.min(#entries, first + PREVIEW_PAGE_SIZE - 1)
    for index = first, last do
        local entry = entries[index]
        local button = CreateFrame("Button", nil, self.buttonHost, "UIPanelButtonTemplate")
        local offset = index - first
        button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
        button:SetPoint("TOPLEFT", self.buttonHost, "TOPLEFT",
            (offset % BUTTON_COLUMNS) * (BUTTON_WIDTH + BUTTON_GAP_X),
            -math.floor(offset / BUTTON_COLUMNS) * (BUTTON_HEIGHT + BUTTON_GAP_Y))
        button:SetText(entry.service .. ": " .. entry.label)
        button:SetScript("OnClick", function() self:RunMappingSelection(entry) end)
        self.actionButtons[#self.actionButtons + 1] = button
    end
end

function Panel:RefreshActionButtons()
    local actions = Logres:GetDevPanelActions()
    local visible = {}
    for index = 1, #actions do
        local action = actions[index]
        if action.phase == self.activePhase then
            visible[#visible + 1] = action
        end
    end

    for index = 1, #self.actionButtons do
        self.actionButtons[index]:Hide()
        self.actionButtons[index] = nil
    end

    if self.activePhase == "M" then
        self:RefreshMappingButtons()
        return
    end
    if self.activePhase == "P" then
        -- Stable alphabetical order keeps previews searchable across pages.
        table.sort(visible, function(a, b) return a.label < b.label end)
    end
    if self.activePhase == "H" then
        -- Explicit live trainer ON/OFF must remain visible on the first H page.
        -- Keep the rest of H in its original registration order.
        local leading, remainder = {}, {}
        for i = 1, #visible do
            local item = visible[i]
            if item.id == "nativeTrainerSkinOn" or item.id == "nativeTrainerSkinOff" then
                leading[#leading + 1] = item
            else
                remainder[#remainder + 1] = item
            end
        end
        visible = {}
        for i = 1, #leading do visible[#visible + 1] = leading[i] end
        for i = 1, #remainder do visible[#visible + 1] = remainder[i] end
    end
    if self.activePhase == "P" or self.activePhase == "H" then
        self:UpdatePreviewPager(#visible)
    else
        self:UpdatePreviewPager(0)
        if #visible > MAX_ACTIONS_PER_PHASE then
            self:AddResult(string.format(
                "Panel phase %s has %s actions; static contract allows %s.",
                tostring(self.activePhase), tostring(#visible),
                tostring(MAX_ACTIONS_PER_PHASE)
            ))
        end
    end

    self.emptyLabel:SetShown(#visible == 0)
    if #visible == 0 then return end
    local first = 1
    local last = #visible
    if self.activePhase == "P" or self.activePhase == "H" then
        local first = (self.previewPage - 1) * PREVIEW_PAGE_SIZE + 1
        local last = math.min(#visible, first + PREVIEW_PAGE_SIZE - 1)
        -- Keep both indices scoped to the same page, never draw beyond row 6.
        for index = first, last do
            local action = visible[index]
            local button = CreateFrame("Button", nil, self.buttonHost, "UIPanelButtonTemplate")
            local zeroIndex = index - first
            local column = zeroIndex % BUTTON_COLUMNS
            local row = math.floor(zeroIndex / BUTTON_COLUMNS)
            button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
            button:SetPoint("TOPLEFT", self.buttonHost, "TOPLEFT",
                column * (BUTTON_WIDTH + BUTTON_GAP_X),
                -(row * (BUTTON_HEIGHT + BUTTON_GAP_Y)))
            button:SetText(action.label)
            button:SetScript("OnClick", function()
                self:RunCommand(action.command)
            end)
            self.actionButtons[#self.actionButtons + 1] = button
        end
        return
    end
    for index = first, last do
        local action = visible[index]
        local button = CreateFrame("Button", nil, self.buttonHost, "UIPanelButtonTemplate")
        local zeroIndex = index - 1
        local column = zeroIndex % BUTTON_COLUMNS
        local row = math.floor(zeroIndex / BUTTON_COLUMNS)
        button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
        button:SetPoint("TOPLEFT", self.buttonHost, "TOPLEFT",
            column * (BUTTON_WIDTH + BUTTON_GAP_X),
            -(row * (BUTTON_HEIGHT + BUTTON_GAP_Y)))
        button:SetText(action.label)
        button:SetScript("OnClick", function()
            self:RunCommand(action.command)
        end)
        self.actionButtons[#self.actionButtons + 1] = button
    end
end

-- P0194 R3: dedicated H.2 panel screen-map view. This is a read-only
-- calibration aid; drawn box bounds do not resize any gameplay controls.
createH2PanelBox = function(canvas, r, g, b, alpha, labeled)
    local box = CreateFrame("Frame", nil, canvas)
    box:EnableMouse(false)
    local fill = box:CreateTexture(nil, "BACKGROUND")
    fill:SetAllPoints(box)
    fill:SetColorTexture(r, g, b, alpha)
    local function line(first, second, isHorizontal)
        local texture = box:CreateTexture(nil, "BORDER")
        texture:SetColorTexture(r, g, b, 0.95)
        texture:SetPoint(first, box, first, 0, 0)
        texture:SetPoint(second, box, second, 0, 0)
        if isHorizontal then texture:SetHeight(1) else texture:SetWidth(1) end
    end
    line("TOPLEFT", "TOPRIGHT", true)
    line("BOTTOMLEFT", "BOTTOMRIGHT", true)
    line("TOPLEFT", "BOTTOMLEFT", false)
    line("TOPRIGHT", "BOTTOMRIGHT", false)
    if labeled then
        local label = box:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        label:SetPoint("TOPLEFT", box, "TOPLEFT", 2, -1)
        label:SetJustifyH("LEFT")
        label:SetTextColor(r, g, b, 1)
        box.label = label
    end
    box:Hide()
    return box
end

local function putH2PanelBox(box, canvas, x, y, width, height, label)
    box:ClearAllPoints()
    box:SetPoint("TOPLEFT", canvas, "TOPLEFT",
        canvas:GetWidth() * x / 100, -canvas:GetHeight() * y / 100)
    box:SetSize(canvas:GetWidth() * width / 100,
        canvas:GetHeight() * height / 100)
    if box.label then box.label:SetText(label) end
    box:Show()
end

function Panel:RefreshH2Map()
    if not self.h2MapCanvas then return end
    local plan = Logres.Layout.GetH2ScreenMapPlan()
    -- The approved planning rectangles are static and always available. The
    -- actual boxes remain deferred whenever their secret-safe audit cannot run.
    local report = Logres.Layout.GetH2ScreenMapAudit()
    for index = 1, #plan do
        local entry = plan[index]
        putH2PanelBox(self.h2MapPlanned[index], self.h2MapCanvas,
            entry.x, entry.y, entry.w, entry.h, entry.id)
        local row = report.rows[index]
        if row and row.state == "MEASURED" then
            putH2PanelBox(self.h2MapMeasured[index], self.h2MapCanvas,
                row.x, row.y, row.w, row.h, nil)
        else
            self.h2MapMeasured[index]:Hide()
        end
    end
    self.h2MapInfo:SetText(string.format(
        "Actual: %d/%d measured | %d missing | %d deferred | %s",
        report.measured, report.total, report.missing, report.deferred,
        report.reason))
end

function Panel:SetH2MapMode(visible)
    self.h2MapMode = visible == true and self.activePhase == "H"
    local view = self.h2MapMode
    self.buttonHost:SetShown(not view)
    self.emptyLabel:SetShown(false)
    self.resultsBackground:SetShown(not view)
    self.results:SetShown(not view)
    self.clearButton:SetShown(not view)
    self.hint:SetShown(not view)
    self.h2MapHost:SetShown(view)
    self.h2MapButton:SetText(view and "Back to H" or "H.2 Map")
    if view then self:RefreshH2Map() end
end

function Panel:SetH2OverlayVisible(visible)
    local ok, reason = Logres.Layout.SetH2MapVisible(visible)
    self.h2MapOverlayInfo:SetText((ok and "Overlay: " or "Overlay deferred: ")
        .. tostring(reason))
    self:RefreshH2Map()
end

function Logres:ShowDevPanel()
    local panel = self:GetModule("DevPanel")
    self:InitializeModule("DevPanel")
    panel:SetActivePhase(panel.activePhase or DEFAULT_PHASE)
    panel.frame:Show()
end

function Logres:HideDevPanel()
    local panel = self:GetModule("DevPanel")
    self:InitializeModule("DevPanel")
    panel.frame:Hide()
end

function Logres:ToggleDevPanel()
    local panel = self:GetModule("DevPanel")
    self:InitializeModule("DevPanel")
    panel:SetActivePhase(panel.activePhase or DEFAULT_PHASE)

    if panel.frame:IsShown() then
        panel.frame:Hide()
    else
        panel.frame:Show()
    end
end
