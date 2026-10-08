local _, Logres = ...

local ActionButton = Logres.ActionButton

local BUTTON_COUNT = 12
local COLUMNS = 4
local ROWS = 3

local PRIMARY_PAGE_DRIVER =
    "[bar:2]2;"
    .. "[bar:3]3;"
    .. "[bar:4]4;"
    .. "[bar:5]5;"
    .. "[bar:6]6;"
    .. "1"

local ACTION_EVENTS = {
    "ACTIONBAR_SLOT_CHANGED",
    "ACTIONBAR_UPDATE_COOLDOWN",
    "ACTIONBAR_UPDATE_STATE",
    "ACTIONBAR_UPDATE_USABLE",
    "ACTION_USABLE_CHANGED",
    "ACTION_RANGE_CHECK_UPDATE",
    "ACTIONBAR_PAGE_CHANGED",
    "UPDATE_BINDINGS",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_ENTERING_WORLD",
}

local Primary = Logres:RegisterModule("PrimaryActions", {
    OnInitialize = function(self)
        local cluster = ActionButton.CreateCluster(
            "LogresPrimaryActionCluster",
            COLUMNS,
            ROWS,
            0,
            -260,
            1
        )
        Logres.Layout.Bind(cluster, "primaryActions", "CENTER", "CENTER")

        local bindingOwner = CreateFrame(
            "Frame",
            "LogresPrimaryActionBindingOwner",
            UIParent
        )

        self.cluster = cluster
        self.bindingOwner = bindingOwner
        self.buttons = {}
        self.currentPage = nil
        self.firstActionSlot = nil
        self.lastActionSlot = nil
        self.registeredCount = 0
        self.secureDriverRegisteredCount = 0
        self.securePagingReady = false
        self.bindingRoutingEnabled = false
        self.bindingsApplied = false
        self.bindingKeyCounts = {}
        self.pendingBindingRefresh = false

        for index = 1, BUTTON_COUNT do
            local button = ActionButton.Create(
                "LogresPrimaryActionButton" .. index,
                cluster,
                index,
                COLUMNS
            )

            -- A positive ID makes SecureActionButtonTemplate calculate the
            -- action from ID + actionpage rather than a concrete action attr.
            button:SetID(index)
            self.buttons[index] = button
        end

        local eventFrame = CreateFrame("Frame")
        eventFrame:SetScript("OnEvent", function(_, event, ...)
            self:HandleEvent(event, ...)
        end)

        self.eventFrame = eventFrame
    end,

    OnEnable = function(self)
        for index = 1, #ACTION_EVENTS do
            self.eventFrame:RegisterEvent(ACTION_EVENTS[index])
        end

        self:OwnCleanup(function()
            self.eventFrame:UnregisterAllEvents()
        end)

        self:RegisterSecurePaging()
        self:RefreshPresentationPage()
        self:RefreshBindingLabels()
        self.cluster:Show()
        self:UpdateAll()
    end,

    OnDisable = function(self)
        -- PrimaryActions is not currently exposed as a combat-time toggle.
        -- Normal disable/cleanup is an out-of-combat development operation.
        if not InCombatLockdown() then
            self:ClearBindings()
            self:UnregisterSecurePaging()
            self:UnregisterButtons()
            self.cluster:Hide()
        else
            Logres:DevPrint(
                "PrimaryActions disable requested during combat; "
                .. "protected cleanup was not attempted."
            )
        end
    end,
})

function Primary:RegisterSecurePaging()
    if InCombatLockdown() then
        return false
    end

    self.secureDriverRegisteredCount = 0

    for index = 1, #self.buttons do
        RegisterAttributeDriver(
            self.buttons[index],
            "actionpage",
            PRIMARY_PAGE_DRIVER
        )
        self.secureDriverRegisteredCount =
            self.secureDriverRegisteredCount + 1
    end

    self.securePagingReady =
        self.secureDriverRegisteredCount == BUTTON_COUNT
    return self.securePagingReady
end

function Primary:UnregisterSecurePaging()
    if InCombatLockdown() then
        return false
    end

    for index = 1, #self.buttons do
        UnregisterAttributeDriver(
            self.buttons[index],
            "actionpage"
        )
    end

    self.secureDriverRegisteredCount = 0
    self.securePagingReady = false
    return true
end

