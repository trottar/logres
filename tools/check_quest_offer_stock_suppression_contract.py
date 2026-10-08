#!/usr/bin/env python3
"""Static contract for P0165 stock quest-offer control suppression."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
ADDON = ROOT / "Logres"

SUPPRESSION = ADDON / "Quest" / "OfferStockSuppression.lua"
DIALOGUE = ADDON / "Quest" / "Dialogue.lua"
COMMANDS = ADDON / "Core" / "Commands.lua"
TOC = ADDON / "Logres.toc"
BOOTSTRAP = ADDON / "Core" / "Bootstrap.lua"

errors = []

for path in (SUPPRESSION, DIALOGUE, COMMANDS, TOC, BOOTSTRAP):
    if not path.is_file():
        errors.append(f"missing required file: {path.relative_to(ROOT)}")

suppression = SUPPRESSION.read_text(encoding="utf-8") if SUPPRESSION.is_file() else ""
dialogue = DIALOGUE.read_text(encoding="utf-8") if DIALOGUE.is_file() else ""
commands = COMMANDS.read_text(encoding="utf-8") if COMMANDS.is_file() else ""
toc = TOC.read_text(encoding="utf-8") if TOC.is_file() else ""
bootstrap = BOOTSTRAP.read_text(encoding="utf-8") if BOOTSTRAP.is_file() else ""

for fragment in (
    'Logres:RegisterModule("QuestOfferStockSuppression"',
    'local SOURCE_COMMIT = "15666a6e67938a1ab5caf041406464251db111ca"',
    '_G.QuestFrameDetailPanel',
    '_G.QuestFrameAcceptButton',
    '_G.QuestFrameDeclineButton',
    'safeBoolean("auto-accept", QuestGetAutoAccept)',
    'safeBoolean("pvp-offer", QuestFlagsPVP)',
    '"pvp-confirmation-required"',
    '"auto-accept-offer"',
    'snapshot.frame:SetAlpha(0)',
    'snapshot.frame:EnableMouse(false)',
    'snapshot.frame:SetAlpha(snapshot.alpha)',
    'snapshot.frame:EnableMouse(snapshot.mouseEnabled)',
    'frame:SetAlpha(1)',
    'frame:EnableMouse(true)',
    'detailPanel:HookScript("OnShow"',
    'detailPanel:HookScript("OnHide"',
    'self.eventFrame:RegisterEvent("QUEST_PROGRESS")',
    'self.eventFrame:RegisterEvent("QUEST_COMPLETE")',
    'self.eventFrame:RegisterEvent("QUEST_FINISHED")',
    'self.eventFrame:RegisterEvent("QUEST_ACCEPTED")',
    'self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")',
    'function Suppression:RequestEnabled(enabled, reason)',
    'function Suppression:GetDebugStatus()',
    'self:Restore("module-disabled")',
):
    if fragment not in suppression:
        errors.append(f"OfferStockSuppression.lua missing P0165 fragment: {fragment}")

for forbidden in (
    'QuestFrame:Hide',
    'QuestFrame:Show',
    'QuestFrameDetailPanel:Hide',
    'QuestFrameDetailPanel:Show',
    'SetParent(',
    'C_Timer.',
    'SetScript("OnUpdate"',
    'hooksecurefunc',
    'HideUIPanel(',
    'ShowUIPanel(',
    'AcceptQuest(',
    'DeclineQuest(',
    'CompleteQuest(',
    'GetQuestReward(',
    'C_GossipInfo.',
):
    if forbidden in suppression:
        errors.append(
            "quest-offer stock suppression exceeds narrow surface/lifecycle scope: "
            + forbidden
        )

# The potentially secret alpha snapshot is restoration-only: no type, compare,
# formatting, or arithmetic is allowed on snapshot.alpha.
for forbidden in (
    'type(snapshot.alpha)',
    'tostring(snapshot.alpha)',
    'snapshot.alpha ==',
    'snapshot.alpha ~=',
    'snapshot.alpha <',
    'snapshot.alpha >',
    'snapshot.alpha +',
    'snapshot.alpha -',
    'snapshot.alpha *',
    'snapshot.alpha /',
):
    if forbidden in suppression:
        errors.append("opaque stock alpha restoration token is inspected: " + forbidden)

for fragment in (
    'function Dialogue:RequestStockOfferSuppression(enabled, reason)',
    '"QuestOfferStockSuppression"',
    'self:RequestStockOfferSuppression(',
    'false,\n        reason or "hide-presentation"',
    '"offer-action-started"',
    '"offer-action-blocked"',
    "self.offerActionsEnabled = false",
    'stockOfferSuppressionApplied =',
    'lastStockOfferSuppressionResult =',
):
    if fragment not in dialogue:
        errors.append(f"Dialogue.lua missing P0165 ownership integration: {fragment}")

# Restore must be requested before the dialogue root/control surfaces are hidden.
hide_start = dialogue.find("function Dialogue:HidePresentation(reason)")
hide_end = dialogue.find("function Dialogue:ClearFailure", hide_start)
hide_block = dialogue[hide_start:hide_end] if hide_start != -1 and hide_end != -1 else ""
restore_call = hide_block.find("self:RequestStockOfferSuppression(")
root_hide = hide_block.find("self.root:Hide()")
if restore_call == -1 or root_hide == -1 or restore_call > root_hide:
    errors.append("Dialogue must restore stock offer controls before withdrawing Logres presentation")

# Preview must not require stock suppression; production controls only surface
# when stock ownership is actually applied.
update_start = dialogue.find("function Dialogue:UpdateOfferControls()")
update_end = dialogue.find("function Dialogue:HandleOfferAction", update_start)
update_block = dialogue[update_start:update_end] if update_start != -1 and update_end != -1 else ""
for fragment in (
    "local previewEligible =",
    "local productionEligible =",
    "stockApplied =",
    "stockApplied and finalPage",
):
    if fragment not in update_block:
        errors.append("Dialogue offer-control gating missing: " + fragment)

for fragment in (
    "local function runQuestOfferStockSuppressionCheck()",
    'Logres:GetModule("QuestOfferStockSuppression")',
    '"Logres questofferstocksuppressioncheck: %s',
    'if command == "questofferstocksuppressioncheck" then',
    '"Quest Offer Stock Check"',
    '"questofferstocksuppressioncheck"',
    "runQuestOfferStockSuppressionCheck()",
):
    if fragment not in commands:
        errors.append(f"Commands.lua missing P0165 diagnostics: {fragment}")

run_all_start = commands.find("local function runAllChecks()")
run_all_end = commands.find("local function handleHUDPreview", run_all_start)
run_all = commands[run_all_start:run_all_end] if run_all_start != -1 and run_all_end != -1 else ""
if "runQuestOfferStockSuppressionCheck()" not in run_all:
    errors.append("Run All must include the non-mutating stock-offer suppression check")

if "Quest\\OfferStockSuppression.lua" not in toc:
    errors.append("Logres.toc missing Quest\\OfferStockSuppression.lua")

if toc.find("Quest\\OfferStockSuppression.lua") > toc.find("Quest\\Dialogue.lua"):
    errors.append("OfferStockSuppression.lua must load before Dialogue.lua")

bootstrap_match = re.search(r'Logres\.VERSION = "([^"]+)"', bootstrap)
toc_match = re.search(r"^## Version: (.+)$", toc, re.MULTILINE)
bootstrap_version = bootstrap_match.group(1) if bootstrap_match else None
toc_version = toc_match.group(1).strip() if toc_match else None
if bootstrap_version is None or toc_version is None:
    errors.append("could not read Bootstrap/TOC runtime version")
elif bootstrap_version != toc_version:
    errors.append("Bootstrap and TOC runtime versions must match")

# P0168 expands P0165's already-proven ordinary-offer ownership to the
# redundant QuestFrame visual shell while preserving native quest lifecycle.
for fragment in (
    'function Suppression:CaptureOfferPresentation()',
    'local questFrame = _G.QuestFrame',
    'readShown(questFrame, "quest-frame")',
    'function Suppression:SuppressOfferPresentation(snapshot)',
    'snapshot.frame:SetAlpha(0)',
    'snapshot.mouseFrames[index].frame:EnableMouse(false)',
    'function Suppression:RestoreOfferPresentation(snapshot)',
    'entry.frame:EnableMouse(entry.mouseEnabled)',
    'snapshot.frame:SetAlpha(snapshot.alpha)',
    'function Suppression:EmergencyRestoreOfferPresentation(snapshot)',
    'local visualSnapshot, visualError =',
    'self:CaptureOfferPresentation()',
    'self:SuppressOfferPresentation(snapshot.visual)',
    'self:RestoreOfferPresentation(snapshot.visual)',
    'visualOwned = self.appliedEnabled == true',
    'visualFrameCount =',
):
    if fragment not in suppression:
        errors.append("P0168 quest visual contract missing: " + fragment)

# The source must never hide/reparent QuestFrame or use polling to reassert it.
for forbidden in ('QuestFrame:Hide(', 'QuestFrame:SetParent(', 'C_Timer.After(',
                  'SetScript("OnUpdate"', 'hooksecurefunc('):
    if forbidden in suppression:
        errors.append("P0168 broad quest-frame mutation forbidden: " + forbidden)

visual_start = suppression.find('function Suppression:CaptureOfferPresentation()')
visual_end = suppression.find('function Suppression:ApplySuppression(reason)', visual_start)
visual = suppression[visual_start:visual_end] if visual_start >= 0 and visual_end > visual_start else ''
if visual.find('if isSecret(child) then') < 0 or visual.find('return nil, "quest-frame-child-secret"') < 0:
    errors.append('P0168 must fail open on secret-capable child references')
if visual.find('return nil, "quest-frame-subtree-too-large"') < 0:
    errors.append('P0168 must bound QuestFrame subtree walk')

print("Logres P0165 quest-offer stock suppression contract")
print("====================================================")

if errors:
    for error in errors:
        print(f"ERROR: {error}")
    print(f"\nFAILED: {len(errors)} error(s)")
    raise SystemExit(1)

print("PASS: 0 errors")
