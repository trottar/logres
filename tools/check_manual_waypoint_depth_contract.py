#!/usr/bin/env python3
"""Static contract for the P0147 local-awareness waypoint depth correction."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
COMPASS = ROOT / "Logres" / "Navigation" / "Compass.lua"
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
TOC = ROOT / "Logres" / "Logres.toc"

errors = []
for path in (COMPASS, THEME, COMMANDS, BOOTSTRAP, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

compass = COMPASS.read_text(encoding="utf-8") if COMPASS.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
bootstrap = BOOTSTRAP.read_text(encoding="utf-8") if BOOTSTRAP.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""

required_theme = (
    "depthCloseRadiusFactor = 0.50",
    "depthNearRadiusFactor = 1.00",
    "depthMediumRadiusFactor = 4.00",
    "depthFarRadiusFactor = 8.00",
    "depthCloseScale = 1.05",
    "depthNearScale = 1.00",
    "depthMediumScale = 0.95",
    "depthFarScale = 0.90",
    "renderScaleMin = 0.90",
    "renderScaleMax = 1.12",
)
for fragment in required_theme:
    if fragment not in theme:
        errors.append(f"Theme.lua missing P0147 token: {fragment}")

required_compass = (
    "MANUAL_DEPTH_CLOSE_RADIUS_FACTOR",
    "MANUAL_DEPTH_NEAR_RADIUS_FACTOR",
    "MANUAL_DEPTH_MEDIUM_RADIUS_FACTOR",
    "MANUAL_DEPTH_FAR_RADIUS_FACTOR",
    "local function manualWaypointDepthScaleForDistance(distanceYards, viewRadiusYards)",
    "C_Minimap.GetViewRadius",
    "isSecret(viewRadiusYards)",
    "self.waypointViewRadiusYards = viewRadiusYards",
    "self.waypointDistanceRadiusRatio = ratio",
    "self.waypointDepthBand = band",
    "self.lastWaypointDepthReason = \"depth-available\"",
    "waypointViewRadiusAPIAvailable = self.waypointViewRadiusAPIAvailable == true",
    "waypointViewRadiusAvailable = self.waypointViewRadiusAvailable == true",
    "waypointViewRadiusYards = self.waypointViewRadiusYards",
    "waypointDistanceRadiusRatio = self.waypointDistanceRadiusRatio",
    "waypointDepthBand = self.waypointDepthBand",
    "lastWaypointDepthReason = self.lastWaypointDepthReason",
    "lastWaypointDepthError = self.lastWaypointDepthError",
)
for fragment in required_compass:
    if fragment not in compass:
        errors.append(f"Compass.lua missing P0147 fragment: {fragment}")

for obsolete in (
    "depthNearYards = 120",
    "depthFarYards = 1200",
    "MANUAL_DEPTH_NEAR_YARDS",
    "MANUAL_DEPTH_FAR_YARDS",
):
    if obsolete in theme or obsolete in compass:
        errors.append(f"obsolete absolute-yard depth calibration remains: {obsolete}")

# Require the semantic boundaries in order: half-radius close, one-radius near,
# four-radius medium, eight-radius far.
function_start = compass.find("local function manualWaypointDepthScaleForDistance(distanceYards, viewRadiusYards)")
function_end = compass.find("\nlocal function readVectorXY", function_start)
depth_fn = compass[function_start:function_end] if function_start != -1 and function_end != -1 else ""
for fragment in (
    "ratio <= MANUAL_DEPTH_CLOSE_RADIUS_FACTOR",
    "ratio <= MANUAL_DEPTH_NEAR_RADIUS_FACTOR",
    "ratio <= MANUAL_DEPTH_MEDIUM_RADIUS_FACTOR",
    "ratio <= MANUAL_DEPTH_FAR_RADIUS_FACTOR",
    'return MANUAL_DEPTH_FAR_SCALE, "far", ratio',
):
    if fragment not in depth_fn:
        errors.append(f"depth function missing semantic band fragment: {fragment}")

# GetViewRadius must be read under pcall and secret-checked before type/math.
distance_start = compass.find("function Compass:RefreshWaypointDistance(")
distance_end = compass.find("function Compass:UpdateTape(headingDegrees)", distance_start)
distance = compass[distance_start:distance_end] if distance_start != -1 and distance_end != -1 else ""
radius_call = distance.find("pcall(C_Minimap.GetViewRadius)")
radius_secret = distance.find("isSecret(viewRadiusYards)", radius_call)
radius_type = distance.find('type(viewRadiusYards) ~= "number"', radius_secret)
radius_math = distance.find("manualWaypointDepthScaleForDistance(", radius_type)
if not (
    radius_call != -1
    and radius_secret != -1
    and radius_type != -1
    and radius_math != -1
    and radius_call < radius_secret < radius_type < radius_math
):
    errors.append("view radius must be pcall-read and secret/type-checked before depth math")

# Distance remains non-owning; depth-reference failure may not clear bearing/presentation.
if "ClearWaypointPresentation" in distance:
    errors.append("distance/depth-only failure must not clear proven waypoint presentation")

# Commands must consume addon-owned diagnostics only and expose semantic-band proof.
check_start = commands.find("local function runCompassCheck()")
check_end = commands.find("\nlocal CONTEXT_POLICY_ALPHA = {", check_start)
check = commands[check_start:check_end] if check_start != -1 and check_end != -1 else ""
for fragment in (
    "debugStatus.waypointViewRadiusAPIAvailable",
    "debugStatus.waypointViewRadiusAvailable",
    "debugStatus.waypointViewRadiusYards",
    "debugStatus.waypointDistanceRadiusRatio",
    "debugStatus.waypointDepthBand",
    "debugStatus.lastWaypointDepthReason",
    "depthBandCoherent",
    "radius=%s",
    "ratio=%s",
    "band=%s",
):
    if fragment not in check:
        errors.append(f"Commands.lua missing P0147 Compass Check integration: {fragment}")

for forbidden in ("C_Map.", "C_Minimap.", "GetUserWaypoint(", "GetViewRadius("):
    if forbidden in check:
        errors.append(f"Compass Check must consume addon-owned state only: {forbidden}")

# Scope remains manual waypoint only; no new destination role or player-facing distance text.
for forbidden in (
    "C_QuestLog.",
    "C_SuperTrack.",
    "C_AreaPoiInfo.",
    "waypointDistanceLabel",
    "manualWaypointName",
    "waypointLabel",
    "SetCVar",
):
    if forbidden in compass:
        errors.append(f"Compass.lua exceeds corrected manual-waypoint scope: {forbidden}")

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None
if bootstrap_version != "0.0.71-dev" or toc_version != "0.0.71-dev":
    errors.append(f"P0147 runtime version must be 0.0.71-dev, got {bootstrap_version}/{toc_version}")

print("Logres P0147 local-awareness waypoint depth contract")
print("=====================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
