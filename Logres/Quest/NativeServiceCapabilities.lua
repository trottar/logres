-- P0270: on-demand, read-only evidence of native NPC service frame capability.
-- D-047: Blizzard owns every native transaction, secure control and camera.
-- Do not query native frame visibility, location, geometry, children, input or scripts.
local _, Logres = ...
local Probe = {}
Logres.NPCNativeServiceCapabilities = Probe

-- Names are candidate source hints, not verified Forever frame identities.
-- A missing global may simply belong to an unloaded Blizzard addon.
local FRAMES = {
    { key = "gossip", name = "GossipFrame" },
    { key = "merchant-repairs-sell", name = "MerchantFrame" },
    { key = "trainer", name = "ClassTrainerFrame" },
    { key = "flight", name = "FlightMapFrame" },
    { key = "bank", name = "BankFrame" },
    { key = "auction", name = "AuctionHouseFrame" },
    { key = "stable", name = "PetStableFrame" },
    { key = "guild-tabard", name = "TabardFrame" },
}

local reads = 0

-- Never branch on/type/format a secret-capable value before checking.
-- If the secret API is unavailable, do not inspect native frame values.
local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function safeMethod(frame, name)
    local ok, method = pcall(function() return frame[name] end)
    if not ok or not ordinary(method) then return nil end
    if type(method) ~= "function" then return false end
    return method
end

local function inspect(name)
    local item = { loaded = "deferred", protected = "unknown",
        pointRead = "unknown", pointWrite = "unknown" }
    local ok, frame = pcall(function() return _G[name] end)
    if not ok or not ordinary(frame) then return item end
    if frame == nil then item.loaded = "not-loaded"; return item end
    local kind = type(frame)
    if kind ~= "table" and kind ~= "userdata" then
        item.loaded = "unexpected-type"
        return item
    end
    item.loaded = "present"
    local read = safeMethod(frame, "GetPoint")
    if read == false then item.pointRead = "absent"
    elseif read then item.pointRead = "method-present" end
    local write = safeMethod(frame, "SetPoint")
    if write == false then item.pointWrite = "absent"
    elseif write then item.pointWrite = "method-present" end
    local protect = safeMethod(frame, "IsProtected")
    if protect == false then
        item.protected = "method-absent"
    elseif protect then
        local called, flag = pcall(protect, frame)
        if called and ordinary(flag) and type(flag) == "boolean" then
            item.protected = flag and "yes" or "no"
        end
    end
    return item
end

function Probe.Read()
    reads = reads + 1
    local state = Logres:GetState() -- Normalized addon-owned interaction context.
    local result = { source = "on-demand-native-metadata",
        request = reads, interacting = state and state.interacting == true or false,
        interactionType = state and state.interactionType or 0,
        rows = {}, present = 0, missing = 0, deferred = 0,
        mutationCalls = 0, serviceIdentity = "unverified",
        placementAuthorization = "none", stylingAuthorization = "none" }
    local safe, inCombat = pcall(function()
        return type(InCombatLockdown) == "function" and InCombatLockdown()
    end)
    local mayInspect = safe and ordinary(inCombat) and inCombat == false
    for i = 1, #FRAMES do
        local entry = FRAMES[i]
        local status = mayInspect and inspect(entry.name) or
            { loaded = "deferred-combat-or-api", protected = "unknown",
              pointRead = "unknown", pointWrite = "unknown" }
        status.key = entry.key
        status.name = entry.name
        result.rows[#result.rows + 1] = status
        if status.loaded == "present" then
            result.present = result.present + 1
        elseif status.loaded == "not-loaded" then
            result.missing = result.missing + 1
        else
            result.deferred = result.deferred + 1
        end
    end
    return result
end

return Probe
