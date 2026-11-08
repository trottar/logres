#!/usr/bin/env python3
"""P0393 trainer-style merchant with native input and reversible geometry."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
def read(name):
    return (root / name).read_text(encoding="utf-8")

source = read("Logres/Quest/MerchantCatalogue.lua")
for token in (
    "Logres.PanelConfigs.trainer", "config.preview, config.landscape",
    "Logres.PanelSurface.Paint(owner, config.surface, visual.width, visual.height)",
    "visual.point, UIParent, visual.relativePoint, visual.x, visual.y",
    "shell(art, merchantName(), false)", 'shell(frame, "Tailoring Supplies", true)',
    'read(frame, "IsForbidden") == false', 'read(frame, "IsProtected") == false',
    "ordinary(locked) and locked == false", '"GetPoint"', '"GetSize"', '"GetAlpha"',
    "unpack(token, 1, 5)", "set(frame, w, h)", "set(region, alpha)",
    'member(_G, "MerchantFrameTab1")', 'member(_G, "MerchantFrameTab2")',
    'member(row, "ItemButton")', 'read(button, "GetParent") ~= row',
    'member(frame, "FilterDropdown")', "for i = 2, 12, 2 do",
    "local ok, plan, goodbyeMode, tabs = pcall(capture, frame)", "live.applied = i",
    "pcall(action.apply)", 'restore("stock-layout-restored")',
    'restore("stock-requested")', 'restore("merchant-closed")',
    'restore("merchant-hidden")', 'restore("merchant-context-ended")',
    'restore("immersion-off")', 'restore("world-changed")',
    '"PLAYER_REGEN_ENABLED"', 'stockOnly, result = true, "stock-layout-unsupported"',
):
    assert token in source, token
assert source.count(":SetScript(") == 1  # Inert preview Close only.
assert "SetParent(" not in source and ":Click(" not in source
assert 'EnableMouse(false)' in source and 'frame:Hide()' in source.split("local function buildPreview()", 1)[1]
assert "merchant.IsActive()" in read("Logres/Quest/NativeServicePlacementTrial.lua")
assert "P0393_TRAINER_STYLE_MERCHANT.md" in read("docs/memory/investigations/ISSUE_LEDGER.md")
print("P0393 trainer shell, native input ownership, capability gates and restoration: PASS (STATIC)")
