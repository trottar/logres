#!/usr/bin/env python3
"""P0463: reversible native aura layout, cached activation and tracker capability."""
from pathlib import Path
import os,shutil,subprocess
root=Path(__file__).resolve().parents[1]
read=lambda path:(root/path).read_text()
h=read('Logres/HUD/HUD.lua');n=read('Logres/HUD/NativeDebuffs.lua');a=read('Logres/Immersion/NativeAccess.lua')
layout=n.split('-- P0463: native AuraContainer',1)[1].split('local harmfulStyle =',1)[0]
for token in ('layoutRegionReady','region.IsProtected','region.IsForbidden','ordinary(count)',
 'pcall(region.GetPoint, region, index)','point[1], point[2], point[3], point[4], point[5]',
 'harmful:SetPoint("RIGHT", parent, "LEFT", -25, 0)',
 'helpful:SetPoint("LEFT", parent, "RIGHT", 25, 0)',
 'native-aura-layout-restore-pending'):
 assert token in layout,token
for forbidden in ('GetChildren','GetRegions','IsShown','GetAlpha','SetAlpha','SetParent','SetUnit','C_UnitAuras','C_Timer'):
 assert forbidden not in layout,forbidden
assert layout.index('claim[#claim + 1]')<layout.index('harmful:ClearAllPoints()')
for token in ('self.worldEnemyAuraLayoutClaim','slot.auraLayoutClaim','native.BindWorldAuraOwner',
 'function HUD:ReconcileObservedWorldEnemyPlates()', 'pairs(self.worldEnemyObservedNameplateEpochs or {})',
 'world-enemy-resume','combat-resume','cancelled-pending-off'):
 assert token in h,token
activation=h.split('function HUD:SetLiveWorldEnemy(enabled)',1)[1].split('function HUD:SetEnemyDisplayPreview',1)[0]
assert 'ordinaryOwnedUnprotected(self.worldEnemyLiveFrame)' in activation
assert '#self.worldEnemySecondaryPool == SECONDARY_POOL_CAPACITY' in activation
assert 'self.worldEnemyEnablePending = true' in activation
assert 'GetNamePlates' not in h and 'C_Timer.' not in activation
gate=a.split('function NativeAccess:CanRefoldObjectivesInCombat(key)',1)[1].split('function NativeAccess:InstallRefoldHooks()',1)[0]
for token in ('key ~= "objectives"','self.snapshots[key]','ordinaryBool(protected) == false','ordinaryBool(forbidden) == false'):
 assert token in gate,token
assert 'function NativeAccess:SetObjectiveSecureGate(folded)' in a
assert 'SecureHandlerWrapScript(frame, "OnShow", control, "return true, true"' in a
assert 'if InCombatLockdown() then return false end' in a
assert 'not self:CanRefoldObjectivesInCombat(hookKey)' in a
assert 'not self:CanRefoldObjectivesInCombat(key)' in a
assert 'self.manualOpen[hookKey]' in a
assert 'incident.snapshot.nativeAccess' in read('Logres/Dev/Panel.lua')
assert 'worldEnemyAuraLayoutClaims' in h and 'worldEnemyAuraLayoutClaims' in read('Logres/Dev/Panel.lua')
assert '| L-048 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
names=('test_p0459_hostile_plate_source.lua','test_p0460_selected_removal_source.lua',
 'test_p0461_native_aura_source.lua','test_p0462_world_enemy_pending.lua',
 'test_p0463_aura_layout.lua','test_p0463_activation.lua','test_p0463_tracker.lua')
lua=os.environ.get('LOGRES_LUA') or shutil.which('lua5.4')
if lua:
 for name in names:subprocess.run([lua,str(root/'tools'/name),str(root)],check=True)
else:print('P0463 source execution SKIPPED: set LOGRES_LUA to Lua 5.4; static contracts only')
print('P0463 STATIC PASS: safe native-list placement, observed plate resume and objective capability gates; client UNVERIFIED')
