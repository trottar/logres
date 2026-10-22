#!/usr/bin/env python3
"""P0305: native trainer readiness events repair missed lazy first presentation."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
s=read('Logres/UI/NPCServiceSession.lua')
v=read('Logres/Quest/TrainerLiveTrial.lua')
p=read('tools/check_p0304_npc_session_auto_trainer_contract.py')
e=read('docs/memory/evidence/P0305_TRAINER_READY_EVENT_REPAIR.md')
toc=read('Logres/Logres.toc')
cur=read('docs/memory/CURRENT.md')
issues=[]
def require(ok,why):
    if not ok:issues.append(why)
for x in (
 'Logres:RegisterEvent("TRAINER_SHOW", function()',
 'Session.Reconcile("trainer-show")',
 'Logres:RegisterEvent("TRAINER_UPDATE", function()',
 'Session.Reconcile("trainer-update")',
 'readySignals = readySignals + 1',
 'lastReady = "TRAINER_SHOW"',
 'lastReady = "TRAINER_UPDATE"',
 'readinessSignals=readySignals',
 'lastReadinessEvent=lastReady',
 'Logres:SubscribeState(function()',
 'pcall(hook, root, "OnShow", function()',
 'function Session.Dismiss(key)',
 'if not spec or not spec.automatic or dismissed[key] or not matches(spec)',
 'if not root or read(root, "IsShown") ~= true then',
 'Session.Register("trainer", {',
 'interactionType=7, nativeFrame="ClassTrainerFrame"',
 'nativePresentation="unchanged-stock-visible"',
):require(x in s,'session readiness/source gate lost: '+x)
require(s.count('Logres:RegisterEvent("TRAINER_SHOW"')==1,'duplicate show subscription')
require(s.count('Logres:RegisterEvent("TRAINER_UPDATE"')==1,'duplicate update subscription')
for bad in ('SetAlpha(', 'SetPoint(', 'SetParent(', 'HideUIPanel(',
            'ClearAllPoints(', 'SetScript("OnUpdate"', 'SetScript("OnShow"',
            'C_Timer.', 'BuyTrainerService(', 'hooksecurefunc(', 'DynamicCam'):
    require(bad not in s,'forbidden shared-session mutation/poll: '+bad)
for x in ('Logres.NPCServiceSession.Dismiss("trainer")',
          'Logres.NPCTrainerPurchaseTrial.Attempt(',
          'Logres.NPCTrainerPurchaseTrial.AttemptAll('):
    require(x in v,'trainer existing capability changed: '+x)
require('P0304' in p and 'Session.Register' in p,'historical session checker altered')
require('Core\\Lifecycle.lua\nUI\\NPCServiceSession.lua' in toc,'historical TOC adjacency')
for x in ('P0304', 'P0305', 'FAIL', 'PASS', 'UNVERIFIED', 'TRAINER_SHOW',
          'TRAINER_UPDATE', 'Blizzard', 'stock', 'manual'):
    require(x.lower() in e.lower(),'negative evidence omits '+x)
headings=('## Active Objective','## Current Work Item','## Verified State',
          '## Next Action','## Success Criteria','## Do Not Reopen Without New Evidence',
          '## Relevant References')
require(len(cur.encode())<10000 and all(cur.splitlines().count(x)==1 for x in headings),
        'CURRENT heading/size policy')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
require(bool(a and b and a.group(1)==b.group(1)), 'TOC/bootstrap version mismatch')
print('P0305 Forever trainer-ready event repair contract')
for issue in issues:print('ERROR:',issue)
if issues:raise SystemExit(1)
print('PASS: event-scoped readiness, stock retained, per-visit dismissal and manual actions preserved')
