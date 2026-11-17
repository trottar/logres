#!/usr/bin/env python3
"""Per-nameplate native aura consumers with transactional presentation handoff."""
from pathlib import Path
import os,shutil,subprocess
r=Path(__file__).resolve().parents[1]
read=lambda p:(r/p).read_text()
n=read('Logres/HUD/NativeDebuffs.lua').split('-- P0464: per-owner native rendering',1)[1]
h=read('Logres/HUD/HUD.lua')
for forbidden in ('GetPoint','GetNumPoints','GetChildren','GetRegions','GetAuraData','IsVisible','GetShown','SetParent','SetAttribute','C_Timer','OnUpdate','HookScript'):
 assert forbidden not in n,forbidden
for token in ('Native.PrepareWorldAuraOwner','Native.BindWorldAuraOwner','Native.ReleaseWorldAuraOwner',
 'ordinary(locked)','worldAuraRegionReady','SetDurationText','SetApplicationCount',
 'AnchorUtil.FlowDirection.Left','AnchorUtil.FlowDirection.Right','AnchorUtil.FlowDirection.Up',
 'pcall(region.IsShown, region)','pcall(entry.region.SetShown, entry.region, entry.shown)',
 'frame:SetUnit(unit)','frame:UpdateAllAuras()','aura-native-restore-pending'):
 assert token in n,token
assert n.index('frame:Show()') < n.index('pcall(entry.region.SetShown, entry.region, false)')
assert 'GetAlpha' not in n and 'SetAlpha' not in n
assert 'if shown' not in n and 'tostring(shown)' not in n
assert n.count('pcall(region.IsShown, region)')==1
assert n.count('entry.shown')==1
assert 'native.ClaimNameplateAuraLayout(' not in h
assert h.count('self:BindEnemyWorldAuras(')==3
for a,b in [('function HUD:HideLiveWorldEnemy(reason)','function HUD:UpdateLiveWorldEnemyValues()'),
 ('function HUD:HideSecondaryAggroOwner(slot, reason)','function HUD:HideSecondaryAggroTrial(reason)')]:
 block=h.split(a,1)[1].split(b,1)[0]
 assert block.index('ReleaseWorldAuraOwner')<block.index('Visible = false') if 'Visible = false' in block else block.index('ReleaseWorldAuraOwner')<block.index('slot.visible = false')
 assert 'return false' in block
for key in ('worldEnemyAuraRendererBinds','worldEnemyAuraRendererReleases','worldEnemyAuraRendererRefusals','worldEnemyAuraRendererReason'):
 assert key in h and key in read('Logres/Dev/Panel.lua')
lua=os.environ.get('LOGRES_LUA')or shutil.which('lua5.4')
if lua:subprocess.run([lua,str(r/'tools/test_p0464_native_world_auras.lua'),str(r)],check=True)
else:print('P0464 source execution SKIPPED; set LOGRES_LUA to Lua 5.4')
print('P0464 STATIC PASS; HP retained, native payload consumers only; client UNVERIFIED')
