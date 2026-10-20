-- P0276: on-demand, READ-ONLY trainer-region feasibility inventory.
-- This is separate from the broad P0270 capability audit. No stock frame is
-- resized, hidden, reparented, recolored, hooked, or given a new script here.
-- Every native result is gated before comparison, formatting or inspection.
local _, Logres = ...
local Audit = {}
Logres.NPCNativeTrainerRegionAudit = Audit

local reads = 0
local NAMES = {
    "ClassTrainerFrame", "ClassTrainerFramePortrait", "ClassTrainerNameText",
    "ClassTrainerGreetingText", "ClassTrainerFrameFilterDropDown",
    "ClassTrainerFrameFilterDropdown", "ClassTrainerListScrollFrame",
    "ClassTrainerDetailScrollFrame", "ClassTrainerSkillIcon",
    "ClassTrainerMoneyFrame", "ClassTrainerFrameMoneyFrame",
    "ClassTrainerDetailMoneyFrame", "ClassTrainerTrainButton",
    "ClassTrainerCancelButton", "ClassTrainerFrameCloseButton",
    "ClassTrainerExpandButtonFrame", "ClassTrainerCollapseAllButton",
    "ClassTrainerStatusBar", "ClassTrainerFrameBottomInset",
    "ClassTrainerFrameSkillStepButton", "ClassTrainerSkill1",
    "ClassTrainerFrame.ScrollBox", "ClassTrainerFrame.ScrollBar",
    "ClassTrainerFrame.FilterDropdown", "ClassTrainerFrame.money",
    "ClassTrainerFrame.trainingPoints", "ClassTrainerTrainAllButton",
    "ClassTrainerFrameTrainAllButton", "ClassTrainerFrame.TrainAllButton",
}

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function method(object, key)
    if not ordinary(object) then return nil end
    local ok, fn = pcall(function() return object[key] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function read(object, key)
    local fn = method(object, key)
    if not fn then return nil end
    local ok, value = pcall(fn, object)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function number(object, key)
    local v = read(object, key)
    if type(v) == "number" and v >= 0 and v < 100000 then
        return math.floor(v * 10 + 0.5) / 10
    end
    return "?"
end

local function flag(object, key)
    local v = read(object, key)
    if type(v) == "boolean" then return v and "yes" or "no" end
    return "unknown"
end

local function objectType(object)
    local value = read(object, "GetObjectType")
    if type(value) == "string" and #value <= 40 then return value end
    return "unknown"
end

local function inspect(name, object)
    if not ordinary(object) then
        return { name = name, status = "deferred-secret-or-api" }
    end
    if object == nil then return { name = name, status = "absent" } end
    if type(object) ~= "table" and type(object) ~= "userdata" then
        return { name = name, status = "unexpected-type" }
    end
    return { name = name, status = "present", kind = objectType(object),
        width = number(object, "GetWidth"), height = number(object, "GetHeight"),
        points = number(object, "GetNumPoints"),
        regions = number(object, "GetNumRegions"),
        protected = flag(object, "IsProtected"),
        shown = flag(object, "IsShown"),
        mouse = flag(object, "IsMouseEnabled"),
        setPoint = method(object, "SetPoint") and "yes" or "no",
        setAlpha = method(object, "SetAlpha") and "yes" or "no",
        setTexture = method(object, "SetTexture") and "yes" or "no" }
end

local function globalObject(name)
    local ok, object = pcall(function() return _G[name] end)
    if not ok or not ordinary(object) then return nil, false end
    return object, true
end

-- Texture identity is an ordinary READ, never a permission to modify it.
local function regionToken(region)
    local texture = read(region, "GetTexture")
    if type(texture) == "string" then
        return texture:sub(1, 100):gsub("[%c]", "?")
    end
    if type(texture) == "number" then return "file:" .. tostring(texture) end
    local atlas = read(region, "GetAtlas")
    if type(atlas) == "string" then
        return "atlas:" .. atlas:sub(1, 90):gsub("[%c]", "?")
    end
    return "unavailable"
end

function Audit.Read()
    reads = reads + 1
    local result = { request = reads, status = "deferred", controls = {},
        regions = {}, nativeMutations = 0, transactionCalls = 0,
        geometryWrites = 0, maxRegions = 16 }
    local state = Logres:GetState() -- addon-owned normalized interaction only
    if not state or state.interacting ~= true or state.interactionType ~= 7 then
        result.status = "open-trainer-required"
        return result
    end
    local combat = nil
    if type(InCombatLockdown) == "function" then
        local ok, value = pcall(InCombatLockdown)
        if ok and ordinary(value) then combat = value end
    end
    if combat ~= false then
        result.status = "combat-or-capability-deferred"
        return result
    end
    local frame, available = globalObject("ClassTrainerFrame")
    if not available or frame == nil then
        result.status = "native-frame-unavailable"
        return result
    end
    if read(frame, "IsProtected") ~= false or read(frame, "IsShown") ~= true then
        result.status = "protected-or-not-shown"
        return result
    end
    result.status = "read-only-inventory"
    result.children = number(frame, "GetNumChildren")
    result.frameRegions = number(frame, "GetNumRegions")
    for i = 1, #NAMES do
        local name = NAMES[i]
        local object, known
        local child = name:match("^ClassTrainerFrame%.([%w_]+)$")
        if child then
            local ok, value = pcall(function() return frame[child] end)
            known = ok and ordinary(value)
            if known then object = value end
        else
            object, known = globalObject(name)
        end
        result.controls[#result.controls + 1] = known and inspect(name, object)
            or { name = name, status = "deferred-secret-or-api" }
    end
    -- For the root's bounded direct decorative regions only, report the
    -- actual client region type and *ordinary* texture/atlas identity.
    -- Do not inspect native GetPoint tokens or any protected presentation state.
    local getRegions = method(frame, "GetRegions")
    if getRegions and type(result.frameRegions) == "number" then
        local ok, regions = pcall(function() return { getRegions(frame) } end)
        if ok and type(regions) == "table" then
            local limit = math.min(result.frameRegions, result.maxRegions)
            for i = 1, limit do
                local region = regions[i]
                if ordinary(region) and region ~= nil then
                    result.regions[#result.regions + 1] = {
                        index = i, kind = objectType(region),
                        texture = regionToken(region),
                        layer = read(region, "GetDrawLayer"),
                        alpha = number(region, "GetAlpha"),
                        shown = flag(region, "IsShown"),
                        setAlpha = method(region, "SetAlpha") and "yes" or "no",
                        setTexture = method(region, "SetTexture") and "yes" or "no",
                    }
                else
                    result.regions[#result.regions + 1] = {
                        index = i, kind = "deferred-secret", texture = "unavailable",
                        shown = "unknown", layer = "unknown", alpha = "?",
                        setAlpha = "no", setTexture = "no" }
                end
            end
        else
            result.regionRead = "deferred"
        end
    end
    return result
end

return Audit
