#!/usr/bin/env python3
"""P0379: addon-owned quest Complete Quest button input provenance."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R/p).read_text(encoding="utf-8")
D = read("Logres/Quest/Dialogue.lua")
P = read("Logres/Dev/Panel.lua")
C = read("Logres/Quest/CompletionControl.lua")
T = read("Logres/Logres.toc")
B = read("Logres/Core/Bootstrap.lua")
I = read("docs/memory/investigations/ISSUE_LEDGER.md")
M = read("docs/memory/CURRENT.md")

def need(value, message):
    if not value:
        raise AssertionError("P0379: " + message)

checks = (
    'function Dialogue:RecordCompletionInput(phase)',
    'function Dialogue:CompletionInputStatus()',
    'owner:RecordCompletionInput("dispatch")',
    'self:RecordCompletionInput("enter")',
    'self:RecordCompletionInput("leave")',
    'self:RecordCompletionInput("down")',
    'self:RecordCompletionInput("up")',
    'acceptButton:HookScript("OnEnter", function()',
    'acceptButton:HookScript("OnLeave", function()',
    'acceptButton:HookScript("OnMouseDown", function()',
    'acceptButton:HookScript("OnMouseUp", function()',
    'completionInput = self:CompletionInputStatus()',
    'self.completionInputCounters = {',
    'if not self.completionActive or self.offerActionPreview then return end',
    'if not classified or secret ~= false then return nil end',
    'pcall(frame[method], frame)',
    'buttonShown = readOwnedFrameValue(self.acceptButton, "IsShown")',
    'buttonVisible = readOwnedFrameValue(self.acceptButton, "IsVisible")',
    'buttonMouseEnabled = readOwnedFrameValue(self.acceptButton, "IsMouseEnabled")',
    'buttonLeft = readOwnedFrameValue(self.acceptButton, "GetLeft")',
    'buttonRight = readOwnedFrameValue(self.acceptButton, "GetRight")',
    'buttonTop = readOwnedFrameValue(self.acceptButton, "GetTop")',
    'buttonBottom = readOwnedFrameValue(self.acceptButton, "GetBottom")',
    'buttonLevel = readOwnedFrameValue(self.acceptButton, "GetFrameLevel")',
    'actionRootShown = readOwnedFrameValue(self.completionActionRoot, "IsShown")',
    'actionRootMouseEnabled = readOwnedFrameValue(self.completionActionRoot, "IsMouseEnabled")',
)
for token in checks:
    need(token in D, "missing dialogue input diagnostic: " + token)
for event in ('enter','leave','down','up'):
    need(D.count('self:RecordCompletionInput("'+event+'")') == 1,
         "duplicate input hook: " + event)
need(D.count('owner:RecordCompletionInput("dispatch")') == 1,
     "click must trace only once")
need(D.index('owner:RecordCompletionInput("dispatch")') <
     D.index('owner:HandleCompletionAction()'),
     "click provenance must precede transaction")
# P0381 explicitly supersedes progress presentation ownership while preserving
# Blizzard ownership of the transition; P0241 still bans direct quest mutation.
need('function Dialogue:HandleQuestProgress()' in D and
     'Blizzard owns Continue on fallback' in D and
     'function Dialogue:ProgressGate()' in D and
     'self:RestoreProgressStock("progress-continue-click")' in D and
     'local called = pcall(_G.QuestProgressCompleteButton_OnClick)' in D and
     'pcall(CompleteQuest)' not in D,
     "progress handoff must be gated, native-owned and restorable")
for token in ('pcall(_G.QuestRewardCompleteButton_OnClick)',
              'self:Restore("claim-invoked")',
              'function Control:Gate()',
              'function Control:SelectChoice(index)'):
    need(token in C, "native reward invariant missing: " + token)
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'SetScript("OnUpdate"',
                  'GetMouseFocus(', 'GetMouseFoci('):
    need(forbidden not in D[D.index('local function readOwnedFrameValue('):
                               D.index('function Dialogue:HandleCompletionAction()')],
         "unsafe diagnostic route: " + forbidden)
need('incident.snapshot.completionInput = pickTraceStatus(' in P,
     "Report Bug snapshot missing")
for key in ('enterCount','downCount','upCount','dispatchCount','lastInput',
            'buttonShown','buttonVisible','buttonMouseEnabled',
            'buttonLeft','buttonRight','buttonTop','buttonBottom','buttonLevel',
            'actionRootShown','actionRootMouseEnabled'):
    need('"'+key+'"' in P[P.index('incident.snapshot.completionInput ='):],
         "incident field missing: " + key)
need(P.index('incident.snapshot.questCompletion =') <
     P.index('incident.snapshot.completionInput =') <
     P.index('incident.snapshot.completionView ='),
     "incident source order changed")
ver_toc = re.search(r'(?m)^## Version: (\S+)$', T)
ver_boot = re.search(r'Logres\.VERSION = "([^"]+)"', B)
need(ver_toc and ver_boot and ver_toc.group(1) == ver_boot.group(1),
     "TOC/Bootstrap runtime version mismatch")
for lid in ('L-002','L-005','L-020'):
    row = next((v for v in I.splitlines() if v.startswith('| '+lid+' |')), None)
    need(row and 'P0379' in row, "issue row lost P0379: " + lid)
need(len(M.encode("utf-8")) < 9800, "CURRENT must remain <9800 bytes")
H = read("docs/memory/handoffs/CURRENT_HANDOFF.md")
need(len(H.encode("utf-8")) < 8000, "HANDOFF must remain <8000 bytes")
for marker in ("P0379 R0", "P0379 R1", "P0379 R2"):
    need(marker in read("docs/memory/evidence/P0379_COMPLETION_INPUT_PROVENANCE.md"),
         "refusal/r2 evidence missing " + marker)
archive = read("docs/memory/handoffs/P0379_ACTIVE_MEMORY_COMPACTION_ARCHIVE.md")
for marker in ("P0357", "P0358", "P0359", "P0336", "P0328", "P0370", "P0352"):
    need(marker in archive, "historical exact-text archive missing " + marker)
need("R0 REFUSED" in H and "R1 REFUSED" in H,
     "handoff must retain both PREWRITE refusals")
need('P0378' in M and 'P0379' in M,
     "CURRENT lost verified baseline or next checkpoint")
for path in ('docs/memory/evidence/P0379_COMPLETION_INPUT_PROVENANCE.md',
             'docs/memory/patches/P0379_COMPLETION_INPUT_PROVENANCE.md'):
    need((R/path).is_file(), "missing evidence: " + path)
print('P0379 input provenance contract: PASS')
