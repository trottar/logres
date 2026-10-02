---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.1 — Quest-experience source / capability review.**

P0076 is verified pushed at `ebb4bbc7`.

Phase E is complete.

Production runtime remains:
`0.0.30-dev`.

## Verified State

- Phases 0, A, B, C, D, and E are complete.
- E.1 compass/navigation source review complete.
- E.2 heading-only compass runtime-proven.
- E.3 manual user-waypoint map-space bearing runtime-proven.
- E.4 production user-waypoint compass marker runtime + visual PASS.
- E.5 navigation-sufficiency/minimap review complete.
- D-030 is accepted:
  **the Blizzard minimap remains Blizzard-owned; Phase E does not suppress it.**
- The minimap suppression capability gate fails because Logres does not
  deliberately replace all required minimap/navigation information and control
  surfaces.
- Known missing/unreplaced domains include:
  - quest/objective navigation;
  - route/path guidance;
  - local POI/tracking information;
  - minimap ping/click interaction;
  - zoom controls;
  - zone/territory context;
  - other Blizzard-owned minimap utility not separately proven/replaced.
- Tested super-tracked quest IDs `436` and `237` returned no usable next
  waypoint.
- Quest marker presentation remains unsupported.
- Existing heading + manual user-waypoint compass remains accepted production
  navigation.
- Minimap remains stock in all contexts.

## Next Action

F.1 reviews the tested Forever client's quest-experience sources and stock UI
ownership before any quest presentation or suppression work.

Review at minimum:
1. NPC quest offer/progress/reward presentation;
2. gossip/quest interaction boundaries;
3. objective/task update sources;
4. selected/super-tracked quest state relevant to presentation;
5. quest helper / world-map ownership boundaries;
6. XP presentation sources;
7. secure/protected/secret-value constraints;
8. stock quest/objective/XP surfaces that must remain until deliberately
   replaced.

No stock quest/XP suppression is authorized during F.1.

## Success Criteria

F.1 succeeds with an explicit capability contract that separates:
- safe informational sources;
- interaction/control surfaces;
- protected/restricted behavior;
- Phase F presentation ownership;
- fail-open stock fallback;
- runtime proof requirements for the first implementation slice.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **Heading compass:** accepted.
- **Manual user-waypoint marker:** accepted.
- **Quest waypoint marker:** unsupported until separately runtime-proven.
- **Minimap:** Blizzard-owned / stock by D-030.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-030_MINIMAP_REMAINS_BLIZZARD_OWNED.md`
- `docs/memory/evidence/E5_MINIMAP_CAPABILITY_REVIEW_2026-10-02.md`
- `docs/memory/evidence/E4_P0075_RUNTIME_PASS_2026-10-02.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
