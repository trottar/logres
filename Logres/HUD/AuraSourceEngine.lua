local _, Logres = ...

-- P0177: Logres-owned comparison reader. This is intentionally NOT the
-- production status renderer. Only ordinary values enter candidate rows.
-- No UNIT_AURA delta payload, restricted aura or Blizzard frame is inspected.
local Engine = {}
Logres.AuraSourceEngine = Engine

local MAX_INDEX = 12
local MAX_CANDIDATES = 5

local GROUPS = {
    {
        key = "playerHarmful", unit = "player", baseline = "HARMFUL",
        priority = { "HARMFUL|CROWD_CONTROL", "HARMFUL|RAID" },
    },
    {
        key = "targetHarmful", unit = "target", baseline = "HARMFUL",
        priority = { "HARMFUL|PLAYER", "HARMFUL|CROWD_CONTROL" },
    },
    {
        key = "targetHelpful", unit = "target", baseline = "HELPFUL",
        priority = { "HELPFUL|DISPELLABLE", "HELPFUL|IMPORTANT" },
    },
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return true
    end
    local ok, secret = pcall(issecretvalue, value)
    return not ok or secret ~= false
end

local function APIsReady()
    return type(issecretvalue) == "function"
        and type(UnitExists) == "function"
        and C_Secrets ~= nil
        and type(C_Secrets.ShouldUnitAuraIndexBeSecret) == "function"
        and C_UnitAuras ~= nil
        and type(C_UnitAuras.GetAuraDataByIndex) == "function"
end

local function scan(unit, filter)
    local state = {
        ordinary = 0, secretIndices = 0, secretPredicates = 0,
        secretPayloads = 0, secretIcons = 0, invalid = 0,
        failures = 0, empty = false, inspected = 0, candidates = {},
    }
    for index = 1, MAX_INDEX do
        state.inspected = state.inspected + 1
        local ok, protected = pcall(
            C_Secrets.ShouldUnitAuraIndexBeSecret, unit, index, filter
        )
        if not ok then
            state.failures = state.failures + 1
        elseif isSecret(protected) then
            state.secretPredicates = state.secretPredicates + 1
        elseif protected == true then
            state.secretIndices = state.secretIndices + 1
        elseif protected ~= false then
            state.invalid = state.invalid + 1
        else
            local readOK, aura = pcall(
                C_UnitAuras.GetAuraDataByIndex, unit, index, filter
            )
            if not readOK then
                state.failures = state.failures + 1
            elseif isSecret(aura) then
                state.secretPayloads = state.secretPayloads + 1
            elseif aura == nil then
                state.empty = true
                break
            elseif type(aura) ~= "table" then
                state.invalid = state.invalid + 1
            else
                -- A payload being ordinary does not make each field ordinary.
                local icon = aura.icon
                if isSecret(icon) then
                    state.secretIcons = state.secretIcons + 1
                elseif type(icon) ~= "number" and type(icon) ~= "string" then
                    state.invalid = state.invalid + 1
                else
                    state.ordinary = state.ordinary + 1
                    if #state.candidates < MAX_CANDIDATES then
                        local applications = aura.applications
                        if isSecret(applications) then
                            applications = nil
                        elseif type(applications) ~= "number" then
                            applications = nil
                        end
                        state.candidates[#state.candidates + 1] = {
                            icon = icon, applications = applications,
                            index = index, filter = filter,
                        }
                    end
                end
            end
        end
    end
    return state
end

local function aggregate(scans)
    local out = {
        ordinary = 0, secret = 0, failures = 0, empty = 0,
        inspected = 0,
    }
    for _, source in ipairs(scans) do
        out.ordinary = out.ordinary + source.ordinary
        out.secret = out.secret + source.secretIndices
            + source.secretPredicates + source.secretPayloads
            + source.secretIcons
        out.failures = out.failures + source.failures + source.invalid
        out.inspected = out.inspected + source.inspected
        if source.empty then
            out.empty = out.empty + 1
        end
    end
    return out
end

-- Called only by the established Phase H Status Aura Check. This independent
-- source adapter is kept out of the production selection/rendering path until
-- Forever client evidence proves its accessible cases.
function Engine.Capture()
    if not APIsReady() then
        return { ready = false, reason = "api-unavailable", groups = {} }
    end
    local groups = {}
    for _, spec in ipairs(GROUPS) do
        local ok, present = pcall(UnitExists, spec.unit)
        if not ok or isSecret(present) then
            groups[#groups + 1] = { key = spec.key, reason = "unit-unreadable" }
        elseif present ~= true then
            groups[#groups + 1] = { key = spec.key, reason = "unit-absent" }
        else
            local base = scan(spec.unit, spec.baseline)
            local special = {}
            for _, filter in ipairs(spec.priority) do
                special[#special + 1] = scan(spec.unit, filter)
            end
            groups[#groups + 1] = {
                key = spec.key, reason = "scanned",
                base = aggregate({ base }), priority = aggregate(special),
                -- Retain only bounded ordinary source candidates, not secret
                -- payloads or derived spell identities.
                candidates = base.candidates,
            }
        end
    end
    return { ready = true, reason = "read-only-comparison", groups = groups }
end


-- P0180: bounded, event-latched comparator evidence. StatusAuras already owns
-- UNIT_AURA/target invalidations; this engine must never register a second
-- event handler or inspect an event delta. No icon or unit identity is cached.
local eventHistory = {}
for _, spec in ipairs(GROUPS) do
    eventHistory[spec.key] = {
        events = 0, baseMax = 0, basePositive = 0,
        priorityMax = 0, priorityPositive = 0, priorityScans = 0,
        restricted = 0, empty = 0, failures = 0,
        hostileEvents = 0, friendlyEvents = 0, unknownEvents = 0,
        hostileMax = 0, friendlyMax = 0,
        last = "not-observed",
    }
end
local unexpectedFailures = 0

local function ordinaryBoolean(func, ...)
    if type(func) ~= "function" then return nil end
    local ok, value = pcall(func, ...)
    if not ok or isSecret(value) or type(value) ~= "boolean" then
        return nil
    end
    return value
end

local function targetReaction()
    -- 'hostile' here means ordinary attackable, NOT a hidden faction query.
    if ordinaryBoolean(UnitCanAttack, "player", "target") == true then
        return "hostile"
    end
    if ordinaryBoolean(UnitIsFriend, "player", "target") == true then
        return "friendly"
    end
    return "unknown"
end

function Engine.NoteEventFailure()
    unexpectedFailures = unexpectedFailures + 1
end

-- Called exclusively from StatusAuras' pre-existing UNIT_AURA and
-- PLAYER_TARGET_CHANGED handler while Immersion is active and preview is off.
function Engine.ObserveEvent(unit, event)
    if isSecret(unit) or (unit ~= "player" and unit ~= "target") then return end
    if isSecret(event) or (event ~= "UNIT_AURA" and
        event ~= "PLAYER_TARGET_CHANGED") then return end
    if not APIsReady() then return end
    local reaction = unit == "target" and targetReaction() or "unknown"
    for _, spec in ipairs(GROUPS) do
        if spec.unit == unit then
            local h = eventHistory[spec.key]
            local present = ordinaryBoolean(UnitExists, spec.unit)
            if present == true then
                local base = aggregate({ scan(spec.unit, spec.baseline) })
                h.events = h.events + 1
                h.baseMax = math.max(h.baseMax, base.ordinary)
                if base.ordinary > 0 then h.basePositive = h.basePositive + 1 end
                if base.secret > 0 then h.restricted = h.restricted + 1 end
                if base.empty > 0 then h.empty = h.empty + 1 end
                h.failures = h.failures + base.failures
                -- Priority scans only when base is populated, restricted or
                -- indeterminate. Ordinary empty base reads need no extra scan.
                if base.ordinary > 0 or base.secret > 0 or base.failures > 0 then
                    local priority = {}
                    for _, filter in ipairs(spec.priority) do
                        priority[#priority + 1] = scan(spec.unit, filter)
                    end
                    local p = aggregate(priority)
                    h.priorityScans = h.priorityScans + 1
                    h.priorityMax = math.max(h.priorityMax, p.ordinary)
                    if p.ordinary > 0 then
                        h.priorityPositive = h.priorityPositive + 1
                    end
                    h.failures = h.failures + p.failures
                end
                if reaction == "hostile" then
                    h.hostileEvents = h.hostileEvents + 1
                    h.hostileMax = math.max(h.hostileMax, base.ordinary)
                elseif reaction == "friendly" then
                    h.friendlyEvents = h.friendlyEvents + 1
                    h.friendlyMax = math.max(h.friendlyMax, base.ordinary)
                else
                    h.unknownEvents = h.unknownEvents + 1
                end
                h.last = base.secret > 0 and "restricted"
                    or base.failures > 0 and "read-failure"
                    or base.ordinary > 0 and "ordinary"
                    or base.empty > 0 and "ordinary-empty"
                    or "indeterminate"
            else
                h.last = present == false and "unit-absent"
                    or "unit-unreadable"
            end
        end
    end
end

function Engine.GetEventHistory()
    local groups = {}
    for _, spec in ipairs(GROUPS) do
        local h = eventHistory[spec.key]
        local copy = { key = spec.key }
        for k, v in pairs(h) do copy[k] = v end
        groups[#groups + 1] = copy
    end
    return { groups = groups, unexpectedFailures = unexpectedFailures,
        sessionOnly = true }
end