function Primary:GetDrivenPage()
    local page = tonumber(SecureCmdOptionParse(PRIMARY_PAGE_DRIVER))

    if page == nil or page < 1 then
        return 1
    end

    return page
end

function Primary:GetActionSlotForIndex(index)
    local page = self.currentPage or self:GetDrivenPage()
    return ((page - 1) * BUTTON_COUNT) + index
end

function Primary:UnregisterButtons()
    for index = 1, #self.buttons do
        ActionButton.Unregister(self.buttons[index])
    end

    self.registeredCount = 0
end

function Primary:RefreshPresentationPage()
    local page = self:GetDrivenPage()

    self.currentPage = page
    self.firstActionSlot = ((page - 1) * BUTTON_COUNT) + 1
    self.lastActionSlot = self.firstActionSlot + BUTTON_COUNT - 1
    self.registeredCount = 0

    for index = 1, #self.buttons do
        local actionSlot = self:GetActionSlotForIndex(index)

        -- This updates ordinary presentation/check/range registration only.
        -- Secure execution comes from button ID + driven actionpage.
        ActionButton.RegisterPresentation(
            self.buttons[index],
            actionSlot
        )
        self.registeredCount = self.registeredCount + 1
    end

    self:UpdateAll()
    return true
end

function Primary:RefreshBindingLabels()
    for index = 1, #self.buttons do
        local button = self.buttons[index]
        local command = "ACTIONBUTTON" .. index
        local keys = { GetBindingKey(command) }

        self.bindingKeyCounts[index] = #keys
        ActionButton.SetHotkeyLabel(button, keys[1] or "")
    end
end

function Primary:RefreshOverrideBindings()
    if InCombatLockdown() then
        self.pendingBindingRefresh = true
        return false
    end

    ClearOverrideBindings(self.bindingOwner)
    self.bindingsApplied = false

    if self.bindingRoutingEnabled then
        for index = 1, #self.buttons do
            local button = self.buttons[index]
            local command = "ACTIONBUTTON" .. index
            local keys = { GetBindingKey(command) }

            for keyIndex = 1, #keys do
                SetOverrideBindingClick(
                    self.bindingOwner,
                    false,
                    keys[keyIndex],
                    button:GetName(),
                    "LeftButton"
                )
            end
        end

        self.bindingsApplied = true
    end

    self.pendingBindingRefresh = false
    return true
end

function Primary:SetBindingRoutingEnabled(enabled)
    self.bindingRoutingEnabled = enabled == true
    self:RefreshBindingLabels()

    if InCombatLockdown() then
        self.pendingBindingRefresh = true
        return false
    end

    return self:RefreshOverrideBindings()
end

function Primary:ClearBindings()
    self.bindingRoutingEnabled = false
    return self:RefreshOverrideBindings()
end

function Primary:UpdateAll()
    ActionButton.UpdateAll(self.buttons)
end

function Primary:UpdateSlot(actionSlot)
    ActionButton.UpdateSlot(self.buttons, actionSlot)
end

function Primary:HandleEvent(event, ...)
    if event == "PLAYER_REGEN_ENABLED" then
        if self.pendingBindingRefresh then
            self:RefreshOverrideBindings()
        end

        return
    end

    if event == "ACTIONBAR_PAGE_CHANGED" then
        self:RefreshPresentationPage()
        return
    end

    if event == "UPDATE_BINDINGS" then
        self:RefreshBindingLabels()

        if self.bindingRoutingEnabled or self.bindingsApplied then
            self:RefreshOverrideBindings()
        end

        return
    end

    if event == "ACTIONBAR_SLOT_CHANGED" then
        local actionSlot = ...

        if actionSlot == 0 then
            self:UpdateAll()
        else
            self:UpdateSlot(actionSlot)
        end

        return
    end

    if event == "ACTION_RANGE_CHECK_UPDATE" then
        local actionSlot = ...
        self:UpdateSlot(actionSlot)
        return
    end

    self:UpdateAll()
end

