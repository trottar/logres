#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "Logres" / "Immersion" / "TargetFrameReplacement.lua"
CONTROLLER = ROOT / "Logres" / "Immersion" / "Controller.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (TARGET, CONTROLLER, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if TARGET.is_file():
    source = TARGET.read_text(encoding="utf-8")
    required = [
        'Logres:RegisterModule("TargetFrameReplacement"',
        '"SecureUnitButtonTemplate"',
        'interaction:SetAttribute("unit", "target")',
        'interaction:SetAttribute("*type1", "target")',
        'interaction:SetAttribute("*type2", "togglemenu")',
        'interaction:RegisterForClicks("AnyUp")',
        "RegisterUnitWatch(self.interaction)",
        "UnregisterUnitWatch(self.interaction)",
        "targetFrame.TargetFrameContainer",
        "content.TargetFrameContentMain",
        "content.TargetFrameContentContextual",
        '"Auras"',
        '"RaidTargetIcon"',
        '"QuestIcon"',
        '"PingIconFrame"',
        "SetIgnoreParentAlpha(true)",
        "snapshot.container:SetAlpha(0)",
        "snapshot.contentMain:SetAlpha(0)",
        "snapshot.contextual:SetAlpha(0)",
        "suppressMouse(snapshot.targetFrame)",
        "function TargetFrameReplacement:RequestEnabled(",
        "function TargetFrameReplacement:GetDebugStatus()",
        "wholeTargetFrameSuppressedByLogres = false",
        "targetOfTargetSuppressedByLogres = false",
        "focusFrameSuppressedByLogres = false",
        "bossFramesSuppressedByLogres = false",
        "partyFramesSuppressedByLogres = false",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"TargetFrameReplacement.lua missing: {fragment}")

    forbidden = [
        "TargetFrame:Hide(",
        "TargetFrame:SetAlpha(",
        "TargetFrameToT:Hide(",
        "FocusFrame:Hide(",
        "Boss1TargetFrame:Hide(",
        "PartyFrame:Hide(",
        "CompactPartyFrame:Hide(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"TargetFrameReplacement.lua forbidden blanket/deferred path: {fragment}"
            )

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    for fragment in (
        'Logres:GetModule("TargetFrameReplacement")',
        "targetFrameSuppressionDesired =",
        "replacement:RequestEnabled(desired, reason)",
        "targetFrameSuppressionImplemented = true",
        "targetFrameSuppressionRequested =",
        "targetFrameSuppressionApplied =",
        "targetFrameSuppressionPending =",
        "partyFrameSuppressionDesired = false",
    ):
        if fragment not in source:
            errors.append(
                f"Controller.lua missing TargetFrame ownership: {fragment}"
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in (
        "local function runTargetFrameCheck()",
        'if command == "targetframecheck" then',
        '"Target Frame Check"',
        "runTargetFrameCheck()",
    ):
        if fragment not in source:
            errors.append(
                f"Commands.lua missing TargetFrame diagnostic: {fragment}"
            )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    player_index = source.find("Immersion\\PlayerFrameReplacement.lua")
    target_index = source.find("Immersion\\TargetFrameReplacement.lua")
    controller_index = source.find("Immersion\\Controller.lua")
    commands_index = source.find("Core\\Commands.lua")

    if min(player_index, target_index, controller_index, commands_index) == -1:
        errors.append("Logres.toc missing TargetFrame replacement load entries")
    elif not player_index < target_index < controller_index < commands_index:
        errors.append(
            "TargetFrameReplacement must load before ImmersionController/Commands"
        )

print("Logres TargetFrame replacement contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
