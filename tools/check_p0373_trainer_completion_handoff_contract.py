#!/usr/bin/env python3
"""P0373 explicit trainer-click fail-open / quest completion trace contract."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]

def need(cond,msg):
    if not cond:raise AssertionError('P0373: '+msg)

def source(p):return (R/p).read_text(encoding='utf-8')

live=source('Logres/Quest/TrainerLiveTrial.lua')
profession=source('Logres/Quest/TrainerProfessionPurchaseTrial.lua')
dialogue=source('Logres/Quest/Dialogue.lua')
claim=source('Logres/Quest/CompletionControl.lua')
panel=source('Logres/Dev/Panel.lua')
for t in ('train-not-ready','train-click','train-requested','train-deferred',
          'train-fallback','serviceIndex = chosen.serviceIndex','native-purchase-deferred','stock-restored',
          'stock-restore-pending','Trial.Disable("native-purchase-deferred")'):
    need(t in live,'trainer fail-open or click trace absent '+t)
need('browse.localChoiceConfirmed or browse.defaultServiceIndex == browse.selectedServiceIndex' in live
     and 'if availableCount ~= 1 then selected = nil end' in live,
     'historical P0296 physical selection/purchase gate removed')
need('if not browse.model.trainEnabled then' in live,
     'P0296 guard no longer belongs to the executable train readiness branch')
need('Logres.NPCTrainerProfessionPurchaseTrial.Attempt' in live,
     'dedicated profession guard bypassed')
for t in ('profession-deferred','profession-call-failed','profession-requested',
          'pcall(buy, row.serviceIndex)', 'scalar(api("InCombatLockdown")) ~= false',
          'or read(root, "IsShown") ~= true', 'ordinary(copper)',
          'money < copper'):
    need(t in profession,'native purchase verification removed '+t)
for t in ('completion-observed','completion-unavailable','completion-presentation',
          'completion-owned','completion-stock-fallback',
          'self.completionControl:Activate()'):
    need(t in dialogue,'quest-completion decision trace absent '+t)
for t in ('completion-click-deferred','completion-click-result',
          'self:Restore("claim-invoked")', '_G.QuestRewardCompleteButton_OnClick',
          'self:Gate()', 'not numeric(GetNumQuestChoices, 0)',
          'not numeric(GetQuestMoneyToGet, 0)'):
    need(t in claim,'quest completion native safety gate removed '+t)
for t in ('incident.snapshot.trainer','incident.snapshot.professionPurchase',
          'incident.snapshot.questCompletion','incident.snapshot.completionView',
          'serviceIndex = true',
          'self:GetModule("QuestDialogue"):GetDebugStatus()'):
    need(t in panel,'addon-owned incident snapshot absent '+t)
need('local JOURNAL_EVENTS = 384' in panel and 'local JOURNAL_INCIDENTS = 12' in panel,
     'journal bounds lost')
need('Logres:TraceEvent("trainer"' in live,
     'trainer decision events not using centralized sanitizer')
need('Logres:TraceEvent("quest"' in dialogue,
     'completion decision events not using centralized sanitizer')
boot=source('Logres/Core/Bootstrap.lua')
toc=source('Logres/Logres.toc')
m1=re.search(r'Logres\.VERSION\s*=\s*"([^"]+)"',boot)
m2=re.search(r'## Version:\s*(\S+)',toc)
need(m1 is not None and m2 is not None and m1.group(1)==m2.group(1)
     and re.fullmatch(r'0\.0\.\d+-dev',m1.group(1)),
     'dynamic version format/TOC parity failure')
cur=source('docs/memory/CURRENT.md');hand=source('docs/memory/handoffs/CURRENT_HANDOFF.md')
for token in ('P0373','P0372','P0362','P0363','P0367','P0368','P0370',
              'L-001','L-002','L-005','L-019','L-021','L-033','D-048'):
    need(token in cur and token in hand,'canonical history continuity '+token)
need(len(cur.encode())<9800 and len(hand.encode())<8000,
     'canonical memory byte bound')
for p in ('docs/memory/evidence/P0373_TRAINER_COMPLETION_HANDOFF.md',
          'docs/memory/patches/P0373_TRAINER_COMPLETION_HANDOFF.md'):
    txt=source(p)
    need('UNVERIFIED' in txt and 'TRAINER' in txt.upper()
         and 'QUEST' in txt.upper(),p+' lacks scope/deferral labels')
print('P0373 trainer/quest completion fail-open and journal: PASS (STATIC ONLY, WoW UNVERIFIED)')
