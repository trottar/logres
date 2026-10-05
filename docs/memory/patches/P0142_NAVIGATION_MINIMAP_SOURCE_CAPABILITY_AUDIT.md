# P0142 — D-037 Navigation / Minimap Source-Capability Audit

Date: 2026-10-05
Baseline: `44720c22f0206c37dc6c1559f51b9319f3ee6647`
Runtime: unchanged at `0.0.68-dev`
Result: **PREPARED — DOCS / PRIMARY-SOURCE EVIDENCE ONLY**

## Purpose

Resolve the next D-037 source question against the exact tested Forever source
generation before adding any navigation runtime code.

## Source result

Canonical evidence:
`../evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`.

Accepted policy:
`../decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`.

Pinned source:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`).

Resolved:
- ordinary quest destination continues to use `C_QuestLog.GetNextWaypoint*`;
- `C_Navigation.GetNextWaypointForMap` is a distinct broader current-navigation
  candidate;
- tracking selection is multi-select;
- tracking APIs expose filter metadata/state, not per-detected-result positions;
- service tracking filters do not expose service-instance positions;
- positioned `C_AreaPoiInfo` rows are a separate runtime candidate;
- `C_Minimap.GetViewRadius` and `C_Map` geometry are source-plausible local-radius /
  comparable-distance inputs;
- stock minimap responsibilities remain broader than directional markers.

## Closed source paths

Without new primary source evidence:
- individual tracking-result coordinates/bearings;
- individual banker/mailbox/repair/trainer/etc. service-blip coordinates.

Do not probe Blizzard presentation internals to compensate.

## Initial applier failure preserved

The first P0142 artifact failed before any tracked write. Its transform for the
D-037 tracking-selection paragraph used an exact multiline anchor; on the user's
checked-out verified P0141 baseline that anchor matched zero times. The applier
stopped during pre-write transform construction. `git status --short` afterward
showed only the pre-existing `LOGRES_DIAGNOSTICS_LATEST.lua` export and the
extracted `P0142_PAYLOAD/`; no tracked repository state changed.

P0142 R1 keeps the source-audit scope unchanged. It preserves unique-anchor
validation but tolerates whitespace/line-wrapping differences while requiring all
non-whitespace anchor tokens to match exactly and in order.

## Next

After P0142 is durable, prepare P0143:
**read-only navigation source runtime probe**.

It will test only surviving source-plausible inputs and will not mutate tracking,
supertracking, minimap CVars/settings, or production presentation.

Deployment:
**none — docs/source evidence only.**
