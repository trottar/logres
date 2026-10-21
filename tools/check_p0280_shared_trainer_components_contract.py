#!/usr/bin/env python3
"""P0280 shared component painter parity; client trial is separately required."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda path:(R/path).read_text(encoding='utf8')
s=read('Logres/Quest/TrainerComponents.lua')
n=read('Logres/Quest/NativeTrainerSkin.lua')
c=read('Logres/Quest/TrainerPanelConfig.lua')
t=read('Logres/Media/Theme.lua')
i=read('Logres/Quest/ServiceElementIndex.lua')
cmd=read('Logres/Core/Commands.lua')
toc=read('Logres/Logres.toc')
e=read('docs/memory/evidence/P0280_SHARED_TRAINER_COMPONENT_TRANCHE.md')
errors=[]
def need(ok,msg):
    if not ok: errors.append(msg)
for token in ('Logres.NPCTrainerComponents = Components',
    'function Components.Render(model)', 'function Components.Preview(owner)',
    'function Components.Enable(trainer)', 'function Components.Disable()',
    'function Components.GetAudit()', 'local function mappedTarget(id)',
    'Logres.ServiceElementIndex.byId[id]', 'return ok and secret == false',
    'return value, true', 'read(owner, "IsProtected")', 'read(owner, "IsShown")',
    'read(owner, "GetWidth")', 'read(owner, "GetHeight")',
    'type(InCombatLockdown)', 'pcall(InCombatLockdown)',
    'local drawn = Components.Render(model)', 'local drawn = Components.Render(view)',
    'fixture=true', 'frame:EnableMouse(false)',
    'target, recipe', 'painted(item.target, recipe)',
    'nativeGeometryWrites=0, nativeTransactions=0',
    'if not ok then hidePieces(pieces); return nil end',
    'if not pcall(function() pieces[i]:Show() end) then'):
    need(token in s,'shared renderer, gating or rollback missing '+token)
for token in ('components = {', 'styles = {','ids = {',
              '["trainer.filter"]','["trainer.selection"]',
              '["trainer.status"]','["trainer.train"]',
              'config' if False else 'preview = {'):
    need(token in c,'trainer component config missing '+token)
for token in ('controlFill', 'controlRule', 'selectionFill',
              'statusFill', 'trainFill'):
    need(token in t,'palette not shared '+token)
for token in ('Logres.NPCTrainerComponents.Disable()',
              'Logres.NPCTrainerComponents.Enable(frame)',
              'Logres.NPCTrainerLandscape.Preview(surface)',
              'components=Logres.NPCTrainerComponents.GetAudit()',
              'local pieces = createPaint(frame, width, height)',
              'Logres.NPCTrainerMotif.Enable(frame)',
              'pcall(item.set, item.region, item.token)'):
    need(token in n,'skin integration or stock restore lost '+token)
for token in ('components=%s/%s', 'componentResult=%s',
              'tostring(report.components.styled)',
              'tostring(report.components.deferred)'):
    need(token in cmd,'component diagnostics missing '+token)
for token in ('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua',):
    need(token in toc,'module load order '+token)
for id in ('trainer.filter','trainer.selection','trainer.status','trainer.train'):
    need('"'+id+'"' in i,'missing verified mapping '+id)
for bad in ('GetTrainerServiceInfo(', 'BuyTrainerService(', 'GetTrainerServiceCost(',
  'SetScript("OnUpdate"', 'hooksecurefunc(', 'SetParent(', 'SetStatusBarTexture(',
  'target:SetPoint(', 'target:SetSize(', 'target:SetAlpha(', 'target:Hide(',
  'target:SetNormalTexture(', 'DynamicCam'):
    need(bad not in s,'forbidden native mutation or uncertain hook '+bad)
for tok in ('PREVIEW', 'PARTIAL', 'Blizzard-owned', 'read-only',
            'P0279', 'P0280', 'portrait', 'unsupported', 'landscape'):
    need(tok in e,'durable scope/evidence missing '+tok)
need(re.search(r'## Version: (\S+)',toc).group(1)==
     re.search(r'Logres.VERSION = "([^"]+)"',read('Logres/Core/Bootstrap.lua')).group(1),
     'runtime version parity')
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff must cite current memory')
for x in errors: print('ERROR:',x)
print('P0280 shared trainer component preview/live contract')
if errors: raise SystemExit(1)
print('PASS: shared 4-control renderer, fail-open native owner; visual WoW proof pending')
