#!/usr/bin/env python3
"""P0363: quest-offer stock diagnostic ownership, preserving native fail-open UI (STATIC)."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

def need(condition, label):
    if not condition:
        raise AssertionError(label)

def getfn(text, signature):
    need(text.count(signature) == 1, 'missing/duplicated '+signature)
    a = text.index(signature)
    b = text.find('\nend\n', a)
    need(b > a, 'unterminated '+signature)
    return text[a:b+5]

C = read('Logres/Core/Commands.lua')
S = read('Logres/Quest/OfferStockSuppression.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')

wrapper = getfn(C, 'local function runQuestOfferStockSuppressionCheck()\n')
need(wrapper == 'local function runQuestOfferStockSuppressionCheck()\n'
     '    Logres:GetModule("QuestOfferStockSuppression"):RunDevQuestOfferStockSuppressionCheck(emit)\nend\n',
     'Commands must retain pure forwarding wrapper')
report = getfn(S, 'function Suppression:RunDevQuestOfferStockSuppressionCheck(emit)\n')
for token in (
    'Logres:GetModuleStatus("QuestOfferStockSuppression")',
    'Logres:GetModule("QuestOfferStockSuppression")',
    'suppression:GetDebugStatus()',
    'Logres:GetModule("QuestDialogue")',
    'dialogue:GetDebugStatus()',
    'dialogueDebug.presentationShown == true',
    'dialogueDebug.offerActionsEnabled == true',
    'dialogueDebug.offerActionPreview ~= true',
    'debugStatus.lastSupportReason == "supported"',
    'debugStatus.appliedEnabled ~= true',
    'debugStatus.snapshotReady ~= true',
    'debugStatus.appliedEnabled == true',
    'debugStatus.requestedEnabled == true',
    'debugStatus.snapshotReady == true',
    'status.initialized == true',
    'status.enabled == true',
    'debugStatus.moduleEnabled == true',
    'debugStatus.sourceCommit',
    '"15666a6e67938a1ab5caf041406464251db111ca"',
    'debugStatus.failureCount == 0',
    'debugStatus.lastError == nil',
    'ownershipCoherent',
    'not supportedOwnershipExpected',
    '"Logres questofferstocksuppressioncheck: %s (',
    '"Logres quest offer presentation: owned=%s capturedFrames=%s',
    'tostring(debugStatus.secretBlockCount)',
    'tostring(debugStatus.emergencyRestoreCount)',
    'tostring(debugStatus.visualOwned)',
    'tostring(debugStatus.visualFrameCount)',
):
    need(token in report, 'original stock offer report invariant missing: '+token)
need(report.count('emit(string.format(') == 2 and
     report.index('Logres questofferstocksuppressioncheck: %s (') <
     report.index('Logres quest offer presentation: owned=%s'),
     'original diagnostic emission shape/order changed')
for message in ('Logres questofferstocksuppressioncheck: %s (',
                'Logres quest offer presentation: owned=%s'):
    need(message not in C and report.count(message) == 1,
         'diagnostic report duplicated or missing in owner: '+message)
for forbidden in (
    'C_Timer.', 'RegisterEvent(', 'SetScript(', 'HookScript(',
    'SetAlpha(', 'EnableMouse(', 'SetParent(', 'SetPoint(',
    'SetAttribute(', 'RegisterStateDriver(', 'hooksecurefunc(',
    ':Show(', ':Hide(', 'GetAlpha(', 'IsShown(',
    'GetAttribute(', 'UnitHealth(', 'UnitPower(',
    'issecretvalue(', 'GetChildren(', 'SetPreference(',
    'AcceptQuest(', 'DeclineQuest(', 'CompleteQuest(',
    'RequestEnabled(', 'Reconcile(', 'Restore(',
):
    need(forbidden not in report, 'report gained live/secret/native operation: '+forbidden)
need(S.index('function Suppression:GetDebugStatus()') <
     S.index('function Suppression:RunDevQuestOfferStockSuppressionCheck('),
     'report not after addon-owned debug status')
for token in (
    '    runQuestOfferStockSuppressionCheck()',
    'if command == "questofferstocksuppressioncheck" then',
    '"Quest Offer Stock Check"',
    '"questofferstocksuppressioncheck"',
    '"questOfferStockSuppressionCheck",',
):
    need(token in C, 'Run All/slash/panel route lost: '+token)
need(C.index('    runQuestOfferControlsCheck()') <
     C.index('    runQuestOfferStockSuppressionCheck()') <
     C.index('    runPlayerHelpfulAuraCheck()'),
     'Run All quest-offer diagnostic ordering changed')
need('Quest\\OfferStockSuppression.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Quest\\OfferStockSuppression.lua') < T.index('Core\\Commands.lua'),
     'report owner must load before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     'Lua load inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'panel action inventory changed')
tv = re.search(r'(?m)^## Version: (\S+)$', T)
bv = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(bool(tv and bv and tv.group(1) == bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'dynamic Bootstrap/TOC parity or version format changed')
legacy = read('tools/check_quest_offer_stock_suppression_contract.py')
for required in (
    'snapshot.frame:SetAlpha(snapshot.alpha)',
    'snapshot.frame:EnableMouse(snapshot.mouseEnabled)',
    'type(snapshot.alpha)',
    'QuestFrame:Hide',
    'P0168 must fail open on secret-capable child references',
    'QuestFrame subtree walk',
    'Logres:GetModule("QuestOfferStockSuppression"):RunDevQuestOfferStockSuppressionCheck(emit)',
    'function Suppression:RunDevQuestOfferStockSuppressionCheck(emit)',
    '"Logres questofferstocksuppressioncheck: %s',
):
    need(required in legacy, 'historical P0165/P0168 safety/diagnostic check weakened: '+required)
prior = read('tools/check_p0362_stock_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 233" in prior and
     'RunDevStockReplacementCheck(emit, boolText)' in prior,
     'P0362 stock replacement ownership or inventory floor lost')
for token in ('P0363','P0362','P0361','P0360','P0359','P0358',
              'P0357','P0356','P0355','P0354','P0353','P0352',
              'P0351','P0350','P0349','P0348','P0347','P0346',
              'P0321','D-048','UNVERIFIED','L-019','L-022',
              'L-027','L-028','L-031','cfdc07af'):
    need(token in CUR and token in HAND, 'CURRENT/HANDOFF continuity lost '+token)
for n in range(317,364):
    need(f'P{n:04d}' in HAND, 'milestone P%04d lost'%n)
for n in range(317,338):
    need(f'P{n:04d}' in CUR, 'CURRENT historical milestone lost P%04d'%n)
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) <= 8000,
     'CURRENT/HANDOFF memory budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md', 'docs/memory/patches/PATCH_INDEX.md'):
    need('P0363' in read(path) and 'P0362' in read(path),
         'durable checkpoint missing '+path)
for path in ('docs/memory/evidence/P0363_QUEST_OFFER_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0363_QUEST_OFFER_DIAGNOSTIC_SEAM.md'):
    note = read(path)
    for token in ('P0363','P0362','P0321','234','UNVERIFIED','OPEN'):
        need(token in note, 'new evidence marker missing '+path+': '+token)
    need(note.endswith('\n') and not note.endswith('\n\n') and '\r' not in note,
         'new evidence newline hygiene '+path)
need(all(x in HAND for x in ('P0354 R0','P0354 R1','P0354 R2',
                            'P0355 R0','P0355 R1','P0358 R0',
                            'P0361 R0 handoff','check_memory_health.py')),
     'historic failed-candidate evidence lost')
need(len(list((ROOT/'tools').glob('check_*.py'))) == 234,
     'expected 234 static checkers')
print('P0363 quest-offer stock diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
