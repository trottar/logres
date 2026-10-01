# D.2 P0048 Immersion Controller Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01

## Runtime version

`0.0.21-dev`

## Implementation

Adds:
`Logres/Immersion/Controller.lua`

The controller:
- subscribes to D-010 preferences;
- subscribes to observed State;
- derives orchestration policy;
- requests the existing StockActionReplacement capability;
- exposes desired Quiet Mode state;
- preserves D.1 unit-frame capability gates.

## Initial policy

### Immersion ON

Action:
- Bar 2–3 stock replacement desired ON.

Quiet Mode:
- world -> desired ON;
- instance -> desired OFF for the conservative first pass.

Unit frames:
- Player suppression false;
- Target suppression false;
- Party suppression false.

Primary:
- Primary routing is not controller-owned.

### Immersion OFF

Action:
- Bar 2–3 stock replacement desired OFF/restored.

Quiet Mode:
- desired OFF.

Unit frames remain untouched.

## Reload behavior

When persisted `immersionEnabled=true`:
- controller enables on login;
- Bar 2–3 replacement is automatically requested;
- Secondary/Utility routing therefore becomes automatic with replacement.

Primary routing remains manual because Primary stock replacement is unsupported.

## Combat

The controller does not directly mutate protected action surfaces.

It passes desired replacement state to `StockActionReplacement`, which retains
combat deferral, routing, stock snapshots, and restoration ownership.

## Diagnostics

Adds:
- `Immersion Check`;
- `/logres immersioncheck`.

Run All includes Immersion Check.

## Runtime proof

1. set Immersion ON;
2. `/reload`;
3. verify `0.0.21-dev`;
4. verify stock Bars 2–3 are already replaced;
5. Primary stock bar remains visible;
6. Primary Action Keys remain manual;
7. Immersion Check PASS;
8. Run All PASS;
9. Immersion OFF restores Bars 2–3;
10. Immersion ON replaces them automatically again;
11. combat-time preference transition defers safely;
12. after combat desired state applies;
13. Player/Target/Party remain untouched;
14. no protected/taint/Lua/secret errors.
