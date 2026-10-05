# P0125 — Documentation State Synchronization

Date: 2026-10-04
Result: **INSTALLED / PUSHED — DOCS-ONLY** (`72d2f040`)
Baseline: `1e7e27e37b91fc6ee9dc39c015456626414b7964`
Runtime: unchanged at `0.0.54-dev`

## Purpose

Synchronize the repository's authoritative active-state documentation after the
approved P0120–P0124 visual translation sequence, without changing addon runtime
behavior.

The older active summaries still pointed to the pre-P0119 G.5 camera checkpoint
and therefore no longer represented the user's explicit visuals-first sequencing.

## Changes

P0125:
- makes `CURRENT.md` authoritative for the accepted P0124 state and Active Quest
  as the exact next objective;
- updates the compact handoff, roadmap status, Phase G pause state, and Phase H
  parallel visual sequence;
- records P0119 as durable while preserving its still-pending Taxi landing retest;
- records P0124 runtime + visual acceptance and creates canonical evidence;
- synchronizes durable visual facts in `MEMORY.md`, HUD/Camera architecture, and
  the active Taxi investigation;
- updates `PATCH_INDEX.md`;
- creates the 2026-10-04 dated memory entry;
- restores the accidentally dropped executable bit on
  `tools/check_hud_contract.py`.

## Boundary

This patch changes no Lua/runtime source and does not require WoW redeployment.

It does not:
- claim P0119 Taxi landing runtime PASS;
- resume Camera work;
- implement Active Quest;
- expand quest-control/navigation/aura/minimap ownership.

After this checkpoint is verified durable, the next implementation objective is
the narrow D-039 Active Quest one-focus presentation.

## Delivery correction

The first P0125 handoff artifact failed safely before producing a manifest because
`tools/check_memory_health.py` requires the canonical CURRENT headings
`Verified State`, `Success Criteria`, and `Do Not Reopen Without New Evidence`.
The proposed replacement CURRENT omitted those exact structural headings.

The transactional applier rolled back all patch-owned files. R1 preserves the
same documentation intent while conforming to the repository memory-health
contract. This is a patch-delivery failure, not a runtime or design failure.
