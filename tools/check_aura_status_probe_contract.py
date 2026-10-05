#!/usr/bin/env python3
"""Static contract for P0136 read-only player/target aura-status probe."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
PROBE = ADDON / "HUD" / "AuraStatusProbe.lua"
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
commands = (
    COMMANDS.read_text(encoding="utf-8")
    if COMMANDS.is_file()
    else ""
)
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
bootstrap = (
    BOOTSTRAP.read_text(encoding="utf-8")
    if BOOTSTRAP.is_file()
    else ""
)
dev_checker = (
    DEV_PANEL_CHECKER.read_text(encoding="utf-8")
    if DEV_PANEL_CHECKER.is_file()
    else ""
)

required_probe = (
    'Logres:RegisterModule("AuraStatusProbe"',
    "local MAX_INDEX = 6",
    '{ id = "helpful", filter = "HELPFUL" }',
    '{ id = "harmful", filter = "HARMFUL" }',
    '"HARMFUL|CROWD_CONTROL"',
    '"HARMFUL|RAID"',
    '"HELPFUL|PLAYER"',
    '"HARMFUL|PLAYER"',
    '"HELPFUL|DISPELLABLE"',
    '"HELPFUL|IMPORTANT"',
    '"HELPFUL|BIG_DEFENSIVE"',
    "C_Secrets.ShouldUnitAuraIndexBeSecret",
    "C_UnitAuras.GetAuraDataByIndex",
    'eventFrame.RegisterUnitEvent',
    '"UNIT_AURA"',
    '"player"',
    '"target"',
    '"PLAYER_TARGET_CHANGED"',
    '"PLAYER_ENTERING_WORLD"',
    "function Probe:CaptureManual()",
    "function Probe:GetDiagnosticLines()",
    "function Probe:GetDebugStatus()",
    'eventFrame:SetScript("OnEvent", function(_, event)',
)

for fragment in required_probe:
    if fragment not in probe:
        errors.append(
            f"AuraStatusProbe.lua missing contract fragment: {fragment}"
        )

for forbidden in (
    "GetUnitAuras",
    "GetAuraSlots",
    "GetAuraDataBySlot",
    "GetAuraDataByAuraInstanceID",
    "unitAuraUpdateInfo",
    "addedAuras",
    "removedAuraInstanceIDs",
    "updatedAuraInstanceIDs",
    "CancelAuraByInstanceID",
    "CancelUnitBuff",
    "UnitAura(",
    'SetScript("OnUpdate"',
    "C_Timer.After",
    "C_Timer.NewTicker",
    "BuffFrame:Hide",
    "DebuffFrame:Hide",
    "TargetFrame:Hide",
    "HideUIPanel",
    "SecureActionButtonTemplate",
):
    if forbidden in probe:
        errors.append(
            "AuraStatusProbe.lua contains forbidden bulk/delta/"
            f"mutation/suppression/polling fragment: {forbidden}"
        )

scalar_start = probe.find("local function scalarRecord(value)")
scalar_end = probe.find("local function sanitizeAura", scalar_start)
scalar = (
    probe[scalar_start:scalar_end]
    if scalar_start != -1 and scalar_end != -1
    else ""
)
secret_i = scalar.find("local secret = isSecret(value)")
nil_i = scalar.find("if value == nil then")
type_i = scalar.find("local valueType = type(value)")
if not (
    secret_i != -1
    and nil_i != -1
    and type_i != -1
    and secret_i < nil_i < type_i
):
    errors.append(
        "scalarRecord must secret-check before nil/type inspection"
    )

read_start = probe.find("local function readAuraIndex(")
read_end = probe.find("local function newFieldStats", read_start)
read_block = (
    probe[read_start:read_end]
    if read_start != -1 and read_end != -1
    else ""
)

predicate_call_i = read_block.find(
    "local predicateOK, predicateResult = pcall("
)
predicate_api_i = read_block.find(
    "C_Secrets.ShouldUnitAuraIndexBeSecret,",
    predicate_call_i,
)
predicate_secret_i = read_block.find(
    "local predicateResultSecret = isSecret(predicateResult)"
)
predicate_compare_i = read_block.find(
    "if predicateResult ~= false then"
)
query_call_i = read_block.find(
    "local queryOK, aura = pcall("
)
query_api_i = read_block.find(
    "C_UnitAuras.GetAuraDataByIndex,",
    query_call_i,
)
aura_secret_i = read_block.find(
    "local auraSecret = isSecret(aura)"
)
aura_nil_i = read_block.find("if aura == nil then")
aura_type_i = read_block.find("local auraType = type(aura)")

if not (
    predicate_call_i != -1
    and predicate_api_i != -1
    and predicate_secret_i != -1
    and predicate_compare_i != -1
    and query_call_i != -1
    and query_api_i != -1
    and predicate_call_i
        < predicate_api_i
        < predicate_secret_i
        < predicate_compare_i
        < query_call_i
        < query_api_i
):
    errors.append(
        "readAuraIndex must preflight and secret-check predicate "
        "before any aura payload query"
    )

if not (
    query_call_i != -1
    and query_api_i != -1
    and aura_secret_i != -1
    and aura_nil_i != -1
    and aura_type_i != -1
    and query_call_i
        < query_api_i
        < aura_secret_i
        < aura_nil_i
        < aura_type_i
):
    errors.append(
        "readAuraIndex must secret-check aura payload before "
        "nil/type inspection"
    )

event_start = probe.find(
    'eventFrame:SetScript("OnEvent", function(_, event)'
)
event_end = probe.find(
    "self.eventFrame = eventFrame",
    event_start,
)
event_block = (
    probe[event_start:event_end]
    if event_start != -1 and event_end != -1
    else ""
)
if "..." in event_block:
    errors.append(
        "UNIT_AURA event handler must discard update payload arguments"
    )

for fragment in (
    "local function runAuraStatusProbe()",
    'Logres:GetModuleStatus("AuraStatusProbe")',
    'Logres:GetModule("AuraStatusProbe")',
    'if command == "aurastatusprobe" then',
    'emit("  /logres aurastatusprobe")',
    '"auraStatusProbe"',
    '"Aura Status Probe"',
    '"aurastatusprobe"',
    '"H"',
):
    if fragment not in commands:
        errors.append(
            f"Commands.lua missing P0136 integration: {fragment}"
        )

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find(
    "local function handleHUDPreview",
    run_all_start,
)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
elif (
    "runAuraStatusProbe()"
    in commands[run_all_start:run_all_end]
):
    errors.append(
        "contextual aura/status probe must not run inside checkall"
    )

if "HUD\\AuraStatusProbe.lua" not in toc:
    errors.append("Logres.toc missing HUD\\AuraStatusProbe.lua")
else:
    probe_i = toc.find("HUD\\AuraStatusProbe.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (
        probe_i != -1
        and commands_i != -1
        and probe_i < commands_i
    ):
        errors.append(
            "AuraStatusProbe.lua must load before Commands.lua"
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
bootstrap_version = (
    bootstrap_match.group(1)
    if bootstrap_match
    else None
)
toc_version = (
    toc_match.group(1).strip()
    if toc_match
    else None
)
if bootstrap_version is None or toc_version is None:
    errors.append(
        "P0136 checker could not read runtime versions"
    )
elif bootstrap_version != toc_version:
    errors.append(
        "Bootstrap and TOC runtime versions must match"
    )

if '"auraStatusProbe": "H"' not in dev_checker:
    errors.append(
        "check_dev_panel_contract.py missing Phase-H auraStatusProbe"
    )

print("Logres P0136 aura/status read-only probe contract")
print("==============================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
