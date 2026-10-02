#!/usr/bin/env python3
# Static contract checks for D.6 restoration/recovery validation.

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

STOCK = ROOT / "Logres" / "Actions" / "StockReplacement.lua"
QUIET = ROOT / "Logres" / "Immersion" / "QuietMode.lua"
PLAYER = ROOT / "Logres" / "Immersion" / "PlayerFrameReplacement.lua"
TARGET = ROOT / "Logres" / "Immersion" / "TargetFrameReplacement.lua"
CONTROLLER = ROOT / "Logres" / "Immersion" / "Controller.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (
    STOCK,
    QUIET,
    PLAYER,
    TARGET,
    CONTROLLER,
    COMMANDS,
    BOOTSTRAP,
    TOC,
):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")


def function_source(source, signature):
    start = source.find(signature)
    if start == -1:
        return None

    next_function = source.find("\nfunction ", start + len(signature))
    if next_function == -1:
        return source[start:]

    return source[start:next_function]


if STOCK.is_file():
    source = STOCK.read_text(encoding="utf-8")

    for fragment in (
        "function StockReplacement:GetRecoveryStatus()",
        "snapshotReady = self.snapshot ~= nil",
        "routingManaged = self.appliedEnabled == true",
    ):
        if fragment not in source:
            errors.append(f"StockReplacement.lua missing: {fragment}")

    disable = function_source(
        source,
        "function StockReplacement:DisableReplacement()",
    )

    if disable is None:
        errors.append("StockReplacement DisableReplacement could not be isolated")
    else:
        restore_index = disable.find("self:RestoreBar(snapshot.secondary)")
        routing_index = disable.find("self:RestoreRouting(snapshot.routing)")

        if not (
            restore_index != -1
            and routing_index != -1
            and restore_index < routing_index
        ):
            errors.append(
                "StockActionReplacement must restore stock bars before prior routing"
            )


if QUIET.is_file():
    source = QUIET.read_text(encoding="utf-8")

    for fragment in (
        "function QuietMode:GetRecoveryStatus()",
        "savedConfigurationMutation = false",
    ):
        if fragment not in source:
            errors.append(f"QuietMode.lua missing: {fragment}")


if PLAYER.is_file():
    source = PLAYER.read_text(encoding="utf-8")

    for fragment in (
        "function PlayerFrameReplacement:GetRecoveryStatus()",
        "self.interactionConfigured",
        "self.interactionMouseOwnedByLogres",
        "self.stockPresentationSuppressed",
        "self.stockMouseSuppressed",
    ):
        if fragment not in source:
            errors.append(f"PlayerFrameReplacement.lua missing: {fragment}")

    disable = function_source(
        source,
        "function PlayerFrameReplacement:DisableReplacement(reason)",
    )

    if disable is None:
        errors.append(
            "PlayerFrameReplacement DisableReplacement could not be isolated"
        )
    else:
        stock_index = disable.find("self:RestoreStock(snapshot)")
        interaction_index = disable.find("self:DisableInteraction()")

        if not (
            stock_index != -1
            and interaction_index != -1
            and stock_index < interaction_index
        ):
            errors.append(
                "PlayerFrame replacement must restore stock before disabling interaction"
            )


if TARGET.is_file():
    source = TARGET.read_text(encoding="utf-8")

    for fragment in (
        "function TargetFrameReplacement:GetRecoveryStatus()",
        "unitWatchRegistered =",
        "interactionMouseOwnedByLogres =",
        "stockPresentationSuppressed =",
        "stockMouseSuppressed =",
        "preservedOverrideCount =",
    ):
        if fragment not in source:
            errors.append(f"TargetFrameReplacement.lua missing: {fragment}")

    disable = function_source(
        source,
        "function TargetFrameReplacement:DisableReplacement(reason)",
    )

    if disable is None:
        errors.append(
            "TargetFrameReplacement DisableReplacement could not be isolated"
        )
    else:
        stock_index = disable.find("self:RestoreStock(snapshot)")
        interaction_index = disable.find("self:DisableInteraction()")

        if not (
            stock_index != -1
            and interaction_index != -1
            and stock_index < interaction_index
        ):
            errors.append(
                "TargetFrame replacement must restore stock before disabling interaction"
            )


if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")

    for fragment in (
        "function ImmersionController:GetRecoveryStatus()",
        "actionReplacementDesired =",
        "quietModeDesired =",
        "playerFrameSuppressionDesired =",
        "targetFrameSuppressionDesired =",
    ):
        if fragment not in source:
            errors.append(f"Controller.lua missing: {fragment}")


for path, signature in (
    (STOCK, "function StockReplacement:GetRecoveryStatus()"),
    (QUIET, "function QuietMode:GetRecoveryStatus()"),
    (PLAYER, "function PlayerFrameReplacement:GetRecoveryStatus()"),
    (TARGET, "function TargetFrameReplacement:GetRecoveryStatus()"),
    (CONTROLLER, "function ImmersionController:GetRecoveryStatus()"),
):
    if not path.is_file():
        continue

    source = path.read_text(encoding="utf-8")
    section = function_source(source, signature)

    if section is None:
        continue

    for forbidden in (
        "GetAlpha(",
        "IsMouseEnabled(",
        "IsMouseClickEnabled(",
        "IsMouseMotionEnabled(",
        "IsShown(",
        "GetAttribute(",
        "IsIgnoringParentAlpha(",
        "FCF_GetChatWindowInfo(",
    ):
        if forbidden in section:
            errors.append(
                f"{path.name} recovery API inspects protected presentation: "
                f"{forbidden}"
            )


if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    for fragment in (
        "local function runRestorationCheck()",
        'if command == "restorationcheck" then',
        '"Restoration Check"',
        '"restorationcheck"',
        "runRestorationCheck()",
        "mode=combat-nonmutating",
        'Logres:DisableModule("ImmersionController")',
        'Logres:EnableModule("ImmersionController")',
        "DEV_RESTORATIONCHECK_FLIP",
        "DEV_RESTORATIONCHECK_RESTORE",
    ):
        if fragment not in source:
            errors.append(f"Commands.lua missing restoration diagnostic: {fragment}")

    for forbidden in (
        "debugStatus.interactionShown",
        "debugStatus.interactionMouseEnabled",
    ):
        if forbidden in source:
            errors.append(
                "Commands.lua still relies on Player protected interaction "
                f"readback: {forbidden}"
            )


if BOOTSTRAP.is_file():
    source = BOOTSTRAP.read_text(encoding="utf-8")
    if 'Logres.VERSION = "0.0.27-dev"' not in source:
        errors.append("Bootstrap.lua version is not 0.0.27-dev")


if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    if "## Version: 0.0.27-dev" not in source:
        errors.append("Logres.toc version is not 0.0.27-dev")


print("Logres D.6 restoration contract")
print("==============================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
