local _, Logres = ...

-- P0196 R1: only fold stock pet and aura surfaces after their corresponding
-- Logres information and interaction paths are established. These controls
-- are Blizzard-owned. No native aura payload is inspected by this module.
local Native = Logres:RegisterModule("NativeSurfaceReplacement", {autoEnable = true})

local ORDER = {"petFrame", "petActions", "playerBuffs", "targetAuras"}
local LABELS = {pet = "PET", playerBuffs = "BUFFS", targetAuras = "TARGET"}

local function secureReadiness(moduleName)
    local ok, module = pcall(Logres.GetModule, Logres, moduleName)
    if not ok or not module or not module:IsEnabled() then return nil end
    return module
end

local function getStock(key)
    if key == "petFrame" then return _G.PetFrame end
    if key == "petActions" then return _G.PetActionBar end
    if key == "playerBuffs" then return _G.BuffFrame end
    if key == "targetAuras" then
        local target = _G.TargetFrame
        local content = target and target.TargetFrameContent
        local contextual = content and content.TargetFrameContentContextual
        return contextual and contextual.Auras
    end
    return nil
end

-- P0196 R2: no generic native helpful-aura replacement. The existing
-- PlayerHelpfulAuras Logres artwork and its four-slot rendering contract
-- remain authoritative. Complete stock auras are accessible through BUFFS.

function Native:PreparePetInteraction()
    if self.petInteraction then return true end
    if InCombatLockdown() then return false end
    local hud = secureReadiness("HUD")
    local row = hud and hud.allyRowsByUnit and hud.allyRowsByUnit.pet
    if not row or not row.frame then return false end
    local ok, button = pcall(function()
        local frame = CreateFrame("Button", "LogresSecurePetUnitInteraction",
            row.frame, "SecureUnitButtonTemplate")
        frame:SetAllPoints(row.frame)
        frame:SetFrameStrata("HIGH")
        frame:RegisterForClicks("AnyUp")
        frame:SetAttribute("unit", "pet")
        frame:SetAttribute("*type1", "target")
        frame:SetAttribute("*type2", "togglemenu")
        frame:EnableMouse(true)
        frame:Show()
        return frame
    end)
    if not ok then
        self.lastError = "secure-pet-interaction-setup-failed"
        return false
    end
    self.petInteraction = button
    return true
end

function Native:Ready(key)
    if key == "petFrame" then
        local hud = secureReadiness("HUD")
        return hud and hud.allyRowsByUnit and hud.allyRowsByUnit.pet
            and self.petInteraction ~= nil
    end
    if key == "petActions" then
        local probe = secureReadiness("PetActionExecutionProbe")
        return probe and probe.armed == true and probe.configured == true
            and probe.cluster ~= nil and probe.cluster:IsShown()
            and probe.occupiedCount > 0
    end
    if key == "playerBuffs" then
        local helpful = secureReadiness("PlayerHelpfulAuras")
        -- Four crafted Logres slots are partial coverage. The BUFFS stock
        -- access control must be present before folding the native strip.
        return helpful and helpful.moduleEnabled == true
            and helpful.root ~= nil and helpful.slots ~= nil
            and self.buttons and self.buttons.playerBuffs ~= nil
    end
    if key == "targetAuras" then
        -- H.2: the Logres helpful lane and Blizzard-owned secure harmful
        -- replacement must both exist. This does not inspect aura membership.
        -- TARGET exposes the full stock surface on demand.
        local status = secureReadiness("StatusAuras")
        return status and status.moduleEnabled == true
            and status.nativeDebuffs ~= nil and status.nativeActive == true
            and status.lanes and status.lanes.targetHelpful ~= nil
            and self.buttons and self.buttons.targetAuras ~= nil
            and _G.TargetFrame ~= nil
            and type(_G.TargetFrame.ConfigureAuraContainer) == "function"
    end
    return false
end

function Native:RefreshNativeAuras()
    -- Retain the Logres authored helpful/status presentation. Do not create
    -- 18px generic icons or override PlayerHelpfulAuras / StatusAuras.
    self.nativeActive = false
    return false
