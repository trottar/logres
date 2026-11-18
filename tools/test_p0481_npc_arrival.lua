local root=assert(arg[1]);local f=assert(io.open(root..'/Logres/Navigation/Compass.lua','rb'));local src=f:read('*a');f:close()
local C;local rows={};local map=1;local guid={};local inRange={};local secret={}
local source={moduleEnabled=true,currentMapID=1,mapWidth=100,mapHeight=100,availableQuestRows={},questMapRows={}}
local db={moduleEnabled=true,GetNearbyRows=function()return {},'fixture',rows end}
local L={RegisterModule=function(_,_,opts)C={options=opts};return C end,
 GetModule=function(_,name)if name=='NavigationSourceProbe'then return source elseif name=='QuestieDBNearby'then return db end end}
local function widget()
 local o={shown=false}
 function o:Show()self.shown=true end
 function o:Hide()self.shown=false end
 function o:SetText(v)self.text=v end
 function o:SetFormattedText(fmt,...)self.text=string.format(fmt,...)end
 function o:SetPoint(...)self.point={...}end
 return setmetatable(o,{__index=function()return function()end end})
end
local env={Logres=L,issecretvalue=function(v)return rawequal(v,secret)end,
 UnitGUID=function(unit)return guid[unit]end,CheckInteractDistance=function(unit)return inRange[unit]end,
 InCombatLockdown=function()return false end,
 C_Map={GetBestMapForUnit=function()return map end,GetPlayerMapPosition=function()return {GetXY=function()return 0,0 end}end},
 C_Minimap={GetViewRadius=function()return 50 end}}
env._G=env;setmetatable(env,{__index=_G});math.atan2=math.atan2 or function(y,x)return math.atan(y,x)end
assert(load(src,'actual-compass','t',env))(nil,L)
C.policyEligible=true;C.presentationActive=true;C.headingDegrees=0;C.frame=widget()
C.availableQuestPoiFocus=widget()
for _,pool in ipairs({'availableQuestPoiMarkers','questDestinationMarkers','trackingMarkers','serviceMarkers'})do
 C[pool]={};for i=1,8 do C[pool][i]=widget()end
end
local function row(id,d,angle)
 local rad=math.rad(angle or 0)
 return {npcID=id,name='NPC'..id,serviceKind='vendor',potential=true,
  sourceX=id/1000,sourceY=.2,dxYards=math.sin(rad)*d,dyYards=-math.cos(rad)*d}
end
local function refresh()C:RefreshAvailableQuestPOIs('fixture')end
rows={row(17,3.01)};refresh();assert(not C.npcArrivalLockActive,'outside 3 acquired')
rows={row(17,3)};refresh()
assert(C.npcArrivalLockActive and C.npcArrivalLockRendered and C.npcArrivalLockNPCID==17)
assert(C.npcArrivalLockSource=='compass-estimate' and C.serviceNearCenteredCandidates==0,'estimate mislabeled native')
assert(C.availableQuestPoiFocus.text=='NPC17 [vendor]' and not C.focusedMarkerDistanceAvailable,'invented close numeric yards')
assert(C.serviceMarkers[1].point[4]==0)
-- New closer provider and camera turning must not steal an existing arrival.
rows={row(18,1),row(17,3.7,180)};refresh()
assert(C.npcArrivalLockNPCID==17 and C.npcArrivalLockTransition=='held' and C.npcArrivalLockRendered)
assert(C.availableQuestPoiFocus.text=='NPC17 [vendor]' and C.serviceMarkers[1].point[4]==0)
-- Exact 4yd release, source disappearance, different map or spawn cannot transfer.
rows={row(17,4,180)};refresh();assert(not C.npcArrivalLockActive)
rows={row(17,2)};refresh();assert(C.npcArrivalLockActive)
rows={};refresh();assert(not C.npcArrivalLockActive)
rows={row(17,2)};refresh();map=2;source.currentMapID=2;rows={row(17,3.5,180)};refresh();assert(not C.npcArrivalLockActive)
map=1;source.currentMapID=1;rows={row(17,2)};refresh()
local moved=row(17,3.5,180);moved.sourceX=.9;rows={moved};refresh();assert(not C.npcArrivalLockActive)
rows={row(17,2,50)};refresh();assert(not C.npcArrivalLockActive,'unproven side-facing acquisition')
-- Native proof can acquire within3 without alignment; explicit range false vetoes estimate/hold.
guid.softinteract='Creature-0-1-2-3-17-abcdef';inRange.softinteract=true
rows={row(17,2,180)};refresh();assert(C.npcArrivalLockActive and C.npcArrivalLockSource=='native')
inRange.softinteract=false;rows={row(17,2)};refresh();assert(not C.npcArrivalLockActive,'native negative range ignored')
guid.softinteract=nil;inRange.softinteract=nil;rows={row(17,2)};refresh();assert(C.npcArrivalLockActive)
guid.softinteract=secret;refresh();assert(C.npcArrivalLockSource=='compass-estimate','secret native result promoted estimate')
guid.softinteract=nil
-- Missing/secret source identity or no name never gets a probable lock.
local unknown=row(17,2);unknown.sourceX=secret;rows={unknown};refresh();assert(not C.npcArrivalLockActive)
unknown=row(17,2);unknown.name=nil;rows={unknown};refresh();assert(not C.npcArrivalLockActive)
rows={row(17,2)};refresh();assert(C.npcArrivalLockActive)
source.moduleEnabled=false;refresh();assert(not C.npcArrivalLockActive and not C.availableQuestPoiFocus.shown)
print('P0481 actual complete refresh PASS: 3/4yd, one stable focus, facing/token loss, map/spawn/disappearance, negative range, secret source and estimate/native distinction')
