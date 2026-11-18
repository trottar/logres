-- P0485 actual-source fixture: QuestieDB sparse optional fields vs failed/secret reads.
local root=assert(arg[1])
local file=assert(io.open(root..'/Logres/Navigation/QuestieDBNearby.lua','rb'))
local source=file:read('*a');file:close()
local Nearby
local Logres={RegisterModule=function(_,name)assert(name=='QuestieDBNearby');Nearby={};return Nearby end}
local secret={}
local active,done={},{}
local quests={}
local numeric={requiredLevel=true,requiredMaxLevel=true,requiredRaces=true,requiredClasses=true,
 parentQuest=true,nextQuestInChain=true,availableUntilCompleted=true,
 availableStartingWith=true,disabledByQuest=true,breadcrumbForQuestId=true,
 requiredSpell=true,requiredSpecialization=true,specialFlags=true,questFlags=true}
local function record(id,overrides)
 local row={name='Quest'..id,requiredLevel=7,requiredMaxLevel=0,
 requiredRaces=1,requiredClasses=0,specialFlags=0,questFlags=0}
 for k,v in pairs(overrides or {})do row[k]=v end
 quests[id]=row
end
record(35,{name='Further Concerns'})
-- QuestieDB optional scalars may legitimately be absent; P0484's fixture
-- incorrectly filled these absent fields with zero, hiding the runtime bug.
for _,key in ipairs({'requiredMaxLevel','requiredRaces','requiredClasses',
 'questFlags','specialFlags'})do quests[35][key]=nil end
-- Forever quest35 is a normal, shareable Classic quest: QUEST_FLAGS_SHARABLE=8.
-- This is the exact failure path in Forever session169; nil/zero-only tests
-- did not exercise the P0485 conditional-quest-flags veto.
quests[35].questFlags=8
quests[35].preQuestGroup={}
quests[35].preQuestSingle={}
quests[35].exclusiveTo={}
quests[35].requiredRanks={}

record(40,{name='Prior Quest'})
record(50,{name='Exclusive A',exclusiveTo={51}})
record(60,{name='Chain',preQuestSingle={40}})
record(61,{name='Group Chain',preQuestGroup={40,41}})
record(62,{name='Conditional',requiredSkill={171,100}})
record(63,{name='High Level',requiredLevel=50})
record(64,{name='Wrong Class',requiredClasses=128})
record(65,{name='Special',specialFlags=1})
record(66,{name='Future Parent',parentQuest=40})
record(67,{name='Breadcrumb',breadcrumbForQuestId=40})
record(68,{name='Disabling',disabledByQuest=40})
record(69,{name='Race',requiredRaces=2})
record(70,{name='Inactive',requiredMaxLevel=12})
record(71,{name='Unknown',requiredMinRep={23,3000}})
local function frame()
 local f={}
 function f:RegisterEvent(e) self[e]=true end
 function f:SetScript(which,handler) self[which]=handler end
 return f
end
local env={
 Logres=Logres, issecretvalue=function(v)return rawequal(v,secret)end,
 LibQuestieDB={RequireContract=function(v)return v==1 or v==3 or v==4 end,
  Enum={raceMaskById={[1]=1,[2]=2},classKeys={WARRIOR=1,MAGE=128}}},
 QuestDB={Get=function(id,key)
    local row=quests[id];if not row then return nil end
    local value=row[key]
    return value
 end},
 UnitLevel=function()return 15 end,
 UnitRace=function()return 'Human','Human',1 end,
 UnitClass=function()return 'Warrior','WARRIOR',1 end,
 C_QuestLog={IsOnQuest=function(id)return active[id] or false end,
   IsQuestFlaggedCompleted=function(id)return done[id] or false end},
 C_Map={GetBestMapForUnit=function()return 1 end,
        GetPlayerMapPosition=function()return {GetXY=function()return 0,0 end}end,
        GetMapInfo=function()return nil end},
 CreateFrame=frame,
}
env._G=env;setmetatable(env,{__index=_G})
assert(load(source,'QuestieDBNearby','t',env))(nil,Logres)
Nearby:OnInitialize()
assert(Nearby.frame.QUEST_LOG_UPDATE and Nearby.frame.QUEST_TURNED_IN
 and Nearby.frame.PLAYER_LEVEL_UP and Nearby.frame.UPDATE_FACTION,
 'eligibility event invalidation absent')
local function eligible(id)
 Nearby.questEligibilityChecksThisRefresh=0
 local ok,why=Nearby:EligibilityForQuest(id)
 return ok,why
end
local yes,why=eligible(35)
assert(yes and why=='player-requirements-satisfied','shareable Classic quest35 rejected: '..tostring(why))
-- Ordinary informational combinations are allowed, but unsupported/repeating
-- and unavailable flags never infer a current offer from DB history.
for _,allowedFlag in ipairs({1,2,4,8,9,14,32,64,256,512,521}) do
 quests[35].questFlags=allowedFlag
 Nearby:InvalidateEligibility('fixture-information-flags')
 assert(eligible(35),'non-eligibility quest flag rejected: '..allowedFlag)
