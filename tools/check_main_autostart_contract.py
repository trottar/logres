#!/usr/bin/env python3
"""P0189: default secure Main start is capability-gated, retryable and reversible."""
from pathlib import Path
import sys
ROOT = Path(__file__).resolve().parents[1]
MAIN = ROOT / "Logres/Actions/MainReplacement.lua"
MODULES = ROOT / "Logres/Core/Modules.lua"
TOC = ROOT / "Logres/Logres.toc"
issues = []
if not MAIN.exists() or not MODULES.exists() or not TOC.exists():
    issues.append("missing Main, Modules or TOC")
else:
    s = MAIN.read_text()
    t = TOC.read_text()
    if t.find('Actions\\Primary.lua') < 0 or t.find('Actions\\MainReplacement.lua') < t.find('Actions\\Primary.lua'):
        issues.append('Primary must register before Main')
    for token in (
        'self.manualOptOut = false',
        'if not self.manualOptOut then\n            self.sessionArmed = true\n        end\n        self:Reconcile("module-enable")',
        'self.manualOptOut = armed ~= true',
        'self.sessionArmed = armed == true',
        'local desired = self.sessionArmed and immersion and not self.editActive',
        'self.pending = true\n        -- Keep any earlier real secure error until a successful Engage',
        '"PLAYER_REGEN_ENABLED", "PLAYER_ENTERING_WORLD"',
        '"UPDATE_BONUS_ACTIONBAR"', '"UPDATE_OVERRIDE_ACTIONBAR"',
        '"UPDATE_VEHICLE_ACTIONBAR"', '"UPDATE_POSSESS_BAR"',
        '"UPDATE_SHAPESHIFT_FORM"', '"PET_BATTLE_CLOSE"',
        'if InCombatLockdown() then',
        'self:Release()',
        'self.gate:SetAttribute("state-logresmode", nil)',
        'primary:SetAttribute("clickbutton", stock)',
        'nativeParentTransitions',
    ):
        if token not in s: issues.append('missing gated auto contract: '+token)
    if 'self:Reconcile("module-enable")' not in s.split('    OnEnable = function(self)',1)[1].split('    OnDisable = function(self)',1)[0]:
        issues.append('default reconcile must live in OnEnable')
    if 'self.sessionArmed = false' not in s.split('    OnDisable = function(self)',1)[1].split('})',1)[0]:
        issues.append('lifecycle disable must disarm and restore')
    engage = s.split('function Main:Engage()',1)[1].split('function Main:Release()',1)[0]
    release = s.split('function Main:Release()',1)[1].split('function Main:Reconcile(',1)[0]
    if 'local ready, reason = sourceReady(primary)' not in engage or 'if not ready then' not in engage:
        issues.append('missing source preflight before native gate')
    if engage.index('local ready, reason = sourceReady(primary)') > engage.index('stock:SetParent(self.gate)'):
        issues.append('unsafe native gate before preflight')
    if 'stock:SetParent(oldParent)' not in release or 'UnregisterStateDriver(self.gate, "logresmode")' not in release:
        issues.append('native restore missing')
    for forbidden in ('C_Timer.', 'OnUpdate', 'hooksecurefunc(', 'MainActionBar:Hide(', 'MainActionBar:SetAlpha('):
        if forbidden in s: issues.append('forbidden background/native mutation: '+forbidden)
print('Logres P0189 Main auto-start contract')
for problem in issues: print('ERROR:',problem)
print('PASS: 0 errors' if not issues else f'FAIL: {len(issues)} errors')
sys.exit(bool(issues))
