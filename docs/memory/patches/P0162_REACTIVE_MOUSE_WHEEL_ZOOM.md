# P0162 — Reactive Mouse-Wheel Zoom

Status: **R3 PREPARED — RUNTIME EVIDENCE REQUIRED**

Candidate runtime:
`0.0.81-dev`

Expected baseline:
`2a95909495e81104e02891fac94f19d59b1e030c`

## R1/R2/R3 delivery corrections

The initial P0162 artifact failed during exact-baseline preflight before any tracked write. Its untracked-file guard rejected the standard `LOGRES_DIAGNOSTICS_LATEST.lua` runtime evidence file; the extracted `P0162_PAYLOAD` remained untracked as expected.

P0162 R1 corrected that allowlist. The next apply then exposed a second pre-write delivery defect: an untracked path named exactly `cd` was present and the guard refused it.

P0162 R2 left the runtime implementation unchanged and corrected the exact `cd` cleanup, but its bounded full-suite shadow preflight caught another pre-write defect: `tools/check_camera_city_contract.py` still globally forbade the token `ReactiveZoom`, a stale P0161-era prohibition that conflicts with the now-authorized generic P0162 adapter. No tracked write occurred.

P0162 R3 leaves the reactive-zoom implementation, candidate runtime, source contract, and runtime gate unchanged. It removes only that obsolete global `ReactiveZoom` checker prohibition while preserving every City-specific prohibition against direct max-distance mutation, UI fading, UIParent coupling, timers, and duplicate resting-event ownership. The complete checker suite is still required to pass in the shadow tree before any tracked write.

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

## Runtime acceptance gate

1. `/reload`.
2. Phase G -> Camera Profile Check.
3. Phase 0 -> Run All.
4. In the current ordinary world context:
   - one slow wheel tick inward;
   - one slow wheel tick outward;
   - several quick ticks in one direction;
   - one direction reversal.
5. Confirm smooth behavior, larger quick accumulation, and no stale-target snapback.
6. Phase G -> Camera Profile Check again. Require active/hooked reactive status, wheel count > 0, easing `OutQuad`, and zero reactive failures/secret skips/unexpected hook conflicts.
7. Phase G -> Camera Profile OFF; wheel once and confirm normal Blizzard zoom remains usable.
8. Phase G -> Camera Profile ON; wheel once; Camera Profile Check again.
9. Upload refreshed diagnostics.

A clean result makes P0162 a runtime PASS and allows a docs-only Phase G closure checkpoint with the existing environmental deferrals preserved.
