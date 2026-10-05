#!/usr/bin/env python3
"""Static contract for P0145 manual-waypoint comparable distance / bounded depth."""

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

required_compass_patterns = (
    (r"local\s+MANUAL_DEPTH_NEAR_YARDS\s*=\s*manualWaypointStyle\.depthNearYards\s+or\s+120", "MANUAL_DEPTH_NEAR_YARDS"),
    (r"local\s+MANUAL_DEPTH_FAR_YARDS\s*=\s*manualWaypointStyle\.depthFarYards\s+or\s+1200", "MANUAL_DEPTH_FAR_YARDS"),
    (r"local\s+MANUAL_DEPTH_NEAR_SCALE\s*=\s*manualWaypointStyle\.depthNearScale\s+or\s+1\.05", "MANUAL_DEPTH_NEAR_SCALE"),
    (r"local\s+MANUAL_DEPTH_FAR_SCALE\s*=\s*manualWaypointStyle\.depthFarScale\s+or\s+0\.90", "MANUAL_DEPTH_FAR_SCALE"),
    (r"local\s+MANUAL_RENDER_SCALE_MIN\s*=\s*manualWaypointStyle\.renderScaleMin\s+or\s+0\.90", "MANUAL_RENDER_SCALE_MIN"),
    (r"local\s+MANUAL_RENDER_SCALE_MAX\s*=\s*manualWaypointStyle\.renderScaleMax\s+or\s+1\.12", "MANUAL_RENDER_SCALE_MAX"),
)
for pattern, label in required_compass_patterns:
    if re.search(pattern, compass) is None:
        errors.append(f"Compass.lua missing P0145 assignment: {label}")

required_compass = (
    "local function manualWaypointDepthScaleForDistance(distanceYards)",
    "function Compass:ClearWaypointDistance(reason, errorText)",
    "function Compass:RefreshWaypointDistance(",
    "C_Map.GetMapWorldSize",
    "rawWaypointSourceMapID",
    "isSecret(rawWaypointSourceMapID)",
    "self.waypointSourceMapID = rawWaypointSourceMapID",
    "waypointSourceMapID ~= mapID",
    "isSecret(width) or isSecret(height)",
    "local dxYards = (destinationX - playerX) * width",
    "local dyYards = (destinationY - playerY) * height",
    "math.sqrt(dxYards * dxYards + dyYards * dyYards)",
    "self.waypointDistanceYards = distanceYards",
    "self.waypointDepthScale =",
    "self.waypointRenderScale = scale",
    "waypointDistanceAPIAvailable = self.waypointDistanceAPIAvailable == true",
    "waypointDistanceAvailable = self.waypointDistanceAvailable == true",
    "waypointDistanceYards = self.waypointDistanceYards",
    "waypointDepthScale = self.waypointDepthScale",
    "waypointRenderScale = self.waypointRenderScale",
    "lastWaypointDistanceReason = self.lastWaypointDistanceReason",
    "lastWaypointDistanceError = self.lastWaypointDistanceError",
)
for fragment in required_compass:
    if fragment not in compass:
        errors.append(f"Compass.lua missing P0145 fragment: {fragment}")

required_theme = (
    "depthNearYards = 120",
    "depthFarYards = 1200",
    "depthNearScale = 1.05",
    "depthFarScale = 0.90",
    "renderScaleMin = 0.90",
    "renderScaleMax = 1.12",
)
for fragment in required_theme:
    if fragment not in theme:
        errors.append(f"Theme.lua missing P0145 token: {fragment}")

