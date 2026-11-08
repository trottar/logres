#!/usr/bin/env python3
"""P0392 retained gallery, provenance and vendor transaction ownership."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
def read(name):
    return (root / name).read_text(encoding="utf-8")

source = read("Logres/Quest/MerchantCatalogue.lua")
toc = read("Logres/Logres.toc")
commands = read("Logres/Core/Commands.lua")
panel = read("Logres/Dev/Panel.lua")
assert toc.count(r"Quest\MerchantCatalogue.lua") == 1
assert toc.index(r"UI\PanelSurface.lua") < toc.index(r"Quest\MerchantCatalogue.lua")
assert '"merchantpreview",\n    "P"' in commands and 'command == "merchantlive"' in commands
assert "incident.snapshot.merchant = pickTraceStatus" in panel
assert "self.NPCMerchantCatalogue.GetAudit()" in panel
for forbidden in (
    "BuyMerchantItem", "SellCursorItem", "BuybackItem", "RepairAllItems",
    "CloseMerchant", "PickupMerchantItem", "OpenStackSplitFrame",
    "HideUIPanel", "ShowUIPanel",
):
    assert not re.search(r"\b" + forbidden + r"\s*\(", source), forbidden
assert 'SetScript("OnUpdate"' not in source and "C_Timer" not in source
assert "P0392_MERCHANT_CATALOGUE.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
assert "P0392" in read("docs/memory/roadmap/STATUS.md")
print("P0392 retained preview, incident and native vendor transaction boundaries: PASS (STATIC)")
