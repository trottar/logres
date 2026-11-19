#!/usr/bin/env python3
"""P0491 combat-safe contextual alpha and all-rest-zero feature contract."""
from pathlib import Path
import re, shutil, subprocess
R=Path(__file__).resolve().parents[1]
c=(R/'Logres/Actions/Context.lua').read_text()
p=(R/'Logres/HUD/PetActionExecutionProbe.lua').read_text()
a=(R/'Logres/Core/Commands.lua').read_text()
b=(R/'Logres/Core/Bootstrap.lua').read_text()
t=(R/'Logres/Logres.toc').read_text()
assert c.count('primary = 0.00,')==3 and c.count('primary = 1.00,')==1
assert c.count('secondary = 0.00,')==3 and c.count('utility = 0.00,')==3
assert c.count('secondary = 0.85,\n        utility = 0.75,')==1
assert 'bar4 = 1.00,' in c and 'bar4 = 1.00,' in a
assert a.count('primary = 0.00,')==3 and a.count('primary = 1.00,')==1
assert 'function Context:InstallCombatDriver()' in c
assert '"SecureHandlerStateTemplate"' in c
assert 'RegisterStateDriver(driver, "logrescombat", "[combat] combat; rest")' in c
assert 'driver:SetAttribute("_onstate-logrescombat", COMBAT_ALPHA_SNIPPET)' in c
for name in ('primary','secondary','utility','bar4','bar5','pet'):
    assert 'self:GetFrameRef("'+name+'")' in c
for name in ('primary','bar4'):
    assert 'if '+name+' then '+name+':SetAlpha(1) end' in c
for name in ('secondary','pet'):
    assert 'if '+name+' then '+name+':SetAlpha(0.85) end' in c
for name in ('utility','bar5'):
    assert 'if '+name+' then '+name+':SetAlpha(0.75) end' in c
assert ':SetAlpha(0) end' not in c, 'rest alpha remains OOC hover-owned'
assert 'if newstate == "combat" then' in c
assert 'if not locked then' in c
assert 'self.protectedRootSkips = self.protectedRootSkips + 1' in c
assert 'pet:ApplyContextOpacity(petAlpha, locked == true)' in c
assert 'function Probe:ApplyContextOpacity(alpha, feedbackOnly)' in p
assert 'self.cluster and feedbackOnly ~= true' in p
assert 'self:FinishPendingDisable()' in c
assert 'self.disableEventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")' in c
assert 'UnregisterStateDriver(self.combatDriver, "logrescombat")' in c
for name in ('secureDriverReady','protectedRootSkips','pendingDisableReconcile'):
    assert name in c
for forbidden in ('C_Timer.', 'OnUpdate', 'TargetNearestEnemy(', 'ClearTarget(',
                  'SetBinding(', 'SaveBindings(', 'button:SetAttribute(',
                  'GetMouseFoci(', 'GetCursorPosition(', 'PetActionBar:Hide('):
    assert forbidden not in c and forbidden not in p,forbidden
assert re.search(r'Logres.VERSION = "(.*?)"',b).group(1)==re.search(r'## Version: (\S+)',t).group(1)
assert 'P0491' in (R/'docs/memory/CURRENT.md').read_text()
assert 'L-055' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert 'P0491_SECURE_ACTION_COMBAT_REVEAL.md' in (R/'docs/memory/patches/PATCH_INDEX.md').read_text()
assert 'Interactive quest-use items' in (R/'docs/memory/roadmap/POST_P0474_WORKSTREAMS.md').read_text()
engine=shutil.which('texlua') or shutil.which('lua')
if engine:
    subprocess.run([engine,str(R/'tools/test_p0491_secure_combat_alpha.lua')],cwd=R,check=True)
else:
    print('P0491 actual-source Lua fixture DEFERRED in this environment')
print('P0491 secure combat alpha / all-rest-zero contract: PASS')
