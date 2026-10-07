#!/usr/bin/env python3
"""Static contract for stop-before-reverse behavior retained by P0160 R2."""

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
        "local function stopMotionDirection(direction)",
        'if direction == "in" then',
        "startFunc = MoveViewInStart",
        "stopFunc = MoveViewInStop",
        'elseif direction == "out" then',
        "startFunc = MoveViewOutStart",
        "stopFunc = MoveViewOutStop",
        "pcall(startFunc, 0)",
        "pcall(stopFunc)",
        "local previousDirection = self.transitionDirection",
        "previousDirection ~= nil and previousDirection ~= direction",
        "stopMotionDirection(previousDirection)",
        '"direction-switch-stop-failed"',
        "self.transitionDirectionSwitchCount =",
        "self.transitionDirectionSwitchCount + 1",
        "transitionDirectionSwitchCount = self.transitionDirectionSwitchCount",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing direction-switch fragment: {fragment}")

    forbidden = [
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"WorldCombat.lua direction-switch regression: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in [
        "switches=%s",
        "tostring(status.transitionDirectionSwitchCount)",
    ]:
        if fragment not in source:
            errors.append(f"Commands.lua missing direction-switch diagnostic: {fragment}")

print("Logres camera direction-switch contract")
print("=======================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
