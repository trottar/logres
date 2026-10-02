#!/usr/bin/env python3
"""Static contract checks for the Logres developer/control panel."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
PANEL = ROOT / "Logres" / "Dev" / "Panel.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (COMMANDS, PANEL, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "function Logres:RegisterDevPanelAction",
        "function Logres:GetDevPanelActions",
        "function Logres:RunDevCommand",
        'Logres:RegisterDevPanelAction("runall", "Run All", "checkall")',
        '"statecheck"',
        '"sensorcheck"',
        '"preferencecheck"',
        '"lifecyclecheck"',
        '"hudcheck"',
        '"immersion on"',
        '"immersion off"',
        '"waypointProbe"',
        '"Waypoint Probe"',
        '"waypointprobe"',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing: {fragment}")

    emit_start = source.find("local function emit(message)")
    emit_end = source.find(
        "function Logres:RegisterDevPanelAction",
        emit_start,
    )

    if emit_start == -1 or emit_end == -1:
        errors.append("Commands.lua emit() function could not be isolated")
    else:
        emit_source = source[emit_start:emit_end]

        if "print(message)" not in emit_source:
            errors.append(
                "Commands.lua emit() must fall back to print(message)"
            )

        if "\n    emit(message)\n" in emit_source:
            errors.append(
                "Commands.lua emit() recursively calls itself without a sink"
            )

if PANEL.is_file():
    source = PANEL.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("DevPanel"',
        'CreateFrame("Frame", "LogresDevPanel", UIParent)',
        'frame:SetMovable(true)',
        'frame:RegisterForDrag("LeftButton")',
        '"ScrollingMessageFrame"',
        '"UIPanelButtonTemplate"',
        "Logres:GetDevPanelActions()",
        "Logres:RunDevCommand(command",
        "function Logres:ToggleDevPanel()",
        "OnEnable = function(self)",
        "self.frame:Show()",
        "LogresDiagnosticsDB = LogresDiagnosticsDB or {}",
        "function Panel:BeginDiagnosticRun(command)",
        "function Panel:AddResult(message, run)",
        "db.runs[#db.runs + 1] = run",
        "MAX_DIAGNOSTIC_RUNS = 100",
        "MAX_DIAGNOSTIC_LINES = 120",
        "Panel runs auto-save to LogresDiagnosticsDB on /reload/logout.",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Panel.lua missing: {fragment}")

    if 'self:GetModule("HUD")' in source:
        errors.append(
            "developer panel must not be parented/owned through the HUD module"
        )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    commands_index = source.find("Core\\Commands.lua")
    panel_index = source.find("Dev\\Panel.lua")
    lifecycle_index = source.find("Core\\Lifecycle.lua")

    if "## SavedVariables: LogresDB, LogresDiagnosticsDB" not in source:
        errors.append(
            "Logres.toc must persist LogresDiagnosticsDB"
        )

    if panel_index == -1:
        errors.append("Logres.toc missing Dev\\Panel.lua")
    elif not (
        commands_index != -1
        and lifecycle_index != -1
        and commands_index < panel_index < lifecycle_index
    ):
        errors.append(
            "Dev\\Panel.lua must load after Commands.lua and before Lifecycle.lua"
        )

print("Logres developer panel contract")
print("===============================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
