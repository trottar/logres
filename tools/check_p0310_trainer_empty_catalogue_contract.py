#!/usr/bin/env python3
"""P0310: zero-service profession uses same landscape; no fabricated gameplay rows."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
empty=read('Logres/UI/NPCServiceEmptyState.lua')
land=read('Logres/Quest/TrainerLandscape.lua')
live=read('Logres/Quest/TrainerLiveTrial.lua')
skin=read('Logres/Quest/NativeTrainerSkin.lua')
cmd=read('Logres/Core/Commands.lua')
probe=read('Logres/Quest/NativeTrainerServiceProbe.lua')
toc=read('Logres/Logres.toc')
evidence=read('docs/memory/evidence/P0310_TRAINER_EMPTY_CATALOGUE.md')
cur=read('docs/memory/CURRENT.md')
errors=[]
def need(cond,why):
    if not cond: errors.append(why)
for x in ('Logres.NPCServiceEmptyState = Empty','function Empty.Build(spec)',
          'catalog = {}','disabled=true','selected=false','price=""'):
    need(x in empty,'missing data-only empty model '+x)
for x in ('function Landscape.EmptyFixture()','Logres.NPCServiceEmptyState.Build(',
          'function Landscape.EmptyPreview(owner)', 'Landscape.Render(owner, Landscape.EmptyFixture())',
          'function Landscape.Preview(owner)','return Landscape.Render(owner, Landscape.Fixture())'):
    need(x in land,'shared renderer/P fixture lost '+x)
for x in ('function Trial.FromEmptySnapshot(report)',
          'report.total ~= 0 or #report.sample ~= 0',
          'report.status ~= "read-only-service-sample"',
          'local empty = Logres.NPCServiceEmptyState.Build(',
          'catalog=empty.catalog, rows={empty.row}',
          'emptyService=empty',
          'if not model and why == "source-sample-size-deferred"',
          'trainerFamily() == true',
          'model.emptyService and model.emptyService.row or',
          'model.profession = "0 native services | Blizzard available"',
          'if not model.emptyService and Logres.NPCServiceNativeParking then',
          'model.nativeSession.profession = trainerFamily()',
          'Logres.NPCTrainerProfessionPurchaseTrial.Attempt(',
          'Logres.NPCTrainerPurchaseTrial.AttemptAll(',
          'Logres.NPCTrainerCloseTrial.RequestClose()'):
    need(x in live,'live empty source guard/capability lost '+x)
need(live.index('local model, why = Trial.FromSnapshot(report)') <
     live.index('if not model and why == "source-sample-size-deferred"'),
     'normal trainer adapter must be tried first')
need('local initiallySelected' in live and 'if rows[i] and not rows[i].disabled and rows[i].serviceIndex then' in live,
     'empty row might be interactive')
for x in ('function Skin.EmptyPreview()',
          'Logres.NPCTrainerLandscape.EmptyPreview(surface)',
          'function Skin.Preview()',
          'if emptyPreview and emptyPreview:IsShown() then emptyPreview:Hide() end'):
    need(x in skin,'preview wrapper lost '+x)
for x in ('if command == "nativetraineremptypreview" then',
          'Logres.NPCNativeTrainerSkin.EmptyPreview()',
          '"nativetraineremptypreview"'):
    need(x in cmd,'explicit inert slash preview missing '+x)
need('"nativeTrainerEmptyPreview"' in cmd and '"Trainer Empty Preview"' in cmd,
     'empty preview must be a normal P-panel action')
need('"nativetraineremptypreview",\n    "P"' in cmd,
     'trainer empty preview must be registered under P')
registry=re.findall(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)',cmd,re.S)
need(sum(phase=='P' for _,phase in registry)==36,
     'P registry must have 35 previous entries and the approved 36th empty preview')
need(any(key=='nativeTrainerSkinPreview' and phase=='P' for key,phase in registry),
     'existing P trainer preview entry must remain')
need("required.add('nativeTrainerEmptyPreview')" in read('tools/check_p0256_preview_hub_contract.py'),
     'P0256 explicit approved preview inventory must include P0310')
for path in ('tools/check_p0271_native_placement_trial_contract.py',
             'tools/check_p0272_native_auto_handoff_contract.py',
             'tools/check_p0273_native_gossip_continuity_contract.py',
             'tools/check_p0274_native_service_accent_contract.py',
             'tools/check_p0276_r1_native_trainer_skin_contract.py',
             'tools/check_p0289_trainer_live_panel_contract.py'):
    need('==36' in read(path) or '== 36' in read(path),
         'historical registry contract not migrated '+path)
need('report.total=total' in probe and 'report.status="read-only-service-sample"' in probe,
     'native empty source must be real copied count')
need('Quest\\NativeTrainerServiceProbe.lua\nUI\\NPCServiceCatalogue.lua\nQuest\\TrainerComponents.lua' in toc,
     'P0303/P0304 source-catalogue adjacency must remain exact')
need('Quest\\NPCTrainerFamilyProbe.lua\nQuest\\TrainerCloseTrial.lua\nQuest\\TrainerProfessionPurchaseTrial.lua\nUI\\NPCServiceEmptyState.lua\n' in toc,
     'data-only empty service helper must follow intact controller chain')
need('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in toc,
     'historical trainer chain broken')
for p in (empty,):
    for bad in ('BuyTrainerService(', 'CloseTrainer(', 'SetPoint(', 'C_Timer.',
                'SetScript("OnUpdate"', 'SetTrainerServiceTypeFilter('):
        need(bad not in p,'data-only helper contains native operation '+bad)
for x in ('P0309','P0310','PASS','UNVERIFIED','Fishing','Enchanting',
          'Blizzard','profession','services=0','no','preview'):
    need(x.lower() in evidence.lower(),'missing evidence '+x)
heads=('## Active Objective','## Current Work Item','## Verified State',
       '## Next Action','## Success Criteria','## Do Not Reopen Without New Evidence',
       '## Relevant References')
need(len(cur.encode())<10000 and all(cur.splitlines().count(x)==1 for x in heads),
     'CURRENT health')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)),'version parity')
print('P0310 R2 shared service empty-catalogue / expanded reviewed P gallery contract')
for issue in errors:print('ERROR:',issue)
if errors:raise SystemExit(1)
print('PASS: 36 reviewed P previews/load order, source zero only, inert alternate preview + same live renderer')
