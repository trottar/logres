# P0154 — World-Entry Camera Motion Diagnostic

Date: 2026-10-06
Baseline: `7ad9be7ecc24c1136bf9a843689f90fb377b2012`
Candidate runtime: `0.0.75-dev`
Result: **INSTALLED / PUSHED — DIAGNOSTIC PASS; DIRECTION-SWITCH DEFECT IDENTIFIED** (`40dec187`)

## Trigger

P0153's targeted normal world-entry retest reproduced the Camera World/Combat timeout. The newest sample started near `8.524`, requested target `5`, and ended near `12.632`, so observed camera motion moved opposite the requested transition direction.

Canonical evidence:
`../evidence/P0154_WORLD_ENTRY_CAMERA_TIMEOUT_REPRODUCED_2026-10-06.md`.

## Narrow question

During the world-entry failure, is Logres commanding inward while the observed camera moves away from target and diverges from the P0119 easing plan?

## Implementation

P0154 changes diagnostics only:
- bumps development runtime to `0.0.75-dev`;
- records observed transition samples/toward-away-flat counts;
- records min/max zoom;
- computes the expected P0119 easing position and records current/max absolute position error;
- records last observed direction/delta;
- records last commanded MoveView direction/factor and inward/outward command counts;
- emits the new data from the existing Phase G **Camera World/Combat Check** and therefore from Run All;
- adds a static contract for this instrumentation.

No target, duration, transition velocity, timeout, context priority, event set, CVar policy, Taxi policy, or suppression behavior changes.

## Runtime validation

After deployment:
1. `/reload` normally;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately;
4. upload diagnostics.

The diagnostic is successful if it captures enough command/observation evidence to decide whether positional rebasing/correction is justified. A timeout is not converted into PASS by this patch.


## Durable/runtime result

Verified main:
`40dec1874a587156c88319a9caed940088e25db7`.

Runtime on `0.0.75-dev` / loadCount `184` preserved the timeout and captured the intended motion evidence:
- start about `23.148`, target `5`, final `50`;
- `145` samples with range `0 -> 50`;
- final/max easing position error `45`;
- `142` inward commands and `1` outward command.

The diagnostic therefore passed. The one outward command proves the P0119 correction path reversed direction during the world-entry displacement. Source inspection then identified that a direction reversal starts the new MoveView direction without stopping the prior one.

P0155 addresses that narrow defect. P0154 itself remains diagnostic-only.
