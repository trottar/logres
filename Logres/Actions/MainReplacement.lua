local _, Logres = ...

-- P0187: session-only, explicitly armed normal Main replacement candidate.
-- Native Main and all children stay Blizzard-owned; we do not overwrite
-- their alpha, mouse states, attributes, placement, or Show scripts.
-- The secure gate owns visibility via ancestry. Native special states open
-- the gate and route Logres Primary clicks to the real stock buttons.
local MODE_DRIVER =
    "[petbattle] special; [vehicleui] special;"
    .. " [overridebar] special; [possessbar] special;"
    .. " [bonusbar:1] special; [bonusbar:2] special;"
    .. " [bonusbar:3] special; [bonusbar:4] special;"
    .. " [bonusbar:5] special; [bonusbar:6] special;"
    .. " [form:1] special; [form:2] special;"
    .. " [form:3] special; [form:4] special;"
    .. " [form:5] special; [form:6] special;"
    .. " [form:7] special; [form:8] special;"
    .. " [form:9] special; [form:10] special; normal"

-- All operations here are secure-state operations. A normal->special
-- transition during combat MUST restore native Main access and convert
-- the *already bound* Primary secure buttons to stock click delegates.
local SECURE_MODE_SCRIPT = [[
    if newstate == "special" then
        self:Show()
        for i = 1, 12 do
            local primary = self:GetFrameRef("primary" .. i)
            local stock = self:GetFrameRef("stock" .. i)
            primary:SetAttribute("clickbutton", stock)
            primary:SetAttribute("type", "click")
        end
    else
        for i = 1, 12 do
            local primary = self:GetFrameRef("primary" .. i)
            primary:SetAttribute("type", "action")
            primary:SetAttribute("clickbutton", nil)
        end
        self:Hide()
    end
]]

local Main = Logres:RegisterModule("MainActionReplacement", {
    OnInitialize = function(self)
        self.gate = CreateFrame(
            "Frame", "LogresMainActionSecureGate", UIParent,
            "SecureHandlerStateTemplate"
        )
        self.gate:EnableMouse(false)
        self.gate:SetAttribute("_onstate-logresmode", SECURE_MODE_SCRIPT)
        self.sessionArmed = false
        self.appliedEnabled = false
        self.pending = false
        self.editActive = false
        self.originalParent = nil
        self.originalRouting = nil
        self.lastError = nil
        self.activations = 0
        self.restorations = 0
        self.nativeParentTransitions = 0
        self.eventFrame = CreateFrame("Frame")
        self.eventFrame:SetScript("OnEvent", function(_, event)
            self:HandleEvent(event)
        end)
    end,

    OnEnable = function(self)
        for _, event in ipairs({
            "PLAYER_REGEN_ENABLED", "PLAYER_ENTERING_WORLD",
        }) do
            self.eventFrame:RegisterEvent(event)
        end
        self:OwnCleanup(function()
            self.eventFrame:UnregisterAllEvents()
        end)
        -- Pinned native EditModeManager uses EventRegistry, not a WoW
        -- RegisterEvent("EDIT_MODE_ENTER") frame event.
        if EventRegistry and EventRegistry.RegisterCallback then
            EventRegistry:RegisterCallback("EditMode.Enter", function()
                self:HandleEvent("EditMode.Enter")
            end, self)
            EventRegistry:RegisterCallback("EditMode.Exit", function()
                self:HandleEvent("EditMode.Exit")
            end, self)
            self:OwnCleanup(function()
                EventRegistry:UnregisterCallback("EditMode.Enter", self)
                EventRegistry:UnregisterCallback("EditMode.Exit", self)
            end)
        end
        self:SubscribePreferences(function()
            self:Reconcile("preferences")
        end)
    end,

    OnDisable = function(self)
        self.sessionArmed = false
        local ok, result = self:Release()
        if not ok then
            Logres:DevPrint("Main replacement release deferred/failed: "
                .. tostring(result))
        end
    end,
})

local function ordinary(value, kind)
    if issecretvalue and issecretvalue(value) then
        return false
    end
    return type(value) == kind
end

local function sourceReady(primary)
    local source = primary:GetStockOwnershipGate()
    local debug = primary:GetDebugStatus()
    if source.flagsUnresolved ~= 0 or not source.normalMode
        or not source.sourcePresent or source.stockButtons ~= 12
        or not source.securePagingReady or debug.registeredCount ~= 12
        or debug.activationFeedbackReadyCount ~= 12
        or not debug.clusterShown
    then
        return false, "Primary/stock normal capability unavailable: "
            .. tostring(source.status)
    end
    local ok, selected = pcall(SecureCmdOptionParse, MODE_DRIVER)
    if not ok or not ordinary(selected, "string")
        or selected ~= "normal"
    then
        return false, "secure mode driver is not classified normal"
    end
    return true
