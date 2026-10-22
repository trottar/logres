#!/usr/bin/env python3
"""P0314: profession whole-frame parking only with one-click native restoration."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
v=read('Logres/Quest/TrainerLiveTrial.lua')
p=read('Logres/UI/NPCServiceNativeParking.lua')
f=read('Logres/Quest/TrainerProfessionContext.lua')
close=read('Logres/Quest/TrainerProfessionCloseTrial.lua')
class_close=read('Logres/Quest/TrainerCloseTrial.lua')
toc=read('Logres/Logres.toc');boot=read('Logres/Core/Bootstrap.lua')
e=read('docs/memory/evidence/P0314_PROFESSION_SINGLE_WINDOW.md')
errors=[]
def need(x,msg):
 if not x:errors.append(msg)
for token in ('function Parking.Park(key)','function Parking.ParkProfession(key)',
    'professionPermit = true','professionPermit = false',
    'local called, accepted, reason = pcall(Parking.Park, key)',
    'if not okFamily or not ordinary(profession)',
    'type(profession) ~= "boolean"',
    'if profession == true and not professionPermit then',
    'profession-or-unknown-stock-retained',
    'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
    'if placementConflict() then',
    'pcall(getPoint, root, index)',
    'points[index] = {p, relative, rp, x, y}',
    'state.set(state.root, token[1], token[2], token[3], token[4], token[5])',
    'Parking.Restore("native-trainer-closed")',
    'retry:RegisterEvent("PLAYER_REGEN_ENABLED")',
    'set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)'):
 need(token in p,'parking safety or capability missing: '+token)
for token in ('model.professionStockFallback = true',
    'model.trainAll = {label="Blizzard UI", enabled=true}',
    'and browse and browse.model.professionStockFallback == true then',
    'Trial.Disable("trial-hidden")',
    'pcall(Logres.NPCServiceNativeParking.ParkProfession, "trainer")',
    'pcall(Logres.NPCServiceNativeParking.Park, "trainer")',
    'if model.emptyService and model.professionStockFallback',
    'browse.stockParked = true',
    'local canCloseProfession = family == true and browse',
    'and browse.stockParked == true',
    'local dismissed = Trial.Disable("goodbye")',
    'elseif dismissed and canCloseProfession then',
    'Logres.NPCTrainerProfessionCloseTrial.RequestClose()',
    'Logres.NPCTrainerCloseTrial.RequestClose()',
    'Logres.NPCTrainerProfessionPurchaseTrial.Attempt(',
    'Logres.NPCTrainerPurchaseTrial.AttemptAll(',
    'if not model.emptyService and Logres.NPCServiceNativeParking then',
    'if not refreshBrowse() then', 'owner:Show()'):
 need(token in v,'live UI/fallback/transaction gate missing: '+token)
need(v.index('owner:Show()') < v.index('pcall(Logres.NPCServiceNativeParking.ParkProfession, "trainer")'),
     'profession native parked before Logres visible')
need(v.index('local dismissed = Trial.Disable("goodbye")') < v.index('Logres.NPCTrainerProfessionCloseTrial.RequestClose()'),
     'stock restore must precede profession native close')
need('function Close.CanClose()' in close and 'function Close.RequestClose()' in close and 'scalar(api("IsTradeskillTrainer")) ~= true' in close,
     'existing profession-only native close must revalidate session')
need('scalar(api("IsTradeskillTrainer")) ~= false' in class_close,
     'class native close must stay class-only')
need('Review lessons on the right' in f and 'No additional lessons shown' in f,
     'P0313 vague current trainer copy persists')
for forbidden in ('SetAlpha(', 'EnableMouse(false)', 'HideUIPanel(', 'SetScript("OnUpdate"',
                  'C_Timer.', 'BuyTrainerService(', 'CloseTrainer('):
 need(forbidden not in p,'parking must not hide native hit region or transact: '+forbidden)
for path in ('tools/check_p0308_native_trainer_goodbye_contract.py',
             'tools/check_p0311_profession_close_filter_contract.py',
             'tools/check_p0312_profession_context_recovery_contract.py',
             'tools/check_p0313_trainer_focus_icon_contract.py'):
 need('P0314' in read(path) or (path.endswith('p0308_native_trainer_goodbye_contract.py') and 'if not okFamily or not ordinary(profession)' in read(path)),
      'historical native profession policy contract not migrated: '+path)
need('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in toc,
     'accepted trainer source/render chain broken')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)),'runtime version parity')
heads=('## Active Objective','## Current Work Item','## Verified State',
       '## Next Action','## Success Criteria','## Do Not Reopen Without New Evidence','## Relevant References')
cur=read('docs/memory/CURRENT.md')
need(len(cur.encode())<10000 and all(cur.splitlines().count(h)==1 for h in heads),'CURRENT maintenance')
for token in ('P0314','P0313','P0311','UNVERIFIED','Blizzard','Fishing','Enchanting',
              'Goodbye','FAIL','purchase','stock','opaque'):
 need(token.lower() in e.lower(),'P0314 evidence missing '+token)
print('P0314 profession single-window reversible native parking contract')
for err in errors:print('ERROR:',err)
if errors:raise SystemExit(1)
print('PASS: one-click stock restoration; guarded profession native-close; class unchanged; no poll/alpha hide')
