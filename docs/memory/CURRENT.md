---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.4 — Player secure interaction + selective PlayerFrame shell suppression.**

D.4 source/design review is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- P0051 pushed at `d25430f`.
- runtime remains `0.0.22-dev`.
- D-026 selective unit-frame suppression contract accepted.
- PlayerFrame blanket hide remains rejected.
- first supported Player suppression subset:
  - `PlayerFrameContainer`;
  - `PlayerFrameContent.PlayerFrameContentMain`.
- preserve Player alternate power area and direct class/rune/totem/pet children.
- secure Logres player interaction is required before stock PlayerFrame mouse
  suppression.
- TargetFrame suppression remains gated on secure interaction + aura /
  raid-marker preservation + contextual metadata filtering.
- Party suppression remains deferred pending normal + compact secure coverage.
- D.3 instance Quiet Mode transition remains environmental deferral.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Implement first D.4 runtime pass.

Add:
1. secure Logres `player` interaction button associated with visible Logres
   player/resource presentation;
2. left click target;
3. right click togglemenu;
4. selective snapshot/suppression of PlayerFrameContainer and
   PlayerFrameContentMain;
5. stock PlayerFrame mouse disable while suppression is active;
6. exact Immersion OFF restoration;
7. combat deferral;
8. diagnostics.

Do not:
- hide the whole PlayerFrame;
- suppress alternate power/class/rune/totem/pet children;
- suppress TargetFrame yet;
- suppress Party/CompactPartyFrame yet.

## Success Criteria

First D.4 runtime pass succeeds when:
- conventional stock PlayerFrame shell disappears under immersion;
- required direct PlayerFrame children remain available;
- visible Logres player affordance preserves secure left/right click behavior;
- old stock frame area is not an invisible click zone;
- Immersion OFF restores exact stock shell + mouse behavior;
- combat transition defers safely;
- no protected/taint/Lua/secret regression occurs.

## Do Not Reopen Without New Evidence

- **D.1–D.3:** complete.
- **D.4 source review:** complete.
- **Whole PlayerFrame suppression:** rejected.
- **Target suppression:** later D.4 capability step.
- **Party suppression:** deferred.
- **D.3 instance transition:** environmental deferral; retry naturally.
- **Primary replacement/routing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D4_UNIT_FRAME_SELECTIVE_SUPPRESSION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/investigations/D4_PLAYER_SHELL_RUNTIME_PROOF.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
