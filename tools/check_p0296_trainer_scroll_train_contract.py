#!/usr/bin/env python3
"""P0296: live-only slider plus independently guarded, single-service trainer request."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
v=read('Logres/Quest/TrainerLiveTrial.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
t=read('Logres/Quest/TrainerPurchaseTrial.lua')
p=read('Logres/Quest/NativeTrainerServiceProbe.lua')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
e=read('docs/memory/evidence/P0296_TRAINER_SCROLL_TRAIN_TEST.md')
errors=[]
def need(cond, msg):
    if not cond:errors.append(msg)
for token in ('CreateFrame("Slider", nil, root)', 'rail:SetOrientation("VERTICAL")',
              'rail:SetThumbTexture(', 'rail:GetThumbTexture()',
              'rail:SetScript("OnValueChanged"', 'browse.scrollSlider:SetValue(browse.offset)',
              'browse.scrollSlider:SetMinMaxValues(1, lastStart)',
              'if lastStart > 1 then', 'browse.scrollSlider:Hide()',
              'browse.syncSlider = true', 'browse.syncSlider = false',
              'moveBrowse(delta > 0 and -1 or 1)',
              'browse.localChoiceConfirmed = true', 'localChoiceConfirmed=false',
              'or not browse.localChoiceConfirmed',
              'Logres.NPCTrainerPurchaseTrial.Attempt(',
              'Trial.Disable("native-purchase-requested-unconfirmed")',
              'model.trainLabel = trainable and "Train selected (TEST)" or "Stock Train"',
              'nativeSession={total=report.total, trainerName=report.trainerName}',
              'sourceName=hasName and native.name or nil',
              'costCopper=type(native.cost) == "number" and native.cost or nil'):
    need(token in v,'missing live slider or explicit train gate: '+token)
for token in ('if not view.localBrowse then',
              'rect(owner, g.list.x + g.list.w - 18, g.list.y + 14, 7, 93, p.gold)',
              'if view.localBrowse then liveControls.trainText = trainText end',
              'controls.trainText:SetText(view.trainLabel)',
              'function Landscape.Preview(owner)',
              'return Landscape.Render(owner, Landscape.Fixture())'):
    need(token in l,'missing shared renderer/fixture boundary: '+token)
for token in ('function Trial.Attempt(row, snapshot)', 'row.sourceType ~= "available"',
              'row.sourceName', 'row.sourceRank', 'row.sourceTextureID',
              'row.costCopper', 'snapshot.total', 'snapshot.trainerName',
              'state.interactionType ~= 7', 'scalar(api("InCombatLockdown")) ~= false',
              'read(root, "IsProtected")', 'read(root, "IsShown")', 'scalar(api("UnitName"), "npc")',
              'scalar(api("GetNumTrainerServices"))', 'api("GetTrainerServiceInfo")',
              'api("GetTrainerServiceCost")', 'scalar(api("GetMoney"))',
              'or kind ~= "available"', 'wallet < liveCost',
              'ordinary(spellName)', 'ordinary(professionSlot)',
              'return deny("service-identity-or-eligibility-changed")',
              'local buyOK = pcall(buy, row.serviceIndex)',
              'requested = requested + 1',
              'last = "single-purchase-request-sent-unconfirmed"'):
    need(token in t, 'missing native revalidation or no-retry invariant: '+token)
need('api("BuyTrainerService")' in t,'missing one explicit native request capability')
need(t.count('pcall(buy, row.serviceIndex)') == 1,'must issue at most one direct request')
for forbidden in ('SelectTrainerService(', 'SetTrainerServiceTypeFilter(',
                  'hooksecurefunc(', 'SetScript("OnUpdate"', 'C_Timer.After(',
                  'BuyTrainerService('):
    need(forbidden not in v and forbidden not in l,'renderer/controller native mutation: '+forbidden)
for forbidden in ('SelectTrainerService(', 'SetTrainerServiceTypeFilter(',
                  'SetParent(', 'SetScript("OnUpdate"', 'C_Timer.After(',
                  'hooksecurefunc(', 'GetTrainerSelectionIndex(', 'ClassTrainerTrainButton'):
    need(forbidden not in t,'purchase controller forbidden native setter: '+forbidden)
need('Quest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua\nQuest\\OptionModel.lua' in toc,
     'new capability must load after live selection controller')
need('local MAX_SAMPLE = 64' in p,'read-only source cap changed')
need('maxRows = 7' in read('Logres/Quest/TrainerPanelConfig.lua'), 'seven rows changed')
need('P0295' in read('tools/check_p0295_trainer_row_hit_priority_contract.py'),
     'historical click priority checker lost')
for term in ('FAIL','P0295','P0296','scroll','Train','Blizzard','UNVERIFIED','single'):
    need(term.lower() in e.lower(),'durable evidence missing '+term)
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)), 'version mismatch')
need(len(read('docs/memory/CURRENT.md').encode()) < 10000,'CURRENT maintenance budget')
print('P0296 trainer live slider / explicit single-skill purchase contract')
for err in errors:print('ERROR:',err)
if errors: raise SystemExit(1)
print('PASS: live-only slider, independent guarded explicit purchase trial, stock UI retained')
