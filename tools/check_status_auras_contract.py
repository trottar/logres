#!/usr/bin/env python3
"""P0175: production additive priority status and fail-open aura boundary."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
addon = root / 'Logres'
p = addon / 'HUD' / 'StatusAuras.lua'
toc = addon / 'Logres.toc'
c = addon / 'Core' / 'Commands.lua'
b = addon / 'Core' / 'Bootstrap.lua'
errors=[]
for f in (p,toc,c,b):
    if not f.is_file(): errors.append(f'missing {f.relative_to(root)}')
source=p.read_text(encoding='utf-8') if p.is_file() else ''
commands=c.read_text(encoding='utf-8') if c.is_file() else ''
txt=toc.read_text(encoding='utf-8') if toc.is_file() else ''
bootstrap=b.read_text(encoding='utf-8') if b.is_file() else ''
for token in (
    'RegisterModule("StatusAuras"',
    '"HARMFUL|CROWD_CONTROL"', '"HARMFUL|RAID"',
    '"HARMFUL|PLAYER"', '"HELPFUL|DISPELLABLE"',
    '"HELPFUL|IMPORTANT"', '"HELPFUL|BIG_DEFENSIVE"',
    'C_Secrets.ShouldUnitAuraIndexBeSecret',
    'C_UnitAuras.GetAuraDataByIndex',
    'if isSecret(predicate) then', 'if isSecret(aura) then',
    'if isSecret(icon) then', 'if isSecret(instanceID)',
    'GameTooltip.SetUnitAura', 'GameTooltip:SetOwner',
    '"PLAYER_TARGET_CHANGED"', '"UNIT_AURA"',
    '"PLAYER_ENTERING_WORLD"', 'function StatusAuras:SetPreview(enabled)',
    'function StatusAuras:GetDebugStatus()',
    'Logres.Layout.Bind(root, anchorKey',
    'stockPreserved = true', 'eventsReady = self.unitAuraRegistered == true',
    '{ filter = "HELPFUL", kind = "helpful" }',
):
    if token not in source: errors.append('StatusAuras missing '+token)
for forbidden in (
    'SetScript("OnUpdate"', 'C_Timer.After', 'C_Timer.NewTicker',
    'GetUnitAuras', 'GetAuraDataBySlot', 'GetAuraSlots',
    'UnitAura(', 'addedAuras', 'updatedAuraInstanceIDs',
    'BuffFrame:Hide', 'DebuffFrame:Hide', 'TargetFrame:Hide',
    'SetCVar(', 'RegisterStateDriver', 'SetParent(',
):
    # Allow only the trusted, native GameTooltip.SetUnitAura method.
    if forbidden == 'UnitAura(' and source.count('UnitAura(') == source.count('GameTooltip.SetUnitAura,'):
        continue
    if forbidden in source: errors.append('forbidden status scope '+forbidden)
pred=source.find('local ok, predicate = pcall(')
secret=source.find('if isSecret(predicate) then')
compare=source.find('if predicate ~= false then')
query=source.find('local queryOK, aura = pcall(')
auraSecret=source.find('if isSecret(aura) then')
auraNil=source.find('if aura == nil then')
icon=source.find('local icon = aura.icon')
iconSecret=source.find('if isSecret(icon) then')
if not (-1 not in (pred,secret,compare,query,auraSecret,auraNil,icon,iconSecret)
        and pred < secret < compare < query < auraSecret < auraNil < icon < iconSecret):
    errors.append('secret-first read order invalid')
for token in (
    'local function runStatusAuraCheck()',
    'local function runStatusAuraPreview(argument)',
    '"Logres statusauracheck: %s',
    'if command == "statusauracheck" then',
    'if command == "statusaurapreview" then',
    'runStatusAuraCheck()',
    'targetEvidence=%s',
    '"statusAuraCheck"',
    '"statusAuraPreviewOn"',
    '"statusAuraPreviewOff"',
):
    if token not in commands: errors.append('Commands missing '+token)
allStart=commands.find('local function runAllChecks()')
allEnd=commands.find('local function handleHUDPreview',allStart)
if not (allStart>=0 and allEnd>allStart and 'runStatusAuraCheck()' in commands[allStart:allEnd]):
    errors.append('Run All missing status aura check')
if 'HUD\\StatusAuras.lua' not in txt:
    errors.append('TOC missing StatusAuras')
else:
    if not (txt.index('HUD\\PlayerHelpfulAuras.lua') < txt.index('HUD\\StatusAuras.lua') < txt.index('Core\\Commands.lua')):
        errors.append('TOC order wrong')
match1=re.search(r'Logres\.VERSION = "([^"]+)"',bootstrap)
match2=re.search(r'^## Version: (.+)$',txt,re.M)
if not match1 or not match2 or match1.group(1)!=match2.group(1):
    errors.append('version mismatch')
print('Logres P0175 additive priority aura contract')
print('==========================================')
if errors:
    for item in errors: print('ERROR:',item)
    print('FAILED:',len(errors),'errors')
    raise SystemExit(1)
print('PASS: 0 errors')
