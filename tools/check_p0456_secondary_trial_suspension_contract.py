#!/usr/bin/env python3
"""P0456 negative trial retained; P0458 re-enables only a capability-gated, independently validated successor."""
from pathlib import Path
R=Path(__file__).resolve().parents[1];read=lambda x:(R/x).read_text()
h=read('Logres/HUD/HUD.lua')
setlive=h[h.index('function HUD:SetLiveWorldEnemy(enabled)'):h.index('function HUD:SetEnemyDisplayPreview(enabled)')]
on=setlive[setlive.index('if enabled then'):setlive.index('self.worldEnemyLiveRequested = true')]
assert 'self:BuildLiveWorldEnemy()' in on
assert 'self:BuildSecondaryAggroTrial()' in on
assert 'self.worldEnemySecondaryTrialArmed = secondaryBuilt == true' in on
assert 'if not secondaryBuilt then' in on
assert 'self.worldEnemyLiveRequested = true' in setlive
assert 'self:RefreshLiveWorldEnemy("manual")' in setlive
assert 'self:HideSecondaryAggroTrial("off")' in setlive
assert 'worldEnemySecondaryEnabled = false' in h
assert 'frame:SetScale(0.5)' in h and 'frame:SetAlpha(0.5)' in h
assert 'function HUD:RestoreNativeSecondaryEnemyDecor(slot)' in h
assert 'function HUD:ObserveSecondaryAggroTrial(event, eventUnit, decision)' in h
assert 'not self.worldEnemySecondaryTrialArmed then return end' in h
assert 'function HUD:RefreshLiveWorldEnemy(event, eventUnit)' in h
assert 'function HUD:ClaimNativeEnemyDecor(anchor)' in h
assert 'secondary visual trial SUSPENDED' not in read('Logres/Core/Commands.lua')
assert 'P0454/P0455 secondary 50/50 VISUAL FAIL' in read('docs/memory/CURRENT.md')
assert 'P0455' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0455' in read('docs/memory/evidence/P0456_SECONDARY_TRIAL_SUSPENSION.md')
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/memory/investigations/ACTIVE.md'):
 s=read(path);assert s.startswith('## P0458 —') and '## P0456 —' in s and '## P0455 —' in s
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0458:')
assert '# P0456:' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert 'P0456' in read('docs/memory/CURRENT.md')
assert 'P0456' in read('docs/memory/patches/PATCH_INDEX.md')
assert 'P0456' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
print('P0456 PASS: failed visual trial/suspension recorded, later guarded multi-owner recovery distinct (STATIC)')
