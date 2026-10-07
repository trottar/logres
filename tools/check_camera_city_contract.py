#!/usr/bin/env python3
"""Static contract checks for City camera ownership."""

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
        "local CITY_TARGET = 5",
        "self.lastResting = false",
        "self.lastResting = state.resting == true",
        'return "city", "resting-city", false',
        'if context == "city" then',
        "return CITY_TARGET",
        "lastResting = self.lastResting",
        "self:SubscribeState(function(",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/WorldCombat.lua missing City contract: {fragment}")

    combat_index = source.find("if not state.inInstance and liveCombat then")
    city_index = source.find("if state.resting then")
    if combat_index == -1 or city_index == -1:
        errors.append("could not locate live-combat / resting context ordering")
    elif combat_index > city_index:
        errors.append("live combat must be evaluated before resting/City")

    # Reactive zoom is now a generic P0162 camera-ownership capability and is
    # separately covered by check_camera_reactive_zoom_contract.py. City still
    # may not add presentation, timers, or direct max-distance ownership here.
    forbidden = [
        'Logres:RegisterEvent("PLAYER_UPDATE_RESTING"',
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "FadeOutUI",
        "UIParent",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Camera/WorldCombat.lua City scope violation: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in [
        'status.selectedContext == "city"',
        'status.transitionContext == "city"',
        "resting=%s",
        "tostring(status.lastResting)",
        "runCameraWorldCombatCheck()",
    ]:
        if fragment not in source:
            errors.append(f"Commands.lua missing City diagnostic: {fragment}")

print("Logres City camera ownership contract")
print("====================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
