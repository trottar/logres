#!/usr/bin/env python3
"""Static contract checks for the Logres Phase C action interface."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
BUTTON_PATH = ROOT / "Logres" / "Actions" / "Button.lua"
PRIMARY_PATH = ROOT / "Logres" / "Actions" / "Primary.lua"
SIDE_PATH = ROOT / "Logres" / "Actions" / "SecondaryUtility.lua"
COMMANDS_PATH = ROOT / "Logres" / "Core" / "Commands.lua"
TOC_PATH = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (
    BUTTON_PATH,
    PRIMARY_PATH,
    SIDE_PATH,
    COMMANDS_PATH,
    TOC_PATH,
):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if BUTTON_PATH.is_file():
    source = BUTTON_PATH.read_text(encoding="utf-8")

    required = [
        "Logres.ActionButton = ActionButton",
        "function ActionButton.CreateCluster(",
        "function ActionButton.Create(",
        '"SecureActionButtonTemplate"',
        'button:SetAttribute("type", "action")',
        'button:SetAttribute("typerelease", "actionrelease")',
        '"LeftButtonDown"',
        '"RightButtonDown"',
        "function ActionButton.RegisterPresentation(button, actionSlot)",
        "function ActionButton.Register(button, actionSlot)",
        'button:SetAttribute("action", actionSlot)',
        "C_ActionBar.RegisterActionUIButton(",
        "C_ActionBar.UnregisterActionUIButton(",
        "C_ActionBar.EnableActionRangeCheck(",
        "C_ActionBar.GetActionTexture(",
        "C_ActionBar.GetActionCooldownDuration(",
        "SetCooldownFromDurationObject(duration, true)",
        "C_ActionBar.GetActionDisplayCount(",
        "C_ActionBar.IsUsableAction(",
        "C_ActionBar.IsActionInRange(",
        'button:SetPushedTexture(',
        "Logres.Theme.action",
        'button:HookScript("PostClick", function(current)',
        'activationFlash:CreateAnimationGroup()',
        'activationFade:SetDuration(0.24)',
        "function ActionButton.CountFeedbackReady(buttons)",
        "activationFeedbackReady = true",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Button.lua missing: {fragment}")

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
        "UI-Quickslot-Depress",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Button.lua forbidden path present: {fragment}")

    if re.search(r"if\s+.*GetActionDisplayCount", source):
        errors.append(
            "Button.lua must not branch on GetActionDisplayCount results"
        )

    if re.search(
        r"GetActionCooldownDuration\([^\n]*\)\s*[+*/<>=-]",
        source,
    ):
        errors.append(
            "Button.lua must not perform Lua arithmetic/comparison on "
            "cooldown duration objects"
        )

if PRIMARY_PATH.is_file():
    source = PRIMARY_PATH.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("PrimaryActions"',
        "local ActionButton = Logres.ActionButton",
        "ActionButton.CreateCluster(",
        "ActionButton.Create(",
        "ActionButton.RegisterPresentation(",
        "ActionButton.Unregister(",
        'button:SetID(index)',
        "RegisterAttributeDriver(",
        '"actionpage"',
        "UnregisterAttributeDriver(",
        "SecureCmdOptionParse(PRIMARY_PAGE_DRIVER)",
        "SetOverrideBindingClick(",
        "ClearOverrideBindings(",
        "function Primary:SetBindingRoutingEnabled(enabled)",
        "bindingRoutingEnabled = false",
        'GetBindingKey(command)',
        'event == "ACTIONBAR_PAGE_CHANGED"',
        "RefreshPresentationPage()",
        'event == "UPDATE_BINDINGS"',
        'event == "PLAYER_REGEN_ENABLED"',
        "InCombatLockdown()",
        "pendingBindingRefresh",
        "stockBarsSuppressed = false",
        "activationFeedbackReadyCount",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Primary.lua missing: {fragment}")

    for fragment in (
        "UseAction(",
        "SaveBindings(",
        "SetBinding(",
        "C_ActionBar.GetActionBarPage(",
        "ActionButton.Register(\n",
    ):
        if fragment in source:
            errors.append(f"Primary.lua forbidden path present: {fragment}")

if SIDE_PATH.is_file():
    source = SIDE_PATH.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("SecondaryUtilityActions"',
        "local ActionButton = Logres.ActionButton",
        'bindingPrefix = "MULTIACTIONBAR1BUTTON"',
        "firstActionSlot = 61",
        "lastActionSlot = 72",
        'bindingPrefix = "MULTIACTIONBAR2BUTTON"',
        "firstActionSlot = 49",
        "lastActionSlot = 60",
        "ActionButton.CreateCluster(",
        "ActionButton.Create(",
        "ActionButton.Register(",
        "ActionButton.Unregister(",
        "SetOverrideBindingClick(",
        "ClearOverrideBindings(",
        "function SecondaryUtility:SetBindingRoutingEnabled(key, enabled)",
        "bindingRoutingEnabled = false",
        'event == "UPDATE_BINDINGS"',
        'event == "PLAYER_REGEN_ENABLED"',
        "InCombatLockdown()",
        "stockBarsSuppressed = false",
        "activationFeedbackReadyCount",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"SecondaryUtility.lua missing: {fragment}")

    for fragment in (
        "C_ActionBar.GetActionBarPage(",
        "ACTIONBAR_PAGE_CHANGED",
        "UseAction(",
        "SaveBindings(",
        "SetBinding(",
    ):
        if fragment in source:
            errors.append(
                f"SecondaryUtility.lua forbidden path present: {fragment}"
            )

if COMMANDS_PATH.is_file():
    source = COMMANDS_PATH.read_text(encoding="utf-8")

    required = [
        "local function runActionCheck()",
        '"Logres actioncheck: PASS',
        '"Secondary Keys ON"',
        '"Secondary Keys OFF"',
        '"Utility Keys ON"',
        '"Utility Keys OFF"',
        'if command == "secondarybindings" then',
        'if command == "utilitybindings" then',
        "primaryDebug.activationFeedbackReadyCount",
        "secondary.activationFeedbackReadyCount",
        "utility.activationFeedbackReadyCount",
        "runActionCheck()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing action diagnostic/control: {fragment}"
            )

if TOC_PATH.is_file():
    source = TOC_PATH.read_text(encoding="utf-8")

    button_index = source.find("Actions\\Button.lua")
    primary_index = source.find("Actions\\Primary.lua")
    side_index = source.find("Actions\\SecondaryUtility.lua")
    commands_index = source.find("Core\\Commands.lua")

    if min(button_index, primary_index, side_index, commands_index) == -1:
        errors.append("Logres.toc missing required action runtime files")
    elif not (
        button_index
        < primary_index
        < side_index
        < commands_index
    ):
        errors.append(
            "Action runtime load order must be "
            "Button -> Primary -> SecondaryUtility -> Commands"
        )

print("Logres action interface contract")
print("===============================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
