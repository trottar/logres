#!/usr/bin/env python3
"""P0381: guarded Forever quest progress ownership and native gossip fail-open.

Static/source contract only: actual gameplay success requires separate WoW evidence.
"""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
read = lambda name: (R / name).read_text(encoding="utf-8")
D = read("Logres/Quest/Dialogue.lua")
C = read("Logres/Quest/CompletionControl.lua")
G = read("Logres/Quest/NPCGossipPresentation.lua")
S = read("Logres/Quest/NPCGossipStockParking.lua")
V = read("Logres/UI/DecisionVisual.lua")
T = read("Logres/Logres.toc")
B = read("Logres/Core/Bootstrap.lua")
L = read("docs/memory/investigations/ISSUE_LEDGER.md")
CUR = read("docs/memory/CURRENT.md")
HAND = read("docs/memory/handoffs/CURRENT_HANDOFF.md")


def need(ok, reason):
    if not ok:
        raise AssertionError("P0381: " + reason)


for token in (
    "function Dialogue:ProgressGate()",
    "function Dialogue:RestoreProgressStock(reason)",
    "function Dialogue:ActivateProgressContinue()",
    "function Dialogue:HandleProgressContinue()",
    "function Dialogue:UpdateProgressPagePresentation()",
    'or type(IsQuestCompletable) ~= "function"',
    'or type(_G.QuestProgressCompleteButton_OnClick) ~= "function"',
    'nativeProgressFrame("QuestFrameProgressPanel")',
    'nativeProgressFrame("QuestFrameCompleteButton")',
    '"IsEnabled"',
    'ordinaryProgress(combat)',
    'ordinaryProgress(questID)',
    'ordinaryProgress(ready)',
    'ordinaryProgress(protected)',
    'emergencyOK and emergencyResult == true',
    'type(module.CaptureOfferPresentation) ~= "function"',
    'pcall(module.SuppressOfferPresentation, module, snapshot)',
    'module.RestoreOfferPresentation, module, snapshot',
    'module.EmergencyRestoreOfferPresentation, module, snapshot',
    'self:RestoreProgressStock("progress-transition-timeout")',
    'self.progressContinuePending = true',
    'local called = pcall(_G.QuestProgressCompleteButton_OnClick)',
    'self:RestoreProgressStock(reason or "progress-hidden")',
    'self:UpdateProgressPagePresentation()',
    'self.progressOwned = false',
    'self.progressStockSnapshot = nil',
    'Blizzard owns Continue',
):
    need(token in D, "progress native/restoration capability missing: " + token)

progress = D[D.index('-- P0381: the quest progress stage'):D.index('function Dialogue:HandleCompletionAction()')]
need(progress.index('self.progressContinuePending = true')
     < progress.index('local called = pcall(_G.QuestProgressCompleteButton_OnClick)')
     < progress.index('self:RestoreProgressStock("progress-transition-timeout")'),
     "native progress bridge must defer restoration until event or bounded timeout")
need('GetQuestReward(' not in progress and 'QuestRewardCompleteButton_OnClick' not in progress and 'pcall(CompleteQuest)' not in progress,
     "progress Continue must not claim a reward")
need(progress.count('pcall(C_Timer.After, 1.5, function()') == 1,
     'transition timeout must be a single fail-open callback, not polling')
for forbidden in ('SetScript("OnUpdate"', 'GetMouseFocus(', 'GetMouseFoci('):
    need(forbidden not in progress, 'progress may not poll or probe protected input: ' + forbidden)
need(D.index('owner:HandleProgressContinue()') < D.index('owner:HandleCompletionAction()'),
     'Continue action must be routed before reward claim')
need('if self.progressOwned then return end' in D,
     'progress action must survive ordinary pagination')
need('local owned, progressReason = self:ActivateProgressContinue()' in D and
     'self:HidePresentation("progress-stock-owned")' in D,
     'unsupported native Continue must remain accessible')
need('actionLevel + 8' in D and 'self.acceptButton:EnableMouse(true)' in D and
     'self.completionActionRoot = offerActionRoot' in D and
     'owner:RecordCompletionInput("dispatch")' in D,
     'existing reward button input geometry/telemetry missing')
need(D.count('createOfferButton(') == 3 and
     D.count('function Dialogue:PositionCompletionActionVisual()') == 1,
     'shared button must not be cloned')
H = read('tools/check_p0379_completion_input_provenance_contract.py')
need('progress handoff must be gated, native-owned and restorable' in H and
     'pcall(CompleteQuest)' in H,
     'superseded historical progress contract must continue to ban direct mutation')
need('button:RegisterForClicks("LeftButtonUp")' in V,
     'one release-click behavior, no duplicate claims')
