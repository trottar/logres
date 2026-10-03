# P0115 — Preserve Approved Visual Baseline

Date: 2026-10-03
Result: **INSTALLED / PUSHED — DOCS / DESIGN ASSETS / STATIC CHECKER ONLY** (`4ba63931`)
Baseline: `f89efd53ae47b41a6c843f203186a225f0b347c4`
Runtime: `0.0.45-dev` unchanged

## Purpose

Preserve the complete approved Logres visual-design set as durable repository
artifacts, reconcile memory with the actual state of visual work, and distinguish
finished art direction from remaining runtime/capability implementation.

## Adds

- twelve approved PNG reference sheets under `docs/design/approved/`;
- a hash/index README for those exact reference assets;
- D-039, which accepts the sheets as the canonical visual baseline and records
  precedence/safety rules;
- `VISUAL_IMPLEMENTATION_STATUS.md`, a component-by-component art/runtime/capability
  audit;
- `tools/check_approved_visual_baseline.py`, which verifies the twelve exact asset
  hashes and required canonical records.

## Memory reconciliation

The checkpoint records that broad visual exploration is no longer the main missing
work for most represented components.

In particular:
- action, resource, aura, cast, target/relative-danger, quest narrative,
  quest-interaction controls, Context, Active Quest, health tunnel, and compass
  families now have approved reference designs;
- quest interaction controls/rewards are no longer visually undefined, though
  runtime ownership remains unimplemented and capability-gated;
- Active Quest is visually designed but not implemented;
- Context visual language is designed and its main Phase-F producers are already
  runtime/visual proven;
- health-tunnel art direction is approved but the production runtime is still the
  procedural secret-safe proof implementation;
- compass art is approved, while only heading/manual-waypoint source capability is
  production-proven;
- aura/status, world-attached target, quest controls, and new navigation sources
  remain capability work despite having visual direction.

## Compass refinement

D-039 preserves the final accepted sheet details not fully captured by D-038:
- major waypoint/quest lane above the tape;
- local POI centered on the tape;
- tracking below the tape;
- approved bounded scaling examples;
- continuous identity fade calibration;
- focused POI emphasis and multiple simultaneous POI examples.

## Prior checkpoint synchronization

P0114 is verified pushed at `f89efd53` and is updated from PREPARED to durable in
this checkpoint's memory/index synchronization.

## Deployment

No files under `Logres/` change.

**No WoW redeploy is required.**
