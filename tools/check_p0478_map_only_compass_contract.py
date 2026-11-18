#!/usr/bin/env python3
"""P0478 L-035: map-only bearings/focus remain available without floor claims."""
from pathlib import Path
import subprocess,shutil,os,re
R=Path(__file__).resolve().parents[1]
C=(R/'Logres/Navigation/Compass.lua').read_text()
D=(R/'Logres/Dev/Panel.lua').read_text()
H=(R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text()
I=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
E=(R/'docs/memory/evidence/P0478_MAP_ONLY_COMPASS_FOCUS.md').read_text()
for tok in ('local uncertainNearNPC = providerNPC and distance < 4 and not liveProof',
            'local centered = questLinked and not uncertainNearNPC',
            'if serviceNPC and liveProof',
            'mapOnly=providerNPC, liveProof=liveProof, uncertainNear=uncertainNearNPC',
            'self.providerNearMapOnlyCandidates = self.providerNearMapOnlyCandidates + 1',
            'self.serviceNearMapOnlyCandidates = self.serviceNearMapOnlyCandidates + 1',
            'self.focusedMarkerDistanceAvailable = false',
            'showProviderMapLabel(self.availableQuestPoiFocus,',
            'label:SetText(name)',
            'serviceNearMapOnlyShown = self.serviceNearMapOnlyShown',
            'serviceNearMapFallbackShown = self.serviceNearMapFallbackShown == true'):
    assert tok in C,tok
segment=C[C.index('local uncertainNearNPC'):C.index('local centered = questLinked')]
assert not re.search(r'^\s*return\b',segment,re.M), 'P0477 early suppression must be removed'
assert 'self.serviceNearUnverifiedHidden = self.serviceNearUnverifiedHidden + 1' not in C
for tok in ('"serviceNearMapOnlyCandidates"','"serviceNearMapOnlyShown"',
            '"serviceNearMapFallbackShown"'):
    assert tok in D,tok
assert H.startswith('# P0482:') and '# P0480:' in H and '# P0479:' in H and '# P0478:' in H and '# P0477:' in H
assert '16476' in E and '16482' in E and 'P0477' in E
assert '| L-035 |' in I and 'P0477' in I and 'P0478' in I
for forb in ('UnitPosition(', 'ClosestUnitPosition(', 'C_Timer.', 'HideUIPanel('):
    assert forb not in C,forb
b=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',(R/'Logres/Core/Bootstrap.lua').read_text(),re.M)
t=re.search(r'^## Version: (0\.0\.\d+-dev)$',(R/'Logres/Logres.toc').read_text(),re.M)
assert b and t and b.group(1)==t.group(1)
lua=os.getenv('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:
    for f in ('tools/test_p0476_npc_near_center.lua', 'tools/test_p0477_live_npc_proof.lua',
              'tools/test_p0478_map_only_label.lua'):
        subprocess.run([lua,str(R/f),str(R)],cwd=R,check=True)
else: print('P0478 actual-source fixtures DEFERRED (Lua interpreter unavailable)')
print('P0478 MAP-ONLY COMPASS source/diagnostic contract STATIC PASS; WoW UNVERIFIED')
