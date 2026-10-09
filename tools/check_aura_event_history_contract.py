#!/usr/bin/env python3
"""P0180: bounded event-latched aura comparison; no native UI mutation."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
E=(ROOT/'Logres/HUD/AuraSourceEngine.lua').read_text(encoding='utf-8')
S=(ROOT/'Logres/HUD/StatusAuras.lua').read_text(encoding='utf-8')
C=(ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
for needle in (
    'function Engine.ObserveEvent(unit, event)',
    'function Engine.GetEventHistory()',
    'function Engine.NoteEventFailure()',
    'if isSecret(unit) or (unit ~= "player" and unit ~= "target")',
    'if isSecret(event) or (event ~= "UNIT_AURA" and',
    'if not APIsReady() then return end',
    'ordinaryBoolean(UnitCanAttack, "player", "target")',
    'ordinaryBoolean(UnitIsFriend, "player", "target")',
    'h.baseMax = math.max(h.baseMax, base.ordinary)',
    'if base.ordinary > 0 or base.secret > 0 or base.failures > 0 then',
    'h.hostileMax = math.max(h.hostileMax, base.ordinary)',
    'return { groups = groups, unexpectedFailures = unexpectedFailures,',
):
    if needle not in E: errors.append('engine missing '+needle)
for needle in (
    'event == "UNIT_AURA" or event == "PLAYER_TARGET_CHANGED"',
    'and not self.preview',
    'if preferences.immersionEnabled == true then',
    'Logres.AuraSourceEngine.ObserveEvent, observedUnit, event',
    'Logres.AuraSourceEngine.NoteEventFailure()',
):
    if needle not in S: errors.append('status event hook missing '+needle)
for needle in (
    'Logres.AuraSourceEngine.GetEventHistory()',
    'Logres aura event %s:',
    'Logres aura event diagnostic: FAIL',
    'session-only, preview-excluded',
):
    if needle not in C: errors.append('status check missing '+needle)
start=S.index('eventFrame:SetScript("OnEvent"')
end=S.index('self.eventFrame = eventFrame',start)
hook=S[start:end]
if hook.index('if isSecret(unit) then') >= hook.index('Logres.AuraSourceEngine.ObserveEvent'):
    errors.append('event-unit secret guard must precede observation')
if hook.index('self:Refresh(event, unit)') >= hook.index('Logres.AuraSourceEngine.ObserveEvent'):
    errors.append('render refresh must precede read-only observation')
if E.count('function Engine.ObserveEvent(')!=1: errors.append('duplicate event observer')
for bad in ('SetScript("OnUpdate"','RegisterEvent(','RegisterUnitEvent(',
            'C_Timer.','SetTexture(', 'GetAuraSlots', 'GetAuraDataBySlot',
            'addedAuras','updatedAuraInstanceIDs','SetParent(', ':Hide()'):
    if bad in E: errors.append('forbidden engine mutation/inspection '+bad)
# Existing 60-upvalue handler is closed to new captured helper locals.
handler=C.split('local function handleCommand(message)',1)[-1]
if 'local function runAuraEventHistoryCheck' in C:
    errors.append('new local helper risks slash handler upvalue overflow')
print('Logres P0180 aura event history contract')
print('========================================')
if errors:
    for msg in errors: print('ERROR:',msg)
    raise SystemExit(1)
print('PASS: 0 errors')
