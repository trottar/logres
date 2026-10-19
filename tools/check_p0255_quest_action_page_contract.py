#!/usr/bin/env python3
"""P0255: final-page reward disclosure and in-panel quest offers."""
from pathlib import Path
import re
root=Path(__file__).resolve().parents[1]
d=(root/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(root/'Logres/Quest/CompletionControl.lua').read_text(encoding='utf-8')
t=(root/'Logres/Logres.toc').read_text(encoding='utf-8')
b=(root/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
p=(root/'Logres/UI/NarrativePages.lua').read_text(encoding='utf-8')
issues=[]
for fragment in (
 'function Dialogue:UpdateCompletionPagePresentation()',
 'local finalPage = self.currentPage == #self.pages',
 'self.objectiveHeader:SetShown(finalPage)',
 'self.objectiveText:SetShown(finalPage)',
 'self.completionActionRoot:Hide()',
 'self.completionActionRoot:Show()',
 'self.rewardVisual.slots[i]:Hide()',
 'self.root:SetHeight(styleValue("height"))',
 'self:UpdateCompletionPagePresentation()',
 'self.completionRewardText = rewardSummary',
 'offerStyleValue("y") + offerStyleValue("height") + 2',
 'offerStyleValue("y") + 64',
 'self.completionControl:Activate()',
 'self.completionButton = acceptButton',
 'owner:HandleCompletionAction()',
):
 if fragment not in d:issues.append('missing invariant: '+fragment)
# The historical coordinates must still exist at exactly one real shared
# painter, with the same owner-state gating; moving them must not drop them.
paint=p.split('function Pages.Paint(self, activeColor, inactiveColor)',1)[-1].split('function Pages.ShowBody(self, index)',1)[0]
for fragment in (
    'self.pageIndicator:ClearAllPoints()',
    'if self.completionActive then',
    'elseif self.offerActionsEnabled',
    'and self.currentPage == #self.pages then',
    '"BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 78',
    '"BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 17',
):
    if fragment not in paint:issues.append('missing shared pager invariant: '+fragment)
if 'Logres.NPCNarrativePages.Paint(' not in d.split('function Dialogue:UpdatePageControls()',1)[-1].split('function Dialogue:SetPage(',1)[0]:
    issues.append('quest page update must call actual shared rail painter')
setpage=d.split('function Dialogue:SetPage(',1)[1].split('function Dialogue:PreviousPage(',1)[0]
if 'self:UpdateCompletionPagePresentation()' not in setpage:
 issues.append('paging must update rewards and completion control')
helper=d.split('function Dialogue:UpdateCompletionPagePresentation()',1)[1].split('function Dialogue:PreviousPage()',1)[0]
if helper.index('if not finalPage then')>helper.index('self.completionActionRoot:Hide()'):
 issues.append('page gating must hide action only in nonfinal branch')
if helper.index('if not finalPage then')>helper.index('self.rewardVisual.slots[i]:Hide()'):
 issues.append('page gating must hide card slots only in nonfinal branch')
if 'self:UpdateCompletionPagePresentation()\n        local pending' not in d:
 issues.append('initial completion must refresh after native ownership')
offer=d.split('function Dialogue:UpdateOfferControls()',1)[1].split('function Dialogue:HandleOfferAction',1)[0]
if 'self.root:SetHeight(391)' not in offer or 'self.offerActionRoot:SetPoint(' not in offer:
 issues.append('offer action must sit within expanded narrative')
if d.count('createOfferButton(')!=3:issues.append('shared factory + Accept/Decline creations changed')
if 'self:Restore("claim-invoked")' not in c or 'pcall(_G.QuestRewardCompleteButton_OnClick)' not in c:
 issues.append('native stock restoration and claim handler must be preserved')
if 'C_Timer.After' in c or 'SetScript("OnUpdate"' in c:
 issues.append('native completion must not use speculative polling')
tv=re.search(r'^## Version: (\S+)$',t,re.M)
bv=re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M)
if not tv or not bv or tv.group(1)!=bv.group(1):issues.append('TOC/Bootstrap version mismatch')
print('Logres P0255 quest action final-page and in-panel contract')
print('==========================================================')
for x in issues:print('ERROR:',x)
if issues:raise SystemExit(1)
print('PASS: 0 errors')
