#!/usr/bin/env python3
"""P0300: live-only Quest-matched Goodbye; no native trainer close or protected controls."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda path:(R/path).read_text(encoding='utf-8')
v=read('Logres/Quest/TrainerLiveTrial.lua')
q=read('Logres/Quest/Dialogue.lua')
l=read('Logres/Quest/TrainerLandscape.lua')
t=read('Logres/Quest/TrainerPurchaseTrial.lua')
p=read('tools/check_p0299_trainer_local_search_contract.py')
e=read('docs/memory/evidence/P0300_TRAINER_GOODBYE.md')
errors=[]
def need(x, why):
    if not x:errors.append(why)
start=v.find('local function attachBrowseControls(root, model, controls)')
end=v.find('function Trial.Toggle(mode)',start)
segment=v[start:end] if start>=0 and end>start else ''
for token in (
    'local goodbye = CreateFrame("Frame", nil, root)',
    'goodbye:SetSize(78, 24)',
    'goodbye:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)',
    'goodbye:SetFrameLevel(root:GetFrameLevel() + 10)',
    'goodbye:EnableMouse(true)',
    'goodbyeText:SetText("Goodbye")',
    'goodbyeLine:SetTexture(',
    'goodbyeLine:SetHeight(1)',
    'goodbyeLine:SetPoint("BOTTOMLEFT", goodbye, "BOTTOMLEFT", 5, 0)',
    'goodbyeLine:SetPoint("BOTTOMRIGHT", goodbye, "BOTTOMRIGHT", -5, 0)',
    'goodbye:SetScript("OnEnter"',
    'goodbye:SetScript("OnLeave"',
    'goodbye:SetScript("OnMouseUp"',
    'ordinaryInput(button) and button == "LeftButton" and active == root',
    'Trial.Disable("goodbye")',
):need(token in segment,'missing owned Goodbye contract: '+token)
need(segment.count('local goodbye = CreateFrame("Frame", nil, root)')==1,
     'multiple Goodbye regions')
need('function Trial.Disable(why)' in v and
     'browse.searchEdit:ClearFocus()' in v and
     'if active then active:Hide(); active = nil end' in v,
     'Goodbye must share focus and safe teardown')
for token in ('goodbyeButton:SetSize(78, 24)',
              'goodbyeButton:SetPoint("TOPRIGHT", root, "TOPRIGHT", -45, -12)',
              'goodbyeText:SetText("Goodbye")',
              'self:HidePresentation("goodbye")'):
    need(token in q,'Quest Goodbye baseline unexpectedly changed: '+token)
for forbidden in ('CloseTrainer(', 'HideUIPanel(', 'SelectTrainerService(',
                  'SetTrainerServiceTypeFilter(', 'BuyTrainerService(',
                  'hooksecurefunc(', 'SetScript("OnUpdate"', 'C_Timer.After('):
    need(forbidden not in v and forbidden not in l,
         'Goodbye may not own native trainer or poll: '+forbidden)
need('Logres.NPCTrainerPurchaseTrial.Attempt(' in v and
     'local buyOK = pcall(buy, row.serviceIndex)' in t,
     'prior single-service purchase unchanged')
need('searchQuery=""' in v and 'browse.scrollSlider:SetValue(browse.offset)' in v,
     'local search/slider changed')
need('return Landscape.Render(owner, Landscape.Fixture())' in l,
     'synthetic P route changed')
need('P0299' in p and 'searchEdit:SetMaxLetters(48)' in p,
     'prior P0299 checker lost')
for token in ('P0299','P0300','PASS','UNVERIFIED','Goodbye','Blizzard','Train All'):
    need(token.lower() in e.lower(), 'evidence missing '+token)
c=read('docs/memory/CURRENT.md')
need(len(c.encode())<10000 and c.count('## Next Action')==1,
     'CURRENT budget/next action invalid')
a=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)), 'TOC/bootstrap version mismatch')
print('P0300 Quest-matched live trainer Goodbye contract')
for err in errors:print('ERROR:',err)
if errors:raise SystemExit(1)
print('PASS: safe owned header exit, native stock preserved, search and purchases unchanged')
