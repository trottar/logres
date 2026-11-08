#!/usr/bin/env python3
"""P0404: guarded native map inputs share the centered service shell."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
def read(path):
    return (root / path).read_text(encoding="utf-8")

flight = read("Logres/Quest/FlightWindow.lua")
host = flight.split("local host = {}", 1)[1].split("local hostResult", 1)[0]
assert 'art:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)' in flight
assert 'return buildShell(false' in flight and 'local root = buildShell(true' in flight
assert 'restore("taxi-frame-hidden", true)' in flight
assert 'if closing and live.centered then live.art:Hide() end' in flight
assert flight.index('pcall(host.Capture') < flight.index('if not restore(failure)') < flight.index('pcall(capture, root, map)')
assert 'host.IsPin(pin, session.routeMap, id) or host.IsPin(pin, session.root, id)' in flight
for token in (
    'for _, parent in ipairs({root, routeMap}) do',
    'chrome.member(_G, "TaxiButton" .. id) == pin',
    'chrome.read(pin, "GetID") == id',
    'chrome.read(child, "GetNumChildren") ~= 0',
    'if not found[id] then return nil end',
    'adopt(plan, pin.frame, pin.parent, routeMap, strata, level + 2)',
    'quietMouse(plan, root) or not quietMouse(plan, close) or not chrome.fade(plan, root)',
    'undo = function() set(frame, original) end',
):
    assert token in host, token

assert host.index("adopt(plan, pin.frame") < host.index("if not quietMouse(plan, root)")
assert 'GetPoint' not in host and 'SetScript' not in host
for token in ("OnUpdate", "C_Timer", "TakeTaxiNode", "hooksecurefunc"):
    assert token not in host and token not in flight
assert '"hostResult", "centered"' in read("Logres/Dev/Panel.lua")
assert "P0404_CENTERED_FLIGHT_MASTER.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0404 exact native pin adoption, source guards, shared center shell and recovery: PASS (STATIC)")
