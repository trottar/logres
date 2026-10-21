#!/usr/bin/env python3
"""P0286: exact native row shape evidence remains gated, read-only and fail-open."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
source=read('Logres/Quest/NativeTrainerServiceProbe.lua')
commands=read('Logres/Core/Commands.lua')
old=read('tools/check_p0285_trainer_service_source_contract.py')
evidence=read('docs/memory/evidence/P0286_TRAINER_SERVICE_SHAPE_DEFERRAL.md')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
errors=[]
def need(ok, desc):
    if not ok: errors.append(desc)
for value in (
    'if not ok or not ordinary(name) or not ordinary(subText)',
    'or not ordinary(category) or not ordinary(expanded) then',
    'state="deferred-secret-or-call"',
    'state="unexpected-service-shape"',
    'nameType=type(name)', 'subTextType=type(subText)',
    'categoryType=type(category)', 'expandedType=type(expanded)',
    'categoryValue=safeText(category, 32) or "unavailable"',
    'shape={', 'report.invalidRows=bad',
    'if row.state ~= "source-observed" then bad = bad + 1 end',
    'report.status="service-row-shape-deferred"',
    'report.status="read-only-service-sample"',
    'math.min(total, MAX_SAMPLE)', 'wallet=','trainerPurchases=0',
    'state.interactionType ~= 7', 'read(root, "IsProtected") ~= false',
): need(value in source, 'Missing safely gated shape/state '+value)
# Order is substantive: secret gate must precede all type/shape inspection.
gate=source.index('if not ok or not ordinary(name)')
shape=source.index('nameType=type(name)')
need(gate < shape, 'Shape inspected before ordinary-value gate')
for token in ('Logres trainer service shape:', 'nameType=%s', 'categoryValue=%s',
              'if item.shape then', 'tostring(shape.nameType)',
              'tostring(shape.categoryValue)', 'Native Service Frame Audit'):
    need(token in commands, 'Missing read-only source diagnostics '+token)
for token in ('BuyTrainerService(', 'SelectTrainerService(',
              'SetTrainerServiceTypeFilter(', 'SetScript("OnUpdate"',
              'SetPoint(', 'ClearAllPoints(', 'SetParent(', 'hooksecurefunc(',
              'SetAlpha('):
    need(token not in source, 'Probe must never mutate or hook '+token)
need('function Probe.Read()' in source and 'Logres.NPCNativeTrainerServiceProbe.Read()' in commands,
     'Preserve same P0285 read-only H action')
need('P0285' in old and 'snapshotRow' in source, 'Preserve prior source contract')
v=re.search(r'(?m)^## Version: (\S+)$',toc)
b=re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$',boot)
need(bool(v and b and v.group(1)==b.group(1)), 'TOC and Bootstrap versions differ')
for word in ('bbc9045','unexpected-service-shape', 'total=1',
             'walletCopper=12058','DEFERRED','OPEN', 'UNVERIFIED', 'NO NATIVE MUTATIONS'):
    need(word.lower() in evidence.lower(), 'Missing exact in-client failure evidence '+word)
need('CURRENT.md' in read('docs/memory/handoffs/CURRENT_HANDOFF.md'),
     'Missing repo authority in handoff')
print('P0286 native trainer row-shape deferral contract')
for e in errors: print('ERROR:',e)
if errors:raise SystemExit(1)
print('PASS: gated type diagnostics; old ownership and transaction boundaries maintained')
