#!/usr/bin/env python3
"""P0301: guarded, explicit full-list class trainer bulk requests and stock fallback."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
v = read('Logres/Quest/TrainerLiveTrial.lua')
t = read('Logres/Quest/TrainerPurchaseTrial.lua')
l = read('Logres/Quest/TrainerLandscape.lua')
e = read('docs/memory/evidence/P0301_TRAINER_BULK_TRANSACTION.md')
p = read('tools/check_p0300_trainer_goodbye_contract.py')
errors = []
def need(ok, why):
    if not ok: errors.append(why)
for token in (
    'local bulkAttempts, bulkRequests, bulkDeferrals, bulkFailures',
    'local function bulkRow(index, info, cost)',
    'not ordinary(name) or not ordinary(kind)',
    'not ordinary(texture) or not ordinary(requiredLevel)',
    'or not ordinary(rank)',
    'or not ordinary(copper) or not ordinary(slot)',
    'scalar(api("IsTradeskillTrainer")) ~= false',
    'read(root, "IsProtected") ~= false',
    'read(root, "IsShown") ~= true',
    'function Trial.QuoteAll(expectedCount, expectedTrainer)',
    'for index = 1, source.count do',
    'if total + row.copper > 100000000000 then',
    'affordable=source.money >= total',
    'function Trial.AttemptAll(quoted, snapshot)',
    'local fresh, why = Trial.QuoteAll(snapshot.total, snapshot.trainerName)',
    'not bulkSame(fresh.offers[i], quoted.offers[i])',
    'for _, row in ipairs(fresh.offers) do',
    'local now = bulkRow(row.index, source.info, source.cost)',
    'local ok = pcall(source.buy, row.index)',
    'bulkLast = "bulk-partial-" .. reason',
    'bulkLast = "bulk-requests-sent-unconfirmed"',
    'function Trial.GetBulkAudit()',
): need(token in t, 'missing bulk guard: '+token)
need(t.count('pcall(source.buy, row.index)') == 1, 'bulk source calls must occur at one location only')
need(t.count('pcall(buy, row.serviceIndex)') == 1, 'existing single-skill request must be unchanged')
for token in (
    'trainAll={label="Train All unavailable", enabled=false}',
    'Logres.NPCTrainerPurchaseTrial.QuoteAll(report.total, report.trainerName)',
    'model.bulkQuote = quote',
    'model.trainAll.enabled = quote.affordable',
    'model.trainAll.label = "Train all ("',
    'local bulkHit = CreateFrame("Frame", nil, root)',
    'bulkHit:SetPoint("TOPLEFT", root, "TOPLEFT", geometry.trainAll.x',
    'or not browse.model.trainAll.enabled or not browse.model.bulkQuote',
    'Logres.NPCTrainerPurchaseTrial.AttemptAll(',
    'Trial.Disable("bulk-training-requested-unconfirmed")',
    'bulkTrial=Logres.NPCTrainerPurchaseTrial.GetBulkAudit()',
    'Trial.Disable("goodbye")',
    'browse.searchQuery', 'browse.scrollSlider:SetValue(browse.offset)',
): need(token in v, 'lost bulk/live legacy contract: '+token)
for forbidden in ('BuyTrainerService(', 'SelectTrainerService(',
                  'SetTrainerServiceTypeFilter(', 'SetScript("OnUpdate"',
                  'C_Timer.After(', 'hooksecurefunc(', 'HideUIPanel('):
    need(forbidden not in v and forbidden not in l, 'renderer/live may not own native APIs: '+forbidden)
need('return Landscape.Render(owner, Landscape.Fixture())' in l,
     'synthetic preview must remain inert')
need('P0300' in p and 'goodbye' in p.lower(), 'historical Goodbye contract missing')
for term in ('P0300','P0301','Goodbye','Train All','Blizzard', 'UNVERIFIED',
             'partial', 'single', 'purchase', 'R1'):
    need(term.lower() in e.lower(), 'missing durable evidence: '+term)
c = read('docs/memory/CURRENT.md')
required = ('## Active Objective','## Current Work Item','## Verified State',
    '## Next Action','## Success Criteria','## Do Not Reopen Without New Evidence',
    '## Relevant References')
need(len(c.encode()) < 10000 and all(c.splitlines().count(x) == 1 for x in required),
     'CURRENT heading/size policy violated')
a = re.search(r'(?m)^## Version: (\S+)$', read('Logres/Logres.toc'))
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1) == b.group(1)), 'TOC/bootstrap versions mismatch')
print('P0301 user-initiated full-native-snapshot class-trainer Train All contract')
for error in errors: print('ERROR:',error)
if errors: raise SystemExit(1)
print('PASS: guarded full quote, no retries, partial-stop, stock fallback, prior features preserved')
