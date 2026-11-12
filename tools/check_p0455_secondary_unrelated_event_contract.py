#!/usr/bin/env python3
"""P0455: unrelated lifecycle updates cannot transfer nameplate ownership."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding="utf-8")
h = read("Logres/HUD/HUD.lua")
s = h[h.index("function HUD:ObserveSecondaryAggroTrial("):h.index("function HUD:BuildLiveWorldEnemy()")]
assert 'if event == "NAME_PLATE_UNIT_REMOVED" then' in s
assert 'probe:IsLiveEnemyRemovalRelevant(' in s
assert 'self:HideSecondaryAggroTrial("secondary-removed")' in s
start = s.index('local unit = probe:OrdinaryEventNameplateToken(eventUnit)')
end = s.index('if self.worldEnemySecondaryTrialUnit\n', start)
unknown = s[start:end]
assert 'if not unit then' in unknown
assert 'self.worldEnemySecondaryTrialIgnoredUnrelatedEvents' in unknown
assert 'return' in unknown
assert 'HideSecondaryAggroTrial' not in unknown
assert 'if decision ~= "eligible" or not ordinaryInCombat() then' in s
assert 'self:HideSecondaryAggroTrial("secondary-threat-lost-or-unknown")' in s
assert 'self.worldEnemySecondaryTrialUnit ~= unit' in s
assert 'self.worldEnemySecondaryTrialUnit == unit' in s
assert 'frame:SetScale(0.5)' in h and 'frame:SetAlpha(0.5)' in h
assert 'frame:EnableMouse(false)' in h
assert 'worldEnemySecondaryEnabled = false' in h
assert 'self:RestoreNativeSecondaryEnemyDecor()' in h
assert 'self:HideSecondaryAggroTrial("secondary-combat-ended")' in h
assert 'self:HideSecondaryAggroTrial("secondary-target-changed")' in h
assert 'self:HideSecondaryAggroTrial("off")' in h
assert 'self.worldEnemySecondaryTrialLastDetachReason = reason or "secondary-hidden"' in h
assert 'worldEnemySecondaryTrialIgnoredUnrelatedEvents' in read('Logres/Dev/Panel.lua')
assert 'World Enemy secondary updates: ignored unrelated=' in read('Logres/Core/Commands.lua')
assert 'P0454 visual FAIL' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0455' in read('docs/memory/CURRENT.md')
assert 'P0455' in read('docs/memory/patches/PATCH_INDEX.md')
assert 'P0455' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/investigations/ACTIVE.md'):
    assert read(path).startswith('## P0455 —') and '## P0454 —' in read(path)
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0455:')
a = re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
b = re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'))
assert a and b and a[1] == b[1]
print('P0455 PASS: unrelated updates ignored; relevant removal, negative threat and native restoration retained (STATIC)')
