-- P0320: direct-click guarded quest-greeting navigation through native gossip.
-- Opens Blizzard quest detail/progress; NEVER accepts, completes or claims quests.
local _, Logres = ...
local Quest = {}
Logres.NPCGossipQuestChoice = Quest

local attempts, issued, blocked = 0, 0, 0
local last = "not-selected"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function selector(kind)
    if kind ~= "available" and kind ~= "active" then return nil end
    if not ordinary(C_GossipInfo) then return nil end
    local key = kind == "available" and "SelectAvailableQuest" or "SelectActiveQuest"
    local ok, fn = pcall(function() return C_GossipInfo[key] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function allowed(kind)
    local fn = selector(kind)
    if not fn then return nil, "quest-selector-unavailable" end
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

function Quest.CanSelect(kind)
    return allowed(kind) ~= nil
end

local function deny(reason)
    blocked = blocked + 1
    last = reason
    return false, reason
end

function Quest.Activate(model, index)
    -- No automatic quest selection. Only a direct addon option click enters here.
    if type(index) ~= "number" or index ~= math.floor(index)
        or index < 1 or index > 72 or type(model) ~= "table"
        or model.previewOnly ~= false or type(model.nodes) ~= "table" then
        return deny("invalid-quest-selection")
    end
    local original = model.nodes[model.start]
    local originalChoices = original and original.options
    local chosen = originalChoices and originalChoices[index]
    if type(originalChoices) ~= "table" or type(chosen) ~= "table"
        or (chosen.questKind ~= "available" and chosen.questKind ~= "active")
        or chosen.enabled ~= false or not ordinary(chosen.questID)
        or type(chosen.questID) ~= "number" or chosen.questID < 1
        or chosen.questID ~= math.floor(chosen.questID) then
        return deny("unverified-quest-row")
    end
    local fn, why = allowed(chosen.questKind)
    if not fn then return deny(why) end
    local fresh, audit = Logres.NPCGossipSource.Sample()
    if not fresh or not audit or audit.status ~= "model-ready"
        or fresh.title ~= model.title or fresh.gossipKind ~= model.gossipKind
        or type(fresh.questSummary) ~= "table" or type(model.questSummary) ~= "table"
        or fresh.questSummary.available ~= model.questSummary.available
        or fresh.questSummary.active ~= model.questSummary.active then
        return deny("quest-gossip-stage-changed")
    end
    local node = fresh.nodes and fresh.nodes[fresh.start]
    local current = node and node.options
    if type(current) ~= "table" or #current ~= #originalChoices then
        return deny("quest-list-changed")
    end
    for i = 1, #originalChoices do
        local a, b = originalChoices[i], current[i]
        if type(a) ~= "table" or type(b) ~= "table"
            or a.label ~= b.label or a.questKind ~= b.questKind
            or a.questID ~= b.questID or a.gossipOptionID ~= b.gossipOptionID
            or a.gossipStatus ~= b.gossipStatus then
            return deny("quest-or-gossip-row-changed")
        end
    end
    local restored = Logres.NPCGossipPresentation.BeforeNativeChoice()
    if not restored then return deny("native-quest-restore-deferred") end
    attempts = attempts + 1
    local ok = pcall(fn, chosen.questID)
    if not ok then return deny("native-quest-open-failed") end
    issued = issued + 1
    last = "native-quest-detail-requested"
    if Logres.NPCGossipPresentation and Logres.NPCGossipPresentation.OnNativeChoice then
        Logres.NPCGossipPresentation.OnNativeChoice()
    end
    return true, last
end

function Quest.GetAudit()
    return { attempts = attempts, issued = issued, blocked = blocked, last = last }
end

return Quest
