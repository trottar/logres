#!/usr/bin/env python3
"""P0447: selected hostile fallback and reversible, opt-in native decor trial."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua')
p=read('Logres/HUD/WorldTargetProbe.lua')
c=read('Logres/Core/Commands.lua')
d=read('Logres/Dev/Panel.lua')
anchor=p.split('function Probe:AcquireLiveEnemyTargetAnchor(eventUnit, fromEvent)',1)[1].split('\nend\n',1)[0]
for required in ('readBoolean(UnitCanAttack, "player", unit)',
                 'readEventReaction(unit)', 'readBoolean(UnitIsFriend, "player", unit)',
                 'readBoolean(UnitAffectingCombat, "player")',
                 'readBoolean(UnitAffectingCombat, unit)',
                 'reaction.category == "friendly"',
                 'friend.value ~= false', 'playerCombat.value ~= true',
                 'unitCombat.value ~= true', '"not-hostile"',
                 '"not-attackable"', '"combat-attackable-nonfriend"',
                 'readEventNameplate(unit)', 'readBoolean(anchor.IsForbidden, anchor)'):
    assert required in anchor,required
assert anchor.index('readBoolean(UnitCanAttack') < anchor.index('readEventNameplate')
assert 'liveEnemyLastEligibility' in p and 'liveEnemyCombatFallbacks' in p
native=h.split('local function safeNativeDecor(region)',1)[1].split('function HUD:BuildLiveWorldEnemy()',1)[0]
for required in ('issecretvalue', 'IsProtected', 'IsForbidden',
                 'HealthBarsContainer', '"name"', '"LevelFrame"',
                 '"PlayerLevelDiffFrame"',
                 'function HUD:RestoreNativeEnemyDecor()',
                 'function HUD:ClaimNativeEnemyDecor(anchor)',
                 'pcall(entry.region.SetAlpha, entry.region, entry.original)',
                 'pcall(region.GetAlpha, region)',
                 'pcall(region.SetAlpha, region, 0)',
                 'self:RestoreNativeEnemyDecor()'):
    assert required in native, required
assert 'tostring(entry.original)' not in native
assert 'if token' not in native and 'if entry.original' not in native
for forbidden in ('SetParent(', 'SetAttribute(', 'SetCVar(', 'GetNamePlates(',
                  'CastBarsContainer:SetAlpha', 'AurasFrame:SetAlpha',
                  'UnitFrame:SetAlpha', 'anchor:SetAlpha', 'anchor:Hide('):
    assert forbidden not in native,forbidden
attach=h.split('function HUD:RefreshLiveWorldEnemy(event, eventUnit)',1)[1].split('function HUD:SetLiveWorldEnemy',1)[0]
assert attach.index('ClaimNativeEnemyDecor(anchor)') < attach.index('pcall(frame.Show, frame)')
assert 'self:HideLiveWorldEnemy("native-decor-unavailable")' in attach
assert 'frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)' in attach
assert 'worldEnemySecondaryEnabled = false' in h
assert 'frame:EnableMouse(false)' in h
hide=h.split('function HUD:HideLiveWorldEnemy(reason)',1)[1].split('function HUD:UpdateLiveWorldEnemyValues',1)[0]
assert hide.index('self:RestoreNativeEnemyDecor()') < hide.index('refreshScreenFallback()')
for key in ('worldEnemyNativeVisualOwner','worldEnemyNativeTransfers',
            'worldEnemyNativeRestoreCount','worldEnemyNativeRestoreFailures',
            'worldEnemyNativeLastResult'):
    assert key in h and '"'+key+'"' in d and key in c, key
assert 'liveEnemyCombatFallbacks' in d and 'liveEnemyLastEligibility' in d
assert 'P0446 live acceptance FAIL' in read('docs/memory/investigations/ISSUE_LEDGER.md')
assert 'P0443' in read('docs/memory/evidence/P0447_HOSTILITY_AND_NATIVE_DECOR_TRIAL.md')
assert 'P0447 limited trial amendment' in read('docs/memory/decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md')
toc_version = re.search(r'^## Version: ([^\n]+)$', read('Logres/Logres.toc'), re.M)
bootstrap_version = re.search(r'Logres.VERSION = "([^"]+)"', read('Logres/Core/Bootstrap.lua'))
assert toc_version is not None and bootstrap_version is not None
assert toc_version.group(1) == bootstrap_version.group(1)
assert toc_version.group(1).endswith('-dev')
print('P0447 PASS: combat-gated nonfriend fallback, isolated native decorative trial, opaque restoration, stock fallback')
