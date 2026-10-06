#!/usr/bin/env python3
"""Static contract for P0152 R7 shared pet-action adapter."""
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
PROBE=ROOT/'Logres/HUD/PetActionExecutionProbe.lua'
BUTTON=ROOT/'Logres/Actions/Button.lua'
COMMANDS=ROOT/'Logres/Core/Commands.lua'
TOC=ROOT/'Logres/Logres.toc'
BOOT=ROOT/'Logres/Core/Bootstrap.lua'
errors=[]
for p in (PROBE,BUTTON,COMMANDS,TOC,BOOT):
    if not p.is_file(): errors.append(f'missing required file: {p.relative_to(ROOT)}')
probe=PROBE.read_text(encoding='utf-8') if PROBE.is_file() else ''
button=BUTTON.read_text(encoding='utf-8') if BUTTON.is_file() else ''
commands=COMMANDS.read_text(encoding='utf-8') if COMMANDS.is_file() else ''
toc=TOC.read_text(encoding='utf-8') if TOC.is_file() else ''
boot=BOOT.read_text(encoding='utf-8') if BOOT.is_file() else ''

for frag in (
    'local ActionButton = Logres.ActionButton',
    'ActionButton.CreateCluster(',
    'ActionButton.Create(',
    'ActionButton.RegisterPet(',
    'ActionButton.UpdatePet(',
    'ActionButton.SetHotkeyLabel(button, "")',
    'button:HookScript("PostClick"',
    'self:AfterSecureClick(current.petActionSlot, mouseButton)',
    'COLUMNS = 5',
    'ROWS = 2',
    'function Probe:ApplyLayout()',
    'local allyAnchor = _G.LogresHUDAllies',
    'self.cluster:SetPoint("TOP", allyAnchor, "BOTTOM", -45, -12)',
    'self.cluster:SetPoint("CENTER", UIParent, "CENTER", -375, -160)',
    'self:ApplyLayout()',
):
    if frag not in probe: errors.append(f'probe missing R7 shared/layout fragment: {frag}')

for forbidden in (
    'HookScript("PreClick"',
    'BeforeSecureClick',
    'TogglePetAutocast',
    'CastPetAction(',
    'SecureActionButtonTemplate',
    'CreateFrame(\n        "CheckButton"',
    'BUTTON_SIZE',
    'BUTTON_GAP',
    'slotText',
    'logresActiveText',
    'SetText("A")',
    'PetActionBar:Hide',
    'LogresHUDResourceBar',
    'COLUMNS = 10',
):
    if forbidden in probe: errors.append(f'probe contains rejected R7 fragment: {forbidden}')

for frag in (
    'local function petValueIsSecret(value)',
    'local function resolvePetActionName(rawName)',
    'function ActionButton.RegisterPet(button, petSlot)',
    'button:RegisterForClicks("AnyUp")',
    'button:SetAttribute("useOnKeyDown", false)',
    'button:SetAttribute("type1", "pet")',
    'button:SetAttribute("action1", petSlot)',
    'button:SetAttribute("type2", "macro")',
    'button:SetAttribute("macrotext2", macrotext)',
    '"/petautocasttoggle " .. petName',
    'button.petAutocastMacroReady = macrotext ~= nil',
    'function ActionButton.UpdatePet(button, petSlot)',
    'button:SetChecked(active == true)',
    'button.petAutoCastAllowed = autoCastAllowed == true',
    '_G[rawTexture]',
    'checksRange == true and inRange == false',
    'usable == false',
):
    if frag not in button: errors.append(f'Button.lua missing R7 pet adapter fragment: {frag}')

for forbidden in (
    'button:SetAttribute("type", "click")',
    'button:SetAttribute("clickbutton", delegate)',
    'button.petActionDelegate = delegate',
    'TogglePetAutocast',
    'CastPetAction(',
):
    if forbidden in button: errors.append(f'Button.lua contains rejected R7 control fragment: {forbidden}')

for frag in ('petactionexecprobe','Pet Action Probe ARM','Pet Action Probe Check','Pet Action Probe Hide'):
    if frag not in commands: errors.append(f'Commands.lua missing P0152 integration: {frag}')
if 'HUD\\PetActionExecutionProbe.lua' not in toc:
    errors.append('TOC missing PetActionExecutionProbe.lua')
else:
    button_i=toc.find('Actions\\Button.lua')
    probe_i=toc.find('HUD\\PetActionExecutionProbe.lua')
    primary_i=toc.find('Actions\\Primary.lua')
    if min(button_i,probe_i,primary_i)==-1:
        errors.append('TOC missing shared-action pet dependency files')
    elif not (button_i < probe_i < primary_i):
        errors.append('PetActionExecutionProbe.lua must load after Actions/Button.lua and before Actions/Primary.lua')

bm=re.search(r'Logres\.VERSION = "([^"]+)"',boot)
tm=re.search(r'^## Version: (.+)$',toc,re.M)
bv=bm.group(1) if bm else None
tv=tm.group(1).strip() if tm else None
if bv is None or tv is None: errors.append('could not read runtime versions')
elif bv != tv: errors.append('Bootstrap and TOC runtime versions must match')

print('Logres P0152 R7 shared pet-action adapter contract')
print('================================================')
if errors:
    for e in errors: print('ERROR:',e)
    print(f'\nFAILED: {len(errors)} error(s)')
    raise SystemExit(1)
print('PASS: 0 errors')
