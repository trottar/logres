-- P0308: explicit class-trainer native Goodbye request.
-- Keep this service-specific operation OUTSIDE the shared NPC session,
-- shared catalogue, and renderer. Stock is restored by the caller FIRST.
-- On any unavailable API, ambiguity or failure, leave Blizzard stock usable.
local _, Logres = ...
local Close = {}
Logres.NPCTrainerCloseTrial = Close

local checks, requests, deferrals, failures = 0, 0, 0, 0
local last = "not-requested"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function api(name)
    local ok, value = pcall(function() return _G[name] end)
    if not ok or not ordinary(value) or type(value) ~= "function" then return nil end
    return value
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

-- Only a deliberate physical Goodbye click may call RequestClose. Class-only
-- preflight deliberately excludes profession trainers and ambiguous states.
local function gate()
    local state = Logres:GetState()
    if not state or state.interacting ~= true or state.interactionType ~= 7 then
        return nil, "not-class-trainer-interaction"
    end
    if scalar(api("InCombatLockdown")) ~= false then
        return nil, "combat-or-secret-deferred"
    end
    if scalar(api("IsTradeskillTrainer")) ~= false then
        return nil, "profession-or-unclassified-trainer"
    end
    local okRoot, root = pcall(function() return _G.ClassTrainerFrame end)
    if not okRoot or not ordinary(root) or root == nil
        or read(root, "IsProtected") ~= false
        or read(root, "IsShown") ~= true then
        return nil, "native-root-not-safe-and-shown"
    end
    local close = api("CloseTrainer")
    if not close then return nil, "native-close-api-unavailable" end
    return close, "ready"
end

function Close.CanClose()
    checks = checks + 1
    local fn, why = gate()
    return fn ~= nil, why
end

function Close.RequestClose()
    local fn, why = gate()
    if not fn then
        deferrals = deferrals + 1
        last = why
        return false, why
    end
    -- One native close request, after caller restored Blizzard anchors.
    -- The native close event confirms actual session teardown; this only
    -- records an issued request and never retries or asserts closure.
    local ok = pcall(fn)
    if not ok then
        failures = failures + 1
        last = "native-close-call-failed-stock-visible"
        return false, last
    end
    requests = requests + 1
    last = "native-close-request-sent-unconfirmed"
    return true, last
end

function Close.GetAudit()
    return {checks=checks, requests=requests, deferrals=deferrals,
        failures=failures, last=last, family="class-only",
        nativeCloseConfirmed=false, nativePurchases=0}
end

return Close
