#!/usr/bin/env python3
"""P0484: independent guarded quest eligibility without old false positives."""
from pathlib import Path
import re, shutil, subprocess
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
N=read('Logres/Navigation/QuestieDBNearby.lua')
C=read('Logres/Navigation/Compass.lua')
D=read('Logres/Dev/Panel.lua')
for frag in (
 'local MAX_QUEST_ELIGIBILITY_CHECKS_PER_REFRESH = 16',
 'local MAX_QUEST_ELIGIBILITY_CACHE = 2048',
 'function Nearby:EligibilityForQuest(questID)',
 'local allowed, reason = independentlyEligible(questID)',
 'return readBoolean(log.IsOnQuest, questID)',
 'readBoolean(log.IsQuestFlaggedCompleted, questID)',
 'read(db.Get, questID, "name")',
 '"requiredLevel"', '"requiredMaxLevel"','"requiredRaces"','"requiredClasses"',
 '"preQuestGroup"','"preQuestSingle"','"exclusiveTo"','"nextQuestInChain"',
 '"requiredMinRep"','"requiredMaxRep"','"requiredSkill"',
 '"requiredSpecialization"','"requiredSpell"','"requiredRanks"',
 '"specialFlags"','"questFlags"','"availableStartingWith"','"availableUntilCompleted"',
 '"disabledByQuest"','"breadcrumbForQuestId"',
 'return false, "native-quest-status-unavailable"',
 'return false, "already-active-or-complete"',
 'return true, "player-requirements-satisfied"',
 'local allowed, reason = self:EligibilityForQuest(id)',
 'row.providerEligible = true',
 'self.questEligibilityQualifiedNPCs = self.questEligibilityQualifiedNPCs + 1',
 'self:InvalidateEligibility(event)',
 '"QUEST_LOG_UPDATE"','"QUEST_TURNED_IN"','"PLAYER_LEVEL_UP"',
 'eligibilityQualified = self.questEligibilityQualifiedNPCs or 0',
 'eligibilityLastReason = self.questEligibilityLastReason or "none"',
): assert frag in N,frag
for frag in (
 'if nativeCurrentQuestOffers[row.questID] == true then',
 'and add(row,"poi","db"..tostring(row.npcID)) then',
 'elseif row.providerEligible == true and type(row.questID)=="number"',
 'and add(row,"poi","eligible"..tostring(row.npcID)) then',
 'self.dbHistoricalQuestExcluded = self.dbHistoricalQuestExcluded + 1',
 'self.dbEligibilityQuestCandidates = self.dbEligibilityQuestCandidates + 1',
 'if confirmedQuestNPCs[row.npcID] then',
 'dbEligibilityQuestCandidates = self.dbEligibilityQuestCandidates',
): assert frag in C,frag
assert C.index('if nativeCurrentQuestOffers[row.questID] == true then') < C.index('elseif row.providerEligible == true')
assert '"dbEligibilityQuestCandidates"' in D
for unwanted in ('C_Timer','SetCVar(','UnitPosition(','SetUserWaypoint(','GetNamePlateForUnit(', 'HideUIPanel('):
 assert unwanted not in N,unwanted
assert '**P0484**' in read('docs/memory/CURRENT.md')
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0485:')
assert '| L-030 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0484' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
version=re.search(r'^Logres.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'),re.M)
toc=re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M)
assert version and toc and version[1]==toc[1]
engine=shutil.which('texlua') or shutil.which('lua')
if engine:
 subprocess.run([engine,str(R/'tools/test_p0484_quest_eligibility.lua'),str(R)],cwd=R,check=True)
else:print('P0484 Lua fixture DEFERRED: no Lua engine')
print('P0484 native-first guarded player-eligibility, false-positive veto and bounded-cache contract STATIC PASS; WoW UNVERIFIED')
