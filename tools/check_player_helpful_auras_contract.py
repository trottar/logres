#!/usr/bin/env python3
"""Static contract for P0137 production player helpful aura presentation."""

from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"

MODULE = ADDON / "HUD" / "PlayerHelpfulAuras.lua"
THEME = ADDON / "Media" / "Theme.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"
BOOTSTRAP = ADDON / "Core" / "Bootstrap.lua"
FRAME = ADDON / "Media" / "Aura" / "aura_frame_passive.tga"
PLATE = ADDON / "Media" / "Aura" / "aura_count_plate.tga"

errors = []

for path in (
    MODULE,
    THEME,
    COMMANDS,
    TOC,
    BOOTSTRAP,
    FRAME,
    PLATE,
):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

module = MODULE.read_text(encoding="utf-8") if MODULE.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
bootstrap = BOOTSTRAP.read_text(encoding="utf-8") if BOOTSTRAP.is_file() else ""

if FRAME.is_file():
    actual = hashlib.sha256(FRAME.read_bytes()).hexdigest()
    if actual != "8b68872304db73ba607611ba8425cc7127f7adb472d976dba4251c4b2e88dd96":
        errors.append(f"passive aura frame hash mismatch: {actual}")

if PLATE.is_file():
    actual = hashlib.sha256(PLATE.read_bytes()).hexdigest()
    if actual != "a818e99b2eeaea1c071600f57f1a22e386cf460e6090f6d5c22e13e60b532713":
        errors.append(f"aura count plate hash mismatch: {actual}")

for fragment in (
    'Logres:RegisterModule("PlayerHelpfulAuras"',
    'local FILTER = "HELPFUL|PLAYER"',
    "local MAX_SCAN = 6",
    "local MAX_ICONS = 4",
    "C_Secrets.ShouldUnitAuraIndexBeSecret",
    "C_UnitAuras.GetAuraDataByIndex",
    'eventFrame.RegisterUnitEvent',
    '"UNIT_AURA"',
    '"player"',
    '"PLAYER_ENTERING_WORLD"',
    "function HelpfulAuras:ReadSnapshot()",
    "function HelpfulAuras:RenderSnapshot(snapshot, reason)",
    "function HelpfulAuras:SetPreviewEnabled(enabled)",
    "function HelpfulAuras:GetDebugStatus()",
    'eventFrame:SetScript("OnEvent", function(_, event)',
    "UNIT_AURA update payload arguments are deliberately discarded",
):
    if fragment not in module:
        errors.append(f"PlayerHelpfulAuras.lua missing: {fragment}")

for forbidden in (
    '"HARMFUL"',
    '"target"',
    "GetUnitAuras",
    "GetAuraSlots",
    "GetAuraDataBySlot",
    "GetAuraDataByAuraInstanceID",
    "addedAuras",
    "removedAuraInstanceIDs",
    "updatedAuraInstanceIDs",
    "CancelAuraByInstanceID",
    "CancelUnitBuff",
    "UnitAura(",
    'SetScript("OnUpdate"',
    "C_Timer.After",
    "C_Timer.NewTicker",
    "duration",
    "expirationTime",
    "BuffFrame:Hide",
    "BuffFrame:SetAlpha",
    "DebuffFrame:Hide",
    "TargetFrame:Hide",
    "HideUIPanel",
    "SecureActionButtonTemplate",
):
    if forbidden in module:
        errors.append(
            "PlayerHelpfulAuras.lua exceeds P0137 player-helpful boundary: "
            + forbidden
        )

read_start = module.find("local function readAura(index)")
read_end = module.find("function HelpfulAuras:ReadSnapshot()", read_start)
read_block = module[read_start:read_end] if read_start != -1 and read_end != -1 else ""

