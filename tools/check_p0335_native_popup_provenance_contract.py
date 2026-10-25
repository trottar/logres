#!/usr/bin/env python3
"""P0335: one-shot cached addon-owned native popup provenance, no Blizzard UI reads."""
from pathlib import Path
import re
import sys

# Pure fixtures also run outside a complete checkout via --selftest.
def classify(folded, popup_owner_known):
    if not popup_owner_known:
        return "owner-unconfirmed"
    if folded:
        return "owner-evidenced-folded"
    return "owner-evidenced-unfolded"

def selftest():
    assert classify(True,False)=="owner-unconfirmed"
    assert classify(False,False)=="owner-unconfirmed"
    assert classify(True,True)=="owner-evidenced-folded"
    assert classify(False,True)=="owner-evidenced-unfolded"
    print("P0335 pure classification fixtures: PASS 4/4 (no native values)")

if '--selftest' in sys.argv:
    selftest()
    raise SystemExit(0)

R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
C=read('Logres/Core/Commands.lua')
N=read('Logres/Immersion/NativeAccess.lua')
X=read('Logres/Quest/XP.lua')
O=read('Logres/Quest/Progress.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
I=read('docs/memory/investigations/ISSUE_REGISTER.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
CUR=read('docs/memory/CURRENT.md')
E=read('docs/memory/evidence/P0335_NATIVE_POPUP_PROVENANCE.md')
def need(ok,why):
    if not ok: raise AssertionError(why)
a=C.index('function Logres:RunGameplayCapture()')
b=C.index('local function printPreferences()',a)
capture=C[a:b]
for key in ('NativeAccess','QuestXP','QuestObjectiveProgress'):
    need(f'readCaptureStatus("{key}"' in capture,key+' cached status absent')
for text in ('native.domains','native.refoldAttempts','native.failures',
             'xp.pulseCount','xp.pulseShown','xp.lastPresentationReason',
             'objective.pulseCount','objective.pulseShown',
             'objective.lastPresentationReason'):
    need(text in capture,'missing correlation: '+text)
for bad in ('_G[', 'GetPoint(', 'GetNumPoints(', 'IsProtected(',
            'GetAuraDataByIndex(', 'UnitAura(', 'UnitHealth(', 'UnitXP(',
            'ShowUIPanel(', 'HideUIPanel(', 'SetPoint(', 'SetAlpha(',
            'SetFrameStrata(', 'RegisterEvent(', 'HookScript(',
            'SetScript(', 'OnUpdate', 'C_Timer.'):
    need(bad not in capture,'native state/mutation forbidden: '+bad)
need('function NativeAccess:GetDebugStatus()' in N and
     'domains = table.concat(details, " ")' in N and
     'nativeShows = self.nativeShows' in N,
     'native addon-owned provenance emitter missing')
need('objectives = { "ObjectiveTrackerFrame" }' in N and
     'progress = { "StatusTrackingBarManager" }' in N and
     'function NativeAccess:Restore(key, reason)' in N,
     'existing Blizzard stock fallback missing')
need('function XP:GetDebugStatus()' in X and 'pulseCount = self.pulseCount' in X and
     'function Progress:GetDebugStatus()' in O and 'pulseCount = self.pulseCount' in O,
     'existing additive pulse producers missing')
need('if command == "gameplaycapture" then' in C and
     'panel:BeginDiagnosticRun("gameplaycapture")' in C,
     'unchanged one-shot capture entry/recording absent')
need('MAX_DIAGNOSTIC_RUNS = 100' in read('Logres/Dev/Panel.lua') and
     'MAX_DIAGNOSTIC_LINES = 120' in read('Logres/Dev/Panel.lua'),
     'bounded diagnostic store changed')
need(len([line for line in T.splitlines() if line.endswith('.lua')])==94,
     'no new WoW module permitted')
need(re.search(r'^## Version: (\S+)$',T,re.M) is not None,
     'TOC version absent')
v=re.search(r'^## Version: (\S+)$',T,re.M)
u=re.search(r'^Logres.VERSION = "([^"]+)"$',B,re.M)
need(v and u and v.group(1)==u.group(1),'runtime version parity')
need('| L-027 |' in I and 'P0335' in I,'L-027 explicitly deferred')
for n in range(317,336):need(f'P{n:04d}' in CUR,'CURRENT continuity '+str(n))
for x in ('CURRENT.md','P0326','P0327','P0333','P0334','P0335'):
    need(x in H,'handoff continuity '+x)
need('OPEN' in E and 'UNVERIFIED' in E and
     'no' in E.lower() and 'fallback' in E.lower(),
     'negative evidence/runtime deferral missing')
need('RegisterDevPanelAction(' not in capture and
     'SetPreference(' not in capture,'new UI/setting forbidden')
selftest()
print('P0335 native popup correlation from addon-owned cached summaries: PASS (STATIC)')
