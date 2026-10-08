#!/usr/bin/env python3
"""P0172 native access fallback/ownership static contract."""
from pathlib import Path
import sys
root=Path(__file__).resolve().parents[1]
addon=root/'Logres'
module=addon/'Immersion'/'NativeAccess.lua'
commands=addon/'Core'/'Commands.lua'
layout=addon/'Integration'/'Layout.lua'
toc=addon/'Logres.toc'
errors=[]
for path in (module, commands, layout, toc):
    if not path.is_file(): errors.append('missing '+str(path.relative_to(root)))
if module.is_file():
    code=module.read_text(encoding='utf-8')
    for token in ('"MinimapCluster"','"ObjectiveTrackerFrame"',
                  '"StatusTrackingBarManager"','"MicroMenuContainer"',
                  '"BagsBar"','function NativeAccess:Capture(key)',
                  'function NativeAccess:Restore(key, reason)',
                  'function NativeAccess:Fold(key)',
                  'function NativeAccess:Toggle(key)',
                  'function NativeAccess:GetDebugStatus()',
                  'Logres:RegisterEvent("PLAYER_REGEN_ENABLED"',
                  'if InCombatLockdown() then',
                  'snapshot[index].frame:Hide()',
                  'self:RestoreAll("immersion-off")',
                  'self:SubscribePreferences(function()',
                  'Logres.Layout.Bind(dock, "nativeAccess", "TOPRIGHT", "TOPRIGHT")',
                  'mainAndPetStockRetained = true'):
        if token not in code: errors.append('missing module token: '+token)
    for bad in ('OnUpdate', 'C_Timer.', 'hooksecurefunc', 'SetParent(',
                'SetAlpha(0)', 'SetCVar(', 'RegisterStateDriver(',
                'SetOverrideBinding', 'SetBinding('):
        if bad in code: errors.append('forbidden module token: '+bad)
if layout.is_file() and 'nativeAccess = {' not in layout.read_text(encoding='utf-8'):
    errors.append('nativeAccess integration anchor absent')
if commands.is_file():
    code=commands.read_text(encoding='utf-8')
    for token in ('local function runNativeAccessCheck()',
                  'Logres:GetModule("NativeAccess")',
                  'runNativeAccessCheck()',
                  'if command == "nativeuicheck" then',
                  'if command == "nativeui" then',
                  '"nativeAccessCheck",',
                  '{ "LogresNativeAccessDock", "nativeAccess" },'):
        if token not in code: errors.append('missing command token: '+token)
if toc.is_file():
    code=toc.read_text(encoding='utf-8')
    if 'Immersion\\NativeAccess.lua' not in code:
        errors.append('NativeAccess not loaded in TOC')
print('Logres P0172 native-access contract')
print('===================================')
for err in errors: print('ERROR:',err)
print('PASS: 0 errors' if not errors else 'FAIL: '+str(len(errors))+' errors')
sys.exit(bool(errors))
