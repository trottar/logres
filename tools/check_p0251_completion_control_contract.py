#!/usr/bin/env python3
"""P0251 controls only ordinary non-choice quest rewards, safely restores stock."""
from pathlib import Path
import re
r = Path(__file__).resolve().parents[1]
d = (r/'Logres/Quest/Dialogue.lua').read_text()
c = (r/'Logres/Quest/CompletionControl.lua').read_text()
s = (r/'Logres/Quest/OfferStockSuppression.lua').read_text()
t = (r/'Logres/Logres.toc').read_text()
b = (r/'Logres/Core/Bootstrap.lua').read_text()
cmd = (r/'Logres/Core/Commands.lua').read_text()
issues=[]
for name, text, parts in [
 ('CompletionControl', c, ['GetNumQuestChoices, 0','GetQuestMoneyToGet, 0',
 'QuestFrameRewardPanel','QuestFrameCompleteQuestButton','QuestRewardCompleteButton_OnClick',
 'InCombatLockdown','snapshot.mouseFrames','frame.IsProtected',
 'module.SuppressOfferPresentation','module.RestoreOfferPresentation',
 'self.actionRoot:Hide()','function Control:Click()','function Control:Restore(reason)',
 'self:Restore("claim-invoked")','pcall(_G.QuestRewardCompleteButton_OnClick)',
 'self.dialogue.lastQuestID','not dialogue.completionActive']),
 ('Dialogue', d, ['function Dialogue:HandleCompletionAction()',
 'self.completionControl:Restore(reason or "hide-presentation")',
 'self.completionControl:Restore("new-presentation")',
 'self.completionControl:Activate()','"complete", "Complete Quest"',
 'Logres.QuestCompletionControl.New(', 'completionControl:GetDebugStatus()',
 'owner:HandleCompletionAction()']),
 ('Commands',cmd,['Logres questdialogue completioncontrol: CANDIDATE']),
 ('TOC',t,['Quest\\CompletionControl.lua']),
 ('Bootstrap',b,['Logres.VERSION = ']),
 ('Existing stock restorative methods',s,['function Suppression:CaptureOfferPresentation()',
 'function Suppression:SuppressOfferPresentation(snapshot)',
 'function Suppression:RestoreOfferPresentation(snapshot)',
 'function Suppression:EmergencyRestoreOfferPresentation(snapshot)'])
]:
 for part in parts:
  if part not in text: issues.append(name+' missing '+part)
if t.index('Quest\\CompletionControl.lua') > t.index('Quest\\Dialogue.lua'):
 issues.append('completion controller must load before Dialogue')
if 'Quest\\RewardVisual.lua\nQuest\\Dialogue.lua' not in t:
 issues.append('P0248 contract: reward visual must remain immediately before Dialogue')
if t.index('Quest\\CompletionControl.lua') > t.index('Quest\\RewardVisual.lua'):
 issues.append('completion control must load before reward visual')
# Version parity is a current-source invariant, not a historical version pin.
toc_version = re.search(r'^## Version: ([^\r\n]+)$', t, flags=re.MULTILINE)
bootstrap_version = re.search(r'^Logres\.VERSION\s*=\s*"([^"]+)"', b, flags=re.MULTILINE)
if not toc_version or not bootstrap_version:
 issues.append('runtime version declaration missing')
elif toc_version.group(1) != bootstrap_version.group(1):
 issues.append('TOC and Bootstrap runtime versions disagree')
elif not re.fullmatch(r'[0-9]+\.[0-9]+\.[0-9]+-dev', toc_version.group(1)):
 issues.append('unexpected runtime version format')
if 'GetQuestReward(' in c or 'CompleteQuest(' in c:
 issues.append('completion control must use native handler, not bypass choice/confirmation')
if 'SetScript("OnUpdate"' in c or 'C_Timer.After' in c:
 issues.append('forbidden polling')
if 'QuestFrame:Hide' in c or 'QuestFrame:EnableMouse' in c:
 issues.append('quest frame not directly hidden')
if 'self:Restore("claim-invoked")' not in c.split('function Control:Click()',1)[1].split('pcall(_G.QuestRewardCompleteButton_OnClick)',1)[0]:
 issues.append('must restore stock before native claim handler')
# R3: re-presentation must be lifecycle-gated; no synthetic completion event.
for token in (
    'function Dialogue:RestoreCompletionAfterImmersion()',
    'elseif self.activeCompletion ~= nil then',
    'self:RestoreCompletionAfterImmersion()',
    'self.restoringCompletion = true',
    'self.restoringCompletion = false',
    'if not self.restoringCompletion then',
    'if reason ~= "QUEST_COMPLETE" then',
    'self.activeCompletion = nil',
    'current.questID ~= active.questID',
    'current.title ~= active.title',
    'isSecret(isShown)',
    'self.completionActionRoot:SetFrameLevel(root:GetFrameLevel() + 5)',
):
    if token not in d: issues.append('R3 restoration/visual invariant missing: ' + token)
print('Logres P0251 quest completion/stock fallback contract')
print('=====================================================')
for issue in issues:print('ERROR:',issue)
if issues:raise SystemExit(1)
print('PASS: 0 errors')
