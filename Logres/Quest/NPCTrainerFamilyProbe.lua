-- P0307: one-shot READ-ONLY native trainer family compatibility probe.
-- A profession trainer is a new adapter case, not authorization to train or
-- park stock. Only separately ordinary native results are classified here.
local _, Logres = ...
local Probe = {}
Logres.NPCTrainerFamilyProbe = Probe
local checks = 0

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
    local ok, result = pcall(fn, ...)
    if not ok or not ordinary(result) then return nil end
    return result
end

local function read(root, key)
    if not ordinary(root) then return nil end
    local ok, method = pcall(function() return root[key] end)
    if not ok or not ordinary(method) or type(method) ~= "function" then return nil end
    return scalar(method, root)
end

function Probe.Read()
    checks = checks + 1
    local state = Logres:GetState() -- already-normalized, addon-owned state
    local output = {check=checks, status="deferred", interactionType="unknown",
        interacting=false, nativeRoot="unavailable", nativeShown="unknown",
        nativeProtected="unknown", professionTrainer="unknown",
        serviceCount="unknown", service1="unavailable",
        service1Type="unknown", service1Rank="unknown",
        live="unknown", source="not-read", session="unknown",
        transactions=0, nativeWrites=0}
    if state and type(state.interactionType) == "number" then
        output.interactionType = state.interactionType
        output.interacting = state.interacting == true
    end
    local session = Logres.NPCServiceSession
    if session and type(session.GetAudit) == "function" then
        local ok, audit = pcall(session.GetAudit)
        if ok and type(audit) == "table" then
            output.session = audit.last or "unknown" -- addon-owned result
            output.ready = audit.lastReadinessEvent or "unknown"
        end
    end
    local trial = Logres.NPCTrainerLiveTrial
    if trial and type(trial.GetAudit) == "function" then
        local ok, audit = pcall(trial.GetAudit)
        if ok and type(audit) == "table" then
            output.live = audit.shown == true and "shown" or "not-shown"
        end
    end
    if scalar(api("InCombatLockdown")) ~= false then
        output.status = "combat-or-secret-deferred"
        return output
    end
    local ok, root = pcall(function() return _G.ClassTrainerFrame end)
    if not ok or not ordinary(root) or root == nil then
        output.status = "native-trainer-frame-unavailable"
        return output
    end
    output.nativeRoot = "present"
    local protected = read(root, "IsProtected")
    local shown = read(root, "IsShown")
    if type(protected) == "boolean" then
        output.nativeProtected = protected and "yes" or "no"
    end
    if type(shown) == "boolean" then
        output.nativeShown = shown and "yes" or "no"
    end
    if protected ~= false or shown ~= true then
        output.status = "native-not-ordinary-shown"
        return output
    end
    local profession = scalar(api("IsTradeskillTrainer"))
    if type(profession) == "boolean" then
        output.professionTrainer = profession and "yes" or "no"
    end
    local count = scalar(api("GetNumTrainerServices"))
    if type(count) ~= "number" or count < 0 or count > 384
        or count ~= math.floor(count) then
        output.status = "trainer-count-unavailable"
        return output
    end
    output.serviceCount = count
    -- Never infer a native purchase from this read. Observe only the first
    -- entry's individually ordinary label/kind/rank; do not inspect secrets.
    local info = api("GetTrainerServiceInfo")
    if not info or count == 0 then
        output.status = info and "native-service-list-empty" or "service-api-unavailable"
        return output
    end
    local called, name, serviceType, texture, reqLevel, rank = pcall(info, 1)
    if not called then
        output.status = "first-service-call-failed"
        return output
    end
    if ordinary(name) and type(name) == "string" and #name <= 100 then
        output.service1 = "readable"
    end
    if ordinary(serviceType) and type(serviceType) == "string"
        and #serviceType <= 32 then
        output.service1Type = serviceType
    end
    if ordinary(rank) and type(rank) == "string" and #rank <= 35 then
        output.service1Rank = "readable"
    end
    if ordinary(texture) and type(texture) == "number" and ordinary(reqLevel)
        and type(reqLevel) == "number" then
        output.source = "forever-six-field-candidate"
    else
        output.source = "nonstandard-or-deferred-field-shape"
    end
    output.status = "trainer-family-observed"
    return output
end

return Probe
