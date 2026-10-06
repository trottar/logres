# Camera World-Entry Transition Timeout — 2026-10-06

Status: **REPRODUCED — TARGETED MOTION DIAGNOSTIC REQUIRED**

## Initial trigger

The final integrated Run All used to validate P0152 R12 recorded a `Camera World/Combat` transition timeout after `PLAYER_ENTERING_WORLD` on `0.0.74-dev` / Forever `1.60.1.70235`.

Initial observation:
- requested/effective target `5`;
- start about `6.812`;
- final about `6.753` after about `3.254s`;
- target not reached;
- one failure;
- error `camera transition timed out before target`.

P0152 did not modify `Logres/Camera/`, so the initial event was correctly classified as OPEN / INTERMITTENT / UNREPRODUCED pending a targeted retest.

## Targeted reproduction

P0153 required one normal `/reload`, Phase G **Camera World/Combat Check**, and a separate Phase 0 **Run All**.

That retest reproduced the failure on loadCount `182`:
- context `world`, owns=true;
- reason/stop `PLAYER_ENTERING_WORLD` / `transition-timeout`;
- start about `8.524`;
- requested/effective target `5`;
- final/current about `12.632`;
- elapsed about `3.258s`;
- `targetReached=false`;
- `failures=1`;
- no secret-value failure;
- error `camera transition timed out before target`.

The separate Run All repeated the same camera state and failure while its other listed checks passed.

Classification is therefore **REPRODUCED RUNTIME FAILURE**.

## Narrow hypothesis

The newest sample is directionally significant: the requested transition is inward (`8.524 -> 5`) but the observed camera ends farther out at `12.632`.

The current P0119 driver maps negative velocity to `MoveViewInStart`, matching the audited LibCamera primary path. Repository search shows production camera ownership and the disabled manual camera probe are the only Logres MoveView users. DynamicCam was reported not loaded.

Therefore the next question is not whether the target selector is wrong. It is whether camera motion outside Logres' commanded direction is displacing the P0119 easing schedule during/after `PLAYER_ENTERING_WORLD`.

Audited LibCamera source has an additional positional-error rebase step when actual position diverges materially from expected easing position. P0119 adopted frame-shaped velocity and end correction but not that rebase behavior. This is a plausible cause of failure under competing movement, not yet an accepted correction.

## P0154 diagnostic contract

P0154 must not change transition behavior. During the already-existing transition OnUpdate it records only addon-owned diagnostic state derived from the ordinary `GetCameraZoom()` value that the controller already reads:
- observed sample count;
- toward/away/flat frame counts relative to target;
- min/max zoom;
- expected easing position plus current/max absolute position error;
- last observed direction/delta;
- last commanded MoveView direction/factor;
- inward/outward command counts.

No timer, ticker, delayed reconcile, CVar mutation, polling loop, or new event hook is authorized.

## Runtime gate

After P0154 deployment:
1. normal `/reload`;
2. developer panel -> Phase G -> **Camera World/Combat Check**;
3. developer panel -> Phase 0 -> **Run All**;
4. preserve diagnostics.

If an inward-target timeout shows inward commands only while observed frames move away and max zoom exceeds start zoom, the competing-motion/stale-easing hypothesis is confirmed strongly enough to design a positional-rebase correction. Otherwise, use the recorded evidence to narrow the driver before changing behavior.