function Primary:GetDebugStatus()
    local boundButtonCount = 0

    for index = 1, #self.buttons do
        if (self.bindingKeyCounts[index] or 0) > 0 then
            boundButtonCount = boundButtonCount + 1
        end
    end

    local securePage
    if self.buttons and self.buttons[1] then
        securePage = self.buttons[1]:GetAttribute("actionpage")
    end

    return {
        moduleEnabled = self:IsEnabled(),
        clusterShown = self.cluster and self.cluster:IsShown() or false,
        clusterAlpha = self.cluster and self.cluster:GetAlpha() or nil,
        buttonCount = self.buttons and #self.buttons or 0,
        registeredCount = self.registeredCount or 0,
        activationFeedbackReadyCount =
            ActionButton.CountFeedbackReady(self.buttons),
        currentPage = self.currentPage,
        securePage = securePage,
        firstActionSlot = self.firstActionSlot,
        lastActionSlot = self.lastActionSlot,
        securePagingReady = self.securePagingReady == true,
        secureDriverRegisteredCount =
            self.secureDriverRegisteredCount or 0,
        bindingRoutingEnabled = self.bindingRoutingEnabled == true,
        bindingsApplied = self.bindingsApplied == true,
        boundButtonCount = boundButtonCount,
        pendingBindingRefresh = self.pendingBindingRefresh == true,
        stockBarsSuppressed = false,
        specialPagingCoverage = "normal-pages-only",
    }
end

-- P0173: source-backed, read-only normal/secure-mode ownership gate.
-- This is NOT authorization to hide MainActionBar: a normal-mode read does not
-- establish combat-safe override/vehicle/possess transitions or editing.
local PRIMARY_SPECIAL_FLAGS = {
    "IsPossessBarVisible",
    "HasVehicleActionBar",
    "HasOverrideActionBar",
    "HasTempShapeshiftActionBar",
    "HasExtraActionBar",
}

local function primaryOrdinaryBoolean(value)
    if issecretvalue and issecretvalue(value) then
        return nil, "secret"
    end
    if type(value) ~= "boolean" then
        return nil, "not-ordinary-boolean"
    end
    return value, nil
end

function Primary:GetStockOwnershipGate()
    local special = false
    local unresolved = 0
    local details = {}
    for index = 1, #PRIMARY_SPECIAL_FLAGS do
        local name = PRIMARY_SPECIAL_FLAGS[index]
        local func = C_ActionBar and C_ActionBar[name]
        local state, reason
        if type(func) ~= "function" then
            reason = "api-unavailable"
        else
            local ok, result = pcall(func)
            if ok then
                state, reason = primaryOrdinaryBoolean(result)
            else
                reason = "api-failed"
            end
        end
        if state == nil then
            unresolved = unresolved + 1
        elseif state then
            special = true
        end
        details[#details + 1] = name .. ":"
            .. (state == nil and reason or tostring(state))
    end

    -- Read the stock object identity, not protected presentation attributes,
    -- alpha, Show state, or action data. Fixed 12-slot presence probe.
    local stock = _G.MainActionBar
    local slots = stock and stock.actionButtons
    if issecretvalue and issecretvalue(slots) then
        slots = nil
    end
    local rootReady = stock ~= nil and type(slots) == "table"
    local buttonCount = 0
    if rootReady then
        for index = 1, BUTTON_COUNT do
            local button = slots[index]
            if issecretvalue and issecretvalue(button) then
                break
            end
            if button == nil then
                break
            end
            buttonCount = buttonCount + 1
        end
    end
    local ordinaryMode = unresolved == 0 and not special
    local routingReady = self.bindingRoutingEnabled == true
        and self.bindingsApplied == true
        and self.pendingBindingRefresh == false
    local candidate = ordinaryMode
        and rootReady and buttonCount == BUTTON_COUNT
        and self.securePagingReady == true
        and self.registeredCount == BUTTON_COUNT
        and routingReady

    local reason
    if not rootReady or buttonCount ~= BUTTON_COUNT then
        reason = "stock-root-unavailable"
    elseif unresolved > 0 then
        reason = "mode-unclassified"
    elseif special then
        reason = "special-mode-stock-required"
    elseif not routingReady then
        reason = "normal-routing-not-active"
    elseif not self.securePagingReady then
        reason = "secure-paging-not-ready"
    else
        reason = "normal-mode-candidate-only"
    end
    return {
        sourcePresent = rootReady,
        stockButtons = buttonCount,
        flagsTotal = #PRIMARY_SPECIAL_FLAGS,
        flagsUnresolved = unresolved,
        specialActive = special,
        normalMode = ordinaryMode,
        routingReady = routingReady,
        securePagingReady = self.securePagingReady == true,
        candidateNormal = candidate,
        status = reason,
        flagDetails = table.concat(details, " "),
        stockSuppressionAuthorized = false,
        stockPreserved = true,
    }
end
