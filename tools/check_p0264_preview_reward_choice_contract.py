#!/usr/bin/env python3
"""P0264 N4: visible synthetic reward choices without native action ownership."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
V=(R/'Logres/Quest/RewardVisual.lua').read_text(encoding='utf-8')
D=(R/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
M=(R/'Logres/Quest/RewardModel.lua').read_text(encoding='utf-8')
C=(R/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
N=(R/'Logres/Quest/CompletionControl.lua').read_text(encoding='utf-8')
B=(R/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
T=(R/'Logres/Logres.toc').read_text(encoding='utf-8')
E=[]
def has(where,*tokens):
 for t in tokens:
  if t not in where:E.append('missing: '+t)
has(V,
 'local slot = CreateFrame("Button", nil, root)',
 'slot:RegisterForClicks("LeftButtonUp")',
 'slot:SetScript("OnClick", function(button)',
 'if self.previewChoiceHandler and button.choiceIndex then',
 'self.previewChoiceHandler(button.choiceIndex)',
 'slot:EnableMouse(interactive)',
 'function Visual:SetPreviewChoiceHandler(handler)',
 'function Visual:SelectPreviewChoice(index)',
 'function Visual:PaintPreviewChoices()',
 'self.previewChoiceHandler = nil',
 'self.previewSelectedChoice = nil',
 'slot.choiceIndex = choiceIndex',
 'slot.label:SetText("SELECTED  " .. slot.choiceName)',
 'slot.rule:SetVertexColor(1.00, 0.83, 0.42, 1.00)',
 'function Visual:Present(cards, footer)',
 'slot.label:SetText((card.kind == "choice" and "CHOICE  " or "") .. card.name)',
 'slot:EnableMouse(false)')
if V.count('slot:SetScript("OnClick", function(button)')!=1:
 E.append('exactly one preview-only row click dispatcher required')
if V.count('CreateFrame("Button", nil, root)')!=1:
 E.append('exactly one reusable row factory required')
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'AcceptQuest(',
                  'DeclineQuest(', 'HideUIPanel(', 'GetQuestItemInfo(',
                  'QuestRewardCompleteButton_OnClick', 'C_GossipInfo.Select',
                  'SetScript("OnUpdate"', 'C_Timer.', 'DynamicCam', 'issecretvalue'):
 if forbidden in V:E.append('view cannot call game APIs or poll '+forbidden)
has(M,'selectablePreviewChoices = false,',
 'selectablePreviewChoices = mode == "multi",',
 'previewOnly = false,','previewOnly = true,')
has(D,
 'function Dialogue:ChooseRewardPreview(index)',
 'self.lastPresentationReason ~= "reward-preview"',
 'or self.completionActive or not self.rewardVisual',
 'self.rewardVisual:SelectPreviewChoice(index)',
 'self.rewardPreviewChoiceClicks = self.rewardPreviewChoiceClicks + 1',
 'self.rewardVisual:SetPreviewChoiceHandler(function(index)',
 'self:ChooseRewardPreview(index)',
 'if model.selectablePreviewChoices then',
 'self.rewardVisual:Present(model.cards, model.footer)',
 'message = "Select a reward first (preview only)"',
 'rewardPreviewSelected = self.rewardPreviewSelected,',
 'rewardPreviewChoiceCount = self.rewardPreviewChoiceCount,',
 'rewardPreviewChoiceState = self.rewardPreviewChoiceState,')
# Runtime live pipeline must never install the synthetic handler.
start=D.index('function Dialogue:ShowRewardPreview(mode)')
end=D.index('function Dialogue:GetDebugStatus()',start)
preview=D[start:end]
if preview.count('self.rewardVisual:SetPreviewChoiceHandler(function(index)')!=1:
 E.append('preview handler must be one, explicitly scoped activation')
if D[:start].count('self.rewardVisual:SetPreviewChoiceHandler(')!=0:
 E.append('live controller must not enable preview selection')
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'QuestRewardCompleteButton_OnClick(',
                  'AcceptQuest(', 'DeclineQuest(', 'C_GossipInfo.Select'):
 if forbidden in preview:E.append('preview may not mutate gameplay: '+forbidden)
has(C,'Logres questdialogue previewchoices: %s (choices=%s clicks=%s selected=%s state=%s nativeActions=none)',
 'tostring(debugStatus.rewardPreviewSelected)')
has(N,'GetNumQuestChoices, 0','self:Restore("claim-invoked")',
 'pcall(_G.QuestRewardCompleteButton_OnClick)')
# Runtime-version check below validates format and parity without a fixed version.
# Do not pin a historical build in durable contracts; assert valid, equal versions.
match = re.search(r'^## Version: (0\.0\.\d+-dev)$', T, re.M)
bmatch = re.search(r'^Logres\.VERSION = "(0\.0\.\d+-dev)"$', B, re.M)
if not match or not bmatch or match.group(1) != bmatch.group(1):
 E.append('invalid development-version format or mismatch')
print('Logres P0264 N4 synthetic reward selection safety and preview contract')
print('===================================================================')
for e in E:print('ERROR:',e)
if E:raise SystemExit(1)
print('PASS: preview-selectable choices, exclusive highlight, owner gating and unchanged native control')
