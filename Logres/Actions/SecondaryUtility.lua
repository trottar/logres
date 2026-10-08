local _, Logres = ...

local ActionButton = Logres.ActionButton

local BUTTON_COUNT = 12
local COLUMNS = 3
local ROWS = 4

local ACTION_EVENTS = {
    "ACTIONBAR_SLOT_CHANGED",
    "ACTIONBAR_UPDATE_COOLDOWN",
    "ACTIONBAR_UPDATE_STATE",
    "ACTIONBAR_UPDATE_USABLE",
    "ACTION_USABLE_CHANGED",
    "ACTION_RANGE_CHECK_UPDATE",
    "UPDATE_BINDINGS",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_ENTERING_WORLD",
    "EDIT_MODE_LAYOUTS_UPDATED",
}

local EXTRA_KEYS = { "bar4", "bar5" }

-- Source configuration is the Blizzard-owned boolean setting, not secret-capable
-- stock presentation readback. Never branch on an unclassified value.
local function configuredExtraBar(setting)
    if not Settings or type(Settings.GetValue) ~= "function" then
        return nil
    end
    local ok, raw = pcall(Settings.GetValue, setting)
    if not ok or (issecretvalue and issecretvalue(raw)) then
        return nil
    end
    if type(raw) ~= "boolean" then
        return nil
    end
    return raw
end

local CLUSTER_CONFIG = {
    secondary = {
        frameName = "LogresSecondaryActionCluster",
        buttonPrefix = "LogresSecondaryActionButton",
        bindingOwnerName = "LogresSecondaryActionBindingOwner",
        bindingPrefix = "MULTIACTIONBAR1BUTTON",
        layoutKey = "secondaryActions",
        firstActionSlot = 61,
        lastActionSlot = 72,
        x = -190,
        y = -260,
        alpha = 0.88,
    },
    bar4 = {
        frameName = "LogresBar4ActionCluster",
        buttonPrefix = "LogresBar4ActionButton",
        bindingOwnerName = "LogresBar4ActionBindingOwner",
        bindingPrefix = "MULTIACTIONBAR3BUTTON",
        layoutKey = "bar4Actions",
        stockFrameName = "MultiBarRight",
        visibilitySetting = "PROXY_SHOW_ACTIONBAR_4",
        firstActionSlot = 25,
        lastActionSlot = 36,
        x = -460,
        y = -350,
        alpha = 0.88,
    },
    bar5 = {
        frameName = "LogresBar5ActionCluster",
        buttonPrefix = "LogresBar5ActionButton",
        bindingOwnerName = "LogresBar5ActionBindingOwner",
        bindingPrefix = "MULTIACTIONBAR4BUTTON",
        layoutKey = "bar5Actions",
        stockFrameName = "MultiBarLeft",
        visibilitySetting = "PROXY_SHOW_ACTIONBAR_5",
        firstActionSlot = 37,
        lastActionSlot = 48,
        x = 460,
        y = -350,
        alpha = 0.76,
    },
    utility = {
        frameName = "LogresUtilityActionCluster",
        buttonPrefix = "LogresUtilityActionButton",
        bindingOwnerName = "LogresUtilityActionBindingOwner",
        bindingPrefix = "MULTIACTIONBAR2BUTTON",
        layoutKey = "utilityActions",
        firstActionSlot = 49,
        lastActionSlot = 60,
        x = 190,
        y = -260,
        alpha = 0.76,
    },
}

