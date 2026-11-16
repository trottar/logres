#!/usr/bin/env python3
"""P0458: enforce per-enemy ownership, separate ordinary proof, bounded unknown, original alpha, stock fallback."""
from pathlib import Path
import hashlib
R=Path(__file__).resolve().parents[1];read=lambda x:(R/x).read_text(encoding='utf-8')
h=read('Logres/HUD/HUD.lua');p=read('Logres/HUD/WorldTargetProbe.lua')
s=h[h.index('-- P0459: every safely observed hostile/attackable non-selected plate'):h.index('function HUD:BuildLiveWorldEnemy()')]
o=p[p.index('function Probe:ObserveSecondaryThreat('):p.index('function Probe:RunDevNameplateLifecycleStatus(')]
for x in ('SECONDARY_POOL_CAPACITY = 40','SECONDARY_MAX_INCONCLUSIVE = 3',
          'for index = #pool + 1, SECONDARY_POOL_CAPACITY do','if not ordinaryOutOfCombat()',
          'frame:SetScale(0.5)','frame:SetAlpha(0.5)','frame:EnableMouse(false)',
          'slot.claim = claim','entry.region.SetAlpha, entry.region, entry.original',
          'if restored and hidden then','slot.blocked = true',
          'self.worldEnemySecondaryOwners[unit] = slot',
          'if old and old.visible then', 'old.inconclusive = 0',
          'self.worldEnemySecondaryTrialStableUpdates',
          'self.worldEnemySecondaryTrialInconclusiveHolds',
          'self.worldEnemySecondaryTrialInconclusiveWithdrawals',
          'self.worldEnemySecondaryTrialTokenReuse',
          'self.worldEnemySecondaryTrialIdentityDeferrals',
          'self.worldEnemySecondaryTrialPoolExhaustions',
          'self:HideSecondaryAggroOwner(old, "secondary-identity-unavailable")',
          'if decision == "promoted" or decision == "unsafe"',
          'or decision == "ineligible"',
          'self:HideSecondaryAggroTrial("secondary-removal-unknown")',
          'self:HideSecondaryAggroOwner(slot, "secondary-removed")',
          'self:HideSecondaryAggroOwner(old, "secondary-inconclusive-limit")',
          'if not anchor then',
          'if not generation and not guid then',
          'slot.frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)',
          'self:ClaimNativeSecondaryEnemyDecor(slot, anchor)',
          'if not pcall(slot.frame.Show, slot.frame) then',
          'probe:OrdinarySecondaryRole(slot.unit)',
          'self:ObserveSecondaryAggroTrial("PLAYER_TARGET_CHANGED", old, decision)'):
 assert x in s,x
for forbidden in ('OnUpdate', 'C_Timer.', 'GetNamePlates(', 'SetParent(', 'GetAlpha() ==', '.original ==', 'tostring(entry.original)'):
 assert forbidden not in s,forbidden
for x in ('function Probe:OrdinarySecondaryIdentity(unit)',
          'callOrdinary(UnitGUID, token)', 'not source.secret and source.present',
          'type(guid) == "string"', 'function Probe:OrdinarySecondaryRole(unit)',
          'readBoolean(UnitIsUnit, token, "target")',
          'local trialDecision = "inconclusive"',
          'trialDecision = "eligible"',
          'trialDecision = "confirmed-loss"',
          'trialDecision = "unsafe"',
          'if source.secret or detail.secret then'):
 assert x in p,x
assert 'UnitDetailedThreatSituation' in o and 'UnitThreatSituation' in o
assert 'self:HideSecondaryAggroTrial("off")' in h
assert 'self:HideSecondaryAggroTrial("secondary-combat-ended")' not in h  # P0459: end combat must not show stock art
assert 'self:ReconcileSecondaryAggroTargetChange(previous)' in h
assert 'self:HideLiveWorldEnemy("target-changed")' in h
assert 'worldEnemySecondaryEnabled = false' in h
for path in ('Logres/Core/Commands.lua','Logres/Dev/Panel.lua'):
 for x in ('worldEnemySecondaryTrialActive','worldEnemySecondaryTrialPending',
           'worldEnemySecondaryTrialStableUpdates',
           'worldEnemySecondaryTrialInconclusiveWithdrawals',
           'worldEnemySecondaryTrialTokenReuse',
           'worldEnemySecondaryTrialPoolExhaustions'):
  assert x in read(path),(path,x)
for path in ('docs/memory/CURRENT.md','docs/ROADMAP.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/investigations/ACTIVE.md','docs/memory/investigations/ISSUE_LEDGER.md',
             'docs/memory/patches/PATCH_INDEX.md','docs/memory/PRE_HANDOFF_AUDIT.md',
             'docs/memory/handoffs/CURRENT_HANDOFF.md'):
 assert 'P0458' in read(path),path
assert 'P0454/P0455 visual failures' in read('docs/memory/evidence/P0458_SECONDARY_MULTI_OWNER_LIFECYCLE.md') or 'P0455' in read('docs/memory/evidence/P0458_SECONDARY_MULTI_OWNER_LIFECYCLE.md')
print('P0458 PASS: per-enemy guarded owner, identity epochs, bounded missing, native fallback and memory (STATIC)')
