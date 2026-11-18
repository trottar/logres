-- Actual QuestieDBNearby.lua fixture; no WoW runtime claim.
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
    local value=row[key];if value==nil and numeric[key] then return 0 end
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
assert(yes and why=='player-requirements-satisfied','classic quest 35 failed: '..tostring(why))
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
print('P0484 actual-source eligibility fixtures PASS: quest35, native absent, active/completed, level/race/class, prerequisites, exclusive, conditional, secret, cache invalidation, 8-cap, native priority')
