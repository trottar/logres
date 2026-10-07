# P0162 — Reactive Mouse-Wheel Zoom

Status: **R3 DURABLE + RUNTIME PASS**

Runtime:
`0.0.81-dev`

Durable commit:
`4628f49e48ff67b8012fb51d4b80e5d8638c6c28`

Expected implementation baseline:
`2a95909495e81104e02891fac94f19d59b1e030c`

## R1/R2/R3 delivery corrections

The initial P0162 artifact failed during exact-baseline preflight before any tracked write. Its untracked-file guard rejected the standard `LOGRES_DIAGNOSTICS_LATEST.lua` runtime evidence file; the extracted `P0162_PAYLOAD` remained untracked as expected.

P0162 R1 corrected that allowlist. The next apply then exposed a second pre-write delivery defect: an untracked path named exactly `cd` was present and the guard refused it.

P0162 R2 left the runtime implementation unchanged and corrected the exact `cd` cleanup, but its bounded full-suite shadow preflight caught another pre-write defect: `tools/check_camera_city_contract.py` still globally forbade the token `ReactiveZoom`, a stale P0161-era prohibition that conflicts with the now-authorized generic P0162 adapter. No tracked write occurred.

P0162 R3 left the reactive-zoom implementation, candidate runtime, source contract, and runtime gate unchanged. It removed only that obsolete global `ReactiveZoom` checker prohibition while preserving every City-specific prohibition against direct max-distance mutation, UI fading, UIParent coupling, timers, and duplicate resting-event ownership. The complete checker suite passed before tracked writes.

All three failed delivery attempts remain negative delivery evidence; none wrote tracked state before refusal.

## Purpose

Port the final non-presentation DynamicCam RPG behavior: reactive mouse-wheel zoom.

P0162 is source-backed by pinned DynamicCam `MouseZoom.lua` and reuses the accepted P0160 LibCamera-derived transition engine.

## Runtime changes

- add `Camera/ReactiveZoom.lua`;
- hook `CameraZoomIn` / `CameraZoomOut` only while Logres owns camera context;
- restore exact captured functions on normal release;
- preserve a newer external hook rather than clobbering it;
- use effective captured reactive settings `true / 0.1 / 2.5 / 1.2 / 2.5 / OutQuad`;
- preserve DynamicCam zero-increment, direction-reset, quick-step, first-person `0.05`, max-distance clamp, short-hop native fallback, and stale-target correction semantics;
- extend the P0160 transition driver to select `OutQuad` for reactive movement while retaining `InOutQuad` for situation transitions;
- preserve same-context manual zoom until context changes;
- add diagnostics/static contract coverage;
- bump runtime to `0.0.81-dev`.

## Explicit non-scope

P0162 does not:
- add or change profile CVar ownership;
- add a timer or context-polling loop;
- add DynamicCam UI fade/hide behavior;
- suppress Blizzard camera or UI surfaces;
- require another Taxi or contrived Teleport/NPC/Fishing/Gathering test.

## Runtime result

Canonical acceptance:
`../evidence/P0163_P0162_RUNTIME_PASS_2026-10-07.md`.

Observed on `0.0.81-dev`, loadCount `193`:
- base Camera Profile Check PASS;
- separate Run All PASS;
- reactive active/hooked with `OutQuad`;
- after the bounded wheel exercise: `wheel=36`, `quick=9`, `resets=2`, `native=4`, `corrections=15`;
- same-context manual City zoom persisted around `11.10` instead of returning to `5`;
- OFF/ON cycle recorded `release=1`, then `acquire=2`;
- user confirmed ordinary Blizzard wheel zoom while the controller was OFF;
- conflicts `0`, secrets `0`, failures `0`;
- final Run All clean.

Classification:
**P0162 RUNTIME PASS. FINAL NON-PRESENTATION PHASE G SLICE ACCEPTED.**

Phase G closes separately in P0163 with environmental deferrals preserved.
