#!/usr/bin/env python3
"""P0211: pet startup retries only on proven addon-owned readiness edges."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
p=(R/'Logres/HUD/PetActionExecutionProbe.lua').read_text()
n=(R/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
t=(R/'Logres/Immersion/PetBarVisibilityTrial.lua').read_text()
c=(R/'Logres/Core/Commands.lua').read_text()
e=[]
for name,content,needle in (
 ('probe ready handoff',p,'trial:Reconcile("pet-probe-armed")'),
 ('pet unit ready handoff',n,'trial:Reconcile("pet-unit-interaction-ready")'),
 ('startup signal accounting',t,'self.readinessWakeups = self.readinessWakeups + 1'),
 ('initial world own-state snapshot',t,'self.startupWorldArmed = self.armed and "yes" or "no"'),
 ('first armed reason',t,'self.firstArmEvent = self.lastEvent'),
 ('startup diagnostic exposed',c,'Logres petbardriver startup: worldArmed='),
):
 if needle not in content:e.append(name)
# Require the handoffs occur AFTER the corresponding secure readiness property.
if p.find('self.armed = true') < 0 or p.find('self.armed = true') > p.find('trial:Reconcile("pet-probe-armed")'):
 e.append('probe signal must follow armed state')
if n.find('self.petInteraction = button') < 0 or n.find('self.petInteraction = button') > n.find('trial:Reconcile("pet-unit-interaction-ready")'):
 e.append('unit signal must follow secure pet interaction')
for forbidden in ('SetScript("OnUpdate"','C_Timer.','PetFrame:IsShown(','PetActionBar:IsShown(',
                  'PetFrame:Hide(', 'PetActionBar:Hide('):
 if forbidden in t:e.append('forbidden startup bypass '+forbidden)
print('P0211 addon-owned secure pet startup contract')
for msg in e:print('ERROR:',msg)
if e:raise SystemExit(1)
print('PASS: 0 errors')
