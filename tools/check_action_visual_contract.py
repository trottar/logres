#!/usr/bin/env python3
from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
BUTTON = ROOT / "Logres" / "Actions" / "Button.lua"
TOC = ROOT / "Logres" / "Logres.toc"
ACTION_DIR = ROOT / "Logres" / "Media" / "Action"

EXPECTED = {'action_hover.tga': '138e5618d562bc844939059148fc5f474a7895ab65bd10864e1176f82274b5b5', 'action_pressed.tga': 'ba5e9beb0d1a9aa3e583e8f6beb35ebfe1fd208a23d31350a736a06cbe54e929', 'action_flash.tga': 'd46219de5bd4014af6d734cf4baad943e9765d99af5446fef0fb9fc499e43cb3', 'action_frame.tga': 'c6bdf768435e6e4adc2a50302f727676b1d3042866359adb34039f961dd32f55', 'action_checked.tga': '0bfc4a317cc5a1ab344808f8f219d16706ef2d631f1e0a96671bc7974d82e88a'}

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
        "buttonSize = 42",
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
