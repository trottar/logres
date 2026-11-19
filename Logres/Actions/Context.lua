local _, Logres = ...

local ALPHA_POLICY = {
    world = {
        primary = 0.00,
        secondary = 0.00,
        utility = 0.00,
    },
    pvp = {
        primary = 0.00,
        secondary = 0.00,
        utility = 0.00,
    },
    instance = {
        primary = 0.00,
        secondary = 0.00,
        utility = 0.00,
    },
    combat = {
        primary = 1.00,
        secondary = 0.85,
        utility = 0.75,
        bar4 = 1.00,
    },
}

local Context = Logres:RegisterModule("ActionContext", {
    OnInitialize = function(self)
        self.policyName = "world"
        self.primaryAlpha = 1
        self.secondaryAlpha = 0.00
        self.utilityAlpha = 0.00
        self.petAlpha = 0.00
        self.feedbackFramesUpdated = 0
        self.hovered = {}
        self.hoverHooksInstalled = false
        self.hoverHookCount = 0
        self.hoverEnterCount = 0
        self.hoverLeaveCount = 0
        self.hoverEffectsEnabled = false
        self.secureDriverReady = false
        self.secureDriverLastResult = "not-attempted"
        self.protectedRootSkips = 0
        self.pendingDisableReconcile = false
        self.disableEventFrame = CreateFrame("Frame")
        self.disableEventFrame:SetScript("OnEvent", function(_, event)
            if event == "PLAYER_REGEN_ENABLED"
                and self.pendingDisableReconcile == true
                and not (InCombatLockdown and InCombatLockdown())
            then
                self:FinishPendingDisable()
            end
        end)
    end,

    OnEnable = function(self)
        self.pendingDisableReconcile = false
        self.disableEventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
        self.hoverEffectsEnabled = true
        self:InstallHoverHooks()
        self:InstallCombatDriver()
        self:SubscribeState(function(current)
            self:ApplyState(current)
        end)

        self:ApplyState(Logres:GetState())
    end,

    OnDisable = function(self)
        -- Installed secure-button hover hooks remain, but cannot reapply
        -- dimming after the action context module is disabled.
        self.hoverEffectsEnabled = false
        self.hovered = {}
        -- Protected-state teardown is deferred if the module is disabled
        -- during combat. Keep the secure driver live until its safe release.
        if InCombatLockdown and InCombatLockdown() then
            self.pendingDisableReconcile = true
            self.disableEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        else
            self:FinishPendingDisable()
        end
    end,
})

function Context:FinishPendingDisable()
    if InCombatLockdown and InCombatLockdown() then
        return false
    end
    self.pendingDisableReconcile = false
    self.disableEventFrame:UnregisterEvent("PLAYER_REGEN_ENABLED")
    if self.secureDriverReady and self.combatDriver then
        UnregisterStateDriver(self.combatDriver, "logrescombat")
        self.secureDriverReady = false
    end
    -- Always leave action and pet controls usable when fading is disabled.
    self:ApplyPolicy("combat")
    return true
end

function Context:ResolvePolicyName(state)
    if state.combat then
        return "combat"
    end

    if state.pvpFlagged then
        return "pvp"
    end

    if state.context == "instance" then
        return "instance"
    end

    return "world"
end

-- A normal UNIT_AURA/PLAYER_REGEN callback is tainted Lua, so it must
-- not be responsible for restoring alpha on parents of secure action
-- buttons during combat. The preconfigured driver restores only combat
-- alpha in secure code; ordinary OOC state/hover owns all resting alpha.
-- Deliberately leave driver "rest" inert so it cannot overwrite a
-- still-hovered button when combat exit events arrive in either order.
local COMBAT_ALPHA_SNIPPET = [[
    if newstate == "combat" then
        local primary = self:GetFrameRef("primary")
        local secondary = self:GetFrameRef("secondary")
        local utility = self:GetFrameRef("utility")
        local bar4 = self:GetFrameRef("bar4")
        local bar5 = self:GetFrameRef("bar5")
        local pet = self:GetFrameRef("pet")
        if primary then primary:SetAlpha(1) end
        if secondary then secondary:SetAlpha(0.85) end
        if utility then utility:SetAlpha(0.75) end
        if bar4 then bar4:SetAlpha(1) end
        if bar5 then bar5:SetAlpha(0.75) end
        if pet then pet:SetAlpha(0.85) end
    end
]]