end

-- Blizzard Forever 1.60.1.70338 TargetFrameMixin:ConfigureAuraContainer
-- uses `self.maxBuffs or defaults.MaxBuffs` (likewise maxDebuffs) and calls
-- auraContainer:Hide() itself when both are zero. This is the owner-supported
-- presentation path: no forbidden OnShow HookScript, no alpha-0 hit regions,
-- no aura payload queries and no repeated Hide() reassertion.
function Native:FoldTargetAuras()
    if self.snapshots.targetAuras then return true end
    if InCombatLockdown() then self.pending = true return false end
    if not self:Ready("targetAuras") then return false end
    local target = _G.TargetFrame
    local auraContainer = getStock("targetAuras")
    if not target or not auraContainer then return false end
    -- Capture native configuration only for direct restoration; never
    -- inspect or compare the captured values (even if secret-capable).
    local snapshot = {
        frame = auraContainer, target = target,
        maxBuffs = target.maxBuffs, maxDebuffs = target.maxDebuffs,
    }
    local ok = pcall(function()
        target.maxBuffs = 0
        target.maxDebuffs = 0
        target:ConfigureAuraContainer()
    end)
    if not ok then
        local restored = pcall(function()
            target.maxBuffs = snapshot.maxBuffs
            target.maxDebuffs = snapshot.maxDebuffs
            target:ConfigureAuraContainer()
        end)
        self.failures = self.failures + 1
        self.lastError = restored and "target-native-config-failed"
            or "target-native-config-and-restore-failed"
        return false
    end
    self.snapshots.targetAuras = snapshot
    self.folds = self.folds + 1
    return true
end

function Native:RestoreTargetAuras()
    local snapshot = self.snapshots.targetAuras
    if not snapshot then return true end
    if InCombatLockdown() then self.pending = true return false end
    -- Native source restores its own aura frame and interactions. Do not
    -- interpret the captured counts: pass directly back to Blizzard fields.
    local ok = pcall(function()
        snapshot.target.maxBuffs = snapshot.maxBuffs
        snapshot.target.maxDebuffs = snapshot.maxDebuffs
        snapshot.target:ConfigureAuraContainer()
    end)
    if not ok then
        self.failures = self.failures + 1
        self.lastError = "target-native-restore-failed"
        return false
    end
    self.snapshots.targetAuras = nil
    self.restores = self.restores + 1
    return true
end

function Native:Restore(key)
    if key == "targetAuras" then return self:RestoreTargetAuras() end
    local snapshot = self.snapshots[key]
    if not snapshot then
        if key == "petActions" then self.petActionDeferredRefold = false end
        return true
    end
    if InCombatLockdown() then self.pending = true return false end
    self.restoring[key] = true
    local ok = pcall(snapshot.frame.SetShown, snapshot.frame, snapshot.shown)
    self.restoring[key] = nil
    if not ok then
        self.failures = self.failures + 1
        self.lastError = "stock-restore-failed:" .. key
        return false
    end
    self.snapshots[key] = nil
    if key == "petActions" then self.petActionDeferredRefold = false end
    self.restores = self.restores + 1
    return true
end

