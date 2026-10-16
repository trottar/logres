#!/usr/bin/env python3
"""P0216 appearance-only rendering contract. Safe state and routing stay owned elsewhere."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
source=lambda p:(ROOT/p).read_text(encoding='utf-8')
button=source('Logres/Actions/Button.lua')
hud=source('Logres/HUD/HUD.lua')
theme=source('Logres/Media/Theme.lua')
quest=source('Logres/Quest/ActiveQuest.lua')
layout=source('Logres/Integration/Layout.lua')
errs=[]
cluster=button.split('function ActionButton.CreateCluster(',1)[-1].split('function ActionButton.Create(',1)[0]
if 'local cluster = CreateFrame("Frame", name, UIParent)' not in cluster or 'return cluster' not in cluster:
    errs.append('cluster construction contract lost')
if 'cluster:CreateTexture' in cluster or 'SetColorTexture' in cluster:
    errs.append('cluster-wide background must not be created')
for tok in ('"SecureActionButtonTemplate"','local border = button:CreateTexture(nil, "BACKGROUND")',
            'inner:SetColorTexture(0.025, 0.022, 0.018, 0.98)',
            'frameArt:SetTexture(actionAssets.frame)','activationFlash:SetTexture(actionAssets.flash)'):
    if tok not in button:errs.append('button or visual/secure surface removed: '+tok)
for tok in ('resource = {','trackWidth = 210','diamondSize = 12','normal = {','trackWidth = 142',
            'compact = {','trackWidth = 58'):
    if tok not in theme:errs.append('bar variant missing '+tok)
if '"LogresHUDResourceBar",\n        "resource",' not in hud:errs.append('resource bar did not select distinct resource style')
if '"LogresHUDTargetHealthBar",\n        "normal",' not in hud:errs.append('target normal bar must remain')
if '"compact",' not in hud:errs.append('compact ally/pet bar removed')
for tok in ('snapshot.ready == true','snapshot.complete == true',
            'self.completionRule:Show()', 'self.completionRule:Hide()',
            'self.completionSeal:Show()', 'self.completionSeal:Hide()',
            'self.divider:SetVertexColor(', 'self.ambient:SetText(phrase)',
            'return "READY TO TURN IN"','return "QUEST COMPLETE"'):
    if tok not in quest:errs.append('completion-state visual missing '+tok)
for tok in ('theme.percentageBar = {','theme.activeQuest = {','completionDivider =', 'completionSeal ='):
    if tok not in theme:errs.append('theme token missing '+tok)
if 'SCREEN_MAP_V4' not in layout and 'function Layout.ApplyApprovedV4()' not in layout:
    errs.append('approved semantic layout no longer active')
for frag in ('UnitHealth("player"','UnitHealthMax("player"','UnitLevel(', 'UnitClassification('):
    if frag in hud:errs.append('forbidden data read '+frag)
print('Logres P0216 visual focus and secure-layout preservation contract')
for e in errs:print('ERROR:',e)
if errs:raise SystemExit(1)
print('PASS: 0 errors')
