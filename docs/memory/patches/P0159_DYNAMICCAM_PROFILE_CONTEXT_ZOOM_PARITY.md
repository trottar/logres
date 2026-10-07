# P0159 — DynamicCam Profile Context + Zoom Parity

Date: 2026-10-06
Baseline: `27670624e8c001dc341ac92ad9c463f2f61088de`
Candidate runtime: `0.0.78-dev`
Result: **R1 PREPARED — INITIAL ARTIFACT REFUSED IN SHADOW PREFLIGHT BEFORE TRACKED WRITES; RUNTIME EVIDENCE REQUIRED**

## Purpose

Move Phase G from four-context zoom ownership toward the already-captured DynamicCam `RPG` profile without opening five more tiny per-situation projects.

P0159 implements one consolidated context/zoom parity layer.

## Runtime changes

New `Camera/ProfileContexts.lua`:
- pinned to DynamicCam source `ae586a9c...`;
- carries the upstream Teleport and Gathering spell sets;
- carries the supported NPC interaction frame family and FlightMap exclusion;
- reads Teleport/Gathering cast state secret-first;
- reads Fishing channel state secret-first;
- reads AFK and NPC interaction state;
- returns only sanitized ordinary booleans/duration/diagnostic counts.

`Camera/WorldCombat.lua`:
- selects all nine enabled captured situations by profile priority;
- adds Teleport target `20`;
- adds Interaction/Gathering target `5`;
- adds Fishing target `50`;
- represents AFK as a no-zoom priority context;
- uses Teleport cast duration when safely available;
- implements Fishing's source-defined one-second exit hold without timers/tickers;
- generalizes engine-ceiling diagnostics to Taxi/Teleport/Fishing;
- retains the P0119/P0155/P0156 transition driver and DynamicCam coexistence.

Developer diagnostics:
- existing legacy command names remain compatible;
- Phase G labels become Camera Profile Check/Reconcile/ON/OFF;
- profile predicate, secret-skip, read-failure, and Fishing-hold state is emitted.

## Explicit exclusions

No:
- `SetCVar`;
- max-distance mutation;
- continuous/degree rotation;
- shoulder-offset mutation;
- reactive zoom ownership;
- DynamicCam UI fade;
- periodic polling.

Those belong to the next consolidated parity layer / Phase H presentation policy as recorded by G.6.

## Validation

Static:
- complete `tools/check_*.py` suite;
- `git diff --check`;
- dedicated P0159 parity checker.

Runtime:
1. `/reload`;
2. Phase G -> Camera Profile Check;
3. Phase 0 -> Run All;
4. normal Taxi flight;
5. Camera Profile Check in flight;
6. Camera Profile Check after landing;
7. refreshed diagnostics.

Naturally encountered remaining profile contexts are useful evidence but are not required to be manufactured solely to close this checkpoint.


## Initial delivery failure and R1

The initial artifact failed its temporary-shadow checker pass before touching
tracked repository files.

`check_camera_city_contract.py` reported that the rendered candidate lacked the
City helper fragments `if context == "city" then` and `return CITY_TARGET`.

Cause: the applier inserted the new context-helper block immediately before
`Controller:Reconcile()`, then replaced the full `OnUpdate` -> `Reconcile`
region, deleting the helpers it had just inserted.

R1 renders the affected functions first and only then inserts the helper block
immediately before `FinishTransition`. The dedicated parity checker now asserts
that helper ordering.

R1 also ensures `StopTransition()` keeps the finite Fishing exit-hold OnUpdate
alive when a zoom transition completes during that hold.