local SecondaryUtility =
    Logres:RegisterModule("SecondaryUtilityActions", {
        OnInitialize = function(self)
            self.extraSourceVisibility = {}
            self.clusters = {
                secondary = self:CreateFixedCluster(
                    "secondary",
                    CLUSTER_CONFIG.secondary
                ),
                utility = self:CreateFixedCluster(
                    "utility",
                    CLUSTER_CONFIG.utility
                ),
                bar4 = self:CreateFixedCluster("bar4", CLUSTER_CONFIG.bar4),
                bar5 = self:CreateFixedCluster("bar5", CLUSTER_CONFIG.bar5),
            }

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

            self:RegisterCluster(self.clusters.secondary)
            self:RegisterCluster(self.clusters.utility)

            self:RefreshBindingLabels(self.clusters.secondary)
            self:RefreshBindingLabels(self.clusters.utility)

            self.clusters.secondary.frame:Show()
            self.clusters.utility.frame:Show()
            for _, key in ipairs(EXTRA_KEYS) do
                local cluster = self.clusters[key]
                self:RegisterCluster(cluster)
                self:RefreshBindingLabels(cluster)
            end
            self:RefreshExtraVisibility()
            self:UpdateAll()
        end,

        OnDisable = function(self)
            if not InCombatLockdown() then
                self:SetBindingRoutingEnabled("secondary", false)
                self:SetBindingRoutingEnabled("utility", false)

                self:UnregisterCluster(self.clusters.secondary)
                self:UnregisterCluster(self.clusters.utility)

                self.clusters.secondary.frame:Hide()
                self.clusters.utility.frame:Hide()
                for _, key in ipairs(EXTRA_KEYS) do
                    local cluster = self.clusters[key]
                    self:SetBindingRoutingEnabled(key, false)
                    self:UnregisterCluster(cluster)
                    cluster.frame:Hide()
                end
            else
                Logres:DevPrint(
                    "SecondaryUtilityActions disable requested during "
                    .. "combat; protected cleanup was not attempted."
                )
            end
        end,
    })

function SecondaryUtility:RefreshExtraVisibility()
    if InCombatLockdown() then
        return false
    end
    local ready = true
    for _, key in ipairs(EXTRA_KEYS) do
        local cluster = self.clusters[key]
        local sourceEnabled = configuredExtraBar(CLUSTER_CONFIG[key].visibilitySetting)
        if sourceEnabled ~= nil then
            self.extraSourceVisibility[key] = sourceEnabled
        else
            -- Keep the last known safe presentation; a transient nil
            -- must never hide Logres while stock is suppressed.
            ready = false
        end
        if self.extraSourceVisibility[key] == true then
            cluster.frame:Show()
        else
            cluster.frame:Hide()
        end
    end
    return ready
end

function SecondaryUtility:CreateFixedCluster(key, config)
    local frame = ActionButton.CreateCluster(
        config.frameName,
        COLUMNS,
        ROWS,
        config.x,
        config.y,
        config.alpha
    )
    Logres.Layout.Bind(frame, config.layoutKey, "CENTER", "CENTER")

    local bindingOwner = CreateFrame(
        "Frame",
        config.bindingOwnerName,
        UIParent
    )

    local cluster = {
        key = key,
        frame = frame,
        bindingOwner = bindingOwner,
        bindingPrefix = config.bindingPrefix,
        firstActionSlot = config.firstActionSlot,
        lastActionSlot = config.lastActionSlot,
        buttons = {},
        bindingKeyCounts = {},
        registeredCount = 0,
        bindingRoutingEnabled = false,
        bindingsApplied = false,
        pendingBindingRefresh = false,
    }

    for index = 1, BUTTON_COUNT do
        cluster.buttons[index] = ActionButton.Create(
            config.buttonPrefix .. index,
            frame,
            index,
            COLUMNS
        )
    end

    return cluster
end

function SecondaryUtility:RegisterCluster(cluster)
    if InCombatLockdown() then
        error(
            "SecondaryUtilityActions cannot register protected "
            .. "action slots during combat"
        )
    end

    self:UnregisterCluster(cluster)

    for index = 1, #cluster.buttons do
        local actionSlot = cluster.firstActionSlot + index - 1

        ActionButton.Register(
            cluster.buttons[index],
            actionSlot
        )
        cluster.registeredCount = cluster.registeredCount + 1
    end

    ActionButton.UpdateAll(cluster.buttons)
end

function SecondaryUtility:UnregisterCluster(cluster)
    for index = 1, #cluster.buttons do
        ActionButton.Unregister(cluster.buttons[index])
    end

    cluster.registeredCount = 0
end

function SecondaryUtility:RefreshBindingLabels(cluster)
    for index = 1, #cluster.buttons do
        local button = cluster.buttons[index]
        local command = cluster.bindingPrefix .. index
        local keys = { GetBindingKey(command) }

        cluster.bindingKeyCounts[index] = #keys
        ActionButton.SetHotkeyLabel(button, keys[1] or "")
    end
end

