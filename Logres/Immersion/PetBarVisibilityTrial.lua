local _, Logres = ...

-- P0209 R8: CORRECT direction. Logres pet buttons stay active; Blizzard's
-- PetActionBar AND PetFrame are suppressed via secure visibility drivers
-- only when the addon-owned controls/fallback are ready and Immersion is ON.
-- The two stock roots are NEVER reparented; no insecure combat Hide/Show.
-- PetFrame access can be explicitly restored with the PET STOCK dock.
local Trial = Logres:RegisterModule("PetBarVisibilityTrial", {autoEnable = true})
local NATIVE_HIDE = "hide" -- secure visibility state maintained in/out of combat
local NATIVE_SHOW = "show"

local function getProbe()
    local ok, probe = pcall(Logres.GetModule, Logres, "PetActionExecutionProbe")
    if ok then return probe end
    return nil
end

local function getNative()
    local ok, native = pcall(Logres.GetModule, Logres, "NativeSurfaceReplacement")
    if ok then return native end
    return nil
end

local function editModeActive()
    -- Blizzard_EditMode may not have been loaded yet. Its manager frame is
    -- created by EditModeManager.xml; without that frame, that Edit Mode
    -- cannot be active. Do not load Blizzard_EditMode just to check it.
    local manager = _G.EditModeManagerFrame
    if manager == nil then
        return false, "manager-not-loaded"
    end
    if type(manager.IsEditModeActive) ~= "function" then
        return nil, "manager-method-unavailable"
    end
    local ok, active = pcall(manager.IsEditModeActive, manager)
    if not ok then return nil, "manager-query-failed" end
    -- Client values can be secret-capable. Never branch on or type-check
    -- a returned state until ordinary status has been established.
    if type(issecretvalue) ~= "function" then
        return nil, "secret-check-unavailable"
    end
    local checked, secret = pcall(issecretvalue, active)
    if not checked or secret == true then
        return nil, "manager-query-restricted"
    end
    -- In Blizzard_EditMode/Shared/EditModeManager.lua, OnLoad does not set
    -- editModeActive. IsEditModeActive() returns that field unchanged; it is
    -- nil until EnterEditMode sets true or ExitEditMode sets false. This is
    -- an ordinary initial idle state, not invalid/missing capability.
    -- This branch is reached ONLY after the ordinary/nonsecret check above.
    if active == nil then
        return false, "manager-initial-idle"
    end
    if type(active) ~= "boolean" then
        return nil, "manager-state-invalid"
    end
    return active, active and "manager-active" or "manager-inactive"
end


-- There is NO exclusive native ownership: Logres secure pet buttons are the
-- primary accessible action controls while stock presentation is hidden.
function Trial:IsAcquired()
    return false
end

function Trial:Ready()
    if Logres:GetPreference("immersionEnabled") ~= true then
        return false, "immersion-off"
    end
    if InCombatLockdown() then return false, "combat-lockdown" end
    local editing, reason = editModeActive()
    self.lastEditModeGate = reason
    if editing ~= false then return false, "editmode-" .. tostring(reason) end
    if type(RegisterStateDriver) ~= "function"
        or type(UnregisterStateDriver) ~= "function" then
        return false, "native-secure-driver-absent"
    end
    if not _G.PetActionBar or not _G.PetFrame then
        return false, "native-pet-frames-unavailable"
    end
    local probe = getProbe()
    if not probe or not probe:IsEnabled() or not probe.configured
        or probe.armed ~= true or not probe.cluster
        or probe.petHasActionBar ~= true or probe.occupiedCount <= 0 then
        return false, "logres-secure-pet-actions-unavailable"
    end
    local native = getNative()
    if not native or not native:IsEnabled() or not native.petInteraction
        or not native.buttons or not native.buttons.pet then
        return false, "secure-pet-unit-or-stock-access-unavailable"
    end
    return true, "pet-controls-and-fallback-ready"
