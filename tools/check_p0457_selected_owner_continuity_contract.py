#!/usr/bin/env python3
"""P0457: retain selected owner without native reclaims on steady events."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding="utf-8")
h=read("Logres/HUD/HUD.lua")
s=h[h.index("function HUD:RefreshLiveWorldEnemy("):h.index("function HUD:SetLiveWorldEnemy(")]
assert s.index('probe:AcquireLiveEnemyTargetAnchor(')<s.index('if self.worldEnemyLiveVisible then')
steady=s[s.index('if self.worldEnemyLiveVisible then'):s.index('local frame = self.worldEnemyLiveFrame',s.index('if self.worldEnemyLiveVisible then'))]
for t in ('self.worldEnemyNativeClaim', 'sameOrdinaryAddedUnit',
          'anchorUnit == self.worldEnemyLiveAnchorUnit',
          'if event ~= "NAME_PLATE_UNIT_ADDED" or sameOrdinaryAddedUnit then',
          'self:UpdateLiveWorldEnemyValues()',
          'self.worldEnemyLiveContinuityRefreshes',
          'self.worldEnemyLiveLastContinuityEvent',
          'self:HideLiveWorldEnemy("selected-anchor-transition")',
          'if self.worldEnemyNativeClaim then',
          '"native-restore-pending"'):
    assert t in steady,t
for forbidden in ('frame:Hide()', 'frame:ClearAllPoints()',
                  'frame:SetPoint(', 'ClaimNativeEnemyDecor(anchor)',
                  'SetWorldEnemyScreenAuraHandoff(true)',
                  'worldEnemyScreenHandoffs + 1', 'GetNamePlates(',
                  'UnitGUID(', 'OnUpdate', 'C_Timer.'):
    assert forbidden not in steady,forbidden
assert s.index('self:ClaimNativeEnemyDecor(anchor)')>s.index('if self.worldEnemyLiveVisible then')
assert 'if why ~= "not-current-target" then self:HideLiveWorldEnemy(why) end' in s
assert 'if event == "NAME_PLATE_UNIT_ADDED" then requestedUnit = eventUnit end' in s
assert 'self:HideLiveWorldEnemy("target-changed")' in h
assert 'self:HideLiveWorldEnemy("nameplate-removed")' in h
assert 'self:HideLiveWorldEnemy("off")' in h
assert 'self.worldEnemySecondaryTrialArmed = secondaryBuilt == true' in h
assert 'self:HideSecondaryAggroTrial("off")' in h
assert 'worldEnemySecondaryEnabled = false' in h
for p in ("Logres/Dev/Panel.lua","Logres/Core/Commands.lua"):
    v=read(p)
    for k in ('worldEnemyLiveContinuityRefreshes','worldEnemyLiveReanchors',
              'worldEnemyLiveLastContinuityEvent','worldEnemyLiveLastDetachReason'):
        assert k in v,(p,k)
assert 'P0457' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0457' in read('docs/memory/CURRENT.md')
assert 'P0457' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert 'P0457' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
assert 'P0457' in read('docs/memory/patches/PATCH_INDEX.md')
for p in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/investigations/ACTIVE.md'):
    assert '## P0457 —' in read(p) and '## P0456 —' in read(p)
a=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
b=re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'))
assert a and b and a[1]==b[1]
print('P0457 PASS: selected steady-state owner and restoration unchanged; secondary separately gated (STATIC)')
