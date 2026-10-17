#!/usr/bin/env python3
"""P0236: wide service-role exploration and ordinary local-POI size contract."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
n=(r/'Logres/Navigation/QuestieDBNearby.lua').read_text()
c=(r/'Logres/Navigation/Compass.lua').read_text()
cmd=(r/'Logres/Core/Commands.lua').read_text()
toc=(r/'Logres/Logres.toc').read_text()
boot=(r/'Logres/Core/Bootstrap.lua').read_text()
errors=[]
roles=['FLIGHT_MASTER','INNKEEPER','REPAIR','VENDOR','TRAINER','BANKER','AUCTIONEER','STABLEMASTER','BATTLEMASTER','SPIRIT_HEALER','SPIRIT_GUIDE','TABARD_DESIGNER','PETITIONER','BARBER','ARCANE_REFORGER','TRANSMOGRIFIER']
for role in roles:
    if 'flag = "'+role+'"' not in n:errors.append('missing role '+role)
for term in ['MAX_NEARBY_SERVICES = 32','MAX_NEARBY_PER_SERVICE_KIND = 2','LOCAL_RADIUS_YARDS = 50','read(lib.RequireContract, 4)','self.serviceRoleMasks[role.kind]','read(npc.npcFlags, id)','self.serviceNearbyKinds = count','serviceRoleCount = (function()','return unique, self.state, services']:
    if term not in n:errors.append('source missing '+term)
if n.count('read(npc.GetAllIds)')!=1:errors.append('unexpected full index scanning')
for term in ['local function nearbySizeScale(', 'math.max(0.74, math.min(1.30', 'self.poiSizeShown','self.poiSizeMin','self.poiSizeMax', 'glyph:SetSize((roleStyle.width or 9)*scale','for index = 1, 32 do']:
    if term not in c:errors.append('compass missing '+term)
for role in ['vendor','trainer','banker','auction','stable','battle','healer','guide','tabard','petition','barber','reforge','transmog']:
    if role+' = { name = "Possible ' not in c:errors.append('missing service label '+role)
for term in ['Logres questiedbservicecoverage:','Logres compass POI proximity:']:
    if term not in cmd:errors.append('diagnostic missing '+term)
if '## OptionalDeps: QuestieDB' not in toc or '## Dependencies: QuestieDB' in toc:errors.append('QuestieDB must remain optional')
a=re.search(r'^## Version: (\S+)$',toc,re.M);b=re.search(r'Logres.VERSION = "([^"]+)"',boot)
if not a or not b or a.group(1)!=b.group(1):errors.append('version mismatch')
for term in ['EnumeratePins','GetChildren','loadstring','C_Timer','SetCVar']:
    if term in n:errors.append('unsupported data acquisition shortcut '+term)
print('P0236 wide service POIs / distance-sized local glyph contract')
for e in errors:print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAILED: {len(errors)}')
raise SystemExit(bool(errors))
