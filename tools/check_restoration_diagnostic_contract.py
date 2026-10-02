#!/usr/bin/env python3
"""Static contract for detailed Restoration Check failure diagnostics."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

errors = []

if not COMMANDS.is_file():
    errors.append("missing Logres/Core/Commands.lua")
else:
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function restorationMatchDetails(",
        "local function restorationMismatchSummary(",
        "details.modulesReady",
        "details.desiredMatches",
        "details.recoveryMatches",
        "details.ownershipCoherent",
        "details.errorsClear",
        "action.snapshotReady",
        "action.routingManaged",
        "quiet.snapshotReady",
        "player.interactionMouseOwnedByLogres",
        "player.stockPresentationSuppressed",
        "player.stockMouseSuppressed",
        "target.unitWatchRegistered",
        "target.interactionMouseOwnedByLogres",
        "target.stockPresentationSuppressed",
        "target.stockMouseSuppressed",
        "target.contextualSuppressedCount",
        '"initial state is not settled "',
        '"opposite preference state did not settle "',
        '"original preference did not reconverge "',
        '"controller re-enable did not reconverge "',
        "restorationMismatchSummary(",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                "Commands.lua missing restoration diagnostic: "
                f"{fragment}"
            )

    start = source.find(
        "local function restorationMismatchSummary("
    )
    end = source.find(
        "\nlocal function failOpenStateMatches(",
        start,
    )
    summary_region = (
        source[start:end]
        if start != -1 and end != -1
        else ""
    )

    if not summary_region:
        errors.append(
            "restorationMismatchSummary could not be isolated"
        )
    else:
        for obsolete in (
            "target.preservedOverrideCount",
            "overrides=%s",
        ):
            if obsolete in summary_region:
                errors.append(
                    "restoration summary still uses obsolete "
                    f"target diagnostic: {obsolete}"
                )

    forbidden = [
        "C_Timer.After",
        "C_Timer.NewTicker",
        "hooksecurefunc",
    ]

    start = source.find(
        "local function restorationMatchDetails("
    )
    end = source.find(
        "local function runCompassCheck()",
        start,
    )
    diagnostic_region = (
        source[start:end]
        if start != -1 and end != -1
        else ""
    )

    for fragment in forbidden:
        if fragment in diagnostic_region:
            errors.append(
                "restoration diagnostic adds forbidden broad "
                f"retry/hook: {fragment}"
            )

print("Logres restoration failure diagnostic contract")
print("=============================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
