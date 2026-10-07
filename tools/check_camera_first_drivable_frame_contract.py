#!/usr/bin/env python3
"""Static contract for first-drivable-frame camera transition timing."""

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
        "self.transitionArmZoom = currentZoom",
        "self.transitionArmTime = GetTime()",
        "self.transitionStartTime = nil",
        "self.transitionFirstUpdateDelay = nil",
        "local now = GetTime()",
        "if self.transitionStartTime == nil then",
        "self.transitionFirstUpdateDelay =",
        "now - self.transitionArmTime",
        "self.transitionStartTime = now",
        "self.transitionStartZoom = currentZoom",
        "self.transitionMinZoom = currentZoom",
        "self.transitionMaxZoom = currentZoom",
        "self.transitionPreviousZoom = currentZoom",
        "local elapsed = now - self.transitionStartTime",
        "transitionArmZoom = self.transitionArmZoom",
        "transitionFirstUpdateDelay = self.transitionFirstUpdateDelay",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing first-frame fragment: {fragment}")

    forbidden = [
        "self.transitionStartTime = GetTime()",
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"WorldCombat.lua first-frame regression: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in [
        "armZoom=%s firstDelay=%s",
        "tostring(status.transitionArmZoom)",
        "tostring(status.transitionFirstUpdateDelay)",
    ]:
        if fragment not in source:
            errors.append(f"Commands.lua missing first-frame diagnostic: {fragment}")

print("Logres first-drivable-frame camera contract")
print("===========================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
