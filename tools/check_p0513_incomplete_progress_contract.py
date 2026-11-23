#!/usr/bin/env python3
"""P0513: incomplete progress ownership, required source, fallback; actual-source fixture."""
from pathlib import Path
import re, shutil, subprocess
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text()
ready=d[d.index('function Dialogue:ProgressGate()'):d.index('function Dialogue:IncompleteProgressGate()')]
read_only=d[d.index('function Dialogue:IncompleteProgressGate()'):d.index('function Dialogue:RestoreProgressStock(reason)')]
source=d[d.index('function Dialogue:ReadIncompleteProgress(progress)'):d.index('function Dialogue:HandleQuestProgress()')]
handler=d[d.index('function Dialogue:HandleProgressContinue()'):d.index('function Dialogue:HandleCompletionAction()')]
bye=d[d.index('function Dialogue:Goodbye()'):d.index('function Dialogue:ClearFailure(')]
assert 'or ready ~= true' in ready and 'or ready ~= false' in read_only
assert '"IsEnabled") ~= false' in read_only and 'combat ~= false' in read_only
assert 'id ~= self.lastQuestID' in read_only
for token in ('incompleteNumber(GetNumQuestItems, 24)', 'incompleteNumber(GetQuestMoneyToGet', 'pcall(GetQuestItemInfo, "required", index)', 'ordinaryProgress(name)', 'ordinaryProgress(quantity)', 'ordinaryProgress(itemID)', 'incompleteNumber(GetItemCount, 10000000, itemID, false, false)', '"incomplete-item-row-unavailable"', 'Quest in progress. Not ready to turn in.', 'self:HidePresentation("incomplete-progress-changed")'):
    assert token in source, token
assert 'self:CaptureProgressStock()' in d[d.index('function Dialogue:ActivateIncompleteProgress('):d.index('function Dialogue:HandleProgressContinue()')]
# P0514 supersedes the manual stock-view action; the read-only gate must
# still precede every native Continue dispatch.
assert 'return false, "incomplete-progress-read-only"' in handler
assert handler.index('if self.progressReadOnly then') < handler.index('return false, "incomplete-progress-read-only"') < handler.index('local called = pcall(_G.QuestProgressCompleteButton_OnClick)')
assert handler.count('pcall(_G.QuestProgressCompleteButton_OnClick)')==1
assert bye.index('self:HidePresentation("incomplete-progress-goodbye")') < bye.index('pcall(CloseQuest)')
page=d[d.index('function Dialogue:UpdateProgressPagePresentation()'):d.index('function Dialogue:CaptureProgressStock()')]
read_only_page=page[page.index('if self.progressReadOnly then'):page.index('self.acceptButton.label:SetText("Continue")')]
for token in ('self.acceptButton:Hide()', 'self.offerActionRoot:Hide()', 'self.offerActionRoot:EnableMouse(false)', 'return'):
    assert token in read_only_page, token
assert 'View in Blizzard' not in page
assert 'self.progressReadOnly = false' in d and 'self:CheckIncompleteProgressChanged(event)' in d
assert 'SetScript("OnUpdate"' not in d
assert 'GetQuestReward(' not in source and 'pcall(CompleteQuest)' not in d
assert 'progressReadOnly = self.progressReadOnly == true' in d
for name in ('CURRENT.md','PRE_HANDOFF_AUDIT.md','patches/PATCH_INDEX.md','evidence/P0513_INCOMPLETE_QUEST_PROGRESS.md','investigations/ISSUE_LEDGER.md'):
    assert 'P0513' in (r/'docs/memory'/name).read_text(), name
assert '| L-061 |' in (r/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
b=(r/'Logres/Core/Bootstrap.lua').read_text();t=(r/'Logres/Logres.toc').read_text()
assert re.search(r'^Logres.VERSION = "([^"]+)"$',b,re.M)[1]==re.search(r'^## Version: (\S+)$',t,re.M)[1]
engine=shutil.which('lua5.4') or shutil.which('texlua') or shutil.which('lua')
assert engine, 'actual-source Lua interpreter required'
subprocess.run([engine,str(r/'tools/test_p0513_incomplete_progress.lua')],cwd=r,check=True)
print('PASS: P0513 incomplete progress STATIC; client UNVERIFIED')
