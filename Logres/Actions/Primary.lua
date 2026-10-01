local _, Logres = ...

local ActionButton = Logres.ActionButton

local BUTTON_COUNT = 12
local COLUMNS = 4
local ROWS = 3

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
        self.bindingRoutingEnabled = false
        self.bindingsApplied = false
        self.bindingKeyCounts = {}
        self.pendingPageRefresh = false
        self.pendingBindingRefresh = false

        for index = 1, BUTTON_COUNT do
            self.buttons[index] = ActionButton.Create(
                "LogresPrimaryActionButton" .. index,
                cluster,
                index,
                COLUMNS
            )
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

        self:ApplyActionPage()
        self:RefreshBindingLabels()
        self.cluster:Show()
        self:UpdateAll()
    end,

    OnDisable = function(self)
        -- PrimaryActions is not currently exposed as a combat-time toggle.
        -- Normal disable/cleanup is an out-of-combat development operation.
        if not InCombatLockdown() then
            self:ClearBindings()
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

function Primary:GetActionSlotForIndex(index)
    if not self.currentPage then
        return index
    end

    return ((self.currentPage - 1) * BUTTON_COUNT) + index
end

function Primary:UnregisterButtons()
    for index = 1, #self.buttons do
        ActionButton.Unregister(self.buttons[index])
    end

    self.registeredCount = 0
end

function Primary:ApplyActionPage()
    if InCombatLockdown() then
        self.pendingPageRefresh = true
        return false
    end

    local page = C_ActionBar.GetActionBarPage()

    if page < 1 then
        page = 1
    end

    self:UnregisterButtons()

    self.currentPage = page
    self.firstActionSlot = ((page - 1) * BUTTON_COUNT) + 1
    self.lastActionSlot = self.firstActionSlot + BUTTON_COUNT - 1

    for index = 1, #self.buttons do
        local actionSlot = self:GetActionSlotForIndex(index)

        ActionButton.Register(
            self.buttons[index],
            actionSlot
        )
        self.registeredCount = self.registeredCount + 1
    end

    self.pendingPageRefresh = false
    self:UpdateAll()
    return true
end

function Primary:RefreshBindingLabels()
    for index = 1, #self.buttons do
        local button = self.buttons[index]
        local command = "ACTIONBUTTON" .. index
        local keys = { GetBindingKey(command) }

        self.bindingKeyCounts[index] = #keys
        button.hotkeyText:SetText(keys[1] or "")
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
        if self.pendingPageRefresh then
            self:ApplyActionPage()
        end

        if self.pendingBindingRefresh then
            self:RefreshOverrideBindings()
        end

        return
    end

    if event == "ACTIONBAR_PAGE_CHANGED" then
        self:ApplyActionPage()
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

    return {
        moduleEnabled = self:IsEnabled(),
        clusterShown = self.cluster and self.cluster:IsShown() or false,
        buttonCount = self.buttons and #self.buttons or 0,
        registeredCount = self.registeredCount or 0,
        currentPage = self.currentPage,
        firstActionSlot = self.firstActionSlot,
        lastActionSlot = self.lastActionSlot,
        bindingRoutingEnabled = self.bindingRoutingEnabled == true,
        bindingsApplied = self.bindingsApplied == true,
        boundButtonCount = boundButtonCount,
        pendingPageRefresh = self.pendingPageRefresh == true,
        pendingBindingRefresh = self.pendingBindingRefresh == true,
        stockBarsSuppressed = false,
    }
end
