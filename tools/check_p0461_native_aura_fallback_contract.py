#!/usr/bin/env python3
"""P0461: stock nameplate aura ownership vs unproven world icon readiness."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding="utf-8")
h=read("Logres/HUD/HUD.lua")
a=read("Logres/HUD/StatusAuras.lua")
n=read("Logres/HUD/NativeDebuffs.lua")
claim=h.split("function HUD:ClaimNativeEnemyDecor(anchor)",1)[1].split("function HUD:BuildSecondaryAggroTrial()",1)[0]
restore=h.split("function HUD:RestoreNativeEnemyDecor()",1)[1].split("function HUD:ClaimNativeEnemyDecor(anchor)",1)[0]
for required in ('local candidates = {name, health}',
                 'nativeDecorField(unitFrame, "AurasFrame")',
                 'nativeDecorField(auraRoot, "DebuffListFrame")',
                 'nativeDecorField(auraRoot, "BuffListFrame")',
                 'worldEnemyNativeAuraSourceCapable',
                 'self.worldEnemyNativeAuraOwned = false',
                 'pcall(region.GetAlpha, region)',
                 'pcall(region.SetAlpha, region, 0)'):
    assert required in claim,required
for forbidden in ('safeNativeDecor(harmful)', 'safeNativeDecor(helpful)',
                  'candidates[#candidates + 1] = harmful',
                  'candidates[#candidates + 1] = helpful',
                  'GetChildren(', 'GetRegions(', 'IsShown(', 'GetAlpha, harmful',
                  'GetAlpha, helpful', 'GetAuraDataByIndex', 'C_Timer.',
                  'SetCVar(', 'SetParent(', 'SetUnit('):
    assert forbidden not in claim,forbidden
assert 'pcall(entry.region.SetAlpha, entry.region, entry.original)' in restore
assert 'self.worldEnemyNativeAuraSourceCapable = false' in restore
assert 'self:RestoreNativeEnemyDecor()' in h
selected=h.split('function HUD:RefreshLiveWorldEnemy(event, eventUnit)',1)[1].split('function HUD:SetLiveWorldEnemy(enabled)',1)[0]
assert selected.index('self:ClaimNativeEnemyDecor(anchor)') < selected.index('if self.worldEnemyNativeAuraSourceCapable')
assert selected.index('if not pcall(frame.Show, frame)') < selected.index('if self.worldEnemyNativeAuraSourceCapable')
assert 'auras:SetWorldEnemyScreenAuraHandoff(true)' in selected
hide=h.split('function HUD:HideLiveWorldEnemy(reason)',1)[1].split('function HUD:UpdateLiveWorldEnemyValues()',1)[0]
assert 'statusAuras:SetWorldEnemyScreenAuraHandoff(false)' in hide
native=a.split('function StatusAuras:CreateWorldEnemyLiveLanes(parent)',1)[1].split('function StatusAuras:SetWorldEnemyScreenAuraHandoff(',1)[0]
assert 'self.worldEnemyNativeLanes = nil' in native
assert 'CreateWorldEnemyLanes' not in native
refresh=a.split('function StatusAuras:RefreshWorldEnemyLiveLanes()',1)[1].split('function StatusAuras:RefreshWorldEnemyLiveSource(',1)[0]
for token in ('renderLane(self.worldEnemyLiveLanes.harmful, {}, false)',
              'renderLane(self.worldEnemyLiveLanes.helpful, {}, false)',
              'stock-nameplate-native-delegated'):
    assert token in refresh,token
for forbidden in ('renderLane(self.worldEnemyLiveLanes.harmful, rows, active)',
                  'renderLane(self.worldEnemyLiveLanes.helpful, helpful, active)',
                  'GetChildren(', 'GetAuraDataByIndex', 'C_Timer.'):
    assert forbidden not in refresh,forbidden
# Historical helper remains available for comparison, never invoked live.
assert 'function Native.CreateWorldEnemyLanes(parent)' in n
assert 'function Native.SetScreenTargetWorldOwned(state, worldOwned)' in n
assert 'state.screenTargetWorldAlpha' in n
secondary=h.split('function HUD:ClaimNativeSecondaryEnemyDecor(slot, anchor)',1)[1].split('function HUD:RefreshSecondaryOwnerCount()',1)[0]
assert 'local candidates = {name, health}' in secondary
for forbidden in ('"AurasFrame"', '"DebuffListFrame"', '"BuffListFrame"', 'SetUnit('):
    assert forbidden not in secondary,forbidden
assert 'worldEnemyAuraPresentationOwner = "Blizzard-nameplate"' in a
assert 'worldEnemyNativeVisibilityProof = "unobserved"' in a
for p in ('docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/investigations/ACTIVE.md'):
    assert read(p).startswith('## P0461 —'),p
assert '**P0461**' in read('docs/memory/CURRENT.md')
assert read('docs/memory/handoffs/CURRENT_HANDOFF.md').startswith('# P0461:')
assert 'P0449' in read('docs/memory/evidence/P0461_NATIVE_NAMEPLATE_AURA_FALLBACK.md')
assert 'P0460' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert re.search(r'^## Version: (\S+)$',read('Logres/Logres.toc'),re.M).group(1)==re.search(r'^Logres.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'),re.M).group(1)
print('P0461 PASS: stock native aura source preserved, duplicate world lanes inert, guarded screen fallback')
