#!/usr/bin/env python3
"""P0402 bounded scalar taxi child inventory, independent of presentation."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
panel = (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
inventory = source.split("local function frameLabel(", 1)[1].split("local function childGate(", 1)[0]
assert "local MAX_INVENTORY_CHILDREN = 32" in source
for token in (
    'not chrome.ordinary(child)', 'not chrome.mutable(child)', 'frameLabel(child)',
    'chrome.read(child, "IsMouseClickEnabled")', 'chrome.read(child, "IsMouseMotionEnabled")',
    'chrome.read(child, "GetNumChildren")', '"inert-leaf"', '"descendants-unchecked"',
    'child ~= recoveryArt', 'hostInventoryStatus = "limit"', 'rows, "complete"',
):
    assert token in inventory, token
assert inventory.index("not chrome.mutable(child)") < inventory.index("frameLabel(child)")
assert "SetPoint" not in inventory and "SetParent" not in inventory and ":Set" not in inventory
assert "inventoryChildren(children, recoveryArt, routeMap, close)" in source
assert '#native > 8 then return "children-count"' in source
assert "math.min(#flightChildren, 32)" in panel
assert 'incident.snapshot.flight.children = copy' in panel
assert 'pickTraceStatus(flightChildren[index]' in panel
assert "P0402_FLIGHT_CHILD_INVENTORY.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0402 bounded read-only flight child inventory and unchanged capture gate: PASS (STATIC)")
