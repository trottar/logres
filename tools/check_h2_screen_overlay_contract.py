#!/usr/bin/env python3
"""P0194/P0418 developer panel H.2 approved-screen overlay contract."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
panel = (ROOT / 'Logres/Dev/Panel.lua').read_text(encoding='utf-8')
layout = (ROOT / 'Logres/Integration/Layout.lua').read_text(encoding='utf-8')
errors = []

def need(ok: bool, msg: str) -> None:
    if not ok:
        errors.append(msg)

for token in (
    'self.h2MapButton = h2MapButton',
    'self.h2MapHost = mapHost',
    'self.h2MapCanvas = canvas',
    'self.h2MapPlanned = planned',
    'self.h2MapMeasured = measured',
    'self.h2MapInfo = info',
    'self.h2MapOverlayInfo = overlayInfo',
    'function Panel:RefreshH2Map()',
    'local approvedPlan = Logres.Layout.GetH2ScreenMapPlan()',
    'for index = 1, #approvedPlan do',
    'for index = 1, #plan do',
    'putH2PanelBox(self.h2MapPlanned[index], self.h2MapCanvas,',
    'local row = report.rows[index]',
    'putH2PanelBox(self.h2MapMeasured[index], self.h2MapCanvas,',
    'Actual: %d/%d measured | %d missing | %d deferred | %s',
    'Layout Check',
    'Overlay ON',
    'Overlay OFF',
    'Refresh Map',
    'BLUE expected at approved anchors    GOLD measured Logres frames',
):
    need(token in panel, 'panel H.2 map token missing: ' + token)

for token in (
    'function Layout.SetH2MapVisible(visible)',
    'function Layout.GetH2MapOverlayStatus()',
    'function Layout.GetH2ScreenMapPlan()',
    'root:SetAllPoints(UIParent)',
    'root:SetFrameStrata("TOOLTIP")',
    'root:EnableMouse(false)',
    'placeMapOutline(root.planned[index], viewport.width, viewport.height,',
    'placeMapOutline(root.measured[index], viewport.width,',
    'BLUE = EXPECTED AT APPROVED ANCHOR | GOLD = MEASURED LOGRES FRAME',
):
    need(token in layout, 'runtime overlay token missing: ' + token)

if 'C_Timer' in panel or 'OnUpdate' in panel:
    errors.append('developer overlay must remain on-demand only')

print('Logres H.2 approved-screen overlay contract')
for err in errors:
    print('ERROR:', err)
if errors:
    raise SystemExit(1)
print('PASS: panel map and fullscreen overlay remain developer-only, read-only, and driven by the approved plan')