end

-- A constant secure visibility state continues to suppress Blizzard
-- presentation through combat. Do not use [combat] show; this was the
-- explicitly rejected R2 implementation. Never touch Logres visibility.
function Trial:Arm()
    if self.armed then return true end
    if InCombatLockdown() then
        self.pending = true
        self.lastReason = "combat-deferred-arm"
        return false
    end
    local ready, reason = self:Ready()
    if not ready then self.lastReason = reason return false end
    local bar, unit = _G.PetActionBar, _G.PetFrame
    -- Each registered surface is tracked individually so partial failure
    -- can always release whichever driver was installed.
    if not self.barDriver then
        if not pcall(RegisterStateDriver, bar, "visibility", NATIVE_HIDE) then
            self.failures = self.failures + 1
            self.lastError = "petbar-driver-arm-failed"
            return false
        end
        self.barDriver = true
    end
    if not self.unitDriver then
        if not pcall(RegisterStateDriver, unit, "visibility", NATIVE_HIDE) then
            self.failures = self.failures + 1
            self.lastError = "petframe-driver-arm-failed"
            self:Release("unit-driver-arm-failed")
            return false
        end
        self.unitDriver = true
    end
    self.armed = true
    self.pending = false
    self.activations = self.activations + 1
    self.lastError = nil
    self.lastReason = "secure-blizzard-pet-surfaces-suppressed-unverified"
    return true
end

-- UnregisterStateDriver alone can leave statehidden set. First request
-- the secure "show" state, then remove our driver, then invoke the original
-- Blizzard visibility predicate out of combat. We do not inspect native
-- protected presentation values, only own registration flags.
function Trial:Release(reason)
    if InCombatLockdown() then
        self.pending = true
        self.lastReason = "combat-deferred-stock-restore"
        return false
    end
    local failed = false
    if self.barDriver then
        local bar = _G.PetActionBar
        if not bar or not pcall(function()
            RegisterStateDriver(bar, "visibility", NATIVE_SHOW)
            UnregisterStateDriver(bar, "visibility")
        end) then
            failed = true
            self.lastError = "petbar-driver-release-failed"
        else
            self.barDriver = false
            -- Native event owner adjusts pet state; no forced Show.
            if type(bar.OnEvent) == "function" then
                pcall(bar.OnEvent, bar, "PET_BAR_UPDATE")
            end
        end
    end
    if self.unitDriver then
        local unit = _G.PetFrame
        if not unit or not pcall(function()
            RegisterStateDriver(unit, "visibility", NATIVE_SHOW)
            UnregisterStateDriver(unit, "visibility")
        end) then
            failed = true
            self.lastError = "petframe-driver-release-failed"
        else
            self.unitDriver = false
            if type(unit.UpdateShownState) == "function" then
                pcall(unit.UpdateShownState, unit)
            end
        end
    end
    if failed then
        self.pending = true
        self.failures = self.failures + 1
        self.lastReason = "stock-driver-release-failed"
        return false
    end
    if self.armed then self.restores = self.restores + 1 end
    self.armed = false
    self.pending = false
    self.lastError = nil
    self.lastReason = reason or "native-pet-surfaces-restored"
    return true
end

function Trial:Reconcile(reason)
    self.lastEvent = reason
    local want = Logres:GetPreference("immersionEnabled") == true
        and not self.manualOpen and not self.editModeSuspended
    if InCombatLockdown() then
        -- Secure driver owns the combat visibility transitions. Never
        -- attempt Lua protected mutations while locked down.
        if (want and not self.armed) or (not want and
            (self.barDriver or self.unitDriver)) then
            self.pending = true
            self.lastReason = "combat-deferred-policy-transition"
        end
        return
    end
    if not want then
        self:Release(reason or "immersion-off")
    elseif not self.armed then
        self:Arm()
    else
        local ready = self:Ready()
        if not ready then self:Release("capability-lost") end
    end
