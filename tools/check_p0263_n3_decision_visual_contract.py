#!/usr/bin/env python3
"""P0263 N3: exact shared action-button appearance, original controller ownership."""
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
D=(ROOT/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
V=(ROOT/'Logres/UI/DecisionVisual.lua').read_text(encoding='utf-8')
T=(ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
B=(ROOT/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
E=[]

for token in (
 'Logres.NPCDecisionVisual = Visual',
 'function Visual.CreateButton(parent, kind, label, styleValue, colorValue, assets)',
 'local function setOfferVisual(button, color)',
 'local button = CreateFrame(',
 'button:EnableMouse(true)',
 'button:RegisterForClicks("LeftButtonUp")',
 'button:SetSize(',
 'styleValue("buttonWidth")',
 'styleValue("buttonHeight")',
 'styleValue("font")',
 'assets.rule',
 'text:SetPoint("CENTER", button, "CENTER", 0, 3)',
 'text:SetShadowColor(0, 0, 0, 0.90)',
 'text:SetShadowOffset(1, -1)',
 'button.label = text', 'button.rule = rule', 'button.kind = kind',
 'colorValue("accept")', 'colorValue("decline")',
 'colorValue("hover")', 'colorValue("pressed")',
 'button:SetScript("OnEnter", function()',
 'button:SetScript("OnLeave", function()',
 'button:SetScript("OnMouseDown", function()',
 'button:SetScript("OnMouseUp", function()',
 'setOfferVisual(button, normalColor)',
 'return button',
):
 if token not in V:E.append('visual factory contract missing: '+token)

for forbidden in (
 'SetScript("OnClick"', 'GetQuestReward(', 'AcceptQuest(', 'DeclineQuest(',
 'CompleteQuest(', 'QuestRewardCompleteButton_OnClick', 'TriggerProductionAction',
 'RequestStockOfferSuppression', 'UnitExists(', 'issecretvalue',
 'RegisterEvent(', 'C_Timer.', 'OnUpdate', 'DynamicCam', 'SetParent(',
 'ShowUIPanel(', 'HideUIPanel(', 'C_GossipInfo.Select',
):
 if forbidden in V:E.append('view cannot own gameplay/native/camera: '+forbidden)

if V.count('CreateFrame(')!=1:E.append('view must construct exactly one generic visual button')
if V.count('button:SetScript(')!=4:E.append('view must bind only four cosmetic callbacks')
if D.count('createOfferButton(')!=3:E.append('original factory wrapper plus precisely two physical controls required')
if D.count('Logres.NPCDecisionVisual.CreateButton(')!=1:E.append('exactly one shared visual factory call required')
if 'local function setOfferVisual(' in D:E.append('old cosmetic painter remained duplicated in Dialogue')
if 'button:CreateFontString(' in D:E.append('duplicate button typography factory in Dialogue')
if 'button:CreateTexture(' in D:E.append('duplicate button rule factory in Dialogue')

click_start=D.find('button:SetScript("OnClick", function()')
click_end=D.find('    return button\nend',click_start)
click=D[click_start:click_end] if click_start>=0 and click_end>click_start else ''
for token in ('if owner.offerActionPreview then', 'owner:HandleOfferAction(kind)',
 'if kind == "accept" and owner.completionActive',
 'and owner.completionControl.applied', 'owner:HandleCompletionAction()'):
 if token not in click:E.append('production/preview click owner missing: '+token)
if click and not click.index('if owner.offerActionPreview then') < click.index('owner:HandleCompletionAction()'):
 E.append('preview click must intercept before native completion controller')
if D.count('button:SetScript("OnClick", function()')!=1:
 E.append('only Dialogue must bind its one original generic click callback')
for token in ('function Dialogue:UpdateOfferControls()',
 'self.root:SetHeight(391)',
 'offerStyleValue("y") + offerStyleValue("height") + 2',
 'function Dialogue:PositionCompletionActionVisual()',
 'offerStyleValue("y") + 64',
 'function Dialogue:UpdateCompletionPagePresentation()',
 'Logres.NPCNarrativePages.Paint(',
 'Logres.NPCNarrativePages.ShowBody(',
 'self.completionControl:Activate()',
 'self:RequestStockOfferSuppression('):
 if token not in D:E.append('original layout/ownership invariant missing: '+token)
if D.count('function Dialogue:PositionCompletionActionVisual()')!=1 or D.count('self:PositionCompletionActionVisual()')!=2:
 E.append('one shared completion placement called only from live and preview')
if D.count('offerStyleValue("y") + 64')!=1:
 E.append('completion visual placement must not be duplicated')
if 'UI\\NarrativePages.lua\nUI\\DecisionVisual.lua\nQuest\\ContextVisual.lua' not in T:
 E.append('N3 visual must load before original quest frame construction')
if 'Quest\\NarrativeModel.lua\nQuest\\RewardModel.lua\nQuest\\RewardVisual.lua\nQuest\\Dialogue.lua' not in T:
 E.append('existing model and dialogue load adjacency changed')
vt=re.search(r'^## Version: (\S+)$',T,re.M)
vb=re.search(r'^Logres\.VERSION = "([^"]+)"$',B,re.M)
if not vt or not vb or vt.group(1)!=vb.group(1):E.append('TOC/Bootstrap version mismatch')

print('Logres P0263 N3 decision visual factory contract')
print('===============================================')
for e in E:print('ERROR:',e)
if E:raise SystemExit(1)
print('PASS: shared visuals, controller separation, two physical buttons, frozen source contracts')
