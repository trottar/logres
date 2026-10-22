-- P0310: a service-neutral, data-only empty catalogue presentation state.
-- A zero-row source is NOT proof of a known profession, an available purchase,
-- or even that the NPC has a skill the character may currently learn.
-- Views render placeholder information only; they never acquire native identity.
local _, Logres = ...
local Empty = {}
Logres.NPCServiceEmptyState = Empty

local function bounded(value, limit)
    return type(value) == "string" and #value > 0 and #value <= limit
end

function Empty.Build(spec)
    if type(spec) ~= "table" or not bounded(spec.name, 100)
        or not bounded(spec.note, 90) or not bounded(spec.detail, 300)
        or not bounded(spec.icon, 180) then return nil end
    return {
        catalog = {},
        row = {name=spec.name, requirement=spec.note, price="",
            icon=spec.icon, selected=false, disabled=true},
        selected = {name=spec.name, requirement=spec.note,
            description=spec.detail, icon=spec.icon},
    }
end

return Empty
