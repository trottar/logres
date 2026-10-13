#!/usr/bin/env python3
"""P0206 R4: enforce native-frame quarantine without freezing runtime version."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
P = (ROOT / "Logres/Immersion/PetCombatCandidate.lua").read_text()
N = (ROOT / "Logres/Immersion/NativeSurfaceReplacement.lua").read_text()
C = (ROOT / "Logres/Core/Commands.lua").read_text()
D = (ROOT / "Logres/Dev/Panel.lua").read_text()
B = (ROOT / "Logres/Core/Bootstrap.lua").read_text()
T = (ROOT / "Logres/Logres.toc").read_text()
errors = []
for name,frag in {
 "explicit blocked trial": 'self.lastReason = "BLOCKED-p0206-r2-protected-and-restore-failure"',
 "opt-in refusal": 'return false, self.lastReason',
 "read-only status": 'function Candidate:GetDebugStatus()',
 "read-only false state": 'armed = false',
 "no auto arm": 'self.lastReason = "quarantined-default-off"',
}.items():
    if frag not in P:errors.append(name)
for bad in ('SetParent', 'GetParent', 'RegisterStateDriver', 'UnregisterStateDriver',
            'SetShown', ':Show(', ':Hide(', 'HookScript', 'OnUpdate',
            'IsShown(', 'GetAlpha(', 'GetPoint(', 'C_Timer', 'InCombatLockdown'):
    if bad in P:errors.append('quarantined module has forbidden frame action: '+bad)
for bad in ('petCombatCandidate()', 'candidate:Disarm(', 'candidate:Reconcile('):
    if bad in N:errors.append('old unsafe native hook remains: '+bad)
for name,frag in {
 'quarantine diagnostics':'Logres petcombat: QUARANTINED',
 'ON retained in Phase H':'"Pet Combat Trial ON (BLOCKED)"',
 'OFF retained in Phase H':'"Pet Combat Trial OFF"',
 'check retained in Phase H':'"Pet Combat Trial Check"',
 'command retained':'command == "petcombat"',
 'rejections reported':'tostring(trial.rejections)',
}.items():
    if frag not in C:errors.append(name)
for frag in ('MAX_ACTIONS_PER_PHASE = BUTTON_COLUMNS * 6', 'buttonHost:SetHeight(180)',
 'resultsBackground:SetPoint("TOPLEFT", frame, "TOPLEFT", 18, -320)'):
    if frag not in D:errors.append('phase H grid capacity '+frag)
b = re.search(r'Logres.VERSION\s*=\s*"([^"]+)"', B)
t = re.search(r'^## Version:\s*(.+)$', T, re.M)
if not b or not t or b.group(1) != t.group(1).strip():
    errors.append('runtime version mismatch')
if 'Immersion\\PetCombatCandidate.lua' not in T:errors.append('TOC module absent')

# P0206 R6: quarantine must cover the older native fold path as well.
# Do not inspect protected stock visibility or assume trial-only quarantine
# prevents NativeSurfaceReplacement from hiding Blizzard's PetActionBar.
ready = N.split('function Native:Ready(key)', 1)
if len(ready) != 2 or 'function Native:RefreshNativeAuras()' not in ready[1]:
    errors.append('native readiness boundary absent')
else:
    gate = ready[1].split('function Native:RefreshNativeAuras()', 1)[0]
    if 'if key == "petActions" then return false end' not in gate:
        errors.append('Blizzard pet action safety gate missing')
    if gate.find('if key == "petActions" then return false end') > gate.find('if key == "petFrame" then'):
        errors.append('native pet action fail-open guard must precede readiness checks')


# P0208: R6 stock-only pet-actions gate is not enough. Native PetFrame
# must also be excluded from folding before any legacy readiness branch.
ready = N.split('function Native:Ready(key)', 1)
if len(ready) != 2 or 'function Native:RefreshNativeAuras()' not in ready[1]:
    errors.append('P0208 native readiness boundary missing')
else:
    gate = ready[1].split('function Native:RefreshNativeAuras()', 1)[0]
    if 'if key == "petFrame" then return false end' not in gate:
        errors.append('P0208 stock PetFrame fail-open guard missing')
    if gate.find('if key == "petFrame" then return false end') > gate.find('if key == "petFrame" then\n'):
        errors.append('P0208 stock pet unit fail-open guard must precede legacy fold readiness')
if 'button:SetText("PET STOCK")' not in N:
    errors.append('P0208 native PET dock stock label missing')
if 'petPolicy=stock/stock' not in N or 'petVisual=UNVERIFIED' not in N:
    errors.append('P0208 native pet source-policy/unverified diagnostics missing')

if errors:
    print('P0206 R4 QUARANTINE CONTRACT FAIL: '+'; '.join(errors))
    raise SystemExit(1)
print('P0206 R4 quarantine and panel contract PASS')
