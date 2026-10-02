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
        "local PRESERVED_CONTEXT_KEYS = {",
        "local SUPPRESSED_CONTEXT_KEYS = {",
        "alpha = entry.region:GetAlpha(),",
        "entry.region:SetAlpha(0)",
        "entry.region:SetAlpha(entry.alpha)",
        "self.contextualSuppressedCount",
        "self.stockPresentationSuppressed",
        "self.stockMouseSuppressed",
        "self.interactionMouseOwnedByLogres",
        "suppressedContextCount =",
        "contextualSuppressedCount =",
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

    for key in (
        "Auras",
        "RaidTargetIcon",
        "QuestIcon",
        "PingIconFrame",
        "HighLevelTexture",
        "LeaderIcon",
        "GuideIcon",
        "BossIcon",
        "PvpIcon",
        "PrestigePortrait",
        "PrestigeBadge",
        "PetBattleIcon",
        "NumericalThreat",
    ):
        if f'"{key}"' not in source:
            errors.append(
                f"TargetFrame contextual key missing: {key}"
            )

    forbidden = [
        "IsIgnoringParentAlpha(",
        "SetIgnoreParentAlpha(",
        "ignoreParentAlpha",
        "preservedOverrideCount",
        "snapshot.contextual:SetAlpha(0)",
        "TargetFrame:Hide(",
        "TargetFrame:SetAlpha(",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "TargetFrameReplacement.lua secret-unsafe/"
                f"obsolete path: {fragment}"
            )

    suppress_start = source.find(
        "function TargetFrameReplacement:SuppressStock(snapshot)"
    )
    restore_start = source.find(
        "function TargetFrameReplacement:RestoreStock(snapshot)"
    )
    enable_start = source.find(
        "function TargetFrameReplacement:EnableReplacement(reason)"
    )

    if (
        suppress_start == -1
        or restore_start == -1
        or enable_start == -1
    ):
        errors.append(
            "TargetFrame suppression functions could not be isolated"
        )
    else:
        suppress = source[suppress_start:restore_start]
        restore = source[restore_start:enable_start]

        if "snapshot.preserved" in suppress:
            errors.append(
                "preserved contextual children must not be mutated"
            )

        if "snapshot.preserved" in restore:
            errors.append(
                "preserved contextual children must not be restored/mutated"
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function runTargetFrameCheck()",
        "debugStatus.stockPresentationSuppressed == true",
        "debugStatus.stockMouseSuppressed == true",
        "debugStatus.preservedCount == 4",
        "debugStatus.suppressedContextCount == 9",
        "debugStatus.contextualSuppressedCount == 9",
        "debugStatus.interactionMouseOwnedByLogres == true",
        "target.contextualSuppressedCount",
        "targetSuppressedExpected",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing target diagnostic: {fragment}"
            )

    target_check = local_function_source(
        source,
        "local function runTargetFrameCheck()",
    )

    if target_check is None:
        errors.append("runTargetFrameCheck could not be isolated")
    else:
        forbidden = [
            "debugStatus.containerAlpha",
            "debugStatus.contentMainAlpha",
            "debugStatus.contextualAlpha",
            "debugStatus.targetFrameMouseEnabled",
            "debugStatus.preservedIgnoreParentCount",
            "debugStatus.interactionShown",
            "debugStatus.interactionMouseEnabled",
            "debugStatus.preservedOverrideCount",
        ]

        for fragment in forbidden:
            if fragment in target_check:
                errors.append(
                    "Commands.lua target diagnostic still inspects "
                    f"obsolete/protected state: {fragment}"
                )

print("Logres TargetFrame replacement contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
