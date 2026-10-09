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
