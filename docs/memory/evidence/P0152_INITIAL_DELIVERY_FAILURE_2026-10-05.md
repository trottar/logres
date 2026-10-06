# P0152 Initial Delivery Failure — Historical Runtime-Frozen Checker — 2026-10-05

Status: **RESOLVED IN P0152 R1 PREPARATION — NO TRACKED WRITE / NO RUNTIME RESULT**
Date: 2026-10-05
Baseline: P0151 `b62397b116cf028326167b7f8bf7010ed94f3717`

## Failure

The first P0152 apply verified the expected ZIP SHA and baseline, built the exact candidate, and passed pre-write `git diff --check`. The new P0152 secure-pet checker also passed. Prepared-candidate validation then failed in the durable P0150 class/pet/special checker:

```text
Logres P0150 class/pet/special read-only probe contract
=====================================================
ERROR: P0150 runtime version must be 0.0.73-dev, got 0.0.74-dev

FAILED: 1 error(s)
```

Porcelain state after refusal contained only the user's existing untracked diagnostics file and the extracted P0152 payload. No tracked file was written.

## Cause

`tools/check_class_pet_special_probe_contract.py` encoded historical P0150 runtime `0.0.73-dev` as a permanent repository requirement. P0152 intentionally advances the synchronized addon runtime to `0.0.74-dev`.

This violates the already-recorded P0083/P0088 rule: durable feature checkers may require readable versions and Bootstrap/TOC equality, but must not freeze the whole repository at a feature's introduction version.

## Exhaustive audit

Every `tools/check_*.py` on P0151 was scanned. Exactly four exact runtime literals remain:
- `tools/check_world_target_probe_contract.py` — `0.0.68-dev`;
- `tools/check_navigation_source_probe_contract.py` — `0.0.69-dev`;
- `tools/check_manual_waypoint_depth_contract.py` — `0.0.72-dev`;
- `tools/check_class_pet_special_probe_contract.py` — `0.0.73-dev`.

No other current static checker contains an exact runtime literal.

## R1 correction

P0152 R1 removes those four historical assertions, preserves Bootstrap/TOC version readability/equality, adds `tools/check_checker_version_policy.py`, adds an explicit AGENTS rule, and runs the complete static checker suite against the exact prepared candidate before and after writes.

Classification: **STATIC CONTRACT-CHECKER DELIVERY FAILURE — FALSE RUNTIME DEFECT.**

No WoW deployment or runtime validation occurred from the failed artifact.
