#!/usr/bin/env python3
"""P0320: validated gossip quest links, no automatic acceptance or stock suppression."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
read=lambda p:(ROOT/p).read_text(encoding='utf-8')
s=read('Logres/Quest/NPCGossipSource.lua')
q=read('Logres/Quest/NPCGossipQuestChoice.lua')
c=read('Logres/Quest/NPCGossipChoice.lua')
session=read('Logres/Quest/OptionSession.lua')
v=read('Logres/UI/OptionList.lua')
live=read('Logres/Quest/NPCGossipPresentation.lua')
commands=read('Logres/Core/Commands.lua')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
current=read('docs/memory/CURRENT.md')
evidence=read('docs/memory/evidence/P0320_QUEST_GOSSIP_LINKS.md')
errors=[]
def need(ok, why):
    if not ok: errors.append(why)
for term in ('local function appendQuestChoices(', 'member(row, "title")',
             'member(row, "questID")', 'questKind = kind', 'questID = identity',
             'displayChoices', 'appendQuestChoices(available, "available"',
             'appendQuestChoices(active, "active"',
             'model.questSummary = { available = #available, active = #active }',
             'audit("model-ready", interaction, #choices, totalQuests',
             'enabled = false'):
    need(term in s,'source missing '+term)
for term in ('Logres.NPCGossipQuestChoice = Quest',
             'function Quest.CanSelect(kind)', 'function Quest.Activate(model, index)',
             'function Quest.GetAudit()', 'C_GossipInfo[key]',
             '"SelectAvailableQuest"', '"SelectActiveQuest"',
             'chosen.questID', 'Logres.NPCGossipSource.Sample()',
             'fresh.title ~= model.title', 'fresh.gossipKind ~= model.gossipKind',
             'a.questID ~= b.questID', 'a.gossipOptionID ~= b.gossipOptionID',
             'pcall(fn, chosen.questID)', 'InCombatLockdown', 'issecretvalue'):
    need(term in q,'quest controller missing '+term)
for forbidden in ('AcceptQuest(', 'CompleteQuest(', 'GetQuestReward(',
                  'SelectGossipOption(', 'BuyTrainerService(', 'SetAlpha(',
                  'HideUIPanel(', 'C_Timer.', 'SetScript("OnUpdate"',
                  'GossipFrame:Hide', 'DynamicCam'):
    need(forbidden not in q,'quest controller forbidden action '+forbidden)
need('Logres.NPCGossipQuestChoice.Activate(self.model, index)' in session
     and 'Logres.NPCGossipChoice.Activate(self.model, index)' in session,
     'session must retain both separate native actions')
need('function Visual:SetQuestSelectable(available, active)' in v and
     'function Visual:SetLiveSelectable(enabled)' in v,
     'visual must preserve old gossip and new quest gating')
need('a.questID ~= b.questID' in c and 'a.questKind ~= b.questKind' in c,
     'gossip option revalidation must cover appended quests')
need('questActions = quest.attempts' in live and
     'nativeActions = actions.attempts' in live,
     'gossip live status must report both controllers')
need('questActions=%s' in commands, 'H status lacks quest-action audit')
need('Quest\\NPCGossipPresentation.lua\nQuest\\NPCGossipChoice.lua\nQuest\\NPCGossipQuestChoice.lua\n' in toc,
     'TOC source/selector load order missing')
import re
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)), 'runtime version parity')
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'authority pointer missing')
need('P0320' in current and 'P0319' in current,
     'current checkpoint absent')
for term in ('P0320','P0319','quest-only','guard','trainer','no native acceptance',
             'Blizzard','UNVERIFIED','FAIL','fail-open'):
    need(term.lower() in evidence.lower(),'evidence missing '+term)
print('P0320 native quest links from C_GossipInfo through shared NPC choices')
for x in errors: print('ERROR:', x)
if errors: raise SystemExit(1)
print('PASS: source quest rows, stage revalidation, guarded open, stock retained')
