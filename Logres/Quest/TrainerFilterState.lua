-- P0311: read-only, ordinary trainer filter visibility; never mutate filters.
-- A hidden Known category does NOT prove any particular rank exists or is owned.
local _, Logres = ...
local State = {}
Logres.NPCTrainerFilterState = State
local reads, last = 0, {status="not-read", used="unknown",
    available="unknown", unavailable="unknown"}
local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end
local function filter(fn, category)
    local ok, value = pcall(fn, category)
    if not ok or not ordinary(value) then return "unknown" end
    if value == true or value == 1 then return "on" end
    if value == false or value == 0 then return "off" end
    return "unknown"
end
function State.Read()
    reads = reads + 1
    local result = {status="unavailable", used="unknown",
        available="unknown", unavailable="unknown"}
    local ok, fn = pcall(function() return _G.GetTrainerServiceTypeFilter end)
    if ok and ordinary(fn) and type(fn) == "function" then
        result.used = filter(fn, "used")
        result.available = filter(fn, "available")
        result.unavailable = filter(fn, "unavailable")
        result.status = "read-only-filter-state"
    end
    last = result
    return {status=result.status, used=result.used,
        available=result.available, unavailable=result.unavailable}
end
function State.GetAudit()
    return {reads=reads, status=last.status, used=last.used,
        available=last.available, unavailable=last.unavailable,
        nativeFilterWrites=0, nativeTransactions=0}
end
return State
