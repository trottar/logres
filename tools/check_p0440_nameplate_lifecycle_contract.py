#!/usr/bin/env python3
"""P0440: event-time nameplate sources remain read-only, separate, and fail-open."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
p = read('Logres/HUD/WorldTargetProbe.lua')
c = read('Logres/Core/Commands.lua')
d = read('Logres/Dev/Panel.lua')
h = read('Logres/HUD/HUD.lua')
assert 'local LIFECYCLE_EVENTS = {' in p
for e in ('NAME_PLATE_UNIT_ADDED', 'NAME_PLATE_UNIT_REMOVED',
          'UNIT_TARGET', 'UNIT_FLAGS', 'UNIT_THREAT_LIST_UPDATE'):
    assert '"' + e + '"' in p
assert 'function Probe:ObserveNameplateLifecycle(event, eventUnit)' in p
segment = p[p.index('function Probe:ObserveNameplateLifecycle('):
            p.index('function Probe:GetNameplateLifecycleLines()')]
for fragment in ('ordinaryNameplateToken(eventUnit)', 'isSecret(unit)',
                 'callOrdinary(api, unit, false)',
                 'readBoolean(frame.IsForbidden, frame)',
                 'readBoolean(UnitIsUnit, unit, "target")',
                 'readBoolean(UnitIsUnit, unit .. "target", "player")',
                 'readBoolean(UnitAffectingCombat, unit)',
                 'readBoolean(InCombatLockdown)',
                 'reaction.category == "hostile"',
                 'attackable == true',
                 'currentTarget == false', 'self.lifecycleSecondaryAnchorsSeen',
                 'self.lifecycleCombatHostileTargetingPlayer'):
    assert fragment in (p if fragment in ('isSecret(unit)', 'callOrdinary(api, unit, false)') else segment), fragment
for forbidden in ('SetPoint', 'SetParent', 'SetAttribute', 'SetScale',
                  'SetAlpha', 'GetNamePlates', 'GetCVar', 'SetCVar',
                  'UnitThreatSituation', 'UnitDetailedThreatSituation',
                  'CreateFrame', 'C_Timer', 'OnUpdate', 'self.lifecycleTokens[',
                  'self.lifecycleFrames['):
    assert forbidden not in segment, forbidden
assert 'lifecycleFrame:SetScript("OnEvent", function(_, event, unit)' in p
assert 'self:ObserveNameplateLifecycle(event, unit)' in p
assert 'eventFrame:SetScript("OnEvent", function(_, event)' in p
assert 'self:RecordEventAnchor(event, capture)' in p
assert 'self:RecordEventAnchor("enable", self.lastCapture)' in p
assert 'self:Capture("enable")' in p
assert 'self.lifecycleFrame = lifecycleFrame' in p
assert 'RunDevNameplateLifecycleStatus(emit)' in p
assert 'function Logres:HandleNameplateLifecycleStatus()' in c
assert 'if command == "nameplatelifecycle" then' in c
assert 'label = "Nameplate Lifecycle", command = "nameplatelifecycle"' in d
assert 'WORLD_TRIAL_PANEL_ACTIONS = {' in d
assert len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', c)) == 122
assert 'incident.snapshot.nameplateLifecycle' in d
for field in ('lifecycleAddedEvents', 'lifecycleRemovedEvents',
              'lifecycleSecondaryAnchorsSeen','lifecycleTargetAnchorsSeen',
              'lifecycleCombatHostileTargetingPlayer','lifecycleSecretResults',
              'lifecycleLastRole','lifecycleLastAnchor'):
    assert field+' =' in p and '"'+field+'"' in d,field
assert 'enemyFallbackPreserved = true' in h
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
toc_version = re.search(r'(?m)^## Version: (\S+)$', read('Logres/Logres.toc'))
bootstrap_version = re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',
                              read('Logres/Core/Bootstrap.lua'))
assert toc_version and bootstrap_version
assert toc_version.group(1) == bootstrap_version.group(1)
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
for path in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/roadmap/STATUS.md'):
    s = read(path)
    assert '## P0440 —' in s and '## P0439 —' in s
assert len(read('docs/memory/CURRENT.md').encode()) < 9800
print('P0440 PASS: event-time source, independent secondary anchor/targeting evidence, safe panel/incident, fallback intact (STATIC)')
