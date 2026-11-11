#!/usr/bin/env python3
"""P0443 historical failure: opaque backing must not remain in P0444."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua')
c=read('Logres/Core/Commands.lua')
d=read('Logres/Dev/Panel.lua')
trial=h.split('function HUD:BuildLiveWorldEnemy()',1)[1].split('function HUD:SetLiveWorldEnemy',1)[0]
assert 'if not ordinaryOutOfCombat() then return false, "build-requires-ooc" end' in trial
assert 'frame:EnableMouse(false)' in trial
assert 'ordinaryOwnedUnprotected(frame)' in trial
assert 'frame:CreateTexture(nil, "BACKGROUND")' not in trial
assert 'texture:SetSize(208, 44)' not in trial
assert 'owned-matte-unavailable' not in trial
assert 'worldEnemyLiveMatte' not in h+c+d
assert 'worldEnemyLivePresentation = "transparent-owned-unit"' in h
assert 'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in trial
assert 'self:HideLiveWorldEnemy("nameplate-removed")' in h
for forbidden in ('SetParent(', 'SetCVar(', 'GetNamePlates(', 'anchor:Hide(',
                  'anchor:SetAlpha(', 'anchor:GetChildren(', 'anchor:GetRegions('):
    assert forbidden not in trial, forbidden
assert 'worldEnemyLivePresentation' in d
assert 'World Enemy: presentation=' in c
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
assert 'worldEnemySecondaryEnabled = false' in h
assert '208x44 fully' in read('docs/memory/evidence/P0444_TRANSPARENT_ENEMY_ROLLBACK.md')
current = read('docs/memory/CURRENT.md')
work_item = current.split('\n## Current Work Item\n', 1)[1].split('\n## ', 1)[0]
active = re.search(r'(?m)^\*\*(P[0-9]{4})\*\*(?:\s|$)', work_item)
assert active, 'CURRENT work item must name the active checkpoint'
for path in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md', 'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
 s=read(path)
 assert s.startswith('## ' + active[1] + ' —')
 assert all('## ' + old + ' —' in s for old in ('P0444', 'P0443', 'P0442'))
 assert s.index('## P0444 —') < s.index('## P0443 —') < s.index('## P0442 —')
assert '| L-011 | World-attached target anchor | PARTIAL |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0443' in read('docs/memory/CURRENT.md')
assert len(read('docs/memory/CURRENT.md').encode()) < 9800
assert len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', c)) == 122
v=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)
assert v==re.search(r'^Logres.VERSION = "([^"]+)"$', read('Logres/Core/Bootstrap.lua'), re.M).group(1)
print('P0443 HISTORICAL PASS: rejected backing absent, negative evidence retained')
