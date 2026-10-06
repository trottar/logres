#!/usr/bin/env python3
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
        "self.transitionFirstUpdateDelay = now - self.transitionArmTime",
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
            errors.append(f"WorldCombat.lua missing P0156 first-frame fragment: {fragment}")

    forbidden = [
        "self.transitionStartTime = GetTime()",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
        "SetCVar(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"WorldCombat.lua P0156 forbids: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "armZoom=%s firstDelay=%s",
        "tostring(status.transitionArmZoom)",
        "tostring(status.transitionFirstUpdateDelay)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing P0156 diagnostic fragment: {fragment}")

print("Logres P0156 first-drivable-frame camera contract")
print("=================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
