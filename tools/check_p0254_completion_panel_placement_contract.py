#!/usr/bin/env python3
"""P0254: shared original Accept action must render INSIDE completion panel."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(r/'Logres/Quest/CompletionControl.lua').read_text(encoding='utf-8')
b=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
t=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
p=(r/'Logres/UI/NarrativePages.lua').read_text(encoding='utf-8')
e=[]
for token in (
    'self.completionActionRoot = offerActionRoot',
    'self.completionButton = acceptButton',
    'self.acceptButton.label:SetText("Complete Quest")',
    'self.acceptButton.label:SetText("Accept")',
    'if self.completionControl and self.completionControl.applied then',
    'self:UpdatePageControls()',
    'self.offerActionRoot:ClearAllPoints()',
    '"TOP", self.root, "BOTTOM", 0, offerStyleValue("y")',
    'offerStyleValue("y") + 64',
    'if #self.completionRewardCards == 0 then',
    'self.root:SetHeight(391)',
    'self.completionControl:Activate()',
):
    if token not in d:e.append('missing internal-panel or offer-restoration contract: '+token)
if d.count('createOfferButton(')!=3:
    e.append('original single factory and Accept/Decline only must remain')
if d.count('offerStyleValue("y") + 64')!=1:
    e.append('completion positioning must be a single, gated site')
start=d.find('if applied then\n                -- The existing Accept button')
end=d.find('self.acceptButton.label:SetText("Complete Quest")',start)
if start<0 or end<start or 'self:PositionCompletionActionVisual()' not in d[start:end]:
    e.append('shared panel-internal position must be invoked only after guarded stock suppression')
# The original geometry still exists at exactly one source site; the same
# helper is invoked once by guarded production and once by inert preview.
if d.count('function Dialogue:PositionCompletionActionVisual()') != 1 or d.count('self:PositionCompletionActionVisual()') != 2:
    e.append('single shared completion positioning helper required for live and preview')
helper_start=d.find('function Dialogue:PositionCompletionActionVisual()')
helper_end=d.find('function Dialogue:HandleQuestComplete()',helper_start)
if helper_start<0 or helper_end<helper_start or 'self.offerActionRoot:SetPoint(' not in d[helper_start:helper_end]:
    e.append('completion helper must anchor actual shared action root')
start=d.find('if shouldShow then\n        -- P0255: the very same Accept/Decline action pair')
end=d.find('self.acceptButton.label:SetText("Accept")',start)
if start<0 or end<start or 'self.offerActionRoot:SetPoint(' not in d[start:end]:
    e.append('ordinary offer panel ownership must be explicitly restored')
page_start=d.find('function Dialogue:UpdatePageControls()')
page_end=d.find('function Dialogue:SetPage(',page_start)
if page_start<0 or page_end<page_start or 'Logres.NPCNarrativePages.Paint(' not in d[page_start:page_end]:
    e.append('completion page navigation is not delegated to the actual shared rail')
for fragment in (
    'self.pageIndicator:ClearAllPoints()',
    '"BOTTOMRIGHT", self.root, "BOTTOMRIGHT", -115, 17',
    '"BOTTOM", self.root, "BOTTOM", 0, 17',
):
    if fragment not in p:e.append('completion pagination geometry missing from view: '+fragment)
if 'self:Restore("claim-invoked")' not in c or 'pcall(_G.QuestRewardCompleteButton_OnClick)' not in c:
    e.append('stock must restore before native claim; no mutation allowed')
if 'Complete Quest below' in d:e.append('duplicate owned footer instruction')
# Layout model: original offer y=-4 and 62px root height; centered button
# has +9 offset, so its label is 26px BELOW the narrative panel. New guarded
# y offset (+64) moves it approximately 38px INSIDE with room for the footer.
offer_top=-4
root_height=62
center_adjust=9
before=offer_top-root_height/2+center_adjust
after=offer_top+64-root_height/2+center_adjust
if not before<0<after or after<30 or after>52:
    e.append('action must move inside panel with bottom clearance')
# Nav center sits >100px to the right of the 150px-wide centered action;
# the 28px chevrons also remain inside the 640px narrative.
button_half=75
nav_center=320-115
nav_prev_left=nav_center-45-10-28
nav_next_right=nav_center+45+10+28
if nav_prev_left<=button_half or nav_next_right>320:
    e.append('completion page navigation would overlap action or leave panel')
tv=re.search(r'^## Version: (\S+)$',t,re.M)
bv=re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M)
if not tv or not bv or tv.group(1)!=bv.group(1):
    e.append('runtime version mismatch')
print('Logres P0254 internal quest completion action layout contract')
print('===========================================================')
for x in e:print('ERROR:',x)
if e:raise SystemExit(1)
print('PASS: 0 errors')
