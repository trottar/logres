#!/usr/bin/env python3
"""P0313: source-backed current trainer + complete owned list, one P/live renderer."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
a=read('Logres/Quest/TrainerProfessionContext.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
t=read('Logres/Logres.toc')
b=read('Logres/Core/Bootstrap.lua')
e=read('docs/memory/evidence/P0313_TRAINER_FOCUS_ICON_PREVIEW.md')
cur=read('docs/memory/CURRENT.md')
issues=[]
def need(cond,why):
    if not cond:issues.append(why)
for x in ('function Context.Read()', 'function Context.Focus(context, catalog)',
          'output.owned = owned', 'GetProfessions', 'GetProfessionInfo',
          'sourceSkillRequirement', 'GetTrainerGreetingText',
          'C_TooltipInfo', 'GetUnit', 'ordinary(payload)',
          'ordinary(lines)', 'ordinary(label)', 'wholeWord',
          'Owned rank not verified', 'No listed training services'):
    need(x in a, 'profession source / focus missing '+x)
for bad in ('BuyTrainerService(', 'CloseTrainer(', 'SetTrainerServiceTypeFilter(',
            'SelectTrainerService(', 'SetPoint(', 'OnUpdate', 'C_Timer.'):
    need(bad not in a,'source adapter may not own mutation '+bad)
for x in ('trainerFocus = {', 'model.trainerFocus = Logres.NPCTrainerProfessionContext.Focus(',
          'model.professionContext = Logres.NPCTrainerProfessionContext.Read()',
          'function Trial.RefreshEmptyFromSource()',
          'Logres.NPCTrainerCloseTrial.RequestClose()'):
    need(x in l or x in v,'shared view/live integration missing '+x)
need('NPCTrainerProfessionCloseTrial.RequestClose()' not in v,'profession Goodbye must stay Logres-only')
for x in ('view.trainerFocus', 'view.professionContext', 'Your professions',
          'Current trainer', 'view.emptyFixtureIconFix',
          'live = live or owner.logresEmptyFixtureIconFix == true',
          'Landscape.Render(owner, Landscape.EmptyFixture())'):
    need(x in l,'landscape P/live fragment missing '+x)
need(l.count('logresEmptyFixtureIconFix = true') == 2,
     'only two addon-owned empty fixture frames may opt in')
need('local _, image = icon(row, datum.icon, 7, 5, 40, view.localBrowse)' in l and
     'local _, selectedImage = icon(selected, view.selected.icon, 5, 7, 53, view.localBrowse)' in l,
     'historical P0297/P0298 native/live icon call sites must remain exact')
need('Quest\\TrainerProfessionContext.lua' in t,'existing module retained')
need('Quest\\NativeTrainerServiceProbe.lua\nUI\\NPCServiceCatalogue.lua\nQuest\\TrainerComponents.lua' in t,
     'stable source/renderer module adjacency')
need('nativeTrainerEmptyPreview' in read('Logres/Core/Commands.lua'), 'P preview button retained')
for x in ('P0312','P0313','Cooking','Fishing','Enchanting','FAIL','UNVERIFIED','Blizzard'):
    need(x.lower() in e.lower(),'evidence missing '+x)
heads=('## Active Objective','## Current Work Item','## Verified State','## Next Action',
       '## Success Criteria','## Do Not Reopen Without New Evidence','## Relevant References')
need(len(cur.encode())<10000 and all(cur.splitlines().count(x)==1 for x in heads),'CURRENT health')
toc_version = re.search(r'(?m)^## Version: (\S+)$', t)
boot_version = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', b)
need(bool(toc_version and boot_version and toc_version.group(1)==boot_version.group(1)),
     'version parity without a historical pin')
print('P0313 current trainer + full profession list / empty fixture icon contract')
for issue in issues:print('ERROR:',issue)
if issues:raise SystemExit(1)
print('PASS: two sidebar sections, grounded source, inert icon fixture only')
