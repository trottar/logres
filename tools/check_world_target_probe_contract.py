#!/usr/bin/env python3
"""Static contract for P0140 read-only world-target anchor/reaction probe."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
PROBE = ADDON / "HUD" / "WorldTargetProbe.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"
BOOTSTRAP = ADDON / "Core" / "Bootstrap.lua"
DEV_PANEL_CHECKER = ROOT / "tools" / "check_dev_panel_contract.py"

errors = []

for path in (
    PROBE,
    COMMANDS,
    TOC,
    BOOTSTRAP,
    DEV_PANEL_CHECKER,
):
    if not path.is_file():
        errors.append(
            f"missing required file: {path.relative_to(ROOT)}"
        )

probe = PROBE.read_text(encoding="utf-8") if PROBE.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
bootstrap = BOOTSTRAP.read_text(encoding="utf-8") if BOOTSTRAP.is_file() else ""
dev_checker = (
    DEV_PANEL_CHECKER.read_text(encoding="utf-8")
    if DEV_PANEL_CHECKER.is_file()
    else ""
)

required_probe = (
    'Logres:RegisterModule("WorldTargetProbe"',
    '"PLAYER_TARGET_CHANGED"',
    '"NAME_PLATE_UNIT_ADDED"',
    '"NAME_PLATE_UNIT_REMOVED"',
    '"NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED"',
    '"PLAYER_ENTERING_WORLD"',
    "C_NamePlate.GetNamePlateForUnit",
    "C_NamePlateManager.IsNamePlateUnitBehindCamera",
    "UnitReaction",
    "UnitCanAttack",
    "UnitIsFriend",
    "UnitIsTrivial",
    "InCombatLockdown",
    'CreateFrame("Frame", nil, UIParent)',
    "self.anchorProxy.SetPoint",
    "self.anchorProxy.ClearAllPoints",
    "function Probe:CaptureManual()",
    "function Probe:GetDiagnosticLines()",
    "function Probe:GetDebugStatus()",
    'eventFrame:SetScript("OnEvent", function(_, event)',
)

for fragment in required_probe:
    if fragment not in probe:
        errors.append(
            f"WorldTargetProbe.lua missing contract fragment: {fragment}"
        )

for forbidden in (
    "GetNamePlates",
    "FORBIDDEN_NAME_PLATE",
    "UnitLevel",
    "UnitClassification",
    "UnitIsBossMob",
    "UnitSelectionType",
    "UnitSelectionColor",
    "UnitThreatSituation",
    "UnitDetailedThreatSituation",
    "SetCVar",
    "GetCVar",
    "SetParent",
    'SetScript("OnUpdate"',
    "C_Timer.After",
    "C_Timer.NewTicker",
    "SecureActionButtonTemplate",
    "TargetFrame:Hide",
    "NamePlateDriverFrame",
):
    if forbidden in probe:
        errors.append(
            "WorldTargetProbe.lua contains forbidden inspection/mutation/"
            f"polling fragment: {forbidden}"
        )

ordinary_start = probe.find("local function callOrdinary(api, ...)")
ordinary_end = probe.find("local function readBoolean", ordinary_start)
ordinary = (
    probe[ordinary_start:ordinary_end]
    if ordinary_start != -1 and ordinary_end != -1
    else ""
)
call_i = ordinary.find("local ok, value = pcall(api, ...)")
secret_i = ordinary.find("local secret = isSecret(value)")
nil_i = ordinary.find("if value == nil then")
if not (
    call_i != -1
    and secret_i != -1
    and nil_i != -1
    and call_i < secret_i < nil_i
):
    errors.append(
        "callOrdinary must secret-check returned values before nil inspection"
    )

nameplate_start = probe.find("local function readNameplate()")
nameplate_end = probe.find("local function readBehindCamera", nameplate_start)
nameplate = (
    probe[nameplate_start:nameplate_end]
    if nameplate_start != -1 and nameplate_end != -1
    else ""
)
if '"target",\n        false' not in nameplate:
    errors.append(
        "readNameplate must query target with includeForbidden=false"
    )
if "true" in nameplate:
    errors.append(
        "readNameplate must never request includeForbidden=true"
    )

capture_start = probe.find("function Probe:Capture(reason)")
capture_end = probe.find("function Probe:CaptureManual()", capture_start)
capture = (
    probe[capture_start:capture_end]
    if capture_start != -1 and capture_end != -1
    else ""
)
anchor_i = capture.find("local anchor, anchorFrame = readNameplate()")
behind_i = capture.find("behind = readBehindCamera()")
attach_i = capture.find("attachment = self:TestAttachment(anchorFrame)")
if not (
    anchor_i != -1
    and behind_i != -1
    and attach_i != -1
    and anchor_i < behind_i < attach_i
):
    errors.append(
        "capture must establish accessible anchor, then behind-camera state, "
        "then attachment"
    )

attach_start = probe.find("function Probe:TestAttachment(anchorFrame)")
attach_end = probe.find("local function attachmentState", attach_start)
attach = (
    probe[attach_start:attach_end]
    if attach_start != -1 and attach_end != -1
    else ""
)
combat_i = attach.find("local combat = readBoolean(InCombatLockdown)")
set_i = attach.find("self.anchorProxy.SetPoint")
clear_i = attach.find("self.anchorProxy.ClearAllPoints", set_i)
if not (
    combat_i != -1
    and set_i != -1
    and clear_i != -1
    and combat_i < set_i < clear_i
):
    errors.append(
        "attachment test must check combat first and immediately detach after SetPoint"
    )

if "anchorFrame:" in probe:
    errors.append(
        "probe must not call methods on the returned Blizzard nameplate frame"
    )

if "self.anchorProxy:SetPoint" in probe:
    errors.append(
        "attachment SetPoint should stay behind pcall"
    )

for api in (
    "UnitReaction",
    "UnitCanAttack",
    "UnitIsFriend",
    "UnitIsTrivial",
):
    if api not in probe:
        errors.append(f"missing reaction/triviality source: {api}")

for fragment in (
    "local function runWorldTargetProbe()",
    'Logres:GetModuleStatus("WorldTargetProbe")',
    'Logres:GetModule("WorldTargetProbe")',
    'if command == "worldtargetprobe" then',
    'emit("  /logres worldtargetprobe")',
    '"worldTargetProbe"',
    '"World Target Probe"',
    '"worldtargetprobe"',
    '"H"',
):
    if fragment not in commands:
        errors.append(
            f"Commands.lua missing P0140 integration: {fragment}"
        )

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find(
    "local function handleHUDPreview",
    run_all_start,
)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
elif (
    "runWorldTargetProbe()"
    in commands[run_all_start:run_all_end]
):
    errors.append(
        "contextual world-target probe must not run inside checkall"
    )

if "HUD\\WorldTargetProbe.lua" not in toc:
    errors.append("Logres.toc missing HUD\\WorldTargetProbe.lua")
else:
    probe_i = toc.find("HUD\\WorldTargetProbe.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (
        probe_i != -1
        and commands_i != -1
        and probe_i < commands_i
    ):
        errors.append(
            "WorldTargetProbe.lua must load before Commands.lua"
        )

bootstrap_match = re.search(
    r'Logres\.VERSION = "([^"]+)"',
    bootstrap,
)
toc_match = re.search(
    r"^## Version: (.+)$",
    toc,
    re.MULTILINE,
)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None
if bootstrap_version is None or toc_version is None:
    errors.append(
        "P0140 checker could not read runtime versions"
    )
elif bootstrap_version != toc_version:
    errors.append(
        "Bootstrap and TOC runtime versions must match"
    )

if '"worldTargetProbe": "H"' not in dev_checker:
    errors.append(
        "check_dev_panel_contract.py missing Phase-H worldTargetProbe"
    )

print("Logres P0140 world-target read-only probe contract")
print("================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
