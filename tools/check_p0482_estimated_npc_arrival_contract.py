#!/usr/bin/env python3
"""P0482: estimate 2/3yd, proven-native 3/4yd, no loss of native/secret fallback."""
from pathlib import Path
import re, os, shutil, subprocess
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
C=read('Logres/Navigation/Compass.lua')
H=C.split('local function chooseNPCArrivalLock(',1)[1].split('-- A focus label may format',1)[0]
for tok in ('previous.source == "native" and 4 or 3', 'item.distance < holdLimit',
 'nativeArrival and item.distance <= 3',
 'not nativeArrival and item.distance <= 2 and item.arrivalMagnitude <= 8',
 'selected.liveProof == true and "native"', 'not item.arrivalRejected',
 'previous.key == item.arrivalKey', 'previous.mapID == mapID',
 'local selected = held or best', '"compass-estimate"'):
 assert tok in H,tok
for tok in ('local priorHoldLimit = previousNPCArrival',
 'previousNPCArrival.source == "native" and 4 or 3',
 'distance < priorHoldLimit', 'not isSecret(row.sourceX)',
 'candidate.arrivalRejected = nearbyRefusedNPCIDs[row.npcID] == true and not liveProof',
 'showProviderMapLabel(self.availableQuestPoiFocus,',
 'local uncertainNearNPC = providerNPC and distance < 4 and not liveProof',
 'distance<=3 or (wasNear and distance<4)'):
 assert tok in C,tok
for bad in ('UnitGUID', 'CheckInteractDistance', 'C_Timer', 'UnitPosition', 'SetCVar', 'SetScript'):
 assert bad not in H,bad
for bad in ('"~" .. tostring','floor unknown','Services at map location','ClosestUnitPosition('):
 assert bad not in C,bad
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0484:')
assert '# P0481:' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert '**P0482**' in read('docs/memory/CURRENT.md')
assert '| L-035 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'session162' in read('docs/memory/evidence/P0482_ESTIMATED_NPC_ARRIVAL_HYSTERESIS.md')
a=re.search(r'^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'),re.M)
b=re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M)
assert a and b and a.group(1)==b.group(1)
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:
 subprocess.run([lua,str(R/'tools/test_p0481_npc_arrival.lua'),str(R)],cwd=R,check=True)
else: print('P0482 actual source fixture DEFERRED: no Lua interpreter')
print('P0482 separated estimated/native arrival and fallback contract STATIC PASS; WoW UNVERIFIED')
