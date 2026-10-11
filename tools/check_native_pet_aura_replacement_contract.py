#!/usr/bin/env python3
"""P0196 R4: preserve authored Logres buffs; gate native target aura configuration.

Never pin an exact runtime version in a permanent static checker.
"""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
def read(p):return (R/p).read_text(encoding='utf-8')
N=read('Logres/Immersion/NativeSurfaceReplacement.lua')
P=read('Logres/HUD/PetActionExecutionProbe.lua')
H=read('Logres/HUD/PlayerHelpfulAuras.lua')
S=read('Logres/HUD/StatusAuras.lua')
T=read('Logres/Logres.toc')
C=read('Logres/Core/Commands.lua')
errors=[]
for t in ('"SecureUnitButtonTemplate"', '"unit", "pet"', '"*type2", "togglemenu"',
          'function Native:Ready(key)', 'function Native:Fold(key)',
          'function Native:Restore(key)', 'function Native:Reconcile(reason)',
          'function Native:Toggle(domain)', 'function Native:GetDebugStatus()',
          'self:Restore(key)', 'self:Fold(key)', 'pcall(frame.HookScript',
          'if InCombatLockdown() then', '"PET"', '"BUFFS"', '"TARGET"',
          'local helpful = secureReadiness("PlayerHelpfulAuras")',
          'helpful.root ~= nil', 'self.buttons.playerBuffs ~= nil',
          'if key == "targetAuras" then',
          'local row = CreateFrame("Frame", nil, UIParent)',
          'row:SetPoint("TOPLEFT", dock, "BOTTOMLEFT", 0, -5)',
          'function Native:RefreshNativeAuras()'):
    if t not in N:errors.append('native gate missing: '+t)
for t in ('function Native:FoldTargetAuras()',
          'function Native:RestoreTargetAuras()',
          'target.maxBuffs = 0', 'target.maxDebuffs = 0',
          'target:ConfigureAuraContainer()',
          'snapshot.target.maxBuffs = snapshot.maxBuffs',
          'snapshot.target.maxDebuffs = snapshot.maxDebuffs',
          'status.nativeDebuffs ~= nil and status.nativeActive == true',
          'self.buttons.targetAuras ~= nil',
          'if key == "targetAuras" then return self:FoldTargetAuras() end',
          'if key == "targetAuras" then return self:RestoreTargetAuras() end'):
    if t not in N:errors.append('source-backed target fold missing: '+t)
if 'pcall(frame.HookScript, frame, "OnShow"' not in N:
    errors.append('non-target on-show hook behavior unexpectedly removed')
if 'auraContainer:Hide()' in N and 'Blizzard Forever' not in N:
    errors.append('unexpected direct aura hide')
for t in ('createAuraContainer(', 'CustomAuraContainerTemplate',
          'function Native:PrepareNativeAuras()', 'frame:AddAuraGroup(',
          'SetNativeOverride(', 'SetNativeHelpfulOverride(',
          'function HelpfulAuras:SetNativeOverride(enabled)',
          'function StatusAuras:SetNativeHelpfulOverride(active)',
          'if self.nativeOverride', 'if self.nativeHelpfulOverride'):
    if t in N+H+S: errors.append('regressed native buff takeover: '+t)
for t in ('local MAX_ICONS = 4', 'local FILTER = "HELPFUL|PLAYER"',
          'frameTexture', 'auraStyle.assets'):
    if t not in H:errors.append('original Logres player buff contract missing: '+t)
for t in ('renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)',
          'local columns = unit == "player" and MAX_ICONS or 2'):
    if t not in S:errors.append('original target-status lane missing: '+t)
for t in ('self:Arm()', 'self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")'):
    if t not in P:errors.append('pet action autostart missing: '+t)
for t in (r'Immersion\NativeSurfaceReplacement.lua',):
    if t not in T:errors.append('TOC missing replacement module')
if 'Logres native-surfaces:' not in C:errors.append('native-surface diagnostic missing')
for t in ('SetCVar(', 'C_Timer.', 'SetParent(', 'SetAlpha(0)',
          'GetAuraDataByIndex','GetAuraDataByAuraInstanceID','GetAuraDataBySlot',
          'UnitBuff(', 'UnitDebuff(', 'hooksecurefunc(', 'RegisterStateDriver(',
          'tostring(shown)', 'if shown then', 'if snapshot.shown'):
    if t in N:errors.append('unsafe native manipulation: '+t)
print('Logres P0196 R4 authored buff art and source-supported target aura fold')
for e in errors: print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAIL: {len(errors)} errors')
raise SystemExit(bool(errors))
