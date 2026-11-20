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
        self.secureFeedbackRefs = 0
        self.secureRootDriverFrames = {}
        self.secureRootDriversByKey = {}
        self.secureRootDriverCount = 0
        self.secureRootDriverLastResult = "not-attempted"
        self.pendingDisableReconcile = false
        self.postCombatReconciles = 0
        self.postCombatHoverRepairs = 0
        self.postCombatHoverUnknown = 0
        self.postCombatLastResult = "not-attempted"
        -- Read-only transition evidence; no protected frame attributes,
        -- native state, or secure snippets are inspected or modified.
        self.combatEnteredEvents = 0
        self.combatLeftEvents = 0
        self.combatEventLastPolicy = "none"
        self.combatEventLastDriver = "none"
        self.disableEventFrame = CreateFrame("Frame")
        self.disableEventFrame:SetScript("OnEvent", function(_, event)
            if event == "PLAYER_REGEN_DISABLED" then
                if not self:IsEnabled() then return end
                -- P0499: Player combat entry is authoritative before the
                -- eventual shared-state UNIT_AURA snapshot. The restricted
                -- driver still owns protected cluster alpha in lockdown.
                self:ApplyPolicy("combat")
                self.combatEnteredEvents = self.combatEnteredEvents + 1
                self.combatEventLastPolicy = self.policyName or "none"
                self.combatEventLastDriver = self.secureDriverLastResult or "none"
                if type(Logres.TraceEvent) == "function" then
                    Logres:TraceEvent("action", "combat-enter-observed", {
                        result = self.combatEventLastPolicy,
                        reason = self.combatEventLastDriver,
                    })
                end
                return
            end
            if event ~= "PLAYER_REGEN_ENABLED"
                or (InCombatLockdown and InCombatLockdown()) then return end
            self.combatLeftEvents = self.combatLeftEvents + 1
            self.combatEventLastPolicy = self.policyName or "none"
            self.combatEventLastDriver = self.secureDriverLastResult or "none"
            if type(Logres.TraceEvent) == "function" then
                Logres:TraceEvent("action", "combat-exit-observed", {
                    result = self.combatEventLastPolicy,
                    reason = self.combatEventLastDriver,
                })
            end
            if self.pendingDisableReconcile == true then
                self:FinishPendingDisable()
            elseif self.hoverEffectsEnabled == true and self:IsEnabled() then
                self:ReconcileAfterCombat()
            end
        end)
    end,

    OnEnable = function(self)
        self.pendingDisableReconcile = false
        -- Active modules also need an OOC recovery event. A state callback
        -- can run before secure combat lockdown actually lifts.
        self.disableEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
        self.disableEventFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
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
    self.disableEventFrame:UnregisterEvent("PLAYER_REGEN_DISABLED")
    -- Releasing the per-cluster handlers is OOC-only, before the shared
    -- feedback driver. No protected teardown occurs in lockdown.
    for _, root in ipairs(self.secureRootDriverFrames or {}) do
        UnregisterStateDriver(root, "logresbar")
    end
    self.secureRootDriverFrames = {}
    self.secureRootDriverCount = 0
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
        -- Only activation feedback remains on UIParent siblings. Keybind
        -- regions now inherit secure action-button visibility directly.
        -- Mirror activation feedback in the same secure transition.
        for index = 1, 12 do
            local a = self:GetFrameRef("primaryFeedback" .. index)
            if a then a:SetAlpha(1) end
            local b = self:GetFrameRef("secondaryFeedback" .. index)
            if b then b:SetAlpha(0.85) end
            local c = self:GetFrameRef("utilityFeedback" .. index)
            if c then c:SetAlpha(0.75) end
            local d = self:GetFrameRef("bar4Feedback" .. index)
            if d then d:SetAlpha(1) end
            local e = self:GetFrameRef("bar5Feedback" .. index)
            if e then e:SetAlpha(0.75) end
        end
        for index = 1, 10 do
            local feedback = self:GetFrameRef("petFeedback" .. index)
            if feedback then feedback:SetAlpha(0.85) end
        end
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
        -- P0499: six separate secure owners, each with one addon-owned
        -- cluster reference. The original cluster constructor, action
        -- buttons, geometry and hover ownership remain unchanged.
        -- Each restricted callback is independent of the 70-feedback loop.
        local roots = {
            {"primary", primary.cluster, "1"},
            {"secondary", sides.clusters.secondary.frame, "0.85"},
            {"utility", sides.clusters.utility.frame, "0.75"},
            {"bar4", sides.clusters.bar4.frame, "1"},
            {"bar5", sides.clusters.bar5.frame, "0.75"},
            {"pet", pet.cluster, "0.85"},
        }
        self.secureRootDriverFrames = {}
        for _, entry in ipairs(roots) do
            local key, root, alpha = entry[1], entry[2], entry[3]
            -- Reuse the named driver after module disable/re-enable.
            local rootDriver = self.secureRootDriversByKey[key]
            if not rootDriver then
                rootDriver = CreateFrame("Frame",
                    "LogresActionAlphaRootDriver" .. key, UIParent,
                    "SecureHandlerStateTemplate")
                self.secureRootDriversByKey[key] = rootDriver
            end
            rootDriver:SetFrameRef("cluster", root)
            -- This marker covers only the current driver registration.
            rootDriver:SetAttribute("logresCombatAck", false)
            rootDriver:SetAttribute("_onstate-logresbar",
                'if newstate == "combat" then ' ..
                'local cluster = self:GetFrameRef("cluster"); ' ..
                'if cluster then cluster:SetAlpha(' .. alpha ..
                '); self:SetAttribute("logresCombatAck", true) end end')
            -- Retain every attempted driver for transactional rollback.
            self.secureRootDriverFrames[#self.secureRootDriverFrames + 1] = rootDriver
            RegisterStateDriver(rootDriver, "logresbar", "[combat] combat; rest")
        end
        self.secureRootDriverCount = #self.secureRootDriverFrames
        local feedbackCount = 0
        -- Pre-register only Logres-owned feedback siblings while OOC.
        -- The restricted combat script never creates or queries UI frames.
        local function bindFeedback(source, buttons)
            for index, button in ipairs(buttons or {}) do
                local feedback = button and button.activationFeedbackFrame
                if feedback then
                    driver:SetFrameRef(source .. "Feedback" .. index, feedback)
                    feedbackCount = feedbackCount + 1
                end
            end
        end
        bindFeedback("primary", primary.buttons)
        for _, source in ipairs({"secondary", "utility", "bar4", "bar5"}) do
            bindFeedback(source, sides.clusters[source].buttons)
        end
        bindFeedback("pet", pet.buttons)
        self.secureFeedbackRefs = feedbackCount
        driver:SetAttribute("_onstate-logrescombat", COMBAT_ALPHA_SNIPPET)
        RegisterStateDriver(driver, "logrescombat", "[combat] combat; rest")
    end)
    if not ok then
        -- A partial secure setup must not strand some bars faded.
        -- The ordinary fail-open policy leaves all action roots visible.
        for _, root in ipairs(self.secureRootDriverFrames or {}) do
            pcall(UnregisterStateDriver, root, "logresbar")
        end
        self.secureRootDriverFrames = {}
        self.secureRootDriverCount = 0
        if self.combatDriver then
            pcall(UnregisterStateDriver, self.combatDriver, "logrescombat")
        end
    end
    self.secureRootDriverLastResult = ok and "six-registered"
        or ("registration-failed:" .. tostring(err))
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

