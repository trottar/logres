#!/usr/bin/env python3
"""P0435 preview is an owned 100/50 shared visual fixture, not a native mutation."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding="utf-8")
db=read("Logres/Core/Database.lua")
pref=read("Logres/Core/Preferences.lua")
panel=read("Logres/Settings/Panel.lua")
hud=read("Logres/HUD/HUD.lua")
aura=read("Logres/HUD/StatusAuras.lua")
report=read("Logres/Dev/Panel.lua")
assert "screenSpaceEnemyFrameEnabled = false" in db
assert "local CURRENT_SCHEMA = 3" in db
assert "target[key] = value" in db
assert 'screenSpaceEnemyFrameEnabled = {' in pref
assert 'screenSpaceEnemyFrameEnabled = Logres.db.settings.screenSpaceEnemyFrameEnabled == true' in pref
assert 'screenSpaceEnemyFrameEnabled = previous.screenSpaceEnemyFrameEnabled' in pref
assert 'SetPreference("screenSpaceEnemyFrameEnabled"' in panel
assert 'GetPreference("screenSpaceEnemyFrameEnabled")' in panel
assert 'function HUD:BuildEnemyDisplayPreview()' in hud
assert 'function HUD:SetEnemyDisplayPreview(enabled)' in hud
assert 'self:SetEnemyDisplayPreview(enabled == true)' in hud
assert 'aggro:SetScale(0.5)' in hud and 'aggro:SetAlpha(0.5)' in hud
assert '"OUT OF COMBAT: only selected hostile' in hud
assert '"COMBAT: current target 100%' in hud
assert 'buildEnemyDisplayFixture(host' in hud
assert 'createPercentageBar(frame, nil, "normal"' in hud
assert 'styleEnemyNameText(targetNameText)' in hud
assert 'local function createLane(unit, point, relativePoint, offsetX, offsetY, laneName, previewParent)' in aura
assert 'slot:EnableMouse(previewParent == nil)' in aura
assert 'renderLane(harmful, PREVIEW.target, true)' in aura
assert 'renderLane(helpful, PREVIEW.targetHelpful, true)' in aura
assert 'root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)' in aura
assert 'root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)' in aura
assert 'enemyWorldAttachmentEnabled = false' in hud
assert 'enemyFallbackPreserved = true' in hud
assert '"enemyFallbackPreserved"' in report
assert '"screenSpaceEnemyFrameEnabled"' in report
for s in (hud,aura):
    assert 'SetCVar(' not in s
assert 'SetParent(_G.NamePlate' not in s
assert 'C_NamePlate.GetNamePlates(' not in s
for path in ("docs/ROADMAP.md", "docs/memory/investigations/ACTIVE.md",
             "docs/memory/roadmap/STATUS.md", "docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md"):
    value=read(path)
    # P0435 remains a historical checkpoint after later active work advances.
    assert re.match(r"## P[0-9]{4} —", value) and "## P0435 —" in value
    assert "## P0427 —" in value
assert len(read('docs/memory/CURRENT.md').encode())<9800
assert 'P0435' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
assert '| L-011 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
print('P0435 shared enemy visual fixture and preserved D-042 fallback PASS (STATIC)')
