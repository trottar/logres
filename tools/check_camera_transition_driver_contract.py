#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
errors = []

if not CONTROLLER.is_file():
    errors.append("missing Logres/Camera/WorldCombat.lua")
else:
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        "local NOMINAL_FRAME_INTERVAL = 1 / 60",
        "local function boundedVelocity(",
        "local function transitionVelocity(",
        "local crossedTarget =",
        "(targetZoom - currentZoom) / NOMINAL_FRAME_INTERVAL",
        "function Controller:ApplyTransitionMotion(currentZoom, elapsed)",
        "self:ApplyTransitionMotion(currentZoom, elapsed)",
        "local function stopMotionDirection(direction)",
        "previousDirection ~= nil and previousDirection ~= direction",
        "stopMotionDirection(previousDirection)",
        "self.transitionDirection = direction",
        "self.transitionStartTime = now",
        "self.transitionStartZoom = currentZoom",
        "elapsed >= (self.transitionDuration + timeoutExtra)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"missing transition-driver contract: {fragment}")

    forbidden = [
        "local desiredUnitsPerSecond =",
        "math.abs(delta) / transitionDuration",
        "CameraZoomIn(",
        "CameraZoomOut(",
        "SetCVar(",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"transition-driver regression: {fragment}")

print("Logres shared camera transition driver contract")
print("==============================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