-- Only run this read on Logres-owned button objects after lockdown ends.
-- IsMouseOver can be unavailable or secret-capable; never branch on the
-- returned value unless issecretvalue has explicitly cleared it.
local function ReadOwnedMouseOver(button)
    if not button or type(button.IsMouseOver) ~= "function" then return nil end
    local ok, value = pcall(button.IsMouseOver, button)
    if not ok or type(issecretvalue) ~= "function" then return nil end
    local classified, secret = pcall(issecretvalue, value)
    if not classified or secret ~= false then return nil end
    if type(value) ~= "boolean" then return nil end
    return value
end

-- Existing button hooks are the primary hover source. One time at combat
-- exit, independently reconcile missed OnLeave events without polling or
-- consulting Blizzard mouse-focus/visual state. Unknown inputs are kept.
function Context:ReconcileOwnedHover()
    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local pet = Logres:GetModule("PetActionExecutionProbe")
    local sources = {
        { key = "primary", buttons = primary and primary.buttons },
        { key = "secondary", buttons = sides and sides.clusters.secondary.buttons },
        { key = "utility", buttons = sides and sides.clusters.utility.buttons },
        { key = "bar4", buttons = sides and sides.clusters.bar4.buttons },
        { key = "bar5", buttons = sides and sides.clusters.bar5.buttons },
        { key = "pet", buttons = pet and pet.buttons },
    }
    for _, group in ipairs(sources) do
        local count, known, over = 0, 0, false
        for _, button in ipairs(group.buttons or {}) do
            count = count + 1
            local value = ReadOwnedMouseOver(button)
            if value ~= nil then
                known = known + 1
                if value == true then over = true end
            end
        end
        if over or (count > 0 and known == count) then
            if self.hovered[group.key] ~= over then
                self.hovered[group.key] = over
                self.postCombatHoverRepairs = self.postCombatHoverRepairs + 1
            end
        else
            self.postCombatHoverUnknown = self.postCombatHoverUnknown + 1
        end
    end
