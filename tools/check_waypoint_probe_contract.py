#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / "tools" / "probes" / "LogresWaypointAudit" / "LogresWaypointAudit.lua"
TOC = ROOT / "tools" / "probes" / "LogresWaypointAudit" / "LogresWaypointAudit.toc"
README = ROOT / "tools" / "probes" / "LogresWaypointAudit" / "README.md"

errors = []

for path in (PROBE, TOC, README):
    if not path.is_file():
        errors.append(f"missing waypoint probe file: {path.relative_to(ROOT)}")

if PROBE.is_file():
    source = PROBE.read_text(encoding="utf-8")

    required = [
        'SLASH_LOGRESWAYPOINTAUDIT1 = "/lwpa"',
        'C_Map.GetUserWaypoint',
        'C_Map.GetUserWaypointPositionForMap',
        'C_Map.GetBestMapForUnit',
        'C_Map.GetPlayerMapPosition',
        'C_Map.GetWorldPosFromMapPos',
        'C_SuperTrack.GetSuperTrackedQuestID',
        'C_SuperTrack.IsSuperTrackingQuest',
        'C_SuperTrack.IsSuperTrackingUserWaypoint',
        'C_QuestLog.GetNextWaypoint',
        '"SUPER_TRACKING_CHANGED"',
        '"SUPER_TRACKING_PATH_UPDATED"',
        '"USER_WAYPOINT_UPDATED"',
        'local function isSecret(value)',
        'result.secret = isSecret(value)',
        'local function mapBearing(',
        'math.atan2(dx, -dy)',
        'result.positionForPlayerMap',
        'result.mapBearing = mapBearing(',
        'mapBearingText(user.mapBearing)',
        'local function candidateBearings',
        'plusYNorth',
        'minusYNorth',
        'pcall(frame.RegisterEvent, frame, candidate)',
        'LogresWaypointAuditDB.eventCounts',
        'function LogresWaypointAudit_Run(output)',
        'snapshot("developer-panel")',
        'printReport(output)',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"waypoint probe missing: {fragment}")

    forbidden = [
        "C_Map.SetUserWaypoint",
        "C_Map.ClearUserWaypoint",
        "C_SuperTrack.SetSuperTrackedQuestID",
        "C_SuperTrack.SetSuperTrackedUserWaypoint",
        "Minimap:",
        "SendChatMessage",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(f"waypoint probe mutates forbidden surface: {fragment}")

COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

if COMMANDS.is_file():
    commands = COMMANDS.read_text(encoding="utf-8")
    for fragment in (
        "local function runWaypointProbe()",
        'if command == "waypointprobe" then',
        'Logres:RegisterDevPanelAction(',
        '"waypointProbe"',
        '"Waypoint Probe"',
        '"waypointprobe"',
        "LogresWaypointAudit_Run",
    ):
        if fragment not in commands:
            errors.append(
                f"Commands.lua missing waypoint panel integration: {fragment}"
            )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    for fragment in (
        "## Interface: 16001",
        "## SavedVariables: LogresWaypointAuditDB",
        "LogresWaypointAudit.lua",
    ):
        if fragment not in source:
            errors.append(f"waypoint probe TOC missing: {fragment}")

print("Logres E.3 waypoint probe contract")
print("==================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
