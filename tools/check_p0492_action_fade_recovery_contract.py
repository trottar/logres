#!/usr/bin/env python3
"""P0492 one-shot combat-exit fade recovery and owned incident evidence."""
from pathlib import Path
import re, subprocess, shutil
R=Path(__file__).resolve().parents[1]
c=(R/'Logres/Actions/Context.lua').read_text()
p=(R/'Logres/Dev/Panel.lua').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
assert 'function Context:ReconcileAfterCombat()' in c
assert 'function Context:ReconcileOwnedHover()' in c
assert 'self.disableEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")' in c
assert 'self:ReconcileAfterCombat()' in c
assert 'self:ReconcileOwnedHover()' in c
assert 'self:ApplyPolicy(policy)' in c
assert 'self.postCombatReconciles = self.postCombatReconciles + 1' in c
assert 'self.postCombatLastResult = self.secureDriverReady and "rest-applied"' in c
assert 'if not classified or secret ~= false then return nil end' in c
assert 'function Context:GetDebugStatus()' in c
assert 'ReadOwnedAlpha(primary and primary.cluster)' in c
assert 'ReadOwnedAlpha(pet and pet.cluster)' in c
assert 'incident.snapshot.actionContext = pickTraceStatus(ownedTraceStatus(function()' in p
for field in ('postCombatReconciles','postCombatHoverRepairs','postCombatHoverUnknown',
              'postCombatLastResult','ownedPrimaryActualAlpha','ownedPetActualAlpha',
              'secureDriverReady','hoveredPrimary'):
    assert field in p and field in c,field
assert 'GetAlpha(' not in p[p.index('incident.snapshot.actionContext ='):p.index('incident.snapshot.activeQuest =')]
for forbidden in ('C_Timer.', 'OnUpdate', 'GetMouseFocus(', 'GetMouseFoci(',
                  'GetCursorPosition(', 'TargetNearestEnemy(', 'ClearTarget(',
                  'SetBinding(', 'SaveBindings(', 'PetActionBar:Hide('):
    assert forbidden not in c,forbidden
assert 'if newstate == "combat" then' in c
assert ':SetAlpha(0) end' not in c
assert 'primary = 0.00' in c and 'secondary = 0.85' in c
assert re.search(r'Logres.VERSION = "(.*?)"',b).group(1)==re.search(r'## Version: (\S+)',t).group(1)
assert 'P0492' in (R/'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert (R/'docs/memory/evidence/P0492_ACTION_FADE_POSTCOMBAT.md').is_file()
assert 'P0492_ACTION_FADE_POSTCOMBAT.md' in (R/'docs/memory/patches/PATCH_INDEX.md').read_text()
engine=shutil.which('texlua') or shutil.which('lua')
if engine: subprocess.run([engine,str(R/'tools/test_p0492_postcombat_reconcile.lua')],cwd=R,check=True)
else: print('P0492 actual-source Lua DEFERRED; interpreter unavailable')
print('P0492 recovery/owned incident contract: PASS')
