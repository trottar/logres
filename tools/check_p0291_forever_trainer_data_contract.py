#!/usr/bin/env python3
"""P0291: Forever 6-return trainer values safely feed the approved model."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/Quest/NativeTrainerServiceProbe.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
c=read('Logres/Core/Commands.lua')
p=read('Logres/Dev/Panel.lua')
t=read('Logres/Logres.toc')
b=read('Logres/Core/Bootstrap.lua')
e=read('docs/memory/evidence/P0291_FOREVER_TRAINER_DATA.md')
errors=[]
def need(test,why):
    if not test:errors.append(why)
for token in (
    'local function snapshotForeverRow(infoFn, costFn, skillFn, descriptionFn, index)',
    'local ok, name, serviceType, texture, reqLevel, subText, category = pcall(infoFn, index)',
    'if not ok or not ordinary(serviceType) or not ordinary(texture)',
    'or not ordinary(reqLevel) then return nil end',
    'type(serviceType) ~= "string" or type(texture) ~= "number"',
    'type(reqLevel) ~= "number"',
    'state="forever-service-observed"',
    'row.name = safeText(name, 100)',
    'row.rank = safeText(subText, 35)',
    'row.textureID = texture',
    'cappedInteger(texture, 1000000000)',
    'row.requiredLevel = reqLevel',
    'local copper, knownCost = scalar(costFn, index)',
    'row.cost = copper',
    'local skillOK, skill, rank, hasRequirement = pcall(skillFn, index)',
    'skillOK and ordinary(skill) and ordinary(rank)',
    'and ordinary(hasRequirement) then',
    'local description, knownDescription = scalar(descriptionFn, index)',
    'row.description = safeText(description, 260)',
    'local skillFn = api("GetTrainerServiceSkillReq")',
    'local descriptionFn = api("GetTrainerServiceDescription")',
    'local row = snapshotForeverRow(infoFn, costFn, skillFn, descriptionFn, index)',
    'if not row then row = snapshotRow(infoFn, costFn, iconFn, index) end',
    'local function snapshotRow(infoFn, costFn, iconFn, index)',
    'read(root, "IsProtected") ~= false',
    'read(root, "IsShown") ~= true',
    'state.interactionType ~= 7',
    'return ok and secret == false',
):need(token in s,'source/secret gate absent: '+token)
start=s.index('local function snapshotForeverRow(')
end=s.index('function Probe.Read()',start)
forever=s[start:end]
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(', 'SetTrainerServiceTypeFilter(',
                  'SetPoint(', 'SetParent(', 'SetAlpha(', 'hooksecurefunc(', 'OnUpdate'):
    need(forbidden not in forever,'Forever reader mutates native UI: '+forbidden)
need(forever.find('ordinary(serviceType)')<forever.find('type(serviceType)'),
     'serviceType inspected before secret gate')
need(forever.find('ordinary(texture)')<forever.find('type(texture)'),
     'texture inspected before secret gate')
need(forever.find('ordinary(reqLevel)')<forever.find('type(reqLevel)'),
     'required level inspected before secret gate')
for token in (
    'native.state ~= "forever-service-observed"',
    'native.state == "forever-service-observed"',
    'bounded(native.rank, 35)',
    'native.requiredLevel',
    'native.skillRequirement',
    'native.textureID',
    'row.requirement = requirement',
    'price=recognized and price(native.cost) or "Cost unknown"',
    'selected and selected.requirement',
    'selected and selected.icon or placeholder',
    'trainAll={label="Train All unavailable", enabled=false}',
    'trainLabel="Stock Train", trainEnabled=false',
    'root:EnableMouse(false)',
    'PLAYER_INTERACTION_MANAGER_FRAME_HIDE',
    'purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0',
):need(token in v,'missing shared renderer model or native safety: '+token)
for token in ('local function validIcon(value)', 'boundedString(value, 180)',
              'value <= 1000000000 and value == math.floor(value)',
              'not validIcon(r.icon)', 'if not validIcon(model.selected.icon) then return nil end',
              'return Landscape.Render(owner, Landscape.Fixture())'):
    need(token in l,'model icon or approved fixture check: '+token)
for bad in ('ClassTrainerFrame','BuyTrainerService(', 'GetTrainerServiceInfo(',
            'SelectTrainerService(', 'SetTrainerServiceTypeFilter(',
            'SetScript("OnUpdate"', 'hooksecurefunc('):
    need(bad not in l,'pure landscape renderer must not own native API: '+bad)
for x in ('"nativeTrainerLiveOn"','"nativeTrainerLiveOff"'):
    need(x in c,'H action missing: '+x)
for x in ('item.id == "nativeTrainerLiveOn"','item.id == "nativeTrainerLiveOff"'):
    need(x in p,'H first-page priority missing: '+x)
need('P0290' in read('tools/check_p0290_trainer_partial_snapshot_contract.py'),
     'P0290 historical partial-source checker removed')
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff authority absent')
for word in ('P0290','P0291','FOREVER','six','wrong','numeric','Blizzard',
             'UNVERIFIED','secret','no purchase'):
    need(word.lower() in e.lower(),'evidence missing '+word)
a=re.search(r'(?m)^## Version: (\S+)$',t)
x=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',b)
need(bool(a and x and a.group(1)==x.group(1)),'version parity')
for error in errors:print('ERROR:',error)
print('P0291 Forever native trainer six-field read-only view contract')
if errors:raise SystemExit(1)
print('PASS: source-only safe six-return normalization; legacy fallback, P renderer and Blizzard interactions retained')
