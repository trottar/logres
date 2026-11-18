-- P0477: extract actual source helper and exercise safe live-ID/range gates.
local root = (arg and arg[1]) or "."
local f = assert(io.open(root .. "/Logres/Navigation/Compass.lua", "rb"))
local s = f:read("*a"); f:close()
local i = assert(s:find("local function readNearbyNPCIDs()", 1, true))
local j = assert(s:find("-- A focus label may format", i, true))
local body = s:sub(i,j-1) .. "\nreturn readNearbyNPCIDs"
local guid, distance, secret = {}, {}, {}
local function isSecret(v) return v == "SECRET" end
local fakeAPI = {
    UnitGUID = function(token) return guid[token] end,
    InCombatLockdown = function() return false end,
    CheckInteractDistance = function(token, index)
        assert(index == 3, "unexpected proximity index")
        return distance[token]
    end,
}
local env = {
    _G = fakeAPI, type=type, ipairs=ipairs, pairs=pairs, pcall=pcall,
    isSecret=isSecret, string=string, tonumber=tonumber,
}
local chunk, err = load(body,"P0477_readNearbyNPCIDs_actual_source","t",env)
assert(chunk, err)
local read = chunk()
local function none() local ids = read(); return next(ids) == nil end
local function clear()
    for k in pairs(guid) do guid[k]=nil end
    for k in pairs(distance) do distance[k]=nil end
end
clear()
guid.npc = "Creature-0-123-456-789-17-abcdef"; distance.npc = true
assert(read()[17] == true, "ordinary, in-range interacting NPC must qualify")
clear()
guid.npc = "Creature-0-123-456-789-17-abcdef"; distance.npc = false
assert(read()[17] == nil, "same NPC across floors but out of range cannot qualify")
clear()
guid.npc = "SECRET"; distance.npc = true
assert(none(), "secret GUID cannot be inspected")
clear()
guid.npc = "Player-1234-5678"; distance.npc = true
assert(none(), "player GUID not an NPC")
clear()
guid.npc = "Creature-0-123-456-789-999-abcdef"; distance.npc = true
assert(read()[17] == nil and read()[999] == true, "different ID must not match")
clear()
guid.mouseover = "Creature-0-123-456-789-17-abcdef"; distance.mouseover = true
assert(read()[17] == true, "mouseover ID with range proof qualifies")
clear()
fakeAPI.InCombatLockdown = function() return true end
guid.npc = "Creature-0-123-456-789-17-abcdef"
assert(none(), "combat lockdown must skip native range API")
fakeAPI.InCombatLockdown = function() return false end
clear()
fakeAPI.CheckInteractDistance = function() error("protected in combat") end
guid.npc = "Creature-0-123-456-789-17-abcdef"
assert(none(), "protected range refusal must fail safely")
print("P0477 actual-source GUID/range proof: ordinary/missing/secret/denied PASS")
