#!/usr/bin/env python3
"""Static contract for P0161 captured DynamicCam profile motion/settings parity."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BEHAVIOR = ROOT / "Logres" / "Camera" / "ProfileBehavior.lua"
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
NOTICE = ROOT / "Logres" / "Camera" / "LIBCAMERA_NOTICE.txt"

errors = []

for path in (BEHAVIOR, CONTROLLER, COMMANDS, TOC, NOTICE):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if BEHAVIOR.is_file():
    source = BEHAVIOR.read_text(encoding="utf-8")

    required = [
        '"ae586a9c973c3f868c10440358d4a6e8c2fab5ff"',
        '"c0b23135a0b24fbca24b41cb53dd7afc9114e352"',
        "cameraZoomSpeed = 15.5",
        "test_cameraDynamicPitch = 1",
        "test_cameraDynamicPitchBaseFovPad = 0.75",
        "test_cameraDynamicPitchBaseFovPadDownScale = 1",
        "test_cameraDynamicPitchBaseFovPadFlying = 0.5",
        "test_cameraDynamicPitchSmartPivotCutoffDist = 25",
        "test_cameraTargetFocusEnemyEnable = 1",
        "test_cameraTargetFocusEnemyStrengthPitch = 0.5",
        "test_cameraTargetFocusEnemyStrengthYaw = 0.75",
        "test_cameraTargetFocusInteractEnable = 1",
        "test_cameraTargetFocusInteractStrengthPitch = 0.5",
        "test_cameraTargetFocusInteractStrengthYaw = 0.75",
        'if context == "interaction" then',
        "target = -2",
        "if zoom <= 2 then",
        "if zoom >= 7 then",
        'if context == "city" then',
        "return 1",
        'taxi = {',
        'kind = "continuous"',
        "speed = -20",
        'teleport = {',
        "speed = 15",
        'interaction = {',
        'kind = "degrees"',
        "yaw = -45",
        'fishing = {',
        "yaw = 10",
        "pitch = 10",
        'gathering = {',
        "yaw = -15",
        "pitch = 15",
        "rotateBack = true",
        "function Behavior:StartContinuousYaw(",
        "function Behavior:StartYawDegrees(",
        "function Behavior:StartPitchDegrees(",
        "function Behavior:StopRotation(",
        "yawBack = yaw % 360",
        "if yawBack > 180 then",
        "function Behavior:BeginSettingsTransition(",
        "oldContext = oldContext",
        "newContext = newContext",
        "interruptedShoulder =",
        "shoulderCurve(",
        "transition.oldContext",
        "transition.newContext",
        "function Behavior:RestoreSettings()",
        "self.originalCvars[name] = token",
        "writeCVar(name, token)",
        "function Behavior:GetTargetMaxDistanceFactor(context)",
        "function Behavior:ServiceSettings(now)",
        "math.abs(zoom - self.lastZoom)",
        ">= ZOOM_EPSILON",
        "self.controller:Relinquish(",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"ProfileBehavior.lua missing P0161 contract: {fragment}")

    forbidden = [
        "FadeOutUI",
        "FadeInUI",
        "UIParent",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
        "CameraZoomIn =",
        "CameraZoomOut =",
        "SetView(",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"ProfileBehavior.lua out-of-scope behavior: {fragment}")

    # Max-distance ownership is situation-scoped only; there must be no hard-coded
    # standard max factor other than the City target 1 path.
    if "cameraDistanceMaxZoomFactor = " in source:
        errors.append(
            "ProfileBehavior.lua must not define a standard cameraDistanceMaxZoomFactor"
        )

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")
    required = [
        "self.profileBehavior = Logres.CameraProfileBehavior",
        "self.profileBehavior:Initialize(self)",
        "not behavior:IsActive()",
        "behavior:Acquire()",
        "behavior:ChangeContext(",
        "behavior:GetTargetMaxDistanceFactor(",
        "self.lastCameraDistanceTargetFactor =",
        "profileBehavior = self.profileBehavior",
        "self.profileBehavior:GetDebugStatus()",
        "self.profileBehavior:Release()",
        "MoveViewLeftStart",
        "MoveViewRightStart",
        "MoveViewUpStart",
        "MoveViewDownStart",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"WorldCombat.lua missing P0161 integration: {fragment}")

    if 'SetCVar("cameraDistanceMaxZoomFactor"' in source:
        errors.append(
            "WorldCombat.lua must not directly mutate cameraDistanceMaxZoomFactor"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local behavior = status.profileBehavior",
        "and behavior.active == true",
        "and behavior.active == false",
        "targetMaxFactor=%s",
        "tostring(status.lastCameraDistanceTargetFactor)",
        "local function emitCameraProfileBehaviorStatus(status)",
        "Logres cameraprofile behavior:",
        "settings=%s/%s/%s",
        "rotation=%s/%s",
        "emitCameraProfileBehaviorStatus(status)",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing P0161 diagnostic: {fragment}")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    behavior_index = source.find("Camera\\ProfileBehavior.lua")
    controller_index = source.find("Camera\\WorldCombat.lua")
    if behavior_index == -1:
        errors.append("Logres.toc missing Camera\\ProfileBehavior.lua")
    elif controller_index == -1 or behavior_index > controller_index:
        errors.append("Camera\\ProfileBehavior.lua must load before Camera\\WorldCombat.lua")

if NOTICE.is_file():
    source = NOTICE.read_text(encoding="utf-8")
    for fragment in [
        "Copyright (c) 2017 Michael P. Starkweather (mpstark)",
        "Permission is hereby granted, free of charge",
        "c0b23135a0b24fbca24b41cb53dd7afc9114e352",
    ]:
        if fragment not in source:
            errors.append(f"LibCamera notice missing attribution: {fragment}")

print("Logres P0161 captured camera profile behavior contract")
print("====================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
