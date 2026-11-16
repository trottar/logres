#!/usr/bin/env python3
"""P0459: appearance, unlike threat, must not restore stock name/health on ordinary 0/1 or combat end."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua');p=read('Logres/HUD/WorldTargetProbe.lua')
obs=p[p.index('function Probe:ObserveSecondaryVisualEligibility('):p.index('function Probe:RunDevNameplateLifecycleStatus(')]
for x in ('if event == "NAME_PLATE_UNIT_REMOVED"',
          'if observation.currentTarget == true',
          'observation.currentTarget ~= false or not observation.anchorSafe',
          'observation.attackableObserved == false',
          'observation.attackableObserved ~= true',
          'observation.reaction == "hostile" or observation.reaction == "neutral"',
          'return "eligible"', 'return "inconclusive"', 'return "ineligible"'):
 assert x in obs,x
for forbidden in ('UnitThreatSituation', 'UnitDetailedThreatSituation', 'GetNamePlates(',
                  'SetAlpha(', 'SetParent(', 'SetPoint(', 'C_Timer.', 'OnUpdate'):
 assert forbidden not in obs,forbidden
life=p[p.index('local lifecycleFrame = CreateFrame('):p.index('self.lifecycleFrame = lifecycleFrame')]
for x in ('self:ObserveSecondaryThreat(event, unit, observation)',
          'self:ObserveSecondaryVisualEligibility(',
          'hud:ObserveSecondaryAggroTrial(event, unit, visual)'):
 assert x in life,x
s=h[h.index('function HUD:ObserveSecondaryAggroTrial('):h.index('function HUD:BuildLiveWorldEnemy()')]
assert 'not (ordinaryInCombat() or ordinaryOutOfCombat())' in s
assert 'if decision == "promoted" or decision == "unsafe"' in s
assert 'or decision == "ineligible"' in s
assert 'or decision == "confirmed-loss"' not in s
assert 'if decision ~= "eligible" then' in s
assert 'self:HideSecondaryAggroOwner(old, "secondary-inconclusive-limit")' in s
assert 'self.worldEnemySecondaryTrialStableUpdates' in s
assert 'self:HideSecondaryAggroTrial("secondary-removal-unknown")' in s
assert 'self:HideSecondaryAggroOwner(slot, "secondary-removed")' in s
assert 'probe:ObserveSecondaryVisualEligibility(' in s
assert 'self:HideSecondaryAggroTrial("secondary-combat-ended")' not in h
assert 'self:HideSecondaryAggroTrial("off")' in h
claim=h[h.index('function HUD:ClaimNativeSecondaryEnemyDecor('):h.index('function HUD:RefreshSecondaryOwnerCount(')]
for x in ('nativeDecorField(unitFrame, "name")','nativeDecorField(unitFrame, "HealthBarsContainer")',
          '"LevelFrame"', '"PlayerLevelDiffFrame"', 'safeNativeDecor(region)',
          'slot.claim = claim', 'pcall(entry.region.SetAlpha, entry.region, 0)'):
 assert x in claim,x
assert 'SetAlpha, entry.region, entry.original' in h
assert 'frame:SetScale(0.5)' in h and 'frame:SetAlpha(0.5)' in h
assert 'frame:EnableMouse(false)' in h
assert 'self:ReconcileSecondaryAggroTargetChange(previous)' in h
assert 'function HUD:RefreshLiveWorldEnemy(event, eventUnit)' in h
assert 'World Enemy secondary skin:' in read('Logres/Core/Commands.lua')
assert 'threat loss does not restore Blizzard art' in read('Logres/Core/Commands.lua')
for f in ('docs/memory/CURRENT.md','docs/memory/handoffs/CURRENT_HANDOFF.md',
          'docs/memory/investigations/ISSUE_LEDGER.md','docs/memory/patches/PATCH_INDEX.md',
          'docs/memory/PRE_HANDOFF_AUDIT.md','docs/ROADMAP.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/investigations/ACTIVE.md'):
 assert 'P0459' in read(f),f
assert 'P0454/P0455' in read('docs/memory/evidence/P0459_HOSTILE_PLATE_APPEARANCE.md')
assert read('docs/ROADMAP.md').startswith('## P0459 —')
print('P0459 PASS: actual source visual eligibility independent of threat, owned native decorative shell, safety and memory (STATIC)')
