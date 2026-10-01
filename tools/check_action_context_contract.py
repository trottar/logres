#!/usr/bin/env python3
"""Static C.4 context/paging contract checks."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTEXT = ROOT / "Logres" / "Actions" / "Context.lua"
PRIMARY = ROOT / "Logres" / "Actions" / "Primary.lua"
BUTTON = ROOT / "Logres" / "Actions" / "Button.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (CONTEXT, PRIMARY, BUTTON, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if CONTEXT.is_file():
    source = CONTEXT.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("ActionContext"',
        "self:SubscribeState(function(current)",
        "self:ApplyState(Logres:GetState())",
        "if state.combat then",
        "if state.pvpFlagged then",
        'if state.context == "instance" then',
        "primary.cluster:SetAlpha(policy.primary)",
        "sides.clusters.secondary.frame:SetAlpha(policy.secondary)",
        "sides.clusters.utility.frame:SetAlpha(policy.utility)",
        "primary = 1.00",
        "secondary = 0.45",
        "secondary = 0.75",
        "secondary = 0.70",
        "secondary = 1.00",
        "utility = 0.20",
        "utility = 0.40",
        "utility = 0.45",
        "utility = 0.75",
        "alphaZeroUsed",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Context.lua missing: {fragment}")

    for fragment in (
        ".frame:Hide(",
        ".frame:Show(",
        "SetAlpha(0)",
        "SetAlpha(0.0)",
    ):
        if fragment in source:
            errors.append(
                f"Context.lua forbidden contextual path present: {fragment}"
            )

if PRIMARY.is_file():
    source = PRIMARY.read_text(encoding="utf-8")

    required = [
        "local PRIMARY_PAGE_DRIVER",
        '"[bar:2]2;"',
        '"[bar:3]3;"',
        '"[bar:4]4;"',
        '"[bar:5]5;"',
        '"[bar:6]6;"',
        "button:SetID(index)",
        "RegisterAttributeDriver(",
        '"actionpage"',
        "UnregisterAttributeDriver(",
        "SecureCmdOptionParse(PRIMARY_PAGE_DRIVER)",
        "ActionButton.RegisterPresentation(",
        "securePagingReady",
        "secureDriverRegisteredCount",
        'specialPagingCoverage = "normal-pages-only"',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Primary.lua missing C.4 path: {fragment}")

    for fragment in (
        "C_ActionBar.GetActionBarPage(",
        "pendingPageRefresh",
        "ActionButton.Register(\n",
    ):
        if fragment in source:
            errors.append(
                f"Primary.lua retained obsolete insecure paging path: {fragment}"
            )

if BUTTON.is_file():
    source = BUTTON.read_text(encoding="utf-8")

    if "function ActionButton.RegisterPresentation(button, actionSlot)" not in source:
        errors.append("Button.lua missing presentation-only registration")

    if 'button:SetAttribute("action", actionSlot)' not in source:
        errors.append(
            "Button.lua fixed-slot Register must still assign secure action"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    for fragment in (
        "contextDebug.policyName",
        "contextDebug.secondaryAlpha",
        "contextDebug.utilityAlpha",
        "primaryDebug.securePagingReady",
        "primaryDebug.secureDriverRegisteredCount",
        "primaryDebug.specialPagingCoverage",
    ):
        if fragment not in source:
            errors.append(f"Commands.lua missing C.4 diagnostic: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    side_index = source.find("Actions\\SecondaryUtility.lua")
    context_index = source.find("Actions\\Context.lua")
    commands_index = source.find("Core\\Commands.lua")

    if min(side_index, context_index, commands_index) == -1:
        errors.append("Logres.toc missing C.4 runtime load entries")
    elif not side_index < context_index < commands_index:
        errors.append(
            "Context.lua must load after action clusters and before Commands"
        )

print("Logres action context / paging contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
