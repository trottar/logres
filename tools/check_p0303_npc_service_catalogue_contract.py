#!/usr/bin/env python3
"""P0303: source-neutral catalogue utilities integrated into tested trainer."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda path: (R / path).read_text(encoding="utf-8")
c = read("Logres/UI/NPCServiceCatalogue.lua")
v = read("Logres/Quest/TrainerLiveTrial.lua")
l = read("Logres/Quest/TrainerLandscape.lua")
t = read("Logres/Quest/TrainerPurchaseTrial.lua")
toc = read("Logres/Logres.toc")
cur = read("docs/memory/CURRENT.md")
e = read("docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md")
issues = []
def need(condition, why):
    if not condition: issues.append(why)
for x in ('function Catalogue.Filter(records, include)',
          'function Catalogue.Window(records, offset, visible)',
          'function Catalogue.Find(records, key, identify)',
          'for i = 1, #records do', 'local lastStart = math.max(1, #records - visible + 1)',
          'return page, first, lastStart, finish', 'if identify(record) == key then return record end'):
    need(x in c, 'missing neutral module operation: '+x)
for x in ('Logres.NPCServiceCatalogue.Filter(model.catalog, function(row)',
          'row.selected = row.serviceIndex == browse.selectedServiceIndex',
          'string.find(row.name:lower(), browse.searchQuery, 1, true)',
          'row.sourceType == "available"',
          'Logres.NPCServiceCatalogue.Window(matching, browse.offset, width)',
          'browse.offset = first', 'browse.scrollSlider:SetValue(browse.offset)',
          'Logres.NPCServiceCatalogue.Find(',
          'entry.serviceIndex == row.serviceIndex',
          'Logres.NPCTrainerPurchaseTrial.Attempt(',
          'Logres.NPCTrainerPurchaseTrial.AttemptAll(',
          'Trial.Disable("goodbye")'):
    need(x in v, 'lost trainer capability or neutral integration: '+x)
# Keep existing trainer visual and live-adapter load adjacency intact.
need('Quest\\TrainerComponents.lua\nQuest\\TrainerMotif.lua\nQuest\\TrainerLandscape.lua\nQuest\\NativeTrainerSkin.lua\nQuest\\TrainerLiveTrial.lua\nQuest\\TrainerPurchaseTrial.lua' in toc,
     'legacy trainer module chain must remain contiguous')
need('Quest\\NativeTrainerServiceProbe.lua\nUI\\NPCServiceCatalogue.lua\nQuest\\TrainerComponents.lua' in toc,
     'shared module must load after source probe but before contiguous trainer chain')
for forbidden in ('GetTrainerServiceInfo(', 'BuyTrainerService(', 'GetMoney(',
                  'SetScript(', 'CreateFrame(', 'UnitName(', 'C_Timer.After(', 'hooksecurefunc('):
    need(forbidden not in c, 'shared catalogue must remain data-only: '+forbidden)
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
                  'SetTrainerServiceTypeFilter(', 'C_Timer.After(', 'hooksecurefunc('):
    need(forbidden not in v, 'trainer view must not write native state: '+forbidden)
need('return Landscape.Render(owner, Landscape.Fixture())' in l, 'P fixture must remain inert')
need('function Trial.AttemptAll(' in t and 'function Trial.Attempt(' in t,
     'single and bulk purchase guards missing')
need('P0302' in e and 'P0303' in e and 'PASS' in e and 'UNVERIFIED' in e,
     'evidence not synchronized with user results and test limits')
required = ('## Active Objective','## Current Work Item','## Verified State',
            '## Next Action','## Success Criteria',
            '## Do Not Reopen Without New Evidence','## Relevant References')
need(len(cur.encode()) < 10000 and all(cur.splitlines().count(x) == 1 for x in required),
     'CURRENT missing required headings or exceeds maintenance budget')
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1) == b.group(1)), 'runtime version mismatch')
print('P0303 service-neutral catalogue extraction contract')
for issue in issues: print('ERROR:', issue)
if issues: raise SystemExit(1)
print('PASS: source-neutral filter/window/identity, trainer gates and shared renderer intact')
