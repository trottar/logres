#!/usr/bin/env python3
# Static contract for P0155 camera stop-before-reverse behavior.
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
            errors.append(f"WorldCombat.lua missing P0155 direction-switch fragment: {fragment}")

    forbidden = [
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
        "SetCVar(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"WorldCombat.lua P0155 forbids: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "switches=%s",
        "tostring(status.transitionDirectionSwitchCount)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing P0155 diagnostic fragment: {fragment}")

print("Logres P0155 camera direction-switch contract")
print("=============================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
