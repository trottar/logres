# P0144 — Record P0143 Navigation Runtime Result

Date: 2026-10-05
Baseline: `b9b2f90b37ad9d10b4ce6d55ef932e113172d3b3`
Runtime: unchanged at `0.0.69-dev`
Result: **INSTALLED / PUSHED — DOCS / RUNTIME-EVIDENCE CHECKPOINT**
Commit: `47534363bd5754306c31d5e860739289504417de`

## Purpose

Record the P0143 runtime result durably, distinguish proven source families from
environmental absences, and open only the next runtime-proven manual-waypoint
distance/depth slice.

Canonical evidence:
`../evidence/P0144_P0143_NAVIGATION_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`.

## Recorded result

P0143 is verified durable at
`b9b2f90b37ad9d10b4ce6d55ef932e113172d3b3` on `0.0.69-dev`.

Observed runtime PASS:
- current map/player position ordinary;
- map world size ordinary;
- minimap view radius ordinary;
- 23 tracking selector rows readable, four independently active;
- zero secret skips;
- zero failures;
- integrated `Run All` PASS.

Environmental DEFERRED:
- current-map AreaPOI population;
- current navigation waypoint;
- super-tracked quest waypoint;
- user waypoint / actual destination-distance branch;
- minimap map ID output in the captured context.

Source-blocked remains source-blocked:
- individual tracking-result positions;
- individual service/townsfolk positions inferred from tracking filters.

## Next

After P0144 is durable:
**P0145 manual-waypoint comparable-distance / bounded-depth slice.**

P0145 must reuse the proven P0123 manual waypoint source, use ordinary same-map
geometry only, fail open when distance is unavailable, and leave all unproven
quest/AreaPOI/tracking roles and the stock minimap untouched.

Deployment:
**none — docs/evidence only.**
