#!/usr/bin/env python3
"""P0258: Single and Multiple use the same inert in-panel Complete Quest preview."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
m = (ROOT/'Logres/Quest/RewardModel.lua').read_text(encoding='utf-8')
d = (ROOT/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
v = (ROOT/'Logres/Quest/RewardVisual.lua').read_text(encoding='utf-8')
c = (ROOT/'Logres/Quest/CompletionControl.lua').read_text(encoding='utf-8')
t = (ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
b = (ROOT/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
issues = []

if m.count('if mode == "single" then') != 1 or m.count('elseif mode == "multi" then') != 1:
    issues.append('single and multi fixtures must each have a unique branch')
else:
    single = m.split('if mode == "single" then', 1)[1].split('elseif mode == "multi" then', 1)[0]
    multi = m.split('elseif mode == "multi" then', 1)[1].split('else\n        return nil, "unknown-preview-mode"', 1)[0]
    for name, block in (('single', single), ('multi', multi)):
        if 'footer = "1050 XP | 7s"' not in block:
            issues.append(name + ' fixture must show amounts without Blizzard instruction')
        if 'action = "preview-complete"' not in block:
            issues.append(name + ' fixture must request the shared visual completion control')
    if multi.count('kind = "choice"') != 3 or multi.count('kind = "reward"') != 1:
        issues.append('multiple preview must retain guaranteed item and three sample choice cards')
    if 'action = "stock-choice"' in multi or 'Blizzard quest window' in multi:
        issues.append('multiple preview must not render stock-choice instruction')
if 'Blizzard quest window' in m:
    issues.append('authored reward preview model contains unnecessary Blizzard instruction')
if 'action = "native-gated"' not in m or 'previewOnly = false' not in m or 'previewOnly = true' not in m:
    issues.append('separate live and synthetic model authority must remain')
for phrase in ('function Dialogue:ShowRewardPreview(mode)',
               'Logres.QuestRewardModel.Preview(mode)',
               'self.rewardVisual:Present(model.cards, model.footer)',
               'if model.action == "preview-complete" then',
               'self:PositionCompletionActionVisual()',
               'self.acceptButton.label:SetText("Complete Quest")',
               'self.offerActionRoot:Show()'):
    if phrase not in d:
        issues.append('preview not using existing view/control: ' + phrase)
start = d.find('function Dialogue:ShowRewardPreview(mode)')
end = d.find('function Dialogue:GetDebugStatus()', start)
preview = d[start:end] if start >= 0 and end > start else ''
if not preview or 'self.declineButton:Hide()' not in preview:
    issues.append('single/multi visual must show one action, not Accept/Decline pair')
click_start = d.find('button:SetScript("OnClick", function()')
click_end = d.find('end)', click_start)
click = d[click_start:click_end] if click_start >= 0 and click_end > click_start else ''
if not click or 'if owner.offerActionPreview then' not in click or not click.index('if owner.offerActionPreview then') < click.index('owner:HandleCompletionAction()'):
    issues.append('synthetic completion click must be intercepted before native route')
if 'function Visual:Present(cards, footer)' not in v or 'slot.icon:SetTexture(card.icon)' not in v:
    issues.append('existing production portrait renderer must stay shared')
for phrase in ('GetNumQuestChoices, 0', 'self:Restore("claim-invoked")',
               'pcall(_G.QuestRewardCompleteButton_OnClick)'):
    if phrase not in c:
        issues.append('existing guarded production/stock fallback was altered: ' + phrase)
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'AcceptQuest(', 'DeclineQuest(',
                  'C_GossipInfo.Select', 'HideUIPanel(', 'SetScript("OnClick"'):
    if forbidden in m or forbidden in preview:
        issues.append('fixture/view must never claim a quest or mutate native controls: ' + forbidden)
if d.count('function Dialogue:PositionCompletionActionVisual()') != 1:
    issues.append('exactly one shared completion layout helper must remain')
vt = re.search(r'^## Version: (\S+)$', t, re.M)
vb = re.search(r'^Logres\.VERSION = "([^"]+)"$', b, re.M)
if not vt or not vb or vt.group(1) != vb.group(1):
    issues.append('TOC/Bootstrap current version parity must remain')
print('Logres P0258 inert Multi/Single preview completion parity')
print('=====================================================')
for item in issues:
    print('ERROR:', item)
if issues:
    raise SystemExit(1)
print('PASS: 0 errors (static only; no live multiple-choice claim acceptance)')
