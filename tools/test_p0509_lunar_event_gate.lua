-- Actual-source Lunar Festival eligibility fixture; no client mutation.
local root=assert(arg[1]);local f=assert(io.open(root..'/Logres/Navigation/QuestieDBNearby.lua','rb'))
local source=f:read('*a');f:close()
local Nearby
local Logres={RegisterModule=function(_,name)assert(name=='QuestieDBNearby');Nearby={};return Nearby end}
local secret={}
local quests={
 [8870]={name='The Lunar Festival',zoneOrSort=-366,questFlags=8},
 [35]={name='Further Concerns',zoneOrSort=12,questFlags=8},
 [333]={name='Harlan Needs a Resupply',zoneOrSort=1519,questFlags=8},
}
local events={}
local day=21
local function frame()
 local f={};function f:RegisterEvent(e)self[e]=true end
 function f:SetScript(k,v)self[k]=v end
 return f
end
local env={Logres=Logres,issecretvalue=function(v)return rawequal(v,secret)end,
 QuestDB={Get=function(id,key)return quests[id] and quests[id][key]end},
 LibQuestieDB={RequireContract=function(v)return true end,
  Enum={raceMaskById={[1]=1},classKeys={WARRIOR=1}}},
 UnitLevel=function()return 15 end,
 UnitRace=function()return 'Human','Human',1 end,
 UnitClass=function()return 'Warrior','WARRIOR',1 end,
 C_QuestLog={IsOnQuest=function()return false end,
  IsQuestFlaggedCompleted=function()return false end},
 C_DateAndTime={GetCurrentCalendarTime=function()return {year=2026,month=11,monthDay=day}end},
 C_Calendar={GetNumDayEvents=function(offset,d)assert(offset==0 and d==day);return #events end,
  GetDayEvent=function(_,d,i)assert(d==day);return events[i]end},
 C_Map={GetBestMapForUnit=function()return 1453 end,
  GetPlayerMapPosition=function()return {GetXY=function()return 0,0 end}end,
  GetMapInfo=function()return nil end},
 CreateFrame=frame,
}
env._G=env;setmetatable(env,{__index=_G})
assert(load(source,'QuestieDBNearby','t',env))(nil,Logres)
Nearby:OnInitialize()
assert(Nearby.frame.CALENDAR_UPDATE_EVENT_LIST,'calendar event must invalidate eligibility')
local function eligible(id)
 Nearby.questEligibilityChecksThisRefresh=0
 return Nearby:EligibilityForQuest(id)
end
local allowed,why=eligible(8870)
assert(not allowed and why=='lunar-holiday-inactive',tostring(why))
assert(eligible(35),'nonseasonal quest35 rejected with empty calendar')
assert(eligible(333),'nonseasonal q333 rejected with empty calendar')
-- An unrelated HOLIDAY and a user-authored matching title are not proof.
events={{calendarType='HOLIDAY',eventID=999,title='Other'},
 {calendarType='PLAYER',eventID=327,title='Lunar Festival'}}
Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
allowed,why=eligible(8870)
assert(not allowed and why=='lunar-holiday-inactive',tostring(why))
-- Realm-local holiday record changes authorization without source data edits.
events={{calendarType='HOLIDAY',eventID=327,title='Localized title'}}
Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
assert(eligible(8870),'live holiday event ID should authorize lunar quest')
events={{calendarType='HOLIDAY',title='Lunar Festival'}}
Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
assert(eligible(8870),'event title fallback should authorize lunar quest')
-- Unknown, secret, and broken calendar facts never invent an available offer.
function env.C_Calendar.GetNumDayEvents()return secret end
Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
allowed,why=eligible(8870)
assert(not allowed and why=='lunar-calendar-incomplete',tostring(why))
env.C_Calendar.GetNumDayEvents=function()return 1 end
env.C_Calendar.GetDayEvent=function()return secret end
Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
allowed,why=eligible(8870)
assert(not allowed and why=='lunar-calendar-incomplete',tostring(why))
env.C_Calendar=nil
Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
allowed,why=eligible(8870)
assert(not allowed and why=='lunar-calendar-unavailable',tostring(why))
assert(eligible(35),'quest35 must not depend on C_Calendar availability')
-- A native current quest offer is authoritative even without calendar data.
Nearby.complete=true;Nearby.moduleEnabled=true;Nearby.mapID=1453;Nearby.areaID=1519
Nearby.areaMapping={[1453]=1519};Nearby.serviceEnabled=false
Nearby.rows={{npcID=15892,name='Lunar Festival Emissary',x=.2,y=0,
 questID=8870,questIDs={8870}}}
local rows=Nearby:GetNearbyRows(1453,0,0,100,100,{})
assert(#rows==1 and not rows[1].providerEligible,
 'inactive lunar quest should stay in diagnostic history but not qualify')
rows=Nearby:GetNearbyRows(1453,0,0,100,100,{[8870]=true})
assert(rows[1].npcID==15892 and Nearby.questEligibilityQualifiedNPCs==0,
 'native current offer must outrank inactive/unknown calendar')
print('P0509 actual-source PASS: Lunar Nov veto, active event, unrelated event, unknown/secret, cached invalidation, q35, native offer')
