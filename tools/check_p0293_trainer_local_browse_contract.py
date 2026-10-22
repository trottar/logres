#!/usr/bin/env python3
"""P0293: addon-owned, bounded local browse of trainer source; Blizzard stays authoritative."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
read=lambda path:(ROOT/path).read_text(encoding='utf-8')
s=read('Logres/Quest/NativeTrainerServiceProbe.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
conf=read('Logres/Quest/TrainerPanelConfig.lua')
h=read('tools/check_p0285_trainer_service_source_contract.py')
past=read('tools/check_p0292_trainer_information_contract.py')
cmd=read('Logres/Core/Commands.lua')
panel=read('Logres/Dev/Panel.lua')
e=read('docs/memory/evidence/P0293_TRAINER_LOCAL_BROWSE.md')
toc=read('Logres/Logres.toc'); boot=read('Logres/Core/Bootstrap.lua')
errors=[]
def need(test, message):
    if not test: errors.append(message)
for token in ('local MAX_SAMPLE = 64','MAX_SERVICES = 384',
              'math.min(total, MAX_SAMPLE)', 'state.interactionType ~= 7',
              'read(root, "IsProtected") ~= false', 'read(root, "IsShown") ~= true',
              'return ok and secret == false'):
    need(token in s,'missing on-demand bounded source: '+token)
need("'MAX_SAMPLE = 64'" in h,'P0285 historical cap checker not migrated')
for token in ('if #report.sample < 1 or #report.sample > 64 then',
              'local catalog = rows', 'catalog=catalog, localBrowse=true',
              'serviceIndex=native.index', 'sourceType=native.state == "forever-service-observed"',
              'local function refreshBrowse()', 'model.catalog',
              'row.sourceType == "available"', 'browse.offset',
              '"All sampled"', '"Available only"',
              'function Trial.Disable(why)', 'browse = nil',
              'local function moveBrowse(delta)', 'local function attachBrowseControls(root, model, controls)',
              'filter:SetScript("OnMouseUp"', 'wheel:SetScript("OnMouseWheel"',
              'control:SetScript("OnMouseUp"', 'filter:EnableMouse(true)',
              'wheel:EnableMouseWheel(true)', 'control:EnableMouse(true)',
              'root:EnableMouse(false)',
              'Logres.NPCTrainerLandscape.UpdateLiveRows(browse.controls, model)',
              'purchases=0, filterWrites=0, selectionWrites=0, nativeGeometryWrites=0'):
    need(token in v,'missing local display-only control: '+token)
need('CreateFrame("Button"' not in v,'avoid protected/native action button ownership')
need('SetScript("OnUpdate"' not in v,'no polling')
for token in ('return f, img', 'liveControls = {rows={}}',
              'if view.localBrowse then rowState = "normal" end',
              'function Landscape.UpdateLiveRows(controls, view)',
              'slot.image:SetTexture(datum.icon)', 'slot.name:SetText(datum.name)',
              'slot.requirement:SetText(datum.requirement)',
              'slot.price:SetText(datum.price)', 'slot.frame:Hide()',
              'controls.filterMode:SetText(view.filters.mode)',
              'controls.statusText:SetText(view.profession)',
              'return Landscape.Render(owner, Landscape.Fixture())'):
    need(token in l,'missing reuse/fixture contract: '+token)
need('maxRows = 7' in conf,'accepted seven-slot geometry changed')
for label in ('"nativeTrainerLiveOn"','"nativeTrainerLiveOff"'):
    need(label in cmd,'H live trial actions lost: '+label)
for label in ('item.id == "nativeTrainerLiveOn"','item.id == "nativeTrainerLiveOff"'):
    need(label in panel,'H first page ordering lost: '+label)
for path,source in [('probe',s),('trial',v),('landscape',l)]:
    for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
        'SetTrainerServiceTypeFilter(', 'SetTrainerSkillLineFilter(',
        'hooksecurefunc(', 'SetScript("OnUpdate"', 'C_Timer.After('):
        need(forbidden not in source,path+' must not mutate native trainer '+forbidden)
need('GetTrainerServiceInfo(' not in v and 'GetTrainerServiceInfo(' not in l,
     'pointer-driven presentation must not reread native source')
need('P0292' in past, 'P0292 historical source checker missing')
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'handoff must cite current authority')
need(len(read('docs/memory/CURRENT.md').encode('utf-8'))<10000,
     'CURRENT.md maintenance budget exceeded')
for word in ('P0292','P0293','All sampled','Available only','64','Blizzard',
             'UNVERIFIED','mouse','filter','no native'):
    need(word.lower() in e.lower(), 'required evidence/scope missing '+word)
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(a and b and a.group(1)==b.group(1)),'version parity')
print('P0293 local trainer filter and bounded wheel/rail navigation')
for error in errors:print('ERROR:',error)
if errors:raise SystemExit(1)
print('PASS: reusable seven-row Logres widgets; Blizzard transactions and native filters unchanged')
