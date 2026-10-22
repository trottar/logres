-- P0303: data-only, source-neutral NPC catalogue operations.
-- The caller supplies addon-owned ordinary records and explicit predicates.
-- No native API reads, UI mutation, transactions, timers, or frame ownership.
local _, Logres = ...
local Catalogue = {}
Logres.NPCServiceCatalogue = Catalogue

-- Return a fresh visible collection in original source order. The callback
-- decides search, category and eligibility; no hidden native filters are read.
function Catalogue.Filter(records, include)
    if type(records) ~= "table" or type(include) ~= "function" then return nil end
    local matching = {}
    for i = 1, #records do
        local record = records[i]
        if include(record) then matching[#matching + 1] = record end
    end
    return matching
end

-- One bounded, clamped page. A scrolled slot is never a service identity.
-- Empty collections yield an empty page, not an invented selection.
function Catalogue.Window(records, offset, visible)
    if type(records) ~= "table" or type(offset) ~= "number"
        or type(visible) ~= "number" or visible < 1 or visible > 64
        or visible ~= math.floor(visible) or offset ~= math.floor(offset) then
        return nil
    end
    local lastStart = math.max(1, #records - visible + 1)
    local first = math.max(1, math.min(offset, lastStart))
    local finish = #records == 0 and 0 or math.min(#records, first + visible - 1)
    local page = {}
    for i = first, finish do page[#page + 1] = records[i] end
    return page, first, lastStart, finish
end

-- Resolve in the captured source, never through a sorted/filtered row index.
-- Callers choose a stable ID field and remain responsible for its provenance.
function Catalogue.Find(records, key, identify)
    if type(records) ~= "table" or key == nil
        or type(identify) ~= "function" then return nil end
    for i = 1, #records do
        local record = records[i]
        if identify(record) == key then return record end
    end
    return nil
end

return Catalogue
