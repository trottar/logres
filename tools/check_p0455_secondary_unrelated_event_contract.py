#!/usr/bin/env python3
"""P0455 unrelated-event invariant; historical missing->detach rule is a visual failure, NOT a requirement."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1];read=lambda x:(R/x).read_text()
h=read('Logres/HUD/HUD.lua');s=h[h.index('function HUD:ObserveSecondaryAggroTrial('):h.index('function HUD:BuildLiveWorldEnemy()')]
for x in ('if event == "NAME_PLATE_UNIT_REMOVED" then',
          'self:HideSecondaryAggroTrial("secondary-removal-unknown")',
          'self:HideSecondaryAggroOwner(slot, "secondary-removed")',
          'local unit = probe:OrdinaryEventNameplateToken(eventUnit)',
          'if not unit then', 'self.worldEnemySecondaryTrialIgnoredUnrelatedEvents',
          'if decision == "promoted" or decision == "unsafe"',
          'or decision == "confirmed-loss"', 'SECONDARY_MAX_INCONCLUSIVE',
          'self.worldEnemySecondaryTrialInconclusiveWithdrawals',
          'self.worldEnemySecondaryTrialInconclusiveHolds',
          'probe:AcquireLiveEnemySecondaryAnchor(unit)',
          'slot.blocked = true'):
    assert x in s,x
unrelated=s[s.index('if not unit then\n        -- Unrelated unit events'):s.index('local old = self:SecondaryOwnerForUnit(unit)')]
assert 'HideSecondaryAggro' not in unrelated
assert 'return' in unrelated
assert 'frame:SetScale(0.5)' in h and 'frame:SetAlpha(0.5)' in h
assert 'frame:EnableMouse(false)' in h and 'worldEnemySecondaryEnabled = false' in h
assert 'self:RestoreNativeSecondaryEnemyDecor(slot)' in h
assert 'self:HideSecondaryAggroTrial("secondary-combat-ended")' in h
assert 'self:HideSecondaryAggroTrial("off")' in h
assert 'self.worldEnemySecondaryTrialLastDetachReason = reason or "secondary-hidden"' in h
assert 'worldEnemySecondaryTrialIgnoredUnrelatedEvents' in read('Logres/Dev/Panel.lua')
assert 'World Enemy secondary updates: ignored unrelated=' in read('Logres/Core/Commands.lua')
assert 'P0454 visual FAIL' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0455' in read('docs/memory/CURRENT.md')
assert 'P0455' in read('docs/memory/patches/PATCH_INDEX.md')
assert 'P0455' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/memory/investigations/ACTIVE.md'):
 assert '## P0455 —' in read(path) and '## P0454 —' in read(path)
assert '# P0455:' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
a=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'));b=re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'))
assert a and b and a[1]==b[1]
print('P0455 PASS: unrelated token ignored; known loss/removal unsafe restore; missing bounded, not forced teardown (STATIC)')
