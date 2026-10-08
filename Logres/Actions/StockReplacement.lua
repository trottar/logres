local _, Logres = ...

local STOCK_BARS = {
    secondary = {
        frameName = "MultiBarBottomLeft",
        buttonCount = 12,
    },
    utility = {
        frameName = "MultiBarBottomRight",
        buttonCount = 12,
    },
    bar4 = { frameName = "MultiBarRight", buttonCount = 12 },
    bar5 = { frameName = "MultiBarLeft", buttonCount = 12 },
}

local StockReplacement =
    Logres:RegisterModule("StockActionReplacement", {
        OnInitialize = function(self)
            self.requestedEnabled = false
            self.appliedEnabled = false
            self.pending = false
            self.snapshot = nil
            self.lastError = nil

            local eventFrame = CreateFrame("Frame")
            eventFrame:SetScript("OnEvent", function(_, event)
                self:HandleEvent(event)
            end)
            self.eventFrame = eventFrame
        end,

        OnEnable = function(self)
            self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")

            self:OwnCleanup(function()
                self.eventFrame:UnregisterAllEvents()
            end)
        end,

        OnDisable = function(self)
            if not self.appliedEnabled then
                return
            end

            if InCombatLockdown() then
                Logres:DevPrint(
                    "StockActionReplacement disabled during combat while "
                    .. "replacement was active; stock restoration was not "
                    .. "attempted."
                )
                return
            end

            self.requestedEnabled = false
            self:ApplyRequestedState()
        end,
    })

function StockReplacement:CaptureBar(key)
    local config = STOCK_BARS[key]
    local frame = _G[config.frameName]

    if not frame then
        return nil, "missing stock frame " .. config.frameName
    end

    if not frame.actionButtons then
        return nil, config.frameName .. " has no actionButtons table"
    end

    local snapshot = {
        key = key,
        frame = frame,
        frameName = config.frameName,
        alpha = frame:GetAlpha(),
        mouseEnabled = frame:IsMouseEnabled() == true,
        buttons = {},
    }

    for index = 1, config.buttonCount do
        local button = frame.actionButtons[index]

        if not button then
            return nil, string.format(
                "%s missing action button %s",
                config.frameName,
                tostring(index)
            )
        end

        snapshot.buttons[index] = {
            frame = button,
            mouseEnabled = button:IsMouseEnabled() == true,
        }
    end

    return snapshot
end

function StockReplacement:SuppressBar(snapshot)
    snapshot.frame:SetAlpha(0)
    snapshot.frame:EnableMouse(false)

    for index = 1, #snapshot.buttons do
        snapshot.buttons[index].frame:EnableMouse(false)
    end
end

function StockReplacement:RestoreBar(snapshot)
    snapshot.frame:SetAlpha(snapshot.alpha)
    snapshot.frame:EnableMouse(snapshot.mouseEnabled)

    for index = 1, #snapshot.buttons do
        local buttonSnapshot = snapshot.buttons[index]
        buttonSnapshot.frame:EnableMouse(buttonSnapshot.mouseEnabled)
    end
end

function StockReplacement:GetRoutingState()
    local actions = Logres:GetModule("SecondaryUtilityActions")

    return {
        secondary =
            actions:GetClusterDebugStatus("secondary")
                .bindingRoutingEnabled == true,
        utility =
            actions:GetClusterDebugStatus("utility")
                .bindingRoutingEnabled == true,
        bar4 = actions:GetClusterDebugStatus("bar4")
            .bindingRoutingEnabled == true,
        bar5 = actions:GetClusterDebugStatus("bar5")
            .bindingRoutingEnabled == true,
    }
end

function StockReplacement:RestoreRouting(routing)
    local actions = Logres:GetModule("SecondaryUtilityActions")

    local secondaryOK =
        actions:SetBindingRoutingEnabled(
            "secondary",
            routing.secondary
        )

    local utilityOK =
        actions:SetBindingRoutingEnabled(
            "utility",
            routing.utility
        )

    local bar4OK = actions:SetBindingRoutingEnabled("bar4", routing.bar4)
    local bar5OK = actions:SetBindingRoutingEnabled("bar5", routing.bar5)
    return secondaryOK and utilityOK and bar4OK and bar5OK
end

