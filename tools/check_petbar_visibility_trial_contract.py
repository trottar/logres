#!/usr/bin/env python3
"""P0209 R8: enforce correct ownership direction and secure pet fallback."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
t=(R/'Logres/Immersion/PetBarVisibilityTrial.lua').read_text()
n=(R/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
p=(R/'Logres/HUD/PetActionExecutionProbe.lua').read_text()
c=(R/'Logres/Core/Commands.lua').read_text()
panel=(R/'Logres/Dev/Panel.lua').read_text()
e=[]
for name,s in {
 'two native state drivers':'pcall(RegisterStateDriver, bar, "visibility", NATIVE_HIDE)',
 'native pet unit state driver':'pcall(RegisterStateDriver, unit, "visibility", NATIVE_HIDE)',
 'secure hide constant':'local NATIVE_HIDE = "hide"',
 'restore secure show state':'RegisterStateDriver(bar, "visibility", NATIVE_SHOW)',
 'pet unit restore':'UnregisterStateDriver(unit, "visibility")',
 'Blizzard owner action update':'pcall(bar.OnEvent, bar, "PET_BAR_UPDATE")',
 'Blizzard owner pet unit update':'pcall(unit.UpdateShownState, unit)',
 'Logres buttons remain primary':'function Trial:IsAcquired()\n    return false',
 'stock manual access':'function Trial:ToggleNativeAccess()',
 'stock immersive policy':'Logres:GetPreference("immersionEnabled") == true',
 'combat lockdown':'if InCombatLockdown() then',
 'pet unit fallback':'not native.petInteraction',
 'known secret-safe Edit Mode':'pcall(issecretvalue, active)',
 'correct intent':'immersive-stock-pet-suppression-logres-active',
 'pet mode state':'petFrameDriver = self.unitDriver',
}.items():
 if s not in t:e.append('missing '+name)
for bad in ('[combat] show; hide','[combat] hide; show','stock:SetPoint(', 'stock:ClearAllPoints(',
            'SetParent(', 'GetParent(', 'pcall(probe.HideProbe', 'probe:HideProbe(',
            'C_Timer.', 'SetScript("OnUpdate"'):
 if bad in t:e.append('unsafe/old inverted handoff '+bad)
if t.count('RegisterStateDriver(')+t.count('pcall(RegisterStateDriver,')<4:e.append('driver arming/restoration incomplete')
if 'if nativeReuse:IsAcquired() then' not in p:e.append('existing pet probe ownership guard missing')
if 'trial:ToggleNativeAccess()' not in n:e.append('PET stock dock not integrated')
for s in ('if key == "petFrame" then return false end','if key == "petActions" then return false end',
          'button:SetText("PET STOCK")'):
 if s not in n:e.append('native fold quarantine or dock missing '+s)
if 'MAX_ACTIONS_PER_PHASE = BUTTON_COLUMNS * 6' not in panel:e.append('18 action panel altered')
for s in ('command == "petbardriver"', '"Native Pet Bar ON (TEST)"',
          '"Native Pet Bar OFF"','"Native Pet Bar Check"'):
 if s not in c:e.append('existing phase H controls lost '+s)
if 'return self.applied == true and self.probeSuppressed == true' in t:
 e.append('old reversed ownership still present')
if any(s in t for s in (':IsShown(', 'GetAlpha(', 'GetPoint(')):
 e.append('protected native presentation inspection not allowed')
print('P0209 R8 correct-direction secure pet visibility contract')
for item in e:print('ERROR:',item)
if e:raise SystemExit(1)
print('PASS: 0 errors')
