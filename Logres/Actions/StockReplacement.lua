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
            self.sourceDeferrals = 0
            self.retryCount = 0
            self.lastRetryEvent = nil
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
            self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
            self.eventFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")

            self:OwnCleanup(function()
                self.eventFrame:UnregisterAllEvents()
            end)
        end,

        OnDisable = function(self)
            if not self.appliedEnabled then
                self.requestedEnabled = false
                self.pending = false
                self.lastError = nil
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

    -- Combat already gates above. Do not carry a stale deferral into a
    -- hard failure or a successful application.
    self.pending = false

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
        -- Settings.GetValue can be unavailable at PLAYER_LOGIN.
        -- Preserve native bars, desired state, and retry only on
        -- Blizzard lifecycle events; no timer or polling.
        self.pending = true
        self.sourceDeferrals = self.sourceDeferrals + 1
        self.lastError = "awaiting-Bar-4/5-source-configuration"
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

    if self.pending and self.requestedEnabled then
        return false, "deferred"
    end
    return false, "failed"
end

function StockReplacement:HandleEvent(event)
    -- Retry only on lifecycle events; no periodic work.
    if self.pending and (event == "PLAYER_REGEN_ENABLED"
        or event == "PLAYER_ENTERING_WORLD"
        or event == "EDIT_MODE_LAYOUTS_UPDATED")
    then
        self.retryCount = self.retryCount + 1
        self.lastRetryEvent = event
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
        sourceDeferrals = self.sourceDeferrals,
        retryCount = self.retryCount,
        lastRetryEvent = self.lastRetryEvent,
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
        sourceDeferrals = self.sourceDeferrals,
        retryCount = self.retryCount,
        lastRetryEvent = self.lastRetryEvent,

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

function StockReplacement:RunDevStockReplacementCheck(emit, boolText)
    local status =
        Logres:GetModuleStatus("StockActionReplacement")
    local replacement =
        Logres:GetModule("StockActionReplacement")
    local debugStatus = replacement:GetDebugStatus()

    local expectedEnabled =
        Logres:GetPreference("immersionEnabled") == true
    local lifecycleConsistent =
        debugStatus.requestedEnabled == expectedEnabled
        and debugStatus.appliedEnabled == expectedEnabled
        and debugStatus.pending == false
        and debugStatus.lastError == nil
        and debugStatus.snapshotReady == expectedEnabled

    local appliedConsistent = true

    if debugStatus.appliedEnabled then
        appliedConsistent =
            debugStatus.snapshotReady == true
            and debugStatus.secondaryAlpha == 0
            and debugStatus.utilityAlpha == 0
            and debugStatus.secondaryFrameMouseEnabled == false
            and debugStatus.utilityFrameMouseEnabled == false
            and debugStatus.secondaryButtonMouseEnabledCount == 0
            and debugStatus.utilityButtonMouseEnabledCount == 0
            and debugStatus.secondaryRoutingEnabled == true
            and debugStatus.secondaryBindingsApplied == true
            and debugStatus.utilityRoutingEnabled == true
            and debugStatus.utilityBindingsApplied == true
            and debugStatus.bar4Alpha == 0
            and debugStatus.bar5Alpha == 0
            and debugStatus.bar4FrameMouseEnabled == false
            and debugStatus.bar5FrameMouseEnabled == false
            and debugStatus.bar4ButtonMouseEnabledCount == 0
            and debugStatus.bar5ButtonMouseEnabledCount == 0
            and debugStatus.bar4RoutingEnabled == true
            and debugStatus.bar4BindingsApplied == true
            and debugStatus.bar5RoutingEnabled == true
            and debugStatus.bar5BindingsApplied == true
    end

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.secondaryFrameFound == true
        and debugStatus.utilityFrameFound == true
        and debugStatus.bar4FrameFound == true
        and debugStatus.bar5FrameFound == true
        and debugStatus.mainActionBarSuppressed == false
        and debugStatus.unsupportedBarsSuppressed == false
        and lifecycleConsistent
        and appliedConsistent

    if passed then
        emit(string.format(
            "Logres stockreplacecheck: PASS (expected=%s requested=%s applied=%s pending=%s bar2Alpha=%s bar2Mouse=%s/%s bar3Alpha=%s bar3Mouse=%s/%s secondaryRouting=%s/%s utilityRouting=%s/%s error=%s)",
            boolText(expectedEnabled),
            boolText(debugStatus.requestedEnabled),
            boolText(debugStatus.appliedEnabled),
            boolText(debugStatus.pending),
            tostring(debugStatus.secondaryAlpha),
            boolText(debugStatus.secondaryFrameMouseEnabled),
            tostring(debugStatus.secondaryButtonMouseEnabledCount),
            tostring(debugStatus.utilityAlpha),
            boolText(debugStatus.utilityFrameMouseEnabled),
            tostring(debugStatus.utilityButtonMouseEnabledCount),
            boolText(debugStatus.secondaryRoutingEnabled),
            boolText(debugStatus.secondaryBindingsApplied),
            boolText(debugStatus.utilityRoutingEnabled),
            boolText(debugStatus.utilityBindingsApplied),
            tostring(debugStatus.lastError)
        ))
        emit(string.format(
            "Logres stockreplacecheck extras: bar4 alpha=%s mouse=%s/%s route=%s/%s bar5 alpha=%s mouse=%s/%s route=%s/%s",
            tostring(debugStatus.bar4Alpha),
            boolText(debugStatus.bar4FrameMouseEnabled),
            tostring(debugStatus.bar4ButtonMouseEnabledCount),
            boolText(debugStatus.bar4RoutingEnabled),
            boolText(debugStatus.bar4BindingsApplied),
            tostring(debugStatus.bar5Alpha),
            boolText(debugStatus.bar5FrameMouseEnabled),
            tostring(debugStatus.bar5ButtonMouseEnabledCount),
            boolText(debugStatus.bar5RoutingEnabled),
            boolText(debugStatus.bar5BindingsApplied)
        ))
        emit(string.format(
            "Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s",
            tostring(debugStatus.sourceDeferrals),
            tostring(debugStatus.retryCount),
            tostring(debugStatus.lastRetryEvent)
        ))
        return
    end

    emit(string.format(
        "Logres stockreplacecheck: FAIL (initialized=%s enabled=%s expected=%s requested=%s applied=%s pending=%s frames=%s/%s alphas=%s/%s frameMouse=%s/%s buttonMouse=%s/%s routing=%s/%s/%s/%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(expectedEnabled),
        tostring(debugStatus.requestedEnabled),
        tostring(debugStatus.appliedEnabled),
        tostring(debugStatus.pending),
        tostring(debugStatus.secondaryFrameFound),
        tostring(debugStatus.utilityFrameFound),
        tostring(debugStatus.secondaryAlpha),
        tostring(debugStatus.utilityAlpha),
        tostring(debugStatus.secondaryFrameMouseEnabled),
        tostring(debugStatus.utilityFrameMouseEnabled),
        tostring(debugStatus.secondaryButtonMouseEnabledCount),
        tostring(debugStatus.utilityButtonMouseEnabledCount),
        tostring(debugStatus.secondaryRoutingEnabled),
        tostring(debugStatus.secondaryBindingsApplied),
        tostring(debugStatus.utilityRoutingEnabled),
        tostring(debugStatus.utilityBindingsApplied),
        tostring(debugStatus.lastError)
    ))
    emit(string.format(
        "Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s",
        tostring(debugStatus.sourceDeferrals),
        tostring(debugStatus.retryCount),
        tostring(debugStatus.lastRetryEvent)
    ))
end
