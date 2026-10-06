# P0155 — Camera Direction-Switch Stop

Date: 2026-10-06
Baseline: `40dec1874a587156c88319a9caed940088e25db7`
Candidate runtime: `0.0.76-dev`
Result: **R1 PREPARED — RUNTIME RETEST REQUIRED**

## Trigger

P0154 runtime diagnostic is a PASS while the camera behavior remains a FAIL.

Canonical evidence:
`../evidence/P0155_P0154_CAMERA_MOTION_RESULT_2026-10-06.md`.

World entry produced observed range `0 -> 50` around target `5`, with `142` inward commands and `1` outward command.

## Initial delivery failure

The first P0155 artifact refused before tracked writes because it expected one indentation-specific counter block twice. R1 validates the module and per-transition blocks separately. Evidence: `../evidence/P0155_INITIAL_DELIVERY_BASELINE_COUNT_FAIL_2026-10-06.md`.

## Narrow cause

P0119 supports crossed-target correction and can reverse MoveView direction.

Before P0155, `ApplyTransitionMotion()` selected the opposite `MoveView*Start()` function but did not stop/reset the previously active direction on a reversal. Full cleanup stops both directions only when the transition ends.

The P0154 command sequence proves this reversal path occurred.

## Runtime correction

P0155:
- adds a one-direction stop helper using the same Start(0) + Stop pairing already used by camera cleanup;
- before `in -> out` or `out -> in`, stops the previously active direction;
- fails open through existing transition cleanup if that stop fails;
- records a direction-switch count;
- preserves P0154 motion diagnostics;
- bumps candidate runtime to `0.0.76-dev`.

It does not change:
- context selection or priority;
- World/City/Combat/Taxi targets;
- transition durations or timeout policy;
- easing/velocity formula;
- event ownership;
- DynamicCam coexistence;
- camera-distance/CVar policy;
- Taxi rotation/UI fade;
- suppression behavior.

It adds no polling, ticker, arbitrary delay, broad hook, periodic reassertion, or positional rebase.

## Runtime acceptance

After deployment:
1. `/reload` in normal world state;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately;
4. upload diagnostics.

PASS requires world-entry convergence near target `5`, `failures=0`, `secret=false`, and no Lua/taint/protected-action failure. The retained motion line must expose `switches=<n>`.

If the timeout persists, preserve the failure and use the remaining motion evidence before considering positional rebasing or a narrower world-entry ownership rule.
