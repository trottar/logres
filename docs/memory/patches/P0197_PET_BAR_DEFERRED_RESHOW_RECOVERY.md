# P0197 — Event-driven pet-bar deferred re-show recovery

Date: 2026-10-11. Baseline: `main` `c89692b` (P0196 R4); proposed version `0.0.108-dev`.
Status: PREPARED / IN-GAME VALIDATION OPEN.

## Confirmed observation
User confirms R4 target buff and debuff presentation; separate Blizzard PetActionBar has reappeared intermittently alongside Logres ten pet controls. Trigger unknown. Uploaded R4 `LOGRES_DIAGNOSTICS_LATEST.lua` reports loadCount 251 native-surfaces `petFrame:folded petActions:folded playerBuffs:folded targetAuras:folded`, `error=nil`, `pending=false`, but these are **only snapshot classifications** and do not read native frame visibility. H.3 should later polish relatively small Logres debuff icons; no sizing change here.

## Source hypothesis and precise gap
Forever Blizzard `PetActionBarMixin:OnEvent` calls `self:Show()` on `PET_BAR_UPDATE`, `UNIT_PET(player)`, `PET_UI_UPDATE`, and `UPDATE_VEHICLE_ACTIONBAR`. Logres's already-hooked `PetActionBar` `OnShow` callback skips native Hide while `InCombatLockdown()` and marks `pending=true`. Once combat ends, `Native:Reconcile` previously reaches `Native:Fold('petActions')`, but a non-nil snapshot causes immediate success and **no deferred hide attempt**. Thus it can remain visible while debug misleadingly reports folded. This is a logically established source path, NOT a measured combat reproduction.

## Candidate fix
Logres-owned counters record PetActionBar `OnShow`, combat deferral, immediate refold, and deferred recovery. Only if a specific `OnShow` event was deferred during combat and a stock snapshot still exists does ordinary out-of-combat Reconcile retry the exact known frame's Hide once. No `IsShown`/protected presentation read, periodic hide, polling, broad hooks or new stock-targeting surfaces. Manual PET open and capability loss restore stock first; successful restores clear the deferral token. On hide error fail open to stock and report failure.

## Required validation
Deploy, `/reload`, pet active: pet Logres cluster usable, stock bar absent, Native Access Check `petbar-reshow` counters available. Natural pet movement/order and combat transitions if available; if pet bar ever appears, record screenshot and native-access check *while present*, then recheck immediately after leaving combat. A source-triggered defer should increment `combatDeferred`, then `recovered` after safe post-combat reconciliation; `awaiting=false` afterwards. Observe that native PET open restores correct working stock and closing re-folds, Immersion OFF/ON restores correctly, secure pet left-click and right-click autocast work, and Phase 0 Run All passes only actual scope. No need to manufacture contrived gameplay. If not reproduced classify OPEN / INTERMITTENT / UNREPRODUCED and do not assert universal cure. No Lua, secret, protected, or taint error allowed. Special/vehicle/petbattle combat gaps remain deferred.

No pet frame art, native helpful aura, target aura, Damage Meter, beta Issue Reporter, approved v4 geometry or debuff icon size changes.
