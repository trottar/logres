#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BUTTON = ROOT / "Logres" / "Actions" / "Button.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
errors = []

for path in (BUTTON, COMMANDS):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if BUTTON.is_file():
    source = BUTTON.read_text(encoding="utf-8")
    required = [
        'CreateFrame("Frame", nil, UIParent)',
        "feedbackFrame:SetAllPoints(button)",
        'feedbackFrame:SetFrameStrata("HIGH")',
        "feedbackFrame:EnableMouse(false)",
        "pressedOverlay:Hide()",
        "activationFlash:SetAlpha(1)",
        "activationFlash:Hide()",
        "activationFade:SetFromAlpha(1)",
        "activationFade:SetToAlpha(0)",
        "activationFade:SetDuration(0.24)",
        'button:HookScript("OnMouseDown"',
        'button:HookScript("OnMouseUp"',
        'button:HookScript("OnLeave"',
        'button:HookScript("PostClick"',
        "function ActionButton.Pulse(button)",
        "flash:SetAlpha(1)",
        "flash:Show()",
        "animation:Play()",
        "activationFeedbackFrame",
        "activationPressedOverlay",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Button.lua missing feedback path: {fragment}")
    for fragment in ("activationFlash:SetAlpha(0)", 'button:SetScript("PostClick"'):
        if fragment in source:
            errors.append(f"Button.lua retains failed P0040 path: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local function runActionFeedbackTest()",
        "Logres.ActionButton.Pulse(primary.buttons[1])",
        "Logres.ActionButton.Pulse(sides.clusters.secondary.buttons[1])",
        "Logres.ActionButton.Pulse(sides.clusters.utility.buttons[1])",
        'if command == "actionfeedback" then',
        '"Feedback Test"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing feedback diagnostic: {fragment}")

print("Logres action feedback contract")
print("===============================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
