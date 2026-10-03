#!/usr/bin/env python3
"""Static contract checks for the G.2 manual camera zoom capability probe."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / "Logres" / "Camera" / "Probe.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (PROBE, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if PROBE.is_file():
    source = PROBE.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("CameraCapabilityProbe"',
        'autoEnable = false',
        'function Probe:StartProbe()',
        'function Probe:HandlePanelAction()',
        'function Probe:GetDebugStatus()',
        'queryDynamicCamLoaded()',
        '"DynamicCam is loaded; disable it for isolated camera proof"',
        'GetCameraZoom',
        'GetCVar',
        '"cameraZoomSpeed"',
        'MoveViewInStart',
        'MoveViewInStop',
        'MoveViewOutStart',
        'MoveViewOutStop',
        'pcall(issecretvalue, value)',
        'self.frame:SetScript("OnUpdate"',
        'self.frame:SetScript("OnUpdate", nil)',
        'self:BeginLeg(self.startZoom, "return")',
        'math.abs(self.finalZoom - self.startZoom) <= TARGET_TOLERANCE',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/Probe.lua missing: {fragment}")

    forbidden = [
        'SetCVar(',
        'C_Timer.NewTicker',
        'C_Timer.NewTimer',
        'SubscribeState(',
        'RegisterEvent(',
        'PLAYER_REGEN_DISABLED',
        'PLAYER_REGEN_ENABLED',
        'CameraZoomIn(',
        'CameraZoomOut(',
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "Camera/Probe.lua must remain manual/primary-path only: "
                + fragment
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        'local function runCameraZoomProbe()',
        'Logres:GetModule("CameraCapabilityProbe")',
        'if command == "camerazoomprobe" then',
        '"cameraZoomProbe"',
        '"Camera Zoom Probe"',
        '"camerazoomprobe"',
        'camerazoomprobe: STARTED',
        'click Camera Zoom Probe again after the movement finishes',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing camera probe contract: {fragment}")

    run_all_start = source.find("local function runAllChecks()")
    run_all_end = source.find("local function handleHUDPreview", run_all_start)
    if run_all_start == -1 or run_all_end == -1:
        errors.append("could not isolate runAllChecks()")
    elif "runCameraZoomProbe()" in source[run_all_start:run_all_end]:
        errors.append("manual camera mutation probe must not be included in Run All")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    probe_index = source.find("Camera\\Probe.lua")
    commands_index = source.find("Core\\Commands.lua")

    if probe_index == -1:
        errors.append("Logres.toc missing Camera\\Probe.lua")
    elif commands_index == -1 or probe_index > commands_index:
        errors.append("Camera\\Probe.lua must load before Core\\Commands.lua")

print("Logres G.2 camera zoom capability probe contract")
print("================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
