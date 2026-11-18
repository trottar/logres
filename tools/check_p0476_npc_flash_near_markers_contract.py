#!/usr/bin/env python3
"""P0476: L-035 NPC near-centering, L-002 addon-owned flash provenance."""
from pathlib import Path
import os,re,subprocess,shutil
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
C=read('Logres/Navigation/Compass.lua')
D=read('Logres/Quest/Dialogue.lua')
P=read('Logres/Dev/Panel.lua')
E=read('docs/memory/evidence/P0476_NPC_FLASH_AND_NEAR_MARKERS.md')
LEDGER=read('docs/memory/investigations/ISSUE_LEDGER.md')
CURRENT=read('docs/memory/CURRENT.md')
HANDOFF=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
for token in ('local centered = questLinked and (distance<=3 or (wasNear and distance<4))',
    'local serviceNPC = role == "service"',
    'and not isSecret(row.npcID)',
    'type(row.npcID) == "number" and row.npcID > 0',
    'if serviceNPC and (distance<=3 or (wasNear and distance<4)) then',
    'if centered then nearQuestCenterKeys[nearKey] = true end',
    'self.serviceNearCenteredCandidates = self.serviceNearCenteredCandidates + 1',
    'serviceNearCenteredCandidates = self.serviceNearCenteredCandidates'):
    assert token in C,token
assert 'self.nearQuestCenterKeys = nearQuestCenterKeys' in C
assert 'if centered then relative=0 end' in C
assert 'reserveMarkerBearing(candidate.x, markerWidth, occupied)' in C
for token in ('nativeHandoffPending = self.nativeQuestHandoff ~= nil',
 'nativeHandoffHeldCount = self.nativeHandoffHeldCount',
 'nativeHandoffRestoreCount = self.nativeHandoffRestoreCount',
 'lastNativeHandoffReason = self.lastNativeHandoffReason',
 'lastNativeHandoffResult = self.lastNativeHandoffResult',
 'self.lastNativeHandoffResult = "capture-or-bridge-unavailable"'):
    assert token in D,token
for token in ('"nativeHandoffPending"','"nativeHandoffHeldCount"',
 '"nativeHandoffRestoreCount"','"lastNativeHandoffReason"',
 '"lastNativeHandoffResult"','"stockOfferSuppressionApplied"'):
    assert token in P,token
# No new hooks, cross-frame probes or native Hide actions in the diagnostic block.
assert 'nativeHandoffPending' in P[P.index('incident.snapshot.questPresentation'):P.index('journal.incidents[#journal.incidents + 1]')]
assert 'incident.snapshot.compassNearNPC' in P and '"serviceNearCenteredCandidates"' in P
assert 'L-002' in LEDGER and 'L-035' in LEDGER and 'OPEN' in LEDGER
assert 'No Blizzard frame' in E and 'WoW Forever' in E
assert HANDOFF.startswith('# P0476:') and '# P0474:' in HANDOFF
assert len(CURRENT.encode())<9800 and len(HANDOFF.encode())<8000
b=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',read('Logres/Core/Bootstrap.lua'),re.M)
t=re.search(r'^## Version: (0\.0\.\d+-dev)$',read('Logres/Logres.toc'),re.M)
assert b and t and b.group(1)==t.group(1)
lua=os.environ.get('LOGRES_LUA') or shutil.which('texlua') or shutil.which('lua')
if lua:
 subprocess.run([lua,str(R/'tools/test_p0476_npc_near_center.lua'),str(R)],cwd=R,check=True)
else: print('P0476 actual-source Lua UNVERIFIED: interpreter unavailable')
print('P0476 NPC-center/quest-handoff diagnostic: PASS (STATIC; WoW UNVERIFIED)')
