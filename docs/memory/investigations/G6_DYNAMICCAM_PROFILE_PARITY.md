# G.6 — Captured DynamicCam Profile Parity

Status: **CLOSED FOR CLAIMED OBSERVED SCOPE — P0162 RUNTIME PASS**

Opened: 2026-10-06
Closed: 2026-10-07

Canonical profile:
`../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Canonical profile audit:
`../evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`

Zoom source:
`../evidence/P0160_LIBCAMERA_ZOOM_SOURCE_AUDIT_2026-10-07.md`

P0160 runtime acceptance:
`../evidence/P0161_P0160_ZOOM_DRIVER_PASS_2026-10-07.md`

Rotation/settings source:
`../evidence/P0161_PROFILE_BEHAVIOR_SOURCE_AUDIT_2026-10-07.md`

Reactive source:
`../evidence/P0162_REACTIVE_ZOOM_SOURCE_AUDIT_2026-10-07.md`

Final runtime acceptance:
`../evidence/P0163_P0162_RUNTIME_PASS_2026-10-07.md`

## Objective

Replace the user's DynamicCam `RPG` camera behavior with deliberate Logres ownership while reusing audited DynamicCam/LibCamera semantics rather than independently reconstructing the camera engine.

## Layer 1 — context and conditional zoom

P0159 R1 is durable at `8ddcf098`.

Observed:
- ordinary profile/base PASS;
- Taxi context/target PASS;
- first shared zoom implementation failed Taxi landing.

That landing failure remains preserved and was corrected by the source-backed P0160 engine.

## Layer 2 — source-backed zoom engine

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

Runtime:
- base PASS;
- Run All PASS;
- Taxi `~4.01 -> 50` PASS;
- landing `50 -> ~4.98` PASS;
- source rebase exercised both directions;
- no direction-switch oscillation;
- zero runtime camera failures.

G.5 Taxi zoom convergence is closed for observed scope.

## Layer 3 — P0161 rotations and camera settings

P0161 is durable at `2a959094` / `0.0.80-dev` and runtime-accepted for the observed Taxi/settings/shoulder-offset scope. Accepted evidence includes Taxi target `50`, continuous yaw `-20`, City landing return about `4.97-5.01`, rotate-back completion, City max-distance factor `1` with original factor `4`, and zero profile/camera secret/runtime failures.

## Layer 4 — P0162 reactive mouse-wheel zoom

P0162 R3 is durable at `4628f49e` / `0.0.81-dev` and runtime-accepted.

Observed bounded gate:
- base Camera Profile Check PASS;
- separate Run All PASS;
- reactive `active=true`, `hooked=true`, `OutQuad`;
- wheel count reached `36` with `quick=9`, `resets=2`, native pass-through `4`, stale-target corrections `15`;
- manual City zoom persisted away from entry target `5` in the same context;
- OFF/ON cycle recorded one release and reacquisition;
- user confirmed native Blizzard wheel zoom remained usable while Logres camera ownership was disabled;
- hook conflicts `0`, secret skips `0`, failures `0`;
- final Run All clean.

## Closure classification

**G.6 and Phase G are complete for the behavior Logres currently claims.**

Environmental runtime deferrals remain:
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- Gathering;
- AFK priority behavior not naturally observed.

These are explicit deferrals, not PASSes and not failures. Do not contrive gameplay solely to manufacture them.

DynamicCam UI fading is intentionally outside Camera parity and remains Phase H presentation/suppression policy.
