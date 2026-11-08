#!/usr/bin/env python3
"""P0400 the visible flight window is independent of native root positioning."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
for token in (
    'local art = CreateFrame("Frame", nil, UIParent)',
    'art:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)',
    'chrome.method(child, "SetParent")', 'chrome.read(child, "GetParent") ~= root',
    'setParent(child, host)', 'setParent(child, root)',
    'for i = #geometry, 1, -1 do geometry[i].undo() end',
    'knownChildren(root, routeMap, close)',
    'adopt(changes, map, root, host, host, mapX, -mapY)',
    'adopt(changes, routeMap, root, host, map, 0, 0, level + 1)',
    'quietMouse(changes, root) or not quietMouse(changes, close)',
    '"IsMouseClickEnabled", "SetMouseClickEnabled", false',
    '"IsMouseMotionEnabled", "SetMouseMotionEnabled", false',
    'chrome.fade(changes, root)', 'matchesHostScale(routeMap, art)',
    'if closing then live.art:Hide() end', 'restore("taxi-frame-hidden", true)',
    'restore("taxi-map-closed", true)', 'pcall(hide, root)', 'pcall(click, pin, "LeftButton")',
):
    assert token in source, token
assert "hooksecurefunc" not in source
assert "chrome.anchor(changes, root" not in source and '"SetScale"' not in source
assert source.index("if closing then live.art:Hide() end") < source.index("if not chrome.unlocked() then")
assert '"hosted", "routeRequests", "routes"' in (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
assert "P0400_FLIGHT_HOST.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0400 independent host, guarded map adoption, native input and stock restoration: PASS (STATIC)")
