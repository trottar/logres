-- P0476: exercise actual Compass:add source with ordinary/secret-safe fixture rows.
local root = (arg and arg[1]) or "."
local f = assert(io.open(root .. "/Logres/Navigation/Compass.lua", "rb"))
local source = f:read("*a"); f:close()
local beginAt = assert(source:find("    local previousNearQuest = self.nearQuestCenterKeys or {}", 1, true))
local endAt = assert(source:find("    -- QuestPOIMapInfo.isQuestStart", beginAt, true))
local sourceBlock = source:sub(beginAt, endAt - 1)
local function isSecret(v) return v == "SECRET" end
local function normalizeRelativeDegrees(degrees)
    return (degrees + 180) % 360 - 180
end
local function focusedIdentity(name,role)
    if type(name) ~= "string" or type(role) ~= "string" then return nil end
    return name .. " [" .. role .. "]"
end
local SERVICE_MARKER_STYLE = {vendor={role="vendor"}}
local PIXELS_PER_DEGREE = 1
local VISIBLE_HALF_ANGLE = 90
math.atan2 = math.atan2 or function(y,x) return math.atan(y,x) end
local chunk = "return function(self, row, role, prior)\n" .. [[
    local source = {mapWidth=100, mapHeight=100}
    local mapID=1
    local px,py = 0,0
    local radius = 50
    local localPOIs,majorQuests,tracked,services={},{},{},{}
    self.nearQuestCenterKeys = prior or {}
    self.liveNearbyNPCIDs = self.liveNearbyNPCIDs or {}
    self.headingDegrees=0
    local function readNearbyNPCIDs() return self.liveNearbyNPCIDs or {} end
]] .. sourceBlock .. [[
    local visible = add(row,role,"service17")
    return visible,nearQuestCenterKeys,self.serviceNearCenteredCandidates,
           #localPOIs,#services,self.serviceNearUnverifiedHidden,
           self.providerNearUnverifiedHidden,self.serviceNearMapOnlyCandidates,
           services[1],self.providerNearMapOnlyCandidates,
           self.serviceNearBearingHeld
end
]]
local runner, err = load(chunk, "P0476_compass_actual_source", "t", {
    type=type, tostring=tostring, math=math, isSecret=isSecret,
    focusedIdentity=focusedIdentity, normalizeRelativeDegrees=normalizeRelativeDegrees,
    SERVICE_MARKER_STYLE=SERVICE_MARKER_STYLE,
    PIXELS_PER_DEGREE=PIXELS_PER_DEGREE,
    VISIBLE_HALF_ANGLE=VISIBLE_HALF_ANGLE,
})
assert(runner, err)
local addActual=runner()
local function service(distance, prior, npcID, proven, facing)
    return addActual({liveNearbyNPCIDs=proven or {}}, {potential=true, dxYards=0,
        dyYards=facing == "front" and -distance or distance,
        npcID=npcID, serviceKind="vendor", name="Vendor"},
        "service", prior)
end
local found, cache, count, pois, services = service(2, nil, 17, {[17]=true})
assert(found==true and cache["service:service17"]==true and count==1 and services==1 and pois==0,
    "<=3yd known service NPC must center and show")
found, cache, count = service(3.5, cache, 17, {[17]=true})
assert(found==true and cache["service:service17"]==true and count==1,
    "3-4yd known service NPC must retain prior center")
found, cache, count = service(4.0, cache, 17, {[17]=true})
assert(found==nil and cache["service:service17"]==nil and count==0,
    ">=4yd must resume ordinary bearing and disappear if behind")
local hidden, allHidden, mapOnlyCount, candidate
found, cache, count, pois, services, hidden, allHidden, mapOnlyCount = service(2, nil, 17)
assert(found==nil and count==0 and services==0 and hidden==0 and allHidden==0
    and mapOnlyCount==1,
    "unproven rear-facing NPC should be angle-clipped, not removed by floor guess")
found, cache, count, pois, services, hidden, allHidden, mapOnlyCount, candidate =
    service(2, nil, 17, nil, "front")
assert(found==true and count==0 and services==1 and mapOnlyCount==1
    and candidate.mapOnly==true and candidate.uncertainNear==true
    and candidate.liveProof==false and cache["service:service17"]==nil,
    "unverified forward NPC retains a qualified bearing but must never sticky-snap")
found, cache, count = service(3.5, nil, 17)
assert(found==nil and count==0,"3-4yd must not center without live proof")
local priorBearing = { ["service:service17"] = 0 }
local heldFound, _, centeredCount, _, _, _, _, _, heldCandidate, _, held =
    addActual({serviceBearingMapID=1, serviceNearBearings=priorBearing},
        {potential=true, dxYards=0, dyYards=2, npcID=17,
         serviceKind="vendor", name="Vendor"}, "service", nil)
assert(heldFound==true and centeredCount==0 and held==1
    and heldCandidate.magnitude==0 and heldCandidate.x==0,
    "unverified near service must hold last ordinary bearing, never snap")

found, cache, count = service(2, nil, nil)
assert(found==nil and count==0,"unknown service identity is not eligible")
found, cache, count = service(2, nil, "SECRET")
assert(found==nil and count==0,"secret service identity must not be compared")
found, cache, count, pois = addActual({}, {potential=true, dxYards=0,dyYards=2,
    questID=76,name="Quest start"},"poi",nil)
assert(found==true and cache["poi:service17"]==true and count==0 and pois==1,
    "quest-linked snap must remain unchanged")
found, cache, count = addActual({}, {potential=true,dxYards=0,dyYards=2,
    name="Generic POI"},"poi",nil)
assert(found==nil and count==0,"generic POI must retain ordinary bearing")
found, cache, count, pois, services, hidden, allHidden, mapOnlyCount, candidate = addActual({},
    {potential=true, dxYards=0,dyYards=-2,npcID=78,
     questID=78,name="Quest NPC above"},"poi",nil)
assert(found==true and pois==1 and count==0 and allHidden==0
    and candidate==nil and cache["poi:service17"]==nil,
    "2D-only quest-giver must retain ordinary bearing but not centered proof")
print("P0476-P0478 Compass actual source: verified snap/hold/release; unverified map-only bearing PASS")
