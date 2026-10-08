#!/usr/bin/env python3
"""P0170 source-readiness deferral, lifecycle retry and truthful stock diagnostics."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
STOCK = ROOT / 'Logres/Actions/StockReplacement.lua'
SIDE = ROOT / 'Logres/Actions/SecondaryUtility.lua'
COMMANDS = ROOT / 'Logres/Core/Commands.lua'
errors=[]


def require(source, fragment, label):
    if fragment not in source:
        errors.append(f'{label} missing: {fragment}')


def scope(source, begin, end, label):
    start=source.find(begin)
    if start < 0:
        errors.append(f'{label} scope missing: {begin}')
        return ''
    stop=source.find(end,start+len(begin))
    if stop < 0:
        errors.append(f'{label} scope terminator missing: {end}')
        return ''
    return source[start:stop]

for path in (STOCK,SIDE,COMMANDS):
    if not path.is_file():
        errors.append(f'missing {path.relative_to(ROOT)}')

if STOCK.is_file():
    s=STOCK.read_text(encoding='utf-8')
    enable=scope(s,'function StockReplacement:EnableReplacement()',
                 'function StockReplacement:DisableReplacement()', 'EnableReplacement')
    request=scope(s,'function StockReplacement:RequestEnabled(enabled)',
                  'function StockReplacement:HandleEvent(event)', 'RequestEnabled')
    events=scope(s,'function StockReplacement:HandleEvent(event)',
                 'function StockReplacement:GetRecoveryStatus()', 'HandleEvent')
    for fragment in (
        'self.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")',
        'self.eventFrame:RegisterEvent("EDIT_MODE_LAYOUTS_UPDATED")',
        'self.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED")',
        'self.sourceDeferrals = 0',
        'self.retryCount = 0',
    ):
        require(s,fragment,'StockReplacement')
    for fragment in (
        'if not actions:RefreshExtraVisibility() then',
        'self.pending = true',
        'self.sourceDeferrals = self.sourceDeferrals + 1',
        'self.lastError = "awaiting-Bar-4/5-source-configuration"',
    ):
        require(enable,fragment,'EnableReplacement')
    transient=scope(enable,'if not actions:RefreshExtraVisibility() then',
                    'for _, key in ipairs({ "bar4", "bar5" }) do','transient')
    if 'self.requestedEnabled = false' in transient:
        errors.append('transient configuration failure cannot clear requested intent')
    for fragment in (
        'if self.pending and self.requestedEnabled then',
        'return false, "deferred"',
    ):
        require(request,fragment,'RequestEnabled')
    for fragment in (
        'if self.pending and (event == "PLAYER_REGEN_ENABLED"',
        'event == "PLAYER_ENTERING_WORLD"',
        'event == "EDIT_MODE_LAYOUTS_UPDATED"',
        'self.retryCount = self.retryCount + 1',
        'self.lastRetryEvent = event',
        'self:ApplyRequestedState()',
    ):
        require(events,fragment,'HandleEvent')
    for fragment in ('OnUpdate','C_Timer.After','C_Timer.NewTicker','hooksecurefunc'):
        if fragment in events:
            errors.append('HandleEvent must not poll, timer-retry or hook: '+fragment)

if SIDE.is_file():
    s=SIDE.read_text(encoding='utf-8')
    refresh=scope(s,'function SecondaryUtility:RefreshExtraVisibility()',
                  'function SecondaryUtility:CreateFixedCluster(', 'RefreshExtraVisibility')
    for fragment in (
        'if sourceEnabled ~= nil then',
        'self.extraSourceVisibility[key] = sourceEnabled',
        'if self.extraSourceVisibility[key] == true then',
        'ready = false',
    ):
        require(refresh,fragment,'RefreshExtraVisibility')
    if 'self.extraSourceVisibility[key] = sourceEnabled\n        if' in refresh:
        errors.append('nil source may overwrite last-known visibility')
    require(s,'or event == "PLAYER_ENTERING_WORLD"','SecondaryUtility')

if COMMANDS.is_file():
    s=COMMANDS.read_text(encoding='utf-8')
    check=scope(s,'local function runStockReplacementCheck()',
                'local function handleStockReplacement(argument)','StockReplaceCheck')
    for fragment in (
        'local expectedEnabled =',
        'Logres:GetPreference("immersionEnabled") == true',
        'local lifecycleConsistent =',
        'debugStatus.requestedEnabled == expectedEnabled',
        'debugStatus.appliedEnabled == expectedEnabled',
        'debugStatus.pending == false',
        'debugStatus.lastError == nil',
        'debugStatus.snapshotReady == expectedEnabled',
        'and lifecycleConsistent',
        'Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s',
    ):
        require(check,fragment,'StockReplaceCheck')

print('Logres P0170 stock startup/diagnostic contract')
print('============================================')
if errors:
    for error in errors:
        print('ERROR:',error)
    raise SystemExit(f'FAILED: {len(errors)} errors')
print('PASS: 0 errors')
