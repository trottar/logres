#!/usr/bin/env python3
"""Static contract checks for the Logres Phase C primary action cluster."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SOURCE_PATH = ROOT / "Logres" / "Actions" / "Primary.lua"
COMMANDS_PATH = ROOT / "Logres" / "Core" / "Commands.lua"
TOC_PATH = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (SOURCE_PATH, COMMANDS_PATH, TOC_PATH):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if SOURCE_PATH.is_file():
    source = SOURCE_PATH.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("PrimaryActions"',
        'local BUTTON_COUNT = 12',
        '"SecureActionButtonTemplate"',
        'button:SetAttribute("type", "action")',
        'button:SetAttribute("typerelease", "actionrelease")',
        '"LeftButtonDown"',
        '"RightButtonDown"',
        'button:SetAttribute("action", actionSlot)',
        "C_ActionBar.GetActionBarPage()",
        "C_ActionBar.RegisterActionUIButton(",
        "C_ActionBar.UnregisterActionUIButton(",
        "C_ActionBar.EnableActionRangeCheck(",
        "C_ActionBar.GetActionTexture(",
        "C_ActionBar.GetActionCooldownDuration(",
        "SetCooldownFromDurationObject(duration, true)",
        "C_ActionBar.GetActionDisplayCount(",
        "C_ActionBar.IsUsableAction(",
        "C_ActionBar.IsActionInRange(",
        "SetOverrideBindingClick(",
        "ClearOverrideBindings(",
        "function Primary:SetBindingRoutingEnabled(enabled)",
        "function Primary:RefreshBindingLabels()",
        "bindingRoutingEnabled = false",
        'GetBindingKey(command)',
        'event == "ACTIONBAR_PAGE_CHANGED"',
        'event == "UPDATE_BINDINGS"',
        'event == "PLAYER_REGEN_ENABLED"',
        "InCombatLockdown()",
        "pendingPageRefresh",
        "pendingBindingRefresh",
        "stockBarsSuppressed = false",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Primary.lua missing: {fragment}")

    forbidden = [
        "UseAction(",
        "SetBinding(",
        "SetBindingClick(",
        "SaveBindings(",
        "C_ActionBar.GetActionCooldown(",
        "GetActionCooldown(",
        "GetActionCount(",
        "C_ActionBar.GetActionUseCount(",
        "C_ActionBar.GetActionCharges(",
        "slotText",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Primary.lua forbidden path present: {fragment}")

    if re.search(
        r"if\s+.*GetActionDisplayCount",
        source,
    ):
        errors.append(
            "Primary.lua must not branch on GetActionDisplayCount results"
        )

    if re.search(
        r"GetActionCooldownDuration\([^\n]*\)\s*[+*/<>=-]",
        source,
    ):
        errors.append(
            "Primary.lua must not perform Lua arithmetic/comparison on "
            "cooldown duration objects"
        )

if COMMANDS_PATH.is_file():
    source = COMMANDS_PATH.read_text(encoding="utf-8")

    required = [
        "local function runActionCheck()",
        '"Logres actioncheck: PASS',
        'if command == "actioncheck" then',
        'Logres:RegisterDevPanelAction("action", "Action Check", "actioncheck")',
        '"Action Keys ON"',
        '"Action Keys OFF"',
        'if command == "actionbindings" then',
        "runActionCheck()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing action diagnostic: {fragment}")

if TOC_PATH.is_file():
    source = TOC_PATH.read_text(encoding="utf-8")
    action_index = source.find("Actions\\Primary.lua")
    commands_index = source.find("Core\\Commands.lua")

    if action_index == -1:
        errors.append("Logres.toc missing Actions\\Primary.lua")
    elif commands_index == -1 or action_index > commands_index:
        errors.append(
            "Actions\\Primary.lua must load before Core\\Commands.lua"
        )

print("Logres action interface contract")
print("===============================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
