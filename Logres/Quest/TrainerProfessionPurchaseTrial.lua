-- P0309: explicit single-service profession training through the native trainer.
-- Separate from class Train All. Fail open to VISIBLE Blizzard trainer controls.
-- Never run on a preview, hover, selection, session event, or native refresh.
local _, Logres = ...
local Trial = {}
Logres.NPCTrainerProfessionPurchaseTrial = Trial
local attempts, requests, deferrals, failures = 0, 0, 0, 0
local last = "not-attempted"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end
local function api(name)
    local ok, fn = pcall(function() return _G[name] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end
local function scalar(fn, ...)
    if not fn then return nil end
    local ok, value = pcall(fn, ...)
    if not ok or not ordinary(value) then return nil end
    return value
end
local function read(root, key)
    if not ordinary(root) then return nil end
    local ok, fn = pcall(function() return root[key] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return scalar(fn, root)
end
local function integer(value, maximum)
    return type(value) == "number" and value >= 0 and value <= maximum
        and value == math.floor(value)
end
local function deny(reason)
    deferrals = deferrals + 1
    last = reason
    return false, reason
end

-- Only one physical click on an explicitly selected available profession row.
-- Native identity/cost/skill requirements are re-read after the click; cached
-- view data is never authority to buy. The native root stays visible.
function Trial.Attempt(row, snapshot)
    attempts = attempts + 1
    if type(row) ~= "table" or type(snapshot) ~= "table"
        or snapshot.profession ~= true or row.sourceType ~= "available"
        or not integer(row.serviceIndex, 384) or row.serviceIndex < 1
        or type(row.sourceName) ~= "string" or #row.sourceName < 1
        or #row.sourceName > 100 or type(row.sourceRank) ~= "string"
        or #row.sourceRank > 35
        or not integer(row.sourceTextureID, 1000000000)
        or not integer(row.costCopper, 100000000000)
        or not integer(snapshot.total, 384)
        or type(snapshot.trainerName) ~= "string" then
        return deny("captured-service-or-family-unavailable")
    end
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7
        or scalar(api("InCombatLockdown")) ~= false
        or scalar(api("IsTradeskillTrainer")) ~= true then
        return deny("profession-session-or-combat-deferred")
    end
    local okRoot, root = pcall(function() return _G.ClassTrainerFrame end)
    if not okRoot or not ordinary(root) or root == nil
        or read(root, "IsProtected") ~= false
        or read(root, "IsShown") ~= true then
        return deny("stock-trainer-not-available")
    end
    if scalar(api("UnitName"), "npc") ~= snapshot.trainerName then
        return deny("trainer-identity-changed")
    end
    local count = scalar(api("GetNumTrainerServices"))
    if not integer(count, 384) or count ~= snapshot.total
        or row.serviceIndex > count then return deny("service-list-changed") end
    local info, cost, buy = api("GetTrainerServiceInfo"), api("GetTrainerServiceCost"), api("BuyTrainerService")
    local skill, money = api("GetTrainerServiceSkillReq"), scalar(api("GetMoney"))
    if not info or not cost or not buy or not integer(money, 100000000000) then
        return deny("native-source-or-funds-unavailable")
    end
    local infoOK, name, kind, texture, level, rank = pcall(info, row.serviceIndex)
    if not infoOK or not ordinary(name) or not ordinary(kind)
        or not ordinary(texture) or not ordinary(level) or not ordinary(rank) then
        return deny("secret-or-unreadable-service")
    end
    if name ~= row.sourceName or kind ~= "available"
        or texture ~= row.sourceTextureID or rank ~= row.sourceRank
        or not integer(level, 120)
        or (row.sourceRequiredLevel ~= nil and level ~= row.sourceRequiredLevel) then
        return deny("service-identity-or-requirement-changed")
    end
    if row.sourceSkillRequirement ~= nil or row.sourceSkillRank ~= nil then
        if not skill then return deny("skill-prerequisite-api-unavailable") end
        local skillOK, skillName, skillRank, hasRequirement = pcall(skill, row.serviceIndex)
        if not skillOK or not ordinary(skillName) or not ordinary(skillRank)
            or not ordinary(hasRequirement) then
            return deny("skill-prerequisite-deferred")
        end
        if (row.sourceSkillRequirement ~= nil and skillName ~= row.sourceSkillRequirement)
            or (row.sourceSkillRank ~= nil and skillRank ~= row.sourceSkillRank) then
            return deny("skill-prerequisite-changed")
        end
    end
    -- Forever API may return non-money talent/profession costs separately.
    -- Unknown or positive extra costs are NOT silently treated as copper.
    local costOK, copper, talentCost, professionCost = pcall(cost, row.serviceIndex)
    if not costOK or not ordinary(copper) or not ordinary(talentCost)
        or not ordinary(professionCost) then return deny("cost-secret-or-unreadable") end
    if not integer(copper, 100000000000) or copper ~= row.costCopper
        or (talentCost ~= nil and talentCost ~= 0)
        or (professionCost ~= nil and professionCost ~= 0)
        or money < copper then return deny("cost-resources-or-funds-changed") end
    local sent = pcall(buy, row.serviceIndex)
    if not sent then
        failures = failures + 1
        last = "profession-purchase-call-failed-stock-visible"
        return false, last
    end
    requests = requests + 1
    last = "profession-single-request-sent-unconfirmed"
    return true, last
end

function Trial.GetAudit()
    return {attempts=attempts, requests=requests, deferrals=deferrals,
        failures=failures, last=last, bulkRequests=0, nativeParkingWrites=0}
end
return Trial