function Context:InstallCombatDriver()
    if self.secureDriverReady then
        return true
    end
    if (InCombatLockdown and InCombatLockdown())
        or type(RegisterStateDriver) ~= "function"
        or type(UnregisterStateDriver) ~= "function"
    then
        self.secureDriverLastResult = "unavailable-or-lockdown"
        return false
    end

    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local pet = Logres:GetModule("PetActionExecutionProbe")
    if not primary or not primary.cluster
        or not sides or not sides.clusters
        or not pet or not pet.cluster
    then
        self.secureDriverLastResult = "missing-owned-root"
        return false
    end

    local ok, err = pcall(function()
        local driver = self.combatDriver
        if not driver then
            driver = CreateFrame(
                "Frame", "LogresActionAlphaCombatDriver", UIParent,
                "SecureHandlerStateTemplate"
            )
            self.combatDriver = driver
        end
        driver:SetFrameRef("primary", primary.cluster)
        for _, source in ipairs({"secondary", "utility", "bar4", "bar5"}) do
            driver:SetFrameRef(source, sides.clusters[source].frame)
        end
        driver:SetFrameRef("pet", pet.cluster)
        driver:SetAttribute("_onstate-logrescombat", COMBAT_ALPHA_SNIPPET)
        RegisterStateDriver(driver, "logrescombat", "[combat] combat; rest")
    end)
    self.secureDriverReady = ok
    self.secureDriverLastResult = ok and "registered" or ("registration-failed:" .. tostring(err))
    return ok
end

-- Hover is captured exclusively from the existing addon-owned action
-- buttons. No transparent hit region is added above secure clicks, and
-- the native Blizzard bars are never sampled or mutated.
function Context:InstallHoverHooks()
    if self.hoverHooksInstalled then
        return true
    end
    -- HookScript on secure buttons is a setup operation, not combat work.
    -- Refuse rather than mutate script ownership during lockdown.
    if InCombatLockdown and InCombatLockdown() then
        return false
    end

    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local pet = Logres:GetModule("PetActionExecutionProbe")
    local sources = {
        { source = "primary", buttons = primary.buttons },
        { source = "secondary", buttons = sides.clusters.secondary.buttons },
        { source = "utility", buttons = sides.clusters.utility.buttons },
        { source = "bar4", buttons = sides.clusters.bar4.buttons },
        { source = "bar5", buttons = sides.clusters.bar5.buttons },
        { source = "pet", buttons = pet and pet.buttons or nil },
    }
    local count = 0
    for _, entry in ipairs(sources) do
        for _, button in ipairs(entry.buttons or {}) do
            local source = entry.source
            -- Existing tooltip/drag/click scripts remain authoritative.
            button:HookScript("OnEnter", function()
                self:SetHovered(source, true)
            end)
            button:HookScript("OnLeave", function()
                self:SetHovered(source, false)
            end)
            count = count + 1
        end
    end
    self.hoverHookCount = count
    self.hoverHooksInstalled = true
    return true
end

function Context:SetHovered(source, hovered)
    if self.hoverEffectsEnabled ~= true then
        return
    end
    hovered = hovered == true
    if self.hovered[source] == hovered then
        return
    end
    self.hovered[source] = hovered
    if hovered then
        self.hoverEnterCount = self.hoverEnterCount + 1
    else
        self.hoverLeaveCount = self.hoverLeaveCount + 1
    end
    -- Combat already uses the full combat policy. Do not repeatedly mutate
    -- secure-button ancestor alpha on every combat-time mouse transition.
    -- Button hit-testing and all secure bindings remain unchanged.
    if self.policyName ~= "combat" then
        self:ApplyPolicy(self.policyName)
    end
end

function Context:ResolvedAlpha(policyName, role, source)
    local policy = ALPHA_POLICY[policyName] or ALPHA_POLICY.world
    -- Bar 4 still inherits the secondary *rest* role, but keeps its
    -- separate full-bright combat/hover opacity.
    local alphaRole = source == "bar4" and "bar4" or role
    if policyName ~= "combat" and self.hoverEffectsEnabled == true
        and self.hovered[source] == true
    then
        return ALPHA_POLICY.combat[alphaRole]
    end
    return policy[alphaRole] or policy[role]
