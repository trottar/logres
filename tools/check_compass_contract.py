#!/usr/bin/env python3
"""Static contract checks for D-029 / E.4 compass navigation."""

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
        "local WAYPOINT_UPDATE_INTERVAL = 0.15",
        "function Compass:ReconcilePolicy(reason)",
        "function Compass:RefreshHeading(reason)",
        "function Compass:RefreshWaypointBearing(reason)",
        "function Compass:UpdateWaypointMarker()",
        "function Compass:OnUpdate(elapsed)",
        "function Compass:GetDebugStatus()",
        "self:SubscribeState(function()",
        "self:SubscribePreferences(function()",
        'self.context == "world"',
        "self.immersionEnabled == true",
        'type(GetPlayerFacing) == "function"',
        "pcall(GetPlayerFacing)",
        "isSecret(facing)",
        "return (360 - math.deg(facing)) % 360",
        "C_Map.GetBestMapForUnit",
        "C_Map.GetPlayerMapPosition",
        "C_Map.GetUserWaypoint",
        "C_Map.GetUserWaypointPositionForMap",
        '"USER_WAYPOINT_UPDATED"',
        "pcall(",
        "readVectorXY(playerPosition)",
        "readVectorXY(destinationPosition)",
        "(math.deg(math.atan2(dx, -dy)) + 360) % 360",
        "self.waypointBearingDegrees = bearingDegrees",
        "self.waypointMarkerShown = shown",
        "self:RefreshWaypointBearing(event)",
        'self.frame:SetScript("OnUpdate", self.onUpdateHandler)',
        'self.frame:SetScript("OnUpdate", nil)',
        "self.headingDegrees = nil",
        "self.waypointBearingDegrees = nil",
        "self.frame:Hide()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Compass.lua missing E.4 fragment: {fragment}")

    for forbidden in (
        "C_Map.GetWorldPosFromMapPos",
        "C_QuestLog.",
        "C_SuperTrack.",
        "GetNextWaypoint",
        "SUPER_TRACKING_CHANGED",
        "SUPER_TRACKING_PATH_UPDATED",
        "Minimap",
    ):
        if forbidden in source:
            errors.append(
                "E.4 Compass.lua exceeds proven user-waypoint scope: "
                f"{forbidden}"
            )

    facing_secret = source.find("if isSecret(facing) then")
    facing_type = source.find('if type(facing) ~= "number" then')
    facing_math = source.find("local headingDegrees = headingFromFacing(facing)")

    if not (
        facing_secret != -1
        and facing_type != -1
        and facing_math != -1
        and facing_secret < facing_type < facing_math
    ):
        errors.append(
            "Compass facing must be secret-checked before inspection/arithmetic"
        )

    map_secret = source.find("if isSecret(mapID) then")
    map_type = source.find('if type(mapID) ~= "number" then')
    player_call = source.find(
        "C_Map.GetPlayerMapPosition,\n        mapID,"
    )

    if not (
        map_secret != -1
        and map_type != -1
        and player_call != -1
        and map_secret < map_type < player_call
    ):
        errors.append(
            "Compass mapID must be secret-checked before use"
        )

    vector_secret = source.find("if isSecret(value) then")
    vector_component_secret = source.find(
        "if isSecret(x) or isSecret(y) then"
    )
    vector_component_type = source.find(
        'if type(x) ~= "number" or type(y) ~= "number" then'
    )

    if not (
        vector_secret != -1
        and vector_component_secret != -1
        and vector_component_type != -1
        and vector_secret
            < vector_component_secret
            < vector_component_type
    ):
        errors.append(
            "Compass waypoint vectors must be secret-checked before arithmetic"
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
        "debugStatus.waypointAPIAvailable",
        "debugStatus.waypointEventRegistered",
        "debugStatus.waypointSourcePresent",
        "debugStatus.waypointBearingAvailable",
        "debugStatus.waypointMarkerShown",
        "waypointCoherent",
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

print("Logres D-029 / E.4 compass contract")
print("===================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
