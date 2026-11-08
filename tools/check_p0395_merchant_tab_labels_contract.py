#!/usr/bin/env python3
"""P0395 live merchant tabs use only the localized native labels."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
source = (root / "Logres/Quest/MerchantCatalogue.lua").read_text(encoding="utf-8")
skin = source.split("local function skinTabs(", 1)[1].split("local function placePager(", 1)[0]
art = source.split("local function tabArt(", 1)[1].split("local function shell(", 1)[0]
preview = source.split("local function buildPreview(", 1)[1]
assert 'pcall(artwork, button, tabArt, nil, level - 1)' in skin
assert 'read(button, "GetFrameLevel")' in skin
assert 'GetFontString' not in skin and 'GetText' not in skin and 'CreateFontString' not in skin
assert 'if caption then\n        label = owner:CreateFontString' in art
assert 'if level then overlay:SetFrameLevel(level) end' in source
assert 'tabArt(tab, caption)(i == 1)' in preview
assert 'pcall(hook, button, "OnClick", refreshTabs)' in skin
assert 'P0395_MERCHANT_TAB_LABELS.md' in (root / "docs/memory/investigations/ISSUE_LEDGER.md").read_text(encoding="utf-8")
print("P0395 single native label, selection underlay and inert preview: PASS (STATIC)")
