#!/usr/bin/env python3
"""Static contract checks for production Taxi zoom parity."""

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
        "local TAXI_TARGET = 50",
        "local TAXI_TRANSITION_DURATION = 5",
        "local CAMERA_DISTANCE_SCALE = 15",
        "local function readCameraDistanceFactor()",
        'return "taxi", "taxi", false',
        "return TAXI_TARGET",
        "effectiveTargetZoom = math.min(",
        "requestedTargetZoom,",
        "cameraDistanceCeiling",
        "transitionDurationForContext(",
        "self.transitionRequestedZoom = requestedTargetZoom",
        "self.transitionEffectiveTargetZoom = effectiveTargetZoom",
        "self.lastCameraDistanceFactor = cameraDistanceFactor",
        "self.lastCameraDistanceCeiling = cameraDistanceCeiling",
        "lastCameraDistanceFactor = self.lastCameraDistanceFactor",
        "lastCameraDistanceCeiling = self.lastCameraDistanceCeiling",
        "transitionRequestedZoom = self.transitionRequestedZoom",
        "transitionEffectiveTargetZoom = self.transitionEffectiveTargetZoom",
        "transitionDuration = self.transitionDuration",
        "local requestedTargetZoom =",
        "self.transitionRequestedZoom",
        "contextAllowsLimitedTarget(",
        '"transition-complete-limited"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/WorldCombat.lua missing Taxi contract: {fragment}")

    order = [
        "if state.onTaxi then",
        "if snapshot.teleport then",
        "if snapshot.afk then",
        "if snapshot.gathering then",
        "if snapshot.interaction then",
        "if not state.inInstance and liveCombat then",
        "if snapshot.fishing then",
        "if state.resting then",
        "if state.inInstance then",
    ]
    positions = [source.find(fragment) for fragment in order]
    if min(positions) == -1:
        errors.append("could not locate captured-profile precedence chain")
    elif positions != sorted(positions):
        errors.append("captured-profile precedence chain is out of order")

    forbidden = [
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        'Logres:RegisterEvent("PLAYER_CONTROL_LOST"',
        'Logres:RegisterEvent("PLAYER_CONTROL_GAINED"',
        "FadeOutUI",
        "UIParent",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Taxi production scope violation: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in [
        'status.selectedContext == "taxi"',
        'status.transitionContext == "taxi"',
        "requested=%s",
        "effective=%s",
        "duration=%s",
        "maxFactor=%s",
        "maxCeiling=%s",
        "tostring(status.transitionRequestedZoom)",
        "tostring(status.transitionEffectiveTargetZoom)",
        "tostring(status.transitionDuration)",
        "tostring(status.lastCameraDistanceFactor)",
        "tostring(status.lastCameraDistanceCeiling)",
    ]:
        if fragment not in source:
            errors.append(f"Commands.lua missing Taxi diagnostic: {fragment}")

print("Logres production Taxi zoom contract")
print("===================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
