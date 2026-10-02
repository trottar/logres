#!/usr/bin/env python3
# Static contract checks for D.6 restoration/recovery validation.

from pathlib import Path
import re

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

for path in (STOCK, QUIET, PLAYER, TARGET, CONTROLLER, COMMANDS, BOOTSTRAP, TOC):
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


def require_fragments(path, fragments):
    if not path.is_file():
        return
    source = path.read_text(encoding="utf-8")
    for fragment in fragments:
        if fragment not in source:
            errors.append(f"{path.name} missing: {fragment}")


require_fragments(STOCK, (
    "function StockReplacement:GetRecoveryStatus()",
    "snapshotReady = self.snapshot ~= nil",
    "routingManaged = self.appliedEnabled == true",
))
require_fragments(QUIET, (
    "function QuietMode:GetRecoveryStatus()",
    "savedConfigurationMutation = false",
))
require_fragments(PLAYER, (
    "function PlayerFrameReplacement:GetRecoveryStatus()",
    "self.interactionConfigured",
    "self.interactionMouseOwnedByLogres",
    "self.stockPresentationSuppressed",
    "self.stockMouseSuppressed",
))
require_fragments(TARGET, (
    "function TargetFrameReplacement:GetRecoveryStatus()",
    "unitWatchRegistered =",
    "interactionMouseOwnedByLogres =",
    "stockPresentationSuppressed =",
    "stockMouseSuppressed =",
    "preservedOverrideCount =",
))
require_fragments(CONTROLLER, (
    "function ImmersionController:GetRecoveryStatus()",
    "actionReplacementDesired =",
    "quietModeDesired =",
    "playerFrameSuppressionDesired =",
    "targetFrameSuppressionDesired =",
))

if STOCK.is_file():
    section = function_source(STOCK.read_text(encoding="utf-8"), "function StockReplacement:DisableReplacement()")
    if section is None:
        errors.append("StockReplacement DisableReplacement could not be isolated")
    else:
        restore_index = section.find("self:RestoreBar(snapshot.secondary)")
        routing_index = section.find("self:RestoreRouting(snapshot.routing)", restore_index + 1)
        if not (restore_index != -1 and routing_index != -1 and restore_index < routing_index):
            errors.append("StockActionReplacement must restore stock bars before prior routing")

for path, signature, label in (
    (PLAYER, "function PlayerFrameReplacement:DisableReplacement(reason)", "PlayerFrame"),
    (TARGET, "function TargetFrameReplacement:DisableReplacement(reason)", "TargetFrame"),
):
    if not path.is_file():
        continue
    section = function_source(path.read_text(encoding="utf-8"), signature)
    if section is None:
        errors.append(f"{label} DisableReplacement could not be isolated")
        continue
    restore_index = section.find("self:RestoreStock(snapshot)")
    interaction_index = section.find("self:DisableInteraction()", restore_index + len("self:RestoreStock(snapshot)")) if restore_index != -1 else -1
    if not (restore_index != -1 and interaction_index != -1 and restore_index < interaction_index):
        errors.append(f"{label} replacement must restore stock before disabling interaction")

for path, signature in (
    (STOCK, "function StockReplacement:GetRecoveryStatus()"),
    (QUIET, "function QuietMode:GetRecoveryStatus()"),
    (PLAYER, "function PlayerFrameReplacement:GetRecoveryStatus()"),
    (TARGET, "function TargetFrameReplacement:GetRecoveryStatus()"),
    (CONTROLLER, "function ImmersionController:GetRecoveryStatus()"),
):
    if not path.is_file():
        continue
    section = function_source(path.read_text(encoding="utf-8"), signature)
    if section is None:
        continue
    for forbidden in (
        "GetAlpha(", "IsMouseEnabled(", "IsMouseClickEnabled(",
        "IsMouseMotionEnabled(", "IsShown(", "GetAttribute(",
        "IsIgnoringParentAlpha(", "FCF_GetChatWindowInfo(",
    ):
        if forbidden in section:
            errors.append(f"{path.name} recovery API inspects protected presentation: {forbidden}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in (
        "local function runRestorationCheck()",
        'if command == "restorationcheck" then',
        '"Restoration Check"', '"restorationcheck"',
        "runRestorationCheck()", "mode=combat-nonmutating",
        'Logres:DisableModule("ImmersionController")',
        'Logres:EnableModule("ImmersionController")',
        "DEV_RESTORATIONCHECK_FLIP", "DEV_RESTORATIONCHECK_RESTORE",
    ):
        if fragment not in source:
            errors.append(f"Commands.lua missing restoration diagnostic: {fragment}")
    for forbidden in ("debugStatus.interactionShown", "debugStatus.interactionMouseEnabled"):
        if forbidden in source:
            errors.append(f"Commands.lua still relies on Player protected interaction readback: {forbidden}")

bootstrap_version = None
toc_version = None
if BOOTSTRAP.is_file():
    source = BOOTSTRAP.read_text(encoding="utf-8")
    match = re.search(r'Logres\.VERSION = "([^"]+)"', source)
    if not match:
        errors.append("Bootstrap.lua missing Logres.VERSION")
    else:
        bootstrap_version = match.group(1)
if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    match = re.search(r"^## Version: (.+)$", source, re.MULTILINE)
    if not match:
        errors.append("Logres.toc missing Version metadata")
    else:
        toc_version = match.group(1).strip()
if bootstrap_version and toc_version and bootstrap_version != toc_version:
    errors.append(f"Bootstrap.lua and Logres.toc versions differ: {bootstrap_version} != {toc_version}")

print("Logres D.6 restoration contract")
print("==============================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
