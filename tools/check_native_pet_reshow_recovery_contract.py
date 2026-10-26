#!/usr/bin/env python3
"""P0197: event-triggered, bounded pet re-show recovery source contract."""
from pathlib import Path
root=Path(__file__).resolve().parents[1]
native=(root/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
commands=(root/'Logres/Core/Commands.lua').read_text()
need={
 'OnShow observation':'self.petActionShowEvents = self.petActionShowEvents + 1',
 'Combat deferral':'self.petActionDeferredRefold = true',
 'Combat deferred count':'self.petActionCombatDeferrals + 1',
 'Reconcile condition':'key == "petActions" and self.petActionDeferredRefold',
 'Event-driven retry':'local recovered = pcall(stock.Hide, stock)',
 'Recovery success':'self.petActionRecoveryRefolds + 1',
 'Fail open':'self:Restore(key)',
 'Diagnostic counters':'petActionCombatDeferrals = self.petActionCombatDeferrals',
}
errors=[k for k,v in need.items() if v not in native]
if 'Logres petbar-reshow: AUDIT' not in (root/'Logres/Core/UIOwnershipAudit.lua').read_text():errors.append('Phase H Native Access diagnostic')
if 'petActionDeferredRefold = false' not in native:errors.append('Recovery flag clear')
if 'frame:IsShown()' in native or 'frame:GetAlpha()' in native:errors.append('Forbidden stock visibility inspection')
if errors:
 print('P0197 source contract FAIL:', ', '.join(errors))
 raise SystemExit(1)
print('P0197 pet re-show recovery source contract PASS')
