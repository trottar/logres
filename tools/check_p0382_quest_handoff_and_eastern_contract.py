#!/usr/bin/env python3
"""P0382: event-held progress, clickable completion ownership and Eastern reporting.
Source-only. User runtime acceptance is a distinct gate.
"""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
D=read('Logres/Quest/Dialogue.lua')
C=read('Logres/Quest/CompletionControl.lua')
E=read('tools/export_panel_diagnostics.py')
Q=read('tools/check_p0381_integrated_gameplay_contract.py')
B=read('Logres/Core/Bootstrap.lua');T=read('Logres/Logres.toc')
L=read('docs/memory/investigations/ISSUE_LEDGER.md')
progress=D[D.index('function Dialogue:HandleProgressContinue()'):D.index('function Dialogue:HandleCompletionAction()')]
assert progress.count('local called = pcall(_G.QuestProgressCompleteButton_OnClick)')==1
assert progress.index('self.progressContinuePending = true')<progress.index('local called = pcall(_G.QuestProgressCompleteButton_OnClick)')
assert progress.count('pcall(C_Timer.After, 1.5, function()')==1
assert 'self.progressContinueSerial == serial' in progress
assert 'self.progressOwned then' in progress
assert 'self:RestoreProgressStock("progress-transition-timeout")' in progress
assert 'self:RestoreProgressStock("progress-native-call-failed")' in progress
assert 'self:RestoreProgressStock("progress-timer-unavailable")' in progress
assert 'self.progressContinuePending = false' in D
assert 'type(C_Timer.After) ~= "function"' in D
assert 'GetQuestReward(' not in progress and 'pcall(CompleteQuest)' not in D
assert 'SetScript("OnUpdate"' not in progress
# No additional interactive quest action or duplicate native call.
assert D.count('createOfferButton(')==3
assert 'self.offerActionRoot:SetFrameLevel(actionLevel + 8)' in D
assert 'self.acceptButton:SetFrameLevel(actionLevel + 9)' in D
# R1 regression: P0382 R0 disabled the shared action root in Restore()
# without re-enabling it for a subsequent ordinary quest offer or Continue.
offer=D[D.index('function Dialogue:UpdateOfferControls()'):D.index('function Dialogue:HandleOfferAction(kind)')]
page=D[D.index('function Dialogue:UpdateProgressPagePresentation()'):D.index('function Dialogue:ActivateProgressContinue()')]
hide=D[D.index('function Dialogue:HidePresentation(reason)'):D.index('function Dialogue:Goodbye()')]
assert 'self.offerActionRoot:EnableMouse(true)' in offer and 'self.offerActionRoot:EnableMouse(false)' in offer, 'offer action root must be enabled only when shown'
assert offer.index('self.offerActionRoot:EnableMouse(true)') < offer.index('self.offerActionRoot:Show()'), 'offer hit capture must precede show'
assert 'self.offerActionRoot:EnableMouse(true)' in page and 'self.offerActionRoot:EnableMouse(false)' in page, 'Continue page must regain input after completion restore'
assert page.index('self.acceptButton.label:SetText("Continue")') < page.index('self.offerActionRoot:EnableMouse(true)') < page.index('self.offerActionRoot:Show()'), 'Continue enabled only on final page'
assert 'self.offerActionRoot:EnableMouse(false)' in hide and 'self.offerActionRoot:Hide()' in hide, 'dismissal must release Logres input'
assert 'self.offerActionRoot:EnableMouse(true)' in D[D.index('function Dialogue:ShowCompletionStockFallback(reason)'):D.index('function Dialogue:HandleLiveRewardChoice(index)')], 'stock fallback must allow user dismissal'
assert 'self.actionRoot:EnableMouse(true)' in C[C.index('function Control:Activate()'):C.index('function Control:SelectChoice(index)')]
assert 'self.actionRoot:EnableMouse(false)' in C[C.index('function Control:Restore(reason)'):C.index('function Control:Activate()')]
assert 'self:Restore("claim-invoked")' in C and 'pcall(_G.QuestRewardCompleteButton_OnClick)' in C
assert 'ok = emergencyOK and restored == true' in C
# Historical protection remains; only the native progress bridge gained a bounded timer.
assert 'pcall(CompleteQuest)' in read('tools/check_p0379_completion_input_provenance_contract.py')
assert 'native progress bridge must defer restoration' in Q
assert 'local enabled, pending, active' not in progress
for token in ("from zoneinfo import ZoneInfo", "EASTERN = ZoneInfo('America/New_York')", "'generated_eastern'", "'source_modified_eastern'", "'display_timezone'", "time_eastern=", "'generated_utc'", "'source_modified_utc'"):
    assert token in E, 'missing timezone field: '+token
assert 'SCREENSHOT_WINDOW_SECONDS = 90' in E and 'SCALAR = re.compile(' in E
rows=[x for x in L.splitlines() if re.match(r'^\| L-\d{3} \|',x)]
assert len(rows)==40
assert [int(x.split(' | ')[0][4:]) for x in rows]==list(range(1,41))
for lid,status in [('L-002','OPEN'),('L-005','PARTIAL'),('L-040','OPEN')]:
    assert any(x.startswith('| '+lid+' |') and '| '+status+' |' in x for x in rows)
assert 'P0382 R1 exact-candidate pre-handoff audit' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
assert 'P0382' in read('docs/memory/CURRENT.md')
assert 'P0382' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert len(read('docs/memory/CURRENT.md').encode())<9800
assert len(read('docs/memory/handoffs/CURRENT_HANDOFF.md').encode())<8000
assert re.search(r'^## Version: (\S+)$',T,re.M).group(1)==re.search(r'^Logres.VERSION = "([^"]+)"$',B,re.M).group(1)
for path in ('docs/memory/evidence/P0382_QUEST_HANDOFF_AND_EASTERN.md','docs/memory/patches/P0382_QUEST_HANDOFF_AND_EASTERN.md'):
    s=read(path)
    for token in ('P0382','L-002','L-005','L-040','UNVERIFIED','2625','America/New_York'):
        assert token in s,path+' missing '+token
print('P0382 quest input / event bridge / Eastern report: PASS (STATIC ONLY, WoW UNVERIFIED)')
