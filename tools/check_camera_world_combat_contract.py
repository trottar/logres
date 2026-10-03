#!/usr/bin/env python3
"""Static contract checks for G.3 production World/Combat camera ownership."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
PROBE = ROOT / "Logres" / "Camera" / "Probe.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (CONTROLLER, PROBE, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        'Logres:RegisterModule("CameraWorldCombat"',
        'local WORLD_TARGET = 5',
        'local COMBAT_TARGET = 15',
        'local TRANSITION_DURATION = 2.5',
        'function Controller:Reconcile(reason)',
        'function Controller:OnUpdate()',
        'function Controller:GetDebugStatus()',
        'self:SubscribeState(function(',
        'readBoolean(UnitAffectingCombat, "player")',
        'readBoolean(InCombatLockdown)',
        'state.inInstance',
        'state.onTaxi',
        'state.interacting',
        'state.resting',
        'context == "world" and currentZoom > WORLD_TARGET',
        'context == "combat" and currentZoom < COMBAT_TARGET',
        'GetCameraZoom',
        'GetCVar',
        '"cameraZoomSpeed"',
        'MoveViewInStart',
        'MoveViewInStop',
        'MoveViewOutStart',
        'MoveViewOutStop',
        'queryDynamicCamLoaded()',
        '"dynamiccam-loaded"',
        '"camera-probe-running"',
        'self.frame:SetScript("OnUpdate"',
        'self.frame:SetScript("OnUpdate", nil)',
        'Logres:RegisterEvent("PLAYER_REGEN_DISABLED"',
        'Logres:RegisterEvent("PLAYER_REGEN_ENABLED"',
        'Logres:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED"',
        'Logres:RegisterEvent("ADDON_LOADED"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/WorldCombat.lua missing: {fragment}")

    forbidden = [
        'SetCVar(',
        'CameraZoomIn(',
        'CameraZoomOut(',
        'C_Timer.NewTicker',
        'C_Timer.NewTimer',
        'if state.combat',
        'elseif state.combat',
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"Camera/WorldCombat.lua forbidden contract: {fragment}")

if PROBE.is_file():
    source = PROBE.read_text(encoding="utf-8")
    required = [
        'Logres:GetModule("CameraWorldCombat")',
        'production camera controller enabled; disable it before manual camera probe',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Camera/Probe.lua missing production ownership gate: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        'local function runCameraWorldCombatCheck()',
        'local function runCameraWorldCombatReconcile()',
        'local function handleCameraWorldCombat(argument)',
        'Logres:GetModule("CameraWorldCombat")',
        'if command == "cameraworldcombatcheck" then',
        'if command == "cameraworldcombatreconcile" then',
        'if command == "cameraworldcombat" then',
        '"cameraWorldCombatCheck"',
        '"Camera World/Combat Check"',
        '"cameraWorldCombatReconcile"',
        '"Camera World/Combat Reconcile"',
        '"cameraWorldCombatOn"',
        '"Camera World/Combat ON"',
        '"cameraWorldCombatOff"',
        '"Camera World/Combat OFF"',
        'runCameraWorldCombatCheck()',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing G.3 camera contract: {fragment}")

    run_all_start = source.find("local function runAllChecks()")
    run_all_end = source.find("local function handleHUDPreview", run_all_start)
    if run_all_start == -1 or run_all_end == -1:
        errors.append("could not isolate runAllChecks()")
    else:
        run_all = source[run_all_start:run_all_end]
        if "runCameraWorldCombatCheck()" not in run_all:
            errors.append("Run All must include non-mutating Camera World/Combat Check")
        if "runCameraWorldCombatReconcile()" in run_all:
            errors.append("Run All must not invoke mutating camera reconcile")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    controller_index = source.find("Camera\\WorldCombat.lua")
    probe_index = source.find("Camera\\Probe.lua")
    commands_index = source.find("Core\\Commands.lua")
    if controller_index == -1:
        errors.append("Logres.toc missing Camera\\WorldCombat.lua")
    elif probe_index == -1 or controller_index > probe_index:
        errors.append("Camera\\WorldCombat.lua must load before Camera\\Probe.lua")
    elif commands_index == -1 or controller_index > commands_index:
        errors.append("Camera\\WorldCombat.lua must load before Core\\Commands.lua")

print("Logres G.3 World/Combat camera ownership contract")
print("=================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