for fragment in (
    "debugStatus.waypointDistanceAPIAvailable",
    "debugStatus.waypointDistanceAvailable",
    "debugStatus.waypointDistanceYards",
    "debugStatus.waypointDepthScale",
    "debugStatus.waypointRenderScale",
    "debugStatus.lastWaypointDistanceReason",
    "debugStatus.lastWaypointDistanceError",
    "waypointDistanceCoherent",
    "waypointScaleCoherent",
    "distanceReason=%s",
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing P0145 Compass Check integration: {fragment}")

refresh_start = compass.find("function Compass:RefreshWaypointBearing(reason)")
refresh_end = compass.find("function Compass:RefreshHeading(reason)", refresh_start)
refresh = compass[refresh_start:refresh_end] if refresh_start != -1 and refresh_end != -1 else ""
waypoint_secret_i = refresh.find("if isSecret(waypoint) then")
raw_i = refresh.find("local waypointMapOK, rawWaypointSourceMapID = pcall(function()")
field_i = refresh.find("return waypoint.uiMapID", raw_i)
secret_i = refresh.find("isSecret(rawWaypointSourceMapID)", raw_i)
type_i = refresh.find('type(rawWaypointSourceMapID) == "number"', secret_i)
store_i = refresh.find("self.waypointSourceMapID = rawWaypointSourceMapID", type_i)
if not (
    waypoint_secret_i != -1
    and raw_i != -1
    and field_i != -1
    and secret_i != -1
    and type_i != -1
    and store_i != -1
    and waypoint_secret_i < raw_i < field_i < secret_i < type_i < store_i
):
    errors.append("waypoint uiMapID must be field-read under pcall and secret-checked before type/storage")

bearing_i = refresh.find("self.waypointBearingDegrees = bearingDegrees")
distance_i = refresh.find("self:RefreshWaypointDistance(")
if not (bearing_i != -1 and distance_i != -1 and bearing_i < distance_i):
    errors.append("distance side channel must not precede or own the proven bearing result")

distance_start = compass.find("function Compass:RefreshWaypointDistance(")
distance_end = compass.find("function Compass:UpdateTape(headingDegrees)", distance_start)
distance = compass[distance_start:distance_end] if distance_start != -1 and distance_end != -1 else ""
if "ClearWaypointPresentation" in distance:
    errors.append("distance-only failure must not clear the proven waypoint presentation")
map_mismatch_i = distance.find("waypointSourceMapID ~= mapID")
size_call_i = distance.find("pcall(C_Map.GetMapWorldSize, mapID)")
size_secret_i = distance.find("isSecret(width) or isSecret(height)")
size_type_i = distance.find('type(width) ~= "number"')
math_i = distance.find("local dxYards =")
if not (
    map_mismatch_i != -1
    and size_call_i != -1
    and size_secret_i != -1
    and size_type_i != -1
    and math_i != -1
    and map_mismatch_i < size_call_i < size_secret_i < size_type_i < math_i
):
    errors.append("distance path must gate same-map then secret-check map size before type/math")

marker_start = compass.find("function Compass:UpdateWaypointMarker()")
marker_end = compass.find("function Compass:RefreshWaypointBearing(reason)", marker_start)
marker = compass[marker_start:marker_end] if marker_start != -1 and marker_end != -1 else ""
if (
    "manualWaypointScaleForMagnitude(magnitude)" not in marker
    or "self.waypointDepthScale" not in marker
    or "clamp(" not in marker
):
    errors.append("marker scale must combine existing angular focus with bounded distance depth")

check_start = commands.find("local function runCompassCheck()")
check_end = commands.find("\nlocal CONTEXT_POLICY_ALPHA = {", check_start)
check = commands[check_start:check_end] if check_start != -1 and check_end != -1 else ""
if "C_Map." in check or "GetUserWaypoint(" in check or "GetMapWorldSize(" in check:
    errors.append("Compass Check must consume addon-owned diagnostic state only")

for forbidden in (
    "C_QuestLog.",
    "C_SuperTrack.",
    "C_AreaPoiInfo.",
    "C_Minimap.",
    "waypointDistanceLabel",
    "manualWaypointName",
    "waypointLabel",
    "SetCVar",
):
    if forbidden in compass:
        errors.append(f"Compass.lua exceeds P0145 scope: {forbidden}")

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None
if bootstrap_version != "0.0.70-dev" or toc_version != "0.0.70-dev":
    errors.append(f"P0145 runtime version must be 0.0.70-dev, got {bootstrap_version}/{toc_version}")

print("Logres P0145 manual-waypoint distance/depth contract")
print("====================================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)
print("PASS: 0 errors")
