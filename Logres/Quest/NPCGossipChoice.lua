-- P0318: guarded native gossip option routing from a direct Logres button click.
-- Native gossip always stays usable; no frame modifications or quest transactions.
local _, Logres = ...
local Choice = {}
Logres.NPCGossipChoice = Choice

local attempts, successes, blocked = 0, 0, 0
local last = "not-selected"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, result = pcall(issecretvalue, value)
    return ok and result == false
end

local function selector()
    if not ordinary(C_GossipInfo) then return nil end
    local ok, fn = pcall(function() return C_GossipInfo.SelectOption end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function allowed()
    local fn = selector()
    if not fn then return nil, "native-select-unavailable" end
    if type(InCombatLockdown) ~= "function" then return nil, "combat-gate-unavailable" end
    local ok, combat = pcall(InCombatLockdown)
    if not ok or not ordinary(combat) or combat ~= false then
        return nil, "combat-or-unknown"
    end
    local state = Logres:GetState()
    if not state or state.interacting ~= true or not ordinary(state.interactionType)
        or type(state.interactionType) ~= "number" then
        return nil, "interaction-not-ready"
    end
    return fn
end

function Choice.CanSelect()
    return allowed() ~= nil
end

local function deny(reason)
    blocked = blocked + 1
    last = reason
    return false, reason
end

function Choice.Activate(model, index)
    -- This function is reachable only from an explicit Logres option click.
    local fn, why = allowed()
    if not fn then return deny(why) end
    if type(index) ~= "number" or index ~= math.floor(index)
        or index < 1 or index > 24 or not model or model.previewOnly ~= false
        or type(model.nodes) ~= "table" then
        return deny("invalid-live-selection")
    end
    local original = model.nodes[model.start]
    local options = original and original.options
    local chosen = options and options[index]
    if type(options) ~= "table" or type(chosen) ~= "table"
        or chosen.enabled ~= false or not ordinary(chosen.gossipOptionID)
        or type(chosen.gossipOptionID) ~= "number"
        or chosen.gossipOptionID < 1 or chosen.gossipOptionID ~= math.floor(chosen.gossipOptionID)
        or chosen.gossipStatus ~= 0 then
        return deny("unverified-or-locked-option")
    end
    -- Re-read current native source at the instant of the user's click;
    -- reject an obsolete NPC, reordered menu or different quest context.
    local fresh, report = Logres.NPCGossipSource.Sample()
    if not fresh or not report or report.status ~= "model-ready"
        or fresh.title ~= model.title or fresh.gossipKind ~= model.gossipKind
        or type(fresh.questSummary) ~= "table" or type(model.questSummary) ~= "table"
        or fresh.questSummary.available ~= model.questSummary.available
        or fresh.questSummary.active ~= model.questSummary.active then
        return deny("gossip-session-changed")
    end
    local newNode = fresh.nodes and fresh.nodes[fresh.start]
    local newOptions = newNode and newNode.options
    if type(newOptions) ~= "table" or #newOptions ~= #options then
        return deny("gossip-menu-changed")
    end
    for i = 1, #options do
        local a, b = options[i], newOptions[i]
        if type(a) ~= "table" or type(b) ~= "table"
            or a.gossipOptionID ~= b.gossipOptionID
            or a.label ~= b.label or a.gossipStatus ~= b.gossipStatus
            or a.questID ~= b.questID or a.questKind ~= b.questKind then
            return deny("gossip-row-changed")
        end
    end
    -- A single native option call is allowed only for an ordinary, validated
    -- source identity and a direct user click. Never auto-select or accept quests.
    local restored = Logres.NPCGossipPresentation.BeforeNativeChoice()
    if not restored then return deny("native-gossip-restore-deferred") end
    attempts = attempts + 1
    local ok = pcall(fn, chosen.gossipOptionID)
    if not ok then return deny("native-select-failed") end
    successes = successes + 1
    last = "native-gossip-choice-issued"
    if Logres.NPCGossipPresentation and Logres.NPCGossipPresentation.OnNativeChoice then
        Logres.NPCGossipPresentation.OnNativeChoice()
    end
    return true, last
end

function Choice.GetAudit()
    return { attempts = attempts, successes = successes, blocked = blocked, last = last }
end

return Choice
