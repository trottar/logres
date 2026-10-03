#!/usr/bin/env python3
# Static contract for the Logres P0118 action keybind metadata plate.
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
BUTTON = ROOT / "Logres" / "Actions" / "Button.lua"
PRIMARY = ROOT / "Logres" / "Actions" / "Primary.lua"
SIDE = ROOT / "Logres" / "Actions" / "SecondaryUtility.lua"
errors = []

for path in (THEME, BUTTON, PRIMARY, SIDE):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if THEME.is_file():
    source = THEME.read_text(encoding="utf-8")
    for fragment in (
        "hotkeyPlate = {",
        "buttonSize = 42",
        "minWidth = 16",
        "height = 15",
        "horizontalPadding = 4",
        "borderColor =",
        "fillColor = { 0.00, 0.00, 0.00, 0.98 }",
        "textColor =",
    ):
        if fragment not in source:
            errors.append(f"Theme.lua missing hotkey plate token: {fragment}")

if BUTTON.is_file():
    source = BUTTON.read_text(encoding="utf-8")
    for fragment in (
        "local hotkeyStyle = actionStyle.hotkeyPlate or {}",
        "local hotkeyPlateBorder = feedbackFrame:CreateTexture",
        "local hotkeyPlateFill = feedbackFrame:CreateTexture",
        "local function normalizeHotkeyLabel(label)",
        'text = text:gsub("SHIFT%-", "s-")',
        'text = text:gsub("CTRL%-", "c-")',
        'text = text:gsub("ALT%-", "a-")',
        "local hotkeyText = feedbackFrame:CreateFontString",
        "function ActionButton.SetHotkeyLabel(button, label)",
        "button.hotkeyText:GetStringWidth()",
        "button.hotkeyPlateBorder:SetWidth(plateWidth)",
        "button.hotkeyPlateBorder:Hide()",
        "button.hotkeyPlateBorder:Show()",
        "button.hotkeyPlateReady = true",
        'countText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -3, 3)',
    ):
        if fragment not in source:
            errors.append(f"Button.lua missing keybind plate contract: {fragment}")

for path in (PRIMARY, SIDE):
    if path.is_file():
        source = path.read_text(encoding="utf-8")
        if 'ActionButton.SetHotkeyLabel(button, keys[1] or "")' not in source:
            errors.append(f"{path.name} does not route labels through SetHotkeyLabel")
        if 'button.hotkeyText:SetText(keys[1] or "")' in source:
            errors.append(f"{path.name} still bypasses the metadata plate helper")

if PRIMARY.is_file():
    source = PRIMARY.read_text(encoding="utf-8")
    if "self.bindingRoutingEnabled = false" not in source:
        errors.append("Primary routing fail-open default changed")

print("Logres action keybind polish contract")
print("============================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
