#!/usr/bin/env python3
"""P0183: native restricted-aura rendering, no restricted payload inspection."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
N=(ROOT/'Logres/HUD/NativeDebuffs.lua').read_text(encoding='utf-8')
S=(ROOT/'Logres/HUD/StatusAuras.lua').read_text(encoding='utf-8')
C=(ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
T=(ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
B=(ROOT/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
errors=[]
for token in ('"AuraContainer", nil, UIParent, "CustomAuraContainerTemplate"',
              'frame:AddAuraGroup("LogresHarmful", "HARMFUL", {',
              'button:SetIcon(icon)', 'frame:SetUnit(unit)',
              'frame:SetEnabled(active)', 'frame:UpdateAllAuras()',
              'Logres.Layout.Bind(frame, key', 'InCombatLockdown()',
              'return nil, "native-setup-failed"'):
    if token not in N: errors.append('missing native contract: '+token)
for forbidden in ('GetAuraDataByIndex','GetAuraDataByAuraInstanceID',
                  'GetUnitAuraInstanceIDs','GetAuraSlots',
                  'ShouldUnitAuraIndexBeSecret','GetAuraDataBySlot',
                  'UNIT_AURA','addedAuras','SetScript("OnUpdate"',
                  'BuffFrame:Hide','DebuffFrame:Hide', 'TargetFrame:Hide'):
    if forbidden in N: errors.append('forbidden native inspection/mutation: '+forbidden)
for token in ('Logres.NativeDebuffs.Create()',
              'Logres.NativeDebuffs.SetActive(',
              'nativeActive = self.nativeDebuffs',
              'active and not useNative',
              'nativeReady = self.nativeDebuffs ~= nil'):
    if token not in S: errors.append('missing StatusAuras integration: '+token)
for token in ('d.nativeActive', 'Logres native debuffs:'):
    if token not in C: errors.append('missing panel check: '+token)
if not (r'HUD\NativeDebuffs.lua' in T and T.index(r'HUD\NativeDebuffs.lua')<T.index(r'HUD\StatusAuras.lua')):
    errors.append('TOC order invalid')
import re
v=re.search(r'Logres.VERSION = "([^"]+)"',B)
t=re.search(r'^## Version: (.+)$',T,re.M)
if not v or not t or v.group(1)!=t.group(1):errors.append('version mismatch')
print('Logres P0183 native debuff container contract')
print('===========================================')
if errors:
    for e in errors: print('ERROR:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
