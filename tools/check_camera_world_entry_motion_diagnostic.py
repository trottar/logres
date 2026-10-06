#!/usr/bin/env python3
"""Static contract for P0154 world-entry camera motion diagnostics."""
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
        "local function transitionExpectedZoom(",
        "self.transitionSampleCount = 0",
        "self.transitionTowardCount = 0",
        "self.transitionAwayCount = 0",
        "self.transitionFlatCount = 0",
        "self.transitionMinZoom = currentZoom",
        "self.transitionMaxZoom = currentZoom",
        "self.transitionPreviousZoom = currentZoom",
        "self.transitionInCommandCount = 0",
        "self.transitionOutCommandCount = 0",
        "self.transitionMaxAbsPositionError = 0",
        "self.lastCommandDirection = direction",
        "self.lastCommandFactor = factor",
        "self.transitionAwayCount = self.transitionAwayCount + 1",
        "self.lastExpectedZoom = expectedZoom",
        "self.lastPositionError = positionError",
        "transitionSampleCount = self.transitionSampleCount",
        "transitionAwayCount = self.transitionAwayCount",
        "transitionMaxAbsPositionError = self.transitionMaxAbsPositionError",
        "transitionInCommandCount = self.transitionInCommandCount",
        "transitionOutCommandCount = self.transitionOutCommandCount",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing P0154 diagnostic fragment: {fragment}")

    forbidden = [
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
        "SetCVar(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"WorldCombat.lua P0154 diagnostic forbids: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local function emitCameraWorldCombatMotion(status)",
        '"Logres cameraworldcombat motion: samples=%s toward=%s away=%s flat=%s min=%s max=%s expected=%s posError=%s maxAbsPosError=%s observed=%s/%s command=%s/%s inCommands=%s outCommands=%s"',
        "emitCameraWorldCombatMotion(status)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing P0154 diagnostic fragment: {fragment}")

print("Logres P0154 world-entry camera motion diagnostic contract")
print("========================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
