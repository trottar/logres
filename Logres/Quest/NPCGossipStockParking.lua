-- P0321: capability-gated, fail-open single-window gossip presentation.
-- Keep GossipFrame SHOWN so Blizzard's source and transaction state survives;
-- move only the whole native root out of the interactive screen. No alpha-only
-- hidden click regions, secure mutation, timers, polling or native option reads.
local _, Logres = ...
local Parking = {}
Logres.NPCGossipStockParking = Parking

local enabled, parked, pendingExit = true, nil, false
local attempts, parks, restores, deferrals, failures = 0, 0, 0, 0, 0
local last = "stock-visible"
local retry = CreateFrame("Frame")
local hooked = false

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, result = pcall(issecretvalue, value)
    return ok and result == false
end

local function member(owner, key)
    if not ordinary(owner) then return nil end
    local ok, value = pcall(function() return owner[key] end)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function method(owner, key)
    local fn = member(owner, key)
    return type(fn) == "function" and fn or nil
end

local function read(owner, name)
    local fn = method(owner, name)
    if not fn then return nil end
    local ok, value = pcall(fn, owner)
    if ok and ordinary(value) then return value end
    return nil
end

local function unlocked()
    if type(InCombatLockdown) ~= "function" then return false end
    local ok, combat = pcall(InCombatLockdown)
    return ok and ordinary(combat) and combat == false
end

local function defer(reason)
    deferrals = deferrals + 1
    last = reason
    return false, reason
end

local function capture(root)
    local count, get = read(root, "GetNumPoints"), method(root, "GetPoint")
    if type(count) ~= "number" or count < 1 or count > 8
        or count ~= math.floor(count) or not get then return nil end
    local tokens = {}
    for index = 1, count do
        local ok, point, relative, relativePoint, x, y = pcall(get, root, index)
        if not ok then return nil end
        -- These five native values may be secret-capable restoration tokens.
        -- Never branch on, format, compare or stringify any of them.
        tokens[index] = {point, relative, relativePoint, x, y}
    end
    return tokens
end

function Parking.IsParked()
    return parked ~= nil
end

function Parking.Restore(reason)
    if not parked then
        last = reason or "stock-already-visible"
        return true, last
    end
    if not unlocked() then
        parked.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        return defer("restore-deferred-combat")
    end
    local saved = parked
    local ok = pcall(function()
        saved.clear(saved.root)
        for index = 1, #saved.tokens do
            local token = saved.tokens[index]
            saved.set(saved.root, token[1], token[2], token[3], token[4], token[5])
        end
    end)
    if not ok then
        failures = failures + 1
        saved.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        return defer("restore-failed-retry-pending")
    end
    parked = nil
    retry:UnregisterEvent("PLAYER_REGEN_ENABLED")
    restores = restores + 1
    last = reason or "stock-anchors-restored"
    return true, last
end

retry:SetScript("OnEvent", function(_, event)
    if event ~= "PLAYER_REGEN_ENABLED" or not parked or not parked.pending then return end
    local exitPending = pendingExit
    local ok = Parking.Restore("regen-restoration")
    if ok then
        pendingExit = false
        if exitPending and Logres.NPCGossipPresentation then
            Logres.NPCGossipPresentation.OnStockRestored()
        end
    end
end)

local function closeAvailable()
    return ordinary(C_GossipInfo) and method(C_GossipInfo, "CloseGossip") ~= nil
end

local function complete(model)
    if not closeAvailable() or type(model) ~= "table"
        or model.previewOnly ~= false or type(model.nodes) ~= "table" then return false end
    local node = model.nodes[model.start]
    if type(node) ~= "table" or type(node.options) ~= "table" then return false end
    if #node.options == 0 then
        return type(node.body) == "string" and node.body ~= ""
    end
    if #node.options > 72 then return false end
    local questAvailable, questActive, gossipReady =
        Logres.NPCGossipQuestChoice.CanSelect("available"),
        Logres.NPCGossipQuestChoice.CanSelect("active"),
        Logres.NPCGossipChoice.CanSelect()
    for index = 1, #node.options do
        local option = node.options[index]
        if type(option) ~= "table" or option.enabled ~= false then return false end
        if option.questKind == "available" then
            if not questAvailable then return false end
        elseif option.questKind == "active" then
            if not questActive then return false end
        elseif option.questKind == nil then
            if not gossipReady or option.gossipStatus ~= 0 then return false end
        else
            return false
        end
    end
    return true
end

function Parking.TryPark(model)
    if not enabled then return defer("stock-parking-disabled") end
    if not complete(model) then
        if parked then Parking.Restore("incomplete-stage-stock-fallback") end
        return defer("stage-not-fully-actionable")
    end
    if parked then
        if parked.pending then return defer("restoration-pending") end
        last = "already-parked"
        return true, last
    end
    attempts = attempts + 1
    if not unlocked() then return defer("combat-or-secret-deferred") end
    local state = Logres:GetState()
    if not state or state.interacting ~= true
        or not ordinary(state.interactionType) or type(state.interactionType) ~= "number" then
        return defer("interaction-unverified")
    end
    local okRoot, root = pcall(function() return _G.GossipFrame end)
    if not okRoot or not ordinary(root) or not root
        or read(root, "IsProtected") ~= false
        or read(root, "IsShown") ~= true then
        return defer("native-root-unavailable-or-protected")
    end
    local clear, set, hook = method(root, "ClearAllPoints"),
        method(root, "SetPoint"), method(root, "HookScript")
    local tokens = capture(root)
    if not clear or not set or not hook or not tokens or not ordinary(UIParent) then
        return defer("native-anchor-capability-unavailable")
    end
    if not hooked then
        local ok = pcall(hook, root, "OnHide", function()
            if parked then Parking.Restore("native-gossip-root-hidden") end
        end)
        if not ok then return defer("native-hide-hook-unavailable") end
        hooked = true
    end
    parked = {root = root, clear = clear, set = set, tokens = tokens, pending = false}
    local moved = pcall(function()
        clear(root)
        set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)
    end)
    if not moved then
        failures = failures + 1
        local restored = Parking.Restore("park-rollback")
        if not restored then pendingExit = true end
        return defer("native-position-failed")
    end
    parks = parks + 1
    last = "native-offscreen-requested-unverified"
    return true, last
end

function Parking.RequestExit(reason)
    if not parked then return true, "stock-visible" end
    local ok, why = Parking.Restore(reason or "gossip-exit")
    if not ok then pendingExit = true end
    return ok, why
end

function Parking.CloseGossip()
    -- Explicit Goodbye only, never automated by GOSSIP_SHOW.
    local restored, why = Parking.RequestExit("goodbye-native-return")
    if not restored then return false, why end
    local close = ordinary(C_GossipInfo) and method(C_GossipInfo, "CloseGossip")
    if not close then return false, "close-api-unavailable-stock-visible" end
    if not unlocked() then return false, "combat-stock-visible" end
    local ok = pcall(close)
    if not ok then return false, "close-failed-stock-visible" end
    last = "native-close-issued"
    return true, last
end

function Parking.Toggle()
    enabled = not enabled
    if not enabled then Parking.RequestExit("H-parking-disabled") end
    if enabled then last = "enabled-next-eligible-gossip" end
    return Parking.GetAudit()
end

function Parking.GetAudit()
    return {enabled = enabled, parked = parked ~= nil,
        pending = parked and parked.pending or false,
        attempts = attempts, parks = parks, restores = restores,
        deferrals = deferrals, failures = failures, last = last,
        stockShownPreserved = true, nativeAlphaWrites = 0, nativeMouseWrites = 0}
end

return Parking
