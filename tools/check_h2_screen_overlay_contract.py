#!/usr/bin/env python3
"""P0194 R3: complete viewport map is usable inside the existing developer panel."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
layout = (ROOT/'Logres/Integration/Layout.lua').read_text(encoding='utf-8')
panel = (ROOT/'Logres/Dev/Panel.lua').read_text(encoding='utf-8')
commands = (ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
for token in (
    'function Layout.GetH2ScreenMapPlan()',
    'function Layout.SetH2MapVisible(visible)',
    'function Layout.GetH2MapOverlayStatus()',
    'local report = Layout.GetH2ScreenMapAudit()',
    'local viewport = readAddonRect(UIParent)',
    '#H2_SCREEN_MAP_V4',
    'placeMapOutline(root.planned[index]',
    'placeMapOutline(root.measured[index]',
    'viewportWidth * x / 100',
    '-viewportHeight * y / 100',
    'viewportWidth * w / 100',
    'viewportHeight * h / 100',
    'root:EnableMouse(false)',
    '"combat-deferred"',
    '"viewport-geometry-restricted"',
):
    if token not in layout: errors.append('Missing safe viewport map: '+token)
for token in (
    'local createH2PanelBox',
    'function Panel:RefreshH2Map()',
    'function Panel:SetH2MapMode(visible)',
    'function Panel:SetH2OverlayVisible(visible)',
    'self.h2MapButton:SetShown(phase == "H")',
    'h2MapButton:SetText("H.2 Map")',
    'canvas:SetSize(552, 310.5)',
    'for index = 1, 13 do',
    'putH2PanelBox(self.h2MapPlanned[index]',
    'putH2PanelBox(self.h2MapMeasured[index]',
    'Logres.Layout.GetH2ScreenMapPlan()',
    'Logres.Layout.GetH2ScreenMapAudit()',
    'Logres.Layout.SetH2MapVisible(visible)',
    '"Overlay ON"', '"Overlay OFF"', '"Refresh Map"', '"Layout Check"',
    'self:RunCommand("layoutcheck")',
    'self.buttonHost:SetShown(not view)',
    'self.results:SetShown(not view)',
):
    if token not in panel: errors.append('Missing panel H.2 view: '+token)
if not panel.count('self:SetH2MapMode(not self.h2MapMode)') == 1:
    errors.append('Dedicated H.2 panel toggle not wired exactly once')
for token in ('if command == "layoutcheck" then', 'if command == "h2map" then'):
    if token not in commands: errors.append('Missing command compatibility: '+token)
if 'P0194 R3' not in panel or 'P0194 R3' not in layout:
    errors.append('Panel / viewport map checkpoint marker missing')
map_code=layout.split('-- P0194 R2: one viewport-wide H.2 map.',1)[-1]
for token in ('BuffFrame:Hide', 'TargetFrame:Hide', 'RegisterStateDriver',
              'C_Timer.', 'SetParent(', 'SetAttribute('):
    if token in map_code: errors.append('Forbidden map operation: '+token)
print('P0194 R3 Phase H dedicated H.2 panel viewport map contract')
for err in errors: print('ERROR:',err)
print(('FAIL' if errors else 'PASS')+': '+str(len(errors))+' errors')
raise SystemExit(bool(errors))
