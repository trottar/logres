#!/usr/bin/env python3
"""Screen-target decorations opt out; neutral world appearance uses safe facts."""
from pathlib import Path
import os,shutil,subprocess
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
P=read('Logres/HUD/WorldTargetProbe.lua');H=read('Logres/HUD/HUD.lua')
N=read('Logres/HUD/NativeDebuffs.lua');S=read('Logres/HUD/StatusAuras.lua')
gate=P.split('elseif reaction.category == "neutral" then',1)[1].split('\n    else',1)[0]
for s in ('readBoolean(UnitIsFriend, "player", unit)','friend.secret','friend.value ~= false','reaction-neutral-attackable-nonfriend'):
 assert s in gate,s
assert 'UnitAffectingCombat' not in gate
assert P.index('readBoolean(UnitCanAttack, "player", unit)',P.index('function Probe:AcquireLiveEnemyTargetAnchor')) < P.index('reaction-neutral-attackable-nonfriend')
for s in ('self.targetPvPBadge:Hide()', 'screenSpaceEnemyFrameEnabled == true',
          'self.worldEnemyLiveVisible ~= true', 'owner.interactionMouseOwnedByLogres == true'):
 assert s in H,s
activation=N.split('function Native.SetActive(',1)[1].split('-- P0450:',1)[0]
for s in ('state.targetEnabled == targetEnabled','if unit == "target" then visible = targetEnabled end',
          'state.targetEnabled = targetEnabled','return false, "combat-deferred"'):
 assert s in activation,s
assert activation.index('InCombatLockdown()') < activation.index('frame:SetEnabled(visible)')
assert 'local active = active and preferences.screenSpaceEnemyFrameEnabled == true' in S
assert 'nativeScreenTargetEnabled' in S and 'nativeScreenTargetEnabled' in read('Logres/Dev/Panel.lua')
assert 'local targetShouldShow = shouldShow and preferences.screenSpaceEnemyFrameEnabled == true' in read('Logres/Core/Commands.lua')
assert '"Auras",' in read('Logres/Immersion/TargetFrameReplacement.lua')
for p in ('docs/memory/evidence/P0470_TARGET_POLICY_REPAIR.md','docs/memory/PRE_HANDOFF_AUDIT.md'):
 assert 'P0470' in read(p) and 'UNVERIFIED' in read(p)
ledger=read('docs/memory/investigations/ISSUE_LEDGER.md')
assert '| L-049 | World enemy display requires manual ON; screen enemy preference unused | OPEN |' in ledger
assert 'neutral-not-engaged' in ledger
lua=os.environ.get('LOGRES_LUA') or shutil.which('lua5.4')
if lua:
 for p in ('test_p0470_target_policy.lua','test_p0468_compatible_aura_grid.lua','test_p0460_selected_removal_source.lua'):
  subprocess.run([lua,str(R/'tools'/p),str(R)],check=True,cwd=R)
else:print('P0470 source fixture UNVERIFIED: Lua5.4 unavailable')
print('P0470 target policy STATIC PASS; WoW UNVERIFIED')
