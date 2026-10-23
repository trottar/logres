#!/usr/bin/env python3
"""P0318: owned option clicks reach only a narrowly validated native gossip API."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
r=lambda p:(R/p).read_text(encoding='utf8')
choice=r('Logres/Quest/NPCGossipChoice.lua')
source=r('Logres/Quest/NPCGossipSource.lua')
session=r('Logres/Quest/OptionSession.lua')
visual=r('Logres/UI/OptionList.lua')
live=r('Logres/Quest/NPCGossipPresentation.lua')
legacy=r('tools/check_p0317_live_gossip_presentation_contract.py')
toc=r('Logres/Logres.toc')
boot=r('Logres/Core/Bootstrap.lua')
current=r('docs/memory/CURRENT.md')
evidence=r('docs/memory/evidence/P0318_GOSSIP_NATIVE_CHOICES.md')
errors=[]
def need(test,msg):
 if not test:errors.append(msg)
for token in ('Logres.NPCGossipChoice = Choice','function Choice.CanSelect()',
              'function Choice.Activate(model, index)','function Choice.GetAudit()',
              'C_GossipInfo.SelectOption','pcall(fn, chosen.gossipOptionID)',
              'chosen.gossipStatus ~= 0','Logres.NPCGossipSource.Sample()',
              'fresh.title ~= model.title','fresh.gossipKind ~= model.gossipKind',
              'fresh.questSummary.available ~= model.questSummary.available',
              'a.gossipOptionID ~= b.gossipOptionID','a.label ~= b.label',
              'InCombatLockdown','issecretvalue','native-select-unavailable',
              'attempts = attempts + 1'):
 need(token in choice,'missing guarded native select contract: '+token)
for forbidden in ('C_GossipInfo.SelectAvailableQuest', 'C_GossipInfo.SelectActiveQuest',
                  'AcceptQuest(', 'GetQuestReward(', 'BuyTrainerService(',
                  'C_Timer.', 'SetScript("OnUpdate"', 'SetAlpha(',
                  'HideUIPanel(', 'GossipFrame:Hide', 'DynamicCam'):
 need(forbidden not in choice,'choice controller must not act on unrelated surfaces: '+forbidden)
need('gossipStatus = status' in source and 'enabled = false' in source,
     'must retain inert source model with ordinary status metadata')
need('function Visual:SetLiveSelectable(enabled)' in visual and
     'slot.optionEnabled = self.liveSelectable and slot.optionVisible == true' in visual,
     'shared visual must gate live click availability independently from preview')
need('Logres.NPCGossipChoice.Activate(self.model, index)' in session and
     'Logres.NPCGossipChoice.CanSelect()' in session,
     'separate gameplay controller not wired from option view')
need('nativeActions = actions.attempts' in live and
     'function Live.OnNativeChoice()' in live,
     'live audit and exit must show native actions accurately')
need('nativeActions = actions.attempts' in legacy,
     'P0317 historical contract must migrate to actual native action audit')
need('Quest\\NPCGossipPresentation.lua\nQuest\\NPCGossipChoice.lua\n' in toc,
     'choice module must load after existing gossip modules')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)), 'runtime version parity')
need('CURRENT.md' in r('docs/memory/handoffs/CURRENT_HANDOFF.md'), 'handoff missing source of truth')
need('P0318' in current and 'P0317' in current, 'current progress not updated')
for term in ('UNVERIFIED','P0317','P0318','Quest 237','Blizzard','fail-open','native'):
 need(term.lower() in evidence.lower(),'evidence missing '+term)
print('P0318 guarded click -> current C_GossipInfo.SelectOption contract')
for e in errors:print('ERROR:',e)
if errors:raise SystemExit(1)
print('PASS: source revalidation, ordinary status, direct user click, retained stock and separate audit')
