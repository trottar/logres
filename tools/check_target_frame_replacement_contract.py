#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "Logres" / "Immersion" / "TargetFrameReplacement.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

errors = []

for path in (TARGET, COMMANDS):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if TARGET.is_file():
    source = TARGET.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("TargetFrameReplacement"',
        '"SecureUnitButtonTemplate"',
        "RegisterUnitWatch(self.interaction)",
        "UnregisterUnitWatch(self.interaction)",
        "ignoreParentAlpha =",
        "entry.region:IsIgnoringParentAlpha(),",
        "entry.region:SetIgnoreParentAlpha(entry.ignoreParentAlpha)",
        "self.preservedOverrideCount",
        "self.stockPresentationSuppressed",
        "self.stockMouseSuppressed",
        "self.interactionMouseOwnedByLogres",
        "preservedOverrideCount =",
        "stockPresentationSuppressed =",
        "stockMouseSuppressed =",
        "interactionMouseOwnedByLogres =",
        "wholeTargetFrameSuppressedByLogres = false",
        "targetOfTargetSuppressedByLogres = false",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"TargetFrameReplacement.lua missing: {fragment}"
            )

    forbidden = [
        "if region:IsIgnoringParentAlpha()",
        "IsIgnoringParentAlpha() == true",
        "interaction:IsShown()",
        "interaction:IsMouseEnabled()",
        "TargetFrame:Hide(",
        "TargetFrame:SetAlpha(",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"TargetFrameReplacement.lua secret-unsafe/forbidden path: {fragment}"
            )

    if source.count("IsIgnoringParentAlpha()") != 1:
        errors.append(
            "IsIgnoringParentAlpha must appear exactly once as opaque capture"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function runTargetFrameCheck()",
        "debugStatus.stockPresentationSuppressed == true",
        "debugStatus.stockMouseSuppressed == true",
        "debugStatus.preservedOverrideCount == 4",
        "debugStatus.interactionMouseOwnedByLogres == true",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing secret-safe target diagnostic: {fragment}"
            )

    forbidden = [
        "debugStatus.containerAlpha",
        "debugStatus.contentMainAlpha",
        "debugStatus.contextualAlpha",
        "debugStatus.targetFrameMouseEnabled",
        "debugStatus.preservedIgnoreParentCount",
        "debugStatus.interactionShown",
        "debugStatus.interactionMouseEnabled",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                f"Commands.lua still inspects secret-capable target state: {fragment}"
            )

print("Logres TargetFrame replacement contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
