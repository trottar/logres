#!/usr/bin/env python3
"""P0302: owned-only cosmetic hover; no transaction or Blizzard state changes."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT/p).read_text(encoding='utf-8')
v = read('Logres/Quest/TrainerLiveTrial.lua')
l = read('Logres/Quest/TrainerLandscape.lua')
c = read('Logres/Quest/TrainerPanelConfig.lua')
purchase = read('Logres/Quest/TrainerPurchaseTrial.lua')
quest = read('Logres/UI/DecisionVisual.lua')
old = read('tools/check_p0301_trainer_bulk_contract.py')
e = read('docs/memory/evidence/P0302_TRAINER_HOVER_FEEDBACK.md')
issues = []
def need(cond, why):
    if not cond: issues.append(why)
for token in ('local function bindHover(region, owner, allowed, label)',
              'region:SetScript("OnEnter"', 'region:SetScript("OnLeave"',
              'wash:SetVertexColor(0.73, 0.51, 0.24, 0.15)',
              'rule:SetVertexColor(1.00, 0.84, 0.48, 0.96)',
              'if active ~= owner or not browse or not allowed() then return end',
              'wash:Hide()', 'rule:Hide()',
              'bindHover(filter, root, function() return true end)',
              'bindHover(control, root, function() return true end)',
              'hit:SetScript("OnEnter", function()',
              'hit:SetScript("OnLeave", function()',
              'if datum and not datum.disabled and datum.serviceIndex',
              'and slot and slot.hover then slot.hover:Show() end',
              'if slot and slot.hover then slot.hover:Hide() end',
              'bindHover(trainHit, root, function()',
              'return browse and browse.model.trainEnabled == true',
              'end, controls.trainText)',
              'bindHover(bulkHit, root, function()',
              'return browse and browse.model.trainAll.enabled == true',
              'end, controls.trainAllText)',
              'Trial.Disable("goodbye")'):
    need(token in v, 'missing owned hover or existing Goodbye: '+token)
need(v.count('local function bindHover(')==1,'duplicate hover helper')
for token in ('if view.localBrowse then',
              'hoverWash = rect(row, 0, 0, g.list.w - 29,',
              'hoverWash:Hide()', 'hover=hoverWash}',
              'if slot.hover then slot.hover:Hide() end',
              'local trainAllText = text(trainAll, view.trainAll.label',
              'liveControls.trainAllText = trainAllText',
              'return Landscape.Render(owner, Landscape.Fixture())',
              'controls.detail.icon:SetTexture(view.selected.icon)'):
    need(token in l,'missing source renderer / preview preservation: '+token)
need('hover = {0.84, 0.61, 0.29, 0.18}' in c,'missing palette hover wash')
need('button:SetScript("OnEnter"' in quest and 'colorValue("hover")' in quest,
     'Quest hover reference missing')
need('P0301' in old and 'AttemptAll' in old,'bulk historical contract changed')
need('function Trial.AttemptAll(' in purchase and 'function Trial.QuoteAll(' in purchase,
     'bulk transaction capability lost')
need('Logres.NPCTrainerPurchaseTrial.AttemptAll(' in v and
     'Logres.NPCTrainerPurchaseTrial.Attempt(' in v,
     'existing explicit native requests missing')
for banned in ('BuyTrainerService(', 'SelectTrainerService(',
               'SetTrainerServiceTypeFilter(', 'SetScript("OnUpdate"',
               'C_Timer.After(', 'hooksecurefunc(', 'HideUIPanel('):
    need(banned not in v and banned not in l,
         'hover code must not mutate native UI or poll: '+banned)
need('CreateFrame("Button"' not in v,'owned hit region changed to Button')
for term in ('P0301','P0302','PASS','UNVERIFIED','hover','Blizzard','Train All'):
    need(term.lower() in e.lower(), 'evidence incomplete: '+term)
current=read('docs/memory/CURRENT.md')
for heading in ('## Active Objective','## Current Work Item','## Verified State',
                '## Next Action','## Success Criteria',
                '## Do Not Reopen Without New Evidence','## Relevant References'):
    need(current.splitlines().count(heading)==1,'CURRENT missing heading: '+heading)
need(len(current.encode())<10000,'CURRENT size maintenance failure')
ma=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
mb=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(ma and mb and ma.group(1)==mb.group(1)),'version parity')
print('P0302 trainer hover feedback contract')
for issue in issues: print('ERROR:',issue)
if issues:raise SystemExit(1)
print('PASS: owned hover gates, inactive controls inert, no native mutation, P fixture intact')
