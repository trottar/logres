#!/usr/bin/env python3
"""Static contract for the P0130 bounded/paged NPC quest narrative."""

from pathlib import Path
import hashlib
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"
DIALOGUE = ADDON / "Quest" / "Dialogue.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"
BOOTSTRAP = ADDON / "Core" / "Bootstrap.lua"
THEME = ADDON / "Media" / "Theme.lua"

errors = []

required_assets = {
    ADDON / "Media" / "Quest" / "quest_narrative_panel.tga":
        "9e08e1964c37296220abbdd2f0ed7ea02c57b3787b20219e8b7cfdcf8ec46181",
    ADDON / "Media" / "Quest" / "quest_narrative_divider.tga":
        "adcf34c840b939cba81b469d34bc358ee459e2a8d3c31142552e1d3993c52595",
    ADDON / "Media" / "Quest" / "quest_page_chevron.tga":
        "db680cff25130ff272f32c444bcbc3d932c421c858dafbec965f71b0a57e08ba",
}

for path, expected in required_assets.items():
    if not path.is_file():
        errors.append(
            f"missing quest narrative asset: {path.relative_to(ROOT)}"
        )
        continue

    actual = hashlib.sha256(path.read_bytes()).hexdigest()

    if actual != expected:
        errors.append(
            f"quest narrative asset hash mismatch: "
            f"{path.relative_to(ROOT)} {actual} != {expected}"
        )

dialogue = (
    DIALOGUE.read_text(encoding="utf-8")
    if DIALOGUE.is_file()
    else ""
)
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
theme = THEME.read_text(encoding="utf-8") if THEME.is_file() else ""

for fragment in (
    'Logres:RegisterModule("QuestDialogue"',
    "local PREVIEW_SECONDS = 30.0",
    "local PAGE_CHAR_LIMIT = 420",
    "local function buildPages(text)",
    "function Dialogue:SetPage(index)",
    "function Dialogue:PreviousPage()",
    "function Dialogue:NextPage()",
    "function Dialogue:PresentText(",
    "function Dialogue:HandleQuestDetail()",
    "function Dialogue:ClearActiveDetail(reason)",
    "self.activeDetail = detail",
    "local wasImmersionEnabled =",
    "and self.activeDetail ~= nil",
    '"immersion-on-restore"',
    "self.restoreCount =",
    "activeDetailCached =",
    "function Dialogue:ShowPreview()",
    "function Dialogue:GetDebugStatus()",
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
    "root:EnableMouse(false)",
    'CreateFrame(\n            "Button"',
    '"OnClick"',
    "self:PreviousPage()",
    "self:NextPage()",
    "self.pageIndicator:SetFormattedText(",
    "bodyText:SetWordWrap(true)",
    "objectiveText:SetWordWrap(true)",
    "C_Timer.After(PREVIEW_SECONDS, function()",
    '"QUEST_DETAIL",\n        false',
):
    if fragment not in dialogue:
        errors.append(
            f"Dialogue.lua missing P0130 contract fragment: {fragment}"
        )

apply_start = dialogue.find(
    "function Dialogue:ApplyPreferences(preferences)"
)
apply_end = dialogue.find(
    "function Dialogue:ShowPreview()",
    apply_start,
)
apply_block = (
    dialogue[apply_start:apply_end]
    if apply_start != -1 and apply_end != -1
    else ""
)

if 'self:HidePresentation("immersion-off")' not in apply_block:
    errors.append(
        "Immersion OFF must hide presentation without clearing cached detail"
    )

if "ClearActiveDetail" in apply_block:
    errors.append(
        "Immersion preference toggle must preserve active detail for restore"
    )

for forbidden in (
    "BODY_LIMIT",
    "OBJECTIVE_LIMIT",
    "trimText(",
    "AcceptQuest(",
    "DeclineQuest(",
    "CompleteQuest(",
    "GetQuestReward(",
    "C_GossipInfo.SelectAvailableQuest(",
    "C_GossipInfo.SelectActiveQuest(",
    "C_GossipInfo.SelectOption(",
    "C_GossipInfo.SelectOptionByIndex(",
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
    "SecureActionButtonTemplate",
    'SetScript("OnUpdate"',
    "LogresDB",
):
    if forbidden in dialogue:
        errors.append(
            "Quest narrative exceeds read-only presentation scope: "
            f"{forbidden}"
        )

value_secret = dialogue.find("if isSecret(value) then")
value_type = dialogue.find('if type(value) ~= "string" then')
if (
    value_secret == -1
    or value_type == -1
    or value_secret > value_type
):
    errors.append(
        "quest text must be secret-checked before string inspection"
    )

id_secret = dialogue.find("if isSecret(questID) then")
id_type = dialogue.find('if type(questID) ~= "number" then')
if (
    id_secret == -1
    or id_type == -1
    or id_secret > id_type
):
    errors.append(
        "quest ID must be secret-checked before numeric inspection"
    )

for fragment in (
    "theme.questDialogue = {",
    'panel = MEDIA_ROOT .. "Quest\\\\quest_narrative_panel.tga"',
    'divider = MEDIA_ROOT .. "Quest\\\\quest_narrative_divider.tga"',
    'pageChevron = MEDIA_ROOT .. "Quest\\\\quest_page_chevron.tga"',
    "bodyHeight = 134",
    "objectiveHeight = 50",
):
    if fragment not in theme:
        errors.append(
            f"Theme.lua missing quest narrative token/path: {fragment}"
        )

for fragment in (
    "local function runQuestDialogueCheck()",
    "local function runQuestDialoguePreview()",
    'Logres:GetModuleStatus("QuestDialogue")',
    'Logres:GetModule("QuestDialogue")',
    'if command == "questdialoguecheck" then',
    'if command == "questdialoguepreview" then',
    '"Quest Dialogue Check"',
    '"Quest Dialogue Preview"',
):
    if fragment not in commands:
        errors.append(
            f"Commands.lua missing quest dialogue integration: {fragment}"
        )

if "Quest\\Dialogue.lua" not in toc:
    errors.append("Logres.toc missing Quest\\Dialogue.lua")

bootstrap_version = None
toc_version = None

match = re.search(
    r'Logres\.VERSION = "([^"]+)"',
    bootstrap,
)
if match:
    bootstrap_version = match.group(1)

match = re.search(
    r"^## Version: (.+)$",
    toc,
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

print("Logres P0130 bounded/paged NPC quest narrative contract")
print("======================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
