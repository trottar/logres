#!/usr/bin/env python3
"""Static contract for P0129 read-only NPC quest interaction probe."""

from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
PROBE = ADDON / "Quest" / "InteractionProbe.lua"
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

for fragment in (
    'Logres:RegisterModule("QuestInteractionProbe"',
    'GOSSIP_SHOW = true',
    '"GOSSIP_CLOSED"',
    '"QUEST_DETAIL"',
    '"QUEST_PROGRESS"',
    '"QUEST_COMPLETE"',
    '"QUEST_FINISHED"',
    'local function scalarRecord(value)',
    'local secret = isSecret(value)',
    'local rawSecret = isSecret(raw)',
    'local rowSecret = isSecret(row)',
    'local extraSecret = isSecret(extra)',
    'GetQuestID',
    'GetTitleText',
    'GetQuestText',
    'GetObjectiveText',
    'GetProgressText',
    'GetRewardText',
    'GetRewardXP',
    'GetNumQuestChoices',
    'GetNumQuestRewards',
    'GetQuestItemInfo',
    'GetQuestItemLink',
    'C_QuestInfoSystem.GetQuestRewardCurrencies',
    'C_QuestInfoSystem.GetQuestRewardSpells',
    'C_GossipInfo.GetAvailableQuests',
    'C_GossipInfo.GetActiveQuests',
    'C_GossipInfo.GetOptions',
    'type(AcceptQuest) == "function"',
    'type(DeclineQuest) == "function"',
    'type(CompleteQuest) == "function"',
    'type(GetQuestReward) == "function"',
    'C_GossipInfo.SelectAvailableQuest',
    'C_GossipInfo.SelectActiveQuest',
    'C_GossipInfo.SelectOption',
    'C_GossipInfo.SelectOptionByIndex',
    'self.mutationCallCount = 0',
    'function Probe:CaptureManual()',
    'function Probe:GetDiagnosticLines()',
    'MAX_ROWS = 4',
):
    if fragment not in probe:
        errors.append(
            f"InteractionProbe.lua missing contract fragment: {fragment}"
        )

for forbidden in (
    "pcall(AcceptQuest",
    "AcceptQuest()",
    "pcall(DeclineQuest",
    "DeclineQuest()",
    "pcall(CompleteQuest",
    "CompleteQuest()",
    "pcall(GetQuestReward",
    "GetQuestReward(",
    "C_GossipInfo.SelectAvailableQuest(",
    "C_GossipInfo.SelectActiveQuest(",
    "C_GossipInfo.SelectOption(",
    "C_GossipInfo.SelectOptionByIndex(",
    "ObjectiveTrackerFrame",
    "QuestFrame:Hide",
    "GossipFrame:Hide",
    "HideUIPanel",
    'SetScript("OnUpdate"',
    "C_Timer.After",
    "SecureActionButtonTemplate",
):
    if forbidden in probe:
        errors.append(
            "InteractionProbe.lua contains forbidden mutation/"
            f"suppression/polling fragment: {forbidden}"
        )

scalar_start = probe.find("local function scalarRecord(value)")
scalar_end = probe.find("local function recordText", scalar_start)
scalar_block = (
    probe[scalar_start:scalar_end]
    if scalar_start != -1 and scalar_end != -1
    else ""
)

secret_i = scalar_block.find("local secret = isSecret(value)")
nil_i = scalar_block.find("if value == nil then")
type_i = scalar_block.find("local valueType = type(value)")

if not (
    secret_i != -1
    and nil_i != -1
    and type_i != -1
    and secret_i < nil_i < type_i
):
    errors.append(
        "scalarRecord must secret-check before nil comparison/type inspection"
    )

rows_start = probe.find("local function captureRows(")
rows_end = probe.find(
    "local function captureQuestItems",
    rows_start,
)
rows_block = (
    probe[rows_start:rows_end]
    if rows_start != -1 and rows_end != -1
    else ""
)

for secret_fragment, later_fragment, label in (
    (
        "local rawSecret = isSecret(raw)",
        "if raw == nil then",
        "container",
    ),
    (
        "local rowSecret = isSecret(row)",
        "elseif row == nil then",
        "row",
    ),
    (
        "local extraSecret = isSecret(extra)",
        "elseif extra ~= nil then",
        "truncation row",
    ),
):
    secret_pos = rows_block.find(secret_fragment)
    later_pos = rows_block.find(later_fragment)

    if not (
        secret_pos != -1
        and later_pos != -1
        and secret_pos < later_pos
    ):
        errors.append(
            f"captureRows must secret-check {label} before inspection"
        )

for fragment in (
    "local function runQuestInteractionProbe()",
    'Logres:GetModuleStatus("QuestInteractionProbe")',
    'Logres:GetModule("QuestInteractionProbe")',
    'if command == "questinteractionprobe" then',
    'emit("  /logres questinteractionprobe")',
    '"questInteractionProbe"',
    '"Quest Interaction Probe"',
    '"questinteractionprobe"',
    '"H"',
):
    if fragment not in commands:
        errors.append(
            f"Commands.lua missing P0129 probe integration: {fragment}"
        )

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find(
    "local function handleHUDPreview",
    run_all_start,
)

if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
elif (
    "runQuestInteractionProbe()"
    in commands[run_all_start:run_all_end]
):
    errors.append(
        "contextual quest interaction probe must not run inside checkall"
    )

if "Quest\\InteractionProbe.lua" not in toc:
    errors.append(
        "Logres.toc missing Quest\\InteractionProbe.lua"
    )
else:
    probe_i = toc.find("Quest\\InteractionProbe.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (
        probe_i != -1
        and commands_i != -1
        and probe_i < commands_i
    ):
        errors.append(
            "InteractionProbe.lua must load before Commands.lua"
        )

for source_name, source in (
    ("Bootstrap.lua", bootstrap),
    ("Logres.toc", toc),
):
    if "0.0.59-dev" not in source:
        errors.append(
            f"{source_name} missing P0129 runtime 0.0.59-dev"
        )

if '"questInteractionProbe": "H"' not in dev_checker:
    errors.append(
        "check_dev_panel_contract.py missing Phase-H questInteractionProbe"
    )

print("Logres P0129 NPC quest interaction probe contract")
print("=================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
