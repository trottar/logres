#!/usr/bin/env python3
"""P0391 trainer continuity and player-only stock debuff ownership."""
from pathlib import Path
root = Path(__file__).resolve().parents[1]
def read(path):
    return (root / path).read_text(encoding="utf-8")
trainer = read("Logres/Quest/TrainerLiveTrial.lua")
train = trainer.split('trainHit:SetScript("OnMouseUp"', 1)[1].split("local bulkHit", 1)[0]
assert train.index("visit.trainingPending = pending") < train.index("PurchaseTrial.Attempt(")
assert 'Trial.Disable("native-purchase-requested-unconfirmed")' not in train
assert "if browse ~= visit then return end" in train
assert "pending.updateObserved then Trial.RefreshAfterTraining()" in train
assert 'model.trainLabel = "Training requested"' in trainer
refresh = trainer.split("function Trial.RefreshAfterTraining()", 1)[1].split(
    "function Trial.Toggle", 1)[0]
assert "pending.dispatching" in refresh and "pending.updateObserved = true" in refresh
assert 'Trial.Toggle("on", true)' in refresh
assert 'Trial.Disable("native-purchase-deferred")' in refresh
assert "if reuseParking then" in trainer and "browse.stockParked = true" in trainer
session = read("Logres/UI/NPCServiceSession.lua")
assert "RefreshAfterTraining()" in session.split('Logres:RegisterEvent("TRAINER_UPDATE"', 1)[1]

native = read("Logres/HUD/NativeDebuffs.lua")
assert "local root = _G.DebuffFrame" in native
assert 'unit ~= "player" or Native.StockPlayerHarmful() == nil' in native
assert "excludeSpellIDs" not in native and "aura.spellId" not in native
assert 'type(Logres.Layout.GetAnchor) == "function"' in native
assert 'and Logres.Layout.GetAnchor("playerHarmful")' in native
assert 'root:SetPoint("BOTTOM", anchor, "CENTER", 0, 0)' in native
assert "ordinary(protected)" in native and "protected ~= false" in native
assert "saved.root:SetPoint(p[1], p[2], p[3], p[4], p[5])" in native
assert "if relative == saved.anchor then" in native
assert "if not active or placementEvent then placeStockPlayerHarmful" in native
assert "state.stockPlacementAttempted" in native
assert "DebuffFrame:Hide(" not in native and 'SetScript("OnUpdate"' not in native
assert "active and not useNative and not stock" in read("Logres/HUD/StatusAuras.lua")
assert '"stockPlayerHarmful", "stockPlayerPlacementReason"' in read("Logres/Dev/Panel.lua")
assert "P0391_FOREVER_SESSION_45.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0391 session 45 contracts PASS")
