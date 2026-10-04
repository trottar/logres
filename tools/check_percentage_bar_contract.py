#!/usr/bin/env python3
"""Static contract for the approved shared Logres percentage-bar primitive."""

from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
HUD = ROOT / "Logres" / "HUD" / "HUD.lua"
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
TOC = ROOT / "Logres" / "Logres.toc"
ASSETS = {
    ROOT / "Logres" / "Media" / "Bar" / "percentage_diamond.tga":
        "375ce1f4ae723bdaca1d4ae9d3c6688729fa3d66e77d0e62fd2d1d29937ad62d",
    ROOT / "Logres" / "Media" / "Bar" / "percentage_fill.tga":
        "5a54e8d8962debecae6fd116cbebc7bb8dc08b4eed63a750aea157b0f4cedee0",
}

errors = []
hud = HUD.read_text(encoding="utf-8") if HUD.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""

for path, expected in ASSETS.items():
    if not path.is_file():
        errors.append(f"missing percentage-bar asset: {path.relative_to(ROOT)}")
        continue
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(
            f"percentage-bar asset hash mismatch: {path.relative_to(ROOT)} "
            f"expected={expected} actual={actual}"
        )

for fragment in (
    "theme.percentageBar = {",
    "normal = {",
    "compact = {",
    'fill = MEDIA_ROOT .. "Bar\\\\percentage_fill.tga"',
    'diamond = MEDIA_ROOT .. "Bar\\\\percentage_diamond.tga"',
    "targetHealth =",
    "allyHealth =",
):
    if fragment not in theme:
        errors.append(f"Theme.lua missing percentage-bar token: {fragment}")

for fragment in (
    "local function createPercentageBar(parent, name, variant, initialColor)",
    'CreateFrame("StatusBar", nil, frame)',
    "status:SetMinMaxValues(0, 100)",
    "self.resourceBar.status:SetValue(percent)",
    'self.resourceText:SetFormattedText("%.0f%%", percent)',
    "row.healthBar.status:SetValue(percent)",
    'row.healthText:SetFormattedText("%.0f%%", percent)',
    "self.targetHealthBar.status:SetValue(percent)",
    'self.targetHealthText:SetFormattedText("%.0f%%", percent)',
    'UnitPowerType("player")',
    '"UNIT_DISPLAYPOWER"',
    '"LogresHUDResourceBar"',
    '"LogresHUDTargetHealthBar"',
    '"compact"',
):
    if fragment not in hud:
        errors.append(f"HUD.lua missing percentage-bar contract: {fragment}")

for forbidden in (
    "LogresHUDPlayerHealthBar",
    "self.playerHealthBar",
    'UnitHealthPercent("player", true, self.percentScaleCurve)',
    "percent *",
    "percent /",
    "percent +",
    "percent -",
    "if percent",
    "percent <",
    "percent >",
    "percent ==",
    "tostring(percent)",
    "resourceText:GetText",
    "targetHealthText:GetText",
):
    if forbidden in hud:
        errors.append(f"HUD.lua violates percentage-bar secret/player-health boundary: {forbidden}")

if "Media\\Theme.lua" not in toc or "HUD\\HUD.lua" not in toc:
    errors.append("TOC must load Media\\Theme.lua and HUD\\HUD.lua")
else:
    if toc.find("Media\\Theme.lua") > toc.find("HUD\\HUD.lua"):
        errors.append("TOC must load Theme before HUD")

print("Logres shared percentage-bar contract")
print("=====================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
