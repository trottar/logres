#!/usr/bin/env python3
"""P0195 static H.2 coordinated placement contract; never pin exact runtime version."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def read(s):return (ROOT/s).read_text(encoding='utf8')
L=read('Logres/Integration/Layout.lua')
S=read('Logres/HUD/StatusAuras.lua')
N=read('Logres/HUD/NativeDebuffs.lua')
P=read('Logres/Actions/Primary.lua')
A=read('Logres/Actions/SecondaryUtility.lua')
C=read('Logres/Core/Commands.lua')
H=read('Logres/HUD/HUD.lua')
error=[]
for k in ('playerHarmful','targetHarmful','targetHelpful'):
    if ('    '+k+' = {') not in L:error.append('missing new status anchor '+k)
for k in ('navigation','activeQuest','playerReaction','playerHarmful','targetFallback',
          'targetHarmful','targetHelpful','allies','classPet','secondaryActions',
          'primaryActions','passiveStatus','utilityActions','bar4Actions',
          'bar5Actions','nativeAccess'):
    if ('    '+k+' = { id = ') not in L:error.append('missing plan '+k)
for t in ('function Layout.ApplyApprovedV4()',
          'function Layout.GetH2PlacementStatus()',
          'viewport.width * rule.x / 100',
          '-viewport.height * rule.y / 100',
          'InCombatLockdown()',
          'restoreOriginalLayoutAnchors',
          'PLAYER_REGEN_ENABLED',
          'UI_SCALE_CHANGED'):
    if t not in L:error.append('missing placement safety '+t)
for token in ('local COLUMNS = 2','local ROWS = 6'):
    if token not in P:error.append('Primary '+token)
for token in ('secondary = { columns = 2, rows = 6 }',
              'utility = { columns = 6, rows = 2 }',
              'bar4 = { columns = 2, rows = 6 }',
              'bar5 = { columns = 2, rows = 6 }',
              'config.frameName,\n        columns,\n        rows,',
              '            columns\n        )'):
    if token not in A:error.append('action roles '+token)
for token in ('Logres.Layout.Bind(root, anchorKey, "CENTER", "CENTER")',
              'local columns = unit == "player" and MAX_ICONS or 2',
              'local anchorKey = unit == "player" and "playerHarmful"',
              'slot:SetPoint("TOPLEFT", root, "TOPLEFT"'):
    if token not in S:error.append('aura lane '+token)
# Keep the Phase H.2 semantic anchor requirements while checking the
# Phase H.3 bounded native-aura geometry, not an obsolete pixel literal.
for token in ('"player", "playerHarmful"','"target", "targetHarmful"',
              'Logres.Layout.Bind(frame, key, "CENTER", "CENTER")',
              'local columns = unit == "target" and 2 or 5',
              'local width = columns * ICON + (columns - 1) * GAP',
              'math.ceil(MAX / columns)',
              'frame:SetSize(width, height)'):
    if token not in N:error.append('native harmful '+token)
if 'targetFrame:SetSize(198, 54)' not in H or 'targetNameText:SetWidth(190)' not in H:
    error.append('target frame width/label')
if 'targetCastCue:SetPoint("TOP", targetFrame, "BOTTOM", 0, -6)' not in H:
    error.append('target cast cue geometry')
if 'status.anchorCount == #LAYOUT_EXPECTED + 3' not in L:error.append('anchor count')
if 'Logres H2 v4 placement:' not in L:error.append('runtime placement diagnostic')
if 'Logres.Layout.RunDevLayoutCheck(emit)' not in C:error.append('command layout diagnostic route')
if any(x in L for x in ('C_Timer.After','C_Timer.NewTicker','SetScript("OnUpdate"',
                         'BuffFrame:Hide','DebuffFrame:Hide')):error.append('unsafe layout forcing')
print('Logres P0195 coordinated screen placement contract')
for e in error:print('ERROR:',e)
if error:raise SystemExit(1)
print('PASS: unified 16 semantic anchors, status/native safety, role shapes')
