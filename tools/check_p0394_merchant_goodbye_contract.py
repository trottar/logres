#!/usr/bin/env python3
"""P0394 native merchant control styling with input and restoration guards."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
def read(name):
    return (root / name).read_text(encoding="utf-8")

source = read("Logres/Quest/MerchantCatalogue.lua")
for token in (
    "78, 24, -45, -12", 'label:SetText("Goodbye")',
    'label:SetTextColor(0.97, 0.78, 0.44, 1)',
    'line:SetPoint("BOTTOMLEFT", owner, "BOTTOMLEFT", 5, 0)',
    "local function goodbye(plan, frame, button)", 'pcall(artwork, button, goodbyeArt)',
    '"GetNormalTexture", "GetPushedTexture", "GetHighlightTexture", "GetDisabledTexture"',
    'and "goodbye" or "stock-x"', "overlay:EnableMouse(false)", "goodbyeArt(close)",
    'member(frame, "selectedTab")', 'read(button, "GetFrameLevel")', 'pcall(hook, button, "OnClick", refreshTabs)',
    "append(plan, changes)", 'member(_G, "MerchantPageText")',
    'member(_G, "MerchantPrevPageButton")', 'member(_G, "MerchantNextPageButton")',
):
    assert token in source, token
before_preview, preview_and_later = source.split("local function buildPreview()", 1)
preview, end_marker, _ = preview_and_later.partition("\nfunction Merchant.Preview()")
assert end_marker, "merchant preview builder boundary missing"
assert ":SetScript(" not in before_preview and preview.count(':SetScript("OnClick"') == 3
assert 'SetScript("OnClick", function() frame:Hide() end)' in source
for forbidden in ("StackSplitFrame", "CloseMerchant", "BuyMerchantItem", ":Click(", "EnableMouse(true)"):
    assert forbidden not in source, forbidden
assert '"goodbye", "tabsStyled"' in read("Logres/Dev/Panel.lua")
assert "P0394_MERCHANT_GOODBYE.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0394 native Goodbye, tabs, pager and fail-open appearance: PASS (STATIC)")
