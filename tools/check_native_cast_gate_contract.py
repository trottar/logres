#!/usr/bin/env python3
"""P0174 R3 source-backed native cast visibility gate and fallback contract."""
from pathlib import Path
import re
import sys
root=Path(__file__).resolve().parents[1]
s=(root/'Logres/Immersion/NativeAccess.lua').read_text(encoding='utf-8')
c=(root/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
for token in (
    'local function setNativeCastGate(snapshot, suppress)',
    'item.frame:SetAndUpdateShowCastbar(false)',
    'item.frame:SetAndUpdateShowCastbar(item.castShowToken)',
    'item.castShowToken = frame.showCastbar',
    'if key == "casts" and type(frame.SetAndUpdateShowCastbar) ~= "function" then',
    'if InCombatLockdown() then',
    'setNativeCastGate(snapshot, true)',
    'setNativeCastGate(snapshot, false)',
    'self.castGateArmed = true',
    'self.castGateArmed = false',
    'self.castGateEscapes = self.castGateEscapes + 1',
    'castGateExpected = self.desired and not self.manualOpen.casts',
    'castGateEscapes = self.castGateEscapes',
    'self.pendingRefolds[hookKey] = true',
    'self.restoring[hookKey]',
    'self.manualOpen[hookKey]',
):
    if token not in s: errors.append('missing native gate token: '+token)
for token in ('result.castGateArmed == result.castGateExpected',
              'result.castGateEscapes == 0', 'castGate=%s/%s',
              'gateEscapes=%s'):
    if token not in c: errors.append('missing truthful diagnostic: '+token)
for bad in ('SetParent(', 'SetAlpha(0)', 'SetCVar(', 'RegisterStateDriver(',
            'C_Timer.', 'OnUpdate', 'GetAttribute("state-visibility")',
            'if item.castShowToken', 'if frame.showCastbar',
            'tostring(item.castShowToken)', 'type(item.castShowToken)'):
    if bad in s: errors.append('forbidden mechanism/secret inspection: '+bad)
# Gate mutation may not move into the source hook's in-combat branch.
start=s.find('frame:HookScript("OnShow", function()')
stop=s.find('                    end)', start)
if start < 0 or stop < 0: errors.append('source-specific OnShow hook absent')
else:
    hook=s[start:stop]
    if 'setNativeCastGate(' in hook or 'SetAndUpdateShowCastbar(' in hook:
        errors.append('native show hook must never mutate cast gate')
print('P0174 R3 native cast gate contract')
for e in errors: print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAIL: {len(errors)} errors')
sys.exit(bool(errors))
