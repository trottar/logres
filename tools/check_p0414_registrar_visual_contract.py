#!/usr/bin/env python3
"""P0414 Guild registrar visual correction after Forever #8259; STATIC only."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding="utf-8")
s = read("Logres/Quest/MerchantCatalogue.lua")
base = read("tools/check_p0413_guild_registrar_contract.py")
ledger = read("docs/memory/investigations/ISSUE_LEDGER.md")
proof = read("docs/memory/evidence/P0414_REGISTRAR_VISUAL_REPAIR.md")
for term in (
    "local function guildTextColor(plan, label, rgba)",
    'read(label, "GetObjectType") ~= "FontString"',
    'method(label, "GetTextColor"), method(label, "SetTextColor")',
    'not ordinary(r) or not ordinary(g)',
    'not ordinary(b) or not ordinary(a)',
    'undo = function() set(label, r, g, b, a) end',
    "local function guildHideCosmetic(plan, region)",
    'read(region, "IsShown")',
    'if shown then show(region) else hide(region) end',
    'read(choices[1], "GetFontString")',
    'read(choices[2], "GetFontString")',
    'member(root, "Inset"), member(root, "ScrollBar")',
    'member(_G, "GuildRegistrarNpcNameFrame")',
    'guildLabelAnchor(plan, heading, list.x + 44, list.y + 46, root)',
    'anchor(plan, choices[1], "TOPLEFT", root, "TOPLEFT",',
    'anchor(plan, choices[2], "TOPLEFT", root, "TOPLEFT",',
    'guildTextColor(plan, heading, palette.goldText)',
    'guildTextColor(plan, labels[1], palette.body)',
    'guildTextColor(plan, labels[2], palette.body)',
    'guildTextColor(plan, purchaseText, palette.body)',
    'guildTextColor(plan, costText, palette.goldText)',
    'inset and not guildFade(plan, inset)',
    'nameplate and not guildFade(plan, nameplate)',
    'scroll and not guildHideCosmetic(plan, scroll)',
    '"registrar-chrome-unsupported"',
    '"registrar-layout-unsupported"',
    'guildRestore("registrar-apply-rollback")',
    'guildRestore("registrar-immersion-off")',
):
    assert term in s, f"P0414 missing {term}"
assert s.count('function Merchant.Preview()') == 1
assert s.count('function Merchant.GuildPreview()') == 1
assert ":Click(" not in s and "SetParent(" not in s
assert 'BuyGuildCharter(' not in s and 'TurnInGuildCharter(' not in s
assert 'OnUpdate' not in s and 'C_Timer.' not in s
assert 'P0413' in base and 'VISUAL FAIL' in ledger and 'L-042' in ledger
assert '8259' in proof and 'UNVERIFIED' in proof
assert 'P0414' in read('docs/memory/CURRENT.md')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
v = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', boot)
assert v and b and v.group(1) == b.group(1)
print('P0414 registrar text/geometry/decor ownership, restoration: PASS (STATIC)')