end

function Context:ApplyPolicy(policyName)
    -- An unsupported driver must never leave user input invisible.
    if self.secureDriverReady ~= true then
        policyName = "combat"
    end
    local locked = InCombatLockdown and InCombatLockdown()
    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local primaryAlpha = self:ResolvedAlpha(policyName, "primary", "primary")

    if not locked then
        primary.cluster:SetAlpha(primaryAlpha)
    else
        self.protectedRootSkips = self.protectedRootSkips + 1
    end
    local feedbackUpdated = 0
    -- Primary feedback plates are unprotected UIParent siblings and
    -- must follow their action role even while root alpha is secure-owned.
    for _, button in ipairs(primary.buttons or {}) do
        local feedback = button.activationFeedbackFrame
        if feedback then
            feedback:SetAlpha(primaryAlpha)
            feedbackUpdated = feedbackUpdated + 1
        end
    end

    local roleAlpha = {}
    for _, source in ipairs({"secondary", "utility", "bar4", "bar5"}) do
        local role = Logres.Layout.GetActionBarSpec(source).role
        local alpha = self:ResolvedAlpha(policyName, role, source)
        -- Presentation only: preserve secure button attributes and clicks.
        if not locked then
            sides.clusters[source].frame:SetAlpha(alpha)
        else
            self.protectedRootSkips = self.protectedRootSkips + 1
        end
        -- Feedback/keybind siblings live under UIParent, not clusters.
        for _, button in ipairs(sides.clusters[source].buttons) do
            local feedback = button.activationFeedbackFrame
            if feedback then
                feedback:SetAlpha(alpha)
                feedbackUpdated = feedbackUpdated + 1
            end
        end
        roleAlpha[source] = alpha
    end

    local petAlpha = self:ResolvedAlpha(policyName, "secondary", "pet")
    local pet = Logres:GetModule("PetActionExecutionProbe")
    if pet and type(pet.ApplyContextOpacity) == "function" then
        pet:ApplyContextOpacity(petAlpha, locked == true)
    end

    self.feedbackFramesUpdated = feedbackUpdated
    self.petAlpha = petAlpha
    self.policyName = policyName
    self.primaryAlpha = primaryAlpha
    self.secondaryAlpha = roleAlpha.secondary
    self.utilityAlpha = roleAlpha.utility
    self.bar4Alpha = roleAlpha.bar4
    self.bar5Alpha = roleAlpha.bar5
end

function Context:ApplyState(state)
    if self.hoverHooksInstalled ~= true then
        self:InstallHoverHooks()
    end
    if self.secureDriverReady ~= true then
        self:InstallCombatDriver()
    end
    self:ApplyPolicy(self:ResolvePolicyName(state))
end

function Context:GetDebugStatus()
    return {
        moduleEnabled = self:IsEnabled(),
        policyName = self.policyName,
        primaryAlpha = self.primaryAlpha,
        secondaryAlpha = self.secondaryAlpha,
        utilityAlpha = self.utilityAlpha,
        petAlpha = self.petAlpha,
        bar4Alpha = self.bar4Alpha,
        bar5Alpha = self.bar5Alpha,
        hoveredPrimary = self.hovered.primary == true,
        hoveredSecondary = self.hovered.secondary == true,
        hoveredUtility = self.hovered.utility == true,
        hoveredBar4 = self.hovered.bar4 == true,
        hoveredBar5 = self.hovered.bar5 == true,
        hoveredPet = self.hovered.pet == true,
        hoverHooksInstalled = self.hoverHooksInstalled,
        hoverHookCount = self.hoverHookCount,
        hoverEnterCount = self.hoverEnterCount,
        hoverLeaveCount = self.hoverLeaveCount,
        secureDriverReady = self.secureDriverReady == true,
        secureDriverLastResult = self.secureDriverLastResult,
        protectedRootSkips = self.protectedRootSkips,
        pendingDisableReconcile = self.pendingDisableReconcile,
        feedbackFramesUpdated = self.feedbackFramesUpdated,
        alphaZeroUsed =
            self.primaryAlpha == 0
            or self.secondaryAlpha == 0
            or self.utilityAlpha == 0
            or self.bar4Alpha == 0
            or self.bar5Alpha == 0
            or self.petAlpha == 0,
    }
end