function StockReplacement:EnableReplacement()
    if self.appliedEnabled then
        self.pending = false
        self.lastError = nil
        return true
    end

    if InCombatLockdown() then
        self.pending = true
        return false
    end

    local secondarySnapshot, secondaryError =
        self:CaptureBar("secondary")

    if not secondarySnapshot then
        self.requestedEnabled = false
        self.lastError = secondaryError
        return false
    end

    local utilitySnapshot, utilityError =
        self:CaptureBar("utility")

    if not utilitySnapshot then
        self.requestedEnabled = false
        self.lastError = utilityError
        return false
    end

    local actions = Logres:GetModule("SecondaryUtilityActions")
    if not actions:RefreshExtraVisibility() then
        self.requestedEnabled = false
        self.lastError = "Bar 4/5 source configuration unreadable"
        return false
    end
    for _, key in ipairs({ "bar4", "bar5" }) do
        local state = actions:GetClusterDebugStatus(key)
        if not state.sourceVisibilityKnown
            or (state.sourceEnabled and not state.shown)
        then
            self.requestedEnabled = false
            self.lastError = "Bar " .. tostring(key)
                .. " source configuration unavailable or Logres cluster absent"
            return false
        end
    end

    local bar4Snapshot, bar4Error = self:CaptureBar("bar4")
    if not bar4Snapshot then
        self.requestedEnabled = false
        self.lastError = bar4Error
        return false
    end
    local bar5Snapshot, bar5Error = self:CaptureBar("bar5")
    if not bar5Snapshot then
        self.requestedEnabled = false
        self.lastError = bar5Error
        return false
    end

    local routing = self:GetRoutingState()
    local actions = Logres:GetModule("SecondaryUtilityActions")

    if not actions:SetBindingRoutingEnabled("secondary", true) then
        self.requestedEnabled = false
        self.lastError = "could not enable Secondary Logres routing"
        return false
    end

    if not actions:SetBindingRoutingEnabled("utility", true) then
        actions:SetBindingRoutingEnabled(
            "secondary",
            routing.secondary
        )
        self.requestedEnabled = false
        self.lastError = "could not enable Utility Logres routing"
        return false
    end

    if not actions:SetBindingRoutingEnabled("bar4", true) then
        self:RestoreRouting(routing)
        self.requestedEnabled = false
        self.lastError = "could not enable Bar 4 Logres routing"
        return false
    end
    if not actions:SetBindingRoutingEnabled("bar5", true) then
        self:RestoreRouting(routing)
        self.requestedEnabled = false
        self.lastError = "could not enable Bar 5 Logres routing"
        return false
    end

    local suppressed, suppressError = pcall(function()
        self:SuppressBar(secondarySnapshot)
        self:SuppressBar(utilitySnapshot)
        self:SuppressBar(bar4Snapshot)
        self:SuppressBar(bar5Snapshot)
    end)

    if not suppressed then
        pcall(function()
            self:RestoreBar(secondarySnapshot)
            self:RestoreBar(utilitySnapshot)
            self:RestoreBar(bar4Snapshot)
            self:RestoreBar(bar5Snapshot)
        end)

        self:RestoreRouting(routing)

        self.requestedEnabled = false
        self.lastError =
            "stock suppression failed: " .. tostring(suppressError)
        return false
    end

    self.snapshot = {
        secondary = secondarySnapshot,
        utility = utilitySnapshot,
        bar4 = bar4Snapshot,
        bar5 = bar5Snapshot,
        routing = routing,
    }

    self.appliedEnabled = true
    self.pending = false
    self.lastError = nil
    return true
end

function StockReplacement:DisableReplacement()
    if not self.appliedEnabled then
        self.requestedEnabled = false
        self.pending = false
        self.lastError = nil
        return true
    end

    if InCombatLockdown() then
        self.pending = true
        return false
    end

    local snapshot = self.snapshot

    if not snapshot then
        self.requestedEnabled = false
        self.appliedEnabled = false
        self.pending = false
        self.lastError =
            "replacement was active without a restoration snapshot"
        return false
    end

    local restored, restoreError = pcall(function()
        self:RestoreBar(snapshot.secondary)
        self:RestoreBar(snapshot.utility)
        self:RestoreBar(snapshot.bar4)
        self:RestoreBar(snapshot.bar5)
    end)

    if not restored then
        self.lastError =
            "stock restoration failed: " .. tostring(restoreError)
        return false
    end

    local routingRestored =
        self:RestoreRouting(snapshot.routing)

    self.appliedEnabled = false
    self.requestedEnabled = false
    self.pending = false
    self.snapshot = nil

    if not routingRestored then
        self.lastError =
            "stock bars restored but prior Logres routing did not restore"
        return false
    end

    self.lastError = nil
    return true
end

function StockReplacement:ApplyRequestedState()
    if self.requestedEnabled then
        return self:EnableReplacement()
    end

    return self:DisableReplacement()