end

-- PLAYER_REGEN_ENABLED explicitly supplies the missing post-lockdown owner.
-- Treat this event as out-of-combat even if the state publisher has not
-- delivered its matching snapshot yet. The secure driver rest branch stays
-- inert, preserving a genuinely held hover in either delivery order.
function Context:ReconcileAfterCombat()
    if InCombatLockdown and InCombatLockdown() then
        self.postCombatLastResult = "lockdown-deferred"
        return false
    end
    self:ReconcileOwnedHover()
    local state = Logres:GetState()
    local policy = state.pvpFlagged and "pvp"
        or (state.context == "instance" and "instance") or "world"
    self:ApplyPolicy(policy)
    self.postCombatReconciles = self.postCombatReconciles + 1
    self.postCombatLastResult = self.secureDriverReady and "rest-applied"
        or "visible-fail-open"
    return true
end

-- GetAlpha is read-only and only queries addon-created roots OOC. Do not
-- read native Blizzard frames or inspect a secret-capable return value.
local function ReadOwnedAlpha(frame)
    if (InCombatLockdown and InCombatLockdown())
        or not frame or type(frame.GetAlpha) ~= "function" then return nil end
    local ok, value = pcall(frame.GetAlpha, frame)
    if not ok or type(issecretvalue) ~= "function" then return nil end
    local classified, secret = pcall(issecretvalue, value)
    if not classified or secret ~= false then return nil end
    if type(value) ~= "number" or value < 0 or value > 1 then return nil end
    return value
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
    -- In lockdown, the secure driver owns combat alpha; a late/stale
    -- noncombat state callback must not re-dim activation feedback.
    -- If driver setup failed, retain the existing visible fail-open path.
    if locked and self.secureDriverReady == true then
        policyName = "combat"
    end
    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local primaryAlpha = self:ResolvedAlpha(policyName, "primary", "primary")

    if not locked then
        primary.cluster:SetAlpha(primaryAlpha)
    else
        self.protectedRootSkips = self.protectedRootSkips + 1
    end
    local feedbackUpdated = 0
    -- Primary activation feedback is an unprotected UIParent sibling and
    -- follows its role while button-owned keybinds inherit root alpha.
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
        -- Activation-feedback siblings live under UIParent, not clusters.
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

-- Read only addon-owned completion tokens, never native presentation state.
-- The token is sampled only outside lockdown, with explicit secret rejection.
local function ReadOwnedCombatAck(root)
    if (InCombatLockdown and InCombatLockdown())
        or not root or type(root.GetAttribute) ~= "function"
        or type(issecretvalue) ~= "function" then return nil end
    local ok, value = pcall(root.GetAttribute, root, "logresCombatAck")
    if not ok then return nil end
    local classified, secret = pcall(issecretvalue, value)
    if not classified or secret ~= false then return nil end
    return value == true
end

function Context:GetDebugStatus()
    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")
    local pet = Logres:GetModule("PetActionExecutionProbe")
    local clusters = sides and sides.clusters or {}
    local secureRootAckCount = 0
    for _, root in ipairs(self.secureRootDriverFrames or {}) do
        if ReadOwnedCombatAck(root) == true then
            secureRootAckCount = secureRootAckCount + 1
        end
    end
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
        secureFeedbackRefs = self.secureFeedbackRefs,
        secureRootDriverCount = self.secureRootDriverCount,
        secureRootDriverLastResult = self.secureRootDriverLastResult,
        secureRootAckCount = secureRootAckCount,
        secureDriverLastResult = self.secureDriverLastResult,
        combatEnteredEvents = self.combatEnteredEvents,
        combatLeftEvents = self.combatLeftEvents,
        combatEventLastPolicy = self.combatEventLastPolicy,
        combatEventLastDriver = self.combatEventLastDriver,
        protectedRootSkips = self.protectedRootSkips,
        postCombatReconciles = self.postCombatReconciles,
        postCombatHoverRepairs = self.postCombatHoverRepairs,
        postCombatHoverUnknown = self.postCombatHoverUnknown,
        postCombatLastResult = self.postCombatLastResult,
        ownedPrimaryActualAlpha = ReadOwnedAlpha(primary and primary.cluster),
        ownedSecondaryActualAlpha = ReadOwnedAlpha(clusters.secondary and clusters.secondary.frame),
        ownedUtilityActualAlpha = ReadOwnedAlpha(clusters.utility and clusters.utility.frame),
        ownedBar4ActualAlpha = ReadOwnedAlpha(clusters.bar4 and clusters.bar4.frame),
        ownedBar5ActualAlpha = ReadOwnedAlpha(clusters.bar5 and clusters.bar5.frame),
        ownedPetActualAlpha = ReadOwnedAlpha(pet and pet.cluster),
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
