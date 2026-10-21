#!/usr/bin/env python3
"""P0287: numeric service categories are raw evidence, never guessed permissions."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda path:(R/path).read_text(encoding='utf-8')
source=read('Logres/Quest/NativeTrainerServiceProbe.lua')
commands=read('Logres/Core/Commands.lua')
evidence=read('docs/memory/evidence/P0287_TRAINER_NUMERIC_CATEGORY.md')
old=read('tools/check_p0286_trainer_shape_diagnostic_contract.py')
errors=[]
def need(ok, why):
    if not ok: errors.append(why)
for token in (
    'local numericCategory = cappedInteger(category, 255)',
    'if not label or (not categoryKnown and not numericCategory) then',
    'state=numericCategory and "numeric-category-unclassified" or "source-observed"',
    'rawNumericCategory=numericCategory and category or nil',
    'rawExpansion=cappedInteger(expanded, 255) and expanded or nil',
    'category=numericCategory and "numeric-unclassified" or category',
    'state="unexpected-service-shape"',
    'categoryValue=safeText(category, 32) or "unavailable"',
    'if row.state ~= "source-observed" then bad = bad + 1 end',
    'if bad > 0 then report.status="service-row-shape-deferred" end',
    'return ok and secret == false',
    'math.min(total, MAX_SAMPLE)',
    'read(root, "IsProtected") ~= false',
    'read(root, "IsShown") ~= true',
    'state.interactionType ~= 7',
): need(token in source,'source requirement missing: '+token)
gate=source.find('if not ok or not ordinary(name)')
num=source.find('local numericCategory = cappedInteger(category, 255)')
need(gate>=0 and num>gate,'numeric category inspection must follow four ordinary gates')
need('tostring(item.rawNumericCategory or "unavailable")' in commands,'raw category not exported safely')
need('tostring(item.rawExpansion or "unavailable")' in commands,'raw expansion not exported safely')
need('Logres trainer service shape:' in commands,'P0286 diagnostic removed')
for bad in ('BuyTrainerService(', 'SelectTrainerService(', 'SetTrainerServiceTypeFilter(',
            'SetScript("OnUpdate"', 'hooksecurefunc(', 'ClearAllPoints(',
            'SetPoint(', 'SetParent(', 'SetAlpha('):
    need(bad not in source,'forbidden native write/hook: '+bad)
for word in ('cb8b756','Forever 1.60.1','number','numeric-category-unclassified',
             'raw category','DEFERRED','NO NATIVE MUTATIONS','12,058'):
    need(word.lower() in evidence.lower(),'P0287 evidence missing '+word)
need('P0286' in old, 'P0286 negative-result checker absent')
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'), 'memory authority missing')
a=re.search(r'(?m)^## Version: (\S+)$',read('Logres/Logres.toc'))
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua'))
need(bool(a and b and a.group(1)==b.group(1)), 'version consistency')
for item in errors: print('ERROR:',item)
print('P0287 trainer numeric-category raw-evidence contract')
if errors: raise SystemExit(1)
print('PASS: typed numeric category remains unclassified; Blizzard service ownership preserved')
