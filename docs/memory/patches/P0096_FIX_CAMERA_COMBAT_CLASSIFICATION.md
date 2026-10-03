# P0096 — Fix Camera Combat Classification

Date: 2026-10-02
Result: PREPARED — G.2 LIVE-COMBAT RETEST PENDING

## Baseline

P0095 verified pushed:
`b65ea1afb5915377029dff52a260668d388cd831`.

## Runtime

`0.0.39-dev -> 0.0.40-dev`.

## Trigger

P0095 proved the camera movement/restoration path twice but both probe results
reported `combat=false`.

The classifier used cached `Logres:GetState().combat`.

DynamicCam World (Combat) uses live:
`UnitAffectingCombat("player")`.

## Change

At probe start P0096 records:
- `combat`: live UnitAffectingCombat;
- `lockdown`: live InCombatLockdown;
- `cachedCombat`: existing Logres state;
- `mismatch`: live combat versus cached combat.

`combat` now matches the DynamicCam situation predicate.

## Unchanged

- camera movement algorithm;
- probe delta/timing;
- target/restoration tolerances;
- no SetCVar;
- no CameraZoomIn/Out fallback;
- no state subscription;
- no automatic camera ownership;
- core State.combat semantics.

## Runtime acceptance

With DynamicCam disabled:
- OOC probe PASS;
- one naturally engaged probe reports `combat=true`;
- targetReached/moved/restored true;
- no secret/error result;
- Run All PASS.
