#!/usr/bin/env python3
"""P0238: only accepted persisted options in a bounded user-facing panel."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
panel = (ROOT/'Logres/Settings/Panel.lua').read_text(encoding='utf-8')
toc = (ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
boot = (ROOT/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
cmd = (ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
prefs = (ROOT/'Logres/Core/Preferences.lua').read_text(encoding='utf-8')
errors=[]
def needs(source, items, scope):
    for item in items:
        if item not in source: errors.append(f'{scope}: missing {item}')
needs(panel, ['RegisterModule("SettingsPanel"', 'OnInitialize = function',
    'OnEnable = function', 'OnDisable = function',
    'SubscribePreferences', 'GetPreference("immersionEnabled")',
    'GetPreference("activeQuestEnabled")',
    'SetPreference("immersionEnabled"', 'SetPreference("activeQuestEnabled"',
    'function SettingsPanel:Refresh()', 'function SettingsPanel:Toggle()',
    'function Logres:ToggleSettingsPanel()', 'UIPanelCloseButton',
    'UIPanelButtonTemplate'], 'panel')
needs(cmd, ['if command == "settings" then',
    'Logres:ToggleSettingsPanel()', '"Settings UI"',
    '"settings",', '"D"'], 'commands')
needs(toc, ['Settings\\Panel.lua', 'Dev\\Panel.lua'], 'toc')
for setting in ['immersionEnabled','activeQuestEnabled']:
    if setting not in prefs: errors.append('preferences missing: '+setting)
for forbidden in ['Logres.db', 'SetAttribute(', 'RegisterStateDriver',
                  'C_Timer', 'issecretvalue', 'SetCVar(', 'UnitHealth(']:
    if forbidden in panel: errors.append('forbidden settings panel side effect '+forbidden)
if 'Settings\\Panel.lua' not in toc or toc.index('Settings\\Panel.lua') >= toc.index('Core\\Lifecycle.lua'):
    errors.append('settings module must load before lifecycle')
if len(re.findall(r'SetPreference\("(?:immersionEnabled|activeQuestEnabled)"',panel)) != 2:
    errors.append('only the two approved preference mutations are allowed')
a=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'Logres.VERSION = "([^"]+)"',boot)
if not a or not b or a.group(1)!=b.group(1):errors.append('runtime version mismatch')
print('P0238 minimal preference UI contract')
for e in errors:print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAIL: {len(errors)}')
raise SystemExit(bool(errors))
