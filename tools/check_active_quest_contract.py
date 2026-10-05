#!/usr/bin/env python3
"""Static contract for P0126 Active Quest one-focus presentation."""

from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
ACTIVE = ADDON / "Quest" / "ActiveQuest.lua"
THEME = ADDON / "Media" / "Theme.lua"
TOC = ADDON / "Logres.toc"
COMMANDS = ADDON / "Core" / "Commands.lua"
DATABASE = ADDON / "Core" / "Database.lua"
PREFERENCES = ADDON / "Core" / "Preferences.lua"

errors = []

required_assets = {
    ADDON / "Media" / "Quest" / "active_quest_panel.tga": "580f6cf9f8540c92726d24ae461f2181f43dfd6148ced6811ecd0e1b3c3ee6e1",
    ADDON / "Media" / "Quest" / "active_quest_divider.tga": "a0942cde4eca94a7ca1e9b813cfb2f63a2afbaf474dab38e613feb8729aec05a",
    ADDON / "Media" / "Quest" / "active_quest_glyph.tga": "1e018c150977fdc41e170ecc10f922650a833b723ab29ebc8a68cc46f82a7073",
}

for path, expected in required_assets.items():
    if not path.is_file():
        errors.append(f"missing Active Quest asset: {path.relative_to(ROOT)}")
        continue
    actual = hashlib.sha256(path.read_bytes()).hexdigest()
    if actual != expected:
        errors.append(
            f"Active Quest asset hash mismatch: {path.relative_to(ROOT)} {actual} != {expected}"
        )

active = ACTIVE.read_text(encoding="utf-8") if ACTIVE.is_file() else ""
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
database = DATABASE.read_text(encoding="utf-8") if DATABASE.is_file() else ""
preferences = PREFERENCES.read_text(encoding="utf-8") if PREFERENCES.is_file() else ""

for fragment in (
    'Logres:RegisterModule("ActiveQuest"',
    'progress:ReadActiveQuestID()',
    'progress:ReadObjectives(questID)',
    'C_QuestLog.GetTitleForQuestID',
    'C_QuestLog.IsComplete',
    'C_QuestLog.ReadyForTurnIn',
    'local function isSecret(value)',
    'self.activeQuestEnabled',
    'preferences.activeQuestEnabled == true',
    'PREVIEW_NORMAL = "normal"',
    'PREVIEW_COMPLETE = "complete"',
    'progress:NormalizeObjectiveLabel(row)',
    'visual.label:SetText(',
    'styleValue("objectiveFont")',
    'GameTooltip:SetOwner',
    'GameTooltip:SetText(label)',
    'GameTooltip:AddLine("Complete")',
    'progress:StableObjectiveText(row)',
    'local MAX_OBJECTIVES = 8',
    'CreateFrame("StatusBar", nil, frame)',
    'status:SetMinMaxValues(0, 100)',
    '"QUEST_LOG_UPDATE"',
    '"QUEST_WATCH_UPDATE"',
    '"QUEST_WATCH_LIST_CHANGED"',
    '"SUPER_TRACKING_CHANGED"',
    '"PLAYER_ENTERING_WORLD"',
):
    if fragment not in active:
        errors.append(f"ActiveQuest.lua missing contract fragment: {fragment}")

for forbidden in (
    "visual.label:SetFormattedText",
    "percentText",
    "SetFormattedText(",
    "GameTooltip:SetText(\n        label,",
    "            0.88,\n            0.78,",
    "SetSuperTrackedQuestID",
    "AddQuestWatch",
    "RemoveQuestWatch",
    "GetNextWaypoint",
    "ObjectiveTrackerFrame",
    "QuestMapFrame:Hide",
    'SetScript("OnUpdate"',
    "C_Timer.After",
):
    if forbidden in active:
        errors.append(f"ActiveQuest.lua contains forbidden ownership/polling fragment: {forbidden}")

# Title and quest flags must reject secret values before type inspection.
title_secret = active.find("if isSecret(title) then")
title_type = active.find('if type(title) ~= "string"')
if title_secret == -1 or title_type == -1 or title_secret > title_type:
    errors.append("ActiveQuest.lua title secret check must precede type inspection")

flag_start = active.find("local function readQuestFlag")
flag_end = active.find("local function percentageSpec", flag_start)
flag_block = active[flag_start:flag_end] if flag_start != -1 and flag_end != -1 else ""
if 'if isSecret(value) then' not in flag_block or 'if type(value) ~= "boolean"' not in flag_block:
    errors.append("ActiveQuest.lua quest-flag reader missing secret/type checks")
elif flag_block.find('if isSecret(value) then') > flag_block.find('if type(value) ~= "boolean"'):
    errors.append("ActiveQuest.lua quest-flag secret check must precede type inspection")

for fragment in (
    "theme.activeQuest = {",
    'panel = MEDIA_ROOT .. "Quest\\\\active_quest_panel.tga"',
    'divider = MEDIA_ROOT .. "Quest\\\\active_quest_divider.tga"',
    'glyph = MEDIA_ROOT .. "Quest\\\\active_quest_glyph.tga"',
):
    if fragment not in theme:
        errors.append(f"Theme.lua missing Active Quest token/path: {fragment}")

if "Quest\\ActiveQuest.lua" not in toc:
    errors.append("Logres.toc does not load Quest\\ActiveQuest.lua")
else:
    progress_i = toc.find("Quest\\Progress.lua")
    active_i = toc.find("Quest\\ActiveQuest.lua")
    commands_i = toc.find("Core\\Commands.lua")
    if not (progress_i != -1 and active_i != -1 and commands_i != -1 and progress_i < active_i < commands_i):
        errors.append("ActiveQuest.lua must load after Progress.lua and before Commands.lua")

for fragment in (
    "local CURRENT_SCHEMA = 3",
    "activeQuestEnabled = true",
    "schema = 3",
):
    if fragment not in database:
        errors.append(f"Database.lua missing Active Quest preference migration: {fragment}")

for fragment in (
    "activeQuestEnabled = {",
    "activeQuestEnabled = Logres.db.settings.activeQuestEnabled and true or false",
    "activeQuestEnabled = previous.activeQuestEnabled",
):
    if fragment not in preferences:
        errors.append(f"Preferences.lua missing Active Quest preference contract: {fragment}")

for fragment in (
    "local function runActiveQuestCheck()",
    "local function runActiveQuestPreview(mode)",
    "local function handleActiveQuest(argument)",
    "/logres activequest [on|off|toggle]",
    "/logres activequestpreview [normal|complete|live]",
    '"activeQuestCheck"',
    '"Active Quest Check"',
    '"activeQuestPreviewNormal"',
    '"Active Quest Preview"',
    '"activeQuestPreviewComplete"',
    '"Active Quest Complete"',
    '"activeQuestLive"',
    '"Active Quest Live"',
    '"activeQuestOn"',
    '"Active Quest ON"',
    '"activeQuestOff"',
    '"Active Quest OFF"',
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing Active Quest control/diagnostic: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
if run_all_start == -1 or run_all_end == -1:
    errors.append("could not isolate runAllChecks()")
elif "runActiveQuestCheck()" not in commands[run_all_start:run_all_end]:
    errors.append("runAllChecks() does not include Active Quest Check")

print("Logres P0126 Active Quest contract")
print("=================================")
if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
