#!/usr/bin/env python3
"""P0485: sparse optional QuestieDB fields and incident trace, no historical-only approval."""
from pathlib import Path
import re,shutil,subprocess
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
N=read('Logres/Navigation/QuestieDBNearby.lua')
D=read('Logres/Dev/Panel.lua')
C=read('Logres/Navigation/Compass.lua')
for frag in (
 'local function optionalNumber(key)',
 'local classified, secret = pcall(issecretvalue, value)',
 'if not classified or secret ~= false then return nil, false end',
 'if value == nil then return 0, true end',
 'local requiredLevel, requiredKnown = optionalNumber("requiredLevel")',
 'local maxLevel, maxKnown = optionalNumber("requiredMaxLevel")',
 'local races, racesKnown = optionalNumber("requiredRaces")',
 'local classes, classesKnown = optionalNumber("requiredClasses")',
 'if not groupKnown or not singleKnown then',
 'if #ids == 0 then return true end',
 'local value, known = optionalNumber(spec[1])',
 'local flags, flagsKnown = optionalNumber("specialFlags")',
 'local questFlags, questFlagsKnown = optionalNumber("questFlags")',
 'eligibilityClosestRejectedReason = self.questEligibilityClosestRejectedReason',
 'eligibilityFirstQualifiedQuestID = self.questEligibilityFirstQualifiedQuestID',
):assert frag in N,frag
for frag in ('"eligibilityQualified"', '"eligibilityRejected"',
 '"eligibilityLastReason"','"eligibilityClosestRejectedReason"',
 '"eligibilityFirstQualifiedQuestID"'):
 assert frag in D,frag
assert 'row.providerEligible == true' in C
assert 'nativeCurrentQuestOffers[row.questID] == true' in C
for frag in ('C_Timer','SetCVar(','UnitPosition(','HideUIPanel('):
 assert frag not in N,frag
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0485:')
assert '**P0485**' in read('docs/memory/CURRENT.md')
assert 'P0484 FAIL on this case' in read('docs/memory/evidence/P0485_SPARSE_QUEST_ELIGIBILITY.md')
boot=re.search(r'^Logres.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'),re.M)
toc=re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M)
assert boot and toc and boot[1]==toc[1]
engine=shutil.which('texlua') or shutil.which('lua')
if engine:subprocess.run([engine,str(R/'tools/test_p0485_sparse_quest_eligibility.lua'),str(R)],cwd=R,check=True)
else:print('P0485 Lua fixture DEFERRED: no Lua interpreter')
print('P0485 sparse quest restrictions, incident observability, native priority contract STATIC PASS; client UNVERIFIED')
