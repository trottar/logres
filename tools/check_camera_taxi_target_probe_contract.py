#!/usr/bin/env python3
"""Static contract checks for G.5 Taxi target-50 camera capability probe."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / "Logres" / "Camera" / "Probe.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (PROBE, COMMANDS, CONTROLLER, BOOTSTRAP, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if PROBE.is_file():
    source = PROBE.read_text(encoding="utf-8")
    required = [
        "local TAXI_TARGET = 50",
        "local TAXI_PROBE_LEG_DURATION = 5.0",
        "local TAXI_PROBE_TIMEOUT_EXTRA = 0.75",
        "local CAMERA_DISTANCE_SCALE = 15",
        "local function readCameraDistanceFactor()",
        'pcall(GetCVar, "cameraDistanceMaxZoomFactor")',
        '"cameraDistanceMaxZoomFactor returned secret value"',
        'function Probe:StartTaxiTargetProbe()',
        'self.probeKind = "taxi-target"',
        'self.legDuration = TAXI_PROBE_LEG_DURATION',
        'self.targetZoom = TAXI_TARGET',
        'self.lastCameraDistanceCeiling =',
        'distanceFactor * CAMERA_DISTANCE_SCALE',
        'function Probe:HandleTaxiTargetPanelAction()',
        'self.lastCameraDistanceUnchanged =',
        'finalFactor - self.lastCameraDistanceFactor',
        ') <= 0.000001',
        'self:BeginLeg(self.startZoom, "return")',
        'MoveViewOutStart',
        'MoveViewOutStop',
        'MoveViewInStart',
        'MoveViewInStop',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Camera/Probe.lua missing Taxi probe contract: {fragment}"
            )

    forbidden = [
        "SetCVar(",
        "CameraZoomIn(",
        "CameraZoomOut(",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "SubscribeState(",
        "RegisterEvent(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "Taxi capability probe must remain manual/read-only-CVar: "
                + fragment
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local function runCameraTaxiTargetProbe()",
        'probe:HandleTaxiTargetPanelAction()',
        'if command == "camerataxitargetprobe" then',
        '"cameraTaxiTargetProbe"',
        '"Taxi Target 50 Probe"',
        '"camerataxitargetprobe"',
        '"G"',
        "camerataxitargetprobe: STARTED",
        "camerataxitargetprobe: %s",
        'passed and "PASS" or "FAIL"',
        "cvarUnchanged=%s",
        "ceiling=%s",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing Taxi probe contract: {fragment}"
            )

    run_all_start = source.find("local function runAllChecks()")
    run_all_end = source.find(
        "local function handleHUDPreview",
        run_all_start,
    )
    if run_all_start == -1 or run_all_end == -1:
        errors.append("could not isolate runAllChecks()")
    elif "runCameraTaxiTargetProbe()" in source[run_all_start:run_all_end]:
        errors.append(
            "Taxi camera mutation probe must not be included in Run All"
        )

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        'if state.onTaxi then',
        'return "taxi", "taxi", false',
        'Logres:GetModule("CameraCapabilityProbe")',
        'if probeStatus.running then',
        'return false, "camera-probe-running"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(
                "Taxi probe/production coexistence contract missing: "
                + fragment
            )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    probe_index = source.find("Camera\\Probe.lua")
    commands_index = source.find("Core\\Commands.lua")
    if probe_index == -1:
        errors.append("Logres.toc missing Camera\\Probe.lua")
    elif commands_index == -1 or probe_index > commands_index:
        errors.append(
            "Camera\\Probe.lua must load before Core\\Commands.lua"
        )

print("Logres G.5 Taxi target-50 capability probe contract")
print("====================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
