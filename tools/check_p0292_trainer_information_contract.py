#!/usr/bin/env python3
"""P0292: only ordinary and bounded trainer identity/abilities/status enter a read-only model."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/Quest/NativeTrainerServiceProbe.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
c=read('Logres/Core/Commands.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
t=read('Logres/Logres.toc'); b=read('Logres/Core/Bootstrap.lua')
e=read('docs/memory/evidence/P0292_TRAINER_INFORMATION_COMPLETENESS.md')
errors=[]
def need(x,msg):
    if not x:errors.append(msg)
for token in ('GetTrainerServiceNumAbilityReq','GetTrainerServiceAbilityReq',
              'scalar(api("GetTrainerServiceNumAbilityReq"), index)',
              'api("GetTrainerServiceAbilityReq")',
              'cappedInteger(abilityCount, 4)',
              'ordinary(abilityName) and ordinary(hasAbility)',
              'local safeAbility = safeText(abilityName, 42)',
              'row.abilityRequirements = abilities',
              'local trainerName, nameKnown = scalar(api("UnitName"), "npc")',
              'report.trainerName = safeName',
              'local function snapshotForeverRow(infoFn, costFn, skillFn, descriptionFn, index)',
              'local ok, name, serviceType, texture, reqLevel, subText, category = pcall(infoFn, index)',
              'read(root, "IsProtected") ~= false',
              'read(root, "IsShown") ~= true',
              'state.interactionType ~= 7',
              'return ok and secret == false'):
    need(token in s,'missing guarded source: '+token)
segment=s[s.index('local function snapshotForeverRow('):s.index('function Probe.Read()')]
need(segment.index('ordinary(abilityName)')<segment.index('safeText(abilityName, 42)'), 'ability name must be secret-gated before reading')
need(segment.index('cappedInteger(abilityCount, 4)')<segment.index('for slot = 1, abilityCount do'), 'count must be bounded before loop')
for token in ('bounded(report.trainerName, 90)', 'native.abilityRequirements',
              'if bounded(ability, 42) then',
              'native.serviceType == "available"',
              'native.serviceType == "unavailable"',
              'native.serviceType == "used"',
              '"Available"', '"Unavailable"', '"Known"',
              '"Availability not classified"',
              'row.requirement = requirement',
              'trainAll={label="Train All unavailable", enabled=false}',
              'trainLabel="Stock Train", trainEnabled=false',
              'root:EnableMouse(false)',
              'purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0'):
    need(token in v,'missing model behavior or stock boundary: '+token)
for p,data in (('source',s),('trial',v)):
    for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
        'SetTrainerServiceTypeFilter(', 'ClearAllPoints(', 'SetParent(',
        'SetScript("OnUpdate"', 'hooksecurefunc(', 'C_Timer.After('):
        need(forbidden not in data,p+' forbidden native operation: '+forbidden)
need('return Landscape.Render(owner, Landscape.Fixture())' in l,'synthetic accepted composition lost')
need('"nativeTrainerLiveOn"' in c and '"nativeTrainerLiveOff"' in c, 'H panel actions absent')
need('P0291' in read('tools/check_p0291_forever_trainer_data_contract.py'), 'historical check missing')
for term in ('P0291','P0292','Wrath','Mardant','LIVE','PARTIAL PASS','no purchase','Blizzard','UNVERIFIED'):
    need(term.lower() in e.lower(), 'missing durable evidence '+term)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'), 'handoff authority absent')
need(len(read('docs/memory/CURRENT.md').encode('utf-8'))<10000,'CURRENT over 10KB soft target')
a=re.search(r'(?m)^## Version: (\S+)$',t)
x=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',b)
need(bool(a and x and a.group(1)==x.group(1)), 'version mismatch')
for m in errors:print('ERROR:',m)
print('P0292 trainer information completeness contract')
if errors:raise SystemExit(1)
print('PASS: ability/identity/status source guarded, no gameplay ownership')
