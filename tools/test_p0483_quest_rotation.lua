local root=assert(arg[1]);local function source(path)
 local f=assert(io.open(root..'/'..path,'rb'));local text=f:read('*a');f:close();return text
end
local secret={};local C,N
local map=1;local services={};local questRows={};local logSource={
 moduleEnabled=true,currentMapID=1,mapWidth=100,mapHeight=100,availableQuestRows={},questMapRows={}}
local db={moduleEnabled=true,serviceStatus='ready',GetNearbyRows=function()return questRows,'ready',services end}
local L={RegisterModule=function(_,name,opts)
 local m={options=opts};if name=='Compass'then C=m else N=m end;return m end,
 GetModule=function(_,name)if name=='NavigationSourceProbe'then return logSource elseif name=='QuestieDBNearby'then return db end end}
local function widget()
 local o={shown=false}
 function o:Show()self.shown=true end
 function o:Hide()self.shown=false end
 function o:SetText(t)self.text=t end
 function o:SetPoint(...)self.point={...}end
 function o:SetSize(...)end
 return setmetatable(o,{__index=function()return function()end end})
end
local env={Logres=L,issecretvalue=function(v)return rawequal(v,secret) end,
 InCombatLockdown=function()return false end,UnitGUID=function()return nil end,
 CheckInteractDistance=function()return nil end,
 C_Map={GetBestMapForUnit=function()return map end,GetPlayerMapPosition=function()return {GetXY=function()return 0,0 end}end},
 C_Minimap={GetViewRadius=function()return 50 end}}
env._G=env;setmetatable(env,{__index=_G});math.atan2=math.atan2 or function(y,x)return math.atan(y,x)end
assert(load(source('Logres/Navigation/Compass.lua'),'actual-compass','t',env))(nil,L)
C.policyEligible=true;C.presentationActive=true;C.headingDegrees=0;C.frame=widget();C.availableQuestPoiFocus=widget()
for _,pool in ipairs({'availableQuestPoiMarkers','questDestinationMarkers','trackingMarkers','serviceMarkers'}) do
 C[pool]={};for i=1,8 do C[pool][i]=widget()end
end
local function provider(id,d,angle)
 local rad=math.rad(angle or 0)
 return {npcID=id,name='NPC'..id,potential=true,questID=11,questIDs={11,22},serviceKind='vendor',
  sourceX=.02,sourceY=.2,dxYards=math.sin(rad)*d,dyYards=-math.cos(rad)*d}
end
local function refresh() C:RefreshAvailableQuestPOIs('fixture') end
-- Absent native offer: historical Questie quest-starts MUST NOT appear as quests.
questRows={provider(10,5,0)};services={provider(10,5,0)};refresh()
assert(C.dbNativeOfferCount==0 and C.dbHistoricalQuestExcluded==1)
assert(C.dbConfirmedQuestCandidates==0 and C.dbServiceCandidateShown==1 and C.dbCandidateShown==0)
-- Second historical ID is the current native offer, despite first ID mismatch.
logSource.availableQuestRows={{questID=22,eligible=true}};refresh()
assert(C.dbNativeOfferCount==1 and C.dbConfirmedQuestCandidates==1 and C.dbHistoricalQuestExcluded==0)
assert(C.dbCandidateShown==1 and C.dbDualRoleServiceSuppressed==1 and C.dbServiceCandidateShown==0)
assert(C.availableQuestPoiFocus.text=='NPC10 [quest] - 5 yd','quest did not take native-eligible focus')
-- Distinct service NPC may still lock; current native quest focus wins its label.
services={provider(20,1.5,0)};questRows={provider(10,1.8,0)};refresh()
assert(C.availableQuestPoiFocus.text=='NPC10 [quest]','native-backed quest focus displaced by service lock')
-- Fast heading updates observed between 0.15s marker samples reacquire.
logSource.availableQuestRows={};questRows={};services={provider(20,1.8,0)};refresh()
C.npcArrivalLock=nil;C.headingDegrees=50;C.arrivalHeadingMapID=1
C.arrivalHeadingSamples={330,350,20,50};refresh()
assert(C.npcArrivalLockActive and C.npcArrivalRotationRecovered and C.npcArrivalLockNPCID==20)
assert(C.npcArrivalLockSource=='compass-estimate')
C.npcArrivalLock=nil;services={provider(20,2.1,0)};C.arrivalHeadingSamples={330,350,20,50};refresh()
assert(not C.npcArrivalLockActive,'rotation widened 2yd acquisition')
-- No stale other-map sweep may acquire.
C.npcArrivalLock=nil;services={provider(20,1.8,0)};C.headingDegrees=50
C.arrivalHeadingMapID=2;C.arrivalHeadingSamples={330,350,20,50};refresh()
assert(not C.npcArrivalLockActive,'old-map sweep acquired NPC')
-- Source-owned finite indexing includes all bounded questIDs even if service.
assert(load(source('Logres/Navigation/QuestieDBNearby.lua'),'actual-db','t',env))(nil,L)
N.moduleEnabled=true;N.scanning=true;N.ids={10};N.scanIndex=1;N.idCount=1;N.areaID=1;N.rows={};N.serviceRows={};N.serviceCategoryCached={vendor=0}
N.serviceRoleMasks={vendor=2};N.serviceEnabled=true;N.frame=widget();N.scanned=0;N.zoneNPCs=0;N.questNPCs=0
N.npc={zoneID=function()return 1 end,questStarts=function()return {11,22} end,
 npcFlags=function()return 2 end,name=function()return 'NPC10' end,
 spawns=function()return {[1]={{40,50}}} end}
N:ScanChunk()
assert(N.complete and #N.rows==1 and #N.serviceRows==1 and N.rows[1].questIDs[1]==11
 and N.rows[1].questIDs[2]==22 and N.questNPCs==1, 'dual-role and multi-quest index lost')
-- Eight-nearest historical NPCs must not starve a farther native offer.
N.complete=true;N.mapID=1;N.areaMapping={[1]=1};N.serviceEnabled=false;N.rows={}
for i=1,9 do N.rows[i]={npcID=i,questID=11,questIDs={11},x=i/1000,y=0,name='Old'..i} end
N.rows[10]={npcID=10,questID=11,questIDs={11,22},x=.3,y=0,name='Current'}
local selected=N:GetNearbyRows(1,0,0,100,100,{[22]=true})
assert(#selected==8 and selected[1].npcID==10,'current native offer starved by historical cap')
print('P0483 actual source fixtures PASS: native offer gate, second quest ID, dual-role, eight-cap priority, quest focus, fast-sweep, 2yd cap, map isolation')