need('self:Restore("claim-invoked")' in C and
     'pcall(_G.QuestRewardCompleteButton_OnClick)' in C,
     'existing guarded claim and restoration lost')

need('local parked, parkingReason = Logres.NPCGossipStockParking.TryPark(model)' in G,
     'original conditional gossip parking missing')
need('if not parked then' in G and 'd:HidePresentation("gossip-native-owner")' in G,
     'unsupported gossip may not show a competing Logres pane')
# Scope this to the exact presenter. The module's initial declaration
# `local enabled, pending, active = true, false, false` is NOT an ownership
# commit and must not be mistaken for the assignment after TryPark.
show_start = G.index('function Live.TryShow(reason)')
show_end = G.index('function Live.GetAudit()', show_start)
show_body = G[show_start:show_end]
parking = 'local parked, parkingReason = Logres.NPCGossipStockParking.TryPark(model)'
failed = '    if not parked then\n'
commit = '    active = true\n    opens = opens + 1\n'
need(show_body.count(parking) == 1 and show_body.count(failed) == 1
     and show_body.count(commit) == 1
     and show_body.index(parking) < show_body.index(failed)
     < show_body.index('d:HidePresentation("gossip-native-owner")')
     < show_body.index('return false, last', show_body.index(failed))
     < show_body.index(commit),
     'gossip ownership state must commit only after parking succeeds')
need('pending = false  -- next intentional GOSSIP_SHOW re-arms; never poll' in G,
     'one-shot native fallback must not spontaneously re-present')
for token in ('function Parking.Restore(reason)',
              'retry:RegisterEvent("PLAYER_REGEN_ENABLED")',
              'function Parking.RequestExit(reason)',
              'nativeAlphaWrites = 0', 'nativeMouseWrites = 0'):
    need(token in S, 'native gossip restoration contract lost: ' + token)

for token in ('0.0.', 'P0381'):
    need(token in CUR + HAND, 'active candidate memory missing marker: ' + token)
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) < 8000,
     'historical memory budgets exceeded')
rows = [line for line in L.splitlines() if re.match(r'^\| L-\d{3} \|', line)]
need(len(rows) >= 40, 'original issue ledger identities were lost')
for lid, status in [('L-001', 'OPEN'), ('L-002', 'OPEN'), ('L-005', 'PARTIAL'),
                    ('L-025', 'PARTIAL'), ('L-029', 'PARTIAL'), ('L-033', 'OPEN'),
                    ('L-034', 'OPEN'), ('L-038', 'OPEN'), ('L-039', 'OPEN')]:
    row = next((r for r in rows if r.startswith('| ' + lid + ' |')), None)
    need(row and '| ' + status + ' |' in row and 'P0381 code candidate' in row,
         'runtime issue must remain unresolved until tested: ' + lid)
for path in ('docs/memory/evidence/P0381_INTEGRATED_GAMEPLAY_IMPLEMENTATION.md',
             'docs/memory/patches/P0381_INTEGRATED_GAMEPLAY_IMPLEMENTATION.md'):
    record = read(path)
    need('P0381' in record and 'UNVERIFIED' in record and 'L-005' in record,
         'missing candidate negative evidence: ' + path)
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/patches/PATCH_INDEX.md', 'docs/ROADMAP.md'):
    need(read(path).startswith('## P0406 —') and '## P0405 —' in read(path) and '## P0404 —' in read(path) and '## P0403 —' in read(path) and '## P0402 —' in read(path) and '## P0401 —' in read(path) and '## P0400 —' in read(path) and '## P0399 —' in read(path) and '## P0398 —' in read(path) and '## P0397 —' in read(path) and '## P0396 —' in read(path) and '## P0395 —' in read(path) and '## P0394 —' in read(path) and '## P0393 —' in read(path) and '## P0392 —' in read(path) and '## P0391 —' in read(path) and '## P0390 —' in read(path) and '## P0389 —' in read(path) and '## P0388 —' in read(path) and '## P0387 —' in read(path) and '## P0386 —' in read(path) and '## P0385 —' in read(path) and '## P0384 —' in read(path) and '## P0383 —' in read(path) and '## P0382 —' in read(path) and '## P0381 —' in read(path), 'active roadmap not synchronized or P0381/P0382/P0383 history lost: '+path)
vt = re.search(r'^## Version: (\S+)$', T, re.M)
vb = re.search(r'^Logres\.VERSION = "([^"]+)"$', B, re.M)
need(vt and vb and vt.group(1) == vb.group(1), 'TOC/Bootstrap version parity')
need('Quest\\CompletionControl.lua' in T and 'Quest\\Dialogue.lua' in T,
     'existing quest load order not preserved')
print('P0381 integrated quest/gossip static contract PASS (WoW UNVERIFIED)')
