---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.3 — Secondary / Utility Clusters.**

C.3 source/design resolution is complete.

Implementation is next.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- P0034 pushed at `daf6a56`.
- primary secure cluster remains proven.
- cast/channel cue color loss remains open non-blocking visual debt.
- Secondary transport contract: slots `61–72`.
- Utility transport contract: slots `49–60`.
- source candidate binding domains:
  - Secondary `MULTIACTIONBAR1BUTTON1–12`;
  - Utility `MULTIACTIONBAR2BUTTON1–12`.
- current-source mapping must still be runtime-proven on Forever.
- stock action bars remain visible.

## Next Action

Implement C.3 using D-019.

Runtime patch should:
1. add a reusable secure action-button presentation primitive;
2. preserve Primary's proven paging/binding orchestration;
3. add 12-button Secondary fixed-slot cluster;
4. add 12-button Utility fixed-slot cluster;
5. use 3 x 4 side geometry;
6. display existing multi-bar binding labels;
7. add fail-open Secondary Keys ON/OFF;
8. add fail-open Utility Keys ON/OFF;
9. extend Action Check to all three clusters;
10. keep stock Blizzard bars visible.

Do not add dynamic combat/PvP fades yet.

That belongs to C.4.

## Success Criteria

C.3 succeeds when:
- Secondary slots 61–72 are runtime-proven;
- Utility slots 49–60 are runtime-proven;
- mouse execution works on both;
- explicit routed keyboard execution works on both;
- routing releases cleanly;
- Primary remains regression-free;
- no protected/taint/Lua/secret error occurs;
- side-cluster geometry is usable with Phase B HUD;
- stock bars remain available.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **P0032 failure:** retained historical evidence.
- **Cast cue colors:** open visual debt.
- **Initial C.3:** only two fixed multi-bar domains.
- **Bars 4–8:** not represented yet.
- **Dynamic cluster visibility:** C.4.
- **Stock action bars:** remain visible.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C3_SECONDARY_UTILITY_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-019_SECONDARY_UTILITY_CLUSTER_CONTRACT.md`
- `docs/memory/investigations/C3_SECONDARY_UTILITY_CLUSTERS.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `docs/memory/decisions/D-018_SECURE_ACTION_INTERFACE_CONTRACT.md`
