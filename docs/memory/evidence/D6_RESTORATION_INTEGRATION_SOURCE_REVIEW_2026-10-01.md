# D.6 Restoration / Integration Source Review — 2026-10-01

Status: SOURCE-RESOLVED
Date: 2026-10-01
Baseline: `01665d1bb96317c04cf27620fb173f18f841af9c`
Runtime: `0.0.26-dev`

## Question

Can Phase D restoration/recovery be validated as one reversible system without
adding new suppression policy or protected Blizzard presentation readback?

## Finding

Yes.

The current runtime already contains the required restoration mechanics.

### Action replacement

StockActionReplacement:
- captures Bars 2–3 plus prior routing state;
- restores the stock bar presentation first;
- then restores prior Logres routing;
- defers protected mutation in combat;
- owns PLAYER_REGEN_ENABLED convergence.

### Player replacement

PlayerFrameReplacement:
- captures only the selectively owned stock shell/mouse state;
- restores that stock state before disabling the Logres secure interaction;
- defers protected mutation in combat;
- owns PLAYER_REGEN_ENABLED convergence.

The integrated D.6 diagnostic should add explicit addon-owned player interaction
ownership state instead of querying protected presentation state.

### Target replacement

TargetFrameReplacement:
- restores stock presentation/mouse state before disabling Logres target
  interaction;
- already tracks addon-owned unit-watch, interaction-mouse, suppression, and
  preserved-override ownership;
- transports secret-capable restoration values opaquely;
- owns PLAYER_REGEN_ENABLED convergence.

No protected readback is needed for the D.6 integrated check.

### Quiet Mode

QuietMode:
- owns exact runtime snapshots;
- restores runtime presentation;
- does not write saved chat visibility;
- is not protected in the same way as the action/unit-frame replacements.

### Controller recovery

ImmersionController OnDisable requests fail-open restoration for all currently
supported domains.

A key source result is that disabling the controller during combat does not
strand protected restoration: StockActionReplacement, PlayerFrameReplacement,
and TargetFrameReplacement remain enabled and independently process their
pending request after PLAYER_REGEN_ENABLED.

Re-enabling ImmersionController immediately reconciles from persisted preference
and current State.

## Selected P0063 runtime diagnostic

Add one integrated `Restoration Check`.

Out of combat it performs a reversible:
- preference flip;
- preference restoration;
- controller disable/fail-open restore;
- controller re-enable/reconvergence.

The final preference must equal the original preference.

In combat it must not perform the active cycle. It validates only legal current
requested/applied/pending state.

Combat runtime proof requires:
1. intentionally toggle immersion during combat;
2. run Restoration Check while combat is active;
3. leave combat;
4. run Restoration Check again and confirm convergence.

## Evidence boundary

The new check must use addon-owned recovery state.

Do not add Blizzard protected presentation readback solely for diagnostics.

The existing per-module checks may remain as their historical/local validation
surfaces; D.6 does not expand protected inspection.

## Context/reload proof

Restoration Check does not synthesize:
- reload;
- PvP;
- instance transitions.

Use existing preference persistence, Context Policy Check, and actual runtime
transitions for those domains.

Natural instance proof remains environmental when unavailable.

## Conclusion

No new suppression policy is required.

P0063 should implement the integrated recovery-state API + Restoration Check,
targeting runtime `0.0.27-dev`.