end

function Trial:Request(enabled)
    -- Existing Phase H ON/OFF remain emergency owner controls, not a
    -- double-click handoff. The Immersion preference is authoritative.
    if enabled then
        self.manualOpen = false
        self.editModeSuspended = false
        self:Reconcile("manual-hide-request")
        return self.armed, self.lastReason
    end
    self.manualOpen = true
    self:Reconcile("manual-stock-request")
    return not self.barDriver and not self.unitDriver, self.lastReason
end

function Trial:ToggleNativeAccess()
    if InCombatLockdown() then
        self.lastReason = "pet-stock-access-combat-deferred"
        return false
    end
    self.manualOpen = not self.manualOpen
    self:Reconcile("pet-stock-dock-toggle")
    return not self.pending
end

function Trial:GetDebugStatus()
    return {
        requested = not self.manualOpen and not self.editModeSuspended
            and Logres:GetPreference("immersionEnabled") == true,
        armed = self.armed, pending = self.pending,
        stockDriver = self.barDriver, logresDriver = false,
        petFrameDriver = self.unitDriver,
        activations = self.activations, restores = self.restores,
        failures = self.failures, reason = self.lastReason,
        event = self.lastEvent, error = self.lastError,
        visual = "USER-UNVERIFIED",
        mode = "immersive-stock-pet-suppression-logres-active",
        manualOpen = self.manualOpen,
        editModeGate = self.lastEditModeGate,
    }
end

function Trial:OnInitialize()
    self.armed = false
    self.barDriver = false
    self.unitDriver = false
    self.pending = false
    self.manualOpen = false
    self.editModeSuspended = false
    self.activations = 0
    self.restores = 0
    self.failures = 0
    self.lastReason = "startup-await-capabilities"
    self.lastEvent = "initialize"
    self.lastError = nil
    self.lastEditModeGate = "not-checked"
    self.eventFrame = CreateFrame("Frame")
    self.eventFrame:SetScript("OnEvent", function(_, event, unit)
        if event == "UNIT_PET" and unit ~= "player" then return end
        if not self:IsEnabled() and not self.pending then return end
        self:Reconcile(event)
    end)
end

function Trial:OnEnable()
    self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
    self.eventFrame:RegisterEvent("PET_BAR_UPDATE")
    self.eventFrame:RegisterEvent("PET_UI_UPDATE")
    self.eventFrame:RegisterUnitEvent("UNIT_PET", "player")
    self:OwnCleanup(function() self.eventFrame:UnregisterAllEvents() end)
    self:SubscribePreferences(function(preferences)
        if preferences.immersionEnabled ~= true then
            self.manualOpen = false
        elseif preferences.immersionEnabled == true then
            -- Explicit Immersion ON restores normal immersive preference.
            self.manualOpen = false
        end
        self:Reconcile("immersion-preference")
    end)
    if EventRegistry and type(EventRegistry.RegisterCallback) == "function" then
        EventRegistry:RegisterCallback("EditMode.Enter", function()
            self.editModeSuspended = true
            self:Reconcile("editmode-enter")
        end, self)
        EventRegistry:RegisterCallback("EditMode.Exit", function()
            self.editModeSuspended = false
            self:Reconcile("editmode-exit")
        end, self)
        self:OwnCleanup(function()
            if EventRegistry and type(EventRegistry.UnregisterCallback) == "function" then
                EventRegistry:UnregisterCallback("EditMode.Enter", self)
                EventRegistry:UnregisterCallback("EditMode.Exit", self)
            end
        end)
    end
    self:Reconcile("module-enable")
end

function Trial:OnDisable()
    self.manualOpen = true
    self:Release("module-disable")
end

-- Keep the final deferred release path even if module event cleanup occurs.
Logres:RegisterEvent("PLAYER_REGEN_ENABLED", function()
    if Trial.pending then Trial:Reconcile("deferred-regeneration") end
end)
