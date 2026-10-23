-- P0315: one-shot, read-only native gossip -> existing NPC option-model envelope.
-- No live presentation, selection, native frame writes, timers, or events.
local _, Logres = ...
local Source = {}
Logres.NPCGossipSource = Source

local MAX_OPTIONS = 24
local MAX_TEXT = 2048
local last = { status = "not-sampled", nativeActions = 0, nativeWrites = 0 }

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function member(object, name)
    if not ordinary(object) then return nil end
    local ok, value = pcall(function() return object[name] end)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function method(object, name)
    local value = member(object, name)
    if type(value) ~= "function" then return nil end
    return value
end

local function plainText(value)
    if not ordinary(value) or type(value) ~= "string" then return nil end
    if #value > MAX_TEXT then return nil end
    return value
end

local function readList(name)
    local fn = method(C_GossipInfo, name)
    if not fn then return nil, "api-unavailable-" .. name end
    local ok, rows = pcall(fn)
    if not ok or not ordinary(rows) or type(rows) ~= "table" then
        return nil, "rows-unavailable-" .. name
    end
    local result = {}
    for index = 1, MAX_OPTIONS + 1 do
        local readOK, value = pcall(function() return rows[index] end)
        if not readOK or not ordinary(value) then
            return nil, "secret-or-invalid-row-" .. name
        end
        if value == nil then return result end
        if index > MAX_OPTIONS then
            return nil, "rows-truncated-" .. name
        end
        if type(value) ~= "table" then
            return nil, "invalid-row-" .. name
        end
        result[index] = value
    end
    return result
end

local function audit(status, interactionType, options, quests, title, bodySource)
    last = {
        status = status,
        interactionType = interactionType,
        optionCount = options or 0,
        questCount = quests or 0,
        npc = title or "unknown",
        bodySource = bodySource or "none",
        nativeActions = 0,
        nativeWrites = 0,
        modelReady = status == "model-ready",
    }
    return last
end

function Source.Sample()
    -- The developer explicitly requests this sample while talking to an NPC.
    -- State is addon-owned; no Blizzard visual frame state is inspected.
    local state = Logres:GetState()
    local interaction = state and state.interactionType
    if not state or state.interacting ~= true
        or not ordinary(interaction) or type(interaction) ~= "number" then
        return nil, audit("no-ordinary-interaction", nil)
    end
    if type(UnitExists) ~= "function" or type(UnitName) ~= "function" then
        return nil, audit("npc-api-unavailable", interaction)
    end
    local existsOK, exists = pcall(UnitExists, "npc")
    if not existsOK or not ordinary(exists) or exists ~= true then
        return nil, audit("npc-not-verified", interaction)
    end
    local nameOK, name = pcall(UnitName, "npc")
    name = nameOK and plainText(name) or nil
    if not name or name == "" then
        return nil, audit("npc-name-unavailable", interaction)
    end
    local options, optionsWhy = readList("GetOptions")
    if not options then
        return nil, audit(optionsWhy, interaction, nil, nil, name)
    end
    local available, availableWhy = readList("GetAvailableQuests")
    if not available then
        return nil, audit(availableWhy, interaction, #options, nil, name)
    end
    local active, activeWhy = readList("GetActiveQuests")
    if not active then
        return nil, audit(activeWhy, interaction, #options, #available, name)
    end
    local totalQuests = #available + #active
    local textFn = method(C_GossipInfo, "GetText")
    local body, bodySource = nil, "unavailable"
    if textFn then
        local textOK, value = pcall(textFn)
        if textOK then body = plainText(value) end
        if body then bodySource = "C_GossipInfo.GetText" end
    end
    if totalQuests > 0 then
        return nil, audit("mixed-quest-gossip-stock-retained", interaction,
            #options, totalQuests, name, bodySource)
    end
    if body == nil then
        return nil, audit("gossip-text-unavailable", interaction,
            #options, totalQuests, name, bodySource)
    end
    local choices = {}
    for index = 1, #options do
        local option = options[index]
        if not ordinary(option) then
            return nil, audit("option-secret", interaction, #options, 0, name, bodySource)
        end
        local label = plainText(member(option, "name"))
        local identity = member(option, "gossipOptionID")
        if not label or label == "" or not ordinary(identity)
            or type(identity) ~= "number" then
            return nil, audit("option-unvalidated", interaction, #options, 0, name, bodySource)
        end
        -- The source ordinal/identity is audit-only. No native click can be
        -- produced by the option preview controller or by this adapter.
        choices[index] = {
            label = label, nextNode = nil, enabled = false,
            reason = "Blizzard gossip interaction retained",
            gossipOptionID = identity,
        }
    end
    local model = Logres.NPCOptionModel.FromValidated(name, "gossip", {
        gossip = { title = name, body = body, options = choices },
    })
    audit("model-ready", interaction, #choices, 0, name, bodySource)
    return model, last
end

function Source.GetAudit()
    -- Audit fields are copies of addon-owned ordinary values only.
    local out = {}
    for key, value in pairs(last) do out[key] = value end
    return out
end

return Source
