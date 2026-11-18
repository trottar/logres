#!/usr/bin/env python3
"""P0480: no-target NPC range sources without changing approved compass visual policy."""
from pathlib import Path
import re, shutil, subprocess
R=Path(__file__).resolve().parents[1]
C=(R/'Logres/Navigation/Compass.lua').read_text()
D=(R/'Logres/Dev/Panel.lua').read_text()
E=(R/'docs/memory/evidence/P0480_PASSIVE_NPC_PROXIMITY.md').read_text()
I=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
H=(R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text()
for token in ('local visibleNameplateUnits = {}',
              'local function readNearbyNPCIDs()',
              '"softinteract", "npc", "mouseover", "target"',
              '"NAME_PLATE_UNIT_ADDED"', '"NAME_PLATE_UNIT_REMOVED"',
              'not isSecret(guid)', 'not isSecret(close)',
              'local lockOK, locked = pcall(combatGate)',
              'pcall(inRange, unit, 3)',
              'local nearbyLiveNPCIDs, nearbyProofSources = readNearbyNPCIDs()',
              'if serviceNPC and liveProof',
              'distance<=3 or (wasNear and distance<4)',
              'self.serviceNearProofSoftInteract',
              'self.serviceNearProofNameplate',
              'self.serviceNearProofOther',
              'local priorServiceBearings = self.serviceBearingMapID == mapID',
              'label:SetText(name)',
              'local function showProviderMapLabel(',
              'self.serviceNearBearings = nextServiceBearings'):
    assert token in C, token
assert C.count('NAME_PLATE_UNIT_ADDED') >= 2
assert C.count('NAME_PLATE_UNIT_REMOVED') >= 2
assert 'if isSecret(unit) or type(unit) ~= "string" then return end' in C
assert 'index < 1 or index > 40' in C
for banned in ('SetCVar(', 'TargetUnit(', 'InteractUnit(', 'ClosestUnitPosition(',
               'UnitPosition(', 'C_Timer.', 'HideUIPanel(', 'RegisterStateDriver(',
               '"~" .. tostring', 'floor unknown', 'Services at map location'):
    assert banned not in C, banned
for name in ('"serviceNearProofSoftInteract"','"serviceNearProofNameplate"',
             '"serviceNearProofOther"','"nameplateEventRegistered"'):
    assert name in D, name
assert H.startswith('# P0480:') and '# P0479:' in H
assert 'L-035' in I and 'P0480' in I and 'P0479' in I
for x in ('P0476','P0477','P0478','P0479','P0480','softinteract','nameplate'):
    assert x in E,x
boot=(R/'Logres/Core/Bootstrap.lua').read_text()
toc=(R/'Logres/Logres.toc').read_text()
a=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',boot,re.M)
b=re.search(r'^## Version: (0\.0\.\d+-dev)$',toc,re.M)
assert a and b and a.group(1)==b.group(1)
lua=shutil.which('texlua') or shutil.which('lua')
if lua:
    for f in ('test_p0476_npc_near_center.lua',
              'test_p0477_live_npc_proof.lua',
              'test_p0478_map_only_label.lua',
              'test_p0480_passive_npc_near.lua'):
        subprocess.run([lua,str(R/'tools'/f),str(R)],check=True,cwd=R,
                       stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
else:
    print('Lua fixture DEFERRED: interpreter unavailable')
print('P0480 no-target NPC proof and visual preservation STATIC PASS; WoW UNVERIFIED')