function SecondaryUtility:RefreshOverrideBindings(cluster)
    if InCombatLockdown() then
        cluster.pendingBindingRefresh = true
        return false
    end

    ClearOverrideBindings(cluster.bindingOwner)
    cluster.bindingsApplied = false

    if cluster.bindingRoutingEnabled then
        for index = 1, #cluster.buttons do
            local button = cluster.buttons[index]
            local command = cluster.bindingPrefix .. index
            local keys = { GetBindingKey(command) }

            for keyIndex = 1, #keys do
                SetOverrideBindingClick(
                    cluster.bindingOwner,
                    false,
                    keys[keyIndex],
                    button:GetName(),
                    "LeftButton"
                )
            end
        end

        cluster.bindingsApplied = true
    end

    cluster.pendingBindingRefresh = false
    return true
end

function SecondaryUtility:SetBindingRoutingEnabled(key, enabled)
    local cluster = self.clusters[key]

    if not cluster then
        error("Unknown action cluster: " .. tostring(key))
    end

    cluster.bindingRoutingEnabled = enabled == true
    self:RefreshBindingLabels(cluster)

    if InCombatLockdown() then
        cluster.pendingBindingRefresh = true
        return false
    end

    return self:RefreshOverrideBindings(cluster)
end

function SecondaryUtility:UpdateAll()
    ActionButton.UpdateAll(self.clusters.secondary.buttons)
    ActionButton.UpdateAll(self.clusters.utility.buttons)
    for _, key in ipairs(EXTRA_KEYS) do
        ActionButton.UpdateAll(self.clusters[key].buttons)
    end
end

function SecondaryUtility:UpdateSlot(actionSlot)
    if ActionButton.UpdateSlot(
        self.clusters.secondary.buttons,
        actionSlot
    ) then
        return
    end

    if ActionButton.UpdateSlot(self.clusters.utility.buttons, actionSlot) then
        return
    end
    for _, key in ipairs(EXTRA_KEYS) do
        if ActionButton.UpdateSlot(self.clusters[key].buttons, actionSlot) then
            return
        end
    end
end

function SecondaryUtility:HandleEvent(event, ...)
    if event == "EDIT_MODE_LAYOUTS_UPDATED"
        or event == "PLAYER_ENTERING_WORLD"
    then
        self:RefreshExtraVisibility()
        if event == "EDIT_MODE_LAYOUTS_UPDATED" then
            return
        end
    end
    if event == "PLAYER_REGEN_ENABLED" then
        for _, key in ipairs({ "secondary", "utility", "bar4", "bar5" }) do
            local cluster = self.clusters[key]

            if cluster.pendingBindingRefresh then
                self:RefreshOverrideBindings(cluster)
            end
        end

        return
    end

    if event == "UPDATE_BINDINGS" then
        for _, key in ipairs({ "secondary", "utility", "bar4", "bar5" }) do
            local cluster = self.clusters[key]

            self:RefreshBindingLabels(cluster)

            if cluster.bindingRoutingEnabled or cluster.bindingsApplied then
                self:RefreshOverrideBindings(cluster)
            end
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

function SecondaryUtility:GetClusterDebugStatus(key)
    local cluster = self.clusters[key]
    local boundButtonCount = 0

    for index = 1, #cluster.buttons do
        if (cluster.bindingKeyCounts[index] or 0) > 0 then
            boundButtonCount = boundButtonCount + 1
        end
    end

    return {
        shown = cluster.frame and cluster.frame:IsShown() or false,
        sourceEnabled = CLUSTER_CONFIG[key].stockFrameName == nil
            or self.extraSourceVisibility[key] == true,
        sourceVisibilityKnown = CLUSTER_CONFIG[key].stockFrameName == nil
            or self.extraSourceVisibility[key] ~= nil,
        buttonCount = cluster.buttons and #cluster.buttons or 0,
        registeredCount = cluster.registeredCount or 0,
        activationFeedbackReadyCount =
            ActionButton.CountFeedbackReady(cluster.buttons),
        firstActionSlot = cluster.firstActionSlot,
        lastActionSlot = cluster.lastActionSlot,
        bindingRoutingEnabled =
            cluster.bindingRoutingEnabled == true,
        bindingsApplied = cluster.bindingsApplied == true,
        boundButtonCount = boundButtonCount,
        pendingBindingRefresh =
            cluster.pendingBindingRefresh == true,
    }
end

function SecondaryUtility:GetDebugStatus()
    return {
        moduleEnabled = self:IsEnabled(),
        secondary = self:GetClusterDebugStatus("secondary"),
        utility = self:GetClusterDebugStatus("utility"),
        bar4 = self:GetClusterDebugStatus("bar4"),
        bar5 = self:GetClusterDebugStatus("bar5"),
        stockBarsSuppressed = false,
    }
end
