#!/usr/bin/env python3
"""Static checks for the Logres HUD secret-safe presentation boundary."""

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
    "function HUD:UpdateTarget()",
    'UnitExists("target")',
    'self.targetNameText:SetText(UnitName("target"))',
    'UnitHealthPercent(',
    '"target"',
    'self.targetHealthText:SetFormattedText("%.0f%%", percent)',
    '"PLAYER_TARGET_CHANGED"',
    '"UNIT_NAME_UPDATE"',
    '"UNIT_POWER_FREQUENT"',
    '"UNIT_MAXPOWER"',
    'local CAST_EVENTS = {',
    '"UNIT_SPELLCAST_START"',
    '"UNIT_SPELLCAST_STOP"',
    '"UNIT_SPELLCAST_FAILED"',
    '"UNIT_SPELLCAST_FAILED_QUIET"',
    '"UNIT_SPELLCAST_INTERRUPTED"',
    '"UNIT_SPELLCAST_CHANNEL_START"',
    '"UNIT_SPELLCAST_CHANNEL_STOP"',
    'handleCastEvent(self.playerCastCue, event, "player")',
    'handleCastEvent(self.targetCastCue, event, "target")',
    'RegisterUnitEvent(event, "player")',
    'RegisterUnitEvent(event, "target")',
    'C_Timer.After(0.18, function()',
    'local ALLY_UNITS = {',
    '"pet"',
    '"party1"',
    '"party2"',
    '"party3"',
    '"party4"',
    "function HUD:UpdateAllyUnit(unit)",
    "function HUD:UpdateAllies()",
    "row.nameText:SetText(UnitName(unit))",
    "UnitHealthPercent(",
    'row.healthText:SetFormattedText("%.0f%%", percent)',
    '"GROUP_ROSTER_UPDATE"',
    'RegisterUnitEvent("UNIT_PET", "player")',
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
    "UnitLevel(",
    "UnitClassification(",
    "SetPortraitTexture",
    "UnitCastingInfo(",
    "UnitChannelInfo(",
    "LogresHUDPlayerHealthBar",
    "self.playerHealthBar",
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
    "targetNameText:GetText",
    "targetHealthText:GetText",
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
