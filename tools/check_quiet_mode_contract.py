#!/usr/bin/env python3
# Static contract checks for D.3 Quiet Mode.

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
QUIET = ROOT / "Logres" / "Immersion" / "QuietMode.lua"
CONTROLLER = ROOT / "Logres" / "Immersion" / "Controller.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (QUIET, CONTROLLER, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if QUIET.is_file():
    source = QUIET.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("QuietMode"',
        '"UPDATE_CHAT_WINDOWS"',
        '"UPDATE_FLOATING_CHAT_WINDOWS"',
        'hooksecurefunc(',
        '"FCF_CheckShowChatFrame"',
        "region:SetAlpha(0)",
        "region:EnableMouse(enabled)",
        "editBox:SetIgnoreParentAlpha(true)",
        "editBox:IsIgnoringParentAlpha()",
        "FCF_GetChatWindowInfo(id)",
        "function QuietMode:RequestEnabled(enabled, reason)",
        "function QuietMode:ScheduleReconcile(reason)",
        "function QuietMode:GetDebugStatus()",
        "savedConfigurationMutation = false",
        '"ChatFrameChannelButton"',
        '"TextToSpeechButton"',
        '"QuickJoinToastButton"',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"QuietMode.lua missing: {fragment}")

    forbidden = [
        "SetChatWindowShown(",
        "FCF_SetWindowAlpha(",
        "SetChatWindowAlpha(",
        "RemoveAllMessageGroups(",
        "RemoveAllChannels(",
        "SetCVar(",
        "SendChatMessage(",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"QuietMode.lua forbidden persistent/communication path: {fragment}"
            )

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")

    for fragment in (
        'Logres:GetModule("QuietMode")',
        "quietMode:RequestEnabled(",
        "quietModeImplemented = true",
        "quietModeRequested =",
        "quietModeApplied =",
        "lastQuietResult =",
        "lastQuietError =",
    ):
        if fragment not in source:
            errors.append(f"Controller.lua missing Quiet Mode ownership: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    for fragment in (
        "local function runQuietModeCheck()",
        'if command == "quietcheck" then',
        '"Quiet Check"',
        "runQuietModeCheck()",
    ):
        if fragment not in source:
            errors.append(f"Commands.lua missing Quiet Mode diagnostic: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")

    quiet_index = source.find("Immersion\\QuietMode.lua")
    controller_index = source.find("Immersion\\Controller.lua")
    commands_index = source.find("Core\\Commands.lua")

    if min(quiet_index, controller_index, commands_index) == -1:
        errors.append("Logres.toc missing Quiet Mode load-order entries")
    elif not quiet_index < controller_index < commands_index:
        errors.append(
            "QuietMode must load before ImmersionController and Commands"
        )

print("Logres Quiet Mode contract")
print("==========================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
