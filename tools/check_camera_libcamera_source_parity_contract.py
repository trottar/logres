#!/usr/bin/env python3
"""Dedicated P0160 R2 contract for LibCamera-source zoom parity."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTROLLER = ROOT / "Logres" / "Camera" / "WorldCombat.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
errors = []

for path in (CONTROLLER, COMMANDS):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")

    required = [
        '"c0b23135a0b24fbca24b41cb53dd7afc9114e352"',
        "LIBCAMERA_MAX_POS_ERROR = 0.5",
        "LIBCAMERA_REBASE_PRECISION = 0.005",
        "LIBCAMERA_REBASE_MAX_ITERATIONS = 100",
        "LIBCAMERA_CORRECTION_DURATION = 0.1",
        "LIBCAMERA_CORRECTION_TOLERANCE = 0.05",
        "local function easeInOutQuad(",
        "local function getEaseVelocity(",
        "local function rebaseEaseTime(",
        "math.min(duration - t, duration / 12)",
        "self.transitionSampleCount > 1",
        "> LIBCAMERA_MAX_POS_ERROR",
        "self.transitionStartTime =",
        "self.transitionStartTime",
        "- elapsedDifference",
        "function Controller:BeginSourceCorrection(",
        'pcall(SetCVar, "cameraZoomSpeed", value)',
        "math.min(",
        "50,",
        "math.abs(change / LIBCAMERA_CORRECTION_DURATION)",
        "function Controller:ServiceSourceCorrection(",
        "pcall(zoomFunc, amount, true)",
        "self:RestoreSourceCorrectionZoomSpeed()",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"missing LibCamera-source fragment: {fragment}")

    if source.count('pcall(SetCVar, "cameraZoomSpeed", value)') != 1:
        errors.append("cameraZoomSpeed SetCVar ownership must have exactly one wrapper")

    forbidden = [
        'SetCVar("cameraDistanceMaxZoomFactor"',
        "C_CVar.SetCVar",
        "local function boundedVelocity(",
        "local function transitionVelocity(",
        "TRANSITION_TIMEOUT_EXTRA",
        "C_Timer.NewTicker",
        "C_Timer.NewTimer",
        "C_Timer.After",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(f"forbidden P0160 R2 behavior: {fragment}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")
    for fragment in [
        "rebases=%s",
        "rebaseIters=%s",
        "corrections=%s",
        "correctionActive=%s",
        "correctionSpeed=%s",
        "rebase=%s->%s",
    ]:
        if fragment not in source:
            errors.append(f"missing P0160 R2 diagnostic: {fragment}")

print("Logres P0160 R2 LibCamera-source zoom parity contract")
print("====================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
