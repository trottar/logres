#!/usr/bin/env python3
"""P0372 passive journal / explicit screenshot marker contract (static only)."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
def read(p): return (R / p).read_text(encoding='utf-8')
def need(ok, msg):
    if not ok: raise AssertionError('P0372 '+msg)

panel = read('Logres/Dev/Panel.lua')
modules = read('Logres/Core/Modules.lua')
probe = read('Logres/Quest/OfferActionProbe.lua')
gossip = read('Logres/Quest/NPCGossipPresentation.lua')
parking = read('Logres/Quest/NPCGossipStockParking.lua')
suppression = read('Logres/Quest/OfferStockSuppression.lua')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
current = read('docs/memory/CURRENT.md')
handoff = read('docs/memory/handoffs/CURRENT_HANDOFF.md')

for token in ('JOURNAL_EVENTS = 384', 'JOURNAL_INCIDENTS = 12',
              'JOURNAL_CONTEXT = 48', 'function Logres:TraceEvent(',
              'function Logres:CaptureBugIncident()', 'ordinaryTraceValue',
              'pcall(issecretvalue, value)', 'journal.dropped',
              'journal.pendingScreenshot = incident.id',
              'self:TraceEvent("incident", "button"',
              'Logres:RegisterEvent("SCREENSHOT_SUCCEEDED"',
              'Logres:RegisterEvent("SCREENSHOT_FAILED"',
              'Logres:RegisterEvent("PLAYER_LOGIN"',
              'Logres:SubscribeState(', 'Logres:SubscribePreferences(',
              'bugButton:SetText("Report Bug")',
              'bugButton:SetFrameStrata("LOW")',
              'bugButton:SetScript("OnClick"',
              'pcall(Screenshot)'):
    need(token in panel, 'missing journal/button boundary '+token)
for forbidden in ('SetPoint(', 'GetPoint(', 'UnitHealth(', 'UnitAura(',
                  'GetAuraDataByIndex(', 'SetAttribute(', 'GetPetActionInfo('):
    journal = panel[panel.index('-- P0372: bounded incident journal.'):panel.index('local createH2PanelBox')]
    need(forbidden not in journal, 'journal crosses native/protected or secret source '+forbidden)
for token in ('function Logres:GetModuleSnapshot()',
              'Logres:TraceEvent("module", "initialized"',
              'Logres:TraceEvent("module", "enabled"',
              'Logres:TraceEvent("module", "disabled"',
              'Logres:TraceEvent("module", "enable-failed"'):
    need(token in modules, 'missing addon-owned module lifecycle coverage '+token)
need('incident.snapshot.modules' in panel and 'self:GetModuleSnapshot()' in panel,
     'incident must capture all module lifecycle states')
# Source-safety invariants, independent of token-presence checks.
sanitizer = journal[journal.index('local function ordinaryTraceValue(value)'):
                    journal.index('local function ensureIncidentJournal()')]
need(sanitizer.index('pcall(issecretvalue, value)') < sanitizer.index('if value == nil'),
     'secret-capable value compared against nil BEFORE secret guard')
need(journal.index('if alreadyPending then') < journal.index('journal.pendingScreenshot = incident.id'),
     'a second screenshot request could misattribute the first result')
for token in ('Logres:TraceEvent("quest", "offer-seen"',
              'Logres:TraceEvent("quest", "action-call"',
              'Logres:TraceEvent("quest", "action-started"',
              'Logres:TraceEvent("quest", "action-blocked"',
              'Logres:TraceEvent("quest", "accepted"',
              'Logres:TraceEvent("quest", "finished"',
              'Logres:TraceEvent("quest", "world-transition"'):
    need(token in probe, 'quest transition missing '+token)
for token in ('Logres:TraceEvent("gossip", "shown"',
              'Logres:TraceEvent("gossip", "hidden"'):
    need(token in gossip, 'gossip transition missing '+token)
for token in ('Logres:TraceEvent("gossip", "parking-deferred"',
              'Logres:TraceEvent("gossip", "parked"',
              'Logres:TraceEvent("gossip", "restored"'):
    need(token in parking, 'parking transition missing '+token)
for token in ('Logres:TraceEvent("quest", "suppression-applied"',
              'Logres:TraceEvent("quest", "suppression-restored"',
              'Logres:TraceEvent("quest", "suppression-unsupported"',
              'Logres:TraceEvent("quest", "suppression-failed"'):
    need(token in suppression, 'suppression transition missing '+token)
need('## SavedVariables: LogresDB, LogresDiagnosticsDB' in toc,
     'saved diagnostic persistence lost')
need(len([line for line in toc.splitlines() if line.endswith('.lua')]) == 95,
     'do not change historical Lua inventory in this patch')
mt=re.search(r'(?m)^## Version: (\S+)$', toc)
mb=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', boot)
need(mt and mb and mt.group(1) == mb.group(1)
     and re.fullmatch(r'0\.0\.\d+-dev', mt.group(1)),
     'runtime version parity and format')
need('MAX_DIAGNOSTIC_RUNS = 100' in panel and 'MAX_DIAGNOSTIC_LINES = 120' in panel,
     'manual diagnostic run budget changed')
need('P0372' in current and 'P0372' in handoff and 'P0371' in handoff,
     'memory handoff missing')
need('L-021' in current and 'L-021' in handoff,
     'P0372 R3 regression: L-021 lost from canonical CURRENT/HANDOFF')
# P0371 R1 and P0372 R2 omitted historical milestone tokens in compact handoffs.
# Verify the entire continuity floor BEFORE invoking earlier source checkers.
for n in range(317, 372):
    milestone = f"P{n:04d}"
    need(milestone in current and milestone in handoff,
         'historical CURRENT/HANDOFF continuity lost: '+milestone)
for marker in ('P0354 R0', 'P0354 R1', 'P0354 R2', 'P0355 R0',
               'P0355 R1', 'P0358 R0', 'P0361 R0 handoff',
               'check_memory_health.py', 'cfdc07af', 'D-048',
               'L-019', 'UNVERIFIED'):
    need(marker in handoff, 'historical refusal/safety marker lost: '+marker)
need(len(current.encode('utf-8')) < 9800 and len(handoff.encode('utf-8')) <= 8000,
     'CURRENT/HANDOFF size cap')
for p in ('docs/memory/evidence/P0372_PASSIVE_JOURNAL_BUG_MARKER.md',
          'docs/memory/patches/P0372_PASSIVE_JOURNAL_BUG_MARKER.md'):
    s=read(p)
    for token in ('P0372', 'P0371', 'UNVERIFIED', 'SCREENSHOT_SUCCEEDED',
                  'L-001', 'L-002', 'L-005', 'L-019'):
        need(token in s, 'missing evidence '+token+' '+p)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'evidence text hygiene '+p)
need(len(list((R/'tools').glob('check_*.py'))) >= 242, 'missing static checker #242')
print('P0372 passive journal + report bug button: PASS (STATIC ONLY, WoW UNVERIFIED)')
