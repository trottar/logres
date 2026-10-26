#!/usr/bin/env python3
"""P0192: design-map mapping, read-only H.2 geometry audit and panel contract."""
from __future__ import annotations
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
layout = (ROOT / 'Logres/Integration/Layout.lua').read_text(encoding='utf-8')
commands = (ROOT / 'Logres/Core/Commands.lua').read_text(encoding='utf-8')
data = json.loads((ROOT / 'docs/design/layout/SCREEN_MAP_V4.json').read_text(encoding='utf-8'))
block = layout.split('local H2_SCREEN_MAP_V4 = {', 1)[1].split('\n}\n', 1)[0]
rows = re.findall(r'^\s*\{ "([\w-]+)", "([\w]+)", ([0-9.]+), ([0-9.]+), ([0-9.]+), ([0-9.]+) \},$', block, re.M)
errors = []
if len(rows) != 13 or len(data) != 13:
    errors.append('Expected 13 design-to-runtime bindings')
else:
    for got, wanted in zip(rows, data):
        id, frame, *numbers = got
        if id != wanted['id'] or list(map(float, numbers)) != [float(wanted[k]) for k in ('x','y','w','h')]:
            errors.append('Design mapping mismatches canonical JSON: ' + id)
        if not frame.startswith('Logres'):
            errors.append('Non-addon-owned frame: ' + frame)
for required in ('function Layout.GetH2ScreenMapAudit()', 'ordinaryGeometryNumber(value)', 'pcall(issecretvalue, value)', 'readAddonRect(UIParent)', 'local frame = _G[s[2]]', 'report.reason = "read-only-addon-geometry"'):
    if required not in layout:
        errors.append('Missing geometry audit safety/contract: '+required)
for required in ('local h2 = Logres.Layout.GetH2ScreenMapAudit()', 'Logres H2 v4 geometry AUDIT', 'layout unchanged', 'row.state == "MEASURED"'):
    if required not in layout:
        errors.append('Missing layout-owned developer-panel output: '+required)
if 'Logres.Layout.RunDevLayoutCheck(emit)' not in commands:
    errors.append('Missing Commands layout diagnostic forwarding')
if 'SetPoint(' in layout.split('-- P0192: read-only Phase H.2 v4 geometry audit.',1)[1].split('function Layout.GetDebugStatus()',1)[0]:
    errors.append('Audit may not mutate anchors')
print('P0192 read-only H.2 geometry audit contract')
for e in errors:
    print('ERROR:', e)
print(f"{'FAIL' if errors else 'PASS'}: {len(errors)} errors")
raise SystemExit(1 if errors else 0)
