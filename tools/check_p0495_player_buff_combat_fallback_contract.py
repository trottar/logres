#!/usr/bin/env python3
"""P0495: prearmed secure native BUFFS combat fallback, fail open."""
from pathlib import Path
import subprocess, shutil, re
R=Path(__file__).resolve().parents[1]
B=(R/'Logres/HUD/PlayerHelpfulAuras.lua').read_text()
N=(R/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
H=(R/'Logres/HUD/PlayerHelpfulAuras.lua').read_text()
P=(R/'Logres/Dev/Panel.lua').read_text()
T=(R/'Logres/Logres.toc').read_text()
assert 'Immersion\\NativeSurfaceReplacement.lua' in T and 'Immersion\\NativePlayerBuffCombatFallback.lua' not in T
for token in ('"SecureHandlerStateTemplate"','driver:SetFrameRef("stockBuffs", stock)',
              'driver:SetAttribute("_onstate-" .. STATE, SNIPPET)',
              'RegisterStateDriver(driver, STATE, "[combat] combat; rest")',
              'pcall(UnregisterStateDriver, self.driver, STATE)',
              'if newstate == "combat" then', 'buffs:Show()',
              'elseif newstate == "rest" then', 'buffs:Hide()',
              'if InCombatLockdown()', 'self.armed = true', 'self.armed = false'):
    assert token in B, token
for token in ('if key == "playerBuffs" then',
              'local fallback = Logres.NativePlayerBuffCombatFallback',
              'if not fallback or not fallback:Arm(frame) then',
              'pcall(frame.SetShown, frame, shown)',
              'if not fallback or not fallback:Disarm() then',
              'self:Restore(key)', 'self:Fold(key)'):
    assert token in N, token
assert N.index('fallback:Arm(frame)') < N.index('pcall(frame.Hide, frame)'), 'arm before native hide'
assert N.index('fallback:Disarm()') < N.index('pcall(snapshot.frame.SetShown, snapshot.frame, snapshot.shown)'), 'disarm before restore'
assert 'RegisterStateDriver(' not in N and 'GetAuraDataByIndex' not in N
assert 'C_Secrets.ShouldUnitAuraIndexBeSecret' in H and 'lastCoverageReady' in H
assert '"buffCombatFallback"' not in P and 'incident.snapshot.buffCombatFallback = ' in P
assert 'P0495' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert 'P0495' in (R/'docs/memory/PRE_HANDOFF_AUDIT.md').read_text()
engine=shutil.which('texlua') or shutil.which('lua')
if engine: subprocess.run([engine,str(R/'tools/test_p0488_player_buff_recovery.lua')],cwd=R,check=True)
else: print('P0495 actual-source fixture DEFERRED')
print('P0495 protected native BUFFS combat fallback contract: PASS')
