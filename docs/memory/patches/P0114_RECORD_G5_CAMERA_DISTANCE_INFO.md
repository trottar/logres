# P0114 — Record G.5 Camera-Distance Info Runtime Evidence

Date: 2026-10-03
Result: **INSTALLED / PUSHED — DOCS/EVIDENCE ONLY** (`f89efd53`)
Baseline: `dea48e04dfdb46f0f443222806e0d6bc81afd2e8`
Runtime: `0.0.45-dev` unchanged

Durable identity:
`f89efd53ae47b41a6c843f203186a225f0b347c4`.

## Purpose

Record the P0112 read-only runtime result, close the missing default/metadata
question, synchronize the parallel P0113 shared summaries, and set the next G.5
work item without authorizing CVar mutation.

## Runtime result

P0112 `Camera Distance Info` returned PASS on Forever 1.60.1 / build 70205:

- current factor `1.2` -> ceiling `18`;
- default factor `1` -> ceiling `15`;
- target-50 required factor `3.3333333333333`;
- current/default target-50 support both false;
- account-stored true;
- character-stored false;
- locked false;
- secure false;
- read-only false;
- secret false;
- error nil.

Canonical evidence:
`../evidence/G5_P0112_CAMERA_DISTANCE_INFO_2026-10-03.md`.

## Decision gate result

The prior default-value gate resolves on the negative branch:

DynamicCam's inherited/default standard max-distance setting cannot itself
satisfy target 50.

This does not authorize a higher setting. The next G.5 checkpoint is a
product/ownership contract for any temporary above-default account-scoped CVar
ownership.

Production Taxi remains fail-open and target 50 remains the captured intent.

## Parallel P0113 convergence

P0113 is already durable at `19c0d1ff`.

P0114 synchronizes the shared current/roadmap summaries with accepted D-038
compass focus/depth direction that P0113 deliberately deferred while P0112 was
in flight.

## P0112 durable identity

P0112 is verified pushed at:
`dea48e04dfdb46f0f443222806e0d6bc81afd2e8`.

The P0112 patch record and patch index are updated from PREPARED to the verified
pushed/runtime-read-only-PASS state.

## Deployment

Docs/evidence only.

No WoW redeploy required.
