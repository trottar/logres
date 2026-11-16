#!/usr/bin/env python3
"""P0454 historical basic-source and native-safety contract; P0458 supersedes its failed single-slot trial."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda x:(R/x).read_text(encoding="utf-8")
p=read('Logres/HUD/WorldTargetProbe.lua');h=read('Logres/HUD/HUD.lua')
c=read('Logres/Core/Commands.lua');d=read('Logres/Dev/Panel.lua')
obs=p[p.index('function Probe:ObserveSecondaryThreat('):p.index('function Probe:RunDevNameplateLifecycleStatus(')]
for x in ('callOrdinary(UnitThreatSituation, "player", unit)',
          'readBoolean(UnitDetailedThreatSituation, "player", unit)',
          'if status >= 2 then', 'trialDecision = "eligible"',
          'trialDecision = "confirmed-loss"', 'trialDecision = "inconclusive"',
          'if detail.secret then', 'primary ~= (detail.value == true)'):
    assert x in obs,x
assert obs.index('trialDecision = "eligible"')<obs.index('if source.secret or detail.secret then')
assert obs.count('return trialDecision')>=8
for forbidden in ('SetPoint(', 'SetAlpha(', 'CreateFrame(', 'SetParent(', 'OnUpdate', 'C_Timer.', 'GetNamePlates(', 'UnitGUID('):
    assert forbidden not in obs,forbidden
assert 'local decision = self:ObserveSecondaryThreat(event, unit, observation)' in p
assert 'hud:ObserveSecondaryAggroTrial(event, unit, decision)' in p
anchor=p[p.index('function Probe:AcquireLiveEnemySecondaryAnchor('):p.index('-- Removal events must never reacquire',p.index('function Probe:AcquireLiveEnemySecondaryAnchor('))]
for x in ('ordinaryNameplateToken','readBoolean(UnitIsUnit, unit, "target")','readEventNameplate(unit)',
          'anchor.IsForbidden','IsNamePlateUnitBehindCamera'):
    assert x in anchor,x
for forbidden in ('SetAlpha(', 'SetPoint(', 'SetParent(', 'UnitGUID('):assert forbidden not in anchor,forbidden
s=h[h.index('-- P0458: bounded, OOC-precreated secondary pool'):h.index('function HUD:BuildLiveWorldEnemy()')]
for x in ('function HUD:BuildSecondaryAggroTrial()', 'SECONDARY_POOL_CAPACITY = 40',
          'if not ordinaryOutOfCombat()', 'frame:SetScale(0.5)', 'frame:SetAlpha(0.5)',
          'frame:EnableMouse(false)', 'function HUD:RestoreNativeSecondaryEnemyDecor(slot)',
          'entry.region.SetAlpha, entry.region, entry.original',
          'function HUD:ClaimNativeSecondaryEnemyDecor(slot, anchor)',
          'nativeDecorField(unitFrame, "name")',
          'nativeDecorField(unitFrame, "HealthBarsContainer")',
          'function HUD:HideSecondaryAggroTrial(reason)',
          'function HUD:ObserveSecondaryAggroTrial(event, eventUnit, decision)',
          'if event == "NAME_PLATE_UNIT_REMOVED" then', 'probe:AcquireLiveEnemySecondaryAnchor(unit)',
          'slot.frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)',
          'self:ClaimNativeSecondaryEnemyDecor(slot, anchor)',
          'self.worldEnemySecondaryOwners[unit] = slot',
          'SECONDARY_MAX_INCONCLUSIVE = 3', 'slot.blocked = true'):
    assert x in s,x
assert 'self:HideSecondaryAggroTrial("off")' in h
assert 'self:HideSecondaryAggroTrial("secondary-combat-ended")' in h
assert 'self.secondaryValueEvents:RegisterEvent(event)' in h
assert 'self.secondaryValueEvents:UnregisterAllEvents()' in h
assert 'worldEnemySecondaryEnabled = false' in h # production gate distinct from DEV opt-in
assert 'worldEnemySecondaryTrialVisible' in d and 'worldEnemySecondaryTrialRestoreFailures' in d
assert 'World Enemy secondary DEV trial:' in c
for path in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/memory/investigations/ACTIVE.md'):
    body=read(path); assert '## P0454 —' in body and '## P0453 —' in body,path
assert 'P0454' in read('docs/memory/CURRENT.md')
assert '# P0454:' in read('docs/memory/handoffs/CURRENT_HANDOFF.md')
assert 'P0453 #12307' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0454' in read('docs/memory/patches/PATCH_INDEX.md')
assert 'P0454' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
assert re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)==re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print('P0454 PASS: historical basic-source and native safety, failed one-slot assumption superseded by P0458 (STATIC)')
