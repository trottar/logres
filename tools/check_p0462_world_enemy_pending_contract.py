#!/usr/bin/env python3
"""P0462: requested/pending/active event policy, no aura suppression."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
h=(R/'Logres/HUD/HUD.lua').read_text()
a=(R/'Logres/HUD/StatusAuras.lua').read_text()
cmd=(R/'Logres/Core/Commands.lua').read_text()
setcode=h.split('function HUD:SetLiveWorldEnemy(enabled)',1)[1].split('function HUD:SetEnemyDisplayPreview(enabled)',1)[0]
events=h.split('local worldTrialEvents = CreateFrame("Frame")',1)[1].split('self.worldTrialEvents = worldTrialEvents',1)[0]
for token in ['self.worldEnemyLiveRequested = true','self.worldEnemyEnablePending = true',
              'self.worldEnemyEnablePending = false','self.worldEnemyDisablePending = true',
              'ordinaryOutOfCombat()', 'already-active','off-cancelled-pending',
              'previous-restore-refused']:
    assert token in setcode,token
for token in ['event == "PLAYER_REGEN_ENABLED" and ordinaryOutOfCombat()',
              'if self.worldEnemyDisablePending then','self.worldEnemyEnablePending',
              'self:SetLiveWorldEnemy(true)','consumedSafeEvent']:
    assert token in events,token
assert 'C_Timer.' not in setcode and 'C_Timer.' not in events
assert 'GetChildren(' not in setcode and 'SetParent(' not in setcode
assert 'worldEnemyActivationState' in h
assert 'worldEnemyActivationState' in cmd
assert 'worldEnemyAuraVisualStatus = "stock-crowding-P0461-unresolved"' in a
assert 'worldEnemyNativeLanes = nil' in a
assert 'P0461' in (R/'docs/memory/investigations/ISSUE_LEDGER.md').read_text()
assert '#13659' in (R/'docs/memory/evidence/P0462_WORLD_ENEMY_PENDING_AND_AURA_BLOCKER.md').read_text()
toc=(R/'Logres/Logres.toc').read_text()
boot=(R/'Logres/Core/Bootstrap.lua').read_text()
vt=re.search(r'^## Version: ([^\s]+)$',toc,re.M)
vb=re.search(r'^Logres\.VERSION = "([^"\n]+)"$',boot,re.M)
assert vt and vb and vt.group(1)==vb.group(1)
print('P0462 SCOPED PASS: pending OOC intent and stock aura retained')
