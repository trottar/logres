local _, Logres = ...

-- Each of these sources is Blizzard-owned. This module deliberately folds
-- whole frame roots (rather than alpha-only hiding clickable children).
-- A failed capture or mutation leaves the native surface usable.
local DOMAIN_ORDER = { "navigation", "objectives", "progress", "menu" }
local DOMAIN_FRAMES = {
    navigation = { "MinimapCluster" },
    objectives = { "ObjectiveTrackerFrame" },
    progress = { "StatusTrackingBarManager" },
    menu = { "MicroMenuContainer", "BagsBar" },
}
local SOURCE_ADDONS = {
    Blizzard_Minimap = true,
    Blizzard_ObjectiveTracker = true,
    Blizzard_StatusTrackingBar = true,
    Blizzard_MicroMenu = true,
    Blizzard_MainMenuBarBagButtons = true,
}

local function ordinaryBool(value)
    if issecretvalue and issecretvalue(value) then
        return nil
    end
    if type(value) ~= "boolean" then
        return nil
    end
    return value
end

local NativeAccess = Logres:RegisterModule("NativeAccess", {
    OnInitialize = function(self)
        self.snapshots = {}
        self.manualOpen = {}
        self.lastReasons = {}
        self.attempts = 0
        self.foldedCount = 0
        self.restoredCount = 0
        self.failures = 0
        self.lastError = nil
        self.lastEvent = "initialize"
        self.desired = false
        self.pendingDisable = false

        local dock = CreateFrame("Frame", "LogresNativeAccessDock", UIParent)
        dock:SetSize(302, 26)
        dock:SetFrameStrata("HIGH")
        dock:EnableMouse(false)
        Logres.Layout.Bind(dock, "nativeAccess", "TOPRIGHT", "TOPRIGHT")
        self.dock = dock

        local labels = { "STOCK", "MAP", "QUESTS", "XP", "MENU" }
        local widths = { 56, 48, 66, 42, 60 }
        local keys = { "all", "navigation", "objectives", "progress", "menu" }
        local x = 0
        for index = 1, #labels do
            local key = keys[index]
            local button = CreateFrame("Button", nil, dock)
            button:SetSize(widths[index], 24)
            button:EnableMouse(true)
            button:SetPoint("TOPLEFT", dock, "TOPLEFT", x, 0)
            local background = button:CreateTexture(nil, "BACKGROUND")
            background:SetAllPoints(button)
            background:SetColorTexture(0.08, 0.07, 0.065, 0.83)
            local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            text:SetAllPoints(button)
            text:SetText(labels[index])
            button:RegisterForClicks("LeftButtonUp")
            button:SetScript("OnClick", function()
                self:Toggle(key)
            end)
            x = x + widths[index] + 5
        end
        dock:Hide()

        local events = CreateFrame("Frame")
        events:SetScript("OnEvent", function(_, event, arg)
            self:OnNativeEvent(event, arg)
        end)
        self.events = events
    end,

    OnEnable = function(self)
        self:SubscribePreferences(function()
            self:Reconcile("preference")
        end)
        self.events:RegisterEvent("PLAYER_ENTERING_WORLD")
        self.events:RegisterEvent("PLAYER_REGEN_ENABLED")
        self.events:RegisterEvent("ADDON_LOADED")
        self:OwnCleanup(function()
            self.events:UnregisterAllEvents()
        end)
        self:Reconcile("module-enable")
    end,

    OnDisable = function(self)
        self.desired = false
        if self:RestoreAll("module-disable") then
            self.dock:Hide()
        else
            -- The separately registered release event restores stock after
            -- lockdown even though module-owned events are cleaned up.
            self.pendingDisable = true
            self.dock:Show()
        end
    end,
})

-- Remains armed if the module is disabled during combat lockdown.
-- Never remove the only native-access control before restoration succeeds.
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if NativeAccess.pendingDisable then
        if NativeAccess:RestoreAll("deferred-disable") then
            NativeAccess.pendingDisable = false
            NativeAccess.dock:Hide()
        end
    end
end)

