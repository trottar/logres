#!/usr/bin/env python3
"""P0174 R2: native quest/cast OnShow source-gated re-fold contract."""
from pathlib import Path
import sys
root = Path(__file__).resolve().parents[1]
s = (root/'Logres/Immersion/NativeAccess.lua').read_text(encoding='utf-8')
c = (root/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
for token in (
    'function NativeAccess:InstallRefoldHooks()',
    'frame:HookScript("OnShow", function()',
    'self.restoring[hookKey]',
    'self.manualOpen[hookKey]',
    'self.snapshots[hookKey]',
    'if InCombatLockdown() then',
    'self.pendingRefolds[hookKey] = true',
    'pcall(hookFrame.Hide, hookFrame)',
    'self.pendingRefolds[hookKey] = nil',
    'self.restoring[key] = true',
    'self.restoring[key] = nil',
    'self:InstallRefoldHooks()',
    'pendingRefolds = pendingRefolds',
    'combatShowDeferrals = self.combatShowDeferrals',
    '"PlayerCastingBarFrame"',
    '"OverlayPlayerCastingBarFrame"',
    '"TargetFrameSpellBar"',
    '"ObjectiveTrackerFrame"',
):
    if token not in s: errors.append(f'missing hook safeguard: {token}')
for token in ('result.pendingRefolds == 0','nativeShows=%s/%s combatDeferred=%s pending=%s'):
    if token not in c: errors.append(f'missing truthful diagnostics: {token}')
for forbidden in ('SetParent(', 'hooksecurefunc(', 'SetAlpha(0)', 'C_Timer.', 'OnUpdate', 'RegisterStateDriver('):
    if forbidden in s: errors.append(f'forbidden native mitigation: {forbidden}')
print('P0174 R2 native source re-show contract')
for e in errors: print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAIL: {len(errors)} errors')
sys.exit(bool(errors))
