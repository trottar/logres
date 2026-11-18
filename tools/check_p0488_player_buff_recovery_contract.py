#!/usr/bin/env python3
"""P0488: event-driven recovery from combat-secret player aura snapshots."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
H=(R/'Logres/HUD/PlayerHelpfulAuras.lua').read_text()
N=(R/'Logres/Immersion/NativeSurfaceReplacement.lua').read_text()
P=(R/'Logres/Dev/Panel.lua').read_text()
B=(R/'Logres/Core/Bootstrap.lua').read_text()
T=(R/'Logres/Logres.toc').read_text()
E=(R/'docs/memory/evidence/P0488_PLAYER_BUFF_RESTRICTION_RECOVERY.md').read_text()
L=(R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
need=lambda ok,why: (_ for _ in ()).throw(AssertionError(why)) if not ok else None
for frag in ('"ADDON_RESTRICTION_STATE_CHANGED"', 'self.restrictionRegistered = pcall(',
             'if InCombatLockdown() then', 'self:Refresh("restriction-release")',
             'self.lastCoverageReady == true', '"NativeSurfaceReplacement"',
             '"player-helpful-restriction-release"', 'self.restrictionReconcileCount',
             'self.restrictionReconcileFailures', 'self.restrictionRecoveryLastReason'):
    need(frag in H,'helpful event-boundary/recovery missing: '+frag)
need('local ownerOK, native = pcall(' in H and
     H.index('self:Refresh("restriction-release")') < H.index('native.Reconcile, native,'),
     'recovery must refresh before native ownership reconciliation')
for unsafe in ('C_Timer.', 'SetScript("OnUpdate"', 'BuffFrame:Hide',
               'GetAuraSlots', 'GetAuraDataBySlot', 'GetAuraDataByAuraInstanceID'):
    need(unsafe not in H, 'no polling/unsafe aura or frame access: '+unsafe)
need('and helpful.lastCoverageReady == true' in N and 'self:Restore(key)' in N,
     'existing native stock fail-open contract lost')
for field in ('"restrictionRecoveryCount"', '"restrictionReconcileCount"',
              '"restrictionRecoveryLastReason"', '"restrictionRecoveryLastCoverage"',
              '"coverageReady"', '"lastRefreshReason"'):
    need(field in P, 'incident missing owned recovery field '+field)
need('L-054' in L and 'P0488' in E and '17676' in E and '17678' in E,
     'runtime failure/recovery evidence missing')
import re
v1=re.search(r'Logres.VERSION = "([^"]+)"',B)
v2=re.search(r'^## Version: ([^\n]+)$',T,re.M)
need(v1 and v2 and v1.group(1)==v2.group(1),'runtime version mismatch')
need((R/'tools/test_p0488_player_buff_recovery.lua').is_file(),
     'actual source fixture missing')
print('P0488 restriction-release player helpful recovery contract: PASS')
