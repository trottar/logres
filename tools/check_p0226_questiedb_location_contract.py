#!/usr/bin/env python3
"""P0226 optional, evidence-first QuestieDB runtime probe contract."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
probe=(R/'Logres/Navigation/QuestieDBLocationProbe.lua').read_text()
cmd=(R/'Logres/Core/Commands.lua').read_text()
toc=(R/'Logres/Logres.toc').read_text()
errors=[]
required=(
 'Logres:RegisterModule("QuestieDBLocationProbe", { autoEnable = true })',
 'LibQuestieDB', 'db.RequireContract', 'indicator.GetStatus',
 'quest.startedBy', 'npc.spawns', 'LOCH_MODAN_UI_MAP = 1432',
 'LOCH_MODAN_AREA_ID = 38', 'MAX_GOSSIP_OFFERS = 8',
 'MAX_QUEST_START_NPCS = 6', 'MAX_SPAWNS = 12',
 'function Probe:CaptureGossip', 'function Probe:CaptureManual()',
 'function Probe:GetDebugStatus()', 'pcall(issecretvalue, value)',
 'gossip-or-npc-identity-unavailable', 'accepted-quest-excluded',
 'observed-offer-npc-and-nearby-spawn-match',
)
for s in required:
 if s not in probe:errors.append('probe missing '+s)
for s in ('GetAllIds','GetRaw','SetTracking','SetCVar','SetSuperTracked','C_Timer',
          'OnUpdate','GetNumChildren','EnumeratePins','hooksecurefunc','loadstring',
          'GetChildren','SetParent','QuestDB.GetAllIds','Minimap:Get'):
 if s in probe: errors.append('probe forbidden '+s)
for s in ('function Logres:RunQuestieDBLocationProbe()',
          'if command == "questiedbprobe" then',
          'Logres:RunQuestieDBLocationProbe()',
          '"questieDBLocationProbe"',
          '"QuestieDB Location Probe"',
          '"questiedbprobe"',
          'emit("  /logres questiedbprobe")'):
 if s not in cmd:errors.append('command missing '+s)
# The slash dispatcher is at the 60-upvalue budget on Forever; do not add
# a further local runner. A namespace method is an existing captured upvalue.
if 'local function runQuestieDBLocationProbe()' in cmd:
 errors.append('questiedb runner must be a namespace method, not a new handler upvalue')
items=('Navigation\\NavigationSourceProbe.lua','Navigation\\QuestieDBLocationProbe.lua','Quest\\ContextVisual.lua')
places=[toc.find(x) for x in items]
if -1 in places or not places[0]<places[1]<places[2]:errors.append('TOC optional probe order incorrect')
# Keep the version contract current; never freeze a historical runtime version.
bootstrap=(R/'Logres/Core/Bootstrap.lua').read_text()
toc_version=re.search(r'^## Version: ([^\n]+)$',toc,re.MULTILINE)
bootstrap_version=re.search(r'^Logres\.VERSION = "([^"\n]+)"$',bootstrap,re.MULTILINE)
if not toc_version or not bootstrap_version:
 errors.append('TOC or Bootstrap version metadata missing')
elif toc_version.group(1)!=bootstrap_version.group(1):
 errors.append('TOC/Bootstrap versions differ')
print('P0226 optional QuestieDB read-only public-contract probe')
for e in errors:print('ERROR:',e)
print('PASS: 0 errors' if not errors else 'FAILED: '+str(len(errors))+' errors')
raise SystemExit(bool(errors))
