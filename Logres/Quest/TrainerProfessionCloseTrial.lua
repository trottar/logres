-- P0311: one guarded native Goodbye for profession trainer sessions.
-- The caller restores any parked Blizzard root BEFORE requesting native close.
-- No native transaction, UI suppression, polling or inferred profession ownership.
local _, Logres = ...
local Close = {}
Logres.NPCTrainerProfessionCloseTrial = Close
local checks, requests, deferrals, failures = 0, 0, 0, 0
local last = "not-requested"

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
    local ok, result = pcall(fn, ...)
    if not ok or not ordinary(result) then return nil end
    return result
end
local function read(root, name)
    if not ordinary(root) then return nil end
    local ok, method = pcall(function() return root[name] end)
    if not ok or not ordinary(method) or type(method) ~= "function" then return nil end
    return scalar(method, root)
end
local function gate()
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7 then
        return nil, "trainer-session-ended"
    end
    if scalar(api("InCombatLockdown")) ~= false then
        return nil, "combat-or-secret-deferred"
    end
    if scalar(api("IsTradeskillTrainer")) ~= true then
        return nil, "not-ordinary-profession-trainer"
    end
    local ok, root = pcall(function() return _G.ClassTrainerFrame end)
    if not ok or not ordinary(root) or root == nil
        or read(root, "IsProtected") ~= false
        or read(root, "IsShown") ~= true then
        return nil, "native-trainer-unavailable"
    end
    local fn = api("CloseTrainer")
    if not fn then return nil, "native-close-unavailable" end
    return fn, "ready"
end
function Close.CanClose()
    checks = checks + 1
    local fn, reason = gate()
    return fn ~= nil, reason
end
function Close.RequestClose()
    local fn, reason = gate()
    if not fn then
        deferrals = deferrals + 1
        last = reason
        return false, reason
    end
    -- Exactly one native close request following successful Logres dismissal.
    local sent = pcall(fn)
    if not sent then
        failures = failures + 1
        last = "profession-native-close-failed-stock-visible"
        return false, last
    end
    requests = requests + 1
    last = "profession-native-close-requested-unconfirmed"
    return true, last
end
function Close.GetAudit()
    return {checks=checks, requests=requests, deferrals=deferrals,
        failures=failures, last=last, nativeConfirmed=false,
        family="profession-only", transactions=0}
end
return Close
