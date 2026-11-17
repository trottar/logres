#!/usr/bin/env python3
"""Sheet-04 world aura appearance without changing the accepted lifecycle."""
from pathlib import Path
import os,shutil,subprocess
r=Path(__file__).resolve().parents[1]
read=lambda p:(r/p).read_text()
source=read('Logres/HUD/NativeDebuffs.lua')
p=source.split('-- P0465 shared source-independent aura presentation.',1)[1].split('-- P0183:',1)[0];n=source
n=n.split('local function createOwnedWorldAura',1)[1].split('function Native.PrepareWorldAuraOwner',1)[0]
for token in ('presentation.CreateBase(button)','presentation.CreateNativeMetadata(button)','button:SetIcon(visual.icon)',
 'button:SetApplicationCount(count, {})','button:SetDurationText(duration, {})'):
 assert token in n,token
for forbidden in ('CooldownFrameTemplate','SetDurationCooldown','SetVertexColor','GetAura','C_UnitAuras','GetChildren','GetRegions','OnUpdate','HookScript'):
 assert forbidden not in n+p,forbidden
assert 'statusAura' in p and 'border:SetTexture(assert(assets.frame))' in p
assert 'Logres.AuraPresentation.CreateBase(slot)' in read('Logres/HUD/StatusAuras.lua')
toc=read('Logres/Logres.toc')
assert toc.index('HUD\\NativeDebuffs.lua')<toc.index('HUD\\StatusAuras.lua')
assert len([s for s in toc.splitlines() if s.endswith('.lua')])==96
for field in ('worldEnemyAuraRendererStyle',):
 assert field in read('Logres/HUD/HUD.lua') and field in read('Logres/Dev/Panel.lua')
assert 'logres-sheet04-native-text' in p
assert '| L-028 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
lua=os.environ.get('LOGRES_LUA')or shutil.which('lua5.4')
if lua:subprocess.run([lua,str(r/'tools/test_p0465_aura_style.lua'),str(r)],check=True)
else:print('P0465 source execution SKIPPED; set LOGRES_LUA to Lua5.4')
print('P0465 STATIC PASS; approved native spell art with Logres framing; client UNVERIFIED')
