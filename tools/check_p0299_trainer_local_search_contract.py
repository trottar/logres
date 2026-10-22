#!/usr/bin/env python3
"""P0299: live-only local search; no native trainer filtering, bulk buys or preview edits."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
v=read('Logres/Quest/TrainerLiveTrial.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
t=read('Logres/Quest/TrainerPurchaseTrial.lua')
probe=read('Logres/Quest/NativeTrainerServiceProbe.lua')
old=read('tools/check_p0298_trainer_icon_layers_contract.py')
e=read('docs/memory/evidence/P0299_TRAINER_LOCAL_SEARCH.md')
errors=[]
def need(ok, why):
    if not ok: errors.append(why)
for token in (
    'search="Search spells..."', 'categories={"Sampled skills"}',
    'browse.searchQuery', 'string.find(row.name:lower(), browse.searchQuery, 1, true)',
    'row.sourceType == "available"',
    'local function refreshBrowse()', 'browse.offset = 1',
    'function Trial.Disable(why)', 'browse.searchEdit:ClearFocus()',
    'local searchEdit = CreateFrame("EditBox", nil, root)',
    'searchEdit:SetAutoFocus(false)', 'searchEdit:SetMaxLetters(48)',
    'searchEdit:EnableMouse(true)', 'searchEdit:SetScript("OnEditFocusGained"',
    'searchEdit:SetScript("OnEditFocusLost"', 'browse.controls.searchHint:SetText("")',
    'searchEdit:SetScript("OnTextChanged"',
    'searchEdit:SetScript("OnEscapePressed"',
    'searchEdit:SetScript("OnEnterPressed"',
    'ordinaryInput(value)', 'type(value) ~= "string"',
    'searchQuery=""', 'browse.searchEdit = searchEdit',
    'model.trainEnabled = trainable',
    'model.filters.mode = browse.availableOnly and "Available only" or "All sampled"',
    'Logres.NPCTrainerLandscape.UpdateLiveRows(browse.controls, model)',
    'if rows[i] and not rows[i].disabled and rows[i].serviceIndex then',
    'browse.scrollSlider:SetValue(browse.offset)',
    'root:EnableMouse(false)', 'Logres.NPCTrainerPurchaseTrial.Attempt(',
): need(token in v,'lost local search/filter/selection contract: '+token)
for token in (
    'if view.localBrowse then', 'liveControls.searchHint = text(filter, view.search',
    'text(filter, view.search, 14, 2, g.search.w - 108, 24,',
    'return Landscape.Render(owner, Landscape.Fixture())',
    'img:SetDrawLayer("OVERLAY", 1)',
    'controls.detail.icon:SetTexture(view.selected.icon)',
): need(token in l,'lost P fixture/icon/renderer boundary: '+token)
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
                  'SetTrainerServiceTypeFilter(', 'SetTrainerSkillLineFilter(',
                  'SetScript("OnUpdate"', 'C_Timer.After(', 'hooksecurefunc('):
    need(forbidden not in v and forbidden not in l,
         'local UI must not mutate native trainer or poll: '+forbidden)
need(v.count('CreateFrame("EditBox", nil, root)')==1,'search is live controller only')
need('local buyOK = pcall(buy, row.serviceIndex)' in t,'single-skill revalidation preserved')
need('local MAX_SAMPLE = 64' in probe,'native sample bound unchanged')
need('P0298' in old and 'img:SetDrawLayer' in old,'historical icon contract lost')
for token in ('P0298','P0299','PASS','UNVERIFIED','Train All','Blizzard',
              'search','48','selection','filter'):
    need(token.lower() in e.lower(),'evidence lacks '+token)
current=read('docs/memory/CURRENT.md')
need(current.count('## Next Action')==1 and len(current.encode())<10000,
     'CURRENT maintenance budget exceeded')
a=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)),'runtime version parity')
print('P0299 local trainer search and preserved native bulk transaction gate')
for err in errors:print('ERROR:',err)
if errors:raise SystemExit(1)
print('PASS: bounded local name search, seven-row identity/slider, inert P, Blizzard Train All retained')
