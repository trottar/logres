# D.6 P0063 Restoration Check Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01
Baseline: `13c53390be13edbaf23a495b9bf006b2147c8bc8`
Runtime target: `0.0.27-dev`

## Runtime implementation

P0063 adds one integrated `Restoration Check`.

### Out of combat

The check:
1. captures the original immersion preference;
2. requires the current supported ownership state to be settled;
3. flips immersion preference;
4. requires the opposite supported ownership state to settle;
5. restores the original preference;
6. requires reconvergence;
7. disables ImmersionController;
8. requires fail-open stock restoration while the preference remains unchanged;
9. re-enables ImmersionController;
10. requires reconvergence to the original preference-driven state;
11. finalizes/reconciles defensively and requires the original preference at
    exit.

If the active cycle fails, the diagnostic still attempts to restore the original
preference and re-enable/reconcile ImmersionController before reporting failure.

### In combat

The check is non-mutating.

It validates:
- controller desired ownership follows the current preference/context;
- action/Player/Target requested state follows preference;
- protected applied state is either converged or legally pending;
- Quiet Mode is immediately coherent;
- addon-owned substitute/suppression ownership matches the currently applied
  state.

## Recovery-state API

P0063 adds narrow `GetRecoveryStatus()` surfaces for:
- StockActionReplacement;
- QuietMode;
- PlayerFrameReplacement;
- TargetFrameReplacement;
- ImmersionController.

These APIs expose addon-owned state only.

They do not inspect Blizzard alpha, visibility, mouse state, secure attributes,
or secret-capable presentation values.

Player replacement now explicitly tracks:
- secure interaction configured ownership;
- secure interaction mouse ownership;
- selective stock presentation suppression ownership;
- stock mouse suppression ownership.

Target already had equivalent ownership facts.

## Recovery invariant

Static checks enforce:

**restore stock ownership first, then remove the Logres substitute path.**

Specifically:
- stock Bars 2–3 restore before prior routing restoration;
- Player stock shell/mouse restore before secure interaction disable;
- Target stock presentation/mouse restore before secure interaction disable.

## Static-contract drift repaired

P0062 delivery exposed a stale D.4-era PlayerFrame checker requirement:

`targetFrameSuppressionDesired = false`

P0063 removes that obsolete cross-domain assertion.

D-028/context-policy checks remain authoritative for current Target ownership:

`targetFrameSuppressionDesired = immersionEnabled`

Player command diagnostics also stop relying on
`interaction:IsShown()` / `interaction:IsMouseEnabled()` readback and use the
new addon-owned ownership facts.

## Runtime proof still required

Required in-client proof:
- Restoration Check out of combat;
- Run All;
- `/reload` persistence;
- Immersion OFF and ON;
- intentional combat immersion toggle;
- Restoration Check during combat;
- post-combat Restoration Check convergence;
- Context Policy Check;
- no Lua/taint/secret regression.

Natural instance proof remains environmental.
