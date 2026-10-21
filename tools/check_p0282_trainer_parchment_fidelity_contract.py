#!/usr/bin/env python3
"""P0282: verify P-only parchment overlays, text stacking and native H separation."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
read=lambda p:(r/p).read_text(encoding='utf8')
l=read('Logres/Quest/TrainerLandscape.lua')
c=read('Logres/Quest/TrainerPanelConfig.lua')
b=read('Logres/Quest/TrainerComponents.lua')
n=read('Logres/Quest/NativeTrainerSkin.lua')
toc=read('Logres/Logres.toc')
errors=[]
def need(ok,why):
    if not ok: errors.append(why)
for token in (
    'rect(owner, g.left.x, g.left.y, g.left.w, g.left.h, p.sidebarWash)',
    'rect(owner, g.list.x, g.list.y, g.list.w, g.list.h, p.catalogueWash)',
    'rect(owner, g.detail.x, g.detail.y, g.detail.w, g.detail.h, p.detailWash)',
    'g.left.w + 7', 'p.sidebarRule',
    'text(owner, view.categories[i]',
    'text(reagent, item.count',
    'fixture=true, styles=config.previewComponents',
    'Logres.NPCTrainerComponents.Render(',
    'Logres.NPCTrainerMotif.PaintFixtureRow(row, rowState)',
    'function Landscape.LiveCapability()',
    'native-reflow-and-transaction-fallback-unverified',
):
    need(token in l,'missing P-only parchment/ownership feature '+token)
for bad in (
    'rect(body, 0, 0, g.left.w, g.left.h, p.pane)',
    'rect(main, 0, 0, g.list.w, g.list.h, p.pane)',
    'local body = frame(owner, g.left.x',
    'local main = frame(owner, g.list.x',
    'rect(owner, item.count',
    'ClassTrainerFrame', 'BuyTrainerService(', 'SetScript("OnUpdate"',
    'SetParent(', 'DynamicCam',
):
    need(bad not in l,'flat black child UI or native mutation remains '+bad)
for token in ('sidebarWash =', 'catalogueWash =', 'detailWash =',
              'sidebarRule =', 'previewComponents = {',
              '["trainer.selection"] =', '["trainer.train"] =',
              'width = 896, height = 712, maxRows = 7',
              'mode = "nine-slice"'):
    need(token in c,'declarative continuous parchment config missing '+token)
for name in ('sidebarWash','catalogueWash','detailWash'):
    match=re.search(r'\b'+name+r'\s*=\s*\{\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,\s*([0-9.]+)\s*,\s*([0-9.]+)\s*\}',c)
    need(bool(match and 0<float(match.group(4))<0.25), 'warm wash must have low alpha '+name)
for token in ('local recipe = config.styles[item.id]',
              'if model.fixture == true and type(model.styles) == "table" then',
              'recipe = model.styles[item.id] or recipe',
              'painted(item.target, recipe)',
              'function Components.Enable(trainer)',
              'local model = {elements={}}',
              'function Components.Disable()'):
    need(token in b,'shared render path/native stock recipe boundary missing '+token)
for bad in ('BuyTrainerService(', 'SetParent(', 'target:SetPoint(', 'target:Hide(',
            'hooksecurefunc(', 'SetScript("OnUpdate"'):
    need(bad not in b,'native mutation forbidden '+bad)
for token in ('function Skin.Enable()', 'function Skin.Disable(reason)',
              'Logres.NPCTrainerLandscape.Preview(surface)',
              'Logres.NPCTrainerComponents.Enable(frame)',
              'Logres.NPCTrainerMotif.Enable(frame)',
              'pcall(item.set, item.region, item.token)'):
    need(token in n,'native H restoration/ownership contract absent '+token)
need('Quest\\TrainerComponents.lua' in toc and
     'Quest\\TrainerLandscape.lua' in toc,'TOC shared painter/preview load order')
for p in ('docs/memory/evidence/P0282_TRAINER_PARCHMENT_VISUAL_FAILURE.md',
          'docs/memory/patches/P0282_TRAINER_PARCHMENT_VISUAL_REPAIR.md'):
    need((r/p).is_file(),'durable negative evidence missing '+p)
for token in ('VISUAL FIDELITY FAIL','dark blocks','incorrect',
              'P0281', 'P0282', 'UNVERIFIED'):
    need(token in read('docs/memory/evidence/P0282_TRAINER_PARCHMENT_VISUAL_FAILURE.md'),
         'negative screenshot evidence missing '+token)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'CURRENT authority missing from handoff')
print('P0282 trainer parchment fidelity and P/H safety contract')
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: preview-only warm parchment surface and native ownership invariants; WoW visual UNVERIFIED')
