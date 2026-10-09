#!/usr/bin/env python3
"""P0177: independent, read-only comparison of canonical and priority aura filters."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
engine=(ROOT/'Logres/HUD/AuraSourceEngine.lua').read_text(encoding='utf-8')
commands=(ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
toc=(ROOT/'Logres/Logres.toc').read_text(encoding='utf-8')
errors=[]
for token in (
    'Logres.AuraSourceEngine = Engine', 'function Engine.Capture()',
    'MAX_INDEX = 12', 'MAX_CANDIDATES = 5',
    'key = "playerHarmful", unit = "player", baseline = "HARMFUL"',
    'key = "targetHarmful", unit = "target", baseline = "HARMFUL"',
    'key = "targetHelpful", unit = "target", baseline = "HELPFUL"',
    'C_Secrets.ShouldUnitAuraIndexBeSecret, unit, index, filter',
    'elseif isSecret(protected) then', 'elseif protected == true then',
    'elseif protected ~= false then',
    'C_UnitAuras.GetAuraDataByIndex, unit, index, filter',
    'elseif isSecret(aura) then', 'elseif aura == nil then',
    'if isSecret(icon) then', 'if isSecret(applications) then',
    'state.candidates[#state.candidates + 1]',
    'if not ok or isSecret(present) then',
):
    if token not in engine: errors.append('missing engine invariant: '+token)
for forbidden in (
    'SetScript("OnUpdate"', 'C_Timer.', 'SetParent(', ':Hide()',
    'BuffFrame', 'DebuffFrame', 'TargetFrame', 'addedAuras',
    'removedAuraInstanceIDs', 'GetAuraSlots', 'GetAuraDataBySlot',
    'SetTexture(', 'RegisterEvent(', 'RegisterUnitEvent(',
    'GetTime(', 'UnitAura(', 'issecretvalue(aura.icon)',
):
    if forbidden in engine: errors.append('forbidden source-engine scope: '+forbidden)
if not (engine.index('isSecret(protected)') < engine.index('protected == true')
        < engine.index('C_UnitAuras.GetAuraDataByIndex, unit, index, filter')
        < engine.index('isSecret(aura)') < engine.index('aura == nil')
        < engine.index('local icon = aura.icon') < engine.index('isSecret(icon)')):
    errors.append('secret-first source comparison ordering')
section=commands.split('local function runStatusAuraCheck()',1)[-1].split('local function runStatusAuraPreview(argument)',1)[0]
for token in ('Logres.AuraSourceEngine.Capture()',
              'if d.preview then',
              'Logres aura source engine: DEFERRED (preview active)',
              'elseif not shouldShow then',
              'Logres aura source engine: DEFERRED (Immersion OFF)',
              'Logres aura source %s: base ordinary=%s secret=%s failures=%s',
              'source.key,'):
    if token not in section: errors.append('missing Phase H comparison: '+token)
if section.find('if d.preview then') > section.find('Logres.AuraSourceEngine.Capture()'):
    errors.append('preview guard must precede capture')
if not (r'HUD\PlayerHelpfulAuras.lua' in toc and r'HUD\AuraSourceEngine.lua' in toc and r'HUD\StatusAuras.lua' in toc):
    errors.append('TOC source engine missing')
else:
    if not (toc.index(r'HUD\PlayerHelpfulAuras.lua') < toc.index(r'HUD\AuraSourceEngine.lua') < toc.index(r'HUD\StatusAuras.lua')):
        errors.append('source engine load order wrong')
if 'RegisterDevPanelAction' in engine or 'RegisterModule(' in engine:
    errors.append('comparison may not add panel buttons or lifecycle modules')
print('Logres P0177 independent aura source engine contract')
print('====================================================')
if errors:
    for e in errors: print('ERROR: '+e)
    raise SystemExit(1)
print('PASS: 0 errors')
