#!/usr/bin/env python3
"""P0399 centered flight panel and guarded native route selection."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
for token in (
    'pcall(secureHook, root, "SetPoint"', 'chrome.ordinary(point) and point == "TOPLEFT"',
    'session.busy or session.pending', 'pcall(session.plan[1].apply)',
    'session.recenterPending = true', 'recenter(live.root)', 'live.busy = true',
    'Logres.NPCServiceCatalogue.Window', 'readAPI("TaxiNodeGetType", id) == "REACHABLE"',
    'readAPI("TaxiNodeName", route.id) ~= route.name', 'cost ~= route.cost',
    'funds < cost', 'chrome.read(pin, "GetParent") ~= session.routeMap',
    'chrome.read(pin, "GetID") ~= id', 'chrome.read(pin, "IsEnabled") ~= true',
    'session.requested, list.locked = true, true', 'pcall(click, pin, "LeftButton")',
    'view.routes.highlight = point[4]', '"PLAYER_MONEY"',
):
    assert token in source, token
assert source.index('session.requested, list.locked = true, true') < source.index('pcall(click, pin, "LeftButton")')
assert source.count('pcall(click, pin, "LeftButton")') == 1
assert "TakeTaxiNode" not in source and "C_Timer" not in source and "OnUpdate" not in source
assert '"recenters", "routeRequests", "routes"' in (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
assert "P0399_FLIGHT_ROUTE_LIST.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0399 scoped recenter, paginated fares, revalidated native route click and inert preview: PASS (STATIC)")
