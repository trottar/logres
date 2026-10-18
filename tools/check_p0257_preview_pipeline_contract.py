#!/usr/bin/env python3
"""P0257: real quest reward visual is shared by deterministic fixture and live model."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
m=(r/'Logres/Quest/RewardModel.lua').read_text(encoding='utf-8')
v=(r/'Logres/Quest/RewardVisual.lua').read_text(encoding='utf-8')
t=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
b=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
errors=[]
for phrase in (
    'Logres.QuestRewardModel = Model',
    'function Model.FromLive(cards, footer)',
    'function Model.Preview(mode)',
    'previewOnly = false', 'previewOnly = true',
    'action = "preview-complete"', 'action = "stock-choice"',
    'return nil, "unknown-preview-mode"',
):
    if phrase not in m:errors.append('missing model contract '+phrase)
for phrase in (
    'local rewardModel = Logres.QuestRewardModel.FromLive(',
    'self.completionRewardCards, rewardFooter',
    'self.completionRewardFooter = rewardModel.footer',
    'local model, errorReason = Logres.QuestRewardModel.Preview(mode)',
    'if not model then return false, errorReason end',
    'completionRewardCard(',
    'self.rewardVisual:Present(model.cards, model.footer)',
    'if model.action == "preview-complete" then',
    'self.acceptButton.label:SetText("Complete Quest")',
    'offerStyleValue("y") + 64',
    'function Dialogue:PositionCompletionActionVisual()',
    'self:PositionCompletionActionVisual()',
    'self.offerActionRoot:Show()',
    'if owner.offerActionPreview then',
    'owner:HandleOfferAction(kind)',
):
    if phrase not in d:errors.append('missing shared view/preview routing '+phrase)
if d.count('function Dialogue:PositionCompletionActionVisual()')!=1 or d.count('self:PositionCompletionActionVisual()')!=2:
    errors.append('preview and live must share exactly one completion layout method')
if d.count('offerStyleValue("y") + 64')!=1:
    errors.append('completion geometry must not be duplicated in preview')
if d.count('createOfferButton(')!=3:
    errors.append('completion may not add a third visual button')
if d.count('function Dialogue:ShowRewardPreview(mode)')!=1:errors.append('expected one reward preview entrypoint')
click=d.split('button:SetScript("OnClick", function()',1)[1].split('end)',1)[0]
if click.index('if owner.offerActionPreview then') > click.index('if kind == "accept" and owner.completionActive'):
    errors.append('preview-only input gate must precede native completion routing')
preview=d.split('function Dialogue:ShowRewardPreview(mode)',1)[1].split('function Dialogue:GetDebugStatus()',1)[0]
for phrase in ('local model, errorReason = Logres.QuestRewardModel.Preview(mode)',
               'if not model then return false, errorReason end',
               'self.rewardVisual:Present(model.cards, model.footer)',
               'self.acceptButton:Show()', 'self.declineButton:Hide()'):
    if phrase not in preview:errors.append('preview parity missing '+phrase)
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'AcceptQuest(', 'DeclineQuest(',
                  'QuestRewardCompleteButton_OnClick(', 'HideUIPanel(', 'C_GossipInfo.Select'):
    if forbidden in preview or forbidden in m or forbidden in v:
        errors.append('preview/data/view contains gameplay mutation '+forbidden)
for fragment in ('function Visual:Present(cards, footer)',
                 'slot.icon:SetTexture(card.icon)',
                 'slot.label:SetText((card.kind == "choice"'):
    if fragment not in v:errors.append('production view was not retained '+fragment)
if 'Quest\\RewardModel.lua\nQuest\\RewardVisual.lua\nQuest\\Dialogue.lua' not in t:
    errors.append('model must load before shared renderer/dialogue')
ver_t=re.search(r'^## Version: (\S+)$',t,re.M)
ver_b=re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M)
if not ver_t or not ver_b or ver_t.group(1)!=ver_b.group(1): errors.append('runtime version mismatch')
dec=(r/'docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md')
if not dec.exists() or 'every Logres-owned UI element' not in dec.read_text(encoding='utf-8'):
    errors.append('universal preview-first decision missing')
print('Logres P0257 preview-first model and view parity contract')
print('=========================================================')
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: 0 errors (STATIC ONLY; WoW parity and claim unverified)')
