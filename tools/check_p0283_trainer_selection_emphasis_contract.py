#!/usr/bin/env python3
"""P0283 P-only row-state emphasis; native H motif still stock-owned."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
read = lambda name: (root / name).read_text(encoding='utf8')
landscape = read('Logres/Quest/TrainerLandscape.lua')
motif = read('Logres/Quest/TrainerMotif.lua')
config = read('Logres/Quest/TrainerPanelConfig.lua')
skin = read('Logres/Quest/NativeTrainerSkin.lua')
old1 = read('tools/check_p0281_landscape_trainer_preview_contract.py')
old2 = read('tools/check_p0282_trainer_parchment_fidelity_contract.py')
toc = read('Logres/Logres.toc')
bootstrap = read('Logres/Core/Bootstrap.lua')
evidence = read('docs/memory/evidence/P0283_TRAINER_SELECTION_EMPHASIS.md')
errors = []
def need(ok, detail):
    if not ok:
        errors.append(detail)

for token in (
    'local rowState = datum.disabled and "disabled"',
    'or (datum.selected and "selected" or "normal")',
    'Logres.NPCTrainerMotif.PaintFixtureRow(row, rowState)',
    'if rowState == "selected" then',
    'local nameColor = p.body',
    'if rowState == "selected" then nameColor = p.goldText',
    'elseif rowState == "disabled" then nameColor = p.muted end',
    '"GameFontNormal", nameColor',
    'p.sidebarWash', 'p.catalogueWash', 'p.detailWash',
    'fixture=true, styles=config.previewComponents',
    'function Landscape.LiveCapability()',
    'native-reflow-and-transaction-fallback-unverified',
):
    need(token in landscape, 'preview row state or boundary missing: '+token)
need('datum.disabled and p.muted or p.goldText' not in landscape,
     'ordinary skill names must not default to gold')
for token in (
    'local function paintRow(owner, recipe, fixtureColors)',
    'fixtureColors and fixtureColors.wash or recipe.rowWash',
    'fixtureColors and fixtureColors.rule or recipe.rowRule',
    'function Motif.PaintFixtureRow(owner, state)',
    'local colors = recipe.previewStates and recipe.previewStates[state]',
    'if not colors then return nil end',
    'return paintRow(owner, recipe, colors)',
    'local pieces = paintRow(row, recipe)',
    'return ok and secret == false',
):
    need(token in motif, 'same-painter P/H boundary missing: '+token)
# Check three distinct preview states and their actual RGBA ranges, not just keywords.
match = re.search(r'previewStates\s*=\s*\{(.*?)\n\s*\},\n\s*preview\s*=', config, re.S)
need(bool(match), 'P-only previewStates config block unavailable')
colors = {}
if match:
    for state in ('normal', 'selected', 'disabled'):
        rule = re.search(r'\b'+state+r'\s*=\s*\{wash=\{([^{}]+)\},\s*rule=\{([^{}]+)\}\}',match.group(1))
        try:
            if rule:
                colors[state] = tuple(tuple(float(s.strip()) for s in grp.split(',')) for grp in rule.groups())
        except ValueError:
            pass
        need(state in colors and all(len(c)==4 and all(0<=v<=1 for v in c) for c in colors.get(state,())),
             'missing/invalid state color: '+state)
    if len(colors)==3:
        normal, selected, disabled = (colors[name] for name in ('normal','selected','disabled'))
        need(normal[0][3]<0.16 and normal[1][3]<0.30,
             'ordinary rows still have strong wash/gold rule')
        need(selected[0][3]>normal[0][3]*2 and selected[1][3]>normal[1][3]*2,
             'only selected rows must have strong wash/rule emphasis')
        need(disabled[1][3]<0.30, 'disabled rules must stay subdued')
for old in (old1, old2):
    need("'Logres.NPCTrainerMotif.PaintFixtureRow(row, rowState)'" in old,
         'historical checker still asserts obsolete one-argument preview')
for token in ('Logres.NPCTrainerComponents.Enable(frame)', 'Logres.NPCTrainerMotif.Enable(frame)',
              'pcall(item.set, item.region, item.token)', 'Skin.Disable("trainer-closed")'):
    need(token in skin, 'native trainer integration/restore boundary missing: '+token)
for forbidden in ('ClassTrainerFrame', 'BuyTrainerService(', 'SetParent(',
                  'SetScript("OnUpdate"', 'DynamicCam'):
    need(forbidden not in landscape, 'P renderer must remain isolated from native: '+forbidden)
need(re.search(r'(?m)^## Version: (\S+)$',toc).group(1)==
     re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',bootstrap).group(1),
     'Bootstrap/TOC runtime-version parity')
for phrase in ('P0282', 'P0283', 'ROW EMPHASIS FAIL', 'native', 'UNVERIFIED'):
    need(phrase in evidence, 'evidence missing '+phrase)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff must cite authoritative CURRENT')
print('P0283 trainer selected/ordinary/disabled row contrast')
for problem in errors: print('ERROR:',problem)
if errors: raise SystemExit(1)
print('PASS: P-only selected emphasis; native H unchanged; client visual acceptance pending')
