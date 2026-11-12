#!/usr/bin/env python3
"""P0453: separate ordinary threat-state evidence, no secondary promotion."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda name: (R / name).read_text(encoding="utf-8")
p = read("Logres/HUD/WorldTargetProbe.lua")
d = read("Logres/Dev/Panel.lua")
h = read("Logres/HUD/HUD.lua")
life = p[p.index("local LIFECYCLE_EVENTS = {"):p.index("local EVENTS = {")]
assert '"UNIT_THREAT_LIST_UPDATE"' in life
assert '"UNIT_THREAT_SITUATION_UPDATE"' in life
section = p[p.index("function Probe:ObserveSecondaryThreat("):p.index("function Probe:RunDevNameplateLifecycleStatus(")]
legacy = section[section.index('if source.secret or detail.secret then'):]
for s in ('ordinaryNameplateToken(eventUnit)', 'observation.secondary ~= true',
          'callOrdinary(UnitThreatSituation, "player", unit)',
          'readBoolean(UnitDetailedThreatSituation, "player", unit)',
          'if source.secret or detail.secret then', 'primary ~= (detail.value == true)',
          '"same-event-primary-threat-candidate"', 'observation.anchorSafe',
          'observation.inCombat', 'observation.targetingPlayer'):
    assert s in section, s
for s in ('secondaryThreatLastResult = "secret-threat-deferred"',
          'secondaryThreatLastResult = "no-ordinary-threat-pair"',
          'secondaryThreatLastResult = "threat-query-failed"'):
    assert s in legacy, s
for s in ('if source.secret then', 'elseif source.failure then',
          'elseif not source.present then', 'elseif type(status) ~= "number"',
          'if status >= 2 then', 'if detail.secret then',
          'elseif detail.failure then', 'elseif not detail.present then',
          'observation.reaction == "hostile"',
          'self.secondaryThreatBasicEligibleDetailSecretEvents'):
    assert s in section, s
assert section.index('if source.secret then') < section.index('if status >= 2 then')
assert section.index('if detail.secret then') < section.index('if detail.value == true then')
assert section.index('if source.secret or detail.secret then') > section.index('if detail.secret then')
for s in ('SetPoint(', 'SetAlpha(', 'SetScale(', 'CreateFrame(', 'SetCVar(',
          'GetNamePlates(', 'C_Timer.', 'OnUpdate', 'UnitGUID(', 'SetParent(',
          'GetChildren(', 'GetAuraDataByIndex('):
    assert s not in section, s
assert 'worldEnemySecondaryEnabled = false' in h
assert '50%% DISABLED' in p
fields = ['secondaryThreatBasicOrdinaryEvents', 'secondaryThreatBasicPrimaryEvents', 'secondaryThreatBasicNonprimaryEvents', 'secondaryThreatBasicSecretEvents', 'secondaryThreatBasicMissingEvents', 'secondaryThreatBasicFailureEvents', 'secondaryThreatBasicEligibleEvents', 'secondaryThreatBasicEligibleDetailSecretEvents', 'secondaryThreatDetailOrdinaryEvents', 'secondaryThreatDetailTankingEvents', 'secondaryThreatDetailSecretEvents', 'secondaryThreatDetailMissingEvents', 'secondaryThreatDetailFailureEvents', 'secondaryThreatLastBasic', 'secondaryThreatLastDetail']
for field in fields:
    assert 'self.'+field+' =' in p, field
    assert field+' = self.'+field in p, field
    assert '"'+field+'"' in d, field
for path in ("docs/ROADMAP.md", "docs/memory/roadmap/STATUS.md",
             "docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md",
             "docs/memory/investigations/ACTIVE.md"):
    assert read(path).startswith("## P0453 \u2014".replace("\u2014", "—")), path
    assert "## P0451 —" in read(path), path
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc')).group(1)==re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$',read('Logres/Core/Bootstrap.lua')).group(1)
print("P0453 PASS: independent ordinary basic/detailed threat provenance, no 50% renderer")