function Native:Fold(key)
    if key == "targetAuras" then return self:FoldTargetAuras() end
    if self.snapshots[key] then return true end
    if InCombatLockdown() then self.pending = true return false end
    if not self:Ready(key) then return false end
    local frame = getStock(key)
    if not frame then return false end
    -- IsShown may return a protected token. Capture as an opaque restoration
    -- argument: never branch on, stringify, compare, or format the result.
    local captured, shown = pcall(frame.IsShown, frame)
    if not captured then return false end
    local snapshot = {frame = frame, shown = shown}
    local ok = pcall(frame.Hide, frame)
    if not ok then
        pcall(frame.SetShown, frame, shown)
        self.failures = self.failures + 1
        self.lastError = "stock-fold-failed:" .. key
        return false
    end
    self.snapshots[key] = snapshot
    self.folds = self.folds + 1
    if not self.hooked[frame] and type(frame.HookScript) == "function" then
        local hooked = pcall(frame.HookScript, frame, "OnShow", function()
            if not self.snapshots[key] or self.restoring[key]
                or not self.desired or self:ManualOpen(key) then return end
            if key == "petActions" then
                -- Logres-owned counts: only an OnShow callback was observed.
                -- Never query protected Blizzard visibility in diagnostics.
                self.petActionShowEvents = self.petActionShowEvents + 1
                self.petActionLastContext = self.lastEvent
            end
            if InCombatLockdown() then
                self.pending = true
                if key == "petActions" then
                    -- The existing post-combat Reconcile previously treated
                    -- its stale snapshot as already folded (no retry).
                    self.petActionDeferredRefold = true
                    self.petActionCombatDeferrals =
                        self.petActionCombatDeferrals + 1
                end
                return
            end
            -- Respond only to this specific Blizzard OnShow callback.
            local refolded = pcall(frame.Hide, frame)
            if refolded and key == "petActions" then
                self.petActionHookRefolds = self.petActionHookRefolds + 1
            end
            if not refolded then
                self.failures = self.failures + 1
                self.lastError = "onshow-refold-failed:" .. key
            end
        end)
        if hooked then
            self.hooked[frame] = true
        else
            self.lastError = "onshow-hook-unavailable:" .. key
            self:Restore(key)
            return false
        end
    end
    return true
end

function Native:ManualOpen(key)
    if key == "petFrame" or key == "petActions" then
        return self.manual.pet == true
    end
    return self.manual[key] == true
end

function Native:Reconcile(reason)
    self.lastEvent = reason
    self.desired = not self.forceDisabled
        and Logres:GetPreference("immersionEnabled") == true
    if InCombatLockdown() then self.pending = true return end
    self.pending = false
    if not self.desired then
        -- Restore stock before withdrawing its Logres replacement.
        for _, key in ipairs(ORDER) do self:Restore(key) end
        self:RefreshNativeAuras()
        self:UpdateButtons()
        return
    end
    self:PreparePetInteraction()
    self:RefreshNativeAuras()
    -- Restore any lost capability or user-open source before folding the rest.
    for _, key in ipairs(ORDER) do
        if self:ManualOpen(key) or not self:Ready(key) then
            self:Restore(key)
        elseif key == "petActions" and self.petActionDeferredRefold
            and self.snapshots.petActions then
            -- Only retry a refold known to have been deferred by OnShow
            -- during combat; never poll or inspect stock visibility.
            local stock = self.snapshots.petActions.frame
            local recovered = pcall(stock.Hide, stock)
            if recovered then
                self.petActionDeferredRefold = false
                self.petActionRecoveryRefolds =
                    self.petActionRecoveryRefolds + 1
            else
                self.failures = self.failures + 1
                self.lastError = "pet-action-deferred-refold-failed"
                -- Fail open to Blizzard stock rather than claiming ownership.
                self:Restore(key)
            end
        else
            self:Fold(key)
        end
    end
    self:UpdateButtons()
end

function Native:Toggle(domain)
    if domain ~= "pet" and domain ~= "playerBuffs"
        and domain ~= "targetAuras" then return false end
    self.manual[domain] = not self.manual[domain]
    self:Reconcile("native-toggle:" .. domain)
    return true
end

function Native:UpdateButtons()
    if not self.buttons then return end
    for key, button in pairs(self.buttons) do
        button:SetText(LABELS[key] .. (self.manual[key] and " OPEN" or ""))
    end
end

