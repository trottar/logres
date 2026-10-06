# P0154 — World-Entry Camera Timeout Reproduced — 2026-10-06

Status: **RUNTIME FAIL REPRODUCED; TARGETED DIAGNOSTIC NEXT**
Runtime: `0.0.74-dev`
Client: Forever `1.60.1.70235`
Durable baseline: P0153 `7ad9be7ecc24c1136bf9a843689f90fb377b2012`

## Requested retest

P0153 required one normal `/reload`, then:
- Phase G -> **Camera World/Combat Check**;
- Phase 0 -> **Run All** separately.

No travel or contrived gameplay was required.

## Result

The direct Phase G check failed:
- loadCount `182`;
- context `world`, ownership retained;
- reason `PLAYER_ENTERING_WORLD`;
- requested/effective target `5`;
- transition start about `8.524`;
- current/final about `12.632`;
- elapsed about `3.258s`;
- target not reached;
- one failure;
- no secret-value error;
- error `camera transition timed out before target`.

The separate Run All immediately reported the same camera failure. Its other listed checks passed.

## Classification

The prior P0153 status **OPEN / INTERMITTENT / UNREPRODUCED** is superseded.

This is now a **REPRODUCED RUNTIME FAILURE**.

The observed motion moved away from the requested inward target, which narrows the investigation to transition motion/ownership rather than target selection. It does not by itself prove which external/client subsystem caused the outward movement.

## Source comparison

The audited LibCamera path maps inward movement to `MoveViewInStart`, matching Logres. LibCamera additionally rebases easing time when actual position diverges materially from expected position. P0119 does not currently record or rebase that positional error.

P0154 therefore adds diagnostic instrumentation only. It does not change runtime camera behavior.
