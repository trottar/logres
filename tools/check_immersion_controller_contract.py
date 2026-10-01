#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUIET = ROOT / "Logres" / "Immersion" / "QuietMode.lua"
PLAYER = ROOT / "Logres" / "Immersion" / "PlayerFrameReplacement.lua"
TARGET = ROOT / "Logres" / "Immersion" / "TargetFrameReplacement.lua"
CONTROLLER = ROOT / "Logres" / "Immersion" / "Controller.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (QUIET, PLAYER, TARGET, CONTROLLER, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        'Logres:RegisterModule("ImmersionController"',
        "self:SubscribePreferences(",
        "self:SubscribeState(",
        "function ImmersionController:BuildPolicy()",
        "function ImmersionController:Reconcile(reason)",
        "function ImmersionController:GetDebugStatus()",
        'Logres:GetModule("StockActionReplacement")',
        'Logres:GetModule("QuietMode")',
        'Logres:GetModule("PlayerFrameReplacement")',
        'Logres:GetModule("TargetFrameReplacement")',
        "quietMode:RequestEnabled(",
        "playerFrameSuppressionDesired =",
        "playerFrameSuppressionImplemented = true",
        "targetFrameSuppressionDesired =",
        "targetFrameSuppressionImplemented = true",
        "partyFrameSuppressionDesired = false",
        "primaryActionRoutingOwned = false",
        "quietModeImplemented = true",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Controller.lua missing: {fragment}")

    forbidden = [
        "PlayerFrame:Hide(",
        "PlayerFrame:SetAlpha(",
        "TargetFrame:Hide(",
        "TargetFrame:SetAlpha(",
        "PartyFrame:Hide(",
        "CompactPartyFrame:Hide(",
        'SetPreference("immersionEnabled"',
        "SetChatWindowShown(",
        "SaveBindings(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"Controller.lua forbidden ownership path: {fragment}"
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in (
        "local function runImmersionCheck()",
        "local function runQuietModeCheck()",
        "local function runPlayerFrameCheck()",
        "local function runTargetFrameCheck()",
        'if command == "immersioncheck" then',
        'if command == "quietcheck" then',
        'if command == "playerframecheck" then',
        'if command == "targetframecheck" then',
        '"Immersion Check"',
        '"Quiet Check"',
        '"Player Frame Check"',
        '"Target Frame Check"',
        "runImmersionCheck()",
        "runQuietModeCheck()",
        "runPlayerFrameCheck()",
        "runTargetFrameCheck()",
    ):
        if fragment not in source:
            errors.append(f"Commands.lua missing Phase D diagnostic: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    replacement_index = source.find("Actions\\StockReplacement.lua")
    quiet_index = source.find("Immersion\\QuietMode.lua")
    player_index = source.find("Immersion\\PlayerFrameReplacement.lua")
    target_index = source.find("Immersion\\TargetFrameReplacement.lua")
    controller_index = source.find("Immersion\\Controller.lua")
    commands_index = source.find("Core\\Commands.lua")
    lifecycle_index = source.find("Core\\Lifecycle.lua")

    if min(
        replacement_index,
        quiet_index,
        player_index,
        target_index,
        controller_index,
        commands_index,
        lifecycle_index,
    ) == -1:
        errors.append("Logres.toc missing Phase D load-order entries")
    elif not (
        replacement_index
        < quiet_index
        < player_index
        < target_index
        < controller_index
        < commands_index
        < lifecycle_index
    ):
        errors.append(
            "Phase D replacement/controller load order is incorrect"
        )

print("Logres immersion controller contract")
print("====================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
