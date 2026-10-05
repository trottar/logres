#!/usr/bin/env python3
"""Static contract checks for the Logres phase-tabbed developer/control panel."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
PANEL = ROOT / "Logres" / "Dev" / "Panel.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []
PHASES = set("0ABCDEFGH")
MAX_ACTIONS_PER_PHASE = 15
EXPECTED_PHASES = {
    "runall": "0",
    "status": "0",
    "preference": "0",
    "lifecycle": "0",
    "state": "A",
    "sensor": "A",
    "hud": "B",
    "healthPreview100": "B",
    "healthPreview80": "B",
    "healthPreview70": "B",
    "healthPreview60": "B",
    "healthPreview50": "B",
    "healthPreview40": "B",
    "healthPreview30": "B",
    "healthPreview20": "B",
    "healthPreview15": "B",
    "healthPreview5": "B",
    "healthPreview0": "B",
    "healthPreviewLive": "B",
    "action": "C",
    "actionFeedback": "C",
    "actionKeysOn": "C",
    "actionKeysOff": "C",
    "secondaryKeysOn": "C",
    "secondaryKeysOff": "C",
    "utilityKeysOn": "C",
    "utilityKeysOff": "C",
    "stockReplaceCheck": "C",
    "stockReplaceOn": "C",
    "stockReplaceOff": "C",
    "immersionCheck": "D",
    "quietCheck": "D",
    "playerFrameCheck": "D",
    "targetFrameCheck": "D",
    "restorationCheck": "D",
    "contextPolicyCheck": "D",
    "immersionOn": "D",
    "immersionOff": "D",
    "compassCheck": "E",
    "waypointProbe": "E",
    "questProbe": "F",
    "xpCheck": "F",
    "xpPreview": "F",
    "objectiveProgressCheck": "F",
    "objectiveProgressPreview": "F",
    "questDialogueCheck": "F",
    "questDialoguePreview": "F",
    "questInteractionProbe": "H",
    "questOfferControlsCheck": "H",
    "questOfferAcceptProbe": "H",
    "questOfferDeclineProbe": "H",
    "cameraWorldCombatCheck": "G",
    "cameraWorldCombatReconcile": "G",
    "cameraWorldCombatOn": "G",
    "cameraWorldCombatOff": "G",
    "cameraZoomProbe": "G",
    "cameraTaxiTargetProbe": "G",
    "cameraDistanceInfo": "G",
}

for path in (COMMANDS, PANEL, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "function Logres:RegisterDevPanelAction(id, label, command, phase)",
        "function Logres:GetDevPanelActions",
        "function Logres:RunDevCommand",
        "VALID_DEV_PANEL_PHASES",
        "phase = action.phase",
        '"statecheck"',
        '"sensorcheck"',
        '"preferencecheck"',
        '"lifecyclecheck"',
        '"hudcheck"',
        '"waypointProbe"',
        '"questProbe"',
        '"cameraWorldCombatCheck"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing: {fragment}")

    pattern = re.compile(
        r'Logres:RegisterDevPanelAction\(\s*'
        r'"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([^"]+)"\s*,\s*"([0A-H])"\s*\)',
        re.S,
    )
    registrations = pattern.findall(source)
    call_count = source.count("Logres:RegisterDevPanelAction(") - 1

    if len(registrations) != call_count:
        errors.append(
            f"every developer-panel action must declare a literal phase: "
            f"parsed {len(registrations)} of {call_count} registrations"
        )

    seen = {}
    counts = {phase: 0 for phase in PHASES}
    for action_id, _label, _command, phase in registrations:
        if action_id in seen:
            errors.append(f"duplicate dev-panel action registration: {action_id}")
        seen[action_id] = phase
        counts[phase] += 1

    for action_id, expected_phase in EXPECTED_PHASES.items():
        actual = seen.get(action_id)
        if actual != expected_phase:
            errors.append(
                f"dev-panel action {action_id!r} phase={actual!r}; "
                f"expected {expected_phase!r}"
            )

    for phase, count in sorted(counts.items()):
        if count > MAX_ACTIONS_PER_PHASE:
            errors.append(
                f"phase {phase} has {count} actions; max is {MAX_ACTIONS_PER_PHASE}"
            )

    emit_start = source.find("local function emit(message)")
    emit_end = source.find("function Logres:RegisterDevPanelAction", emit_start)
    if emit_start == -1 or emit_end == -1:
        errors.append("Commands.lua emit() function could not be isolated")
    else:
        emit_source = source[emit_start:emit_end]
        if "print(message)" not in emit_source:
            errors.append("Commands.lua emit() must fall back to print(message)")
        if "\n    emit(message)\n" in emit_source:
            errors.append("Commands.lua emit() recursively calls itself without a sink")

if PANEL.is_file():
    source = PANEL.read_text(encoding="utf-8")
    required = [
        'Logres:RegisterModule("DevPanel"',
        'CreateFrame("Frame", "LogresDevPanel", UIParent)',
        'frame:SetMovable(true)',
        'frame:RegisterForDrag("LeftButton")',
        '"ScrollingMessageFrame"',
        '"UIPanelButtonTemplate"',
        'DEFAULT_PHASE = "G"',
        'local PHASES = {',
        '{ id = "0", title = "Phase 0 — Foundation" }',
        '{ id = "A", title = "Phase A — Core State Engine" }',
        '{ id = "B", title = "Phase B — Core HUD" }',
        '{ id = "C", title = "Phase C — Action Interface" }',
        '{ id = "D", title = "Phase D — Immersion Controller" }',
        '{ id = "E", title = "Phase E — Compass and Navigation" }',
        '{ id = "F", title = "Phase F — Quest Experience" }',
        '{ id = "G", title = "Phase G — Cinematic Camera" }',
        '{ id = "H", title = "Phase H — Integration and Polish" }',
        "function Panel:CreatePhaseTabs()",
        "function Panel:SetActivePhase(phase)",
        "function Panel:RefreshPhaseTabs()",
        "action.phase == self.activePhase",
        "MAX_ACTIONS_PER_PHASE = BUTTON_COLUMNS * 5",
        "Logres:GetDevPanelActions()",
        "Logres:RunDevCommand(command",
        "function Logres:ToggleDevPanel()",
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
        errors.append("developer panel must not be parented/owned through the HUD module")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    commands_index = source.find("Core\\Commands.lua")
    panel_index = source.find("Dev\\Panel.lua")
    lifecycle_index = source.find("Core\\Lifecycle.lua")

    if "## SavedVariables: LogresDB, LogresDiagnosticsDB" not in source:
        errors.append("Logres.toc must persist LogresDiagnosticsDB")

    if panel_index == -1:
        errors.append("Logres.toc missing Dev\\Panel.lua")
    elif not (
        commands_index != -1
        and lifecycle_index != -1
        and commands_index < panel_index < lifecycle_index
    ):
        errors.append("Dev\\Panel.lua must load after Commands.lua and before Lifecycle.lua")

print("Logres phase-tabbed developer panel contract")
print("============================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
