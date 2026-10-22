#!/usr/bin/env python3
"""P0308: native class Goodbye closure is explicit, restoration-first and fail-open."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
v=read('Logres/Quest/TrainerLiveTrial.lua')
s=read('Logres/Quest/TrainerCloseTrial.lua')
park=read('Logres/UI/NPCServiceNativeParking.lua')
session=read('Logres/UI/NPCServiceSession.lua')
family=read('Logres/Quest/NPCTrainerFamilyProbe.lua')
toc=read('Logres/Logres.toc')
e=read('docs/memory/evidence/P0308_TRAINER_NATIVE_GOODBYE.md')
current=read('docs/memory/CURRENT.md')
old=read('tools/check_p0307_trainer_family_probe_contract.py')
issues=[]
def need(x,why):
    if not x:issues.append(why)
for x in ('Logres.NPCTrainerCloseTrial = Close','local function gate()',
          'state.interacting ~= true or state.interactionType ~= 7',
          'scalar(api("InCombatLockdown")) ~= false',
          'scalar(api("IsTradeskillTrainer")) ~= false',
          'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
          'local close = api("CloseTrainer")', 'function Close.CanClose()',
          'function Close.RequestClose()', 'local ok = pcall(fn)',
          'requests = requests + 1',
          'native-close-request-sent-unconfirmed',
          'native-close-call-failed-stock-visible',
          'function Close.GetAudit()'):
    need(x in s,'missing guarded class native-close contract: '+x)
need(s.count('pcall(fn)')==1,'exactly one native close request invocation')
need('CloseTrainer()' not in s,'no unguarded direct native close call')
for x in ('local canClose = Logres.NPCTrainerCloseTrial',
          'Logres.NPCTrainerCloseTrial.CanClose()',
          'local dismissed = Trial.Disable("goodbye")',
          'if dismissed and canClose then',
          'Logres.NPCTrainerCloseTrial.RequestClose()',
          'nativeClose=Logres.NPCTrainerCloseTrial.GetAudit()'):
    need(x in v,'missing ordered Goodbye adapter: '+x)
need(v.index('local dismissed = Trial.Disable("goodbye")') < v.index('Logres.NPCTrainerCloseTrial.RequestClose()'),
     'must restore stock through Disable before native close')
need('Logres.NPCServiceNativeParking.Restore,' in v and 'if not ok or restored ~= true then' in v,
     'restore-first fail-open behavior must remain')
for x in ('local okProfession, family = pcall(function() return _G.IsTradeskillTrainer end)',
          'if not okProfession or not ordinary(family)',
          'local okFamily, profession = pcall(family)',
          'if not okFamily or not ordinary(profession)',
          'profession-or-unknown-stock-retained',
          'trainer-family-api-unavailable-stock-retained'):
    need(x in park, 'profession native transaction fallback gate missing: '+x)
need(park.index('local okFamily, profession = pcall(family)') < park.index('local points = capture(root)'),
     'family gate must run before native parking anchor snapshot')
need('function Parking.Restore(reason)' in park and 'function Parking.DeferExit()' in park,
     'native parking restore safety lost')
need('function Session.Dismiss(key)' in session and 'Trainer Family Check' in read('Logres/Core/Commands.lua'),
     'existing NPC session and family panel must remain')
need('IsTradeskillTrainer' in family,'profession family probe preserved')
for bad in ('SetScript("OnUpdate"','C_Timer.', 'SetAlpha(', 'SetParent(',
            'HideUIPanel(', 'ShowUIPanel(', 'BuyTrainerService(', 'SetPoint('):
    need(bad not in s,'class close must not change visual/native purchase state: '+bad)
need('Quest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua\nQuest\\OptionModel.lua' in toc,
     'historical trainer chain broken')
need('UI\\NPCServiceSession.lua\nUI\\NPCServiceNativeParking.lua\nQuest\\NPCTrainerFamilyProbe.lua\nQuest\\TrainerCloseTrial.lua' in toc,
     'new close adapter not loaded after existing NPC service modules')
need('P0307' in old and 'NPCTrainerFamilyProbe' in old,'historical family checker lost')
for x in ('P0306','P0307','P0308','PASS','UNVERIFIED','services=0','Goodbye','Blizzard','CloseTrainer','Cooking','Enchanting'):
    need(x.lower() in e.lower(),'evidence missing '+x)
heads=('## Active Objective','## Current Work Item','## Verified State','## Next Action',
       '## Success Criteria','## Do Not Reopen Without New Evidence','## Relevant References')
need(len(current.encode())<10000 and all(current.splitlines().count(x)==1 for x in heads),
     'CURRENT headings/size failure')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)),'runtime version mismatch')
print('P0308 class native-close Goodbye restoration-first contract')
for x in issues:print('ERROR:',x)
if issues:raise SystemExit(1)
print('PASS: class-only native close after stock restoration, source-empty profession retained')
