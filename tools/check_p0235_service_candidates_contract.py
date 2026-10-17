#!/usr/bin/env python3
"""P0235: independent, bounded optional service roles, distinct from quests."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
n=(ROOT/'Logres/Navigation/QuestieDBNearby.lua').read_text()
c=(ROOT/'Logres/Navigation/Compass.lua').read_text()
cmd=(ROOT/'Logres/Core/Commands.lua').read_text()
toc=(ROOT/'Logres/Logres.toc').read_text()
boot=(ROOT/'Logres/Core/Bootstrap.lua').read_text()
errors=[]
def has(s,words,context):
    for w in words:
        if w not in s: errors.append(f'{context}: missing {w}')
has(n,('LOCAL_RADIUS_YARDS = 50','IDS_PER_FRAME = 96',
    'MAX_SERVICE_SPAWNS_PER_NPC = 16','MAX_SERVICE_SPAWNS_PER_CATEGORY = 96',
    'MAX_NEARBY_SERVICES = 4','MAX_NEARBY_PER_SERVICE_KIND = 2',
    'read(lib.RequireContract, 1)','read(lib.RequireContract, 4)',
    'ordinary(lib.Enum, "table")','ordinary(enums.npcFlags, "table")',
    'read(npc.npcFlags, id)', 'read(npc.spawns, id)',
    'local startQuestID = quests and number(quests[1])',
    'if startQuestID or serviceKind then',
    'if startQuestID and not serviceKind then',
    'self.serviceCategoryCached', 'self.serviceStatus',
    'self.serviceNearby = #serviceHits','function Nearby:GetNearbyRows(',
    'return unique, self.state, services', 'SERVICE_PRIORITY',
    'self.state = self.truncated and "ready-partial" or "ready"'), 'nearby')
has(n,('"FLIGHT_MASTER"','"INNKEEPER"','"REPAIR"'), 'role names')
if n.count('read(npc.GetAllIds)') != 1:errors.append('multiple full NPC ID scans')
if n.count('function Nearby:ScanChunk()') != 1:errors.append('multiple chunk scanners')
for term in ('loadstring','C_Timer','GetChildren','EnumeratePins','SetCVar'):
    if term in n:errors.append('forbidden source '+term)
has(c,('db:GetNearbyRows(', 'self.serviceMarkers',
    'self.dbServiceCandidateShown','self.dbServiceStatus',
    'candidate.serviceKind','"Possible flight master: "',
    '"Possible innkeeper: "','"Possible repair: "',
    'glyph:SetVertexColor', 'self.dbCandidateShown',
    'local cap=row.potential == true and 50'), 'compass')
has(cmd,('Logres compass services:', 'Logres questiedbservices:',
    'local function runCompassCheck()',
    'nearby:StartIndex("panel-map-diagnostic")'), 'panel')
if '## OptionalDeps: QuestieDB' not in toc or '## Dependencies: QuestieDB' in toc:
    errors.append('QuestieDB must remain optional')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'Logres.VERSION = "([^"]+)"',boot)
if not a or not b or a.group(1)!=b.group(1):errors.append('runtime version mismatch')
print('P0235 independently classified nearby QuestieDB services')
for e in errors:print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAIL: {len(errors)}')
raise SystemExit(bool(errors))