function NativeAccess:Capture(key)
    local names = DOMAIN_FRAMES[key]
    if not names then
        return nil, "unknown domain"
    end
    local snapshot = {}
    for index = 1, #names do
        local frame = _G[names[index]]
        if not frame then
            return nil, "missing " .. names[index]
        end
        local ok, shown = pcall(function()
            return frame:IsShown()
        end)
        if not ok then
            return nil, "unreadable " .. names[index]
        end
        shown = ordinaryBool(shown)
        if shown == nil then
            return nil, "unclassified " .. names[index]
        end
        snapshot[#snapshot + 1] = { frame = frame, shown = shown }
    end
    return snapshot
end

function NativeAccess:Restore(key, reason)
    local snapshot = self.snapshots[key]
    if not snapshot then
        self.lastReasons[key] = "stock-unmodified"
        return true
    end
    if InCombatLockdown() then
        self.lastReasons[key] = "combat-deferred"
        return false
    end
    local ok, err = pcall(function()
        for index = 1, #snapshot do
            local item = snapshot[index]
            if item.shown then
                item.frame:Show()
            else
                item.frame:Hide()
            end
        end
    end)
    if not ok then
        self.failures = self.failures + 1
        self.lastError = "restore " .. key .. " failed: " .. tostring(err)
        self.lastReasons[key] = "restore-failed"
        return false
    end
    self.snapshots[key] = nil
    self.restoredCount = self.restoredCount + 1
    self.lastReasons[key] = reason or "restored"
    return true
end

function NativeAccess:Fold(key)
    if self.snapshots[key] then
        return true
    end
    if InCombatLockdown() then
        self.lastReasons[key] = "combat-deferred"
        return false
    end
    self.attempts = self.attempts + 1
    local snapshot, captureError = self:Capture(key)
    if not snapshot then
        self.lastReasons[key] = captureError
        return false
    end
    local ok, err = pcall(function()
        for index = 1, #snapshot do
            snapshot[index].frame:Hide()
        end
    end)
    if not ok then
        -- Attempt exact rollback after a partial Hide failure. Keep a
        -- restoration token armed if the emergency restore is rejected.
        local rollbackOK = pcall(function()
            for index = 1, #snapshot do
                if snapshot[index].shown then
                    snapshot[index].frame:Show()
                else
                    snapshot[index].frame:Hide()
                end
            end
        end)
        if not rollbackOK then
            self.snapshots[key] = snapshot
        end
        self.failures = self.failures + 1
        self.lastReasons[key] = "fold-failed"
        self.lastError = "fold " .. key .. " failed: " .. tostring(err)
        return false
    end
    self.snapshots[key] = snapshot
    self.foldedCount = self.foldedCount + 1
    self.lastReasons[key] = "folded"
    return true
end

function NativeAccess:RestoreAll(reason)
    local result = true
    for _, key in ipairs(DOMAIN_ORDER) do
        if not self:Restore(key, reason) then
            result = false
        end
    end
    return result
end

function NativeAccess:Reconcile(reason)
    self.lastEvent = reason or "reconcile"
    self.desired = Logres:GetPreference("immersionEnabled") == true
    if not self.desired then
        if self:RestoreAll("immersion-off") then
            self.dock:Hide()
        else
            self.dock:Show()
        end
        return
    end
    self.dock:Show()
    for _, key in ipairs(DOMAIN_ORDER) do
        if self.manualOpen[key] then
            self:Restore(key, "manual-open")
        else
            self:Fold(key)
        end
    end
end

function NativeAccess:Toggle(key)
    if key == "all" then
        local everythingOpen = true
        for _, domain in ipairs(DOMAIN_ORDER) do
            if not self.manualOpen[domain] then
                everythingOpen = false
            end
        end
        for _, domain in ipairs(DOMAIN_ORDER) do
            self.manualOpen[domain] = not everythingOpen
        end
    elseif DOMAIN_FRAMES[key] then
        self.manualOpen[key] = not self.manualOpen[key]
    else
        return false, "unknown-domain"
    end
    self:Reconcile("manual-toggle")
    if InCombatLockdown() then
        return false, "deferred-combat"
    end
    return true, "updated"
end

function NativeAccess:OnNativeEvent(event, arg)
    if event == "ADDON_LOADED" and not SOURCE_ADDONS[arg] then
        return
    end
    -- This is event-gated (never polled), and never mutates protected stock
    -- presentation while combat lockdown is active.
    self:Reconcile(event)
end

function NativeAccess:GetDebugStatus()
    local folded = 0
    local open = 0
    local incomplete = 0
    local details = {}
    for _, key in ipairs(DOMAIN_ORDER) do
        local isFolded = self.snapshots[key] ~= nil
        local isOpen = self.manualOpen[key] == true
        if isFolded then folded = folded + 1 end
        if isOpen then open = open + 1 end
        if (self.desired and not isOpen and not isFolded)
            or (isOpen and isFolded)
        then
            incomplete = incomplete + 1
        end
        details[#details + 1] = key .. ":"
            .. (isFolded and "folded" or (isOpen and "open" or "native"))
            .. "/" .. tostring(self.lastReasons[key] or "none")
    end
    return {
        moduleEnabled = self:IsEnabled(),
        desired = self.desired,
        dockShown = self.dock:IsShown(),
        foldedDomains = folded,
        openDomains = open,
        incompleteDomains = incomplete,
        attempts = self.attempts,
        folds = self.foldedCount,
        restores = self.restoredCount,
        failures = self.failures,
        lastError = self.lastError,
        lastEvent = self.lastEvent,
        domains = table.concat(details, " "),
        mainAndPetStockRetained = true,
    }
end