end

function Main:Engage()
    if self.appliedEnabled then
        self.pending = false
        return true
    end
    if InCombatLockdown() then
        self.pending = true
        return false, "deferred-combat"
    end
    if self.editActive then
        self.pending = true
        return false, "deferred-edit-mode"
    end
    local primary = Logres:GetModule("PrimaryActions")
    local ready, reason = sourceReady(primary)
    if not ready then
        self.pending = false
        self.lastError = reason
        return false, reason
    end

    local stock = _G.MainActionBar
    local children = stock and stock.actionButtons
    if not stock or (issecretvalue and issecretvalue(children))
        or type(children) ~= "table" then
        self.lastError = "MainActionBar source unavailable"
        return false, self.lastError
    end
    for i = 1, 12 do
        if (issecretvalue and issecretvalue(children[i]))
            or not children[i] then
            self.lastError = "MainActionBar stock click delegate missing"
            return false, self.lastError
        end
    end
    local oldParent = stock:GetParent()
    if not oldParent or (issecretvalue and issecretvalue(oldParent)) then
        self.lastError = "native parent source unreadable"
        return false, self.lastError
    end
    local oldRouting = primary.bindingRoutingEnabled == true
    local routeOK, routeResult = pcall(
        primary.SetBindingRoutingEnabled, primary, true
    )
    if not routeOK or routeResult ~= true
        or primary.bindingsApplied ~= true
    then
        self.lastError = "Primary secure key override unavailable"
        if routeOK and not oldRouting then
            pcall(primary.SetBindingRoutingEnabled, primary, false)
        end
        return false, self.lastError
    end

    local engaged, failure = pcall(function()
        self.gate:SetFrameRef("nativeMain", stock)
        for i = 1, 12 do
            self.gate:SetFrameRef("stock" .. i, children[i])
            self.gate:SetFrameRef("primary" .. i, primary.buttons[i])
        end
        stock:SetParent(self.gate)
        -- An unregistered state driver retains its last state attribute.
        -- The same "normal" value on re-registration does not rerun
        -- _onstate-logresmode, leaving the gate visible after OFF -> ON.
        -- Reset only our own secure handler attribute, out of combat,
        -- before arming the driver; the native Main has no attribute edits.
        self.gate:SetAttribute("state-logresmode", nil)
        RegisterStateDriver(self.gate, "logresmode", MODE_DRIVER)
        -- The initial normal mode must immediately hide the native subtree.
        -- Do not read native alpha/IsShown; this is addon-owned gate state.
        local mode = self.gate:GetAttribute("state-logresmode")
        if not ordinary(mode, "string") or mode ~= "normal"
            or self.gate:IsShown() or stock:GetParent() ~= self.gate
        then
            error("secure normal mode gate not established")
        end
    end)
    if not engaged then
        -- All setup is out of combat; rollback before dropping key routing.
        pcall(UnregisterStateDriver, self.gate, "logresmode")
        pcall(stock.SetParent, stock, oldParent)
        pcall(self.gate.SetAttribute, self.gate, "state-logresmode", nil)
        pcall(self.gate.Show, self.gate)
        for i = 1, 12 do
            pcall(primary.buttons[i].SetAttribute, primary.buttons[i],
                "type", "action")
            pcall(primary.buttons[i].SetAttribute, primary.buttons[i],
                "clickbutton", nil)
        end
        if not oldRouting then
            pcall(primary.SetBindingRoutingEnabled, primary, false)
        end
        self.lastError = "secure Main engage failed: " .. tostring(failure)
        self.pending = false
        return false, self.lastError
    end

    self.originalParent = oldParent
    self.originalRouting = oldRouting
    self.appliedEnabled = true
    primary.mainReplacementActive = true
    self.activations = self.activations + 1
    self.pending = false
    self.lastError = nil
    return true
end

