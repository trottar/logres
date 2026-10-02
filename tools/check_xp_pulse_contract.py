#!/usr/bin/env python3
"""Static contract checks for the Phase F contextual XP pulse."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
XP = ROOT / "Logres" / "Quest" / "XP.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"

errors = []

for path in (XP, COMMANDS, TOC, BOOTSTRAP):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if XP.is_file():
    source = XP.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("QuestXP"',
        "local PULSE_SECONDS = 2.0",
        'type(UnitXP) == "function"',
        'type(UnitXPMax) == "function"',
        'pcall(UnitXP, "player")',
        'pcall(UnitXPMax, "player")',
        "if isSecret(currentXP) or isSecret(maxXP) then",
        'if type(currentXP) ~= "number"',
        'or type(maxXP) ~= "number"',
        "local delta = currentXP - self.baselineXP",
        "(currentXP / maxXP) * 100",
        '"PLAYER_XP_UPDATE"',
        '"PLAYER_LEVEL_UP"',
        '"PLAYER_ENTERING_WORLD"',
        "self:SubscribePreferences(function(preferences)",
        'self:PresentText(',
        'C_Timer.After(PULSE_SECONDS, function()',
        'function XP:ShowPreview()',
        'function XP:GetDebugStatus()',
        '"xp-range-changed-rebaseline"',
        '"xp-nonpositive-rebaseline"',
        '"suppressed-immersion-off"',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"XP.lua missing: {fragment}")

    forbidden = [
        "OnUpdate",
        'CreateFrame("StatusBar"',
        "SetMinMaxValues",
        "SetValue(",
        "MainMenuExpBar",
        "StatusTrackingBarManager",
        "ExperienceBar",
        "XPBar",
        "LogresDB",
        "HideUIPanel",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "XP pulse exceeds contextual/additive scope: "
                f"{fragment}"
            )

    secret = source.find(
        "if isSecret(currentXP) or isSecret(maxXP) then"
    )
    type_check = source.find(
        'if type(currentXP) ~= "number"'
    )
    current_compare = source.find("if currentXP < 0 then")
    max_compare = source.find("if maxXP <= 0 then")

    if not (
        secret != -1
        and type_check != -1
        and current_compare != -1
        and max_compare != -1
        and secret < type_check < current_compare < max_compare
    ):
        errors.append(
            "XP values must be secret-checked before inspection/comparison"
        )

    delta = source.find(
        "local delta = currentXP - self.baselineXP"
    )
    if delta == -1 or max_compare == -1 or delta < max_compare:
        errors.append(
            "XP arithmetic must occur only after safe sample validation"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function runXPCheck()",
        "local function runXPPreview()",
        'Logres:GetModuleStatus("QuestXP")',
        'Logres:GetModule("QuestXP")',
        'if command == "xpcheck" then',
        'if command == "xppreview" then',
        '"XP Check"',
        '"XP Preview"',
        '"xpcheck"',
        '"xppreview"',
        "runXPCheck()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing XP integration: {fragment}"
            )

    start = source.find("local function runXPCheck()")
    end = source.find(
        "\nlocal function runXPPreview()",
        start,
    )

    if start == -1 or end == -1:
        errors.append("XP Check function could not be isolated")
    else:
        check_source = source[start:end]
        for forbidden in (
            "UnitXP(",
            "UnitXPMax(",
            "GetXPExhaustion(",
        ):
            if forbidden in check_source:
                errors.append(
                    "XP Check must consume addon-owned status only: "
                    f"{forbidden}"
                )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    xp_index = source.find("Quest\\XP.lua")
    commands_index = source.find("Core\\Commands.lua")

    if xp_index == -1:
        errors.append("Logres.toc missing Quest\\XP.lua")
    elif commands_index == -1 or xp_index > commands_index:
        errors.append(
            "Quest\\XP.lua must load before Core\\Commands.lua"
        )

bootstrap_version = None
toc_version = None

if BOOTSTRAP.is_file():
    source = BOOTSTRAP.read_text(encoding="utf-8")
    match = re.search(
        r'Logres\.VERSION = "([^"]+)"',
        source,
    )
    if match:
        bootstrap_version = match.group(1)

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    match = re.search(
        r"^## Version: (.+)$",
        source,
        re.MULTILINE,
    )
    if match:
        toc_version = match.group(1).strip()

if bootstrap_version != "0.0.31-dev":
    errors.append(
        "F.3 runtime must identify as 0.0.31-dev"
    )

if toc_version != "0.0.31-dev":
    errors.append(
        "F.3 TOC must identify as 0.0.31-dev"
    )

print("Logres F.3 contextual XP pulse contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
