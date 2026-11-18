local _, Logres = ...

local ALPHA_POLICY = {
    world = {
        primary = 1.00,
        secondary = 0.00,
        utility = 0.00,
    },
    pvp = {
        primary = 1.00,
        secondary = 0.00,
        utility = 0.00,
    },
    instance = {
        primary = 1.00,
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
    end,

    OnEnable = function(self)
        self:SubscribeState(function(current)
            self:ApplyState(current)
        end)

        self:ApplyState(Logres:GetState())
    end,

    OnDisable = function(self)
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

function Context:ApplyPolicy(policyName)
    local policy = ALPHA_POLICY[policyName] or ALPHA_POLICY.world

    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")

    primary.cluster:SetAlpha(policy.primary)
    local feedbackUpdated = 0
    for _, source in ipairs({"secondary", "utility", "bar4", "bar5"}) do
        local role = Logres.Layout.GetActionBarSpec(source).role
        -- Context is presentation-only; never change secure action attributes.
        sides.clusters[source].frame:SetAlpha(policy[role])
        -- Keybind plates and pressed/activation feedback live under UIParent,
        -- outside the cluster. Fade those addon-owned visuals as well or
        -- apparently empty bars leave floating key labels on screen.
        for _, button in ipairs(sides.clusters[source].buttons) do
            local feedback = button.activationFeedbackFrame
            if feedback then
                feedback:SetAlpha(policy[role])
                feedbackUpdated = feedbackUpdated + 1
            end
        end
    end

    local pet = Logres:GetModule("PetActionExecutionProbe")
    if pet and type(pet.ApplyContextOpacity) == "function" then
        pet:ApplyContextOpacity(policy.secondary)
    end

    self.feedbackFramesUpdated = feedbackUpdated
    self.petAlpha = policy.secondary
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
        petAlpha = self.petAlpha,
        feedbackFramesUpdated = self.feedbackFramesUpdated,
        alphaZeroUsed =
            self.primaryAlpha == 0
            or self.secondaryAlpha == 0
            or self.utilityAlpha == 0,
    }
end
