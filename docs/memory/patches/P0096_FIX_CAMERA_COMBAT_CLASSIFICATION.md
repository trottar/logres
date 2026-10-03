# P0096 — Fix Camera Combat Classification

Date: 2026-10-02
Result: INSTALLED / PUSHED — G.2 RUNTIME + INTEGRATION PASS (`a556a19a`)

## Baseline

P0095 verified pushed:
`b65ea1afb5915377029dff52a260668d388cd831`.

## Runtime

`0.0.39-dev -> 0.0.40-dev`.

## Durable identity

P0096 verified pushed:
`a556a19a569fe2c539b6b61ab5946f6fa7e91c68`.

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

`combat` therefore matches the DynamicCam situation predicate.

## Unchanged

- camera movement algorithm;
- probe delta/timing;
- target/restoration tolerances;
- no SetCVar;
- no CameraZoomIn/Out fallback;
- no state subscription;
- no automatic camera ownership;
- core State.combat semantics.

## Runtime result

Two genuine live-combat probes on `0.0.40-dev` both reported:
- `combat=true`;
- `lockdown=true`;
- `cachedCombat=false`;
- `mismatch=true`;
- `targetReached=true`;
- `moved=true`;
- `restored=true`;
- `secret=false`;
- `error=nil`.

The out-of-combat path remained clean, and a post-combat probe returned to
`combat=false` with restoration PASS.

Run All was performed on the current `0.0.40-dev` runtime and every emitted
check passed through `checkall: complete`.

Canonical evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## Classification

**PASS — G.2 RUNTIME + INTEGRATION.**

The observed cached/live mismatch confirms why production camera context must
use the live DynamicCam predicate while treating lockdown as a separate signal.

P0099 records the G.2 closure and opens G.3 production ownership.
