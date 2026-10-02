#!/usr/bin/env python3
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PROBE = (
    ROOT
    / "tools"
    / "probes"
    / "LogresQuestAudit"
    / "LogresQuestAudit.lua"
)
TOC = (
    ROOT
    / "tools"
    / "probes"
    / "LogresQuestAudit"
    / "LogresQuestAudit.toc"
)
README = (
    ROOT
    / "tools"
    / "probes"
    / "LogresQuestAudit"
    / "README.md"
)
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"

errors = []

for path in (PROBE, TOC, README, COMMANDS):
    if not path.is_file():
        errors.append(
            f"missing quest probe file: {path.relative_to(ROOT)}"
        )

if PROBE.is_file():
    source = PROBE.read_text(encoding="utf-8")

    required = [
        'SLASH_LOGRESQUESTAUDIT1 = "/lqa"',
        '"QUEST_DETAIL"',
        '"QUEST_PROGRESS"',
        '"QUEST_COMPLETE"',
        '"QUEST_ACCEPTED"',
        '"QUEST_TURNED_IN"',
        '"QUEST_LOG_UPDATE"',
        '"QUEST_WATCH_LIST_CHANGED"',
        '"QUEST_WATCH_UPDATE"',
        '"SUPER_TRACKING_CHANGED"',
        '"PLAYER_XP_UPDATE"',
        '"UPDATE_EXHAUSTION"',
        "C_QuestLog.GetSelectedQuest",
        "C_QuestLog.GetQuestObjectives",
        "C_QuestLog.GetNextWaypoint",
        "C_QuestLog.GetNextWaypointForMap",
        "C_QuestLog.GetNextWaypointText",
        "C_SuperTrack.GetSuperTrackedQuestID",
        "C_Map.GetBestMapForUnit",
        "C_Map.GetPlayerMapPosition",
        "C_GameRules.GetForeverExperiencePreset",
        "UnitXP",
        "UnitXPMax",
        "GetXPExhaustion",
        "GetQuestID",
        "GetTitleText",
        "GetQuestText",
        "GetObjectiveText",
        "GetProgressText",
        "GetRewardText",
        "local function isSecret(value)",
        "result.secret = isSecret(value)",
        "if result.secret then",
        "pcall(",
        "math.atan2(dx, -dy)",
        "db.eventRegistration[event]",
        "db.eventCounts[event]",
        "function LogresQuestAudit_Run(output)",
        'captureSnapshot("developer-panel")',
        "printReport(output)",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"quest probe missing: {fragment}"
            )

    forbidden = [
        "AcceptQuest(",
        "DeclineQuest(",
        "CompleteQuest(",
        "GetQuestReward(",
        "C_QuestLog.SetSelectedQuest",
        "C_QuestLog.AddQuestWatch",
        "C_QuestLog.RemoveQuestWatch",
        "C_SuperTrack.Set",
        "C_Map.SetUserWaypoint",
        "C_Map.ClearUserWaypoint",
        "Minimap:",
        "SendChatMessage",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "quest probe mutates forbidden surface: "
                f"{fragment}"
            )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    for fragment in (
        "local function runQuestProbe()",
        'if command == "questprobe" then',
        '"questProbe"',
        '"Quest Probe"',
        '"questprobe"',
        "LogresQuestAudit_Run",
    ):
        if fragment not in source:
            errors.append(
                "Commands.lua missing quest panel integration: "
                f"{fragment}"
            )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")

    for fragment in (
        "## Interface: 16001",
        "## Dependencies: Logres",
        "## SavedVariables: LogresQuestAuditDB",
        "LogresQuestAudit.lua",
    ):
        if fragment not in source:
            errors.append(
                f"quest probe TOC missing: {fragment}"
            )

if README.is_file():
    source = README.read_text(encoding="utf-8")

    for fragment in (
        "Logres developer panel",
        "Quest Probe",
        "passive",
        "Secret-capable values",
        "Source presence is not treated as runtime proof.",
    ):
        if fragment not in source:
            errors.append(
                f"quest probe README missing: {fragment}"
            )

print("Logres F.2 quest/XP probe contract")
print("==================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