end
for _,forbidden in ipairs({16,128,1024,2048,4096,8192,16384,32768,65536,524288,8+4096,-1,3.5}) do
 quests[35].questFlags=forbidden
 Nearby:InvalidateEligibility('fixture-conditional-flags')
 local allowed,reason=eligible(35)
 assert(not allowed and reason=='conditional-quest-flags','unsupported flag accepted '..forbidden..' '..tostring(reason))
end
quests[35].questFlags=8
Nearby:InvalidateEligibility('fixture-shareable-restored')
assert(eligible(35),'shareable quest did not recover after conditional-bit veto')
-- A truly failed read must not be interpreted as an absent restriction.
local originalGet=env.QuestDB.Get
function env.QuestDB.Get(id,key)
 if id==35 and key=='requiredMaxLevel' then error('fixture db read failure') end
 return originalGet(id,key)
end
Nearby:InvalidateEligibility('fixture-failed-read')
assert(not eligible(35),'failed optional-field read was treated as missing')
env.QuestDB.Get=originalGet
function env.QuestDB.Get(id,key)
 if id==35 and key=='requiredMaxLevel' then return secret end
 return originalGet(id,key)
end
Nearby:InvalidateEligibility('fixture-secret-read')
assert(not eligible(35),'secret optional field was treated as missing')
env.QuestDB.Get=originalGet
Nearby:InvalidateEligibility('fixture-sparse-restored')
assert(eligible(35),'sparse quest did not recover after failed read')

-- Reject completed and active quests; a relevant native event clears the cache.
active[35]=true;Nearby.frame.OnEvent(nil,'QUEST_LOG_UPDATE')
assert(not eligible(35),'active quest was eligible')
active[35]=false;done[35]=true;Nearby.frame.OnEvent(nil,'QUEST_TURNED_IN')
assert(not eligible(35),'completed quest was eligible')
done[35]=false;Nearby:InvalidateEligibility('fixture')
assert(eligible(35),'event refresh did not restore eligible quest')
-- Prerequisites: single = one of; grouped = all.
assert(not eligible(60),'future prerequisite candidate passed')
done[40]=true;Nearby:InvalidateEligibility('fixture');assert(eligible(60),'met single prerequisite rejected')
assert(not eligible(61),'incomplete grouped prerequisite passed')
done[41]=true;Nearby:InvalidateEligibility('fixture');assert(eligible(61),'met grouped prerequisite rejected')
active[51]=true;Nearby:InvalidateEligibility('fixture');assert(not eligible(50),'exclusive quest passed')
active[51]=false;Nearby:InvalidateEligibility('fixture');assert(eligible(50),'exclusive quest did not clear')
for _,id in ipairs({62,63,64,65,66,69,70,71})do
 local ok=eligible(id);assert(not ok,'restricted quest '..id..' passed')
end
active[40]=true;Nearby:InvalidateEligibility('fixture');assert(not eligible(68),'disabled by active quest')
assert(not eligible(67),'breadcrumb following active quest accepted')
-- A secret-capable Boolean cannot prove eligibility; no secret branching.
env.C_QuestLog.IsOnQuest=function(id)if id==35 then return secret end return false end
Nearby:InvalidateEligibility('fixture');assert(not eligible(35),'secret quest-state value passed')
env.C_QuestLog.IsOnQuest=function(id)return active[id] or false end
active[40]=false;done[40]=false;done[41]=false;Nearby:InvalidateEligibility('fixture')
-- Candidate index retains all, but independently eligible quest moves ahead
-- of eight closer historical NPCs without enlarging the existing cap.
Nearby.complete=true;Nearby.moduleEnabled=true;Nearby.mapID=1;Nearby.areaID=1
Nearby.areaMapping={[1]=1};Nearby.serviceEnabled=false;Nearby.rows={}
for i=1,9 do Nearby.rows[i]={npcID=i,questID=63,questIDs={63},name='Future'..i,x=i/1000,y=0}end
Nearby.rows[10]={npcID=240,name='Marshal Dughan',questID=35,questIDs={35},x=.3,y=0}
local rows=Nearby:GetNearbyRows(1,0,0,100,100,{})
assert(#rows==8 and rows[1].npcID==240 and rows[1].providerEligible==true
 and rows[1].questID==35,'current Classic quest was starved by old candidates')
assert(Nearby.questEligibilityQualifiedNPCs==1 and Nearby.questEligibilityRejectedNPCs==9)
local report=Nearby:GetDebugStatus()
assert(report.eligibilityQualified==1 and report.eligibilityCache>0)
-- Explicit native source stays authoritative even if metadata is conditional.
Nearby.rows[11]={npcID=500,name='Native',questID=62,questIDs={62},x=.32,y=0}
rows=Nearby:GetNearbyRows(1,0,0,100,100,{[62]=true})
assert(rows[1].npcID==500,'native current offer must outrank the model')
assert(type(report.eligibilityClosestRejectedReason)=='string' and report.eligibilityFirstQualifiedNPCID==240)
print('P0486 Classic quest flags actual-source PASS: quest35 SHARABLE=8; informational composites; daily/unavailable/unknown veto; sparse/secret, active/completed, native priority, 8-cap')
