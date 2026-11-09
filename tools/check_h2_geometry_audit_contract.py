#!/usr/bin/env python3
"""P0192/P0418 static contract for the H.2 geometry audit map."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
layout = (ROOT / 'Logres/Integration/Layout.lua').read_text(encoding='utf-8')
doc = json.loads((ROOT / 'docs/design/layout/SCREEN_MAP_V5.json').read_text(encoding='utf-8'))
errors = []

def need(ok: bool, why: str) -> None:
    if not ok:
        errors.append(why)

components = doc.get('components', [])
need(doc.get('coordinateSpace') == 'viewport percentages, component centers',
     'screen map v5 coordinate convention drift')
need(len(components) == 19, 'approved screen map must contain 19 components')
for token in (
    'function Layout.GetH2ScreenMapAudit()',
    'local result = {',
    'state = "MISSING"',
    'state = "MEASURED"',
    'reason = "read-only-addon-geometry"',
    'ordinaryGeometryNumber',
    'readAddonRect',
    'Logres H2 geometry AUDIT',
    'layout unchanged',
    'Only addon-owned frame references are inspected',
):
    need(token in layout, 'audit safety token missing: ' + token)

# Exact table rows the audit must expose.
for ident, frame, x, y, w, h in (
    ('compass', 'LogresCompassFrame', 31.4, 6.55, 37.4, 6.9),
    ('activeQuest', 'LogresActiveQuest', 78.2, 5.4, 19.6, 19.2),
    ('questDialogue', 'LogresQuestDialogue', 35.0, 28.0, 30.0, 30.0),
    ('contextObjective', 'LogresQuestObjectiveProgress', 40.0, 47.5, 20.0, 5.0),
    ('contextXP', 'LogresQuestXPPulse', 40.0, 61.0, 20.0, 4.0),
    ('player-debuff', 'LogresStatusAurasplayer', 39.5, 81.0, 22.5, 5.8),
    ('resource', 'LogresHUDResourceBar', 39.5, 88.3, 22.5, 6.0),
    ('player-buff', 'LogresPlayerHelpfulAuras', 77.0, 72.5, 22.0, 5.0),
    ('enemy-debuff', 'LogresStatusAurastarget', 65.2, 40.0, 6.0, 9.0),
    ('enemy', 'LogresHUDTarget', 72.0, 40.0, 13.0, 9.0),
    ('enemy-buff', 'LogresStatusAurastargetHelpful', 85.8, 40.0, 6.0, 9.0),
    ('group', 'LogresHUDAllies', 20.0, 32.7, 10.0, 25.9),
    ('petActions', 'LogresPetActionExecutionProbeCluster', 5.0, 52.5, 10.0, 5.0),
    ('bar2', 'LogresSecondaryActionCluster', 0.0, 56.0, 10.0, 38.0),
    ('bar1', 'LogresPrimaryActionCluster', 9.0, 56.0, 8.0, 38.0),
    ('bar4', 'LogresBar4ActionCluster', 5.0, 90.0, 10.0, 8.0),
    ('bar3', 'LogresUtilityActionCluster', 76.0, 80.0, 24.0, 10.0),
    ('bar5', 'LogresBar5ActionCluster', 76.0, 90.0, 24.0, 8.0),
    ('reportBug', 'LogresBugReportButton', 91.0, 33.25, 8.0, 3.5),
):
    row = f'{{ "{ident}", "{frame}", {x}, {y}, {w}, {h} }}'
    need(row in layout, 'audit row drift: ' + ident)

print('Logres H.2 approved screen-map audit contract')
for err in errors:
    print('ERROR:', err)
if errors:
    raise SystemExit(1)
print('PASS: 19 approved rows, read-only geometry audit, no native inspection or mutation')
