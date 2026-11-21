#!/usr/bin/env python3
"""P0505: known addon flight shell encloses unchanged native taxi art and controls."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
src = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
frame = re.search(r'local visual = \{width = (\d+), height = (\d+), point = config.preview.point,', src)
map_geometry = re.search(r'local mapX, mapY, mapSize = (\d+), (\d+), (\d+)', src)
assert frame and map_geometry
width, height = map(int, frame.groups())
x, y, size = map(int, map_geometry.groups())
# Prior 820x660 shell failed: (279+580,100+580)=(859,680) overflowed.
assert (width, height) == (900, 720)
assert (x, y, size) == (279, 100, 580), "Never silently distort native taxi pin art"
assert x >= 32 and y >= 32 and width - (x + size) >= 32
assert height - (y + size) >= 32
# Sidebar washes must fit too: x=32 w=220, y=102 h=578.
assert 32 + 220 <= x and 102 + 578 <= height - 32
for token in (
    'art:SetSize(visual.width, visual.height)',
    'assert(Logres.PanelSurface.Paint(root, config.surface, visual.width, visual.height))',
    'chrome.anchor(changes, root, visual.point, UIParent, visual.relativePoint, visual.x, visual.y)',
    'chrome.resize(changes, root, visual.width, visual.height)',
    'chrome.anchor(plan, map, "TOPLEFT", art, "TOPLEFT", x, -y)',
    'chrome.resize(plan, map, size, size)',
    'chrome.resize(plan, routeMap, size, size)',
    'adopt(plan, pin.frame, pin.parent, routeMap, strata, level + 2)',
    'pcall(click, pin, "LeftButton")',
    'local function flightFits()',
    'chrome.read(UIParent, "GetWidth"), chrome.read(UIParent, "GetHeight")',
    'height >= visual.height + math.abs(visual.y)',
    'if not flightFits() then result = "stock-small-viewport"; return end',
    'if live and not flightFits() then',
    'restore("stock-small-viewport")',
    'restore("stock-requested")',
    'if not host.MatchesScale(art, routeMap, hostedPins) then',
):
    assert token in src, token
assert 'chrome.fits()' not in src, "Viewport check must use new flight-only dimensions"
for forbidden in ('TakeTaxiNode', 'C_Timer', 'OnUpdate', 'hooksecurefunc'):
    assert forbidden not in src
assert 'P0505_FLIGHT_PANEL_BOUNDS.md' in (root / 'docs/memory/investigations/ISSUE_LEDGER.md').read_text(encoding='utf-8')
print('P0505 flight shell/map/sidebar containment and native pin, scale, restore gates: PASS (STATIC)')
