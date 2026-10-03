# G.4 — City Camera Ownership

Status: **CLOSED — RUNTIME + INTEGRATION PASS**
Opened: 2026-10-03
Contract resolved: 2026-10-03
Runtime closed: 2026-10-03
Final runtime: `0.0.43-dev`

## Objective

Extend the runtime-proven G.3 controller with the smallest deliberate
City/resting zoom slice without importing unrelated DynamicCam presentation or
CVar policy.

## Canonical source/profile audit

`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`

## Accepted contract

Inside the proven safety exclusions:
1. instance / taxi / active interaction -> relinquish;
2. live `UnitAffectingCombat("player")` -> `combat`;
3. resting -> `city`;
4. otherwise -> `world`.

Targets:
- combat -> conditional target `15`;
- city -> conditional target `5`;
- world -> conditional target `5`.

City ordinary entry is 2.5 seconds. Zoom restoration is `never`.

## Implementation

P0105 at `69560080`, runtime `0.0.43-dev`, extends the existing
`CameraWorldCombat` controller:
- `CITY_TARGET = 5`;
- resting state in addon-owned diagnostics;
- City selection after live combat and before World;
- conditional-in target 5;
- existing 2.5-second MoveView transition/fail-open architecture;
- City-aware diagnostics;
- `tools/check_camera_city_contract.py` static ordering/scope coverage.

## Runtime evidence

Canonical:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`

Accepted evidence proves:
- automatic resting -> City selection;
- clean City >5 target-5 transition;
- City <=5 no-op;
- fresh World evaluation on City exit;
- Run All;
- DynamicCam coexistence;
- clean addon-owned failure/secret/error state.

The first City transition observation from zoom 18 reported final zoom 0 with
`targetReached=false`. It remains preserved as ambiguous environmental evidence
and was not accepted as PASS. A later targeted retest from about 13.090 completed
near 5.178 with `targetReached=true`.

Natural live-combat + resting overlap was unavailable and remains an
environmental deferral; static ordering plus the already-proven live-combat path
remain authoritative.

## Explicit exclusions retained

G.4 does not own:
- City UI hide/fade;
- City/global camera CVar ownership;
- reactive-zoom implementation;
- login/reload startup-snap parity;
- Taxi;
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- AFK;
- Gathering;
- rotation;
- shoulder offsets.

## Result

**G.4 CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

Next Phase G work:
`G5_TAXI_CAMERA_OWNERSHIP.md`.
