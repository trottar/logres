local _, Logres = ...

local PANEL_WIDTH = 540
local PANEL_HEIGHT = 590
local BUTTON_WIDTH = 154
local BUTTON_HEIGHT = 24
local BUTTON_GAP_X = 8
local BUTTON_GAP_Y = 6
local BUTTON_COLUMNS = 3

local MAX_DIAGNOSTIC_RUNS = 100
local MAX_DIAGNOSTIC_LINES = 120

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

        local title = frame:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormalLarge"
        )
        title:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -16)
        title:SetText("Logres Control / Diagnostics")

        local version = frame:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightSmall"
        )
        version:SetPoint("LEFT", title, "RIGHT", 10, 0)
        version:SetText(tostring(Logres.VERSION))

        local subtitle = frame:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightSmall"
        )
        subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
        subtitle:SetText(
            "Developer validation surface; independent of immersion visibility."
        )

        local closeButton = CreateFrame(
            "Button",
            nil,
            frame,
            "UIPanelCloseButton"
        )
        closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -3, -3)

        local buttonHost = CreateFrame("Frame", nil, frame)
        buttonHost:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -64)
        buttonHost:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -18, -64)
        buttonHost:SetHeight(270)

        local resultsBackground = frame:CreateTexture(nil, "ARTWORK")
        resultsBackground:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -348)
        resultsBackground:SetPoint(
            "BOTTOMRIGHT",
            frame,
            "BOTTOMRIGHT",
            -18,
            44
        )
        resultsBackground:SetColorTexture(0.015, 0.012, 0.01, 0.88)

        local results = CreateFrame(
            "ScrollingMessageFrame",
            nil,
            frame
        )
        results:SetPoint("TOPLEFT", resultsBackground, "TOPLEFT", 8, -8)
        results:SetPoint(
            "BOTTOMRIGHT",
            resultsBackground,
            "BOTTOMRIGHT",
            -8,
            8
        )
        results:SetFontObject(GameFontHighlightSmall)
        results:SetJustifyH("LEFT")
        results:SetFading(false)
        results:SetMaxLines(120)
        results:SetInsertMode("BOTTOM")

        local clearButton = CreateFrame(
            "Button",
            nil,
            frame,
            "UIPanelButtonTemplate"
        )
        clearButton:SetSize(90, 22)
        clearButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -18, 12)
        clearButton:SetText("Clear")
        clearButton:SetScript("OnClick", function()
            results:Clear()
        end)

        local hint = frame:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontDisableSmall"
        )
        hint:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 18, 17)
        hint:SetText(
            "Panel runs auto-save to LogresDiagnosticsDB on /reload/logout."
        )

        self.frame = frame
        self.buttonHost = buttonHost
        self.results = results
        self.actionButtons = {}
        self.renderedActionCount = 0

        self:RefreshActionButtons()

        if UISpecialFrames then
            UISpecialFrames[#UISpecialFrames + 1] = frame:GetName()
        end
    end,

    OnEnable = function(self)
        self.frame:Show()
        self:RefreshActionButtons()
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

    self:AddResult(
        "> /logres " .. tostring(command),
        run
    )

    Logres:RunDevCommand(command, function(line)
        self:AddResult(line, run)
    end)
end

function Panel:RefreshActionButtons()
    local actions = Logres:GetDevPanelActions()

    if self.renderedActionCount == #actions then
        return
    end

    for index = 1, #self.actionButtons do
        self.actionButtons[index]:Hide()
        self.actionButtons[index] = nil
    end

    for index = 1, #actions do
        local action = actions[index]
        local button = CreateFrame(
            "Button",
            nil,
            self.buttonHost,
            "UIPanelButtonTemplate"
        )

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

    self.renderedActionCount = #actions
end

function Logres:ShowDevPanel()
    local panel = self:GetModule("DevPanel")
    self:InitializeModule("DevPanel")

    panel:RefreshActionButtons()
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

    panel:RefreshActionButtons()

    if panel.frame:IsShown() then
        panel.frame:Hide()
    else
        panel.frame:Show()
    end
end
