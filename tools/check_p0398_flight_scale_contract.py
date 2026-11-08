#!/usr/bin/env python3
"""P0398 scale the supported taxi layout in UIParent units."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
for token in (
    'chrome.read(root, "GetParent") ~= UIParent',
    'chrome.method(root, "GetScale"), chrome.method(root, "SetScale")',
    'local ok, stockScale = pcall(get, root)',
    'apply = function() set(root, 1) end',
    'undo = function() set(root, stockScale) end',
    'or not normalizeScale(changes, root)',
    'chrome.read(root, "GetEffectiveScale")',
    'chrome.read(UIParent, "GetEffectiveScale")',
    'math.abs(actual - expected) < 0.001',
    'restore("stock-scale-mismatch")',
    'labels:SetFrameLevel(level + 2)',
    'labels:EnableMouse(false)',
    'art.view = paint(art, false, labels)',
    'wash(root, mapX - 1, mapY - 1',
):
    assert token in source, token
assert source.index("if not matchesParentScale(root)") < source.index("if not pcall(art.Show, art)")
assert source.count("stockScale") == 2
assert "TakeTaxiNode" not in source and "C_Timer" not in source and "OnUpdate" not in source
assert '"scaleMatched"' in (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
assert "P0398_FLIGHT_SCALE.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0398 parent-scale verification, opaque restore and mouse-inert sidebar layering: PASS (STATIC)")
