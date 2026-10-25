#!/usr/bin/env python3
"""P0337: optional QuestieDB history requires native current-offer corroboration."""
from pathlib import Path
import re,sys

def eligible(native_map, native_lines):
    out=set()
    for row in native_map:
        if isinstance(row,dict) and row.get('role')=='poi' and isinstance(row.get('questID'),int) and row['questID']>0:out.add(row['questID'])
    for row in native_lines:
        if isinstance(row,dict) and row.get('eligible') is True and isinstance(row.get('questID'),int) and row['questID']>0:out.add(row['questID'])
    return out

def select(db,confirmed,seen):
    selected=[];held=0
    for row in db:
        if not isinstance(row,dict) or not isinstance(row.get('npcID'),int):continue
        if row.get('questID') not in confirmed:held+=1;continue
        if row['questID'] not in seen:selected.append(row);seen.add(row['questID'])
    return selected,held

def fixtures():
    e=eligible([{'role':'poi','questID':11},{'role':'quest','questID':22}], [{'eligible':True,'questID':33},{'eligible':False,'questID':44}])
    assert e=={11,33}
    got,held=select([{'npcID':1,'questID':11},{'npcID':2,'questID':44},{'npcID':3,'questID':33}],e,set())
    assert [x['npcID'] for x in got]==[1,3] and held==1
    assert select([{'npcID':1,'questID':11}],set(),set())==([],1)
    assert select([{'npcID':1,'questID':11}],e,{11})==([],0)
    assert select([{'npcID':1,'questID':99}],e,set())==([],1)
    assert eligible([],[])==set()
    print('P0337 fixture PASS: native-map offer, native-line offer, historical-only, duplicate, future, absent source')

if '--selftest' in sys.argv:fixtures();raise SystemExit(0)
R=Path(__file__).resolve().parents[1];read=lambda p:(R/p).read_text(encoding='utf-8')
c=read('Logres/Navigation/Compass.lua');db=read('Logres/Navigation/QuestieDBNearby.lua');n=read('Logres/Navigation/NavigationSourceProbe.lua')
cur=read('docs/memory/CURRENT.md');handoff=read('docs/memory/handoffs/CURRENT_HANDOFF.md');issues=read('docs/memory/investigations/ISSUE_REGISTER.md')
toc=read('Logres/Logres.toc');boot=read('Logres/Core/Bootstrap.lua')
def need(ok,msg):
    if not ok:raise AssertionError(msg)
block=c[c.index('function Compass:RefreshAvailableQuestPOIs(reason)'):c.index('function Compass:SetArtworkPreview',c.index('function Compass:RefreshAvailableQuestPOIs(reason)'))]
for q in ('local nativeCurrentQuestOffers = {}','row.role == "poi"','row.eligible == true','nativeCurrentQuestOffers[row.questID] = true','nativeCurrentQuestOffers[row.questID] == true','self.dbHistoricalQuestExcluded = self.dbHistoricalQuestExcluded + 1', 'if add(row,row.role,"map"..tostring(row.questID)) then','if add(row,"poi","line"..tostring(row.questID)) then','and add(row,"poi","db"..tostring(row.npcID)) then','seenQuest[row.questID]=true'):
    need(q in block,'native corroboration or positioned dedup absent: '+q)
need(block.index('local nativeCurrentQuestOffers = {}')<block.index('local seenQuest={}')<block.index('local function add('),'native corroboration must precede candidate accumulation')
# The actual Lua guard is a multiline conjunction, not an unguarded if add(...).
provider = block[block.index('if type(dbRows) == "table" then'):block.index('local function nearestFirst(')]
need('if nativeCurrentQuestOffers[row.questID] == true then' in provider and
     'if not seenQuest[row.questID]\n                            and add(row,"poi","db"..tostring(row.npcID)) then' in provider and
     provider.index('if nativeCurrentQuestOffers[row.questID] == true then') <
     provider.index('if not seenQuest[row.questID]') <
     provider.index('and add(row,"poi","db"..tostring(row.npcID)) then') <
     provider.index('seenQuest[row.questID]=true'),
     'provider fallback must require native corroboration and nonduplicate position')

need(block.index('nativeCurrentQuestOffers[row.questID] == true')>block.index('db:GetNearbyRows('),'QuestieDB provider candidate must be gated')
need('return true\n    end\n    -- QuestPOIMapInfo' in block,'add must return success only after actual candidate is added')
need('self.dbHistoricalQuestExcluded = 0' in c and 'dbHistoricalQuestExcluded = self.dbHistoricalQuestExcluded' in c,'source-candidate exclusion count absent')
for frag in ('Logres:GetModule("QuestieDBNearby")','db:GetNearbyRows(','add(row,"service",','source.questMapRows','source.availableQuestRows','source.areaPoiRows','source.vignetteRows','paint(localPOIs,self.availableQuestPoiMarkers,poiStyle,"poi")','reserveMarkerBearing(candidate.x, markerWidth, occupied)','self.poiCollisionHiddenCount'):
    need(frag in block,'historical source/stock navigation path lost '+frag)
for x in ('read(npc.questStarts, id)','local startQuestID = quests and number(quests[1])','return unique, self.state, services','SERVICE_ROLES','"Forever"'):
    need(x in db,'optional provider or independent services changed '+x)
for x in ('row.eligible = row.onQuest == false and row.completed == false','role = "poi"','self:ReadNativeOfferFeeds()'):
    need(x in n,'native offer eligibility source altered '+x)
for unsafe in ('C_QuestLog.','C_QuestLine.','C_TaskQuest.','C_SuperTrack.','C_Timer.NewTicker','hooksecurefunc(', 'SetUserWaypoint(', 'HideUIPanel('):
    need(unsafe not in block,'Compass must not adopt source/protected API '+unsafe)
need('## OptionalDeps: QuestieDB' in toc,'optional provider required only as optional')
v=re.search(r'(?m)^## Version: (\S+)$',toc);b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',boot)
need(bool(v and b and v.group(1)==b.group(1)),'TOC/Bootstrap metadata mismatch')
need(len([x for x in toc.splitlines() if x.endswith('.lua')])==94,'Lua TOC inventory drift')
for idx in range(317,338):need(f'P{idx:04d}' in cur,'CURRENT history '+str(idx))
for marker in ('CURRENT.md','P0326','P0327','P0335','P0336','P0337'):
    need(marker in handoff,'handoff marker lost '+marker)
need('| L-030 |' in issues and 'P0337' in issues,'L-030 status not updated')
for p in ('docs/memory/evidence/P0337_QUEST_GIVER_ELIGIBILITY.md','docs/memory/patches/P0337_QUEST_GIVER_ELIGIBILITY.md'):
    s=read(p);need('UNVERIFIED' in s and s.endswith('\n') and not s.endswith('\n\n'),'record hygiene '+p)
fixtures();print('P0337 native-current-offer-gated optional QuestieDB glyph contract PASS (static; WoW UNVERIFIED)')
