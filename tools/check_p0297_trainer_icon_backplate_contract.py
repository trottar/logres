#!/usr/bin/env python3
"""P0297: contain live trainer gold icon fill without touching source or transactions."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda name: (R / name).read_text(encoding='utf-8')
l = read('Logres/Quest/TrainerLandscape.lua')
c = read('Logres/Quest/TrainerPanelConfig.lua')
v = read('Logres/Quest/TrainerLiveTrial.lua')
t = read('Logres/Quest/TrainerPurchaseTrial.lua')
e = read('docs/memory/evidence/P0297_TRAINER_ICON_BACKPLATE.md')
p = read('tools/check_p0296_trainer_scroll_train_contract.py')
errors = []
def need(cond, why):
    if not cond: errors.append(why)
start = l.find('local function icon(owner, path, x, y, side, live)')
end = l.find('local function boundedString(', start)
need(start >= 0 and end > start, 'missing scoped icon helper')
segment = l[start:end] if start >= 0 and end > start else ''
for token in (
    'if live then',
    'rect(f, 0, 0, side, side, config.palette.liveIconBacking)',
    'rect(f, 0, 0, side, side, config.palette.iconBorder)',
    'img:SetTexture(path)',
    'rect(f, 0, 0, side, 1, config.palette.iconBorder)',
    'rect(f, 0, side - 1, side, 1, config.palette.iconBorder)',
    'rect(f, 0, 0, 1, side, config.palette.iconBorder)',
    'rect(f, side - 1, 0, 1, side, config.palette.iconBorder)',
    'return f, img',
):
    need(token in segment, 'missing live-only backing or existing fixture: ' + token)
need('liveIconBacking = {0.06, 0.04, 0.025, 0.96}' in c, 'live backdrop not palette-defined')
need('local _, image = icon(row, datum.icon, 7, 5, 40, view.localBrowse)' in l,
     'reused skill icon must route through live art')
need('local _, selectedImage = icon(selected, view.selected.icon, 5, 7, 53, view.localBrowse)' in l,
     'detail icon must route through same live art')
need('local reagent = icon(owner, item.icon, g.reagents.x, y, 42)' in l,
     'fixture reagent painter changed')
need('slot.image:SetTexture(datum.icon)' in l and 'controls.detail.icon:SetTexture(view.selected.icon)' in l,
     'dynamic icon updates lost')
need('return Landscape.Render(owner, Landscape.Fixture())' in l, 'synthetic P fixture changed')
for token in ('browse.localChoiceConfirmed = true', 'browse.scrollSlider:SetValue(browse.offset)',
              'Logres.NPCTrainerPurchaseTrial.Attempt(', 'root:EnableMouse(false)'):
    need(token in v, 'live selection/slider/transaction boundary lost: ' + token)
need('local buyOK = pcall(buy, row.serviceIndex)' in t, 'existing explicit single-skill purchase removed')
for banned in ('BuyTrainerService(', 'SelectTrainerService(', 'SetTrainerServiceTypeFilter(',
               'SetScript("OnUpdate"', 'C_Timer.After(', 'hooksecurefunc('):
    need(banned not in l, 'icon painter may not mutate native state or poll: ' + banned)
need('P0296' in p, 'historical P0296 checker missing')
for token in ('P0296','P0297','PASS','FAIL','gold','Blizzard','UNVERIFIED','icon'):
    need(token.lower() in e.lower(), 'runtime evidence missing: ' + token)
current = read('docs/memory/CURRENT.md')
need(len(current.encode()) < 10000 and current.count('## Next Action') == 1,
     'CURRENT maintenance threshold/section failure')
a = re.search(r'(?m)^## Version: (\S+)$', read('Logres/Logres.toc'))
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1) == b.group(1)), 'TOC/bootstrap version mismatch')
print('P0297 live-only trainer icon backing contract')
for error in errors: print('ERROR:',error)
if errors: raise SystemExit(1)
print('PASS: live dark icon backing/edge-only gold, P fixture and purchase gates preserved')
