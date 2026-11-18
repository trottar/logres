#!/usr/bin/env python3
"""P0477: near provider NPC bearings require live identity/range proof."""
from pathlib import Path
import re, subprocess, shutil, os
R=Path(__file__).resolve().parents[1]
C=(R/'Logres/Navigation/Compass.lua').read_text()
D=(R/'Logres/Dev/Panel.lua').read_text()
L=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
E=(R/'docs/memory/evidence/P0477_VERTICAL_NPC_GUARD.md').read_text()
H=(R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text()
for token in ('local function readNearbyNPCIDs()', 'pcall(getGUID, unit)',
              'local lockOK, locked = pcall(combatGate)',
              'locked ~= false', 'not isSecret(guid)', 'pcall(inRange, unit, 3)',
              'not isSecret(close)', 'local nearbyLiveNPCIDs, nearbyProofSources = readNearbyNPCIDs()',
              'local providerNPC = row.potential == true',
              'local uncertainNearNPC = providerNPC and distance < 4 and not liveProof',
              'self.providerNearMapOnlyCandidates = self.providerNearMapOnlyCandidates + 1',
              'self.serviceNearMapOnlyCandidates = self.serviceNearMapOnlyCandidates + 1',
              'if serviceNPC and liveProof',
              'serviceNearMapOnlyCandidates = self.serviceNearMapOnlyCandidates',
              'providerNearMapOnlyCandidates = self.providerNearMapOnlyCandidates'):
    assert token in C, token
for forbidden in ('UnitPosition(', 'ClosestUnitPosition(', 'C_Timer.', 'SecureHandler',
                  'HideUIPanel('):
    assert forbidden not in C, 'forbidden mutation/API '+forbidden
assert 'SetScript("OnUpdate"' not in C[C.index('local function readNearbyNPCIDs()'):C.index('-- A focus label may format')], 'no new polling helper'
for token in ('"serviceNearMapOnlyCandidates"','"providerNearMapOnlyCandidates"'):
    assert token in D,token
assert 'L-035' in L and 'P0476' in L and '16399' in L
assert 'no verified elevation' in E and 'P0476' in E
assert H.startswith('# P0480:') and '# P0479:' in H and '# P0478:' in H and '# P0477:' in H and '# P0476:' in H
bootstrap=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',(R/'Logres/Core/Bootstrap.lua').read_text(),re.M)
toc=re.search(r'^## Version: (0\.0\.\d+-dev)$',(R/'Logres/Logres.toc').read_text(),re.M)
assert bootstrap and toc and bootstrap.group(1)==toc.group(1)
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:
    for f in ['tools/test_p0476_npc_near_center.lua','tools/test_p0477_live_npc_proof.lua']:
        subprocess.run([lua,str(R/f),str(R)],cwd=R,check=True)
else:
    print('P0477 actual-source Lua UNVERIFIED: interpreter unavailable')
print('P0477 vertical NPC projected-source safety STATIC PASS; WoW UNVERIFIED')
