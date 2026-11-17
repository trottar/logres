#!/usr/bin/env python3
"""Identified native target crest joins exact reversible decorative allowlist."""
from pathlib import Path
import re,os,shutil,subprocess
R=Path(__file__).resolve().parents[1];read=lambda p:(R/p).read_text()
T=read('Logres/Immersion/TargetFrameReplacement.lua')
keys=re.findall(r'^    "([^"]+)",',T.split('local SUPPRESSED_CONTEXT_KEYS = {',1)[1].split('}',1)[0],re.M)
assert keys==['HighLevelTexture','LeaderIcon','GuideIcon','BossIcon','PvpIcon','PvpBackgroundIcon','PrestigePortrait','PrestigeBadge','PetBattleIcon','NumericalThreat']
preserved=re.findall(r'^    "([^"]+)",',T.split('local PRESERVED_CONTEXT_KEYS = {',1)[1].split('}',1)[0],re.M)
assert preserved==['Auras','RaidTargetIcon','QuestIcon','PingIconFrame']
for x in ('alpha = entry.region:GetAlpha()', 'entry.region:SetAlpha(entry.alpha)',
 'entry.region:SetAlpha(0)', 'if InCombatLockdown() then',
 'debugStatus.suppressedContextCount == 10','debugStatus.contextualSuppressedCount == 10'):
 assert x in T,x
assert 'target.appliedEnabled and 10 or 0' in read('Logres/Core/Commands.lua')
for p in ('tools/check_target_frame_replacement_contract.py','tools/check_p0360_target_frame_diagnostic_seam_contract.py'):
 assert 'debugStatus.suppressedContextCount == 10' in read(p)
assert 'PvpBackgroundIcon' not in read('Logres/Immersion/PlayerFrameReplacement.lua')
for p in ('docs/memory/evidence/P0471_TARGET_FACTION_CREST.md','docs/memory/investigations/ISSUE_LEDGER.md'):
 assert 'P0471' in read(p) and 'L-049' in read(p)
lua=os.environ.get('LOGRES_LUA')or shutil.which('lua5.4')
if lua:subprocess.run([lua,str(R/'tools/test_p0471_target_crest.lua'),str(R)],check=True)
else:print('P0471 actual-source fixture UNVERIFIED: Lua5.4 unavailable')
print('P0471 target crest STATIC PASS; client UNVERIFIED')
