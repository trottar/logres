#!/usr/bin/env python3
"""P0386: complete native QuestFrame greeting replacement and fail-open handoff."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding="utf8")
G=read("Logres/Quest/NPCGossipQuestChoice.lua")
D=read("Logres/Quest/Dialogue.lua")
S=read("Logres/Quest/OptionSession.lua")
T=read("Logres/Logres.toc")
B=read("Logres/Core/Bootstrap.lua")
for token in ('function Greeting.ReadModel()', 'GetNumAvailableQuests', 'GetNumActiveQuests',
  'GetAvailableTitle', 'GetActiveTitle', 'GetGreetingText', 'function Greeting.CanSelect(kind)',
  'SelectAvailableQuest', 'SelectActiveQuest', 'function Greeting.TryShow(dialogue)',
  'function Greeting.Restore(reason)', 'function Greeting.Activate(model, index)',
  'function Greeting.Goodbye()', 'function Greeting.IsParked()',
  'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
  'local points = anchors(root)', 'saved.set(saved.root, p[1], p[2], p[3], p[4], p[5])',
  'set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)',
  'dialogue:HidePresentation("greeting-native-stock-owned")',
  'sameList(model, fresh)', 'Greeting.Restore("native-quest-selected")',
  'pcall(selectFn, chosen.questIndex)', 'not unlocked()', 'PLAYER_REGEN_ENABLED'):
    assert token in G, token
assert G.index('dialogue:ShowReadOnlyQuestGreeting(model)') < G.index('local parkedOK, parkedReason = tryPark()')
assert G.index('Greeting.Restore("native-quest-selected")') < G.index('pcall(selectFn, chosen.questIndex)')
for forbidden in ('SetScript("OnUpdate"', 'GetMouseFocus(', 'GetMouseFoci(', 'AcceptQuest(', 'CompleteQuest(', 'GetQuestReward('):
    assert forbidden not in G,forbidden
for token in ('function Dialogue:ShowReadOnlyQuestGreeting(model)',
    'Logres.QuestGreetingControl.TryShow(self)', 'Logres.QuestGreetingControl.Restore(',
    '"npc-quest-greeting"', 'self.lastGreetingPresentationReason = why',
    'self.lastGreetingStatus = status'):
    assert token in D,token
for token in ('self.questGreeting = model.questGreeting == true',
    'Logres.QuestGreetingControl.CanSelect("available")',
    'Logres.QuestGreetingControl.Activate(self.model, index)',
    'Logres.QuestGreetingControl.Goodbye()'):
    assert token in S,token
assert "Quest\\NPCGossipQuestChoice.lua" in T
assert re.search(r'^## Version: (\S+)$',T,re.M).group(1) == re.search(r'^Logres.VERSION = "([^"]+)"$',B,re.M).group(1)
assert 'and d.optionSession.questGreeting ~= true then' in read('Logres/Quest/NPCGossipPresentation.lua')
assert 'Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE"' in G
assert '"lastGreetingPresentationReason", "greetingStockParked"' in read('Logres/Dev/Panel.lua')
assert 'dialogue:HidePresentation("greeting-native-frame-hidden")' in G
assert 'self:Restore("claim-invoked")' in read('Logres/Quest/CompletionControl.lua')
assert 'pcall(_G.QuestRewardCompleteButton_OnClick)' in read('Logres/Quest/CompletionControl.lua')
for p in ('docs/memory/CURRENT.md', 'docs/memory/handoffs/CURRENT_HANDOFF.md',
          'docs/memory/PRE_HANDOFF_AUDIT.md','docs/memory/investigations/ISSUE_LEDGER.md'):
    assert 'P0386' in read(p) and 'P0385' in read(p),p
print('P0386 QuestFrame greeting single-window native handoff: PASS (STATIC; runtime UNVERIFIED)')
