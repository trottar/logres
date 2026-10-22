-- P0296: one explicit Logres trainer purchase request, never Train All.
-- Every purchase revalidates the native source; any ambiguity leaves stock UI usable.
local _, Logres = ...
local Trial = {}
Logres.NPCTrainerPurchaseTrial = Trial

local attempts, requested, deferred, failed = 0, 0, 0, 0
local last = "not-attempted"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function api(key)
    local ok, value = pcall(function() return _G[key] end)
    if not ok or not ordinary(value) or type(value) ~= "function" then return nil end
    return value
end

local function scalar(fn, ...)
    if not fn then return nil end
    local ok, value = pcall(fn, ...)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function read(owner, key)
    if not ordinary(owner) then return nil end
    local ok, method = pcall(function() return owner[key] end)
    if not ok or not ordinary(method) or type(method) ~= "function" then return nil end
    return scalar(method, owner)
end

local function integer(value, maximum)
    return type(value) == "number" and value >= 0 and value <= maximum
        and value == math.floor(value)
end

local function deny(why)
    deferred = deferred + 1
    last = why
    return false, why
end

-- Called ONLY from a visible, addon-owned, physical left-click on Train TEST.
-- The snapshot is descriptive input; no cached eligibility is trusted for spending.
function Trial.Attempt(row, snapshot)
    attempts = attempts + 1
    if type(row) ~= "table" or type(snapshot) ~= "table"
        or row.sourceType ~= "available" or not integer(row.serviceIndex, 384)
        or row.serviceIndex < 1 or type(row.sourceName) ~= "string"
        or #row.sourceName < 1 or #row.sourceName > 100
        or type(row.sourceRank) ~= "string" or #row.sourceRank > 35
        or not integer(row.sourceTextureID, 1000000000)
        or not integer(row.costCopper, 100000000000)
        or not integer(snapshot.total, 384)
        or type(snapshot.trainerName) ~= "string" then
        return deny("cached-identity-or-cost-deferred")
    end
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7 then
        return deny("trainer-session-ended")
    end
    if scalar(api("InCombatLockdown")) ~= false then
        return deny("combat-or-secret-deferred")
    end
    local okRoot, root = pcall(function() return _G.ClassTrainerFrame end)
    if not okRoot or not ordinary(root) or root == nil then
        return deny("native-trainer-unavailable")
    end
    if read(root, "IsProtected") ~= false or read(root, "IsShown") ~= true then
        return deny("stock-trainer-protection-deferred")
    end
    local name = scalar(api("UnitName"), "npc")
    if name ~= snapshot.trainerName then return deny("trainer-identity-changed") end
    local count = scalar(api("GetNumTrainerServices"))
    if not integer(count, 384) or count ~= snapshot.total
        or row.serviceIndex > count then return deny("service-list-changed") end
    local info = api("GetTrainerServiceInfo")
    local cost = api("GetTrainerServiceCost")
    local wallet = scalar(api("GetMoney"))
    local buy = api("BuyTrainerService")
    if not info or not cost or not buy or not integer(wallet, 100000000000) then
        return deny("native-training-capability-deferred")
    end
    local infoOK, spellName, kind, texture, reqLevel, rank = pcall(info, row.serviceIndex)
    if not infoOK or not ordinary(spellName) or not ordinary(kind)
        or not ordinary(texture) or not ordinary(reqLevel)
        or not ordinary(rank) then return deny("service-secret-or-call-deferred") end
    if spellName ~= row.sourceName or kind ~= "available"
        or texture ~= row.sourceTextureID or rank ~= row.sourceRank
        or not integer(reqLevel, 120) then
        return deny("service-identity-or-eligibility-changed")
    end
    -- Source is six-field Forever; no numeric service-type guessing.
    if row.sourceRequiredLevel ~= nil and reqLevel ~= row.sourceRequiredLevel then
        return deny("service-requirement-changed")
    end
    local costOK, liveCost, professionSlot = pcall(cost, row.serviceIndex)
    if not costOK or not ordinary(liveCost) or not ordinary(professionSlot)
        or not integer(liveCost, 100000000000) or liveCost ~= row.costCopper
        or professionSlot == true or wallet < liveCost then
        return deny("cost-slot-or-funds-deferred")
    end
    -- One request for the explicitly selected service. No timer, retries or Train All.
    local buyOK = pcall(buy, row.serviceIndex)
    if not buyOK then
        failed = failed + 1
        last = "native-purchase-call-failed"
        return false, last
    end
    requested = requested + 1
    last = "single-purchase-request-sent-unconfirmed"
    return true, last
end

function Trial.GetAudit()
    return {attempts=attempts, requested=requested, deferred=deferred,
        failures=failed, last=last}
end
return Trial
