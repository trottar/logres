local _, Logres = ...

local PANEL_WIDTH = 620
local PANEL_HEIGHT = 590
local TAB_WIDTH = 56
local TAB_HEIGHT = 24
local TAB_GAP = 4
local BUTTON_WIDTH = 180
local BUTTON_HEIGHT = 24
local BUTTON_GAP_X = 8
local BUTTON_GAP_Y = 6
local BUTTON_COLUMNS = 3
local MAX_ACTIONS_PER_PHASE = BUTTON_COLUMNS * 4
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
        buttonHost:SetHeight(120)

        local emptyLabel = buttonHost:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        emptyLabel:SetPoint("TOPLEFT", buttonHost, "TOPLEFT", 2, -8)
        emptyLabel:SetText("No diagnostics registered for this phase yet.")
        emptyLabel:Hide()

        local resultsBackground = frame:CreateTexture(nil, "ARTWORK")
        resultsBackground:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -258)
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

        self.frame = frame
        self.tabHost = tabHost
        self.phaseTitle = phaseTitle
        self.buttonHost = buttonHost
        self.emptyLabel = emptyLabel
        self.results = results
        self.phaseTabs = {}
        self.actionButtons = {}
        self.activePhase = DEFAULT_PHASE

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

    self.activePhase = phase
    self.phaseTitle:SetText(PHASE_BY_ID[phase].title)
    self:RefreshPhaseTabs()
    self:RefreshActionButtons()
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

    if #visible == 0 then
        self.emptyLabel:Show()
    else
        self.emptyLabel:Hide()
    end

    if #visible > MAX_ACTIONS_PER_PHASE then
        self:AddResult(string.format(
            "Panel phase %s has %s actions; static contract allows %s.",
            tostring(self.activePhase),
            tostring(#visible),
            tostring(MAX_ACTIONS_PER_PHASE)
        ))
    end

    for index = 1, #visible do
        local action = visible[index]
        local button = CreateFrame("Button", nil, self.buttonHost, "UIPanelButtonTemplate")
        local zeroIndex = index - 1
        local column = zeroIndex % BUTTON_COLUMNS
        local row = math.floor(zeroIndex / BUTTON_COLUMNS)

        button:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
        button:SetPoint(
            "TOPLEFT",
            self.buttonHost,
            "TOPLEFT",
            column * (BUTTON_WIDTH + BUTTON_GAP_X),
            -(row * (BUTTON_HEIGHT + BUTTON_GAP_Y))
        )
        button:SetText(action.label)
        button:SetScript("OnClick", function()
            self:RunCommand(action.command)
        end)
        self.actionButtons[index] = button
    end
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
