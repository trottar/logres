#!/usr/bin/env python3
"""P0369 live diagnostic-export contract; synthetic filesystem only, no WoW I/O."""
from pathlib import Path
import importlib.util
import re
import tempfile

ROOT = Path(__file__).resolve().parents[1]


def read(path):
    return (ROOT / path).read_text(encoding='utf-8')


def need(condition, message):
    if not condition:
        raise AssertionError(message)


source = read('tools/export_panel_diagnostics.py')
need("LIVE_PATTERN = '_forever_/WTF/Account/*/SavedVariables/Logres.lua'" in source,
     'live Forever account SavedVariables discovery lost')
need("'_classic_beta_/WTF/Account" not in source and 'shutil.copy2' not in source,
     'beta-only source or unsafe overwrite restored')
for token in ('LogresDiagnosticsDB', 'No LIVE Forever Logres SavedVariables',
              'Existing {output} was NOT refreshed', 'os.replace(',
              'NamedTemporaryFile(', '--wow-root', '--output',
              'LIVE Forever SavedVariables copied'):
    need(token in source, 'live export behavior missing '+token)
need(not re.search(r'\b0\.0\.\d+-dev\b',source),
     'exporter must not freeze runtime version')

spec = importlib.util.spec_from_file_location('p0369_live_exporter', ROOT/'tools/export_panel_diagnostics.py')
need(bool(spec and spec.loader), 'cannot load diagnostic exporter')
module = importlib.util.module_from_spec(spec)
spec.loader.exec_module(module)
with tempfile.TemporaryDirectory(prefix='p0369-export-') as tmp:
    root = Path(tmp)
    destination = root/'LOGRES_DIAGNOSTICS_LATEST.lua'
    destination.write_bytes(b'ORIGINAL STALE COPY\n')
    beta = root/'_classic_beta_'/'WTF'/'Account'/'Fake'/'SavedVariables'/'Logres.lua'
    beta.parent.mkdir(parents=True)
    beta.write_bytes(b'LogresDiagnosticsDB = { runs = { [1] = { command = "old" } } }\n')
    try:
        module.export(root, destination)
    except ValueError as exc:
        need('No LIVE Forever' in str(exc), 'no-live error must distinguish live versus beta')
    else:
        raise AssertionError('beta-only diagnostics must never be used as live')
    need(destination.read_bytes() == b'ORIGINAL STALE COPY\n',
         'missing live source overwrote stale artifact')
    live = root/'_forever_'/'WTF'/'Account'/'AccountA'/'SavedVariables'/'Logres.lua'
    live.parent.mkdir(parents=True)
    live.write_bytes(b'LogresDB = {}\n')
    try:
        module.export(root, destination)
    except ValueError as exc:
        need('no serialized LogresDiagnosticsDB' in str(exc),
             'invalid live SavedVariables must be explicitly refused')
    else:
        raise AssertionError('invalid live saved variables passed')
    need(destination.read_bytes() == b'ORIGINAL STALE COPY\n',
         'invalid live source overwrote stale artifact')
    content = b'LogresDiagnosticsDB = {schema = 1, runs = {{command = "gossipstockstatus"}}}\n'
    live.write_bytes(content)
    need(module.export(root, destination) == live, 'live exporter selected wrong source')
    need(destination.read_bytes() == content, 'live exported bytes differ')
    second = root/'_forever_'/'WTF'/'Account'/'AccountB'/'SavedVariables'/'Logres.lua'
    second.parent.mkdir(parents=True)
    second.write_bytes(b'LogresDiagnosticsDB = {schema = 1, runs = {}}\n')
    import os
    os.utime(live, ns=(1000000000,1000000000))
    os.utime(second, ns=(2000000000,2000000000))
    need(module.export(root, destination) == second,
         'newest matching live SavedVariables must be selected')
    need(destination.read_bytes() == second.read_bytes(),
         'selected newest live export content differs')

for path in ('docs/memory/evidence/P0369_LIVE_DIAGNOSTIC_EXPORT_RECOVERY.md',
             'docs/memory/patches/P0369_LIVE_DIAGNOSTIC_EXPORT_RECOVERY.md'):
    note = read(path)
    for marker in ('P0369','P0368','P0321','_forever_',
                   '2026-11-04','gossip','quest','pet',
                   'UNVERIFIED','BLOCKED'):
        need(marker in note, 'missing live evidence marker '+marker+' '+path)
    need(note.endswith('\n') and not note.endswith('\n\n') and '\r' not in note,
         'evidence newline hygiene '+path)
    need('P0369 R0 applier passed 12 blob guards' in note and '9809' in note,
         'P0369 R0 memory-budget refusal evidence absent '+path)
    need('gossiplivetoggle' in note and 'native-close-issued' in note,
         'uploaded live diagnostic distinction missing '+path)
    need('P0369 R1 PREWRITE STATIC 206/240 REFUSED' in note,
         'P0369 R1 checker/evidence refusal missing '+path)

current = read('docs/memory/CURRENT.md')
handoff = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
for marker in ('P0369','P0368','P0367','P0321','L-019','L-021','L-001',
               'L-022','L-027','L-028','UNVERIFIED','cfdc07af'):
    need(marker in current and marker in handoff,
         'current/handoff continuity missing '+marker)
need(len(current.encode('utf-8'))<9800 and len(handoff.encode('utf-8'))<=8000,
     'memory summary size limit exceeded')
for path in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
             'docs/memory/patches/PATCH_INDEX.md','docs/memory/investigations/ISSUE_REGISTER.md',
             'docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md'):
    need('P0369' in read(path), 'missing durable live evidence in '+path)
prior = read('tools/check_p0368_nov04_freeze_gate_contract.py')
need("glob('check_*.py'))) >= 239" in prior,
     'P0368 checker count must be a historical floor')
need(len(list((ROOT/'tools').glob('check_*.py'))) >= 240,
     'P0369 static checker inventory missing')
print('P0369 live diagnostic exporter: PASS (STATIC, runtime failures OPEN)')
