#!/usr/bin/env python3
"""P0213 H.3 Compass label readability, no hardcoded runtime version."""
from pathlib import Path
import re
r = Path(__file__).resolve().parents[1]
t = (r / 'Logres/Media/Theme.lua').read_text(encoding='utf-8')
c = (r / 'Logres/Navigation/Compass.lua').read_text(encoding='utf-8')
errors = []
def req(ok, why):
    if not ok: errors.append(why)
for s in ('labelContrast = {', 'cardinalShadow = {', 'intercardinalShadow = {', 'shadowOffset = { 1, -1 }'):
    req(s in t, f'missing Compass Theme contrast token {s}')
for s in ('labelContrast.cardinal or compassLabels.cardinal', 'labelContrast.intercardinal or compassLabels.intercardinal',
          'definition.cardinal and cardinalShadow or intercardinalShadow', 'label:SetShadowColor(', 'label:SetShadowOffset('):
    req(s in c, f'missing Compass render contract {s}')
for s in ('local UPDATE_INTERVAL = 0.05', 'local WAYPOINT_UPDATE_INTERVAL = 0.15',
          'local VISIBLE_HALF_ANGLE = compassStyle.visibleHalfAngle or 100',
          'baseline:SetTexture(compassAssets.baseline)', 'center:SetTexture(compassAssets.center)',
          'self.waypointMarker:SetAlpha(edgeAlpha)', 'function Compass:UpdateWaypointMarker()'):
    req(s in c, f'Compass source or geometry invariant absent {s}')
req(not any(s in c for s in ('C_QuestLog.', 'C_SuperTrack.', 'GetNextWaypoint', 'C_Map.GetWorldPosFromMapPos')),
    'unproven compass marker source added')
req('SetParent(' not in c and 'RegisterStateDriver(' not in c, 'protected or native ownership mutation in Compass')
version1 = re.search(r'Logres\.VERSION = "([^"]+)"', (r/'Logres/Core/Bootstrap.lua').read_text())
version2 = re.search(r'^## Version: (.+)$', (r/'Logres/Logres.toc').read_text(), re.M)
req(bool(version1 and version2 and version1.group(1) == version2.group(1)), 'Bootstrap/TOC version mismatch')
print('Logres H.3 compass contrast contract')
print('==================================')
for s in errors: print('FAIL:',s)
if errors: raise SystemExit(1)
print('PASS: 0 errors')
