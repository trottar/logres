#!/usr/bin/env python3
# Static contract checks for G.5 production Taxi zoom parity.

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
        "requestedTargetZoom = TAXI_TARGET",
        "effectiveTargetZoom = math.min(",
        "requestedTargetZoom,",
        "cameraDistanceCeiling",
        "transitionDurationForContext(context)",
        'context == "taxi" and currentZoom < requestedTargetZoom',
        "self.transitionRequestedZoom = requestedTargetZoom",
        "self.transitionEffectiveTargetZoom = effectiveTargetZoom",
        "self.lastCameraDistanceFactor = cameraDistanceFactor",
        "self.lastCameraDistanceCeiling = cameraDistanceCeiling",
        "lastCameraDistanceFactor = self.lastCameraDistanceFactor",
        "lastCameraDistanceCeiling = self.lastCameraDistanceCeiling",
        "transitionRequestedZoom = self.transitionRequestedZoom",
        "transitionEffectiveTargetZoom = self.transitionEffectiveTargetZoom",
        "transitionDuration = self.transitionDuration",
        "local requestedTargetZoom = self.transitionRequestedZoom",
        'transitionContext ~= "taxi"',
        '"transition-complete-limited"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/WorldCombat.lua missing Taxi contract: {fragment}")

    instance_index = source.find("if state.inInstance then")
    taxi_index = source.find("if state.onTaxi then")
    interaction_index = source.find("if state.interacting then")
    combat_index = source.find("if liveCombat then")
    city_index = source.find("if state.resting then")
    if min(instance_index, taxi_index, interaction_index, combat_index, city_index) == -1:
        errors.append("could not locate Taxi precedence chain")
    elif not (instance_index < taxi_index < interaction_index < combat_index < city_index):
        errors.append(
            "Taxi precedence must be instance boundary -> Taxi -> interaction -> combat -> City"
        )

    forbidden = [
        "SetCVar(",
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
    required = [
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
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing Taxi diagnostic contract: {fragment}")

print("Logres G.5 production Taxi zoom contract")
print("========================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
