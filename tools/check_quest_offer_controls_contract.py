#!/usr/bin/env python3
"""Static contract for P0132 production quest-offer Accept/Decline controls."""

from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"

DIALOGUE = ADDON / "Quest" / "Dialogue.lua"
PROBE = ADDON / "Quest" / "OfferActionProbe.lua"
THEME = ADDON / "Media" / "Theme.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"
BOOTSTRAP = ADDON / "Core" / "Bootstrap.lua"
ASSET = ADDON / "Media" / "Quest" / "quest_offer_action_rule.tga"

errors = []

for path in (
    DIALOGUE,
    PROBE,
    THEME,
    COMMANDS,
    TOC,
    BOOTSTRAP,
    ASSET,
):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if ASSET.is_file():
    actual = hashlib.sha256(ASSET.read_bytes()).hexdigest()
    expected = "882c04d17b3a6433c7a4b358d59d65ea88a554b61e283d5e81eec22a812c578c"
    if actual != expected:
        errors.append(
            "quest offer action rule hash mismatch: "
            f"{actual} != {expected}"
        )

dialogue = DIALOGUE.read_text(encoding="utf-8") if DIALOGUE.is_file() else ""
probe = PROBE.read_text(encoding="utf-8") if PROBE.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
bootstrap = BOOTSTRAP.read_text(encoding="utf-8") if BOOTSTRAP.is_file() else ""

for fragment in (
    "theme.questOfferControls = {",
    'rule = MEDIA_ROOT .. "Quest\\\\quest_offer_action_rule.tga"',
    "buttonWidth = 150",
    "buttonHeight = 38",
    'accept = { 0.96, 0.72, 0.24, 1.00 }',
):
    if fragment not in theme:
        errors.append(f"Theme.lua missing P0132 token/path: {fragment}")

for fragment in (
    "local function createOfferButton(",
    "function Dialogue:UpdateOfferControls()",
    "function Dialogue:HandleOfferAction(kind)",
    'actionRuntime:TriggerProductionAction(',
    'offerActionRoot:SetPoint(',
    '"TOP",\n        root,\n        "BOTTOM"',
    '"decline",\n            "Decline"',
    '"accept",\n            "Accept"',
    "self.offerActionsEnabled =",
    "self.offerActionPreview =",
    "self.offerActionPending =",
    "self.offerControlsFinalPage =",
    "self.offerActionClickCount =",
    "self.offerActionRoot:IsVisible()",
    '"Use the standard quest controls."',
    '"Preview only"',
    "or self.currentPage == pageCount",
):
    if fragment not in dialogue:
        errors.append(f"Dialogue.lua missing P0132 control fragment: {fragment}")

for forbidden in (
    "AcceptQuest(",
    "DeclineQuest(",
    "CompleteQuest(",
    "GetQuestReward(",
    "C_GossipInfo.SelectAvailableQuest(",
    "C_GossipInfo.SelectActiveQuest(",
    "C_GossipInfo.SelectOption(",
    "QuestFrame:",
    "GossipFrame:",
    "HideUIPanel(",
    "ShowUIPanel(",
    "SecureActionButtonTemplate",
    'SetScript("OnUpdate"',
):
    if forbidden in dialogue:
        errors.append(
            "Dialogue.lua must remain presentation/control routing only: "
            + forbidden
        )

for fragment in (
    "function Probe:TriggerAction(kind, source)",
    "function Probe:TriggerProductionAction(",
    '"production"',
    "productionAttemptCount",
    "lastActionSource",
    'if action.source == "production" then',
    "pcall(AcceptQuest)",
    "pcall(DeclineQuest)",
):
    if fragment not in probe:
        errors.append(f"OfferActionProbe.lua missing production route: {fragment}")

if probe.count("pcall(AcceptQuest)") != 1:
    errors.append("production controls must reuse the single proven AcceptQuest call site")

if probe.count("pcall(DeclineQuest)") != 1:
    errors.append("production controls must reuse the single proven DeclineQuest call site")

for forbidden in (
    "CompleteQuest(",
    "GetQuestReward(",
    "C_GossipInfo.SelectAvailableQuest(",
    "C_GossipInfo.SelectActiveQuest(",
    "C_GossipInfo.SelectOption(",
    "C_GossipInfo.SelectOptionByIndex(",
    "QuestFrame:Hide",
    "GossipFrame:Hide",
    "HideUIPanel(",
    "ShowUIPanel(",
    "C_Timer.After",
    'SetScript("OnUpdate"',
):
    if forbidden in probe:
        errors.append(
            "OfferActionProbe exceeds P0132 offer-only boundary: "
            + forbidden
        )

for fragment in (
    "local function runQuestOfferControlsCheck()",
    '"Logres questoffercontrolscheck: %s',
    'if command == "questoffercontrolscheck" then',
    '"questOfferControlsCheck"',
    '"Quest Offer Controls Check"',
    '"questoffercontrolscheck"',
    "runQuestOfferControlsCheck()",
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing P0132 check integration: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
else:
    run_all = commands[run_all_start:run_all_end]
    if "runQuestOfferControlsCheck()" not in run_all:
        errors.append("Run All must include the non-mutating offer-controls check")
    for forbidden in (
        'TriggerProductionAction(',
        'runQuestOfferActionProbe("accept")',
        'runQuestOfferActionProbe("decline")',
    ):
        if forbidden in run_all:
            errors.append("Run All must never trigger quest mutation: " + forbidden)

for forbidden in (
    "QuestFrame:Hide",
    "GossipFrame:Hide",
    "HideUIPanel(",
    "ShowUIPanel(",
):
    if forbidden in dialogue + probe:
        errors.append("P0132 must keep Blizzard offer controls available: " + forbidden)

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None

if bootstrap_version is None or toc_version is None:
    errors.append("P0132 checker could not read runtime versions")
elif bootstrap_version != toc_version:
    errors.append("Bootstrap and TOC runtime versions must match")

print("Logres P0132 production quest-offer controls contract")
print("====================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
