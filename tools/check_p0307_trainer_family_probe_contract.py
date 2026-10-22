#!/usr/bin/env python3
"""P0307: source-neutral NPC framework's trainer-family read-only adapter diagnostic."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/Quest/NPCTrainerFamilyProbe.lua')
c=read('Logres/Core/Commands.lua')
t=read('Logres/Logres.toc')
version=read('Logres/Core/Bootstrap.lua')
old=read('tools/check_p0306_trainer_native_parking_contract.py')
e=read('docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md')
cur=read('docs/memory/CURRENT.md')
errors=[]
def need(cond,desc):
    if not cond:errors.append(desc)
for token in ('Logres.NPCTrainerFamilyProbe = Probe','function Probe.Read()',
              'Logres:GetState()', 'Logres.NPCServiceSession',
              'Logres.NPCTrainerLiveTrial', 'IsTradeskillTrainer',
              'GetNumTrainerServices', 'GetTrainerServiceInfo',
              'read(root, "IsShown")', 'read(root, "IsProtected")',
              'scalar(api("InCombatLockdown")) ~= false',
              'ordinary(name)', 'ordinary(serviceType)',
              'ordinary(texture)', 'ordinary(reqLevel)', 'ordinary(rank)',
              'output.service1Type = serviceType',
              'output.source = "forever-six-field-candidate"',
              'transactions=0, nativeWrites=0'):
    need(token in s,'probe read-only boundary missing: '+token)
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
                  'CloseTrainer(', 'SetPoint(', 'ClearAllPoints(',
                  'SetAlpha(', 'SetParent(', 'HideUIPanel(', 'C_Timer.',
                  'SetScript("OnUpdate"', 'hooksecurefunc(', 'DynamicCam'):
    need(forbidden not in s,'family probe may not mutate/native poll: '+forbidden)
for token in ('if command == "trainerfamilycheck" then',
              'Logres.NPCTrainerFamilyProbe.Read()',
              '"trainerFamilyCheck"', '"Trainer Family Check (READ-ONLY)"',
              '"trainerfamilycheck"'):
    need(token in c,'missing H-panel diagnostic action: '+token)
need('Core\\Lifecycle.lua\nUI\\NPCServiceSession.lua\nUI\\NPCServiceNativeParking.lua\nQuest\\NPCTrainerFamilyProbe.lua' in t,
     'P0306 contiguous session+parking or new probe load order lost')
need('Quest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in t,
     'historical trainer chain changed')
need('P0306' in old and 'NPCServiceNativeParking' in old,'historical parking checker missing')
for x in ('P0306','P0307','PASS','UNVERIFIED','profession','fishing',
          'Blizzard','stock','READ-ONLY','no purchase','no parking'):
    need(x.lower() in e.lower(),'evidence omits '+x)
head=('## Active Objective','## Current Work Item','## Verified State',
      '## Next Action','## Success Criteria',
      '## Do Not Reopen Without New Evidence','## Relevant References')
need(len(cur.encode())<10000 and all(cur.splitlines().count(h)==1 for h in head),
     'CURRENT memory headings/budget')
a=re.search(r'(?m)^## Version: (\S+)$',t)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',version)
need(bool(a and b and a.group(1)==b.group(1)),'version parity')
print('P0307 trainer family / source-neutral NPC compatibility diagnostic')
for e in errors: print('ERROR:',e)
if errors:raise SystemExit(1)
print('PASS: family diagnostic is read-only; class trainer/parking transaction gates unchanged')
