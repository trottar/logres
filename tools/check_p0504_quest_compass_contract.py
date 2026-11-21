#!/usr/bin/env python3
"""P0504 exact-source quest-link handoff and observed native no-offer guard."""
from pathlib import Path
import re, shutil, subprocess
R=Path(__file__).resolve().parents[1]
read=lambda path:(R/path).read_text()
gossip=read('Logres/Quest/NPCGossipPresentation.lua')
quest=read('Logres/Quest/NPCGossipQuestChoice.lua')
near=read('Logres/Navigation/QuestieDBNearby.lua')
for part in ('(kind == "gossip-option" or kind == "quest-link") and active',
    'if choiceTicket ~= nil then\n        choiceOutcome = "interaction-hidden-awaiting-branch"',
    'function Live.OnChoiceHandoffTimeout(ticket)',
    'if choiceTicket ~= nil then\n        -- Native close commonly precedes service-open',
    'hide("gossip-handoff-" .. event)'):
    assert part in gossip, part
for part in ('BeforeNativeChoice("quest-link")',
    'pcall(fn, chosen.questID)', 'OnNativeChoiceFailed(ticket)',
    'OnNativeChoice(ticket)'):
    assert part in quest, part
assert quest.index('BeforeNativeChoice("quest-link")') < quest.index('pcall(fn, chosen.questID)')
for part in ('function Nearby:ObserveNativeAvailableQuests(event)',
    'self.frame:RegisterEvent("GOSSIP_SHOW")',
    'self.frame:RegisterEvent("QUEST_GREETING")',
    'local id = currentOrdinaryNPCID()',
    'if absent == nil then return end',
    'if not observedNoOffer and type(ids) == "table" then',
    'self.observedNoOfferNPCIDs = {}',
    '"native-visit-no-offers"',
    'observedNoOfferLastNPCID = self.observedNoOfferLastNPCID'):
    assert part in near, part
assert 'observedNoOffer' not in read('Logres/Navigation/Compass.lua'), 'negative is provider-owned only'
assert 'SetScript("OnUpdate"' not in gossip and 'SetScript("OnUpdate"' not in quest
assert 'C_Timer.' not in gossip and 'C_Timer.' not in quest
assert 'L-030' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0504' in read('docs/memory/evidence/P0504_QUEST_HANDOFF_AND_FALSE_QUEST_GIVER.md')
a=re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M)
b=re.search(r'^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'),re.M)
assert a and b and a.group(1)==b.group(1)
lua=shutil.which('lua5.4') or shutil.which('texlua') or shutil.which('lua')
assert lua, 'P0504 requires actual-source Lua fixture'
for test in ('tools/test_p0503_gossip_handoff.lua','tools/test_p0486_quest_flags.lua'):
    subprocess.run([lua,str(R/test),str(R)],cwd=R,check=True)
print('P0504 source-owned bounded quest handoff and observed no-offer compass STATIC PASS; WoW UNVERIFIED')
