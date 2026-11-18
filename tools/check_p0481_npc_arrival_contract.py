#!/usr/bin/env python3
"""Probable NPC arrival is an explicit policy, never native/floor evidence."""
from pathlib import Path
import os,shutil,subprocess,re
R=Path(__file__).resolve().parents[1];read=lambda p:(R/p).read_text()
C=read('Logres/Navigation/Compass.lua');D=read('Logres/Dev/Panel.lua')
helper=C.split('local function chooseNPCArrivalLock(',1)[1].split('-- A focus label may format',1)[0]
for s in ('not item.arrivalRejected','item.distance <= 3','item.distance <= 2',
 'previous.source == "native" and 4 or 3','item.distance < holdLimit',
 'previous.mapID == mapID','previous.key == item.arrivalKey',
 'not nativeArrival and item.distance <= 2 and item.arrivalMagnitude <= 8',
 'local selected = held or best','"compass-estimate"'):
 assert s in helper,s
for bad in ('UnitGUID','UnitPosition','CheckInteractDistance','C_Timer','SetScript','SetCVar','ClosestUnitPosition'):
 assert bad not in helper,bad
for s in ('sourceX = item.x, sourceY = item.y,',):assert read('Logres/Navigation/QuestieDBNearby.lua').count(s)==2
for s in ('local previousNPCArrival = self.npcArrivalLock','candidate.arrivalKey = nearKey',
 'not isSecret(row.sourceX)','previousNPCArrival.key == priorKey','arrival.arrivalLocked = true',
 'not closestFocus.arrivalLocked','self.npcArrivalLock = nil','refused[id] = true'):
 assert s in C,s
for s in ('npcArrivalLockActive','npcArrivalLockSource','npcArrivalLockTransition','npcArrivalLockNPCID','npcArrivalLockMapDistanceYards','npcArrivalLockRendered'):
 assert s+' =' in C and '"'+s+'"' in D,s
for bad in ('SetCVar(', 'UnitPosition(', 'ClosestUnitPosition(', 'C_Timer.', 'Services at map location','floor unknown','"~" .. tostring'):
 assert bad not in C,bad
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0485:')
assert '# P0481:' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert 'L-035' in read('docs/memory/evidence/P0481_NPC_ARRIVAL_LOCK.md')
assert 'P0481' in read('docs/memory/investigations/ISSUE_LEDGER.md')
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua5.4')
if lua:
 for f in ('test_p0481_npc_arrival.lua','test_p0476_npc_near_center.lua','test_p0477_live_npc_proof.lua','test_p0478_map_only_label.lua','test_p0480_passive_npc_near.lua'):
  subprocess.run([lua,str(R/'tools'/f),str(R)],cwd=R,check=True)
else:print('Source Lua fixtures UNVERIFIED: no interpreter')
print('P0481 probable NPC arrival STATIC PASS; client floor/usability UNVERIFIED')
