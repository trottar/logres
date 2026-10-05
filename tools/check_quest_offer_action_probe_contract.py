#!/usr/bin/env python3
"""Static contract for P0131 player-triggered quest-offer Accept/Decline probe."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
PROBE = ADDON / "Quest" / "OfferActionProbe.lua"
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
dev_checker = DEV_PANEL_CHECKER.read_text(encoding="utf-8") if DEV_PANEL_CHECKER.is_file() else ""

for fragment in (
    'Logres:RegisterModule("QuestOfferActionProbe"',
    '"QUEST_DETAIL"',
    '"QUEST_ACCEPTED"',
    '"QUEST_FINISHED"',
    '"PLAYER_ENTERING_WORLD"',
    'local function isSecret(value)',
    'local function readCurrentOfferIdentity()',
    'if isSecret(questID) then',
    'if isSecret(title) then',
    'function Probe:CaptureOffer(reason)',
    'function Probe:TriggerAction(kind, source)',
    'function Probe:TriggerProductionAction(',
    'function Probe:HandlePanelAction(kind)',
    'function Probe:MarkReported(kind)',
    'function Probe:ResolveAccepted(...)',
    'function Probe:ResolveFinished()',
    'offer.questID ~= self.currentOffer.questID',
    'pcall(AcceptQuest)',
    'pcall(DeclineQuest)',
    'self.mutationCallCount =',
    'action.state = "awaiting-event"',
    'action.state = "event-confirmed"',
    'action.state = "event-mismatch"',
    'action.state = "awaiting-accepted-after-finished"',
    'action.finishedObserved = true',
    'and action.finishedObserved ~= true',
    'self.lastAction.reported = true',
):
    if fragment not in probe:
        errors.append(f"OfferActionProbe.lua missing contract fragment: {fragment}")

for forbidden in (
    "CompleteQuest(",
    "pcall(CompleteQuest",
    "GetQuestReward(",
    "pcall(GetQuestReward",
    "C_GossipInfo.SelectAvailableQuest(",
    "C_GossipInfo.SelectActiveQuest(",
    "C_GossipInfo.SelectOption(",
    "C_GossipInfo.SelectOptionByIndex(",
    "QuestFrame:Hide",
    "GossipFrame:Hide",
    "ObjectiveTrackerFrame",
    "HideUIPanel(",
    "ShowUIPanel(",
    'SetScript("OnUpdate"',
    "C_Timer.After",
    "SecureActionButtonTemplate",
    'action.state = "finished-without-accepted"',
):
    if forbidden in probe:
        errors.append(
            "OfferActionProbe.lua exceeds Accept/Decline probe boundary: "
            + forbidden
        )

if probe.count("pcall(AcceptQuest)") != 1:
    errors.append("AcceptQuest must have exactly one explicit probe call site")

if probe.count("pcall(DeclineQuest)") != 1:
    errors.append("DeclineQuest must have exactly one explicit probe call site")

trigger_start = probe.find("function Probe:TriggerAction(kind, source)")
trigger_end = probe.find("function Probe:HandlePanelAction(kind)", trigger_start)
trigger_block = (
    probe[trigger_start:trigger_end]
    if trigger_start != -1 and trigger_end != -1
    else ""
)

if "pcall(AcceptQuest)" not in trigger_block or "pcall(DeclineQuest)" not in trigger_block:
    errors.append("all Accept/Decline mutation calls must be isolated inside TriggerAction")

for mutation in ("pcall(AcceptQuest)", "pcall(DeclineQuest)"):
    first = probe.find(mutation)
    if first != -1 and not (trigger_start <= first < trigger_end):
        errors.append(f"mutation call outside TriggerAction: {mutation}")

id_secret = probe.find("if isSecret(questID) then")
id_type = probe.find('if type(questID) ~= "number"')
if not (id_secret != -1 and id_type != -1 and id_secret < id_type):
    errors.append("quest ID must be secret-checked before numeric inspection")

title_secret = probe.find("if isSecret(title) then")
title_type = probe.find('if type(title) ~= "string"')
if not (title_secret != -1 and title_type != -1 and title_secret < title_type):
    errors.append("quest title must be secret-checked before string inspection")

for fragment in (
    "local function runQuestOfferActionProbe(kind)",
    'Logres:GetModule("QuestOfferActionProbe")',
    'if command == "questofferacceptprobe" then',
    'if command == "questofferdeclineprobe" then',
    'emit("  /logres questofferacceptprobe")',
    'emit("  /logres questofferdeclineprobe")',
    '"questOfferAcceptProbe"',
    '"TEST Accept Current Quest"',
    '"questofferacceptprobe"',
    '"questOfferDeclineProbe"',
    '"TEST Decline Current Quest"',
    '"questofferdeclineprobe"',
    'finishedObserved=%s',
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing P0131 action integration: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
else:
    run_all = commands[run_all_start:run_all_end]
    for forbidden in (
        "runQuestOfferActionProbe(\"accept\")",
        "runQuestOfferActionProbe(\"decline\")",
    ):
        if forbidden in run_all:
            errors.append("mutation probe must never run inside checkall")

if "Quest\\OfferActionProbe.lua" not in toc:
    errors.append("Logres.toc missing Quest\\OfferActionProbe.lua")
else:
    probe_i = toc.find("Quest\\OfferActionProbe.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (probe_i != -1 and commands_i != -1 and probe_i < commands_i):
        errors.append("OfferActionProbe.lua must load before Commands.lua")

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None

if bootstrap_version is None or toc_version is None:
    errors.append("P0131 checker could not read runtime versions")
elif bootstrap_version != toc_version:
    errors.append("Bootstrap and TOC runtime versions must match")
# P0131 remains a durable behavior contract across later runtime checkpoints.

for fragment in (
    '"questOfferAcceptProbe": "H"',
    '"questOfferDeclineProbe": "H"',
):
    if fragment not in dev_checker:
        errors.append("check_dev_panel_contract.py missing P0131 action: " + fragment)

print("Logres P0131 quest-offer Accept/Decline probe contract")
print("======================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
