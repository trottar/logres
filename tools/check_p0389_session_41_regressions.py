#!/usr/bin/env python3
"""P0389 source contracts for the session 41 ownership and presentation repairs."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]

def read(path):
    return (root / path).read_text(encoding="utf-8")

dialogue = read("Logres/Quest/Dialogue.lua")
offer = dialogue.split("function Dialogue:HandleOfferAction(kind)", 1)[1].split(
    "local function readOwnedFrameValue", 1)[0]
assert offer.index("local generation = self.presentationGeneration") < offer.index(
    "actionRuntime:TriggerProductionAction(") < offer.index(
    "if self.presentationGeneration ~= generation then") < offer.index(
    "self.offerActionPending = true")
assert offer.count("pcall(C_Timer.After, 1.5, function()") == 1
assert "self.presentationGeneration == generation and self.offerActionPending" in offer
assert "CanHoldOfferForTransition()" in offer
suppression = read("Logres/Quest/OfferStockSuppression.lua")
hold = suppression.split("function Suppression:CanBridgeVisual(snapshot)", 1)[1].split(
    "function Suppression:NotifyDialogue()", 1)[0]
assert 'combat ~= false' in hold and 'protected ~= false' in hold
accepted = dialogue.split('if event == "QUEST_ACCEPTED" then', 1)[1].split(
    'if event == "QUEST_TURNED_IN" then', 1)[0]
for token in ('accepted == self.pendingAcceptedOfferQuestID', 'self.optionSession.questGreeting == true',
              'Logres.QuestGreetingControl.IsParked()', 'late-accepted-greeting-preserved'):
    assert token in accepted
assert accepted.index('late-accepted-greeting-preserved') < accepted.index("self:ClearActiveDetail(")
assert "if self.progressContinuePending then" in dialogue.split(
    "function Dialogue:UpdateProgressPagePresentation()", 1)[1].split(
    "function Dialogue:ActivateProgressContinue()", 1)[0]
assert "self.completionRewardText = ownedRewardCopy(rewardSummary)" in dialogue
assert "self.completionRewardText = text" in dialogue
for path in ("NPCGossipQuestChoice.lua", "NPCGossipSource.lua"):
    source = read("Logres/Quest/" + path)
    assert "Ready to turn in: " in source and "Quest in progress: " in source

trainer = read("Logres/Quest/TrainerLiveTrial.lua")
assert trainer.index("elseif wallet < cost then") < trainer.index("model.trainEnabled = true")
assert 'Logres:RegisterEvent("PLAYER_MONEY"' in trainer and "ordinaryInput(wallet)" in trainer
assert "chosen.requiresProfessionConfirmation == nil" in trainer
purchase = read("Logres/Quest/TrainerProfessionPurchaseTrial.lua")
for reason in ("insufficient-funds", "service-cost-changed", "unsupported-cost-shape",
               "blizzard-confirmation-required"):
    assert purchase.index(reason) < purchase.index("pcall(buy, row.serviceIndex)")
assert purchase.count("pcall(buy, row.serviceIndex)") == 1

tracker = read("Logres/Quest/ActiveQuest.lua")
assert "not isSecret(row.required) and row.required == 1" in tracker
assert 'finished and " · Done" or " · Pending"' in tracker
panel = read("Logres/Dev/Panel.lua")
# P0418 gives Report Bug an independent addon-owned anchor. Preserve the
# historical accessibility/placement intent without re-coupling the button
# to P0172 native-access stock restoration.
assert 'Logres.Layout.Bind(bugButton, "reportBug", "CENTER", "CENTER")' in panel
assert 'bugButton:SetFrameStrata("LOW")' in panel
assert 'Logres.Layout.Bind(bugButton, "nativeAccess"' not in panel
assert "incident.snapshot.playerHarmful" in panel and "incident.snapshot.playerHelpful" in panel
ledger = read("docs/memory/investigations/ISSUE_LEDGER.md")
assert "| L-041 | Boosted Rest" in ledger and "P0389_SESSION_41_REGRESSIONS.md" in ledger
assert "P0389 exact-candidate" in read("docs/memory/PRE_HANDOFF_AUDIT.md")
print("P0389 session 41 source contracts PASS (Forever runtime UNVERIFIED)")
