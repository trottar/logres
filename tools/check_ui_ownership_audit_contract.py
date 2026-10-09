#!/usr/bin/env python3
"""P0178: expandable, non-mutating Blizzard/Logres ownership audit."""
from pathlib import Path
import re
ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / 'Logres/Core/UIOwnershipAudit.lua'
CMDS = ROOT / 'Logres/Core/Commands.lua'
TOC = ROOT / 'Logres/Logres.toc'
errors = []
if not SOURCE.is_file(): errors.append('UIOwnershipAudit.lua missing')
if not CMDS.is_file(): errors.append('Commands.lua missing')
if not TOC.is_file(): errors.append('Logres.toc missing')
if SOURCE.is_file():
    s = SOURCE.read_text(encoding='utf-8')
    required = (
        'function Logres:RegisterUIOwnershipSurface(spec)',
        'function Audit.Capture()',
        'if byID[spec.id] then',
        'local ok, evaluated = pcall(spec.evaluate, flags, snapshot)',
        'local moduleOK, status = pcall(module.GetDebugStatus, module)',
        'Blizzard retained',
        'Logres applied',
        'combat pending',
        'Logres released',
        '"PASS"', '"FAIL"', '"DEFERRED"', '"STOCK"',
        'status = entry.status',
        'flags.immersion', 'flags.combat',
    )
    for r in required:
        if r not in s: errors.append('missing invariant: '+r)
    registrations = re.findall(r'\bregister\("([a-z][a-z0-9_]*)"\s*,\s*"[^"\n]+"\s*,\s*"[^"\n]+"\s*,',s)
    if len(registrations)<30: errors.append(f'only {len(registrations)} inventory registrations; need >=30')
    if len(set(registrations))!=len(registrations): errors.append('duplicate inventory IDs')
    required_surfaces = ('quiet_chat','player_frame','target_frame','player_health','player_resource',
        'main_action','special_actions','bar2','bar3','bar4','bar5','pet_actions','player_class','allies',
        'navigation','objectives','progress','micro_menu','stock_cast','quest_offer','quest_other',
        'player_buffs','player_debuffs','target_auras','target_of_target','focus_boss','nameplates')
    for name in required_surfaces:
        if name not in registrations: errors.append('missing inventory domain: '+name)
    forbidden = ('GetAlpha(', 'IsShown(', ':Hide(', ':Show(', ':SetAlpha(',
        'GetAuraDataByIndex(', 'ShouldUnitAuraIndexBeSecret(',
        'C_UnitAuras.', 'C_NamePlate.', 'GetAttribute(', 'SetAttribute(',
        '_G[', 'hooksecurefunc(', 'C_Timer.', 'SetParent(')
    for pattern in forbidden:
        if pattern in s: errors.append('new audit must not inspect/mutate Blizzard state: '+pattern)
if CMDS.is_file():
    s=CMDS.read_text(encoding='utf-8')
    for r in ('function Logres:RunUIOwnershipCheck()',
              'Logres.UIOwnershipAudit.Capture()',
              '"uiownershipcheck"',
              '"uiOwnershipCheck"',
              'Logres:RunUIOwnershipCheck()'):
        if r not in s: errors.append('Commands missing: '+r)
    if 'local function runUIOwnershipCheck(' in s:
        errors.append('audit runner must not add a local upvalue to handleCommand')
    if s.count('Logres:RunUIOwnershipCheck()') != 3:
        errors.append('namespace method plus Run All and slash dispatch required')
    if s.count('"uiOwnershipCheck"') !=1: errors.append('Phase 0 UI action must appear exactly once')
    if s.count('if command == "uiownershipcheck" then')!=1: errors.append('uiownershipcheck dispatch must appear once')
    # Never add more than the Forever Lua limit of 60 captured locals to
    # handleCommand. This source guard is conservative; client test remains mandatory.
    start = s.find('local function handleCommand(message)')
    end = s.find('function Logres:RunDevCommand(', start)
    if start < 0 or end < start:
        errors.append('could not isolate slash command handler for upvalue budget')
    else:
        names = set(re.findall(r'(?m)^local\s+(?:function\s+)?([A-Za-z_]\w*)', s[:start]))
        names.add('Logres')  # second local in: local _, Logres = ...
        captured = [n for n in names if re.search(r'\b' + re.escape(n) + r'\b', s[start:end])]
        if len(captured) > 60:
            errors.append(f'handleCommand would capture {len(captured)} locals; Forever limit is 60')

if TOC.is_file():
    s=TOC.read_text(encoding='utf-8')
    if 'Core\\UIOwnershipAudit.lua' not in s: errors.append('TOC missing audit module')
    if not (s.find('Core\\Modules.lua')<s.find('Core\\UIOwnershipAudit.lua')<s.find('Core\\Commands.lua')):
        errors.append('audit source must load between module registry and commands')
print('Logres P0178 expandable UI ownership audit contract\n'+'='*54)
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: 0 errors; all inventory domains registered; non-mutating audit')
