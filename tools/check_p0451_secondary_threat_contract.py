#!/usr/bin/env python3
"""P0451: same-event secondary threat proof, never a renderer."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf8')
p=read('Logres/HUD/WorldTargetProbe.lua')
d=read('Logres/Dev/Panel.lua')
h=read('Logres/HUD/HUD.lua')
obs=p[p.index('function Probe:ObserveNameplateLifecycle('):p.index('function Probe:GetNameplateLifecycleLines()')]
assert 'UnitThreatSituation' not in obs and 'UnitDetailedThreatSituation' not in obs
assert 'return {' in obs and 'secondary = currentTarget == false' in obs
section=p[p.index('function Probe:ObserveSecondaryThreat('):p.index('function Probe:RunDevNameplateLifecycleStatus(')]
for token in ('ordinaryNameplateToken(eventUnit)', 'observation.secondary ~= true',
              'callOrdinary(UnitThreatSituation, "player", unit)',
              'readBoolean(UnitDetailedThreatSituation, "player", unit)',
              'if source.secret or detail.secret then',
              'status < 0 or status > 3', 'local primary = status >= 2',
              'primary ~= (detail.value == true)',
              'observation.anchorSafe', 'observation.inCombat',
              'observation.enemyInCombat', 'observation.attackable',
              'observation.targetingPlayer', 'observation.reaction ~= "hostile"',
              '"same-event-primary-threat-candidate"'):
    assert token in section, token
for forbidden in ('SetAlpha(', 'SetParent(', 'SetPoint(', 'CreateFrame(',
                  'GetNamePlates(', 'C_Timer.', 'OnUpdate', 'UnitGUID(',
                  'SetCVar(', 'GetChildren(', 'self.secondaryTokens',
                  'self.secondaryFrames', 'GetAuraDataByIndex('):
    assert forbidden not in section, forbidden
assert 'local observation = self:ObserveNameplateLifecycle(event, unit)' in p
assert 'self:ObserveSecondaryThreat(event, unit, observation)' in p
assert '50%% DISABLED' in p
keys=['secondaryThreatEvents','secondaryThreatPrimaryEvents',
      'secondaryThreatQualifiedEvents','secondaryThreatNonprimaryEvents',
      'secondaryThreatNoTableEvents','secondaryThreatDisagreementEvents',
      'secondaryThreatSecretEvents','secondaryThreatFailureEvents',
      'secondaryThreatUnknownEvents','secondaryThreatLastEvent',
      'secondaryThreatLastResult']
for k in keys:
    assert 'self.'+k+' =' in p,k
    assert k+' = self.'+k in p,k
    assert '"'+k+'"' in d,k
assert 'lifecycleCombatHostileTargetingPlayer' in p
assert 'function HUD:RefreshLiveWorldEnemy(' in h
assert 'worldEnemySecondaryEnabled = false' in h
assert read('docs/memory/CURRENT.md').find('P0451')>=0
assert read('docs/memory/CURRENT.md').find('P0442')>=0
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0451:')
for path in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/roadmap/STATUS.md'):
    body=read(path)
    assert body.startswith('## P0451 —') and '## P0450 —' in body,path
assert 'P0450 selected-target visual PASS' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)==re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print('P0451 PASS: same-event ordinary primary-threat evidence, fail-open, no 50% mutation')
