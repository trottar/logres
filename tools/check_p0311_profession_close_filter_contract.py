#!/usr/bin/env python3
"""P0311: guarded profession Goodbye + native read-only filter context."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding="utf-8")
v=read('Logres/Quest/TrainerLiveTrial.lua')
p=read('Logres/Quest/TrainerProfessionCloseTrial.lua')
f=read('Logres/Quest/TrainerFilterState.lua')
old=read('Logres/Quest/TrainerCloseTrial.lua')
park=read('Logres/UI/NPCServiceNativeParking.lua')
empty=read('Logres/UI/NPCServiceEmptyState.lua')
toc=read('Logres/Logres.toc')
c=read('docs/memory/CURRENT.md')
e=read('docs/memory/evidence/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md')
errors=[]
def need(x,why):
    if not x: errors.append(why)
for x in ('Logres.NPCTrainerProfessionCloseTrial = Close', 'local function gate()',
          'state.interacting ~= true or state.interactionType ~= 7',
          'scalar(api("IsTradeskillTrainer")) ~= true',
          'scalar(api("InCombatLockdown")) ~= false',
          'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
          'local fn = api("CloseTrainer")', 'function Close.CanClose()',
          'function Close.RequestClose()', 'local sent = pcall(fn)',
          'profession-native-close-failed-stock-visible',
          'function Close.GetAudit()'):
    need(x in p, 'profession-only native close gate missing: '+x)
need(p.count('pcall(fn)')==1,'at most one guarded native request call site')
for bad in ('BuyTrainerService(', 'SetTrainerServiceTypeFilter(', 'SetPoint(',
            'C_Timer.', 'OnUpdate', 'HideUIPanel(', 'ShowUIPanel('):
    need(bad not in p, 'profession close owns forbidden operation: '+bad)
for x in ('Logres.NPCTrainerFilterState = State', 'function State.Read()',
          'function State.GetAudit()', 'GetTrainerServiceTypeFilter',
          'filter(fn, "used")', 'filter(fn, "available")',
          'filter(fn, "unavailable")', 'ordinary(value)',
          'nativeFilterWrites=0', 'nativeTransactions=0'):
    need(x in f,'read-only trainer filter guard missing: '+x)
for bad in ('SetTrainerServiceTypeFilter(', 'SelectTrainerService(',
            'GetTrainerServiceInfo(', 'BuyTrainerService(', 'SetScript("OnUpdate"'):
    need(bad not in f,'filter status must not mutate native UI: '+bad)
for x in ('local canClose = Logres.NPCTrainerCloseTrial',
          'Logres.NPCTrainerCloseTrial.CanClose()',
          'local dismissed = Trial.Disable("goodbye")',
          'if dismissed and canClose then',
          'Logres.NPCTrainerCloseTrial.RequestClose()',
          'local filters = Logres.NPCTrainerFilterState.Read()',
          'filters.used == "off"',
          'model.emptyService and model.nativeSession.profession == true',
          'professionClose=Logres.NPCTrainerProfessionCloseTrial.GetAudit()',
          'filterState=Logres.NPCTrainerFilterState.GetAudit()'):
    need(x in v,'existing trainer UI/source/close integration missing: '+x)
# P0312 supersession: user rejected native close while profession stock is still required.
need('NPCTrainerProfessionCloseTrial.RequestClose()' not in v,
     'P0312: native profession close must be inactive pending full replacement')
need('P0312' in read('docs/memory/evidence/P0312_PROFESSION_CONTEXT_RECOVERY.md'),
     'P0311 native-close regression and reversal not preserved')
need('scalar(api("IsTradeskillTrainer")) ~= false' in old,
     'class native-close gate must stay class-only')
need('profession-or-unknown-stock-retained' in park,
     'profession Blizzard stock must remain visible')
need('catalog = {}' in empty and 'disabled=true' in empty,
     'zero-source inert shared empty model remains')
need('Quest\\NPCTrainerFamilyProbe.lua\nQuest\\TrainerCloseTrial.lua\nQuest\\TrainerProfessionPurchaseTrial.lua\nUI\\NPCServiceEmptyState.lua\n' in toc,
     'P0310 module adjacency lost')
need('UI\\NPCServiceEmptyState.lua\nQuest\\TrainerProfessionCloseTrial.lua\nQuest\\TrainerFilterState.lua\n' in toc,
     'new service-specific adapters not loaded at end')
need('Quest\\NativeTrainerServiceProbe.lua\nUI\\NPCServiceCatalogue.lua\nQuest\\TrainerComponents.lua' in toc,
     'source/catalogue adjacency broken')
need('"nativeTrainerEmptyPreview"' in read('Logres/Core/Commands.lua'),
     'P preview action removed')
for token in ('P0310','P0311','PASS','UNVERIFIED','Fishing','known',
              'Enchanting','Blizzard','filter','Goodbye','CloseTrainer'):
    need(token.lower() in e.lower(), 'new evidence missing '+token)
heads=('## Active Objective','## Current Work Item','## Verified State',
       '## Next Action','## Success Criteria',
       '## Do Not Reopen Without New Evidence','## Relevant References')
need(len(c.encode())<10000 and all(c.splitlines().count(x)==1 for x in heads),
     'CURRENT heading count/size drift')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)), 'runtime version mismatch')
print('P0311 profession Goodbye and filter-source capability contract')
for x in errors: print('ERROR:',x)
if errors:raise SystemExit(1)
print('PASS: class isolation; ordinary profession Goodbye after restoration; native filter read-only; stock retained')
