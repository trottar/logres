#!/usr/bin/env python3
"""P0443: owned-only world-nameplate backing and fallback contract."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding="utf-8")
h=read("Logres/HUD/HUD.lua")
panel=read("Logres/Dev/Panel.lua")
cmd=read("Logres/Core/Commands.lua")
trial=h.split('function HUD:BuildLiveWorldEnemy()',1)[1].split('function HUD:SetLiveWorldEnemy',1)[0]
assert 'if not ordinaryOutOfCombat() then return false, "build-requires-ooc" end' in trial
assert 'frame:EnableMouse(false)' in trial
assert 'ordinaryOwnedUnprotected(frame)' in trial
assert 'pcall(function()' in trial
assert 'frame:CreateTexture(nil, "BACKGROUND")' in trial
assert 'texture:SetSize(208, 44)' in trial
assert 'texture:SetPoint("TOP", frame, "TOP", 0, 0)' in trial
assert 'texture:SetColorTexture(0.016, 0.012, 0.009, 1)' in trial
assert '"owned-matte-unavailable"' in trial
assert 'self.worldEnemyLiveMatteReady = true' in trial
assert 'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in trial
assert 'self:HideLiveWorldEnemy("owned-attach-refused")' in trial
assert 'self:HideLiveWorldEnemy("nameplate-removed")' in h
for forbidden in ('SetParent(', 'SetCVar(', 'GetNamePlates(', 'anchor:Hide(',
                  'anchor:SetAlpha(', 'anchor:GetChildren(', 'anchor:GetRegions('):
    assert forbidden not in trial, forbidden
assert 'worldEnemyLiveMatteReady = self.worldEnemyLiveMatteReady == true' in h
assert 'worldEnemyLiveMatteReady' in panel and 'worldEnemyLivePresentation' in panel
assert 'World Enemy: owned backing ready=' in cmd
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
assert 'worldEnemySecondaryEnabled = false' in h
for path in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    s=read(path)
    assert s.startswith('## P0443 —') and '## P0442 —' in s
assert '| L-011 | World-attached target anchor | PARTIAL |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0443' in read('docs/memory/CURRENT.md')
assert len(read('docs/memory/CURRENT.md').encode()) < 9800
assert len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', cmd)) == 122
v=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)
assert v==re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print('P0443 PASS: OOC-only owned opaque name/health backing, no native writes, unchanged target/aura/fallback (STATIC)')
