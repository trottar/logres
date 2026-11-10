#!/usr/bin/env python3
"""P0437: no gold HP underline on the owned enemy preview or target fallback."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
read = lambda name: (ROOT / name).read_text(encoding='utf-8')
hud = read('Logres/HUD/HUD.lua')
auras = read('Logres/HUD/StatusAuras.lua')
settings = read('Logres/Settings/Panel.lua')
database = read('Logres/Core/Database.lua')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
assert 'local accent = frame:CreateTexture(nil, "ARTWORK")' not in hud
assert 'local targetAccent = targetFrame:CreateTexture(nil, "ARTWORK")' not in hud
assert 'targetAccent:SetPoint(' not in hud
assert 'accent:SetPoint("TOP", bar, "BOTTOM"' not in hud
assert 'local rowAccent = rowFrame:CreateTexture(nil, "ARTWORK")' in hud  # unrelated ally/pet art unchanged
assert 'targetHealthBar:SetPoint("TOP", targetNameText, "BOTTOM", 0, -4)' in hud
assert 'bar:SetPoint("TOP", nameText, "BOTTOM", 0, -4)' in hud
assert 'local cue = createCastCue(frame, nil)' in hud
assert 'local targetCastCue = createCastCue(' in hud
assert 'styleEnemyNameText(targetNameText)' in hud
assert 'aggro:SetScale(0.5)' in hud and 'aggro:SetAlpha(0.5)' in hud
assert 'aggroSlot:SetPoint("TOP", host, "TOP", 245, -252)' in hud
assert 'root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)' in auras
assert 'root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)' in auras
assert 'screenSpaceEnemyFrameEnabled = false' in database
assert 'GetPreference("screenSpaceEnemyFrameEnabled")' in settings
assert 'enemyWorldAttachmentEnabled = false' in hud
assert 'enemyFallbackPreserved = true' in hud
assert 'SetCVar(' not in hud and 'C_NamePlate.GetNamePlates(' not in hud
assert re.search(r'(?m)^## Version: (\S+)$', toc).group(1) == re.search(r'(?m)^Logres.VERSION = "([^"\n]+)"$', boot).group(1)
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'):
    value = read(p)
    assert value.startswith('## P0437 —'), p
    assert '## P0436 —' in value and '## P0435 —' in value and '## P0427 —' in value
assert len(read('docs/memory/CURRENT.md').encode()) < 9800
assert 'P0425 visual PASS' in read('docs/memory/CURRENT.md')
assert '| L-046 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0437' in read('docs/memory/PRE_HANDOFF_AUDIT.md')
print('P0437 PASS: gold enemy HP underlines retired, target/aura/fallback boundaries preserved (STATIC)')
