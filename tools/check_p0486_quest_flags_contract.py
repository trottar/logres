#!/usr/bin/env python3
"""P0486: reject only conditional/unsupported flags, never ordinary shareable Classic quests."""
from pathlib import Path
import re,shutil,subprocess
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
N=read('Logres/Navigation/QuestieDBNearby.lua')
for fragment in (
 'local questFlags, questFlagsKnown = optionalNumber("questFlags")',
 'local remainingFlags = questFlags',
 'for _, bit in ipairs({1, 2, 4, 8, 32, 64, 256, 512}) do',
 'if remainingFlags ~= 0 then return false, "conditional-quest-flags" end',
 'if not flagsKnown or flags ~= 0 then return false, "conditional-special-flags" end',
 'if onQuest or completed then return false, "already-active-or-complete" end',
 'if not groupKnown or not singleKnown then return false, "prerequisite-read-unavailable" end',
 'if self.questEligibilityChecksThisRefresh >= MAX_QUEST_ELIGIBILITY_CHECKS_PER_REFRESH',
):assert fragment in N,fragment
assert 'if not questFlagsKnown or questFlags ~= 0' not in N
assert 'eligibleFlag' not in read('Logres/Navigation/Compass.lua')
assert 'dbEligibilityQuestCandidates' in read('Logres/Navigation/Compass.lua')
assert '"eligibilityClosestRejectedReason"' in read('Logres/Dev/Panel.lua')
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0486:')
assert '**P0486**' in read('docs/memory/CURRENT.md')
assert 'P0485 Forever FAIL' in read('docs/memory/evidence/P0486_INFORMATIONAL_QUEST_FLAGS.md')
boot=re.search(r'^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'),re.M)
toc=re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M)
assert boot and toc and boot[1]==toc[1]
for forbidden in ('C_Timer','SetCVar(','UnitPosition(','HideUIPanel('):
 assert forbidden not in N,forbidden
engine=shutil.which('texlua') or shutil.which('lua')
if engine: subprocess.run([engine,str(R/'tools/test_p0486_quest_flags.lua'),str(R)],cwd=R,check=True)
else: print('P0486 actual-source Lua fixture DEFERRED: no interpreter')
print('P0486 quest flag semantic distinction/native source and historical state gates STATIC PASS; client UNVERIFIED')
