#!/usr/bin/env python3
"""Static contract for camera motion diagnostics after P0160 R2."""

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
        "self.transitionDirectionSwitchCount = 0",
        "self.transitionMaxAbsPositionError = 0",
        "self.transitionRebaseCount = 0",
        "self.transitionRebaseIterationCount = 0",
        "self.transitionCorrectionCount = 0",
        "self.lastCommandDirection = direction",
        "self.lastCommandFactor = factor",
        "self.transitionAwayCount =",
        "self.transitionAwayCount + 1",
        "self.lastExpectedZoom = expectedZoom",
        "self.lastPositionError = positionError",
        "transitionSampleCount = self.transitionSampleCount",
        "transitionAwayCount = self.transitionAwayCount",
        "transitionMaxAbsPositionError = self.transitionMaxAbsPositionError",
        "transitionInCommandCount = self.transitionInCommandCount",
        "transitionOutCommandCount = self.transitionOutCommandCount",
        "transitionDirectionSwitchCount = self.transitionDirectionSwitchCount",
        "transitionRebaseCount = self.transitionRebaseCount",
        "transitionRebaseIterationCount = self.transitionRebaseIterationCount",
        "transitionCorrectionCount = self.transitionCorrectionCount",
        "transitionCorrectionActive = self.transitionCorrectionActive",
        "transitionArmZoom = self.transitionArmZoom",
        "transitionFirstUpdateDelay = self.transitionFirstUpdateDelay",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing motion diagnostic fragment: {fragment}")

    forbidden = [
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"WorldCombat.lua motion diagnostic regression: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local function emitCameraWorldCombatMotion(status)",
        "rebases=%s",
        "rebaseIters=%s",
        "corrections=%s",
        "correctionActive=%s",
        "correctionSpeed=%s",
        "rebase=%s->%s",
        "tostring(status.transitionRebaseCount)",
        "tostring(status.transitionRebaseIterationCount)",
        "tostring(status.transitionCorrectionCount)",
        "tostring(status.transitionCorrectionActive)",
        "tostring(status.lastCorrectionZoomSpeed)",
        "tostring(status.lastRebaseFromElapsed)",
        "tostring(status.lastRebaseToElapsed)",
        "emitCameraWorldCombatMotion(status)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing motion diagnostic fragment: {fragment}")

print("Logres camera motion diagnostic contract")
print("=======================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
