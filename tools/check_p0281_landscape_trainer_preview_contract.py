#!/usr/bin/env python3
"""P0281 declared trainer landscape P fixture; WoW visual gate remains separate."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
read=lambda p:(r/p).read_text(encoding='utf8')
v=read('Logres/Quest/TrainerLandscape.lua')
c=read('Logres/Quest/TrainerPanelConfig.lua')
s=read('Logres/Quest/NativeTrainerSkin.lua')
m=read('Logres/Quest/TrainerMotif.lua')
b=read('Logres/Quest/TrainerComponents.lua')
t=read('Logres/Logres.toc')
errors=[]
def need(ok,msg):
    if not ok: errors.append(msg)
for token in ('Logres.NPCTrainerLandscape = Landscape',
              'function Landscape.Fixture()', 'function Landscape.Build(model)',
              'function Landscape.Render(owner, model)',
              'function Landscape.Preview(owner)',
              'return Landscape.Render(owner, Landscape.Fixture())',
              'function Landscape.LiveCapability()',
              'native-reflow-and-transaction-fallback-unverified',
              'view.categories', 'view.rows', 'view.reagents', 'view.selected',
              'view.profession', 'view.title', 'view.subtitle',
              'view.search', 'view.trainLabel',
              'g.search.', 'g.categories.', 'g.list.', 'g.detail.',
              'g.reagents.', 'g.train.',
              'Logres.NPCTrainerMotif.PaintFixtureRow(row)',
              'fixture=true, styles=config.previewComponents, elements={',
              '{id="trainer.filter", target=filter}',
              '{id="trainer.selection", target=selected}',
              '{id="trainer.status", target=status}',
              '{id="trainer.train", target=train}',
              'landscape-construction-deferred'):
    need(token in v, 'landscape fixture/model/renderer missing '+token)
# Inspect the fixture constructor, not a hardcoded local variable name.
# Require the exact CreateFrame local to have mouse interaction disabled.
helper = re.search(r'local function frame\(owner, x, y, w, h\)(.*?)\nend', v, re.S)
created = re.search(r'local (\w+) = CreateFrame\("Frame", nil, owner\)',
                    helper.group(1)) if helper else None
need(bool(created and
          f'{created.group(1)}:EnableMouse(false)' in helper.group(1)),
     'landscape frame helper must disable mouse interaction')
for token in ('landscape = {', 'width = 896, height = 712, maxRows = 7',
              'left = {x=32', 'search = {x=38', 'categories = {x=38',
              'list = {x=273', 'detail = {x=33', 'reagents = {x=574',
              'train = {x=732', 'art.motifs.goldLine'):
    need(token in c,'landscape geometry/color missing '+token)
for token in ('function Motif.PaintFixtureRow(owner)',
              'return paintRow(owner, Logres.PanelConfigs.trainer.motif)'):
    need(token in m,'production row painter not reused by P '+token)
for token in ('function Components.Render(model)', 'painted(item.target, recipe)',
              'function Components.Enable(trainer)'):
    need(token in b, 'shared P0280 native/fixture painter regressed '+token)
for token in ('local landscapeOK = Logres.NPCTrainerLandscape.Preview(surface)',
              'local painted = createPaint(surface, visual.width, visual.height)',
              'local pieces = createPaint(frame, width, height)',
              'Logres.NPCTrainerComponents.Enable(frame)',
              'Logres.NPCTrainerMotif.Enable(frame)',
              'Skin.Disable("trainer-closed")',
              'pcall(item.set, item.region, item.token)'):
    need(token in s,'P/H presentation boundary changed '+token)
for token in ('Logres.NPCTrainerMotif.Preview(surface)',
              'Logres.NPCTrainerComponents.Preview(surface)'):
    need(token not in s,'old floating samples still called from P '+token)
for forbidden in ('ClassTrainerFrame', 'BuyTrainerService(',
                  'GetTrainerServiceInfo(', 'GetTrainerServiceCost(',
                  'GetTrainerServiceSkillLine(', 'SetScript("OnUpdate"',
                  'hooksecurefunc(', 'SetParent(', 'DynamicCam',
                  'C_GossipInfo.', 'AcceptQuest('):
    need(forbidden not in v, 'P renderer must not inspect/mutate native '+forbidden)
sequence=['Quest\\TrainerPanelConfig.lua','Quest\\TrainerComponents.lua',
          'Quest\\TrainerMotif.lua','Quest\\TrainerLandscape.lua',
          'Quest\\NativeTrainerSkin.lua']
pos=[t.find(x) for x in sequence]
need(all(x>=0 for x in pos) and pos==sorted(pos), 'TOC ownership/load order')
ver=re.search(r'(?m)^## Version: (\S+)$',t)
boot=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',
               read('Logres/Core/Bootstrap.lua'))
need(bool(ver and boot and ver.group(1)==boot.group(1)),
     'runtime version mismatch')
for p in ('docs/memory/evidence/P0281_LANDSCAPE_TRAINER_PREVIEW.md',
          'docs/memory/patches/P0281_LANDSCAPE_TRAINER_PREVIEW.md'):
    need((r/p).is_file(), 'missing durable evidence '+p)
for token in ('P0280', 'VISUAL FAIL', 'Blizzard', 'P0281', 'UNVERIFIED'):
    need(token in read('docs/memory/evidence/P0281_LANDSCAPE_TRAINER_PREVIEW.md'),
         'missing negative evidence '+token)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff not linked to authority')
for problem in errors: print('ERROR:',problem)
print('P0281 complete landscape fixture / native ownership separation')
if errors: raise SystemExit(1)
print('PASS: static composition and fail-open ownership contract; WoW visual UNVERIFIED')
