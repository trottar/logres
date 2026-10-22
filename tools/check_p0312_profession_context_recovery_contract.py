#!/usr/bin/env python3
"""P0312: source-backed left-side profession context, no native-close regressions."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
a=read('Logres/Quest/TrainerProfessionContext.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
s=read('Logres/UI/NPCServiceSession.lua')
t=read('Logres/Logres.toc')
e=read('docs/memory/evidence/P0312_PROFESSION_CONTEXT_RECOVERY.md')
errors=[]
def need(ok,why):
    if not ok:errors.append(why)
for token in ('Logres.NPCTrainerProfessionContext = Context', 'function Context.Read()',
              'GetProfessions', 'GetProfessionInfo', 'ordinary(name)', 'number(maximum)',
              '[150]="Journeyman"', 'lines=', 'nativeWrites=0', 'transactions=0'):
    need(token in a,'source read-only adapter: '+token)
for forbidden in ('SetTrainerServiceTypeFilter(', 'BuyTrainerService(', 'CloseTrainer(',
                  'GetPoint(', 'C_Timer.', 'SetScript("OnUpdate"', 'SelectTrainerService('):
    need(forbidden not in a,'forbidden context operation: '+forbidden)
for token in ('professionContext =', 'view.professionContext', 'Your professions',
              'GameFontHighlightSmall', 'Landscape.Render(owner, Landscape.EmptyFixture())'):
    need(token in l,'shared renderer/fixture profession context: '+token)
for token in ('model.professionContext = Logres.NPCTrainerProfessionContext.Read()',
              'function Trial.RefreshEmptyFromSource()', 'Trial.FromSnapshot(report)',
              'Trial.Disable("trainer-source-refreshed")', 'Trial.Toggle("on")',
              'local dismissed = Trial.Disable("goodbye")',
              'Logres.NPCTrainerCloseTrial.RequestClose()',
              'Logres.NPCTrainerProfessionPurchaseTrial.Attempt('):
    need(token in v,'live trainer integration: '+token)
need('NPCTrainerProfessionCloseTrial.RequestClose()' not in v,
     'profession Goodbye must remain Logres-only pending complete replacement')
need('if dismissed and canClose then' in v,'class native Goodbye must still work')
need('Logres.NPCTrainerLiveTrial.RefreshEmptyFromSource()' in s and
     'Logres:RegisterEvent("TRAINER_UPDATE"' in s,
     'source recovery bound only to native TRAINER_UPDATE')
need('Quest\\TrainerProfessionCloseTrial.lua\nQuest\\TrainerFilterState.lua\nQuest\\TrainerProfessionContext.lua\n' in t,
     'context module appended after existing native adapter chain')
need('Quest\\NativeTrainerServiceProbe.lua\nUI\\NPCServiceCatalogue.lua\nQuest\\TrainerComponents.lua' in t,
     'P0303 source/catalogue chain preserved')
need('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in t,
     'historical trainer chain unchanged')
need('nativeTrainerEmptyPreview' in read('Logres/Core/Commands.lua'),
     'existing P preview action preserved')
need('P0312' in read('tools/check_p0311_profession_close_filter_contract.py'),
     'archived P0311 checker not reconciled with rejected runtime behavior')
for token in ('P0311','P0312','Enchanting','Fishing','Journeyman','Goodbye',
              'FAIL','UNVERIFIED','Blizzard'):
    need(token in e,'missing failure/result in evidence: '+token)
heads=('## Active Objective','## Current Work Item','## Verified State',
       '## Next Action','## Success Criteria','## Do Not Reopen Without New Evidence',
       '## Relevant References')
c=read('docs/memory/CURRENT.md')
need(len(c.encode())<10000 and all(c.splitlines().count(h)==1 for h in heads),
     'current headings/size')
for issue in errors:print('ERROR:',issue)
print('P0312 profession context + event repair contract')
if errors:raise SystemExit(1)
print('PASS: source-backed context; profession close reverted, class retained; event-only refresh')
