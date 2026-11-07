#!/usr/bin/env python3
"""P0387: QUEST_ACCEPTED of first offer must not dismiss newer Logres quest."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
D=(R/'Logres/Quest/Dialogue.lua').read_text()
S=(R/'Logres/Quest/OfferStockSuppression.lua').read_text()
G=(R/'Logres/Quest/NPCGossipQuestChoice.lua').read_text()
for token in ('function Dialogue:ShouldPreserveNewOfferOnAccepted(...)',
    'ordinaryAcceptedEventQuestID(...)', 'pcall(issecretvalue, candidate)',
    'accepted ~= nil and accepted == pending',
    'detail.questID == pending', 'self.pendingAcceptedOfferQuestID =',
    'kind == "accept" and detail.questID or nil',
    'if self:ShouldPreserveNewOfferOnAccepted(...) then',
    'late-accepted-preserved', 'activeQuestID = self.activeDetail.questID'):
    assert token in D, token
assert D.index('self.pendingAcceptedOfferQuestID =\n        kind == "accept"') < D.index('actionRuntime:TriggerProductionAction(')
accepted=D.split('if event == "QUEST_ACCEPTED" then',1)[1].split('if event == "QUEST_TURNED_IN" then',1)[0]
assert accepted.index('if self:ShouldPreserveNewOfferOnAccepted(...) then') < accepted.index('self:ClearActiveDetail(')
assert 'self.pendingAcceptedOfferQuestID = nil' in accepted
assert 'self.pendingAcceptedOfferQuestID = nil' in D.split('if event ==\n                "PLAYER_ENTERING_WORLD"',1)[1]
for token in ('if RESTORE_EVENTS[event]', 'event == "QUEST_ACCEPTED" and self.appliedEnabled',
    'self.requestedEnabled', 'dialogue.ShouldPreserveNewOfferOnAccepted,',
    'late-accepted-stock-preserved', 'self:Restore("event:" .. event)'):
    assert token in S,token
scope=S.split('if RESTORE_EVENTS[event]',1)[1].split('end)\n    self.eventFrame',1)[0]
assert scope.index('if ok and preserve == true then') < scope.index('self:Restore("event:" .. event)')
assert 'QUEST_ACCEPTED = true' in S and 'QUEST_FINISHED = true' in S
assert 'Greeting.Restore("native-quest-selected")' in G
assert 'pcall(selectFn, chosen.questIndex)' in G
assert 'self:Restore("claim-invoked")' in (R/'Logres/Quest/CompletionControl.lua').read_text()
assert 'P0386' in (R/'docs/memory/CURRENT.md').read_text()
assert 'P0386' in (R/'docs/memory/handoffs/CURRENT_HANDOFF.md').read_text()
print('P0387 late QUEST_ACCEPTED identity and stock ownership: PASS (STATIC; WoW UNVERIFIED)')
