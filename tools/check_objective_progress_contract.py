#!/usr/bin/env python3
"""Static contract checks for F.6 contextual objective progress."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
PROGRESS = ROOT / "Logres" / "Quest" / "Progress.lua"
COMMANDS = ROOT / "Logres" / "Core" / "Commands.lua"
TOC = ROOT / "Logres" / "Logres.toc"
BOOTSTRAP = ROOT / "Logres" / "Core" / "Bootstrap.lua"
HUD = ROOT / "Logres" / "HUD" / "HUD.lua"

errors = []

for path in (PROGRESS, COMMANDS, TOC, BOOTSTRAP, HUD):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

if PROGRESS.is_file():
    source = PROGRESS.read_text(encoding="utf-8")

    required = [
        'Logres:RegisterModule("QuestObjectiveProgress"',
        "local PULSE_SECONDS = 3.0",
        "local MAX_OBJECTIVES = 8",
        "local MAX_PRESENTATION_ROWS = 2",
        "local TEXT_LIMIT = 86",
        "local PRESENTATION_WIDTH = 520",
        "local PRESENTATION_HEIGHT = 32",
        "local FALLBACK_Y = -5",
        "local PREVIEW_TEXT =",
        "PREVIEW",
        "Objective progress",
        "C_QuestLog.GetQuestObjectives",
        "C_QuestLog.GetSelectedQuest",
        "C_SuperTrack.GetSuperTrackedQuestID",
        '"QUEST_LOG_UPDATE"',
        '"QUEST_WATCH_UPDATE"',
        '"SUPER_TRACKING_CHANGED"',
        '"PLAYER_ENTERING_WORLD"',
        "function Progress:ReadActiveQuestID()",
        "function Progress:ReadObjectives(questID)",
        "function Progress:StableObjectiveText(row)",
        "function Progress:NormalizeObjectiveLabel(row)",
        "local prefixLength = #prefix",
        "local remainder =",
        'remainder:gsub("^%s+", "")',
        "self:NormalizeObjectiveLabel(row)",
        "function Progress:FindChangedRows(previousRows, currentRows)",
        "function Progress:Refresh(reason, forceBaseline)",
        "function Progress:ShowPreview()",
        "function Progress:GetDebugStatus()",
        "self:SubscribePreferences(function(preferences)",
        "C_Timer.After(PULSE_SECONDS, function()",
        'root:EnableMouse(false)',
        '"suppressed-immersion-off"',
        "self.baselineRows = rows",
        "self:StableObjectiveText(previous)",
        "self:StableObjectiveText(current)",
        "previousIdentity == currentIdentity",
        "previous.fulfilled ~= current.fulfilled",
        "previous.finished ~= current.finished",
        'Logres.Layout.Bind(root, "contextObjective", "CENTER", "CENTER")',
        "{ PREVIEW_TEXT }",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(f"Progress.lua missing: {fragment}")

    if (
        'Logres.Layout.Bind(root, "contextObjective", "CENTER", "CENTER")'
        not in source
    ):
        errors.append(
            "Progress.lua missing integration-owned Context anchor"
        )

    fallback_pattern = re.compile(
        r'root:SetPoint\(\s*'
        r'"CENTER",\s*'
        r'UIParent,\s*'
        r'"CENTER",\s*'
        r'0,\s*'
        r'FALLBACK_Y\s*'
        r'\)',
        re.MULTILINE,
    )
    if fallback_pattern.search(source) is None:
        errors.append(
            "Progress.lua missing center fallback presentation anchor"
        )

    size_pattern = re.compile(
        r'root:SetSize\(\s*'
        r'PRESENTATION_WIDTH,\s*'
        r'PRESENTATION_HEIGHT\s*'
        r'\)',
        re.MULTILINE,
    )
    if size_pattern.search(source) is None:
        errors.append(
            "Progress.lua missing bounded presentation size contract"
        )

    forbidden = [
        "OnUpdate",
        "C_Timer.NewTicker",
        '"QUEST_PROGRESS"',
        '"QUEST_COMPLETE"',
        '"QUEST_TURNED_IN"',
        "AcceptQuest(",
        "DeclineQuest(",
        "CompleteQuest(",
        "GetQuestReward(",
        "C_QuestLog.SetSelectedQuest",
        "C_QuestLog.AddQuestWatch",
        "C_QuestLog.RemoveQuestWatch",
        "C_SuperTrack.Set",
        "ObjectiveTrackerFrame",
        "_G.LogresHUDTarget",
        "QuestObjectiveTracker",
        "HideUIPanel(",
        "ShowUIPanel(",
        "hooksecurefunc",
        "RegisterStateDriver",
        "SetAttribute(",
        "LogresDB",
        "LogresDiagnosticsDB",
        "root:SetSize(600, 58)",
        "Stonesplinter Seer slain  ·  1/10",
        "local label = trimText(row.text, TEXT_LIMIT)",
        "previous.text == current.text",
    ]

    for fragment in forbidden:
        if fragment in source:
            errors.append(
                "objective progress exceeds current contract: "
                f"{fragment}"
            )

    old_anchor_pattern = re.compile(
        r'root:SetPoint\(\s*'
        r'"CENTER",\s*'
        r'UIParent,\s*'
        r'"CENTER",\s*'
        r'0,\s*'
        r'-205\s*'
        r'\)',
        re.MULTILINE,
    )
    if old_anchor_pattern.search(source) is not None:
        errors.append(
            "objective progress still uses rejected lower action-lane anchor"
        )

    container_secret = source.find("if isSecret(objectives) then")
    container_type = source.find('if type(objectives) ~= "table" then')
    if (
        container_secret == -1
        or container_type == -1
        or container_secret > container_type
    ):
        errors.append(
            "objective container must be secret-checked before table inspection"
        )

    row_secret = source.find("if isSecret(objective) then")
    row_type = source.find('if type(objective) ~= "table" then')
    if (
        row_secret == -1
        or row_type == -1
        or row_secret > row_type
    ):
        errors.append(
            "objective row must be secret-checked before table inspection"
        )

    field_secret = source.find("if isSecret(value) then")
    field_type = source.find("if type(value) ~= expectedType then")
    if (
        field_secret == -1
        or field_type == -1
        or field_secret > field_type
    ):
        errors.append(
            "objective scalar fields must be secret-checked before type inspection"
        )

if HUD.is_file():
    source = HUD.read_text(encoding="utf-8")
    if (
        'CreateFrame("Frame", "LogresHUDTarget", root)'
        not in source
    ):
        errors.append(
            "HUD must still provide addon-owned target presentation anchor"
        )

if COMMANDS.is_file():
    source = COMMANDS.read_text(encoding="utf-8")

    required = [
        "local function runObjectiveProgressCheck()",
        "local function runObjectiveProgressPreview()",
        'Logres:GetModuleStatus("QuestObjectiveProgress")',
        'Logres:GetModule("QuestObjectiveProgress")',
        'if command == "objectiveprogresscheck" then',
        'if command == "objectiveprogresspreview" then',
        '"Objective Progress Check"',
        '"Objective Progress Preview"',
        '"objectiveprogresscheck"',
        '"objectiveprogresspreview"',
        "runObjectiveProgressCheck()",
    ]

    for fragment in required:
        if fragment not in source:
            errors.append(
                f"Commands.lua missing objective progress integration: {fragment}"
            )

    start = source.find("local function runObjectiveProgressCheck()")
    end = source.find(
        "\nlocal function runObjectiveProgressPreview()",
        start,
    )

    if start == -1 or end == -1:
        errors.append(
            "Objective Progress Check function could not be isolated"
        )
    else:
        region = source[start:end]

        for forbidden in (
            "GetQuestObjectives(",
            "GetSelectedQuest(",
            "GetSuperTrackedQuestID(",
            "ObjectiveTrackerFrame",
        ):
            if forbidden in region:
                errors.append(
                    "Objective Progress Check must use addon-owned status only: "
                    f"{forbidden}"
                )

if TOC.is_file():
    source = TOC.read_text(encoding="utf-8")
    progress_index = source.find("Quest\\Progress.lua")
    commands_index = source.find("Core\\Commands.lua")

    if progress_index == -1:
        errors.append("Logres.toc missing Quest\\Progress.lua")
    elif commands_index == -1 or progress_index > commands_index:
        errors.append(
            "Quest\\Progress.lua must load before Core\\Commands.lua"
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
    errors.append("Bootstrap runtime version could not be read")

if toc_version is None:
    errors.append("TOC runtime version could not be read")

if (
    bootstrap_version is not None
    and toc_version is not None
    and bootstrap_version != toc_version
):
    errors.append(
        "Bootstrap and TOC runtime versions must match"
    )

print("Logres F.6 contextual objective progress contract")
print("===============================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
