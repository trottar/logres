#!/usr/bin/env python3
"""Static contract for G.5 read-only camera-distance info diagnostic."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / "Logres" / "Camera" / "Probe.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (PROBE, COMMANDS, BOOTSTRAP, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if PROBE.is_file():
    source = PROBE.read_text(encoding="utf-8")

    start = source.find("local function readCameraDistanceInfo()")
    end = source.find("local function queryDynamicCamLoaded()", start)

    if start == -1 or end == -1 or end <= start:
        errors.append("could not isolate readCameraDistanceInfo()")
    else:
        region = source[start:end]

        required = [
            'C_CVar.GetCVarInfo',
            '"cameraDistanceMaxZoomFactor"',
            'GetCVarDefault',
            'TAXI_TARGET / CAMERA_DISTANCE_SCALE',
            'currentCeiling = currentNumber * CAMERA_DISTANCE_SCALE',
            'defaultCeiling = defaultNumber * CAMERA_DISTANCE_SCALE',
            'currentSupports50 = currentNumber >= requiredFactor',
            'defaultSupports50 = defaultNumber >= requiredFactor',
            'isStoredServerAccount',
            'isStoredServerCharacter',
            'isLockedFromUser',
            'isSecure',
            'isReadOnly',
        ]
        for fragment in required:
            if fragment not in region:
                errors.append(
                    f"Probe read-only info helper missing contract: {fragment}"
                )

        forbidden = [
            "SetCVar(",
            "CameraZoomIn(",
            "CameraZoomOut(",
            "MoveView",
            "C_Timer",
            "RegisterEvent(",
            "SubscribeState(",
            "SetScript(",
        ]
        for fragment in forbidden:
            if fragment in region:
                errors.append(
                    "readCameraDistanceInfo() must remain read-only: "
                    + fragment
                )

    required_source = [
        "function Probe:ReadCameraDistanceInfo()",
        "queryDynamicCamLoaded()",
        "dynamicCamLoaded",
        "dynamicCamStatusKnown",
        "dynamicCamStatusSource",
    ]
    for fragment in required_source:
        if fragment not in source:
            errors.append(f"Probe.lua missing info exposure: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    required = [
        "local function runCameraDistanceInfo()",
        "probe:ReadCameraDistanceInfo()",
        'if command == "cameradistanceinfo" then',
        '"cameraDistanceInfo"',
        '"Camera Distance Info"',
        '"cameradistanceinfo"',
        '"G"',
        "cameradistanceinfo: PASS",
        "currentCeiling=%s",
        "defaultCeiling=%s",
        "requiredFactor=%s",
        "defaultSupports50=%s",
        "storedAccount=%s",
        "storedCharacter=%s",
        "locked=%s",
        "secure=%s",
        "readOnly=%s",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing distance-info contract: {fragment}")

print("Logres G.5 camera-distance read-only info contract")
print("====================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
