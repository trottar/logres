#!/usr/bin/env python3
"""Session 44 regressions and native fail-open contracts."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]

def read(name):
    return (root / ("Logres/" + name)).read_text(encoding="utf-8")

trainer = read("Quest/TrainerLiveTrial.lua")
assert "if availableCount ~= 1 then selected = nil end" in trainer
assert "if selected then selected.selected = true end" in trainer
assert "browse.defaultServiceIndex == browse.selectedServiceIndex" in trainer
assert 'and "Train · Confirm" or "Train selected"' in trainer
assert 'if not browse.model.trainEnabled then' in trainer
purchase = read("Quest/TrainerProfessionPurchaseTrial.lua")
confirm = purchase.split("local function confirmProfession", 1)[1].split("function Trial.Attempt", 1)[0]
assert 'BuyTrainerService' not in confirm
assert confirm.index("ordinary(byService)") < confirm.index("byService[serviceIndex]")
assert confirm.index("nativeIndex ~= serviceIndex") < confirm.index("pcall(selectDisplay")
assert confirm.index("scalar(selection) ~= serviceIndex") < confirm.index('pcall(show, "CONFIRM_PROFESSION")')
assert "second ~= nil" in confirm and 'if popup then return true' in confirm
assert purchase.index('if money < copper') < purchase.index('return confirmProfession(root, row.serviceIndex)')
assert purchase.count('pcall(buy, row.serviceIndex)') == 1
assert 'RefreshAfterConfirmation' in read("UI/NPCServiceSession.lua")

dialogue = read("Quest/Dialogue.lua")
bridge = dialogue.split("function Dialogue:BeginNativeQuestHandoff", 1)[1].split(
    "function Dialogue:ProgressGate", 1)[0]
assert bridge.index("CanBridgeVisual(snapshot)") < bridge.index("SuppressOfferPresentation")
assert bridge.count("pcall(C_Timer.After, 1.25") == 1
assert "self.nativeQuestHandoff ~= handoff" in bridge
assert 'and not self:EndNativeQuestHandoff(event)' in dialogue.split(
    'function(_, event, ...)', 1)[1]
assert 'self:EndNativeQuestHandoff("immersion-off")' in dialogue
assert 'self:EndNativeQuestHandoff("dialogue-disabled")' in dialogue
greet = read("Quest/NPCGossipQuestChoice.lua")
assert greet.index('BeginNativeQuestHandoff("greeting-selection")') < greet.index(
    'Greeting.Restore("native-quest-selected")') < greet.index('pcall(selectFn, chosen.questIndex)')
claim = read("Quest/CompletionControl.lua")
assert claim.index('self:Restore("claim-invoked")') < claim.index(
    'pcall(_G.QuestRewardCompleteButton_OnClick)') < claim.index('BeginNativeQuestHandoff("claim")')

native = read("HUD/NativeDebuffs.lua")
assert "Native.BoostedRestSpellID = 1229451" in native
assert 'candidateFilters = unit == "player" and Native.UsesStockBoostedRest()' in native
assert "excludeSpellIDs = {[Native.BoostedRestSpellID] = true}" in native
assert "aura.spellId" not in native
lua = read("HUD/StatusAuras.lua")
assert 'unit == "player" and Logres.NativeDebuffs.UsesStockBoostedRest()' in lua
assert "not isSecret(spellID) and spellID == Logres.NativeDebuffs.BoostedRestSpellID" in lua
panel = read("Dev/Panel.lua")
assert '"walletCopper", "trainLabel", "trainEnabled", "confirmationPending"' in panel
print("P0390 session 44 safety contracts PASS")
