---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.3 — Waypoint-bearing capability/proof.**

P0071 is verified pushed at `7976d34e`.

P0071 runtime diagnostics are captured and reviewed.

## Verified State

- E.1 complete.
- E.2 complete.
- P0069 waypoint probe installed/pushed.
- P0070 developer-panel integration installed/pushed.
- P0071 developer-panel diagnostic persistence installed/pushed.
- Forever runtime: client `1.60.1`, build `70170`, interface `16001`.
- Open-world player map position and map->world conversion are usable/non-secret.
- User-waypoint retrieval is runtime-proven.
- User-waypoint world conversion is runtime-proven on same continent/domain.
- Clearing the waypoint returns cleanly to no destination/no bearing.
- `USER_WAYPOINT_UPDATED` is runtime-proven to register and fire on Forever.
- `SUPER_TRACKING_CHANGED` is runtime-proven to register and fire.
- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire in this run.
- Tested super-tracked quest IDs `436` and `237` returned no usable next waypoint.
- Two user-waypoint bearing candidates were captured.
- Bearing-axis convention remains OPEN because the intended cardinal direction
  of those manual waypoint placements was not persisted.
- P0071 introduced a real version metadata mismatch:
  TOC `0.0.29-dev`, Bootstrap `0.0.28-dev`.
- P0072 corrects the mismatch and adds a static equality check.
- Production waypoint presentation remains unimplemented.
- Minimap remains stock.

## Next Action

Apply/push P0072.

Then resolve only the remaining E.3 bearing-orientation proof.

Do not repeat retrieval/event/quest tests already captured.

Do not add production waypoint presentation until orientation is resolved.

## Success Criteria

E.3 closes when:
- user-waypoint retrieval/conversion/update behavior remains accepted;
- the world-axis bearing convention is runtime-proven;
- unavailable quest waypoint cases remain fail-open;
- no fabricated/stale direction is used.

## Do Not Reopen Without New Evidence

- **E.1:** complete.
- **E.2:** complete.
- **User waypoint retrieval/conversion:** proven.
- **USER_WAYPOINT_UPDATED:** proven.
- **SUPER_TRACKING_CHANGED:** proven.
- **Quest IDs 436/237 next waypoint:** unavailable in tested state.
- **Minimap suppression:** deferred/capability-gated.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/E3_P0071_RUNTIME_EVIDENCE_2026-10-01.md`
- `docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`
- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
