local _, Logres = ...

local ALPHA_POLICY = {
    world = {
        primary = 0.50,
        secondary = 0.00,
        utility = 0.00,
    },
    pvp = {
        primary = 0.50,
        secondary = 0.00,
        utility = 0.00,
    },
    instance = {
        primary = 0.50,
        secondary = 0.00,
        utility = 0.00,
    },
    combat = {
        primary = 1.00,
        secondary = 1.00,
        utility = 0.75,
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
    end,

    OnEnable = function(self)
        self.hoverEffectsEnabled = true
        self:InstallHoverHooks()
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
        -- Disabling contextual fading restores usable visible action art.
        self:ApplyPolicy("combat")
    end,
})

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
    if policyName ~= "combat" and self.hoverEffectsEnabled == true
        and self.hovered[source] == true
    then
        return ALPHA_POLICY.combat[role]
    end
    return policy[role]
end

function Context:ApplyPolicy(policyName)
    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local primaryAlpha = self:ResolvedAlpha(policyName, "primary", "primary")

    primary.cluster:SetAlpha(primaryAlpha)
    local feedbackUpdated = 0
    -- Primary feedback plates are outside the cluster and must follow
    -- its 50% resting opacity, not remain full-bright out of combat.
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
        sides.clusters[source].frame:SetAlpha(alpha)
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
        pet:ApplyContextOpacity(petAlpha)
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
