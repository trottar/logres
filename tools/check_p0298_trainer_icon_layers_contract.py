#!/usr/bin/env python3
"""P0298: maintain explicit live icon image priority; no native source or transaction changes."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
read = lambda path: (R / path).read_text(encoding='utf-8')
land = read('Logres/Quest/TrainerLandscape.lua')
config = read('Logres/Quest/TrainerPanelConfig.lua')
trial = read('Logres/Quest/TrainerLiveTrial.lua')
purchase = read('Logres/Quest/TrainerPurchaseTrial.lua')
old = read('tools/check_p0297_trainer_icon_backplate_contract.py')
evidence = read('docs/memory/evidence/P0298_TRAINER_ICON_DRAW_LAYERS.md')
errors = []
def need(condition, message):
    if not condition: errors.append(message)
start = land.find('local function icon(owner, path, x, y, side, live)')
end = land.find('local function boundedString(', start)
icon = land[start:end] if start >= 0 and end > start else ''
need(bool(icon), 'missing scoped shared icon renderer')
for token in (
    'rect(f, 0, 0, side, side, config.palette.liveIconBacking):SetDrawLayer("BACKGROUND", -1)',
    'rect(f, 0, 0, side, side, config.palette.iconBorder)',
    'img:SetDrawLayer("OVERLAY", 1)',
    'img:SetTexture(path)',
    'rect(f, 0, 0, side, 1, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)',
    'rect(f, 0, side - 1, side, 1, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)',
    'rect(f, 0, 0, 1, side, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)',
    'rect(f, side - 1, 0, 1, side, config.palette.iconBorder):SetDrawLayer("OVERLAY", 2)',
): need(token in icon, 'missing deterministic owned draw layer: '+token)
need(icon.index('if live then') < icon.index('img:SetDrawLayer("OVERLAY", 1)'),
     'artwork priority must be live-only')
need(icon.count('img:SetDrawLayer("OVERLAY", 1)') == 1,
     'preview branch may not alter icon image layer')
need('local _, image = icon(row, datum.icon, 7, 5, 40, view.localBrowse)' in land,
     'existing live skill art call changed')
need('local _, selectedImage = icon(selected, view.selected.icon, 5, 7, 53, view.localBrowse)' in land,
     'existing live detail art call changed')
need('local reagent = icon(owner, item.icon, g.reagents.x, y, 42)' in land,
     'inert reagent fixture route changed')
need('slot.image:SetTexture(datum.icon)' in land and
     'controls.detail.icon:SetTexture(view.selected.icon)' in land,
     'in-place icon texture binding changed')
need('return Landscape.Render(owner, Landscape.Fixture())' in land,
     'accepted preview route changed')
need('liveIconBacking = {0.06, 0.04, 0.025, 0.96}' in config,
     'live cosmetic palette changed')
need('P0297' in old and 'liveIconBacking' in old,
     'historical P0297 checker lost')
need('Logres.NPCTrainerPurchaseTrial.Attempt(' in trial and
     'browse.scrollSlider:SetValue(browse.offset)' in trial,
     'existing controller or scroll contract changed')
need('local buyOK = pcall(buy, row.serviceIndex)' in purchase,
     'existing isolated purchase gate changed')
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
                  'SetTrainerServiceTypeFilter(', 'SetScript("OnUpdate"',
                  'hooksecurefunc(', 'C_Timer.After('):
    need(forbidden not in land, 'forbidden native mutation or polling: '+forbidden)
for word in ('P0297', 'P0298', 'FAIL', 'UNVERIFIED', 'BACKGROUND', 'OVERLAY', 'Blizzard', 'purchase'):
    need(word.lower() in evidence.lower(), 'evidence missing '+word)
current = read('docs/memory/CURRENT.md')
need(len(current.encode()) < 10000 and current.count('## Next Action') == 1,
     'CURRENT exceeds maintenance budget or headings invalid')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(bool(a and b and a.group(1) == b.group(1)), 'version parity mismatch')
print('P0298 trainer icon layer isolation contract')
for err in errors: print('ERROR:', err)
if errors: raise SystemExit(1)
print('PASS: live overlay source image priority, preview preserved, native ownership unchanged')
