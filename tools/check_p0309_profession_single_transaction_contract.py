#!/usr/bin/env python3
"""P0309: preserve class controls; service-specific guarded profession one-skill purchase."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
v=read('Logres/Quest/TrainerLiveTrial.lua')
p=read('Logres/Quest/TrainerPurchaseTrial.lua')
s=read('Logres/Quest/TrainerProfessionPurchaseTrial.lua')
parking=read('Logres/UI/NPCServiceNativeParking.lua')
close=read('Logres/Quest/TrainerCloseTrial.lua')
toc=read('Logres/Logres.toc')
e=read('docs/memory/evidence/P0309_PROFESSION_SINGLE_TRANSACTION.md')
c=read('docs/memory/CURRENT.md')
prior=read('tools/check_p0308_native_trainer_goodbye_contract.py')
errors=[]
def need(ok,why):
    if not ok: errors.append(why)
for token in ('Logres.NPCTrainerProfessionPurchaseTrial = Trial',
    'function Trial.Attempt(row, snapshot)',
    'snapshot.profession ~= true or row.sourceType ~= "available"',
    'state.interacting ~= true or state.interactionType ~= 7',
    'scalar(api("IsTradeskillTrainer")) ~= true',
    'read(root, "IsProtected") ~= false',
    'read(root, "IsShown") ~= true',
    'snapshot.trainerName', 'snapshot.total', 'sourceName',
    'sourceRank', 'sourceTextureID', 'sourceRequiredLevel',
    'sourceSkillRequirement', 'sourceSkillRank',
    'api("GetTrainerServiceInfo")', 'api("GetTrainerServiceCost")',
    'api("GetTrainerServiceSkillReq")',
    'api("BuyTrainerService")', 'scalar(api("GetMoney"))',
    'ordinary(copper)', 'ordinary(talentCost)', 'ordinary(professionCost)',
    'talentCost ~= nil and talentCost ~= 0',
    'professionCost ~= nil and professionCost ~= 0',
    'money < copper', 'row.serviceIndex',
    'local sent = pcall(buy, row.serviceIndex)',
    'requests = requests + 1', 'profession-single-request-sent-unconfirmed',
    'function Trial.GetAudit()'):
    need(token in s,'profession guard/receipt missing: '+token)
need(s.count('pcall(buy, row.serviceIndex)')==1,
     'exactly one native profession purchase call site')
need('scalar(api("IsTradeskillTrainer")) ~= false' in p,
     'class single skill purchase must reject professions')
need('function Trial.AttemptAll(quoted, snapshot)' in p and
     'scalar(api("IsTradeskillTrainer")) ~= false' in p,
     'class bulk gating must remain intact')
for token in ('sourceSkillRequirement=', 'sourceSkillRank=',
    'local function trainerFamily()',
    'model.nativeSession.profession = trainerFamily()',
    'model.trainEnabled = trainable and model.nativeSession.profession ~= nil',
    'if browse.model.nativeSession.profession == true then',
    'Logres.NPCTrainerProfessionPurchaseTrial.Attempt(',
    'elseif browse.model.nativeSession.profession == false then',
    'Logres.NPCTrainerPurchaseTrial.Attempt(',
    'Trial.Disable("native-purchase-requested-unconfirmed")',
    'local dismissed = Trial.Disable("goodbye")',
    'Logres.NPCTrainerCloseTrial.RequestClose()',
    'Logres.NPCServiceCatalogue.Filter(',
    'Logres.NPCServiceCatalogue.Window(',
    'Logres.NPCServiceCatalogue.Find('):
    need(token in v,'live shared catalogue/controller route lost: '+token)
need('profession-or-unknown-stock-retained' in parking,
     'profession native stock must remain visible')
need('function Close.RequestClose()' in close, 'class Goodbye lost')
need('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in toc,
     'historic trainer UI chain load order changed')
need('Quest\\NPCTrainerFamilyProbe.lua\nQuest\\TrainerCloseTrial.lua\nQuest\\TrainerProfessionPurchaseTrial.lua' in toc,
     'new profession transaction module must load after class close adapter')
need('P0308' in prior and 'TrainerCloseTrial' in prior,
     'prior native-close contract missing')
for path,text in [('live',v),('profession',s)]:
    for token in ('SetScript("OnUpdate"', 'C_Timer.', 'hooksecurefunc(',
                  'SelectTrainerService(', 'SetTrainerServiceTypeFilter('):
        need(token not in text,f'{path}: forbidden native filter/poll mutation {token}')
for token in ('P0308','P0309','PASS','UNVERIFIED','Cooking','Enchanting',
    'Fishing','Blizzard','extra','stock','single','class', 'bulk'):
    need(token.lower() in e.lower(),'missing evidence '+token)
heads=('## Active Objective','## Current Work Item','## Verified State',
       '## Next Action','## Success Criteria',
       '## Do Not Reopen Without New Evidence','## Relevant References')
need(len(c.encode())<10000 and all(c.splitlines().count(h)==1 for h in heads),
     'CURRENT memory health')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)),'runtime version mismatch')
print('P0309 guarded, click-only profession one-skill purchase contract')
for issue in errors:print('ERROR:',issue)
if errors:raise SystemExit(1)
print('PASS: family-isolated revalidation, no automatic or bulk profession transaction; stock retained')
