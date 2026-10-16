#!/usr/bin/env python3
"""P0218 sheet-04 aura metadata: presentation-only, no new source access."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def read(s):return (ROOT/s).read_text(encoding='utf-8')
status=read('Logres/HUD/StatusAuras.lua')
theme=read('Logres/Media/Theme.lua')
helpful=read('Logres/HUD/PlayerHelpfulAuras.lua')
native=read('Logres/HUD/NativeDebuffs.lua')
errs=[]
for s in ('theme.statusAura = {', 'countWidth = 18','countHeight = 12', 'urgentRailWidth = 11',
          'urgentRailHeight = 2', 'urgentRailColor =', 'aura_frame_passive.tga', 'aura_count_plate.tga'):
    if s not in theme: errs.append('Theme missing '+s)
for s in ('local statusAssets = statusStyle.assets or {}',
          'local urgentRail = slot:CreateTexture(nil, "OVERLAY")',
          'local countPlate = slot:CreateTexture(nil, "OVERLAY")',
          'countPlate:SetTexture(statusAssets.countPlate)',
          'item.countPlate:Show()', 'item.countPlate:Hide()',
          'item.urgentRail:SetShown(aura.kind == "urgent")',
          'item.urgentRail:Hide()',
          'if aura.applications and aura.applications > 1 then',
          'item.count:SetFormattedText("%.0f", aura.applications)',
          'GameTooltip.SetUnitAura', 'C_Secrets.ShouldUnitAuraIndexBeSecret',
          'local MAX_ICONS = 5', 'local ICON_SIZE = 25',
          'local GAP = 3', 'local FILTERS = {',
          'Logres.Layout.Bind(root, anchorKey, "CENTER", "CENTER")'):
    if s not in status:errs.append('StatusAuras missing '+s)
if '"AuraContainer"' not in native or 'CustomAuraContainerTemplate' not in native:
    errs.append('Blizzard native secure harmful renderer missing')
if 'auraAssets.countPlate' not in helpful or 'frameTexture:SetTexture' not in helpful:
    errs.append('accepted player helpful aura art missing')
for s in ('OnUpdate', 'C_Timer.NewTicker', 'SetParent(', 'RegisterStateDriver(', 'UnitAura(', 'UnitHealth('):
    if s in status:errs.append('unexpected forbidden StatusAuras token '+s)
print('Logres P0218 sheet-04 aura metadata visual contract')
for e in errs:print('ERROR:',e)
print('PASS: 0 errors' if not errs else f'FAIL: {len(errs)} errors')
raise SystemExit(bool(errs))
