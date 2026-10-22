#!/usr/bin/env python3
"""P0290: independently safe trainer names survive other field deferrals."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda name:(R/name).read_text(encoding='utf-8')
source=read('Logres/Quest/NativeTrainerServiceProbe.lua')
trial=read('Logres/Quest/TrainerLiveTrial.lua')
land=read('Logres/Quest/TrainerLandscape.lua')
commands=read('Logres/Core/Commands.lua')
panel=read('Logres/Dev/Panel.lua')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
evidence=read('docs/memory/evidence/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md')
errors=[]
def need(ok,msg):
    if not ok:errors.append(msg)
for token in (
    'if not ok or not ordinary(name) or not ordinary(subText)',
    'or not ordinary(category) or not ordinary(expanded) then',
    'if ok and ordinary(name) then safeName = safeText(name, 100) end',
    'state="deferred-secret-or-call", name=safeName',
    'local numericCategory = cappedInteger(category, 255)',
    'state=numericCategory and "numeric-category-unclassified" or "source-observed"',
    'state="unexpected-service-shape"',
    'read(root, "IsProtected") ~= false',
    'read(root, "IsShown") ~= true',
    'state.interactionType ~= 7',
    'report.status="service-row-shape-deferred"',
):need(token in source,'source partial-value or safety gate missing: '+token)
# Preserve existing P0288 contract token syntax and add independently partial rows.
for token in (
    'function Trial.FromSnapshot(report)',
    'report.status ~= "service-row-shape-deferred"',
    'report.status ~= "read-only-service-sample"',
    'native.state ~= "numeric-category-unclassified"',
    'native.state ~= "source-observed"',
    'native.state ~= "unexpected-service-shape"',
    'native.state ~= "deferred-secret-or-call"',
    'return nil, "invalid-service-identity"',
    'return nil, "unrecognized-service-source-state"',
    'local hasName = bounded(native.name, 100)',
    '" (details withheld)"',
    'recognized and price(native.cost) or "Cost unknown"',
    'requirement="Availability not classified"',
    'serviceIndex=native.index',
    'visibleWithheld > 0 and "native-snapshot-mapped-partial"',
    '"live-partial-visible"',
    'Logres.NPCTrainerLandscape.Build(model)',
    'Logres.NPCTrainerLandscape.Render(root, model)',
    'root:EnableMouse(false)',
    'trainAll={label="Train All unavailable", enabled=false}',
    'trainLabel="Stock Train", trainEnabled=false',
    'PLAYER_INTERACTION_MANAGER_FRAME_HIDE',
    'PLAYER_REGEN_DISABLED',
    'PLAYER_ENTERING_WORLD',
    'purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0',
):need(token in trial,'partial trial or safety contract missing: '+token)
need('return nil, "unsafe-or-incomplete-service-row"' not in trial,
     'old all-or-nothing row rejection remains')
for fname,data in (('source',source),('trial',trial)):
    for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
                      'SetTrainerServiceTypeFilter(', 'SetParent(',
                      'SetScript("OnUpdate"', 'ClearAllPoints(', 'DynamicCam'):
        need(forbidden not in data,f'{fname}: forbidden native action '+forbidden)
need('return Landscape.Render(owner, Landscape.Fixture())' in land,
     'accepted P fixture must still use exact same renderer')
for token in ('"nativeTrainerLiveOn"','"nativeTrainerLiveOff"',
              '"nativetrainerlive on"','"nativetrainerlive off"'):
    need(token in commands,'missing H registration '+token)
for token in ('item.id == "nativeTrainerLiveOn"','item.id == "nativeTrainerLiveOff"',
              'self:RunCommand(action.command)'):
    need(token in panel,'H panel routing missing '+token)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff missing CURRENT authority')
for token in ('P0289','P0290','unsafe-or-incomplete-service-row',
              'FAIL','partial','UNVERIFIED','Blizzard','no purchase'):
    need(token.lower() in evidence.lower(),'durable negative evidence missing '+token)
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)), 'runtime version parity')
need('P0288' in read('tools/check_p0288_trainer_live_trial_contract.py'),
     'historical P0288 shared renderer checker removed')
print('P0290 independently ordinary trainer detail / partial render contract')
for problem in errors:print('ERROR:',problem)
if errors:raise SystemExit(1)
print('PASS: unknown row details remain inert, stock transactions intact, H panel preserved')
