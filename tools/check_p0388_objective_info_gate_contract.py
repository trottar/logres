#!/usr/bin/env python3
"""P0388 scoped objective native information source contract."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
p=(r/'Logres/Quest/Progress.lua').read_text()
checks={
    'scoped method ownership': 'frame.ShouldDisplayMessageType = scopedPolicy' in p,
    'original native decision': 'pcall(prior, owner, messageType, message)' in p,
    'only addon owned pulse': 'self.nativePulseQuestID ~= self.currentQuestID' in p and 'not self.pulseShown' in p,
    'live sanitized resample': 'self:Refresh("native-objective-info", false)' in p,
    'unknown format pass-through': 'if format == nil then return false end' in p,
    'unmatched pass-through': 'return nativeDecision' in p,
    'no generic identity-free suppression': 'ERR_QUEST_UNKNOWN_COMPLETE' in p and 'LE_GAME_ERR_QUEST_UNKNOWN_COMPLETE' not in p,
    'no frame visibility changes': 'UIErrorsFrame:Hide()' not in p and 'UIErrorsFrame:SetAlpha(' not in p,
    'no all-errors suppression': 'SetMessagesSuppressed' not in p and 'UnregisterEvent("UI_INFO_MESSAGE")' not in p,
    'restore on disable': 'self:RestoreNativeObjectiveGate()' in p,
    'fail open on closed module': 'if not self.moduleEnabled or not self.immersionEnabled' in p,
    'not in combat install': 'InCombatLockdown()' in p,
    'uses same 95 loaded Lua modules': len([s for s in (r/'Logres/Logres.toc').read_text().splitlines() if s.strip().endswith('.lua')]) == 95,
    'version synchronized': __import__('re').search(r'Logres\.VERSION\s*=\s*"([^"]+)"', (r/'Logres/Core/Bootstrap.lua').read_text()).group(1) == __import__('re').search(r'## Version:\s*([^\s]+)',(r/'Logres/Logres.toc').read_text()).group(1),
    'issue preserved': '| L-027 |' in (r/'docs/memory/investigations/ISSUE_LEDGER.md').read_text(),
    'report bug carries addon-owned snapshot': 'incident.snapshot.objectiveInfo = pickTraceStatus' in (r/'Logres/Dev/Panel.lua').read_text(),
    'negative evidence recorded': 'Risks / negative conditions' in (r/'docs/memory/evidence/P0388_OBJECTIVE_INFO_GATE.md').read_text(),
}
bad=[x for x,ok in checks.items() if not ok]
print('P0388 scoped native objective info gate:', 'PASS' if not bad else 'FAIL')
for x in bad:print('FAIL:',x)
raise SystemExit(bool(bad))
