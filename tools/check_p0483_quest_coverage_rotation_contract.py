#!/usr/bin/env python3
"""P0483: current-native corroboration, dual-role multiquest, bounded rotation recovery."""
from pathlib import Path
import re,subprocess,shutil
R=Path(__file__).resolve().parents[1];read=lambda p:(R/p).read_text()
C=read('Logres/Navigation/Compass.lua');N=read('Logres/Navigation/QuestieDBNearby.lua')
D=read('Logres/Dev/Panel.lua');A=read('docs/memory/PRE_HANDOFF_AUDIT.md')
for frag in ('local MAX_QUEST_IDS_PER_NPC = 32','local startQuestID = quests and number(quests[1])',
 'questIDs = questIDs','questIDs = item.questIDs',
 'if type(currentQuestOffers) == "table" then','if #questIDs > 0 then','if #questIDs > 0 or serviceKind then'):
 assert frag in N,frag
for frag in ('nativeCurrentQuestOffers[row.questID] == true','self.dbHistoricalQuestExcluded = self.dbHistoricalQuestExcluded + 1',
 'if not seenQuest[row.questID]','if type(row.questIDs) == "table" then',
 'confirmedQuestNPCs[row.npcID] = true','self.dbDualRoleServiceSuppressed',
 'arrivalHeadings','rotationRecovered','math.abs(swept) <= 60',
 'self.npcArrivalRotationRecovered','self.arrivalHeadingMapID = mapID'):
 assert frag in C,frag
for frag in ('"dbNativeOfferCount"','"dbConfirmedQuestCandidates"',
 '"dbHistoricalQuestExcluded"','"dbDualRoleServiceSuppressed"','"npcArrivalRotationRecovered"'):
 assert frag in D,frag
for frag in ('incident.snapshot.questCompassSources', 'incident.snapshot.questCompassDB'):
 assert frag in D,frag
for banned in ('C_Timer','SetCVar','UnitPosition(','GetNamePlateForUnit(','GetQuestReward(', 'IsQuestAvailable('):
 assert banned not in C,banned
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0485:')
assert '**P0483**' in read('docs/memory/CURRENT.md')
assert '| L-030 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0483' in A
boot=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',read('Logres/Core/Bootstrap.lua'),re.M)
toc=re.search(r'^## Version: (0\.0\.\d+-dev)$',read('Logres/Logres.toc'),re.M)
assert boot and toc and boot[1]==toc[1]
engine=shutil.which('texlua') or shutil.which('lua')
if engine:
 subprocess.run([engine,str(R/'tools/test_p0483_quest_rotation.lua'),str(R)],cwd=R,check=True)
else:print('P0483 Lua fixture DEFERRED (no engine)')
print('P0483 bounded quest source / rotation safety contract STATIC PASS; WoW UNVERIFIED')
