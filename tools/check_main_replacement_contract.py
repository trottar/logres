#!/usr/bin/env python3
"""P0187 R1: secure Main must rearm after ON/OFF/ON without stale driver state."""
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / 'Logres/Actions/MainReplacement.lua'
PRIMARY = ROOT / 'Logres/Actions/Primary.lua'
COMMANDS = ROOT / 'Logres/Core/Commands.lua'
TOC = ROOT / 'Logres/Logres.toc'
issues = []
for f in (MAIN, PRIMARY, COMMANDS, TOC):
    if not f.exists(): issues.append(f'missing {f.relative_to(ROOT)}')
if MAIN.exists():
    s = MAIN.read_text()
    for token in (
        '"MainActionReplacement"', 'SecureHandlerStateTemplate',
        'RegisterStateDriver(self.gate, "logresmode", MODE_DRIVER)',
        'UnregisterStateDriver(self.gate, "logresmode")',
        'SECURE_MODE_SCRIPT', 'primary:SetAttribute("type", "click")',
        'primary:SetAttribute("type", "action")',
        'primary:SetAttribute("clickbutton", stock)',
        'self:Hide()', 'self:Show()', 'stock:SetParent(self.gate)',
        'stock:SetParent(oldParent)', 'if InCombatLockdown() then',
        'self.originalParent', 'self.originalRouting',
        'self.sessionArmed = false', 'EditMode.Enter', 'EditMode.Exit',
        'self:SubscribePreferences(', 'issecretvalue',
        'specialModeProof = "environmentally-deferred"',
    ):
        if token not in s: issues.append('Main missing: '+token)
    for forbidden in (
        'MainActionBar:Hide(', 'MainActionBar:SetAlpha(',
        'C_Timer.', ':SetScript("OnUpdate"', 'SetBinding(', 'SaveBindings(',
        'hooksecurefunc(', 'hooksecurefunc ',
    ):
        if forbidden in s: issues.append('Main forbidden: '+forbidden)
    # Regression: after OFF the old state-"normal" attribute persists unless
    # actively reset. Driver registration compares values and skips _onstate
    # when they have not changed. Guard BOTH Engage and Release ordering.
    gate_reset = 'self.gate:SetAttribute("state-logresmode", nil)'
    if s.count(gate_reset) < 2:
        issues.append('Main must reset stale state on both arm and disarm')
    engage = s.split('function Main:Engage()', 1)[-1].split('function Main:Release()', 1)[0]
    release = s.split('function Main:Release()', 1)[-1].split('function Main:Reconcile(', 1)[0]
    engage_start = engage.find('stock:SetParent(self.gate)')
    engage_reset = engage.find(gate_reset, engage_start)
    engage_driver = engage.find('RegisterStateDriver(self.gate, "logresmode", MODE_DRIVER)', engage_reset)
    if min(engage_start, engage_reset, engage_driver) < 0 or not (engage_start < engage_reset < engage_driver):
        issues.append('Main engage must clear stale state before driver registration')
    release_parent = release.find('stock:SetParent(oldParent)')
    release_unreg = release.find('UnregisterStateDriver(self.gate, "logresmode")')
    release_reset = release.find(gate_reset, release_unreg)
    release_show = release.find('self.gate:Show()', release_reset)
    if min(release_parent, release_unreg, release_reset, release_show) < 0 or not (release_parent < release_unreg < release_reset < release_show):
        issues.append('Main OFF must restore native parent, unregister/reset, then show gate')
    if 'if not self.sessionArmed then\n            self.lastError = nil' not in release:
        issues.append('Main OFF must retire prior failed-ON diagnostic')
    if 'self.appliedEnabled = true' not in s or 'self.appliedEnabled = false' not in s:
        issues.append('missing restoration/application state')
if PRIMARY.exists():
    s=PRIMARY.read_text()
    if 'if enabled ~= true and self.mainReplacementActive then' not in s:
        issues.append('Primary key-routing OFF not protected while Main active')
if TOC.exists() and 'Actions\\MainReplacement.lua' not in TOC.read_text():
    issues.append('TOC missing Main module')
if COMMANDS.exists():
    s=COMMANDS.read_text()
    for item in ('"mainreplace"', '"mainreplacecheck"',
                 '"mainReplaceOn"', '"mainReplaceOff"', '"mainReplaceCheck"',
                 'Logres:GetMainReplacementDiagnosticLine()'):
        if item not in s: issues.append('Commands missing '+item)
print('Logres P0187 main secure candidate contract')
for i in issues: print('ERROR:',i)
print('PASS: 0 errors' if not issues else f'FAIL: {len(issues)} errors')
sys.exit(bool(issues))
