#!/usr/bin/env python3
"""P0479: do not regress the accepted compass visual language."""
from pathlib import Path
import subprocess, shutil, re
R=Path(__file__).resolve().parents[1]
C=(R/'Logres/Navigation/Compass.lua').read_text()
D=(R/'Logres/Dev/Panel.lua').read_text()
L=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
E=(R/'docs/memory/evidence/P0479_COMPASS_VISUAL_RECOVERY.md').read_text()
H=(R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text()
for tok in ('local function showProviderMapLabel(',
            'label:SetText(name)',
            'showFocusedMarkerLabel(label, name, yards, magnitude)',
            'local priorServiceBearings = self.serviceBearingMapID == mapID',
            'local nextServiceBearings = {}',
            'nextServiceBearings[nearKey] = bearing',
            'self.serviceNearBearings = nextServiceBearings',
            'if serviceNPC and liveProof',
            'serviceNearBearingHeld = self.serviceNearBearingHeld',
            'self.serviceNearMapFallbackShown = false'):
    assert tok in C,tok
for bad in ('floor unknown','Services at map location','"~" .. tostring',
            'map position (floor','* (candidate.uncertainNear and 0.65 or 1)',
            'self.focusedMarkerKind = "service-map-only"'):
    assert bad not in C,bad
assert '"serviceNearBearingHeld"' in D
assert H.startswith('# P0480:') and '# P0479:' in H and '# P0478:' in H
assert '| L-031 |' in L and '| L-035 |' in L
assert all(x in E for x in ('16561','16569','P0478 VISUAL FAIL'))
assert re.search(r'0\.0\.\d+-dev',E)
for bad in ('UnitPosition(', 'C_Timer.', 'HideUIPanel(', 'RegisterStateDriver('):
    assert bad not in C,bad
boot=(R/'Logres/Core/Bootstrap.lua').read_text()
toc=(R/'Logres/Logres.toc').read_text()
a=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',boot,re.M)
b=re.search(r'^## Version: (0\.0\.\d+-dev)$',toc,re.M)
assert a and b and a.group(1)==b.group(1)
lua=shutil.which('texlua') or shutil.which('lua')
if lua:
    for f in ('tools/test_p0476_npc_near_center.lua',
              'tools/test_p0477_live_npc_proof.lua',
              'tools/test_p0478_map_only_label.lua'):
        subprocess.run([lua,str(R/f),str(R)],cwd=R,check=True)
else: print('Source Lua fixtures UNVERIFIED: interpreter unavailable')
print('P0479 compass accepted typography / bearing latch contract STATIC PASS; WoW UNVERIFIED')
