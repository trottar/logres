#!/usr/bin/env python3
"""P0385: bounded read-only QUEST_GREETING and claim stock handoff provenance."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
D=(R/'Logres/Quest/Dialogue.lua').read_text()
C=(R/'Logres/Quest/CompletionControl.lua').read_text()
P=(R/'Logres/Dev/Panel.lua').read_text()
S=D[D.index('-- P0385: QUEST_GREETING'):D.index('function Dialogue:HandleQuestComplete()')]
for token in ('function Dialogue:ObserveQuestGreeting()', 'greetingCount(GetNumAvailableQuests)',
              'greetingCount(GetNumActiveQuests)', 'greetingTitlesReady(available, GetAvailableTitle)',
              'greetingTitlesReady(active, GetActiveTitle)', 'pcall(GetGreetingText)',
              'greetingOrdinary(value)', 'greetingOrdinary(title)', 'greetingOrdinary(greeting)',
              'value > 24', '"greeting-observed"'):
    assert token in S,token
for forbidden in ('GetPoint(', 'SetAlpha(', 'SetParent(', 'HideUIPanel(',
                  'SetScript("OnUpdate"', 'C_Timer.', 'SelectAvailableQuest(', 'SelectActiveQuest('):
    assert forbidden not in S, forbidden
assert '_G.QuestFrame' not in S
assert '"QUEST_GREETING",' in D and 'self:ObserveQuestGreeting()' in D
assert 'self.eventRegistration.QUEST_GREETING == true' in D
assert 'self.greetingEventCount = 0' in D
assert '"claim-stock-restore-requested"' in C
click=C[C.index('function Control:Click()'):C.index('function Control:GetDebugStatus()')]
assert click.index('self:Restore("claim-invoked")') < click.index('"claim-stock-restore-requested"') < click.index('pcall(_G.QuestRewardCompleteButton_OnClick)')
assert 'incident.snapshot.questGreeting' in P and '"lastGreetingStatus"' in P
assert '"questGreetingRegistered"' in P and '"greetingEventCount"' in P
B=(R/'Logres/Core/Bootstrap.lua').read_text();T=(R/'Logres/Logres.toc').read_text()
assert re.search(r'^## Version: (\S+)$',T,re.M).group(1)==re.search(r'^Logres.VERSION = "([^"]+)"$',B,re.M).group(1)
L=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
for lid in ('L-001','L-002','L-005'):
    assert lid in L
assert 'P0385' in (R/'docs/memory/PRE_HANDOFF_AUDIT.md').read_text()
assert 'P0385' in (R/'docs/memory/CURRENT.md').read_text()
print('P0385 quest greeting / stock handoff provenance PASS (STATIC; WoW UNVERIFIED)')
