#!/usr/bin/env python3
"""P0333: ordinary pet binding labels and single active outline; source/offline only."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda s:(R/s).read_text(encoding="utf8")
P=read("Logres/HUD/PetActionExecutionProbe.lua")
A=read("Logres/HUD/PetActionPresentation.lua")
B=read("Logres/Actions/Button.lua")
T=read("Logres/Logres.toc")
boot=read("Logres/Core/Bootstrap.lua")
legacy=read("tools/check_pet_action_execution_probe_contract.py")
issues=read("docs/memory/investigations/ISSUE_REGISTER.md")
current=read("docs/memory/CURRENT.md")
handoff=read("docs/memory/handoffs/CURRENT_HANDOFF.md")

def need(ok,msg):
    if not ok: raise AssertionError(msg)

label=P[P.index('local function safePetBindingLabel(slot)'):P.index('function Probe:RefreshBindingLabels()',P.index('local function safePetBindingLabel(slot)'))]
for token in ('type(GetBindingKey) ~= "function"','pcall(GetBindingKey, "BONUSACTIONBUTTON" .. slot)',
              'if not ok or isSecret(rawKey) then','if rawKey == nil then','type(rawKey) ~= "string"',
              'return rawKey'):
    need(token in label, 'pet binding label ordinary-only source missing: '+token)
need(label.index('isSecret(rawKey)')<label.index('if rawKey == nil then')<label.index('type(rawKey) ~= "string"'),
     'secret must be checked before inspecting the first key')
refresh=P[P.index('function Probe:RefreshBindingLabels()'):P.index('function Probe:ConfigureSecureButtons()')]
for token in ('for slot = 1, MAX_PET_SLOTS do','safePetBindingLabel(slot)',
              'ActionButton.SetHotkeyLabel(self.buttons[slot], label)',
              'ActionButton.SetHotkeyLabel(self.buttons[slot], "")'):
    need(token in refresh,'pet label refresh absent: '+token)
need('"UPDATE_BINDINGS",' in P and 'if event == "UPDATE_BINDINGS" then' in P
     and 'self:RefreshBindingLabels()' in P and 'self:RefreshBindingLabels()' in P[P.index('function Probe:ConfigureSecureButtons()'):P.index('function Probe:CaptureActiveState')],
     'binding init / change lifecycle missing')
need('ActionButton.SetHotkeyLabel(button, "")' in P,
     'empty default for not-yet-configured pet buttons not retained')
need('button:SetChecked(active == true and not button.logresPetPresentationReady)' in B,
     'decorated pet buttons must not draw second generic checked outline')
need('button:SetChecked(active == true)' not in B and
     'button:SetChecked(active == true and not button.logresPetPresentationReady)' in legacy,
     'historical P0152 check not migrated with presentation policy')
start=A.index('local function updateButton(button)')
end=A.index('local function readAttribute(',start)
block=A[start:end]
need('if isActive == nil then' in block and
     'if isActive == nil or autoCastAllowed == nil or autoCastEnabled == nil then' not in block,
     'valid active must not depend on independent autocast availability')
for token in ('ordinaryBoolean(rawIsActive)','ordinaryBoolean(rawAutoCastAllowed)',
              'ordinaryBoolean(rawAutoCastEnabled)',
              'local activeShown = isActive == true',
              'local autocastShown = autoCastAllowed == true and autoCastEnabled == true',
              'setBorderShown(button.logresPetActiveBorder, activeShown)',
              'setBorderShown(button.logresPetAutocastBorder, autocastShown)'):
    need(token in block,'pet active/autocast distinction lost: '+token)
for forbidden in ('SetOverrideBinding','SetBinding(', 'SetAttribute(',
                  'CastPetAction(', 'TogglePetAutocast(', 'C_Timer.', 'OnUpdate'):
    need(forbidden not in label+refresh, 'pet label must not change secure actions: '+forbidden)

# Pure policy fixtures, inputs already ordinary; no game/secret data modelled.
def display(key,secret):
    if secret or key is None: return ''
    if not isinstance(key,str): return ''
    return key.upper().replace('SHIFT-','s-').replace('CTRL-','c-').replace('ALT-','a-')
for key,secret,expected in [('CTRL-2',False,'c-2'),('SHIFT-4',False,'s-4'),
                            (None,False,''),('CTRL-1',True,''),('ALT-CTRL-3',False,'a-c-3'),(9,False,'')]:
    need(display(key,secret)==expected,'binding label offline policy fixture failed')
def indicators(active,autoAllowed,autoEnabled,decorated):
    return (active is True and not decorated,
            active is True,
            autoAllowed is True and autoEnabled is True)
need(indicators(True,None,None,True)==(False,True,False), 'active lost to unknown autocast')
need(indicators(True,True,True,True)==(False,True,True), 'autocast and active conflated')
need(indicators(True,None,None,False)==(True,True,False), 'undecorated checked fallback lost')
need(indicators(False,True,True,True)==(False,False,True), 'autocast without active invalid')
v=re.search(r'(?m)^## Version: (\S+)$',T);b=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',boot)
need(v and b and v.group(1)==b.group(1), 'TOC/Bootstrap mismatch')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,'loaded Lua inventory changed')
need('| L-021 |' in issues and '| L-024 |' in issues and 'P0333' in issues,'issue continuity lost')
for n in range(317,334): need(f'P{n:04d}' in current,'CURRENT history lost '+str(n))
for x in ('CURRENT.md','P0326','P0327','P0332','P0333'):
    need(x in handoff,'handoff historical continuity lost: '+x)
for x in ('docs/memory/evidence/P0333_PET_PRESENTATION.md','docs/memory/patches/P0333_PET_PRESENTATION.md'):
    s=read(x);need('UNVERIFIED' in s and s.endswith('\n') and not s.endswith('\n\n'),x+' hygiene/deferral')
print('P0333 pet binding plate / active outline / independent autocast contract')
print('PASS: ordinary binding source, six binding and four active/autocast fixtures, continuity')
