local _, Logres = ...

local ALPHA_POLICY = {
    world = {
        primary = 1.00,
        secondary = 0.45,
        utility = 0.20,
    },
    pvp = {
        primary = 1.00,
        secondary = 0.75,
        utility = 0.40,
    },
    instance = {
        primary = 1.00,
        secondary = 0.70,
        utility = 0.45,
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
        self.secondaryAlpha = 0.45
        self.utilityAlpha = 0.20
    end,

    OnEnable = function(self)
        self:SubscribeState(function(current)
            self:ApplyState(current)
        end)

        self:ApplyState(Logres:GetState())
    end,

    OnDisable = function(self)
        -- Restore proof-layout emphasis when disabled.
        self:ApplyPolicy("world")
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

function Context:ApplyPolicy(policyName)
    local policy = ALPHA_POLICY[policyName] or ALPHA_POLICY.world

    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")

    primary.cluster:SetAlpha(policy.primary)
    sides.clusters.secondary.frame:SetAlpha(policy.secondary)
    sides.clusters.utility.frame:SetAlpha(policy.utility)
    sides.clusters.bar4.frame:SetAlpha(policy.secondary)
    sides.clusters.bar5.frame:SetAlpha(policy.utility)

    self.policyName = policyName
    self.primaryAlpha = policy.primary
    self.secondaryAlpha = policy.secondary
    self.utilityAlpha = policy.utility
end

function Context:ApplyState(state)
    self:ApplyPolicy(self:ResolvePolicyName(state))
end

function Context:GetDebugStatus()
    return {
        moduleEnabled = self:IsEnabled(),
        policyName = self.policyName,
        primaryAlpha = self.primaryAlpha,
        secondaryAlpha = self.secondaryAlpha,
        utilityAlpha = self.utilityAlpha,
        alphaZeroUsed =
            self.primaryAlpha == 0
            or self.secondaryAlpha == 0
            or self.utilityAlpha == 0,
    }
end
