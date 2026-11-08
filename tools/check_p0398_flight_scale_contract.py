#!/usr/bin/env python3
"""P0398 scale the supported taxi layout in UIParent units."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
for token in (
    'chrome.read(root, "GetParent") ~= UIParent',
    'art:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)',
    'chrome.read(routeMap, "GetEffectiveScale")',
    'chrome.read(host, "GetEffectiveScale")',
    'math.abs(actual - expected) < 0.001',
    'restore("stock-scale-mismatch")',
    'art:EnableMouse(false)',
    'art.view = paint(art, false)',
    'wash(root, mapX - 1, mapY - 1',
):
    assert token in source, token
assert source.index("if not matchesHostScale(routeMap, art)") < source.index("if not pcall(art.Show, art)")
assert '"SetScale"' not in source
assert "TakeTaxiNode" not in source and "C_Timer" not in source and "OnUpdate" not in source
assert '"scaleMatched"' in (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
assert "P0398_FLIGHT_SCALE.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0398 parent-scale verification, opaque restore and mouse-inert sidebar layering: PASS (STATIC)")
