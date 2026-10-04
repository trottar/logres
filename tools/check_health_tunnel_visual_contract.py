#!/usr/bin/env python3
"""Static contract for P0124 organic player-health tunnel assets and previews."""

from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
HUD = ROOT / "Logres" / "HUD" / "HUD.lua"
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

ASSETS = {
    "Logres/Media/Health/health_outer.tga":
        "1988d6ad4d3f4989b90a750aa80d2add3aff88738eba13eb038155bdbe60beb3",
    "Logres/Media/Health/health_injury.tga":
        "d3e230df4accc6149fada2307185a43b323a5d1ec6c2d12af8ac708480d04ee8",
    "Logres/Media/Health/health_critical.tga":
        "b4ba397e05d379652968224d6ccb315489d67bbb2111cb94fc6a13ef40ac2fac",
    "Logres/Media/Health/health_near_death.tga":
        "47b0f4ffe97fad786e8081097a84b0ff4f75a6f83a12c6da5663740c21067791",
    "Logres/Media/Health/health_death.tga":
        "54f18019f502f3b75c8518d0a766da25d5f0a2ceeadcfdd34980ab151cf3a940",
}

errors = []

for relative, expected in ASSETS.items():
    path = ROOT / relative
    if not path.is_file():
        errors.append(f"missing health-tunnel asset: {relative}")
        continue

    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(
            f"health-tunnel asset hash mismatch: {relative}: {actual} != {expected}"
        )

hud = HUD.read_text(encoding="utf-8") if HUD.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""

for fragment in (
    "theme.healthTunnel = {",
    'outer = MEDIA_ROOT .. "Health\\\\health_outer.tga"',
    'injury = MEDIA_ROOT .. "Health\\\\health_injury.tga"',
    'critical = MEDIA_ROOT .. "Health\\\\health_critical.tga"',
    'nearDeath = MEDIA_ROOT .. "Health\\\\health_near_death.tga"',
    'death = MEDIA_ROOT .. "Health\\\\health_death.tga"',
):
    if fragment not in theme:
        errors.append(f"Theme.lua missing health-tunnel fragment: {fragment}")

for fragment in (
    "local HEALTH_PREVIEW_PERCENTAGES = {",
    "[100] = true",
    "[80] = true",
    "[70] = true",
    "[60] = true",
    "[50] = true",
    "[40] = true",
    "[30] = true",
    "[20] = true",
    "[15] = true",
    "[5] = true",
    "[0] = true",
    "local function createHealthTunnelTexture(root, band)",
    "texture:SetAllPoints(root)",
    "texture:SetTexture(asset)",
    "texture:SetVertexColor(",
    "local function samplePreviewCurve(points, normalizedPreview)",
    "function HUD:ApplyHealthPreviewPercent(previewPercent)",
    "function HUD:SetHealthPreviewPercent(previewPercent)",
    'UnitHealthPercent("player", true, band.curve)',
    "band.texture:SetAlpha(alpha)",
):
    if fragment not in hud:
        errors.append(f"HUD.lua missing P0124 fragment: {fragment}")

for forbidden in (
    "local function createEdgeTextures",
    "band.textures[textureIndex]:SetAlpha(alpha)",
    "LogresHUDPlayerHealthBar",
    "self.playerHealthBar",
):
    if forbidden in hud:
        errors.append(f"HUD.lua retains forbidden/obsolete P0124 path: {forbidden}")

# Isolate the live path and keep it free of preview calculations / secret inspection.
live_start = hud.find("function HUD:UpdateHealthVignette()")
live_end = hud.find("\nfunction HUD:UpdateResource()", live_start)
if live_start == -1 or live_end == -1:
    errors.append("could not isolate live health-vignette function")
else:
    live = hud[live_start:live_end]
    for forbidden in (
        "samplePreviewCurve",
        "previewPercent",
        "tonumber(",
        "if alpha",
        "alpha <",
        "alpha >",
        "alpha ==",
        "tostring(alpha)",
        "string.format(alpha",
        "alpha *",
        "alpha /",
        "alpha +",
        "alpha -",
    ):
        if forbidden in live:
            errors.append(
                f"live health path inspects/derives secret health or mixes preview state: {forbidden}"
            )

# Preview path must not query live health at all.
preview_start = hud.find("function HUD:ApplyHealthPreviewPercent(previewPercent)")
preview_end = hud.find("\nfunction HUD:UpdateHealthVignette()", preview_start)
if preview_start == -1 or preview_end == -1:
    errors.append("could not isolate health preview path")
else:
    preview = hud[preview_start:preview_end]
    if "UnitHealthPercent" in preview:
        errors.append("preview path must not query live UnitHealthPercent")

for fragment in (
    'Usage: /logres healthpreview [100|80|70|60|50|40|30|20|15|5|0|off]',
    'if command == "healthpreview" then',
    '"healthPreview100"',
    '"healthPreview80"',
    '"healthPreview70"',
    '"healthPreview60"',
    '"healthPreview50"',
    '"healthPreview40"',
    '"healthPreview30"',
    '"healthPreview20"',
    '"healthPreview15"',
    '"healthPreview5"',
    '"healthPreview0"',
    '"healthPreviewLive"',
    '"healthpreview 100"',
    '"healthpreview 80"',
    '"healthpreview 70"',
    '"healthpreview 60"',
    '"healthpreview 50"',
    '"healthpreview 40"',
    '"healthpreview 30"',
    '"healthpreview 20"',
    '"healthpreview 15"',
    '"healthpreview 5"',
    '"healthpreview 0"',
    '"healthpreview off"',
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing health preview integration: {fragment}")

print("Logres P0124 health-tunnel visual contract")
print("==========================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
