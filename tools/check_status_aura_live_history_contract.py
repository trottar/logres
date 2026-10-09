#!/usr/bin/env python3
"""P0176: live-only, event-latched aura diagnostic and unchanged native fallback."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
S = (ROOT / 'Logres/HUD/StatusAuras.lua').read_text(encoding='utf-8')
C = (ROOT / 'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
def require(text, needle, what):
    if needle not in text: errors.append('missing '+what+': '+needle)
for token in (
    'local function recordLiveBucket(bucket, count, reason)',
    'function StatusAuras:RecordLiveSnapshot(unit, snapshot, reason)',
    'self:RecordLiveSnapshot(unit, snapshot, reason)',
    'recordLiveBucket(self.liveHistory.playerHarmful, #snapshot.rows, reason)',
    'recordLiveBucket(self.liveHistory.targetHarmful, #snapshot.harmfulRows, reason)',
    'recordLiveBucket(self.liveHistory.targetHelpful, #snapshot.helpfulRows, reason)',
    'historyPlayerMax = self.liveHistory.playerHarmful.maxRows',
    'historyTargetHarmfulMax = self.liveHistory.targetHarmful.maxRows',
    'historyTargetHelpfulMax = self.liveHistory.targetHelpful.maxRows',
    'self.liveScans = 0',
    'self.liveFailures = 0',
    'self.liveSecrets = 0',
    'self.liveHistory = {',
    'stockPreserved = true',
    'C_Secrets.ShouldUnitAuraIndexBeSecret',
): require(S,token,'aura source')
refresh_start=S.find('function StatusAuras:Refresh(reason, onlyUnit)')
refresh_end=S.find('function StatusAuras:SetPreview(enabled)',refresh_start)
refresh=S[refresh_start:refresh_end] if refresh_start>=0 and refresh_end>refresh_start else ''
preview=refresh.find('if active and self.preview then')
live=refresh.find('elseif active then')
read=refresh.find('snapshot = readUnit(unit)')
record=refresh.find('self:RecordLiveSnapshot(unit, snapshot, reason)')
disabled=refresh.find('reason = "disabled"')
snapshot_assigned=refresh.find('self.last[unit] = snapshot')
guard = 'if active and not self.preview then\n                self:RecordLiveSnapshot(unit, snapshot, reason)\n            end'
if not (0 <= preview < live < read < disabled < snapshot_assigned < record):
    errors.append('history ordering wrong: only post-read, post-disabled-branch is permitted')
if guard not in refresh:
    errors.append('missing explicit active/non-preview guard around history call')
# Do not weaken the R3 disabled-snapshot contract: the required adjacency is
# essential to the prior regression checker and its observed Run All failure.
if 'end\n            self.last[unit] = snapshot' not in refresh:
    errors.append('P0175 R3 disabled-snapshot adjacency changed')
if S.count('self:RecordLiveSnapshot(unit, snapshot, reason)') != 1:
    errors.append('history call not unique')
for forbidden in (
    'SetScript("OnUpdate"', 'C_Timer.After', 'C_Timer.NewTicker',
    'GetAuraSlots', 'GetAuraDataBySlot', 'addedAuras', 'updatedAuraInstanceIDs',
    'BuffFrame:Hide', 'DebuffFrame:Hide', 'TargetFrame:Hide',
):
    if forbidden in S: errors.append('forbidden source expansion '+forbidden)
for token in (
    'Logres statusaura live history:',
    'tostring(d.historyPlayerMax)',
    'tostring(d.historyTargetHarmfulMax)',
    'tostring(d.historyTargetHelpfulMax)',
    'tostring(d.historyScans)',
    'tostring(d.historyFailures)',
    'tostring(d.historySecrets)',
    '"statusAuraCheck",',
    'runStatusAuraCheck()',
): require(C,token,'Phase H diagnostic')
if C.count('Logres statusaura live history:')!=1:
    errors.append('history emission count mismatch')
print('P0176 live-only aura history contract')
print('====================================')
if errors:
    for x in errors:print('ERROR:',x)
    raise SystemExit('FAILED: '+str(len(errors))+' errors')
print('PASS: 0 errors')
