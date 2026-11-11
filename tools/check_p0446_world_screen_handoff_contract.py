#!/usr/bin/env python3
"""P0446: addon-owned world/screen target handoff; native presentation untouched."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua');d=read('Logres/Dev/Panel.lua');c=read('Logres/Core/Commands.lua')
update=h.split('function HUD:UpdateTarget()',1)[1].split('function HUD:ApplyImmersionPreference',1)[0]
assert 'self.worldEnemyLiveVisible ~= true' in update
assert 'self.targetFrame:Show()' in update and 'self.targetFrame:Hide()' in update
assert 'self.targetNameText:SetShown(self.worldEnemyLiveVisible ~= true)' in update
assert 'self.targetHealthBar:SetShown(self.worldEnemyLiveVisible ~= true)' in update
assert 'self.targetNameText:SetText(UnitName("target"))' in update
hide=h.split('function HUD:HideLiveWorldEnemy(reason)',1)[1].split('function HUD:UpdateLiveWorldEnemyValues',1)[0]
assert 'hadWorldOwner' in hide and 'self:UpdateTarget()' in hide
assert hide.count('refreshScreenFallback()') >= 3
assert 'hide-protected-deferred' in hide and 'hide-refused' in hide
attach=h.split('function HUD:RefreshLiveWorldEnemy(event, eventUnit)',1)[1].split('function HUD:SetLiveWorldEnemy',1)[0]
assert attach.index('pcall(frame.Show, frame)') < attach.index('self.targetNameText:Hide()')
assert 'self.targetFrame:Show() -- Preserve its independent cast cue child.' in attach
assert 'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in attach
for name in ('worldEnemyScreenHandoffs','worldEnemyScreenFallbackRefreshes','worldEnemyScreenFallbackVisible'):
    assert name in h and '"'+name+'"' in d and name in c
assert 'worldEnemyLivePresentation = "transparent-owned-unit"' in h
assert 'worldEnemySecondaryEnabled = false' in h
assert 'frame:EnableMouse(false)' in h
for forbidden in ('anchor:SetAlpha(', 'anchor:Hide(', 'SetCVar(', 'GetNamePlates(', 'anchor:GetChildren(', 'anchor:GetRegions('):
    assert forbidden not in attach, forbidden
assert 'session 108 #11645' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0443' in read('docs/memory/evidence/P0446_WORLD_SCREEN_FALLBACK_HANDOFF.md')
print('P0446 PASS: one Logres target presentation on successful attach; native visuals preserved')