end

function StockReplacement:RequestEnabled(enabled)
    self.requestedEnabled = enabled == true

    if InCombatLockdown() then
        self.pending = true
        return false, "deferred"
    end

    local applied = self:ApplyRequestedState()

    if applied then
        return true, "applied"
    end

    return false, "failed"
end

function StockReplacement:HandleEvent(event)
    if event == "PLAYER_REGEN_ENABLED" and self.pending then
        self:ApplyRequestedState()
    end
end

function StockReplacement:GetRecoveryStatus()
    return {
        moduleEnabled = self:IsEnabled(),
        requestedEnabled = self.requestedEnabled == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        snapshotReady = self.snapshot ~= nil,
        routingManaged = self.appliedEnabled == true,
        lastError = self.lastError,
    }
end

function StockReplacement:IsRoutingManaged(key)
    return self.appliedEnabled
        and (key == "secondary" or key == "utility"
            or key == "bar4" or key == "bar5")
end

function StockReplacement:IsApplied()
    return self.appliedEnabled == true
end

local function countMouseEnabledButtons(frame)
    if not frame or not frame.actionButtons then
        return nil
    end

    local count = 0

    for index = 1, 12 do
        local button = frame.actionButtons[index]

        if button and button:IsMouseEnabled() then
            count = count + 1
        end
    end

    return count
end

function StockReplacement:GetDebugStatus()
    local secondaryFrame = _G.MultiBarBottomLeft
    local utilityFrame = _G.MultiBarBottomRight
    local bar4Frame = _G.MultiBarRight
    local bar5Frame = _G.MultiBarLeft
    local actions = Logres:GetModule("SecondaryUtilityActions")
    local secondaryRouting =
        actions:GetClusterDebugStatus("secondary")
    local utilityRouting =
        actions:GetClusterDebugStatus("utility")
    local bar4Routing = actions:GetClusterDebugStatus("bar4")
    local bar5Routing = actions:GetClusterDebugStatus("bar5")

    return {
        moduleEnabled = self:IsEnabled(),
        requestedEnabled = self.requestedEnabled == true,
        appliedEnabled = self.appliedEnabled == true,
        pending = self.pending == true,
        lastError = self.lastError,
        snapshotReady = self.snapshot ~= nil,

        secondaryFrameFound = secondaryFrame ~= nil,
        utilityFrameFound = utilityFrame ~= nil,

        secondaryAlpha =
            secondaryFrame and secondaryFrame:GetAlpha() or nil,
        utilityAlpha =
            utilityFrame and utilityFrame:GetAlpha() or nil,

        secondaryFrameMouseEnabled =
            secondaryFrame
            and secondaryFrame:IsMouseEnabled() == true
            or false,
        utilityFrameMouseEnabled =
            utilityFrame
            and utilityFrame:IsMouseEnabled() == true
            or false,

        secondaryButtonMouseEnabledCount =
            countMouseEnabledButtons(secondaryFrame),
        utilityButtonMouseEnabledCount =
            countMouseEnabledButtons(utilityFrame),

        secondaryRoutingEnabled =
            secondaryRouting.bindingRoutingEnabled == true,
        secondaryBindingsApplied =
            secondaryRouting.bindingsApplied == true,
        utilityRoutingEnabled =
            utilityRouting.bindingRoutingEnabled == true,
        utilityBindingsApplied =
            utilityRouting.bindingsApplied == true,

        bar4FrameFound = bar4Frame ~= nil,
        bar5FrameFound = bar5Frame ~= nil,
        bar4Alpha = bar4Frame and bar4Frame:GetAlpha() or nil,
        bar5Alpha = bar5Frame and bar5Frame:GetAlpha() or nil,
        bar4FrameMouseEnabled = bar4Frame
            and bar4Frame:IsMouseEnabled() == true or false,
        bar5FrameMouseEnabled = bar5Frame
            and bar5Frame:IsMouseEnabled() == true or false,
        bar4ButtonMouseEnabledCount = countMouseEnabledButtons(bar4Frame),
        bar5ButtonMouseEnabledCount = countMouseEnabledButtons(bar5Frame),
        bar4RoutingEnabled = bar4Routing.bindingRoutingEnabled == true,
        bar4BindingsApplied = bar4Routing.bindingsApplied == true,
        bar5RoutingEnabled = bar5Routing.bindingRoutingEnabled == true,
        bar5BindingsApplied = bar5Routing.bindingsApplied == true,
        mainActionBarSuppressed = false,
        unsupportedBarsSuppressed = false,
    }
end
