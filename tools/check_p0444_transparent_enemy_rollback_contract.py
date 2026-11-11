#!/usr/bin/env python3
"""P0444: no opaque world frame, intact target health and aura source."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua');c=read('Logres/Core/Commands.lua')
d=read('Logres/Dev/Panel.lua');a=read('Logres/HUD/StatusAuras.lua')
trial=h.split('function HUD:BuildLiveWorldEnemy()',1)[1].split('function HUD:HideLiveWorldEnemy',1)[0]
assert 'if self.worldEnemyLiveFrame then return true end' in trial
assert 'buildEnemyDisplayFixture(UIParent' in trial
assert 'frame:EnableMouse(false)' in trial
assert 'frame:CreateTexture' not in trial and 'SetColorTexture' not in trial
assert 'owned-matte-unavailable' not in h and 'worldEnemyLiveMatte' not in h
assert 'worldEnemyLivePresentation = "transparent-owned-unit"' in h
assert '"worldEnemyLivePresentation"' in d
assert 'World Enemy: presentation=' in c
assert 'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in h
assert 'self:HideLiveWorldEnemy("nameplate-removed")' in h
assert 'CreateWorldEnemyLiveLanes(frame)' in h and 'RefreshWorldEnemyLiveLanes()' in h
assert 'worldEnemySecondaryEnabled = false' in h
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
assert 'CreateWorldEnemyLiveLanes' in a and '25' in a
print('P0444 PASS: transparent 100% world target and existing aura ownership')
