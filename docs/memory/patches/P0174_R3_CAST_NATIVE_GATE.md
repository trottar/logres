# P0174 R3 — Native cast visibility policy under combat

**Baseline:** local P0174 plus P0174 R2 (Git HEAD `f9c99685`, no intermediate push).
**Runtime version:** `0.0.90-dev` (no new semantic addon version; corrective revision).
**Status:** source-backed candidate; in-game NOT TESTED.

## Negative runtime input

P0174 R2's objective tracker OnShow repair is visually accepted by the user: the quest UI remains folded. The user confirms native cast/channel bars reappear **in combat**, despite out-of-combat re-folding. A diagnostics export records two combat deferrals and no pending refolds after release, not an in-combat suppression PASS. Keep exact failure in evidence even if R3 succeeds.

## Cause and correction

`NativeAccess` previously called `Hide()` out of combat then deferred when Blizzard re-showed its protected casting-bar roots during combat. Source-backed remedy: native casting mixin `showCastbar` policy via `SetAndUpdateShowCastbar(false)` armed **before lockdown**. Restore captured native policy values through native setters when CAST opens or Immersion is disabled. The capture tokens must not be inspected. Fail open if the native policy setter or source is unavailable; preserve snapshot and rollback on failure. Keep narrow Objective Tracker OnShow refolding, existing normal cast OnShow reporting, CAST fallback, and negative combat-escape counters. Do not mutate protected frames during combat, suppress boss/focus/vehicle controls, change user CVars, or manufacture game-state test requirements.

## Validation

Apply transactionally on R2 manifest baseline, run full `tools/check_*.py` and `git diff --check` before and after tracked changes, deploy addon, `/reload`, check `nativeuicheck` before and after normal casting and naturally occurring combat, verify CAST manual open/close and Immersion OFF/ON restoration, verify quest tracker, action drag and tooltip behavior. No runtime PASS from static checks; if bars still show in combat, keep failure OPEN and do not push as a fix.
