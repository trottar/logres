#!/usr/bin/env python3
"""Static contract for P0150 R1 class/pet/special-control read-only probe."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
PROBE = ADDON / "HUD" / "ClassPetSpecialProbe.lua"
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
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

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
    'Logres:RegisterModule("ClassPetSpecialProbe"',
    "local MAX_PET_SLOTS = 10",
    "local MAX_STANCE_SLOTS = 10",
    "local MAX_TOTEM_SLOTS = 8",
    "local MAX_CHARGED_POINTS = 10",
    "local MAX_RUNES = 6",
    '"PET_BAR_UPDATE"',
    '"UNIT_PET"',
    '"UPDATE_SHAPESHIFT_FORMS"',
    '"PLAYER_TOTEM_UPDATE"',
    '"RUNE_POWER_UPDATE"',
    '"UNIT_POWER_FREQUENT"',
    '"UNIT_MAXPOWER"',
    '"UNIT_POWER_POINT_CHARGE"',
    '"UPDATE_POSSESS_BAR"',
    '"UPDATE_OVERRIDE_ACTIONBAR"',
    '"UPDATE_VEHICLE_ACTIONBAR"',
    '"UPDATE_EXTRA_ACTIONBAR"',
    '"PLAYER_ENTERING_WORLD"',
    "PetHasActionBar",
    "GetPetActionInfo",
    "GetPetActionCooldown",
    "GetPetActionSlotUsable",
    "GetNumShapeshiftForms",
    "GetShapeshiftFormInfo",
    "GetShapeshiftFormCooldown",
    "GetNumTotemSlots",
    "GetTotemInfo",
    "GetTotemTimeLeft",
    "GetTotemCannotDismiss",
    "UnitClass",
    "UnitPowerType",
    "UnitPower",
    "UnitPowerMax",
    "GetUnitChargedPowerPoints",
    "GetRuneCooldown",
    "C_ActionBar.IsPossessBarVisible",
    "C_ActionBar.HasVehicleActionBar",
    "C_ActionBar.GetVehicleBarIndex",
    "C_ActionBar.HasOverrideActionBar",
    "C_ActionBar.GetOverrideBarIndex",
    "C_ActionBar.HasTempShapeshiftActionBar",
    "C_ActionBar.GetTempShapeshiftBarIndex",
    "C_ActionBar.HasExtraActionBar",
    "function Probe:CaptureAll(reason)",
    "function Probe:CaptureDomain(domain, reason)",
    "function Probe:CaptureManual()",
    "function Probe:GetDiagnosticLines()",
    "function Probe:GetDebugStatus()",
    'eventFrame:SetScript("OnEvent", function(_, event)',
)

for fragment in required_probe:
    if fragment not in probe:
        errors.append(
            f"ClassPetSpecialProbe.lua missing contract fragment: {fragment}"
        )

for forbidden in (
    "CastPetAction",
    "TogglePetAutocast",
    "PickupPetAction",
    "CastShapeshiftForm",
    "DestroyTotem",
    "SetActionBarPage",
    "VehicleExit",
    "TaxiRequestEarlyLanding",
    "CancelPetPossess",
    "UseAction(",
    "RegisterStateDriver",
    "UnregisterStateDriver",
    "SecureActionButtonTemplate",
    "SetAttribute(\"actionpage\"",
    ":Hide(",
    ":SetAlpha(",
    'SetScript("OnUpdate"',
    "C_Timer.After",
    "C_Timer.NewTimer",
    "C_Timer.NewTicker",
    "PetActionBar:",
    "StanceBar:",
    "TotemFrame:",
    "RuneFrame:",
    "PetFrame:",
    "OverrideActionBar:",
    "PossessActionBar:",
    "ExtraActionBar:",
):
    if forbidden in probe:
        errors.append(
            "ClassPetSpecialProbe.lua contains forbidden mutation/polling/"
            f"presentation fragment: {forbidden}"
        )

ordinary_start = probe.find("local function ordinaryField(owner, value, expectedType, label)")
ordinary_end = probe.find("local function call(owner, label, api, ...)", ordinary_start)
ordinary = (
    probe[ordinary_start:ordinary_end]
    if ordinary_start != -1 and ordinary_end != -1
    else ""
)
secret_i = ordinary.find("if isSecret(value) then")
nil_i = ordinary.find("if value == nil then")
type_i = ordinary.find("local valueType = type(value)")
if not (
    secret_i != -1
    and nil_i != -1
    and type_i != -1
    and secret_i < nil_i < type_i
):
    errors.append(
        "ordinaryField must secret-check before nil/type inspection"
    )

pet_start = probe.find("local function readPet()")
pet_end = probe.find("local function readStance()", pet_start)
pet = (
    probe[pet_start:pet_end]
    if pet_start != -1 and pet_end != -1
    else ""
)
expected_is_token = 'row.isToken = ordinaryField(\n                result,\n                rawIsToken,\n                nil,\n                "pet.isToken"\n            )'
if expected_is_token not in pet:
    errors.append(
        "pet isToken must remain an opaque secret-first value; Forever returned numeric values in P0150 initial runtime"
    )
if 'rawIsToken,\n                "boolean",\n                "pet.isToken"' in pet:
    errors.append(
        "pet isToken must not be forced to boolean"
    )

debug_start = probe.find("function Probe:GetDebugStatus()")
debug_end = probe.find("function Probe:OnInitialize()", debug_start)
debug = (
    probe[debug_start:debug_end]
    if debug_start != -1 and debug_end != -1
    else ""
)
for field in (
    "possess",
    "vehicle",
    "override",
    "tempShapeshift",
    "extra",
):
    expected = f"{field} = self.special and self.special.{field},"
    if expected not in debug:
        errors.append(
            f"GetDebugStatus must preserve false special-mode value for {field}"
        )
    if f"{field} = self.special and self.special.{field} or nil" in debug:
        errors.append(
            f"GetDebugStatus must not collapse false to nil for {field}"
        )

charged_start = probe.find("local function readChargedPoints(result)")
charged_end = probe.find("local function readRunes", charged_start)
charged = (
    probe[charged_start:charged_end]
    if charged_start != -1 and charged_end != -1
    else ""
)
for forbidden in ("#points", "pairs(points)", "ipairs(points)"):
    if forbidden in charged:
        errors.append(
            "charged-point result must use bounded fixed-index secret-first reads: "
            + forbidden
        )
raw_i = charged.find("local rawPoint = points[index]")
secret_point_i = charged.find("if isSecret(rawPoint) then")
nil_point_i = charged.find("elseif rawPoint == nil then")
type_point_i = charged.find('elseif type(rawPoint) ~= "number" then')
if not (
    raw_i != -1
    and secret_point_i != -1
    and nil_point_i != -1
    and type_point_i != -1
    and raw_i < secret_point_i < nil_point_i < type_point_i
):
    errors.append(
        "charged-point entries must be secret-checked before nil/type inspection"
    )

totem_start = probe.find("local function readTotem()")
totem_end = probe.find("local function classResourceType", totem_start)
totem = (
    probe[totem_start:totem_end]
    if totem_start != -1 and totem_end != -1
    else ""
)
for label, fragment in (
    ("haveTotem", "row.haveTotem, haveTotemState = ordinaryField("),
    ("name", "row.name = ordinaryField("),
    ("timeLeft", "row.timeLeft = ordinaryField("),
):
    if fragment not in totem:
        errors.append(
            "totem secret-capable results must flow through ordinaryField: " + label
        )

runes_start = probe.find("local function readRunes(result, classFilename)")
runes_end = probe.find("local function readResource()", runes_start)
runes = (
    probe[runes_start:runes_end]
    if runes_start != -1 and runes_end != -1
    else ""
)
if 'if classFilename ~= "DEATHKNIGHT" then' not in runes:
    errors.append("rune cooldown reads must remain naturally class-gated")
if "for runeIndex = 1, MAX_RUNES do" not in runes:
    errors.append("rune scan must remain fixed at MAX_RUNES")

for function_name, limit_name in (
    ("readPet", "MAX_PET_SLOTS"),
    ("readStance", "MAX_STANCE_SLOTS"),
    ("readTotem", "MAX_TOTEM_SLOTS"),
):
    start = probe.find(f"local function {function_name}()")
    if start == -1:
        continue
    next_start = probe.find("local function ", start + 15)
    block = probe[start: next_start if next_start != -1 else len(probe)]
    if limit_name not in block:
        errors.append(f"{function_name} must remain bounded by {limit_name}")

for fragment in (
    "local function runClassPetSpecialProbe()",
    'Logres:GetModuleStatus("ClassPetSpecialProbe")',
    'Logres:GetModule("ClassPetSpecialProbe")',
    'if command == "classpetspecialprobe" then',
    'emit("  /logres classpetspecialprobe")',
    '"classPetSpecialProbe"',
    '"Class / Pet / Special Probe"',
    '"classpetspecialprobe"',
    '"H"',
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing P0150 integration: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
elif "runClassPetSpecialProbe()" in commands[run_all_start:run_all_end]:
    errors.append("contextual class/pet/special probe must not run inside checkall")

if "HUD\\ClassPetSpecialProbe.lua" not in toc:
    errors.append("Logres.toc missing HUD\\ClassPetSpecialProbe.lua")
else:
    probe_i = toc.find("HUD\\ClassPetSpecialProbe.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (probe_i != -1 and commands_i != -1 and probe_i < commands_i):
        errors.append("ClassPetSpecialProbe.lua must load before Commands.lua")

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None
if bootstrap_version is None or toc_version is None:
    errors.append("P0150 checker could not read runtime versions")
elif bootstrap_version != toc_version:
    errors.append("Bootstrap and TOC runtime versions must match")
elif bootstrap_version != "0.0.73-dev":
    errors.append(
        f"P0150 runtime version must be 0.0.73-dev, got {bootstrap_version}"
    )

if '"classPetSpecialProbe": "H"' not in dev_checker:
    errors.append(
        "check_dev_panel_contract.py missing Phase-H classPetSpecialProbe"
    )

print("Logres P0150 class/pet/special read-only probe contract")
print("=====================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
