#!/usr/bin/env python3
# Static contract checks for G.4 City camera ownership.

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

errors = []

for path in (CONTROLLER, COMMANDS):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        'local CITY_TARGET = 5',
        'self.lastResting = false',
        'self.lastResting = state.resting == true',
        'return "city", "resting-city", false',
        'elseif context == "city" then',
        'requestedTargetZoom = CITY_TARGET',
        'context == "city" and currentZoom > CITY_TARGET',
        'lastResting = self.lastResting',
        'self:SubscribeState(function(',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/WorldCombat.lua missing G.4 City contract: {fragment}")

    combat_index = source.find('if liveCombat then')
    city_index = source.find('if state.resting then')
    if combat_index == -1 or city_index == -1:
        errors.append("could not locate live-combat / resting context ordering")
    elif combat_index > city_index:
        errors.append("live combat must be evaluated before resting/City")

    forbidden = [
        'Logres:RegisterEvent("PLAYER_UPDATE_RESTING"',
        'SetCVar(',
        'FadeOutUI',
        'UIParent',
        'ReactiveZoom',
        'C_Timer.NewTicker',
        'C_Timer.NewTimer',
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Camera/WorldCombat.lua G.4 scope violation: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        'status.selectedContext == "city"',
        'status.transitionContext == "city"',
        'resting=%s',
        'tostring(status.lastResting)',
        'runCameraWorldCombatCheck()',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing City-aware diagnostic contract: {fragment}")

print("Logres G.4 City camera ownership contract")
print("========================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
