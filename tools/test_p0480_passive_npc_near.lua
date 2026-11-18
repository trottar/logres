-- P0480: execute the real NPC proof helper, including passive native tokens.
local root = (arg and arg[1]) or "."
local f = assert(io.open(root .. "/Logres/Navigation/Compass.lua", "rb"))
local source = f:read("*a"); f:close()
local a = assert(source:find("local visibleNameplateUnits = {}", 1, true))
local b = assert(source:find("-- A focus label may format", a, true))
local guid, distance = {}, {}
local combat = false
local function isSecret(v) return v == "SECRET" end
local fakeAPI = {
    UnitGUID = function(unit) return guid[unit] end,
    CheckInteractDistance = function(unit, i)
        assert(i == 3); return distance[unit]
    end,
    InCombatLockdown = function() return combat end,
}
local env = { _G = fakeAPI, pcall = pcall, type = type, string = string,
    tonumber = tonumber, ipairs = ipairs, pairs = pairs, isSecret = isSecret }
local make, err = load(source:sub(a, b-1)
    .. "\nreturn readNearbyNPCIDs, visibleNameplateUnits",
    "P0480_proximity_actual_source", "t", env)
assert(make, err)
local read, nameplates = make()
local function clear()
    for k in pairs(guid) do guid[k] = nil end
    for k in pairs(distance) do distance[k] = nil end
    for k in pairs(nameplates) do nameplates[k] = nil end
    combat = false
end
local function creature(id)
    return "Creature-0-123-456-789-" .. tostring(id) .. "-abcdef"
end
local ids, origins
clear()
guid.softinteract = creature(151); distance.softinteract = true
ids, origins = read()
assert(ids[151] == true and origins[151] == "softinteract",
    "native soft-interact NPC is eligible without a hard target")
clear()
guid.nameplate7 = creature(152); distance.nameplate7 = true
nameplates.nameplate7 = true
ids, origins = read()
assert(ids[152] == true and origins[152] == "nameplate",
    "event-observed NPC nameplate is eligible without targeting")
nameplates.nameplate7 = nil
ids = read()
assert(ids[152] == nil, "removed nameplate must not contribute")
clear()
guid.softinteract = creature(153); distance.softinteract = false
ids = read()
assert(ids[153] == nil, "different-floor or out-of-range unit cannot prove nearby")
clear()
guid.softinteract = "SECRET"; distance.softinteract = true
ids = read()
assert(ids[153] == nil, "secret native identity must not be inspected")
clear()
guid.nameplate9 = creature(154); distance.nameplate9 = "SECRET"
nameplates.nameplate9 = true
ids = read()
assert(ids[154] == nil, "secret proximity is never evidence")
clear()
guid.softinteract = creature(155); distance.softinteract = true
combat = true
ids = read()
assert(ids[155] == nil, "preserve restricted call combat gate")
clear()
guid.mouseover = creature(156); distance.mouseover = true
ids, origins = read()
assert(ids[156] == true and origins[156] == "mouseover",
    "historical mouseover proof preserved")
clear()
guid.target = creature(157); distance.target = true
ids, origins = read()
assert(ids[157] == true and origins[157] == "target",
    "historical explicit target proof preserved")

-- Execute the actual nameplate event handler with a mock event frame.
local start = assert(source:find('        local nameplateFrame = CreateFrame("Frame")', 1, true))
local finish = assert(source:find('        self.nameplateEventFrame = nameplateFrame', start, true))
local frame = { events = {} }
function frame:RegisterEvent(e) self.events[e] = true end
function frame:SetScript(_, fn) self.dispatch = fn end
local eventEnv = { CreateFrame = function() return frame end,
    isSecret = isSecret, pcall = pcall, type = type, string = string,
    tonumber = tonumber, visibleNameplateUnits = nameplates }
local register = assert(load('return function(self)\n' ..
    source:sub(start, finish + #('        self.nameplateEventFrame = nameplateFrame') - 1)
    .. '\nend', 'P0480_nameplate_events_actual_source','t',eventEnv))()
local self = {}
register(self)
assert(self.nameplateEventRegistered and frame.events.NAME_PLATE_UNIT_ADDED
    and frame.events.NAME_PLATE_UNIT_REMOVED)
frame.dispatch(frame, 'NAME_PLATE_UNIT_ADDED','nameplate10')
assert(nameplates.nameplate10 == true)
frame.dispatch(frame, 'NAME_PLATE_UNIT_REMOVED','nameplate10')
assert(nameplates.nameplate10 == nil)
frame.dispatch(frame, 'NAME_PLATE_UNIT_ADDED','SECRET')
assert(nameplates.SECRET == nil)
frame.dispatch(frame, 'NAME_PLATE_UNIT_ADDED','nameplate41')
assert(nameplates.nameplate41 == nil, "bounded nameplate index")
print('P0480 live ordinary softinteract/nameplate/mouseover proof and event lifecycle: PASS')
