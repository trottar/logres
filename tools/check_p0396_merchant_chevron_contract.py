#!/usr/bin/env python3
"""P0396 shared chevrons on original merchant page controls."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
def read(path):
    return (root / path).read_text(encoding="utf-8")

source = read("Logres/Quest/MerchantCatalogue.lua")
pages = read("Logres/UI/NarrativePages.lua")
dialogue = read("Logres/Quest/Dialogue.lua")
assert 'function Pages.CreateChevron(owner, previous)' in pages
assert 'Logres.Theme.questDialogue.assets.pageChevron' in pages
assert 'texture:SetTexCoord(1, 0, 0, 1)' in pages
for token in (
    'CreateChevron(owner, previous)', 'colors.pageActive or colors.pageInactive',
    'local enabled = read(button, "IsEnabled")', 'method(button, "GetRegions")',
    'ordinary(region) or read(region, "GetParent") ~= button',
    'if labels ~= 1 then return false end',
    'pcall(hook, button, "OnEnable"', 'pcall(hook, button, "OnDisable"',
    'if styled then append(plan, art) end',
    'member(_G, "MerchantPageText")', 'pagerStyled = live and live.pagerStyled or false',
    'indicator:SetFormattedText("%d / %d", page, count)',
):
    assert token in source, token
for name, reverse in (("previousButton", "true"), ("nextButton", "false")):
    assert f'Logres.NPCNarrativePages.CreateChevron({name}, {reverse})' in dialogue
live = source.split("local function buildPreview()", 1)[0]
assert "SetScript(" not in live and "SetEnabled(" not in live
assert 'MerchantNextPageButton_OnClick' not in live and 'MerchantPrevPageButton_OnClick' not in live
assert "StackSplitFrame" not in live
assert '"pagerStyled"' in read("Logres/Dev/Panel.lua")
assert "P0396_MERCHANT_PAGE_CHEVRONS.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0396 quest chevron reuse, native pager state, optional stock fallback and inert preview: PASS (STATIC)")
