#!/usr/bin/env python3
"""Static checks for the Logres Phase B HUD health-vignette boundary."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
HUD = ADDON / "HUD" / "HUD.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"

errors = []

hud = HUD.read_text(encoding="utf-8") if HUD.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""

required_hud_fragments = [
    'Logres:RegisterModule("HUD"',
    "C_CurveUtil.CreateCurve()",
    "curve:SetType(Enum.LuaCurveType.Linear)",
    'UnitHealthPercent("player", true, band.curve)',
    "band.textures[textureIndex]:SetAlpha(alpha)",
    "function HUD:UpdateHealthVignette()",
    "function HUD:ApplyImmersionPreference(preferences)",
    "function HUD:SetPreviewEnabled(enabled)",
    "function HUD:ApplyPreview()",
    "function HUD:UpdateResource()",
    'UnitPowerPercent(',
    'self.resourceText:SetFormattedText("%.0f%%", percent)',
    '"UNIT_POWER_FREQUENT"',
    '"UNIT_MAXPOWER"',
    "self:SubscribePreferences(function(current)",
    'RegisterUnitEvent("UNIT_HEALTH", "player")',
    'RegisterUnitEvent("UNIT_MAXHEALTH", "player")',
]

for fragment in required_hud_fragments:
    if fragment not in hud:
        errors.append(f"HUD.lua missing B.1 contract fragment: {fragment}")

for forbidden in [
    'UnitHealth("player"',
    'UnitHealthMax("player"',
    'UnitPower("player"',
    'UnitPowerMax("player"',
    "LogresDB",
]:
    if forbidden in hud:
        errors.append(f"HUD.lua contains forbidden health/persistence path: {forbidden}")

# The health result may only be forwarded to native consumers. Keep obvious
# secret-value inspection/branching patterns out of production HUD code.
for forbidden in [
    "if alpha",
    "alpha <",
    "alpha >",
    "alpha ==",
    "tostring(alpha)",
    "string.format(alpha",
    "if percent",
    "percent <",
    "percent >",
    "percent ==",
    "tostring(percent)",
    "string.format(percent",
    "percent *",
    "percent /",
    "percent +",
    "percent -",
    "resourceText:GetText",
]:
    if forbidden in hud:
        errors.append(f"HUD.lua inspects secret-derived alpha in Lua: {forbidden}")

if "HUD\\HUD.lua" not in toc:
    errors.append("Logres.toc does not load HUD\\HUD.lua")

modules_index = toc.find("Core\\Modules.lua")
hud_index = toc.find("HUD\\HUD.lua")
commands_index = toc.find("Core\\Commands.lua")
lifecycle_index = toc.find("Core\\Lifecycle.lua")

if not (
    modules_index != -1
    and hud_index != -1
    and commands_index != -1
    and lifecycle_index != -1
):
    pass
elif not (modules_index < hud_index < commands_index < lifecycle_index):
    errors.append("TOC order must load Modules -> HUD -> Commands -> Lifecycle")

if "/logres hudcheck" not in commands:
    errors.append("Commands.lua must expose /logres hudcheck")

if "/logres hudpreview [on|off]" not in commands:
    errors.append("Commands.lua must expose /logres hudpreview [on|off]")

print("Logres HUD contract")
print("===================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