function Native:GetDebugStatus()
    local details = {}
    local folded = 0
    for _, key in ipairs(ORDER) do
        local active = self.snapshots[key] ~= nil
        if active then folded = folded + 1 end
        details[#details + 1] = key .. ":"
            .. (active and "folded" or (self:ManualOpen(key) and "open" or "stock"))
    end
    return {
        desired = self.desired,
        nativeActive = self.nativeActive,
        petInteractionReady = self.petInteraction ~= nil,
        folded = folded,
        folds = self.folds,
        restores = self.restores,
        failures = self.failures,
        pending = self.pending,
        details = table.concat(details, " "),
        lastError = self.lastError,
        lastEvent = self.lastEvent,
        petActionShowEvents = self.petActionShowEvents,
        petActionCombatDeferrals = self.petActionCombatDeferrals,
        petActionHookRefolds = self.petActionHookRefolds,
        petActionRecoveryRefolds = self.petActionRecoveryRefolds,
        petActionDeferredRefold = self.petActionDeferredRefold,
        petActionLastContext = self.petActionLastContext,
    }
end

function Native:OnInitialize()
    self.snapshots = {}
    self.restoring = {}
    self.hooked = {}
    self.manual = {}
    self.desired = false
    self.nativeActive = false
    self.petInteraction = nil
    self.pending = false
    self.pendingDisable = false
    self.forceDisabled = false
    self.folds = 0
    self.restores = 0
    self.failures = 0
    self.lastError = nil
    self.lastEvent = "initialize"
    -- Addon-owned observations from the already-hooked PetActionBar OnShow.
    self.petActionShowEvents = 0
    self.petActionCombatDeferrals = 0
    self.petActionHookRefolds = 0
    self.petActionRecoveryRefolds = 0
    self.petActionDeferredRefold = false
    self.petActionLastContext = "not-observed"
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:SetScript("OnEvent", function(_, event, unit)
        if event == "UNIT_PET" and unit ~= "player" then return end
        if not self:IsEnabled() and not self.pendingDisable then return end
        if event == "PLAYER_REGEN_ENABLED" and self.pendingDisable then
            self.desired = false
            self:Reconcile("deferred-disable")
            if next(self.snapshots) == nil then self.pendingDisable = false end
            return
        end
        self:Reconcile(event)
    end)
    local dock = _G.LogresNativeAccessDock
    if dock then
        self.buttons = {}
        local row = CreateFrame("Frame", nil, UIParent)
        row:SetSize(342, 23)
        row:SetFrameStrata("DIALOG")
        row:SetPoint("TOPLEFT", dock, "BOTTOMLEFT", 0, -5)
        self.nativeAccessRow = row
        row:SetShown(dock:IsShown())
        dock:HookScript("OnShow", function() row:Show() end)
        dock:HookScript("OnHide", function() row:Hide() end)
        local groups = {{"pet", 0}, {"playerBuffs", 116},
            {"targetAuras", 232}}
        for _, spec in ipairs(groups) do
            local key, x = spec[1], spec[2]
            local button = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            button:SetSize(110, 23)
            button:SetPoint("TOPLEFT", row, "TOPLEFT", x, 0)
            button:SetText(LABELS[key])
            button:RegisterForClicks("LeftButtonUp")
            button:SetScript("OnClick", function() self:Toggle(key) end)
            self.buttons[key] = button
        end
    end
end

function Native:OnEnable()
    self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.eventFrame:RegisterUnitEvent("UNIT_PET", "player")
    self.eventFrame:RegisterEvent("PET_BAR_UPDATE")
    self.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.eventFrame:RegisterUnitEvent("UNIT_AURA", "player", "target")
    self:OwnCleanup(function() self.eventFrame:UnregisterAllEvents() end)
    self:SubscribePreferences(function() self:Reconcile("preference") end)
    self:Reconcile("module-enable")
end

function Native:OnDisable()
    self.forceDisabled = true
    self.desired = false
    self:Reconcile("module-disable")
    if next(self.snapshots) ~= nil then
        self.pendingDisable = true
    end
end

-- Remains registered if module cleanup unregisters its event frame mid-combat.
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if Native.pendingDisable then
        Native:Reconcile("deferred-disable")
        if next(Native.snapshots) == nil then Native.pendingDisable = false end
    end
end)
