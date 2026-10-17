#!/usr/bin/env python3
"""Static source contract for P0230 dynamic QuestieDB candidate feed."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
f=(R/'Logres/Navigation/QuestieDBNearby.lua').read_text()
c=(R/'Logres/Navigation/Compass.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
cmd=(R/'Logres/Core/Commands.lua').read_text()
err=[]
for term in ('LOCAL_RADIUS_YARDS = 50','IDS_PER_FRAME = 96',
 'MAX_CACHED_SPAWNS = 1024','MAX_NEARBY = 8',
 'readAreaMap(lib)','Support','uiMapIdToAreaId',
 'GetBestMapForUnit','GetMapInfo','PLAYER_MAP_CHANGED',
 'read(npc.GetAllIds)','read(npc.zoneID, id)',
 'read(npc.questStarts, id)','read(npc.spawns, id)',
 'function Nearby:GetNearbyRows(', 'function Nearby:ScanChunk()',
 'self:StopIndex()', 'potential = true'):
 if term not in f:err.append('module missing '+term)
for term in ('LOCH_MODAN_MAP','LOCH_MODAN_AREA','QuestDB.GetAllIds',
             'GetChildren','EnumeratePins','C_Timer','loadstring','SetCVar'):
 if term in f:err.append('forbidden implementation shortcut: '+term)
if f.count('read(npc.GetAllIds)')!=1:err.append('NPC list should be read once per area-index build')
for term in ('Logres:GetModule("QuestieDBNearby")','db:GetNearbyRows(',
 'self.dbCandidateShown', 'Possible quest giver: ',
 'candidate.potential', 'self.dbNearbyStatus',
 'local cap=row.potential == true and 50'):
 if term not in c:err.append('compass integration missing '+term)
if 'Logres questiedbnearby:' not in cmd or '"questieDBLocationProbe"' not in cmd:
 err.append('existing Phase E panel probe not wired')
if '## OptionalDeps: QuestieDB' not in t:err.append('missing optional TOC dependency')
if '## Dependencies: QuestieDB' in t:err.append('unexpected required dependency')
order=['Navigation\\NavigationSourceProbe.lua','Navigation\\QuestieDBLocationProbe.lua',
       'Navigation\\QuestieDBNearby.lua','Quest\\ContextVisual.lua']
positions=[t.find(v) for v in order]
if -1 in positions or positions != sorted(positions):err.append('TOC load order wrong')
v=re.search(r'(?m)^## Version: (\S+)$',t)
w=re.search(r'Logres.VERSION = "([^"]+)"',b)
if not v or not w or v.group(1)!=w.group(1):err.append('version mismatch')
print('P0230 dynamic QuestieDB candidate source contract')
for e in err:print('ERROR:',e)
print('PASS: 0 errors' if not err else f'FAILED: {len(err)}')
raise SystemExit(bool(err))
