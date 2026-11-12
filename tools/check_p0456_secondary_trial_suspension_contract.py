#!/usr/bin/env python3
"""P0456: secondary visual experiment suspended after two Forever failures."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua')
setlive=h[h.index('function HUD:SetLiveWorldEnemy(enabled)'):h.index('function HUD:SetEnemyDisplayPreview(enabled)')]
on=setlive[setlive.index('if enabled then'):setlive.index('self.worldEnemyLiveRequested = true')]
assert 'self:BuildLiveWorldEnemy()' in on
assert 'self.worldEnemySecondaryTrialArmed = false' in on
assert 'self:HideSecondaryAggroTrial("secondary-trial-suspended")' in on
assert 'self:BuildSecondaryAggroTrial()' not in on
assert 'self.worldEnemyLiveRequested = true' in setlive
assert 'self:RefreshLiveWorldEnemy("manual")' in setlive
assert 'self:HideSecondaryAggroTrial("off")' in setlive
assert 'worldEnemySecondaryEnabled = false' in h
assert 'frame:SetScale(0.5)' in h and 'frame:SetAlpha(0.5)' in h
assert 'function HUD:RestoreNativeSecondaryEnemyDecor()' in h
assert 'function HUD:ObserveSecondaryAggroTrial(event, eventUnit, decision)' in h
assert 'or not self.worldEnemySecondaryTrialArmed then return end' in h
assert 'function HUD:RefreshLiveWorldEnemy(event, eventUnit)' in h
assert 'function HUD:ClaimNativeEnemyDecor(anchor)' in h
assert 'World Enemy LIVE: selected target 100%; secondary 50% visual trial SUSPENDED' in read('Logres/Core/Commands.lua')
assert 'P0455' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0455' in read('docs/memory/evidence/P0456_SECONDARY_TRIAL_SUSPENSION.md')
for p in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/memory/investigations/ACTIVE.md'):
    s=read(p)
    assert s.startswith('## P0456 —') and '## P0455 —' in s
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0456:')
assert 'P0456' in read('docs/memory/CURRENT.md')
assert 'P0456' in read('docs/memory/patches/PATCH_INDEX.md')
assert 'P0456' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
a=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
b=re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua'))
assert a and b and a[1] == b[1]
print('P0456 PASS: selected retained; unaccepted 50% secondary takeover suspended (STATIC)')
