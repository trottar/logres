#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
BUTTON = ROOT / "Logres" / "Actions" / "Button.lua"
TOC = ROOT / "Logres" / "Logres.toc"
ACTION_DIR = ROOT / "Logres" / "Media" / "Action"

EXPECTED = {'action_hover.tga': 'e82fa599975ae30e7d903fe291d12735adac37ab084d89d2da6b28f6b1c63467', 'action_pressed.tga': 'a22ab9563733c8d238274150973e407569ca997b5778ef7506d15ce8a55d14c9', 'action_flash.tga': '02dcff00105ea42df4505bdbed154ce4b6933cca1db7557bbdec2f071a50b779', 'action_frame.tga': '2378b8a9785f48de8159977768e2c306ffd4cfdf4d6a4994a04f6394c2de1289', 'action_checked.tga': 'fe619646cb543062344d9f78935a1456f773e61a1c7ebaa1a68e3d97537377c7'}

errors = []

for path in (THEME, BUTTON, TOC, ACTION_DIR):
    if not path.exists():
        errors.append(f"missing required path: {path.relative_to(ROOT)}")

for name, expected in EXPECTED.items():
    path = ACTION_DIR / name
    if not path.is_file():
        errors.append(f"missing action visual asset: {path.relative_to(ROOT)}")
        continue
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(
            f"action visual asset hash mismatch: {path.relative_to(ROOT)} "
            f"expected={expected} actual={actual}"
        )

if THEME.is_file():
    source = THEME.read_text(encoding="utf-8")
    required = [
        'local MEDIA_ROOT = "Interface\\\\AddOns\\\\Logres\\\\Media\\\\"',
        "theme.action = {",
        "buttonSize = 38",
        "buttonGap = 5",
        "iconInset = 4",
        "artOverscan = 2",
        '"Action\\\\action_frame.tga"',
        '"Action\\\\action_hover.tga"',
        '"Action\\\\action_pressed.tga"',
        '"Action\\\\action_checked.tga"',
        '"Action\\\\action_flash.tga"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Theme.lua missing action token: {fragment}")

if BUTTON.is_file():
    source = BUTTON.read_text(encoding="utf-8")
    required = [
        "local actionStyle =",
        "Logres.Theme.action",
        "local actionAssets = actionStyle.assets or {}",
        "setActionArtBounds(frameArt, button)",
        "frameArt:SetTexture(actionAssets.frame)",
        "hoverTexture:SetTexture(actionAssets.hover)",
        "pushedTexture:SetTexture(actionAssets.pressed)",
        "checked:SetTexture(actionAssets.checked)",
        "pressedOverlay:SetTexture(actionAssets.pressed)",
        "activationFlash:SetTexture(actionAssets.flash)",
        "button.actionVisualReady = true",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Button.lua missing production visual path: {fragment}")
    if "UI-Quickslot-Depress" in source:
        errors.append("Button.lua still uses stock UI-Quickslot-Depress art")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    theme_index = source.find("Media\\Theme.lua")
    button_index = source.find("Actions\\Button.lua")
    if theme_index == -1:
        errors.append("Logres.toc missing Media\\Theme.lua")
    if button_index == -1:
        errors.append("Logres.toc missing Actions\\Button.lua")
    if theme_index != -1 and button_index != -1 and theme_index > button_index:
        errors.append("Media\\Theme.lua must load before Actions\\Button.lua")

print("Logres action visual asset contract")
print("===================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
