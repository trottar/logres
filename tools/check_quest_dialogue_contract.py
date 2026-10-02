#!/usr/bin/env python3
"""Static contract checks for the F.4 additive NPC quest dialogue."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
DIALOGUE = ROOT / "Logres" / "Quest" / "Dialogue.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"

errors = []

for path in (DIALOGUE, COMMANDS, TOC, BOOTSTRAP):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if DIALOGUE.is_file():
    source = DIALOGUE.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("QuestDialogue"',
        "local DISPLAY_SECONDS = 10.0",
        "GetQuestID",
        "GetTitleText",
        "GetQuestText",
        "GetObjectiveText",
        '"QUEST_DETAIL"',
        '"QUEST_ACCEPTED"',
        '"QUEST_FINISHED"',
        '"PLAYER_ENTERING_WORLD"',
        "if isSecret(value) then",
        "if isSecret(questID) then",
        "function Dialogue:HandleQuestDetail()",
        "function Dialogue:ShowPreview()",
        "function Dialogue:GetDebugStatus()",
        "self:SubscribePreferences(function(preferences)",
        "C_Timer.After(DISPLAY_SECONDS, function()",
        '"suppressed-immersion-off"',
        'root:EnableMouse(false)',
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Dialogue.lua missing: {fragment}")

    forbidden = [
        "OnUpdate",
        "AcceptQuest(",
        "DeclineQuest(",
        "CompleteQuest(",
        "GetQuestReward(",
        "QuestFrame:",
        "GossipFrame:",
        "HideUIPanel(",
        "ShowUIPanel(",
        "C_QuestLog.SetSelectedQuest",
        "C_QuestLog.AddQuestWatch",
        "C_QuestLog.RemoveQuestWatch",
        "C_SuperTrack.Set",
        "hooksecurefunc",
        "RegisterStateDriver",
        "SetAttribute(",
        "LogresDB",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "Quest dialogue exceeds additive/passive scope: "
                f"{fragment}"
            )

    value_secret = source.find("if isSecret(value) then")
    value_type = source.find('if type(value) ~= "string" then')
    if value_secret == -1 or value_type == -1 or value_secret > value_type:
        errors.append(
            "quest text must be secret-checked before string inspection"
        )

    id_secret = source.find("if isSecret(questID) then")
    id_type = source.find('if type(questID) ~= "number" then')
    if id_secret == -1 or id_type == -1 or id_secret > id_type:
        errors.append(
            "quest ID must be secret-checked before numeric inspection"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function runQuestDialogueCheck()",
        "local function runQuestDialoguePreview()",
        'Logres:GetModuleStatus("QuestDialogue")',
        'Logres:GetModule("QuestDialogue")',
        'if command == "questdialoguecheck" then',
        'if command == "questdialoguepreview" then',
        '"Quest Dialogue Check"',
        '"Quest Dialogue Preview"',
        '"questdialoguecheck"',
        '"questdialoguepreview"',
        "runQuestDialogueCheck()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing quest dialogue integration: {fragment}"
            )

    start = source.find("local function runQuestDialogueCheck()")
    end = source.find(
        "\nlocal function runQuestDialoguePreview()",
        start,
    )

    if start == -1 or end == -1:
        errors.append(
            "Quest Dialogue Check function could not be isolated"
        )
    else:
        region = source[start:end]
        for forbidden in (
            "GetQuestID(",
            "GetTitleText(",
            "GetQuestText(",
            "GetObjectiveText(",
        ):
            if forbidden in region:
                errors.append(
                    "Quest Dialogue Check must use addon-owned status only: "
                    f"{forbidden}"
                )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    dialogue_index = source.find("Quest\\Dialogue.lua")
    commands_index = source.find("Core\\Commands.lua")

    if dialogue_index == -1:
        errors.append("Logres.toc missing Quest\\Dialogue.lua")
    elif commands_index == -1 or dialogue_index > commands_index:
        errors.append(
            "Quest\\Dialogue.lua must load before Core\\Commands.lua"
        )

bootstrap_version = None
toc_version = None

if BOOTSTRAP.is_file():
    source = BOOTSTRAP.read_text(encoding="utf-8")
    match = re.search(
        r'Logres\.VERSION = "([^"]+)"',
        source,
    )
    if match:
        bootstrap_version = match.group(1)

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    match = re.search(
        r"^## Version: (.+)$",
        source,
        re.MULTILINE,
    )
    if match:
        toc_version = match.group(1).strip()

if bootstrap_version is None:
    errors.append(
        "Bootstrap runtime version could not be read"
    )

if toc_version is None:
    errors.append(
        "TOC runtime version could not be read"
    )

if (
    bootstrap_version is not None
    and toc_version is not None
    and bootstrap_version != toc_version
):
    errors.append(
        "Bootstrap and TOC runtime versions must match"
    )

print("Logres F.4 additive NPC quest dialogue contract")
print("==============================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
