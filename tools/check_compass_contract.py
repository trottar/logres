#!/usr/bin/env python3
"""Static contract checks for D-029 / E.2 heading-only compass."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
COMPASS = ROOT / "Logres" / "Navigation" / "Compass.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []

for path in (COMPASS, COMMANDS, BOOTSTRAP, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if COMPASS.is_file():
    source = COMPASS.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("Compass"',
        "local UPDATE_INTERVAL = 0.05",
        "function Compass:ReconcilePolicy(reason)",
        "function Compass:RefreshHeading(reason)",
        "function Compass:OnUpdate(elapsed)",
        "function Compass:GetDebugStatus()",
        "self:SubscribeState(function()",
        "self:SubscribePreferences(function()",
        'self.context == "world"',
        "self.immersionEnabled == true",
        'type(GetPlayerFacing) == "function"',
        "pcall(GetPlayerFacing)",
        "isSecret(facing)",
        "if facing == nil then",
        'if type(facing) ~= "number" then',
        "return (360 - math.deg(facing)) % 360",
        'self.frame:SetScript("OnUpdate", self.onUpdateHandler)',
        'self.frame:SetScript("OnUpdate", nil)',
        'self:ClearPresentation("facing-unavailable")',
        "self.headingDegrees = nil",
        "self.frame:Hide()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Compass.lua missing D-029 fragment: {fragment}")

    for forbidden in (
        "C_Map.",
        "C_QuestLog.",
        "C_SuperTrack.",
        "Minimap",
        "USER_WAYPOINT_UPDATED",
        "SUPER_TRACKING_CHANGED",
        "GetUserWaypoint",
        "GetPlayerMapPosition",
        "GetBestMapForUnit",
    ):
        if forbidden in source:
            errors.append(
                "E.2 Compass.lua exceeds heading-only scope: "
                f"{forbidden}"
            )

    secret_index = source.find("if isSecret(facing) then")
    nil_index = source.find("if facing == nil then")
    type_index = source.find('if type(facing) ~= "number" then')
    math_index = source.find("local headingDegrees = headingFromFacing(facing)")

    if not (
        secret_index != -1
        and nil_index != -1
        and type_index != -1
        and math_index != -1
        and secret_index < nil_index < type_index < math_index
    ):
        errors.append(
            "Compass facing must be secret-checked before inspection/arithmetic"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    for fragment in (
        "local function runCompassCheck()",
        'Logres:GetModuleStatus("Compass")',
        'Logres:GetModule("Compass")',
        'if command == "compasscheck" then',
        "runCompassCheck()",
        '"Compass Check"',
        '"compasscheck"',
        'emit("  /logres compasscheck")',
    ):
        if fragment not in source:
            errors.append(
                f"Commands.lua missing Compass Check integration: {fragment}"
            )

    start = source.find("local function runCompassCheck()")
    end = source.find("\nlocal CONTEXT_POLICY_ALPHA = {", start)

    if start == -1 or end == -1:
        errors.append("Compass Check function could not be isolated")
    else:
        check_source = source[start:end]
        for forbidden in (
            "GetPlayerFacing(",
            "C_Map.",
            "C_QuestLog.",
            "C_SuperTrack.",
            "Minimap",
        ):
            if forbidden in check_source:
                errors.append(
                    "Compass Check must consume addon-owned status only: "
                    f"{forbidden}"
                )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    compass_index = source.find("Navigation\\Compass.lua")
    commands_index = source.find("Core\\Commands.lua")

    if compass_index == -1:
        errors.append("Logres.toc missing Navigation\\Compass.lua")
    elif commands_index == -1 or compass_index > commands_index:
        errors.append(
            "Navigation\\Compass.lua must load before Core\\Commands.lua"
        )

bootstrap_version = None
toc_version = None

if BOOTSTRAP.is_file():
    source = BOOTSTRAP.read_text(encoding="utf-8")
    match = re.search(r'Logres\.VERSION = "([^"]+)"', source)
    if not match:
        errors.append("Bootstrap.lua missing Logres.VERSION")
    else:
        bootstrap_version = match.group(1)

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    match = re.search(r"^## Version: (.+)$", source, re.MULTILINE)
    if not match:
        errors.append("Logres.toc missing Version metadata")
    else:
        toc_version = match.group(1).strip()

if (
    bootstrap_version is not None
    and toc_version is not None
    and bootstrap_version != toc_version
):
    errors.append(
        "Bootstrap.lua and Logres.toc versions differ: "
        f"{bootstrap_version} != {toc_version}"
    )

print("Logres D-029 / E.2 compass contract")
print("===================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
