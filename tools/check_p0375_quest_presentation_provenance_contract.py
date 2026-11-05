#!/usr/bin/env python3
"""P0375 event-driven Logres-owned quest UI provenance, not native suppression."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]

def src(path):
    return (R/path).read_text(encoding='utf-8')

def need(ok, msg):
    if not ok:
        raise AssertionError('P0375: '+msg)

d=src('Logres/Quest/Dialogue.lua')
p=src('Logres/Dev/Panel.lua')
c=src('Logres/Quest/CompletionControl.lua')
ledger=src('docs/memory/investigations/ISSUE_LEDGER.md')
cur=src('docs/memory/CURRENT.md')
hand=src('docs/memory/handoffs/CURRENT_HANDOFF.md')
boot=src('Logres/Core/Bootstrap.lua')
toc=src('Logres/Logres.toc')

for token in (
    'root:HookScript("OnShow"', 'root:HookScript("OnHide"',
    'self.rootShowCount = self.rootShowCount + 1',
    'self.rootHideCount = self.rootHideCount + 1',
    '"root-onshow"', '"root-onhide"',
    '"presentation-presented"', '"presentation-dismissed"',
    'rootShown = self.root ~= nil and self.root:IsShown() or false',
    'turninEventCount = self.turninEventCount',
    'questTurnedInRegistered =',
    '"QUEST_TURNED_IN",',
    'if event == "QUEST_TURNED_IN" then',
    'local ok, secret = pcall(issecretvalue, questID)',
    'valid = ok and secret == false',
    'if valid and type(questID) == "number" and questID > 0 then',
    '"turnin-event"',
):
    need(token in d, 'missing owned provenance or guarded event: '+token)
need(d.index('valid = ok and secret == false') < d.index('if valid and type(questID)'),
     'secret-capable turn-in ID examined before validation')
need('root:HookScript("OnShow"' in d and 'QuestFrame:HookScript' not in d,
     'native frame hooked for presentation inspection')
for token in (
    'incident.snapshot.questPresentation',
    '"rootShown", "presentationShown", "lastPresentationReason"',
    '"turninEventCount", "lastTurninQuestID"',
    'incident.snapshot.questCompletion',
    'local JOURNAL_EVENTS = 384', 'local JOURNAL_INCIDENTS = 12',
):
    need(token in p, 'missing existing/added bounded snapshot field: '+token)
for token in ('self:Restore("claim-invoked")',
              'pcall(_G.QuestRewardCompleteButton_OnClick)',
              'not numeric(GetNumQuestChoices, 0)',
              'not numeric(GetQuestMoneyToGet, 0)'):
    need(token in c, 'old completion safety invariant lost: '+token)
for identifier, status in [('L-002','OPEN'),('L-005','PARTIAL'),('L-034','OPEN'),('L-033','OPEN')]:
    lines=[l for l in ledger.splitlines() if l.startswith('| '+identifier+' |')]
    need(len(lines)==1 and ('| '+status+' |') in lines[0],
         'ledger issue not present or silently closed: '+identifier)
    if identifier in ('L-002','L-005','L-034'):
        need('P0375' in lines[0], 'issue lacks updated P0375 disposition: '+identifier)
need('incident **764**' in ledger and 'screenshot' in ledger,
     'L-034 unresolved visual owner context erased')
for token in ('P0371','P0372','P0373','P0374','P0375','L-002','L-005','L-034'):
    need(token in cur, 'current history missing '+token)
need('ISSUE_LEDGER.md' in cur and 'ISSUE_LEDGER.md' in hand,
     'mandatory issue-first routing absent')
need(len(cur.encode('utf-8'))<9800 and len(hand.encode('utf-8'))<8000,
     'canonical memory size regression')
need('P0375' in src('docs/memory/evidence/P0375_QUEST_PRESENTATION_PROVENANCE.md')
     and 'UNVERIFIED' in src('docs/memory/evidence/P0375_QUEST_PRESENTATION_PROVENANCE.md'),
     'runtime uncertainty not recorded')
need('P0375' in src('docs/memory/patches/P0375_QUEST_PRESENTATION_PROVENANCE.md'),
     'missing patch record')
m1=re.search(r'Logres\.VERSION\s*=\s*"([^"]+)"',boot)
m2=re.search(r'## Version:\s*(\S+)',toc)
need(m1 and m2 and m1.group(1)==m2.group(1) and
     re.fullmatch(r'0\.0\.\d+-dev',m1.group(1)),
     'dynamic current-version parity missing')
print('P0375 quest-root and turn-in provenance: PASS (STATIC ONLY, CLIENT UNVERIFIED)')
