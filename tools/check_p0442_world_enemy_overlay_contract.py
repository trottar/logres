#!/usr/bin/env python3
"""P0442: combat attachment positioning and removal fail-open contracts."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
read=lambda p:(r/p).read_text(encoding="utf-8")
h=read("Logres/HUD/HUD.lua")
p=read("Logres/HUD/WorldTargetProbe.lua")
d=read("Logres/Dev/Panel.lua")
c=read("Logres/Core/Commands.lua")
assert 'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in h
assert 'self.worldEnemyLiveAnchorUnit = anchorUnit' in h
assert 'event ~= "PLAYER_TARGET_CHANGED"' in h
assert 'self:HideLiveWorldEnemy("target-changed")' in h
assert 'self:HideLiveWorldEnemy("nameplate-removed")' in h
assert 'self:RefreshLiveWorldEnemy(event)' in h
assert 'IsLiveEnemyRemovalRelevant' in p
assert 'ordinaryNameplateToken(eventUnit)' in p
assert 'return false, "other-unit-removed"' in p
# P0454 adds a separate secondary-removal handler; constrain this historical
# check to the original selected-target worldTrialEvents callback.
world_events = h[h.index('local worldTrialEvents = CreateFrame('):
                 h.index('self.worldTrialEvents = worldTrialEvents')]
removal = world_events.split('if event == "NAME_PLATE_UNIT_REMOVED" then',1)[1].split('elseif event == "PLAYER_TARGET_CHANGED"',1)[0]
assert 'RefreshLiveWorldEnemy' not in removal, 'Never reacquire on removed event'
trial=h.split('-- P0441: event-driven',1)[1].split('function HUD:SetEnemyDisplayPreview',1)[0]
for forbidden in ('SetCVar', 'GetNamePlates(', 'SetParent(', 'SetAttribute(',
                  'anchor:Hide(', 'anchor:SetAlpha(', 'anchor:GetChildren('):
    assert forbidden not in trial, forbidden
for field in ('worldEnemyLiveDetaches','worldEnemyLiveRemovalResult','worldEnemyLiveLayout'):
    assert field in h and ('"'+field+'"') in d
assert 'World Enemy: layout=' in c
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
for path in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    s=read(path)
    assert '## P0442 —' in s and '## P0441 —' in s  # preserve history, not active phase
assert 'P0442' in read('docs/memory/CURRENT.md')
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
version=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)
assert version==re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print('P0442 PASS: native-anchor co-location, safe removal/target change, fallback retained (STATIC)')
