-- Actual-source test for all uniquely classified holiday quests.
local root=assert(arg[1]); local f=assert(io.open(root..'/Logres/Navigation/QuestieDBNearby.lua','rb'))
local source=f:read('*a'); f:close()
local Nearby,secret={},{}
local Logres={RegisterModule=function(_,name) assert(name=='QuestieDBNearby'); return Nearby end}
local cases={
 {8870,-366,'Lunar Festival'},
 {50021,-21,"Hallow's End"},
 {50041,-41,'Day of the Dead'},
 {50364,-364,'Darkmoon Faire (Elwynn)'},
 {50369,-369,'Midsummer Fire Festival'},
 {50370,-370,'Brewfest'},
 {50374,-374,'Noblegarden'},
 {50375,-375,"Pilgrim's Bounty"},
 {50376,-376,'Love is in the Air'},
 {50378,-378,"Children's Week"},
}
local quests={[35]={name='Further Concerns',zoneOrSort=12,questFlags=8},
 [333]={name='Harlan Needs a Resupply',zoneOrSort=1519,questFlags=8},
 [60022]={name='Unassigned Seasonal',zoneOrSort=-22,questFlags=8},
 [60284]={name='Special Quest',zoneOrSort=-284,questFlags=8}}
for _,t in ipairs(cases)do quests[t[1]]={name=t[3],zoneOrSort=t[2],questFlags=8}end
local events,day= {},21
local function frame() local f={};function f:RegisterEvent(e)self[e]=true end;function f:SetScript(k,v)self[k]=v end;return f end
local env={ Logres=Logres, issecretvalue=function(v)return rawequal(v,secret)end,
 QuestDB={Get=function(id,key) return quests[id] and quests[id][key] end},
 LibQuestieDB={RequireContract=function()return true end,
  Enum={raceMaskById={[1]=1},classKeys={WARRIOR=1}}},
 UnitLevel=function()return 15 end, UnitRace=function()return 'Human','Human',1 end,
 UnitClass=function()return 'Warrior','WARRIOR',1 end,
 C_QuestLog={IsOnQuest=function()return false end,
  IsQuestFlaggedCompleted=function()return false end},
 C_DateAndTime={GetCurrentCalendarTime=function()return {year=2026,month=11,monthDay=day}end},
 C_Calendar={GetNumDayEvents=function(_,d)assert(d==day);return #events end,
  GetDayEvent=function(_,d,i)assert(d==day);return events[i] end},
 C_Map={GetBestMapForUnit=function()return 1453 end,
  GetPlayerMapPosition=function()return {GetXY=function()return 0,0 end}end,
  GetMapInfo=function()return nil end}, CreateFrame=frame }
env._G=env;setmetatable(env,{__index=_G})
assert(load(source,'QuestieDBNearby','t',env))(nil,Logres)
Nearby:OnInitialize()
assert(Nearby.frame.CALENDAR_UPDATE_EVENT_LIST)
local function eligible(id)
 Nearby.questEligibilityChecksThisRefresh=0
 return Nearby:EligibilityForQuest(id)
end
local function reset()
 Nearby.frame.OnEvent(nil,'CALENDAR_UPDATE_EVENT_LIST')
end
for _,t in ipairs(cases)do
 events={};reset()
 local allowed,why=eligible(t[1])
 assert(not allowed and why=='holiday-inactive:'..({[-21]='hallows-end',[-41]='day-of-the-dead',[-364]='darkmoon-faire',[-366]='lunar-festival',[-369]='midsummer',[-370]='brewfest',[-374]='noblegarden',[-375]='pilgrims-bounty',[-376]='love-is-in-the-air',[-378]='childrens-week'})[t[2]],t[3]..':'..tostring(why))
 events={{calendarType='HOLIDAY',title=t[3]}};reset()
 allowed,why=eligible(t[1]);assert(allowed,t[3]..':'..tostring(why))
 -- A different active holiday never authorizes this category.
 events={{calendarType='HOLIDAY',title='Feast of Winter Veil'}};reset()
 assert(not eligible(t[1]),t[3]..' incorrectly accepted with Winter Veil')
 events={{calendarType='PLAYER',title=t[3]}};reset()
 assert(not eligible(t[1]),t[3]..' accepted player calendar event')
end
-- Darkmoon setup or an unrelated prefixed title is not the running faire.
events={{calendarType='HOLIDAY',title='Darkmoon Faire Setup'}};reset()
assert(not eligible(50364),'Darkmoon setup cannot authorize faire quest')
-- Unassigned seasonal sorts cannot be assigned to a random active holiday.
events={{calendarType='HOLIDAY',title='Feast of Winter Veil'}};reset()
local allowed,why=eligible(60022)
assert(not allowed and why=='seasonal-holiday-identity-unknown',tostring(why))
assert(eligible(60284),'generic Special quest should not be blanket suppressed')
assert(eligible(35),'ordinary quest35 must remain available')
assert(eligible(333),'ordinary quest333 must remain available')
-- Brewfest eventID 327 is ambiguous across clients: it cannot enable Lunar.
events={{calendarType='HOLIDAY',eventID=327,title='Brewfest'}};reset()
assert(not eligible(8870),'numeric holiday ID collision leaked Lunar')
-- Secret/unavailable calendar cannot invent offers, but ordinary quests survive.
env.C_Calendar.GetNumDayEvents=function()return secret end;reset()
allowed,why=eligible(8870)
assert(not allowed and why=='holiday-calendar-incomplete',tostring(why))
assert(eligible(35))
env.C_Calendar.GetNumDayEvents=function()return #events end
-- Day rollover invalidates an already cached holiday authorization.
events={{calendarType='HOLIDAY',title='Lunar Festival'}};reset()
assert(eligible(8870))
day=22;events={}
allowed,why=eligible(8870)
assert(not allowed and why=='holiday-inactive:lunar-festival',tostring(why))
assert(Nearby.questEligibilityLastInvalidation=='calendar-day-changed')
-- Native-confirmed offer is stronger than DB-only event checks, even for -22.
Nearby.complete=true;Nearby.moduleEnabled=true;Nearby.mapID=1453;Nearby.areaID=1519
Nearby.areaMapping={[1453]=1519};Nearby.serviceEnabled=false
Nearby.rows={{npcID=15892,name='Lunar Festival Emissary',x=.2,y=0,questID=8870,questIDs={8870}},
 {npcID=9999,name='Winter Veil NPC',x=.3,y=0,questID=60022,questIDs={60022}}}
local rows=Nearby:GetNearbyRows(1453,0,0,100,100,{})
assert(#rows==2 and not rows[1].providerEligible,'unconfirmed holidays must remain historical')
rows=Nearby:GetNearbyRows(1453,0,0,100,100,{[8870]=true,[60022]=true})
assert(#rows==2,'native active offers must remain visible on calendar failure')
print('P0510 actual-source PASS: ten holiday categories, cross-holiday, ID collision, generic seasonal, native, q35, invalidation')
