#!/usr/bin/env python3
"""P0401 recover prior flight presentation and label read-only host capture gates."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/FlightWindow.lua").read_text(encoding="utf-8")
probe = source.split("local function propertyGate(", 1)[1].split("local function apply(", 1)[0]
for token in (
    'local function adoptionGate', 'local function childGate', 'local function probeHost',
    'local recoveryArt = frames[root] and frames[root].art', 'child ~= recoveryArt',
    'return "extra-child-click"', 'return "extra-child-descendants"',
    'prefix .. "-anchor-capture"', 'prefix .. "-size-capture"',
    'chrome.anchor({}, child', 'chrome.resize({}, child',
    'propertyGate(routeMap, "GetFrameStrata"', 'mouseGate(close, "close-mouse")',
    'or "capture-passed"',
):
    assert token in probe, token
assert '.apply' not in probe and '.undo' not in probe and 'SetScript' not in probe
assert 'pcall(probeHost, root, map, routeMap)' in source
assert source.index('hostGate = probed and gate or "probe-error"') < source.index('pcall(capture, root, map)')
assert 'setParent(' not in source and 'hooksecurefunc' not in source
for token in ('Logres.NPCServicePresentation', 'Logres.NPCServiceCatalogue.Window',
              'pcall(click, pin, "LeftButton")', 'normalizeScale(changes, root)'):
    assert token in source, token
assert '"hostGate", "hostChildren", "hostChild"' in (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
assert "P0401_FLIGHT_RECOVERY.md" in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0401 independent capture diagnosis, shared layout recovery and existing route guards: PASS (STATIC)")
