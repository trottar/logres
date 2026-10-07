#!/usr/bin/env python3
"""Static contract for P0162 source-backed DynamicCam reactive mouse-wheel zoom."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REACTIVE = ROOT / "Logres" / "Camera" / "ReactiveZoom.lua"
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
errors = []

for path in (REACTIVE, CONTROLLER, COMMANDS, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if REACTIVE.is_file():
    source = REACTIVE.read_text(encoding="utf-8")
    required = [
        '"ae586a9c973c3f868c10440358d4a6e8c2fab5ff"',
        "local REACTIVE_ZOOM_ENABLED = true",
        "local REACTIVE_ADD_ALWAYS = 0.1000000000000001",
        "local REACTIVE_ADD_QUICK = 2.5",
        "local REACTIVE_QUICK_THRESHOLD = 1.2",
        "local REACTIVE_MAX_TIME = 2.5",
        'local REACTIVE_EASING = "OutQuad"',
        "local CAMERA_DISTANCE_SCALE = 15",
        "if isSecret(value) then",
        "local numberValue = tonumber(value)",
        "if isSecret(increments) then",
        "if increments == 0 then",
        "if increments ~= 1 then",
        "math.abs(target - currentZoom) > REACTIVE_QUICK_THRESHOLD",
        "scaledIncrements = scaledIncrements + REACTIVE_ADD_QUICK",
        "target > currentZoom",
        "target < currentZoom",
        "if currentZoom == 0 then",
        "0.05",
        'readPositiveCVarNumber("cameraDistanceMaxZoomFactor")',
        "distanceFactor * CAMERA_DISTANCE_SCALE",
        "REACTIVE_MAX_TIME",
        "zoomTime < self.secondsPerFrame",
        "controller:BeginReactiveZoomTransition(",
        "REACTIVE_EASING",
        "self.nonReactiveZoomStarted",
        "self.nonReactiveZoomInProgress",
        "self.reactiveZoomTarget = currentZoom",
        "_G.CameraZoomIn = self.zoomInWrapper",
        "_G.CameraZoomOut = self.zoomOutWrapper",
        "if _G.CameraZoomIn == self.zoomInWrapper then",
        "if _G.CameraZoomOut == self.zoomOutWrapper then",
        "self.hookConflictCount = self.hookConflictCount + 1",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"ReactiveZoom.lua missing P0162 contract: {fragment}")

    forbidden = [
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
        "SetCVar(",
        "C_CVar.SetCVar",
        "UIParent",
        "FadeOutUI",
        "FadeInUI",
        "SetView(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"ReactiveZoom.lua out-of-scope behavior: {fragment}")

    secret_gate = source.find("if isSecret(value) then")
    numeric_use = source.find("local numberValue = tonumber(value)")
    if secret_gate == -1 or numeric_use == -1 or secret_gate > numeric_use:
        errors.append("ReactiveZoom.lua must secret-gate CVar values before tonumber")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        "self.reactiveZoom = Logres.CameraReactiveZoom",
        "self.reactiveZoom:Initialize(self)",
        "reactiveZoom:Acquire()",
        "self.reactiveZoom:Release()",
        "function Controller:MarkReactiveManualZoom()",
        "function Controller:BeginReactiveZoomTransition(",
        'transitionContext == "reactive"',
        'self.manualZoomContext == context',
        'self.transitionEasingName = easingName or "InOutQuad"',
        'self.lastTransitionEasingName = self.transitionEasingName',
        "local function easeOutQuad(",
        'if name == "OutQuad" then',
        "easingForName(self.transitionEasingName)",
        "reactiveZoom = self.reactiveZoom",
        "self.reactiveZoom:GetDebugStatus()",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing P0162 integration: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local reactive = status.reactiveZoom",
        "and reactive.active == true",
        "and reactive.hooked == true",
        "local function emitCameraReactiveZoomStatus(status)",
        "Logres cameraprofile reactive:",
        "emitCameraReactiveZoomStatus(status)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing P0162 diagnostic: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    reactive_index = source.find("Camera\\ReactiveZoom.lua")
    controller_index = source.find("Camera\\WorldCombat.lua")
    if reactive_index == -1:
        errors.append("Logres.toc missing Camera\\ReactiveZoom.lua")
    elif controller_index == -1 or reactive_index > controller_index:
        errors.append("Camera\\ReactiveZoom.lua must load before Camera\\WorldCombat.lua")

print("Logres P0162 reactive mouse-wheel zoom contract")
print("==============================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
