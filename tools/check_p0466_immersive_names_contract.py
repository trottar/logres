#!/usr/bin/env python3
"""Saved world defaults, screen opt-in and transactional native name settings."""
from pathlib import Path
import os,shutil,subprocess
r=Path(__file__).resolve().parents[1]
read=lambda p:(r/p).read_text()
h=read('Logres/HUD/HUD.lua');c=read('Logres/Immersion/Controller.lua')
n=c.split('-- P0466: reversible client name-display policy',1)[1]
for token in ('UnitNameNPC','UnitNameOwn','UnitNameFriendlyPlayerName','UnitNameEnemyPlayerName',
 'UnitNameFriendlyPetName','UnitNamePlayerGuild','UnitNameFocused',
 'nameplateShowEnemies = "1"','nameplateShowAll = "0"','nameplateShowFriends = "0"',
 'state.meta.overheadNameSnapshot','Names.Restore','state.active then',
 'names-deferred-ooc','REQUIRED_NAMES','readSetting(key) == value'):
 assert token in n,token
for forbidden in ('UnitName(', 'UnitExists(', 'GetChildren','GetRegions','GetPoint', 'SetAlpha',
 'SetAttribute','C_NamePlate','C_Timer','OnUpdate','HookScript','CVAR_UPDATE'):
 assert forbidden not in n,forbidden
assert 'worldEnemyEnabled = true' in read('Logres/Core/Database.lua')
assert 'screenSpaceEnemyFrameEnabled = false' in read('Logres/Core/Database.lua')
assert 'worldEnemyEnabled = previous.worldEnemyEnabled' in read('Logres/Core/Preferences.lua')
assert 'SetPreference("worldEnemyEnabled", argument == "on"' in read('Logres/Core/Commands.lua')
assert 'local screenEnemy = Logres:GetPreferences().screenSpaceEnemyFrameEnabled == true' in h
assert 'screenEnemy and self.worldEnemyLiveVisible ~= true' in h
assert 'self.worldEnemyPreferenceApplied ~= desiredWorld' in h
assert 'self:ReconcileOverheadNames(policy)' in c
assert 'self:ReconcileOverheadNames({immersionEnabled = false})' in c
assert 'incident.snapshot.overheadNames' in read('Logres/Dev/Panel.lua')
assert '| L-049 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert '| L-050 |' in read('docs/memory/investigations/ISSUE_LEDGER.md')
lua=os.environ.get('LOGRES_LUA')or shutil.which('lua5.4')
if lua:subprocess.run([lua,str(r/'tools/test_p0466_names_defaults.lua'),str(r)],check=True)
else:print('P0466 source execution SKIPPED; set LOGRES_LUA to Lua5.4')
print('P0466 STATIC PASS; saved choices and safe CVar restoration; client selection behavior UNVERIFIED')
