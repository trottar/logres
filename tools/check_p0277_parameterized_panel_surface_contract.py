#!/usr/bin/env python3
"""P0277: shared visual vocabulary, independent declarative component inputs."""
from pathlib import Path
r = Path(__file__).resolve().parents[1]
read = lambda x: (r/x).read_text(encoding='utf-8')
q=read('Logres/Quest/QuestPanelConfig.lua')
t=read('Logres/Quest/TrainerPanelConfig.lua')
f=read('Logres/UI/PanelSurface.lua')
d=read('Logres/Quest/Dialogue.lua')
s=read('Logres/Quest/NativeTrainerSkin.lua')
theme=read('Logres/Media/Theme.lua')
layout=read('Logres/Integration/Layout.lua')
toc=read('Logres/Logres.toc')
errors=[]
def need(ok,why):
    if not ok: errors.append(why)
for token in ('function Surface.Paint(owner, config, width, height)',
              'function Surface.Hide(pieces)', 'if bg.mode == "stretch" then',
              'elseif bg.mode == "nine-slice" then',
              'panel:SetTexCoord(', 'panel:SetAllPoints(owner)',
              'rule.horizontalInset','rule.height','rule.x, rule.y',
              'bg.texture','rule.texture'):
    need(token in f,'shared surface missing '+token)
for token in ('local style = Logres.Theme.questDialogue',
              'local art = Logres.Theme.panelSurface',
              'Logres.PanelConfigs.quest = quest',
              'width = 640, height = 320', 'bodyHeight = 134',
              'objectiveHeight = 50', 'x = 0, y = -110',
              'mode = "stretch"', 'theme' if False else 'background ='):
    need(token in q,'quest configuration missing '+token)
for token in ('Logres.PanelConfigs.trainer = trainer',
              'local art = Logres.Theme.panelSurface',
              'width = 896, height = 712',
              'mode = "nine-slice"', 'corner = 40',
              'referenceWidth = 640, referenceHeight = 320',
              'point = "TOP", relativePoint = "TOP"',
              'noteColor = art.colors.body'):
    need(token in t,'trainer configuration missing '+token)
for token in ('theme.questDialogue = {', 'theme.panelSurface = {',
              'assets = theme.questDialogue.assets',
              'colors = theme.questDialogue.colors',
              'Quest\\\\quest_narrative_panel.tga',
              'Quest\\\\quest_narrative_divider.tga'):
    need(token in theme,'shared theme missing '+token)
quest_theme = theme.split('theme.questDialogue = {', 1)[1].split('theme.panelSurface = {', 1)[0]
need('width = 640' not in quest_theme and 'bodyHeight = 134' not in quest_theme,
     'Quest-specific geometry must reside in QuestPanelConfig, not Theme')
for token in ('local panelConfig = Logres.PanelConfigs.quest',
              'Logres.PanelSurface.Paint(', 'panelConfig.surface',
              'Logres.Layout.Bind(root, panelConfig.placement.key,'):
    need(token in d,'Quest Dialogue must consume one surface and config '+token)
need('local panel =\n        root:CreateTexture(' not in d,
     'Quest Dialogue must not retain independent panel painter')
for token in ('local trainerConfig = Logres.PanelConfigs.trainer',
              'Logres.PanelSurface.Paint(owner, trainerConfig.surface, width, height)',
              'local visual = trainerConfig.preview',
              'local painted = createPaint(surface, visual.width, visual.height)',
              'local pieces = createPaint(frame, width, height)',
              'surface:SetPoint(visual.point, UIParent, visual.relativePoint, visual.x, visual.y)',
              'Skin.Disable("trainer-closed")'):
    need(token in s,'trainer must share painter/config and preserve native safety '+token)
for forbidden in ('CreateTexture(', 'SetTexCoord(',
                  'surface:SetSize(560, 430)',
                  'SetPoint("CENTER", UIParent, "CENTER", 0, 0)',
                  'local function paint(owner, width, height)'):
    need(forbidden not in s,'independent/hardcoded trainer painter reintroduced '+forbidden)
need('questDialogue = {' in layout and
     'Logres.PanelConfigs.quest.placement' in layout,
     'existing Quest anchor geometry must read configuration')
order=['Media\\Theme.lua','Quest\\QuestPanelConfig.lua',
       'Quest\\TrainerPanelConfig.lua','Integration\\Layout.lua',
       'UI\\PanelSurface.lua','Quest\\NativeTrainerSkin.lua','Quest\\Dialogue.lua']
positions=[toc.find(x) for x in order]
need(all(x>=0 for x in positions) and positions==sorted(positions),
     'Theme/config/layout/surface/consumers TOC load order')
for forbidden in ('BuyTrainerService(', 'BuyMerchantItem(', 'C_GossipInfo.',
                  'SetScript("OnUpdate"', 'DynamicCam'):
    need(forbidden not in f and forbidden not in q and forbidden not in t,
         'style/config must not own gameplay or camera '+forbidden)
print('P0277 shared visual design system / separate Quest and Trainer input contracts')
for x in errors: print('ERROR:',x)
if errors: raise SystemExit(1)
print('PASS: 0 static errors; visual/native runtime acceptance pending')
