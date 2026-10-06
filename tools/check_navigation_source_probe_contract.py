#!/usr/bin/env python3
"""Static contract checks for P0143 read-only navigation-source runtime probe."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
PROBE = ROOT / "Logres" / "Navigation" / "NavigationSourceProbe.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
DEV_CHECKER = ROOT / "tools" / "check_dev_panel_contract.py"

errors = []

for path in (PROBE, COMMANDS, TOC, BOOTSTRAP, DEV_CHECKER):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

probe = PROBE.read_text(encoding="utf-8") if PROBE.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
bootstrap = BOOTSTRAP.read_text(encoding="utf-8") if BOOTSTRAP.is_file() else ""
dev_checker = DEV_CHECKER.read_text(encoding="utf-8") if DEV_CHECKER.is_file() else ""

required_probe = [
    'Logres:RegisterModule("NavigationSourceProbe"',
    "local MAX_TRACKING_TYPES = 48",
    "local MAX_AREA_POIS = 24",
    'type(issecretvalue) == "function"',
    "function Probe:Capture(reason)",
    "function Probe:CaptureManual()",
    "function Probe:GetDiagnosticLines()",
    "function Probe:GetDebugStatus()",
    'eventFrame:SetScript("OnEvent", function(_, event)',
    '"MINIMAP_UPDATE_TRACKING"',
    '"AREA_POIS_UPDATED"',
    '"SUPER_TRACKING_CHANGED"',
    '"SUPER_TRACKING_PATH_UPDATED"',
    '"QUEST_LOG_UPDATE"',
    '"PLAYER_MAP_CHANGED"',
    '"PLAYER_ENTERING_WORLD"',
    "C_Minimap.GetNumTrackingTypes",
    "C_Minimap.GetTrackingInfo",
    "C_Minimap.GetTrackingFilter",
    "C_Minimap.GetViewRadius",
    "C_Minimap.GetUiMapID",
    "C_Map.GetBestMapForUnit",
    "C_Map.GetPlayerMapPosition",
    "C_Map.GetMapWorldSize",
    "C_AreaPoiInfo.GetAreaPOIForMap",
    "C_AreaPoiInfo.GetAreaPOIInfo",
    "C_SuperTrack.IsSuperTrackingAnything",
    "C_SuperTrack.IsSuperTrackingQuest",
    "C_SuperTrack.IsSuperTrackingUserWaypoint",
    "C_SuperTrack.GetSuperTrackedQuestID",
    "C_Navigation.GetNextWaypointForMap",
    "C_QuestLog.GetNextWaypoint",
    "C_QuestLog.GetNextWaypointForMap",
    "self:DistanceYards",
    "self.secretSkipCount",
    "self.failureCount",
]

for fragment in required_probe:
    if fragment not in probe:
        errors.append(f"NavigationSourceProbe.lua missing: {fragment}")

forbidden_probe = [
    "C_Minimap.SetTracking",
    "C_Minimap.ClearAllTracking",
    "C_Map.SetUserWaypoint",
    "C_Map.ClearUserWaypoint",
    "C_SuperTrack.Set",
    "C_SuperTrack.Clear",
    "SetCVar",
    "SetZoom",
    "PingLocation",
    "EnumeratePins",
    "AcquirePin",
    "hooksecurefunc",
    "C_Timer",
    'SetScript("OnUpdate"',
    "RegisterUnitEvent",
]

for fragment in forbidden_probe:
    if fragment in probe:
        errors.append(f"NavigationSourceProbe.lua forbidden mutation/hook: {fragment}")

if "ipairs(ordinaryIDs)" in probe or "#ordinaryIDs" in probe:
    errors.append("AreaPOI ID table must be bounded by fixed index, not iterated/counted")

event_handler = re.search(
    r'eventFrame:SetScript\("OnEvent", function\(_, event\)(.*?)\n    end\)',
    probe,
    flags=re.S,
)
if not event_handler:
    errors.append("event handler could not be isolated")
elif "..." in event_handler.group(1):
    errors.append("event handler must discard event payloads")

raw_id_secret = probe.find("if isSecret(rawID) then")
raw_id_nil = probe.find("elseif rawID == nil then")
if raw_id_secret == -1 or raw_id_nil == -1 or raw_id_secret > raw_id_nil:
    errors.append("AreaPOI IDs must be secret-preflighted before nil/type inspection")

for fragment in (
    "local function runNavigationSourceProbe()",
    'Logres:GetModuleStatus("NavigationSourceProbe")',
    'Logres:GetModule("NavigationSourceProbe")',
    'if command == "navigationsourceprobe" then',
    'emit("  /logres navigationsourceprobe")',
    '"navigationSourceProbe"',
    '"Navigation Source Probe"',
    '"navigationsourceprobe"',
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing navigation-probe integration: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
if run_all_start == -1 or run_all_end == -1:
    errors.append("runAllChecks block could not be isolated")
else:
    run_all = commands[run_all_start:run_all_end]
    if "runNavigationSourceProbe" in run_all:
        errors.append("contextual navigation source probe must not be included in Run All")

if "Navigation\\NavigationSourceProbe.lua" not in toc:
    errors.append("Logres.toc missing NavigationSourceProbe.lua")
else:
    compass_index = toc.find("Navigation\\Compass.lua")
    probe_index = toc.find("Navigation\\NavigationSourceProbe.lua")
    quest_index = toc.find("Quest\\ContextVisual.lua")
    if not (compass_index < probe_index < quest_index):
        errors.append("NavigationSourceProbe.lua must load after Compass and before Quest modules")

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None
if bootstrap_version is None or toc_version is None:
    errors.append("P0143 checker could not read runtime versions")
elif bootstrap_version != toc_version:
    errors.append("Bootstrap and TOC runtime versions must match")

if '"navigationSourceProbe": "H"' not in dev_checker:
    errors.append("developer-panel contract missing navigationSourceProbe Phase H expectation")

print("Logres navigation source probe contract")
print("=======================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
