#!/usr/bin/env python3
"""Static contract for P0160 R2 source-backed LibCamera zoom behavior."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
errors = []

if not CONTROLLER.is_file():
    errors.append("missing Logres/Camera/WorldCombat.lua")
else:
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        'local LIBCAMERA_SOURCE_COMMIT =',
        '"c0b23135a0b24fbca24b41cb53dd7afc9114e352"',
        "local LIBCAMERA_MAX_POS_ERROR = 0.5",
        "local LIBCAMERA_REBASE_PRECISION = 0.005",
        "local LIBCAMERA_REBASE_MAX_ITERATIONS = 100",
        "local LIBCAMERA_CORRECTION_DURATION = 0.1",
        "local LIBCAMERA_CORRECTION_TOLERANCE = 0.05",
        "local function easeInOutQuad(",
        "local function getEaseVelocity(",
        "local function rebaseEaseTime(",
        "duration / 12",
        "iterations < LIBCAMERA_REBASE_MAX_ITERATIONS",
        "self.transitionSampleCount > 1",
        "absoluteError",
        "> LIBCAMERA_MAX_POS_ERROR",
        "LIBCAMERA_REBASE_PRECISION",
        "self.transitionStartTime =",
        "self.transitionStartTime",
        "- elapsedDifference",
        "function Controller:BeginSourceCorrection(",
        "function Controller:ServiceSourceCorrection(",
        'pcall(SetCVar, "cameraZoomSpeed", value)',
        "CameraZoomIn",
        "CameraZoomOut",
        "self:RestoreSourceCorrectionZoomSpeed()",
        "function Controller:ApplyTransitionMotion(currentZoom, elapsed)",
        "getEaseVelocity(",
        "(requestedTargetZoom - currentZoom)",
        "/ NOMINAL_FRAME_INTERVAL",
        "local function stopMotionDirection(direction)",
        "previousDirection ~= nil and previousDirection ~= direction",
        "stopMotionDirection(previousDirection)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"missing source-backed transition contract: {fragment}")

    forbidden = [
        "local function boundedVelocity(",
        "local function transitionVelocity(",
        "TRANSITION_TIMEOUT_EXTRA",
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"source-backed transition regression: {fragment}")

print("Logres source-backed LibCamera zoom contract")
print("==========================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
