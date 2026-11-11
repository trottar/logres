#!/usr/bin/env python3
"""P0441: opt-in owned world enemy, fail-open, historic contract compatibility."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
h = read('Logres/HUD/HUD.lua')
p = read('Logres/HUD/WorldTargetProbe.lua')
a = read('Logres/HUD/StatusAuras.lua')
c = read('Logres/Core/Commands.lua')
d = read('Logres/Dev/Panel.lua')
assert 'function HUD:BuildLiveWorldEnemy()' in h
assert 'function HUD:RefreshLiveWorldEnemy(event, eventUnit)' in h
assert 'function HUD:SetLiveWorldEnemy(enabled)' in h
assert 'ordinaryOwnedUnprotected(frame)' in h
assert 'local function ordinaryInCombat()' in h
assert 'not ordinaryOutOfCombat() and not ordinaryInCombat()' in h
assert ('frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in h
        or 'frame:SetPoint("BOTTOM", anchor, "TOP", 0, 6)' in h)
assert 'self.worldEnemyLiveRequested = false' in h
assert 'worldEnemySecondaryEnabled = false' in h
assert 'enemyFallbackPreserved = true' in h
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
assert 'function Probe:AcquireLiveEnemyTargetAnchor(eventUnit, fromEvent)' in p
anchor = p.split('function Probe:AcquireLiveEnemyTargetAnchor(eventUnit, fromEvent)', 1)[1].split('\nend\n', 1)[0]
for fragment in ('ordinaryNameplateToken(eventUnit)', 'readBoolean(UnitIsUnit, unit, "target")',
                 'readEventReaction(unit)', '"not-hostile"', '"not-attackable"',
                 'readEventNameplate(unit)', 'readBoolean(anchor.IsForbidden, anchor)',
                 'readBoolean(api, unit)'):
    assert fragment in anchor, fragment
for forbidden in ('SetCVar', 'GetNamePlates(', 'SetParent(', 'SetAttribute('):
    assert forbidden not in anchor and forbidden not in h.split('-- P0441: event-driven',1)[1].split('function HUD:SetEnemyDisplayPreview',1)[0]
assert 'function StatusAuras:CreateWorldEnemyLiveLanes(parent)' in a
assert 'function StatusAuras:RefreshWorldEnemyLiveLanes()' in a
assert '"P0441WorldHarmful"' in a and '"P0441WorldHelpful"' in a
assert 'function Logres:HandleLiveWorldEnemyCommand(argument)' in c
assert 'if command == "worldenemy" then' in c
for label in ('World Enemy ON', 'World Enemy OFF', 'World Enemy Status'):
    assert 'label = "' + label + '"' in d
assert len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', c)) == 122
assert 'incident.snapshot.worldEnemyLive' in d
for field in ('worldEnemyLiveRequested','worldEnemyLiveVisible','worldEnemyLiveLastReason',
              'worldEnemyLiveAttachments','worldEnemyLiveFailures','worldEnemySecondaryEnabled'):
    assert field in h and '"'+field+'"' in d
versions = [re.search(pattern, src).group(1) for pattern, src in [
    (r'(?m)^## Version: (\S+)$', read('Logres/Logres.toc')),
    (r'(?m)^Logres.VERSION = "([^"\n]+)"$', read('Logres/Core/Bootstrap.lua'))]]
assert versions[0] == versions[1]
for path in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    s=read(path)
    assert ('## P0441 —' in s and '## P0440 —' in s), 'historical P0441/P0440 must be retained'
assert len(read('docs/memory/CURRENT.md').encode('utf-8')) < 9800
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
print('P0441 PASS: opt-in real enemy world frame + ordinary anchor guard, saved default OFF, native fallback and historic contracts (STATIC)')