predicate_call = read_block.find("local predicateOK, predicateResult = pcall(")
predicate_api = read_block.find(
    "C_Secrets.ShouldUnitAuraIndexBeSecret,",
    predicate_call,
)
predicate_secret = read_block.find("if isSecret(predicateResult) then")
predicate_compare = read_block.find("if predicateResult ~= false then")
query_call = read_block.find("local queryOK, aura = pcall(")
query_api = read_block.find(
    "C_UnitAuras.GetAuraDataByIndex,",
    query_call,
)
aura_secret = read_block.find("if isSecret(aura) then")
aura_nil = read_block.find("if aura == nil then")
aura_type = read_block.find('if type(aura) ~= "table" then')
icon_assign = read_block.find("local icon = aura.icon")
icon_secret = read_block.find("if isSecret(icon) then")
icon_nil = read_block.find("if icon == nil then")
icon_type = read_block.find("local iconType = type(icon)")
apps_assign = read_block.find("local applications = aura.applications")
apps_secret = read_block.find("local applicationsSecret = isSecret(applications)")

if not (
    -1 not in (
        predicate_call,
        predicate_api,
        predicate_secret,
        predicate_compare,
        query_call,
        query_api,
        aura_secret,
        aura_nil,
        aura_type,
        icon_assign,
        icon_secret,
        icon_nil,
        icon_type,
        apps_assign,
        apps_secret,
    )
    and predicate_call < predicate_api < predicate_secret
    < predicate_compare < query_call < query_api
    < aura_secret < aura_nil < aura_type
    < icon_assign < icon_secret < icon_nil < icon_type
    < apps_assign < apps_secret
):
    errors.append(
        "PlayerHelpfulAuras read ordering must remain secret-first "
        "from predicate through payload and selected fields"
    )

event_start = module.find(
    'eventFrame:SetScript("OnEvent", function(_, event)'
)
event_end = module.find("self.eventFrame = eventFrame", event_start)
event_block = (
    module[event_start:event_end]
    if event_start != -1 and event_end != -1
    else ""
)
if "..." in event_block or "unitAuraUpdateInfo" in event_block:
    errors.append(
        "PlayerHelpfulAuras event handler must discard UNIT_AURA payload arguments"
    )

for fragment in (
    "theme.playerHelpfulAuras = {",
    "maxIcons = 4",
    "iconSize = 36",
    'frame = MEDIA_ROOT .. "Aura\\\\aura_frame_passive.tga"',
    'countPlate = MEDIA_ROOT .. "Aura\\\\aura_count_plate.tga"',
):
    if fragment not in theme:
        errors.append(f"Theme.lua missing P0137 token/path: {fragment}")

for fragment in (
    "local function runPlayerHelpfulAuraCheck()",
    "local function runPlayerHelpfulAuraPreview(argument)",
    '"Logres helpfulauracheck: %s',
    '"Logres helpfulaurapreview: %s',
    'if command == "helpfulauracheck" then',
    'if command == "helpfulaurapreview" then',
    '"playerHelpfulAuraCheck"',
    '"Player Helpful Aura Check"',
    '"playerHelpfulAuraPreview"',
    '"Player Helpful Aura Preview"',
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing P0137 integration: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
else:
    run_all = commands[run_all_start:run_all_end]
    if "runPlayerHelpfulAuraCheck()" not in run_all:
        errors.append("Run All must include Player Helpful Aura Check")
    if "runPlayerHelpfulAuraPreview" in run_all:
        errors.append("Run All must not toggle the helpful-aura preview")

if "HUD\\PlayerHelpfulAuras.lua" not in toc:
    errors.append("Logres.toc missing HUD\\PlayerHelpfulAuras.lua")
else:
    aura_probe_i = toc.find("HUD\\AuraStatusProbe.lua")
    helpful_i = toc.find("HUD\\PlayerHelpfulAuras.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (
        aura_probe_i != -1
        and helpful_i != -1
        and commands_i != -1
        and aura_probe_i < helpful_i < commands_i
    ):
        errors.append(
            "PlayerHelpfulAuras.lua must load after AuraStatusProbe and before Commands"
        )

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None

if bootstrap_version is None or toc_version is None:
    errors.append("P0137 checker could not read runtime versions")
elif bootstrap_version != toc_version:
    errors.append("Bootstrap and TOC runtime versions must match")

print("Logres P0137 player helpful aura presentation contract")
print("====================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
