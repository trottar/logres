#!/usr/bin/env python3
"""P0175 R3 regression: preference/lifecycle OFF must retain all status row tables."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
STATUS = ROOT / 'Logres/HUD/StatusAuras.lua'
COMMANDS = ROOT / 'Logres/Core/Commands.lua'
errors = []
source = STATUS.read_text(encoding='utf-8') if STATUS.is_file() else ''
commands = COMMANDS.read_text(encoding='utf-8') if COMMANDS.is_file() else ''

def require(haystack, fragment, label):
    if fragment not in haystack:
        errors.append('missing '+label+': '+fragment)

start = source.find('function StatusAuras:Refresh(reason, onlyUnit)')
end = source.find('function StatusAuras:SetPreview(enabled)', start)
refresh = source[start:end] if start >= 0 and end > start else ''
# This is the exact formerly-crashing transition. The first disabled snapshot
# lacked harmfulRows/helpfulRows and renderLane read rows[i] on nil.
disabled = re.search(
    r'elseif active then\s+snapshot = readUnit\(unit\)\s+else\s+snapshot = \{(.*?)\}\s+end\s+self\.last\[unit\]',
    refresh, flags=re.DOTALL)
if disabled is None:
    errors.append('cannot isolate disabled snapshot in StatusAuras:Refresh')
else:
    fields = disabled.group(1)
    for name in ('rows', 'harmfulRows', 'helpfulRows'):
        if not re.search(r'\b'+name+r'\s*=\s*\{\s*\}', fields):
            errors.append('disabled snapshot missing empty '+name+' table')
    require(fields, 'reason = "disabled"', 'disabled provenance')
    for key in ('failures', 'secretSkips', 'secretFields', 'duplicateUnknown'):
        if not re.search(r'\b'+key+r'\s*=\s*0', fields):
            errors.append('disabled snapshot missing zero '+key)

for s in (
    'renderLane(self.lanes.target, snapshot.harmfulRows, active and not useNative)',
    'renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)',
    'renderLane(self.lanes.player, snapshot.rows, active and not useNative)',
    'self:SubscribePreferences(function()',
    'self:Refresh("preference")',
    'function StatusAuras:OnDisable()',
    'self:Refresh("disable")',
):
    require(source, s, 'preference-safe status lane integration')
for s in ('local function runPreferenceCheck()', 'local function runLifecycleCheck()',
          '    runPreferenceCheck()', '    runLifecycleCheck()',
          '    runHUDCheck()', '    runStatusAuraCheck()'):
    require(commands, s, 'Run All preference/HUD/status coverage')

# The source-first and preview branches must also use the same lane table shape.
read_begin = source.find('local function readUnit(unit)')
read_end = source.find('local function createLane(', read_begin)
read_body = source[read_begin:read_end] if read_begin >= 0 and read_end > read_begin else ''
require(read_body, 'rows = {}, harmfulRows = {}, helpfulRows = {},', 'live empty row constructor')
require(refresh, 'harmfulRows = unit == "target" and PREVIEW.target or {},', 'preview harmful rows')
require(refresh, 'helpfulRows = unit == "target" and PREVIEW.targetHelpful or {},', 'preview helpful rows')

print('Logres P0175 R3 preference-transition status lane regression contract')
print('==============================================================')
if errors:
    for error in errors:
        print('ERROR: '+error)
    print('FAILED: %d error(s)' % len(errors))
    raise SystemExit(1)
print('PASS: 0 errors')
