-- P0296: guarded one-service purchase; P0301 adds separate, explicit class-only bulk requests.
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
    -- P0309: the class single-service controller must never handle a
    -- profession or unknown-family purchase. Its own adapter owns that.
    if scalar(api("IsTradeskillTrainer")) ~= false then
        return deny("profession-or-unknown-class-purchase-deferred")
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

-- P0301: bounded, user-initiated class-trainer bulk purchase capability.
-- Independent of the single-service trial: never auto-repeat or hide stock.
local bulkAttempts, bulkRequests, bulkDeferrals, bulkFailures = 0, 0, 0, 0
local bulkLast = "not-attempted"

local function bulkDeny(why)
    bulkDeferrals = bulkDeferrals + 1
    bulkLast = why
    return false, why
end

-- Read one native service only after confirming each value is ordinary.
local function bulkRow(index, info, cost)
    local ok, name, kind, texture, requiredLevel, rank = pcall(info, index)
    if not ok or not ordinary(name) or not ordinary(kind)
        or not ordinary(texture) or not ordinary(requiredLevel)
        or not ordinary(rank) then return nil end
    if type(kind) ~= "string" or (kind ~= "available" and
        kind ~= "unavailable" and kind ~= "used" and kind ~= "header") then return nil end
    if kind ~= "available" then return {index=index, kind=kind} end
    if type(name) ~= "string" or #name < 1 or #name > 100
        or not integer(texture, 1000000000) or texture == 0
        or not integer(requiredLevel, 120)
        or type(rank) ~= "string" or #rank > 35 then return nil end
    local costOK, copper, slot = pcall(cost, index)
    if not costOK or not ordinary(copper) or not ordinary(slot)
        or not integer(copper, 100000000000) or slot == true then return nil end
    return {index=index, kind=kind, name=name, texture=texture,
        requiredLevel=requiredLevel, rank=rank, copper=copper}
end

local function bulkContext(countExpected, trainerExpected)
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7
        or scalar(api("InCombatLockdown")) ~= false
        or scalar(api("IsTradeskillTrainer")) ~= false then
        return nil, "not-ordinary-class-trainer"
    end
    local okRoot, root = pcall(function() return _G.ClassTrainerFrame end)
    if not okRoot or not ordinary(root) or root == nil
        or read(root, "IsProtected") ~= false
        or read(root, "IsShown") ~= true then
        return nil, "native-trainer-inaccessible"
    end
    local name = scalar(api("UnitName"), "npc")
    local count = scalar(api("GetNumTrainerServices"))
    local money = scalar(api("GetMoney"))
    local info, cost = api("GetTrainerServiceInfo"), api("GetTrainerServiceCost")
    local buy = api("BuyTrainerService")
    if type(name) ~= "string" or #name < 1 or #name > 90
        or not integer(count, 384) or count == 0
        or not integer(money, 100000000000)
        or not info or not cost or not buy
        or (countExpected ~= nil and count ~= countExpected)
        or (trainerExpected ~= nil and name ~= trainerExpected) then
        return nil, "native-bulk-source-changed"
    end
    return {count=count, trainer=name, money=money, info=info, cost=cost,
        buy=buy}
end

-- One complete scan on opening the live trainer; no polling or native writes.
function Trial.QuoteAll(expectedCount, expectedTrainer)
    local source, why = bulkContext(expectedCount, expectedTrainer)
    if not source then return nil, why end
    local offers, total = {}, 0
    for index = 1, source.count do
        local row = bulkRow(index, source.info, source.cost)
        if not row then return nil, "bulk-service-unreadable" end
        if row.kind == "available" then
            if total + row.copper > 100000000000 then
                return nil, "bulk-total-invalid"
            end
            offers[#offers + 1] = row
            total = total + row.copper
        end
    end
    if #offers == 0 then return nil, "no-available-services" end
    return {count=source.count, trainer=source.trainer,
        money=source.money, total=total, offers=offers,
        affordable=source.money >= total}, "bulk-quote-ready"
end

local function bulkSame(first, second)
    return first and second and first.index == second.index
        and first.kind == second.kind and first.name == second.name
        and first.texture == second.texture
        and first.requiredLevel == second.requiredLevel
        and first.rank == second.rank and first.copper == second.copper
end

-- Called only from the deliberately clicked Logres Train All region.
-- A mid-batch change stops further purchases; previous requests are never retried.
function Trial.AttemptAll(quoted, snapshot)
    bulkAttempts = bulkAttempts + 1
    if type(quoted) ~= "table" or type(snapshot) ~= "table"
        or quoted.affordable ~= true or not integer(quoted.count, 384)
        or quoted.count ~= snapshot.total or quoted.trainer ~= snapshot.trainerName
        or type(quoted.offers) ~= "table" or #quoted.offers < 1 then
        return bulkDeny("bulk-quote-or-session-invalid")
    end
    local fresh, why = Trial.QuoteAll(snapshot.total, snapshot.trainerName)
    if not fresh then return bulkDeny(why) end
    if not fresh.affordable or fresh.total ~= quoted.total
        or #fresh.offers ~= #quoted.offers then
        return bulkDeny("bulk-offer-or-funds-changed")
    end
    for i = 1, #fresh.offers do
        if not bulkSame(fresh.offers[i], quoted.offers[i]) then
            return bulkDeny("bulk-offer-identity-changed")
        end
    end
    local issued = 0
    local function stop(reason)
        if issued > 0 then
            bulkRequests = bulkRequests + issued
            bulkLast = "bulk-partial-" .. reason
            bulkFailures = bulkFailures + 1
            return true, bulkLast -- stale snapshot must hide, stock remains usable
        end
        return bulkDeny(reason)
    end
    for _, row in ipairs(fresh.offers) do
        local source, reason = bulkContext(snapshot.total, snapshot.trainerName)
        if not source then return stop(reason) end
        local now = bulkRow(row.index, source.info, source.cost)
        if not bulkSame(now, row) or source.money < row.copper then
            return stop("service-or-funds-changed")
        end
        local ok = pcall(source.buy, row.index)
        if not ok then return stop("purchase-api-error") end
        issued = issued + 1
    end
    bulkRequests = bulkRequests + issued
    bulkLast = "bulk-requests-sent-unconfirmed"
    return true, bulkLast
end

function Trial.GetBulkAudit()
    return {attempts=bulkAttempts, requested=bulkRequests,
        deferrals=bulkDeferrals, failures=bulkFailures, last=bulkLast}
end

function Trial.GetAudit()
    return {attempts=attempts, requested=requested, deferred=deferred,
        failures=failed, last=last}
end
return Trial