function Main:Release()
    if not self.appliedEnabled then
        self.pending = false
        -- OFF is a verified stock recovery; a previous failed ON must not
        -- remain reported as a current failure once explicitly disarmed.
        if not self.sessionArmed then
            self.lastError = nil
        end
        return true
    end
    if InCombatLockdown() then
        self.pending = true
        return false, "deferred-combat"
    end
    local primary = Logres:GetModule("PrimaryActions")
    local stock = _G.MainActionBar
    local oldParent = self.originalParent
    if not stock or not oldParent then
        self.lastError = "native Main restore source absent"
        return false, self.lastError
    end
    -- Restore Blizzard's actual native parent BEFORE removing replacement
    -- routing. If Blizzard already reparented Main during a special mode,
    -- leave its current parent alone rather than overwriting native control.
    local ok, err = pcall(function()
        if stock:GetParent() == self.gate then
            stock:SetParent(oldParent)
        else
            self.nativeParentTransitions = self.nativeParentTransitions + 1
        end
        UnregisterStateDriver(self.gate, "logresmode")
        -- Reset the inactive driver state while Blizzard Main is already
        -- back under its exact original parent. No native UI attribute read.
        self.gate:SetAttribute("state-logresmode", nil)
        self.gate:Show()
        for i = 1, 12 do
            local button = primary.buttons[i]
            button:SetAttribute("type", "action")
            button:SetAttribute("clickbutton", nil)
        end
    end)
    if not ok then
        self.lastError = "native Main restore failed: " .. tostring(err)
        self.pending = true
        return false, self.lastError
    end
    primary.mainReplacementActive = false
    local routeOK, routeResult = pcall(
        primary.SetBindingRoutingEnabled, primary,
        self.originalRouting == true
    )
    self.appliedEnabled = false
    self.originalParent = nil
    self.originalRouting = nil
    self.pending = false
    self.restorations = self.restorations + 1
    if not routeOK or routeResult ~= true then
        self.lastError = "native Main restored, prior binding routing failed"
        return false, self.lastError
    end
    self.lastError = nil
    return true
end

function Main:Reconcile(reason)
    local immersion = Logres:GetPreference("immersionEnabled") == true
    local desired = self.sessionArmed and immersion and not self.editActive
    if desired then
        if self.appliedEnabled then
            self.pending = false
            return true, "already-active"
        end
        return self:Engage()
    end
    return self:Release()
end

function Main:RequestSessionArmed(armed)
    self.sessionArmed = armed == true
    return self:Reconcile("manual")
end

function Main:HandleEvent(event)
    if event == "EditMode.Enter" then
        self.editActive = true
        if self.appliedEnabled then
            self:Release()
        end
        return
    end
    if event == "EditMode.Exit" then
        self.editActive = false
    end
    if event == "PLAYER_REGEN_ENABLED" and self.appliedEnabled then
        -- Blizzard may legitimately have reparented Main while the special
        -- secure driver was active. Recover only once at this lifecycle event.
        local stock = _G.MainActionBar
        if stock and stock:GetParent() ~= self.gate then
            self:Release()
        end
    end
    if self.sessionArmed or self.pending or self.appliedEnabled then
        self:Reconcile(event)
    end
end

function Main:GetDebugStatus()
    -- Intentionally do not inspect Blizzard protected presentation attributes,
    -- children, alpha, click flags or secret-capable state in diagnostics.
    return {
        moduleEnabled = self:IsEnabled(),
        sessionArmed = self.sessionArmed == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        editActive = self.editActive == true,
        secureDriverInstalled = self.appliedEnabled == true,
        nativeParentCaptured = self.originalParent ~= nil,
        routingManaged = self.appliedEnabled == true,
        activations = self.activations,
        restorations = self.restorations,
        nativeParentTransitions = self.nativeParentTransitions,
        lastError = self.lastError,
        specialModeProof = "environmentally-deferred",
    }
end

function Logres:GetMainReplacementDiagnosticLine()
    local d = self:GetModule("MainActionReplacement"):GetDebugStatus()
    local state = d.appliedEnabled and "CANDIDATE" or "STOCK"
    if d.lastError then state = "FAIL" end
    return string.format(
        "Logres mainreplacecheck: %s armed=%s applied=%s pending=%s driver=%s "
        .. "parentCaptured=%s route=%s edit=%s activations=%s "
        .. "restores=%s nativeReparents=%s special=%s error=%s",
        state, tostring(d.sessionArmed), tostring(d.appliedEnabled),
        tostring(d.pending), tostring(d.secureDriverInstalled),
        tostring(d.nativeParentCaptured), tostring(d.routingManaged),
        tostring(d.editActive), tostring(d.activations),
        tostring(d.restorations), tostring(d.nativeParentTransitions),
        d.specialModeProof, tostring(d.lastError)
    )
end
