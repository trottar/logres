#!/usr/bin/env python3
"""P0436 owned fixture: live health independence and unscaled aggro slot."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
read = lambda name: (ROOT / name).read_text(encoding="utf-8")
hud = read("Logres/HUD/HUD.lua")
panel = read("Logres/Settings/Panel.lua")
cmd = read("Logres/Core/Commands.lua")
aura = read("Logres/HUD/StatusAuras.lua")
db = read("Logres/Core/Database.lua")
boot = read("Logres/Core/Bootstrap.lua")
toc = read("Logres/Logres.toc")
preview = hud.split("function HUD:SetPreviewEnabled(enabled)",1)[1].split("local function readOrdinaryDeathTravelState",1)[0]
assert "self:SetEnemyDisplayPreview(enabled == true)" in preview
assert "SetHealthPreviewPercent" not in preview and "self.previewEnabled =" not in preview
assert "function HUD:SetHealthPreviewPercent(previewPercent)" in hud
assert "hud:SetPreviewEnabled(true)" in cmd and "hud:SetPreviewEnabled(false)" in cmd
assert "hud:SetHealthPreviewPercent(previewPercent)" in cmd
assert 'local aggroSlot = CreateFrame("Frame", nil, host)' in hud
assert 'aggroSlot:SetPoint("TOP", host, "TOP", 245, -252)' in hud
assert 'combatTarget:SetPoint("TOP", host, "TOP", -160, -252)' in hud
assert 'buildEnemyDisplayFixture(aggroSlot, nil, "Confirmed aggro", 43)' in hud
assert 'aggro:SetPoint("TOP", aggroSlot, "TOP", 0, 0)' in hud
assert hud.index('aggro:SetScale(0.5)') < hud.index('aggro:SetPoint("TOP", aggroSlot')
assert 'aggro:SetAlpha(0.5)' in hud
assert 'self.enemyPreviewUnits = {oocTarget, combatTarget, aggro}' in hud
assert 'root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)' in aura
assert 'root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)' in aura
assert 'screenSpaceEnemyFrameEnabled = false' in db
assert '"Fallback retained until safe overhead attachment"' in panel
assert 'enemyWorldAttachmentEnabled = false' in hud and 'enemyFallbackPreserved = true' in hud
assert 'C_NamePlate.GetNamePlates(' not in hud and 'SetCVar(' not in hud
assert re.search(r'(?m)^## Version: (\S+)$', toc).group(1) == re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$', boot).group(1)
for path in ("docs/ROADMAP.md", "docs/memory/investigations/ACTIVE.md",
             "docs/memory/roadmap/STATUS.md", "docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md"):
    value = read(path)
    assert re.match(r"## P[0-9]{4} —", value) and "## P0436 —" in value, path
    assert "## P0435 —" in value and "## P0427 —" in value
assert len(read('docs/memory/CURRENT.md').encode('utf-8')) < 9800
assert "P0425 visual PASS" in read('docs/memory/CURRENT.md')
assert "P0436" in read('docs/memory/PRE_HANDOFF_AUDIT.md')
assert "| L-011 |" in read('docs/memory/investigations/ISSUE_LEDGER.md')
print("P0436 enemy fixture: health separation, row-aligned half-scale, aura spacing, fail-open PASS (STATIC)")
