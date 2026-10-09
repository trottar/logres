local _, Logres = ...

-- Each of these sources is Blizzard-owned. This module deliberately folds
-- whole frame roots (rather than alpha-only hiding clickable children).
-- A failed capture or mutation leaves the native surface usable.
local DOMAIN_ORDER = { "navigation", "objectives", "progress", "menu", "casts" }
local DOMAIN_FRAMES = {
    navigation = { "MinimapCluster" },
    objectives = { "ObjectiveTrackerFrame" },
    progress = { "StatusTrackingBarManager" },
    menu = { "MicroMenuContainer", "BagsBar" },
    casts = { "PlayerCastingBarFrame", "OverlayPlayerCastingBarFrame", "TargetFrameSpellBar" },
}
-- Objective Tracker can be updated/re-shown by the native quest/edit
-- lifecycle after our snapshot is created. Only these source-related events
-- are allowed to request a bounded re-fold; no polling or generic hooks.
local OBJECTIVE_REFRESH_EVENTS = {
    QUEST_LOG_UPDATE = true,
    QUEST_WATCH_LIST_CHANGED = true,
    SUPER_TRACKING_CHANGED = true,
    QUEST_ACCEPTED = true,
    QUEST_REMOVED = true,
    EDIT_MODE_LAYOUTS_UPDATED = true,
    ZONE_CHANGED_NEW_AREA = true,
}
local CAST_REFRESH_EVENTS = {
    UNIT_SPELLCAST_START = true,
    UNIT_SPELLCAST_CHANNEL_START = true,
}
local SOURCE_ADDONS = {
    Blizzard_Minimap = true,
    Blizzard_ObjectiveTracker = true,
    Blizzard_StatusTrackingBar = true,
    Blizzard_MicroMenu = true,
    Blizzard_MainMenuBarBagButtons = true,
    Blizzard_UIPanels_Game = true,
    Blizzard_UnitFrame = true,
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

-- Native cast-bar show policy is set OUT of combat. Blizzard's
-- CastingBarMixin:ShouldShowCastBar() consults showCastbar when a cast begins.
-- Preserve each native showCastbar value only as an opaque restoration token.
-- Do not inspect or compare that Blizzard-supplied value in addon Lua.
local function setNativeCastGate(snapshot, suppress)
    for index = 1, #snapshot do
        local item = snapshot[index]
        if suppress then
            item.frame:SetAndUpdateShowCastbar(false)
        else
            item.frame:SetAndUpdateShowCastbar(item.castShowToken)
        end
    end
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
        self.refoldAttempts = 0
        self.refoldFailures = 0
        self.lastRefoldEvent = nil
        self.hookedFrames = {}
        self.restoring = {}
        self.pendingRefolds = {}
        self.nativeShows = 0
        self.showRefolds = 0
        self.combatShowDeferrals = 0
        self.lastNativeShow = nil
        self.castGateArmed = false
        self.castGateAttempts = 0
        self.castGateRestores = 0
        self.castGateFailures = 0
        self.castGateEscapes = 0
        self.lastError = nil
        self.lastEvent = "initialize"
        self.desired = false
        self.pendingDisable = false

        local dock = CreateFrame("Frame", "LogresNativeAccessDock", UIParent)
        dock:SetSize(370, 26)
        dock:SetFrameStrata("HIGH")
        dock:EnableMouse(false)
        Logres.Layout.Bind(dock, "nativeAccess", "TOPRIGHT", "TOPRIGHT")
        self.dock = dock

        local labels = { "STOCK", "MAP", "QUESTS", "XP", "MENU", "CAST" }
        local widths = { 56, 48, 66, 42, 60, 52 }
        local keys = { "all", "navigation", "objectives", "progress", "menu", "casts" }
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
        for event in pairs(OBJECTIVE_REFRESH_EVENTS) do
            self.events:RegisterEvent(event)
        end
        -- Scope spellcast invalidation at registration; event unit payload
        -- is never read/compared by our callback.
        for event in pairs(CAST_REFRESH_EVENTS) do
            self.events:RegisterUnitEvent(event, "player", "target")
        end
        self:OwnCleanup(function()
            self.events:UnregisterAllEvents()
        end)
        self:InstallRefoldHooks()
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
        if key == "casts" and type(frame.SetAndUpdateShowCastbar) ~= "function" then
            return nil, "native cast gate unavailable " .. names[index]
        end
        local item = { frame = frame, shown = shown }
        if key == "casts" then
            -- Capture opaque Blizzard flag; do not inspect or compare it.
            item.castShowToken = frame.showCastbar
        end
        snapshot[#snapshot + 1] = item
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
    self.restoring[key] = true
    local ok, err = pcall(function()
        if key == "casts" then
            -- Native setter re-evaluates the live casting state; a stale
            -- pre-cast shown snapshot cannot safely determine restoration.
            setNativeCastGate(snapshot, false)
        else
            for index = 1, #snapshot do
                local item = snapshot[index]
                if item.shown then
                    item.frame:Show()
                else
                    item.frame:Hide()
                end
            end
        end
    end)
    self.restoring[key] = nil
    if not ok then
        self.failures = self.failures + 1
        self.lastError = "restore " .. key .. " failed: " .. tostring(err)
        self.lastReasons[key] = "restore-failed"
        return false
    end
    self.snapshots[key] = nil
    self.pendingRefolds[key] = nil
    if key == "casts" then
        self.castGateArmed = false
        self.castGateRestores = self.castGateRestores + 1
    end
    if key == "casts" and reason == "manual-open" then
        -- Re-evaluate native casting state after opening CAST in the
        -- middle of a spell. Do not force every idle bar visible.
        for _, item in ipairs(snapshot) do
            if type(item.frame.UpdateShownState) == "function" then
                pcall(item.frame.UpdateShownState, item.frame)
            end
        end
    end
    self.restoredCount = self.restoredCount + 1
    self.lastReasons[key] = reason or "restored"
    return true
end

-- A source-specific OnShow notification closes the timing gap between a
-- Blizzard Show() and the next quest/cast event. It never polls and does not
-- inspect protected native visible/alpha state.
function NativeAccess:InstallRefoldHooks()
    for _, key in ipairs({ "objectives", "casts" }) do
        for _, name in ipairs(DOMAIN_FRAMES[key]) do
            local frame = _G[name]
            if frame and not self.hookedFrames[frame] then
                if type(frame.HookScript) ~= "function" then
                    self.lastReasons[key] = "hook-unavailable"
                else
                    local hookKey = key
                    local hookName = name
                    local hookFrame = frame
                    self.hookedFrames[frame] = true
                    frame:HookScript("OnShow", function()
                        self.nativeShows = self.nativeShows + 1
                        self.lastNativeShow = hookName
                        if not self.desired
                            or self.manualOpen[hookKey]
                            or self.restoring[hookKey]
                            or not self.snapshots[hookKey]
                        then
                            return
                        end
                        if InCombatLockdown() then
                            if hookKey == "casts" and self.castGateArmed then
                                -- Persist the failure even after regen clears
                                -- pending flags; no false PASS after combat.
                                self.castGateEscapes = self.castGateEscapes + 1
                            end
                            self.pendingRefolds[hookKey] = true
                            self.combatShowDeferrals = self.combatShowDeferrals + 1
                            self.lastReasons[hookKey] = "onshow-combat-deferred"
                            return
                        end
                        -- The OnShow notification itself identifies the
                        -- exact native source; no protected readback needed.
                        local ok, err = pcall(hookFrame.Hide, hookFrame)
                        if ok then
                            self.showRefolds = self.showRefolds + 1
                            self.pendingRefolds[hookKey] = nil
                            self.lastReasons[hookKey] = "onshow-refold"
                        else
                            self.failures = self.failures + 1
                            self.refoldFailures = self.refoldFailures + 1
                            self.lastReasons[hookKey] = "onshow-refold-failed"
                            self.lastError = "onshow " .. hookName .. " failed: " .. tostring(err)
                        end
                    end)
                end
            end
        end
    end
end

function NativeAccess:Refold(key, reason)
    if not self.desired or self.manualOpen[key] or not self.snapshots[key] then
        return true
    end
    if InCombatLockdown() then
        self.pendingRefolds[key] = true
        self.lastReasons[key] = "combat-deferred-refold"
        return false
    end
    self.refoldAttempts = self.refoldAttempts + 1
    self.lastRefoldEvent = reason or "reconcile"
    -- Mutation-only reconciliation. Do not read secret-capable native
    -- visibility/alpha/click state just to prove that Blizzard re-showed it.
    local ok, err = pcall(function()
        if key == "casts" then
            -- Only reached outside lockdown; configure the native source.
            setNativeCastGate(self.snapshots[key], true)
        end
        for _, name in ipairs(DOMAIN_FRAMES[key]) do
            local frame = _G[name]
            if not frame then
                error("native source missing: " .. name)
            end
            frame:Hide()
        end
    end)
    if not ok then
        self.refoldFailures = self.refoldFailures + 1
        self.failures = self.failures + 1
        self.lastReasons[key] = "refold-failed"
        self.lastError = "refold " .. key .. " failed: " .. tostring(err)
        -- Keep restoration snapshot and on-demand access intact.
        return false
    end
    self.pendingRefolds[key] = nil
    self.lastReasons[key] = "folded"
    return true
end

function NativeAccess:Fold(key)
    if self.snapshots[key] then
        return self:Refold(key, "reconcile")
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
        if key == "casts" then
            self.castGateAttempts = self.castGateAttempts + 1
            setNativeCastGate(snapshot, true)
        end
        for index = 1, #snapshot do
            snapshot[index].frame:Hide()
        end
    end)
    if not ok then
        -- Attempt exact rollback after a partial Hide failure. Keep a
        -- restoration token armed if the emergency restore is rejected.
        local rollbackOK = pcall(function()
            if key == "casts" then
                setNativeCastGate(snapshot, false)
            end
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
        if key == "casts" then
            self.castGateArmed = false
            self.castGateFailures = self.castGateFailures + 1
        end
        self.failures = self.failures + 1
        self.lastReasons[key] = "fold-failed"
        self.lastError = "fold " .. key .. " failed: " .. tostring(err)
        return false
    end
    self.snapshots[key] = snapshot
    self.pendingRefolds[key] = nil
    if key == "casts" then
        self.castGateArmed = true
    end
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
    if OBJECTIVE_REFRESH_EVENTS[event] then
        self:Refold("objectives", event)
        return
    end
    if CAST_REFRESH_EVENTS[event] then
        self:Refold("casts", event)
        return
    end
    if event == "ADDON_LOADED" and not SOURCE_ADDONS[arg] then
        return
    end
    if event == "ADDON_LOADED" then
        self:InstallRefoldHooks()
    end
    -- This is event-gated (never polled), and never mutates protected stock
    -- presentation while combat lockdown is active.
    self:Reconcile(event)
end

function NativeAccess:GetDebugStatus()
    local pendingRefolds = 0
    for _, key in ipairs(DOMAIN_ORDER) do
        if self.pendingRefolds[key] then
            pendingRefolds = pendingRefolds + 1
        end
    end
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
        refoldAttempts = self.refoldAttempts,
        refoldFailures = self.refoldFailures,
        nativeShows = self.nativeShows,
        showRefolds = self.showRefolds,
        combatShowDeferrals = self.combatShowDeferrals,
        pendingRefolds = pendingRefolds,
        lastNativeShow = self.lastNativeShow,
        castGateArmed = self.castGateArmed,
        castGateExpected = self.desired and not self.manualOpen.casts,
        castGateAttempts = self.castGateAttempts,
        castGateRestores = self.castGateRestores,
        castGateFailures = self.castGateFailures,
        castGateEscapes = self.castGateEscapes,
        lastRefoldEvent = self.lastRefoldEvent,
        lastError = self.lastError,
        lastEvent = self.lastEvent,
        domains = table.concat(details, " "),
        mainAndPetStockRetained = true,
    }
end
