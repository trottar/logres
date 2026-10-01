#!/usr/bin/env python3
"""Static checks for D-028 Context Policy Check."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
CONTEXT = ROOT / "Logres" / "Actions" / "Context.lua"
CONTROLLER = ROOT / "Logres" / "Immersion" / "Controller.lua"

errors = []

for path in (COMMANDS, CONTEXT, CONTROLLER):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local CONTEXT_POLICY_ALPHA = {",
        "local function resolveExpectedContextPolicy(state)",
        "if state.combat then",
        "if state.pvpFlagged then",
        'if state.context == "instance" then',
        "local function runContextPolicyCheck()",
        "local state = Logres:GetState()",
        "local preferences = Logres:GetPreferences()",
        'Logres:GetModule("ImmersionController")',
        'Logres:GetModule("ActionContext")',
        "controllerDebug.actionReplacementDesired == immersion",
        "controllerDebug.quietModeDesired == expectedQuiet",
        "controllerDebug.playerFrameSuppressionDesired == immersion",
        "controllerDebug.targetFrameSuppressionDesired == immersion",
        "controllerDebug.partyFrameSuppressionDesired == false",
        "actionDebug.policyName == expectedActionPolicy",
        "actionDebug.primaryAlpha == expectedAlpha.primary",
        "actionDebug.secondaryAlpha == expectedAlpha.secondary",
        "actionDebug.utilityAlpha == expectedAlpha.utility",
        "contextDomainSettledOrDeferred(",
        'if command == "contextpolicycheck" then',
        '"Context Policy Check"',
        "runContextPolicyCheck()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Commands.lua missing D.5 diagnostic: {fragment}")

    start = source.find("local function runContextPolicyCheck()")
    end = source.find("\nlocal function runAllChecks()", start)

    if start == -1 or end == -1:
        errors.append("Context Policy Check function could not be isolated")
    else:
        check_source = source[start:end]

        forbidden = [
            "GetAlpha(",
            "IsMouse",
            "IsShown(",
            "IsIgnoringParentAlpha(",
            "_G.PlayerFrame",
            "_G.TargetFrame",
            "UnitHealth",
            "UnitPower",
        ]

        for fragment in forbidden:
            if fragment in check_source:
                errors.append(
                    "Context Policy Check must not inspect protected/secret "
                    f"presentation state: {fragment}"
                )

if CONTEXT.is_file():
    source = CONTEXT.read_text(encoding="utf-8")

    required = [
        "if state.combat then",
        "if state.pvpFlagged then",
        'if state.context == "instance" then',
        'return "world"',
        "primary = 1.00",
        "secondary = 0.45",
        "utility = 0.20",
        "secondary = 0.75",
        "utility = 0.40",
        "secondary = 0.70",
        "utility = 0.45",
        "secondary = 1.00",
        "utility = 0.75",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Context.lua missing D-028 policy fragment: {fragment}")

if CONTROLLER.is_file():
    source = CONTROLLER.read_text(encoding="utf-8")

    required = [
        "actionReplacementDesired = immersionEnabled",
        "quietModeDesired =",
        'state.context == "world"',
        "playerFrameSuppressionDesired = immersionEnabled",
        "targetFrameSuppressionDesired = immersionEnabled",
        "partyFrameSuppressionDesired = false",
        "primaryActionRoutingOwned = false",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Controller.lua missing D-028 ownership: {fragment}")

print("Logres context orchestration contract")
print("====================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
