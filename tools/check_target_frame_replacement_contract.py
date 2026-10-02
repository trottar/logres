#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
TARGET = ROOT / "Logres" / "Immersion" / "TargetFrameReplacement.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

errors = []

for path in (TARGET, COMMANDS):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")


def local_function_source(source, signature):
    start = source.find(signature)
    if start == -1:
        return None

    next_function = source.find(
        "\nlocal function ",
        start + len(signature),
    )

    if next_function == -1:
        return source[start:]

    return source[start:next_function]


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

    target_check = local_function_source(
        source,
        "local function runTargetFrameCheck()",
    )

    if target_check is None:
        errors.append("runTargetFrameCheck could not be isolated")
    else:
        # These fields are forbidden only inside the Target diagnostic.
        # PlayerFrame Check legitimately uses container/content alpha fields.
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
            if fragment in target_check:
                errors.append(
                    "Commands.lua target diagnostic still inspects "
                    f"secret-capable target state: {fragment}"
                )

print("Logres TargetFrame replacement contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
