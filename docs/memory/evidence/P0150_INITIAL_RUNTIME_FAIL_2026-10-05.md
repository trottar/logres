# P0150 — Initial Class / Pet / Special Probe Runtime Failure

Date: 2026-10-05
Runtime: `0.0.73-dev`
Result: **FAIL — DIAGNOSTIC TYPE CONTRACT; R3 CORRECTION / RETEST REQUIRED**

## Observed result

The Phase-H **Class / Pet / Special Probe** initialized successfully, registered 22/22 expected events, and found the required API set. Manual capture returned `failureCount=6`.

All six failures were the same diagnostic-contract mismatch:
`pet.isToken:unexpected-number`.

The observed pet state was otherwise populated: PetActionBar present, 10 slots scanned, 7 occupied, with two active actions and one autocast-enabled action.

Other observed domains:
- stance/form count `0` — environmental absence;
- eight totem slots scanned, zero active — environmental absence;
- player class `WARLOCK`, selected resource `SoulShards`;
- one primary-power result was secret and safely skipped; resource failures remained `0`;
- possess/vehicle/override/temp-shapeshift/extra-action were all ordinary `false`;
- separate integrated `Run All` completed cleanly.

## Diagnosis

The probe assumed `GetPetActionInfo(...).isToken` was a boolean. The pinned Blizzard source carries `isToken` through without a declared boolean conversion, and this Forever runtime returned numeric values. The read-only probe must therefore treat it as an opaque secret-first value unless a stricter contract is independently proven.

A second diagnostic presentation defect was exposed: `GetDebugStatus()` used `self.special and value or nil`, which maps a legitimate `false` to `nil`. The detailed special-domain line retained the correct false values.

## Classification

**RUNTIME FAIL / PROBE-CONTRACT DEFECT.**

This is not a production-control failure. No cast, autocast mutation, form mutation, totem dismissal, special-mode mutation, Blizzard presentation mutation, taint, or protected-action failure was observed.

## Correction history

The first R1 delivery artifact expected pre-P0150 HEAD `dbe468f7` and correctly refused before writes because the initial P0150 implementation had already become durable at `c7ea3638`. That refusal is an artifact-baseline mismatch, not additional runtime evidence.

The R2 delivery artifact then correctly refused before tracked writes because its validator incorrectly demanded that the raw `"classpetspecialprobe"` token occur exactly once in `Commands.lua`. The durable P0150 file contains that token twice by design (dispatch plus developer-panel registration). This is a second artifact-delivery failure, not additional runtime evidence.

P0150 R3:
- removes the boolean-only type requirement from `isToken`;
- retains secret-first handling before any value inspection;
- preserves ordinary false special-mode values in the summary;
- adds static contracts for both corrected behaviors;
- keeps runtime at `0.0.73-dev` and does not widen scope.

Retest the same probe in the natural current state, then run `Run All` separately.
