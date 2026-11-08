#!/usr/bin/env python3
"""P0371: single saved, bounded, non-mutating NPC incident bundle. Static only."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
def read(p): return (ROOT / p).read_text(encoding='utf-8')
def need(condition, reason):
    if not condition: raise AssertionError('P0371 '+reason)

C = read('Logres/Core/Commands.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
D = read('docs/memory/CURRENT.md')
H = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
N = read('docs/memory/investigations/ISSUE_REGISTER.md')

start = C.index('function Logres:RunNPCDiagnosticBatch()')
stop = C.index('local function handleCommand(message)', start)
batch = C[start:stop]
route_end = C.index('function Logres:RunDevCommand(', stop)
route = C[stop:route_end]
need('if command == "npcbatch" then\n        Logres:RunNPCDiagnosticBatch()\n        return'
     in route, 'dispatcher must only forward to module method')
expected = ('gameplaycapture', 'gossipstockstatus', 'gossiplivestatus',
            'gossipsourcecheck', 'questdialoguecheck', 'questoffercontrolscheck',
            'questofferstocksuppressioncheck', 'questinteractionprobe')
positions = []
for cmd in expected:
    token = '"' + cmd + '"'
    need(batch.count(token) == 1, 'missing or duplicate read-only subcheck '+cmd)
    positions.append(batch.index(token))
need(positions == sorted(positions), 'NPC command order changed')
for forbidden in ('gossipstocktoggle','gossiplivetoggle','questofferacceptprobe',
                  'questofferdeclineprobe','SelectAvailableQuest','SelectActiveQuest',
                  'SetPoint(', 'ClearAllPoints(', 'SetAttribute(', 'SetOverrideBinding',
                  'C_Timer.', 'OnUpdate', 'OnEvent', 'CloseGossip(', 'TriggerAction('):
    need(forbidden not in batch, 'native mutation/unsafe check in batch: '+forbidden)
for token in ('pcall(self.RunDevCommand, self, check, boundedOutput)',
              'local sourceOutput = activeOutput or print',
              'sourceOutput("Logres npcbatch: end',
              'local MAX_NPC_BATCH_LINES = 110',
              'Logres npcbatch: TRUNCATED', 'Logres npcbatch: subcheck-error',
              'Logres npcbatch: begin', 'Logres npcbatch: end'):
    need(token in batch, 'R1 method persistence/error/boundary missing '+token)
need(batch.index('local sourceOutput = activeOutput or print')
     < batch.index('pcall(self.RunDevCommand, self, check, boundedOutput)'),
     'original sink must be captured before nested subcheck')
# P0329 source budget: code before handleCommand defines up to 60 local names
# including the Logres namespace; a new capture here was R0's 166/241 FAIL.
names=set(re.findall(r'(?m)^local\s+(?:function\s+)?([A-Za-z_]\w*)', C[:stop]))
names.add('Logres')
captures=[n for n in names if re.search(r'\b'+re.escape(n)+r'\b',route)]
need(len(captures)<=60, f'R0 handleCommand upvalue budget recurred: {len(captures)}/60')
need('activeOutput' not in route, 'dispatcher captures activeOutput (R0 regression)')
need('if output == nil and type(message) == "string"' in C,
     'existing slash command save path missing')
need('panel:BeginDiagnosticRun("gameplaycapture")' in C,
     'original gameplaycapture saved run changed')
need('panel:BeginDiagnosticRun("npcbatch")' in C,
     'NPC slash result not persisted as one run')
need('local lines = run.lines' in C and 'while #lines > 120 do' in C,
     'existing bounded SavedVariables persistence lost')
need('npcbatch  (one-shot saved read-only NPC incident)' in C,
     'help route not advertised')

matches = re.findall(r'Logres:RegisterDevPanelAction\(\s*"([^\"]+)",\s*"([^\"]+)",\s*"([^\"]+)",\s*"([0A-HP])"\s*\)',C)
need(len(matches)==121, 'developer-panel action count changed')
need(sum(1 for _,_,_,ph in matches if ph=='P')==39, 'preview action count changed')
need('## SavedVariables: LogresDB, LogresDiagnosticsDB' in T,
     'saved diagnostic DB removed')
need(len([l for l in T.splitlines() if l.endswith('.lua')])==95,
     'loaded Lua inventory changed')
mt=re.search(r'(?m)^## Version: (\S+)$',T)
mb=re.search(r'(?m)^Logres.VERSION = "([^\"]+)"$',B)
need(mt is not None and mb is not None and mt.group(1)==mb.group(1) and
     re.fullmatch(r'0\.0\.\d+-dev',mt.group(1)), 'TOC/Bootstrap version parity')
need(len(list((ROOT/'tools').glob('check_*.py')))>=241, 'expected 241 static checks')
need(len(D.encode('utf-8'))<9800 and len(H.encode('utf-8'))<=8000,
     'canonical current/handoff memory size caps')
# R2: preserve historical continuity, including the exact R1 199/241 refusal.
for n in range(317,371):
    need(f'P{n:04d}' in H, f'R1 regression: handoff lost P{n:04d}')
for n in range(346,372):
    token=f'P{n:04d}'
    need(token in D and token in H, 'historical CURRENT/HANDOFF lost '+token)
for token in ('P0354 R0','P0354 R1','P0354 R2','P0355 R0','P0355 R1',
              'P0358 R0','P0361 R0 handoff','check_memory_health.py',
              'cfdc07af','D-048','UNVERIFIED','L-019'):
    need(token in H, 'historical handoff refusal/safety marker lost '+token)
for token in ('P0371','P0370','P0369','P0321','L-001','L-019','D-048',
              'UNVERIFIED'):
    need(token in D and token in H, 'CURRENT/HANDOFF continuity missing '+token)
for token in ('L-001','L-002','L-005','L-019','P0371','P0370'):
    need(token in N, 'issue state continuity missing '+token)
# Retain the exact negative PREWRITE evidence for R0; static may not claim runtime PASS.
for p in ('docs/memory/evidence/P0371_NPC_DIAGNOSTIC_BATCH.md',
          'docs/memory/patches/P0371_NPC_DIAGNOSTIC_BATCH.md'):
    note=read(p)
    need('P0371 R0 PREWRITE STATIC 166/241 REFUSED' in note and
         'check_p0329_gameplay_capture_contract.py' in note and
         'handleCommand upvalue budget exceeded' in note,
         'R0 regression evidence missing '+p)

for p in ('docs/memory/evidence/P0371_NPC_DIAGNOSTIC_BATCH.md',
          'docs/memory/patches/P0371_NPC_DIAGNOSTIC_BATCH.md'):
    note=read(p)
    need('P0371 R1 PREWRITE STATIC 199/241 REFUSED' in note and
         'check_p0362_stock_diagnostic_seam_contract.py' in note and
         'CURRENT/HANDOFF historical continuity lost: P0362' in note,
         'R1 failure evidence missing '+p)

for p in ('docs/memory/evidence/P0371_NPC_DIAGNOSTIC_BATCH.md',
          'docs/memory/patches/P0371_NPC_DIAGNOSTIC_BATCH.md'):
    s=read(p)
    for token in ('P0371','P0370','P0321','L-001','L-019','UNVERIFIED','BLOCKED'):
        need(token in s, 'evidence missing '+token+' '+p)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'evidence LF/EOF hygiene '+p)
for p in ('docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md',
          'docs/memory/roadmap/LAUNCH_READINESS.md'):
    text=read(p)
    need('P0371' in text and 'P0370' in text,
         'roadmap checkpoint missing '+p)
print('P0371 NPC incident bundle contract: PASS (STATIC, WoW UNVERIFIED)')
