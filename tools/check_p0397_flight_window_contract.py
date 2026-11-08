#!/usr/bin/env python3
"""P0397 shared service shell around original Classic taxi controls."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
def read(path):
    return (root / path).read_text(encoding="utf-8")
source = read("Logres/Quest/FlightWindow.lua")
toc = read("Logres/Logres.toc")
assert toc.count(r"Quest\FlightWindow.lua") == 1
assert toc.index(r"Quest\MerchantCatalogue.lua") < toc.index(r"Quest\FlightWindow.lua")
for token in (
    "Logres.NPCServicePresentation", "Logres.PanelSurface.Paint", 'chrome.member(_G, "TaxiFrame")',
    'chrome.member(root, "InsetBg")', 'chrome.member(_G, "TaxiRouteMap")',
    'chrome.read(routeMap, "GetParent") ~= root', 'state.interactionType == 6',
    'chrome.read(root, "IsShown") ~= true', 'chrome.member(systems, "Taxi")',
    'adopt(changes, map, root, host', 'chrome.goodbyeArt(goodbye)',
    'readAPI("TaxiNodeName", id)', 'readAPI("TaxiNodeGetType", index)', 'readAPI("TaxiNodeCost", index)',
    '"TAXIMAP_OPENED"', '"TAXIMAP_CLOSED"', '"PLAYER_REGEN_ENABLED"',
    'pcall(live.plan[i].undo)', 'restore("stock-requested")', 'Flight.Preview()',
):
    assert token in source, token
for forbidden in ("TakeTaxiNode", "CloseTaxiMap", "ShowTaxiMapFrame", ":Click(", "SetParent(", "C_Timer", "OnUpdate"):
    assert forbidden not in source, forbidden
live = source.split("local function buildPreview()", 1)[0]
assert 'root:SetScript(' not in live and 'pin:SetScript(' not in live
assert 'pcall(click, pin, "LeftButton")' in live
assert "incident.snapshot.flight = pickTraceStatus" in read("Logres/Dev/Panel.lua")
assert "P0397_FLIGHT_WINDOW.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0397 Classic taxi, native payment/input, shared styling and fail-open flight restoration: PASS (STATIC)")
