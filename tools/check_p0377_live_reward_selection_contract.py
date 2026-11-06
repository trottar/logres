#!/usr/bin/env python3
"""P0377: modular live choice selection, guarded native completion, fail-open fallback."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
read=lambda p:(ROOT/p).read_text(encoding='utf-8')
D=read('Logres/Quest/Dialogue.lua')
V=read('Logres/Quest/RewardVisual.lua')
C=read('Logres/Quest/CompletionControl.lua')
M=read('Logres/Quest/RewardModel.lua')
I=read('docs/memory/investigations/ISSUE_LEDGER.md')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')

def need(ok, message):
    if not ok:raise AssertionError('P0377: '+message)

for key in (
    'function Control:ReadChoiceCount()',
    'local ok, count = pcall(GetNumQuestChoices)',
    'not ordinary(count)',
    'count > 6',
    'if not numeric(GetNumQuestChoices, 0) then',
    'if dialogue.completionRewardOverflow == true',
    'local index = card.nativeChoiceIndex',
    'if not seen[index] then',
    'function Control:SelectChoice(index)',
    'self.selectedChoiceIndex = index',
    'self:Restore("claim-invoked")',
    'pcall(function()',
    '_G.QuestInfoFrame.itemChoice = selectedChoiceIndex',
    'pcall(_G.QuestRewardCompleteButton_OnClick)',
    'if choiceCount > 0 and (type(selectedChoiceIndex) ~= "number"',
    'Logres:TraceEvent("quest", "completion-choice-selected"',
    'Logres:TraceEvent("quest", "completion-choice-required"',
):need(key in C, 'controller choice/native safety missing: '+key)
need(C.index('self:Restore("claim-invoked")') < C.index('_G.QuestInfoFrame.itemChoice = selectedChoiceIndex')
     < C.index('pcall(_G.QuestRewardCompleteButton_OnClick)'),
     'native state must be restored before setting selection and calling handler')
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'QuestFrame:Hide',
                  'C_Timer.', 'SetScript("OnUpdate"'):
    need(forbidden not in C,'unsafe controller mutation/polling: '+forbidden)

for key in (
    'function Visual:SetLiveChoiceHandler(handler, selectedIndex)',
    'function Visual:ClearLiveChoiceHandler()',
    'elseif self.liveChoiceHandler and button.nativeChoiceIndex then',
    'self.liveChoiceHandler(button.nativeChoiceIndex)',
    'slot.nativeChoiceIndex = card.nativeChoiceIndex',
    'local liveInteractive = self.liveChoiceHandler ~= nil',
    'slot:EnableMouse(interactive)',
    'if self.previewChoiceHandler and button.choiceIndex then',
    'slot.itemLink = card.itemLink',
    'function Visual:Reset()',
    'self.liveChoiceHandler = nil',
):need(key in V,'visual choice/view contract missing: '+key)
for forbidden in ('GetQuestReward(', 'CompleteQuest(',
                  'QuestRewardCompleteButton_OnClick(', 'QuestInfoFrame.itemChoice',
                  'GetNumQuestChoices(', 'SetScript("OnUpdate"', 'HideUIPanel('):
    need(forbidden not in V,'reward view must never perform native gameplay actions '+forbidden)
need(V.count('slot:SetScript("OnClick", function(button)')==1,
     'one existing reusable choice callback required')

for key in (
    'if kind == "choice" then card.nativeChoiceIndex = index end',
    'self.completionFallbackActive = not applied',
    'function Dialogue:HandleLiveRewardChoice(index)',
    'self.completionControl:SelectChoice(index)',
    'function Dialogue:ShowCompletionStockFallback(reason)',
    'function Dialogue:HandleCompletionFallback()',
    'self.acceptButton.label:SetText("Finish in Blizzard")',
    'self.acceptButton.label:SetText("Complete Quest")',
    'self:ShowCompletionStockFallback(controlReason)',
    'self:ShowCompletionStockFallback(reason)',
    'self.rewardVisual:SetLiveChoiceHandler(function(index)',
    'self.rewardVisual:Present(self.completionRewardCards, ownedFooter)',
    'self.completionControl:Activate()',
    'self.completionControl:Restore(reason or "hide-presentation")',
):need(key in D,'dialogue coordinator or fallback missing '+key)
need(D.count('function Dialogue:PositionCompletionActionVisual()')==1,
     'single shared original action geometry must remain')
need(D.count('createOfferButton(')==3,
     'must preserve original Accept/Decline factory; no third action frame')
# Native reward transactions are delegated exclusively to CompletionControl.
# An existing, conditional preview presentation auto-hide uses C_Timer.After
# elsewhere in Dialogue.lua. It is not reward polling or a claim transaction.
for forbidden in ('GetQuestReward(', 'QuestInfoFrame.itemChoice ='):
    need(forbidden not in D,'dialogue must not perform native reward transaction: '+forbidden)
action_start = D.find('function Dialogue:HandleCompletionAction()')
action_end = D.find('function Dialogue:HidePresentation(reason)',action_start)
need(action_start >= 0 and action_end > action_start,
     'cannot isolate guarded reward-selection coordinator methods')
action_methods = D[action_start:action_end]
for forbidden in ('C_Timer.After(', 'C_Timer.NewTicker(',
                  'SetScript("OnUpdate"'):
    need(forbidden not in action_methods,
         'no timer or polling in reward-selection coordinator methods: '+forbidden)
need('selectablePreviewChoices = false' in M and
     'function Model.FromLive(cards, footer)' in M and 'previewOnly = false' in M,
     'plain reward model should remain passive and preview/live distinct')
for ident,status in [('L-002','OPEN'),('L-005','PARTIAL'),('L-033','OPEN'),('L-034','OPEN')]:
    rows=[x for x in I.splitlines() if x.startswith('| '+ident+' |')]
    need(len(rows)==1 and ('| '+status+' |') in rows[0],
         ident+' incorrectly closed or removed')
need('P0377' in I and 'first reference for every Logres bug' in I,
     'ledger-first runtime failure evidence absent')
need('ISSUE_LEDGER.md' in CUR and 'ISSUE_LEDGER.md' in HAND,
     'ledger-first references missing')
need(len(CUR.encode('utf-8'))<9800 and len(HAND.encode('utf-8'))<8000,
     'canonical memory limit exceeded')
for path in ('docs/memory/evidence/P0377_LIVE_REWARD_SELECTION.md',
             'docs/memory/patches/P0377_LIVE_REWARD_SELECTION.md'):
    t=read(path)
    need('P0377' in t and 'UNVERIFIED' in t and 'L-005' in t,
         'missing durable fail/unverified checkpoint '+path)
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
v1=re.search(r'^## Version: (0\.0\.\d+-dev)$',toc,re.M)
v2=re.search(r'^Logres.VERSION = "(0\.0\.\d+-dev)"$',boot,re.M)
need(v1 and v2 and v1.group(1)==v2.group(1),
     'current version format/parity broken')

# Pure fixture of normal bounds and omitted-card exclusion (no protected API).
def supported(choices,indices,overflow,cost=0):
    if not isinstance(choices,int) or not 0<=choices<=6 or overflow or cost!=0:
        return False
    return choices==0 or sorted(indices)==list(range(1,choices+1))
assert supported(0,[],False)
assert supported(2,[1,2],False)
assert supported(3,[3,1,2],False)
assert not supported(2,[1],False)
assert not supported(2,[1,1],False)
assert not supported(2,[1,2],True)
assert not supported(7,list(range(1,8)),False)
assert not supported(2,[1,2],False,cost=100)
print('P0377 modular live choice/claim and stock fallback: 8/8 fixture PASS (STATIC ONLY; WoW UNVERIFIED)')
