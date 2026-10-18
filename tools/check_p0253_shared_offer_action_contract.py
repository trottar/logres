#!/usr/bin/env python3
"""P0253: completion must use the ACTUAL Accept frame/button, not cloned styling."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
cc=(r/'Logres/Quest/CompletionControl.lua').read_text(encoding='utf-8')
t=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
b=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
e=[]
for token in (
    'self.completionActionRoot = offerActionRoot',
    'self.completionButton = acceptButton',
    'self.acceptButton.label:SetText("Complete Quest")',
    'self.acceptButton.label:SetText("Accept")',
    'self.acceptButton:ClearAllPoints()',
    'self.acceptButton:Show()',
    'self.declineButton:Hide()',
    'self.declineButton:Show()',
    'and self.declineButton:IsVisible()',
    'and owner.completionControl.applied',
    'owner:HandleCompletionAction()',
    'if self.completionControl and self.completionControl.applied then',
    'self.completionControl:Activate()',
    'local ownedFooter = rewardFooter:gsub(',
    r'"\nComplete using Blizzard quest controls", ""',
    r'return label .. "\nComplete using Blizzard quest controls"',
    'self.completionControl = Logres.QuestCompletionControl.New(',
):
    if token not in d:e.append('missing shared original Accept control: '+token)
if d.count('createOfferButton(')!=3:
    e.append('only one factory and exactly two original Accept/Decline creations')
for forbidden in ('CreateFrame("Frame", nil, root)\n    self.completionActionRoot',
                  'self.completionActionRoot = CreateFrame(',
                  'local completionButton = createOfferButton(',
                  'completionButton.rule:SetDrawLayer('):
    if forbidden in d:e.append('duplicate completion presentation: '+forbidden)
if 'Complete Quest below' in d:e.append('duplicate completion instruction returned')
start=d.find('function Dialogue:UpdateOfferControls()')
end=d.find('function Dialogue:HandleOfferAction(',start)
s=d[start:end] if start>=0 and end>start else ''
if not s or s.index('if self.completionControl and self.completionControl.applied then') > s.index('self:RequestStockOfferSuppression('):
    e.append('completion ownership must survive paging without touching stock suppression')
if 'shown = self.applied and self.actionRoot:IsShown() or false' not in cc or 'self:Restore("claim-invoked")' not in cc or 'pcall(_G.QuestRewardCompleteButton_OnClick)' not in cc:
    e.append('unchanged stock-restore-before-claim contract missing')
tv=re.search(r'^## Version: (\S+)$',t,re.M)
bv=re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M)
if not tv or not bv or tv.group(1)!=bv.group(1):e.append('runtime versions not in parity')
print('Logres P0253 single shared Accept/Complete action contract')
print('=========================================================')
for m in e:print('ERROR:',m)
if e:raise SystemExit(1)
print('PASS: 0 errors')
