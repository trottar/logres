#!/usr/bin/env python3
"""Static checks for the P0123 approved compass visual translation."""

from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
COMPASS = ROOT / "Logres" / "Navigation" / "Compass.lua"
THEME = ROOT / "Logres" / "Media" / "Theme.lua"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
TOC = ROOT / "Logres" / "Logres.toc"

ASSETS = {
    "Logres/Media/Compass/compass_baseline.tga": "8177abd69492813094b742b01ebfb35f1780c95032cf1d33b0ece6dc57974440",
    "Logres/Media/Compass/compass_center.tga": "8245056dbbe79e0b2f38d606de0cb0a1af31d970f5863accdcac4e287971d7ab",
    "Logres/Media/Compass/compass_tick_cardinal.tga": "39674bc269b14323d08731e55959df3f9f120dc59b57be491f53229f99d80ee2",
    "Logres/Media/Compass/compass_tick_intercardinal.tga": "75d40e22cc9bcee221f5f4cf3006b73a4f226daec970d44062314f57f653b543",
    "Logres/Media/Compass/compass_manual_waypoint.tga": "822af5e20d2e6883a0fc0d4f677b28b2c5e1cbf49642cf122210eff5e684ef2a",
}

errors = []

for path in (COMPASS, THEME, BOOTSTRAP, TOC):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

for relative, expected in ASSETS.items():
    path = ROOT / relative
    if not path.is_file():
        errors.append(f"missing compass media: {relative}")
        continue
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(
            f"compass media hash mismatch: {relative} {actual} != {expected}"
        )

if THEME.is_file():
    source = THEME.read_text(encoding="utf-8")
    required = [
        "theme.compass = {",
        "edgeFadeStart = 78",
        "focusAngle = 8",
        "focusScale = 1.07",
        'baseline = MEDIA_ROOT .. "Compass\\\\compass_baseline.tga"',
        'center = MEDIA_ROOT .. "Compass\\\\compass_center.tga"',
        'cardinalTick = MEDIA_ROOT .. "Compass\\\\compass_tick_cardinal.tga"',
        'intercardinalTick = MEDIA_ROOT .. "Compass\\\\compass_tick_intercardinal.tga"',
        'manualWaypoint = MEDIA_ROOT .. "Compass\\\\compass_manual_waypoint.tga"',
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Theme.lua missing compass token/path: {fragment}")

if COMPASS.is_file():
    source = COMPASS.read_text(encoding="utf-8")
    required = [
        "local compassStyle =",
        "local compassAssets = compassStyle.assets or {}",
        "local EDGE_FADE_START = compassStyle.edgeFadeStart or 78",
        "local MANUAL_FOCUS_ANGLE = manualWaypointStyle.focusAngle or 8",
        "baseline:SetTexture(compassAssets.baseline)",
        "center:SetTexture(compassAssets.center)",
        "tick:SetTexture(",
        "waypointMarker:SetTexture(compassAssets.manualWaypoint)",
        "local function edgeFadeForMagnitude(magnitude)",
        "local function manualWaypointScaleForMagnitude(magnitude)",
        "self.waypointMarker:SetAlpha(edgeAlpha)",
        "self.waypointMarker:SetSize(",
        'self.waypointMarker:SetPoint(',
        '"BOTTOM",',
        "waypointMarkerReady = self.waypointMarker ~= nil",
    ]
    for fragment in required:
        if fragment not in source:
            errors.append(f"Compass.lua missing P0123 visual fragment: {fragment}")

    forbidden = [
        "waypointCap",
        "C_QuestLog.",
        "C_SuperTrack.",
        "GetNextWaypoint",
        "SUPER_TRACKING_CHANGED",
        "SUPER_TRACKING_PATH_UPDATED",
        "C_Map.GetWorldPosFromMapPos",
    ]
    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "P0123 must remain manual-waypoint/source-gated: "
                f"unexpected {fragment}"
            )

    # P0123 may style the proven manual bearing only. It must not add fabricated
    # map-coordinate distance/depth semantics or a manual identity label.
    for fragment in (
        "waypointDistance",
        "distanceScale",
        "manualWaypointName",
        "waypointLabel",
    ):
        if fragment in source:
            errors.append(
                "P0123 exceeds proven manual-waypoint data: "
                f"unexpected {fragment}"
            )

bootstrap_version = None
toc_version = None

if BOOTSTRAP.is_file():
    source = BOOTSTRAP.read_text(encoding="utf-8")
    match = re.search(r'Logres\.VERSION = "([^"]+)"', source)
    if match:
        bootstrap_version = match.group(1)
    else:
        errors.append("Bootstrap.lua missing Logres.VERSION")

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    match = re.search(r"^## Version: (.+)$", source, re.MULTILINE)
    if match:
        toc_version = match.group(1).strip()
    else:
        errors.append("Logres.toc missing Version metadata")

if (
    bootstrap_version is not None
    and toc_version is not None
    and bootstrap_version != toc_version
):
    errors.append(
        "Bootstrap and TOC runtime versions must match: "
        f"{bootstrap_version} != {toc_version}"
    )

print("Logres compass visual contract")
print("=============================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
