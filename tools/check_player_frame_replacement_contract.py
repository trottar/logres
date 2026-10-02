#!/usr/bin/env python3
# Static contract checks for D-026 Player selective replacement.

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PLAYER = ROOT / "Logres" / "Immersion" / "PlayerFrameReplacement.lua"
CONTROLLER = ROOT / "Logres" / "Immersion" / "Controller.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (PLAYER, CONTROLLER, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if PLAYER.is_file():
    source = PLAYER.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("PlayerFrameReplacement"',
        '"SecureUnitButtonTemplate"',
        'interaction:SetAttribute("unit", "player")',
        'interaction:SetAttribute("*type1", "target")',
        'interaction:SetAttribute("*type2", "togglemenu")',
        'interaction:RegisterForClicks("AnyUp")',
        "playerFrame.PlayerFrameContainer",
        "content.PlayerFrameContentMain",
        "snapshot.container:SetAlpha(0)",
        "snapshot.contentMain:SetAlpha(0)",
        "suppressMouse(snapshot.playerFrame)",
        "self:EnableInteraction()",
        "self:RestoreStock(snapshot)",
        "self:DisableInteraction()",
        '"PLAYER_REGEN_ENABLED"',
        "function PlayerFrameReplacement:RequestEnabled(",
        "function PlayerFrameReplacement:GetRecoveryStatus()",
        "function PlayerFrameReplacement:GetDebugStatus()",
        "self.interactionConfigured",
        "self.interactionMouseOwnedByLogres",
        "self.stockPresentationSuppressed",
        "self.stockMouseSuppressed",
        "wholePlayerFrameSuppressedByLogres = false",
        "directPlayerChildrenSuppressedByLogres = false",
        "targetFrameSuppressedByLogres = false",
        "partyFramesSuppressedByLogres = false",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"PlayerFrameReplacement.lua missing: {fragment}")

    forbidden = [
        "PlayerFrame:Hide(",
        "PlayerFrame:SetAlpha(",
        "RuneFrame:Hide(",
        "RuneFrame:SetAlpha(",
        "TotemFrame:Hide(",
        "TotemFrame:SetAlpha(",
        "PetFrame:Hide(",
        "PetFrame:SetAlpha(",
        "TargetFrame:Hide(",
        "TargetFrame:SetAlpha(",
        "PartyFrame:Hide(",
        "CompactPartyFrame:Hide(",
        "RegisterUnitWatch(",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"PlayerFrameReplacement.lua forbidden blanket/deferred path: {fragment}"
            )

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")

    required = [
        'Logres:GetModule("PlayerFrameReplacement")',
        "playerFrameSuppressionDesired =",
        "playerReplacement:RequestEnabled(",
        "playerFrameSuppressionImplemented = true",
        "playerFrameSuppressionRequested =",
        "playerFrameSuppressionApplied =",
        "playerFrameSuppressionPending =",
        "partyFrameSuppressionDesired = false",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Controller.lua missing PlayerFrame ownership: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    for fragment in (
        "local function runPlayerFrameCheck()",
        'if command == "playerframecheck" then',
        '"Player Frame Check"',
        "runPlayerFrameCheck()",
    ):
        if fragment not in source:
            errors.append(
                f"Commands.lua missing PlayerFrame diagnostic: {fragment}"
            )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")

    quiet_index = source.find("Immersion\\QuietMode.lua")
    player_index = source.find("Immersion\\PlayerFrameReplacement.lua")
    controller_index = source.find("Immersion\\Controller.lua")
    commands_index = source.find("Core\\Commands.lua")

    if min(
        quiet_index,
        player_index,
        controller_index,
        commands_index,
    ) == -1:
        errors.append("Logres.toc missing PlayerFrame replacement load entries")
    elif not (
        quiet_index
        < player_index
        < controller_index
        < commands_index
    ):
        errors.append(
            "PlayerFrameReplacement must load before ImmersionController/Commands"
        )

print("Logres PlayerFrame replacement contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
