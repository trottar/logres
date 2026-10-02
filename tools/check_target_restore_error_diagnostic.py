#!/usr/bin/env python3
"""Static contract for P0081 TargetFrame restoration error detail."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

errors = []

if not COMMANDS.is_file():
    errors.append("missing Logres/Core/Commands.lua")
else:
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "targetReason=%s",
        "targetError=%s",
        "controllerTargetResult=%s",
        "controllerTargetError=%s",
        "tostring(target.lastReason)",
        "tostring(target.lastError)",
        "tostring(controller.lastTargetResult)",
        "tostring(controller.lastTargetError)",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing restoration error detail: {fragment}"
            )

    start = source.find("local function restorationMismatchSummary(")
    end = source.find("\nlocal function failOpenStateMatches(", start)

    if start == -1 or end == -1:
        errors.append("restorationMismatchSummary could not be isolated")
    else:
        region = source[start:end]

        for forbidden in (
            "C_Timer.After",
            "C_Timer.NewTicker",
            "hooksecurefunc",
            "RequestEnabled(",
            "Reconcile(",
        ):
            if forbidden in region:
                errors.append(
                    "restoration mismatch diagnostic mutates behavior: "
                    f"{forbidden}"
                )

print("Logres P0081 TargetFrame restore error diagnostic")
print("=================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
