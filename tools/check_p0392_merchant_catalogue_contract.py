#!/usr/bin/env python3
"""P0392 merchant preview and explicit read-only live surface contract."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
def read(name):
    return (root / name).read_text(encoding="utf-8")

source = read("Logres/Quest/MerchantCatalogue.lua")
toc = read("Logres/Logres.toc")
commands = read("Logres/Core/Commands.lua")
panel = read("Logres/Dev/Panel.lua")
assert toc.count("Quest\\MerchantCatalogue.lua") == 1
assert toc.index("UI\\NPCServiceCatalogue.lua") < toc.index("Quest\\MerchantCatalogue.lua")
for token in (
    "local function render()", "Logres.PanelSurface.Paint",
    "Logres.NPCServiceCatalogue.Window", "local function readCatalogue()",
    "ordinary(count)", "ordinary(info)", "ordinary(value) and type(value)",
    'model = { state = "unavailable", items = {} }',
    "item.extended ~= false or not item.currencyKnown",
    'function Merchant.Preview()', 'function Merchant.OpenLive()',
    "if not visit or not merchantContext(Logres:GetState())",
    'Logres:GetPreference("immersionEnabled") == true',
    "state.interactionType == 5", 'Logres:SubscribePreferences(',
    '"MERCHANT_SHOW"', '"MERCHANT_UPDATE"', '"MERCHANT_CLOSED"',
    '"PLAYER_ENTERING_WORLD"', "if live then refresh() end",
    'state = "list"', 'state = "empty"', 'state = "unavailable"', 'state = "handoff"',
):
    assert token in source, token
for forbidden in (
    "BuyMerchantItem(", "SellCursorItem(", "BuybackItem(", "RepairAllItems(",
    "CloseMerchant(", "MerchantFrame:", "MerchantFrame.", "HideUIPanel(",
    'SetScript("OnUpdate"', "C_Timer", "hooksecurefunc", "SetParent(",
):
    if forbidden == "MerchantFrame.":
        assert forbidden not in source.replace("C_MerchantFrame.GetItemInfo", "")
    else:
        assert forbidden not in source, forbidden
preview = source.split("function Merchant.Preview()", 1)[1].split("local function refresh()", 1)[0]
assert "readCatalogue" not in preview and "return show()" in preview
assert '"merchantpreview",\n    "P"' in commands and 'command == "merchantlive"' in commands
assert "incident.snapshot.merchant = pickTraceStatus" in panel
assert "self.NPCMerchantCatalogue.GetAudit()" in panel
assert "P0392_MERCHANT_CATALOGUE.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0392 merchant source, shared renderer, explicit visit scope and native control boundaries: PASS (STATIC)")
