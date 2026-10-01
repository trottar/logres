---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.4 — Target selective replacement runtime implementation.**

Target source/design review is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 Player selective replacement runtime PASS.
- P0054 pushed at `d971459`.
- runtime remains `0.0.23-dev`.
- D-026 remains the broad selective unit-frame contract.
- D-027 Target selective suppression contract accepted.
- TargetFrame blanket suppression remains rejected.
- Target conventional container/main content are suppressible.
- Target contextual parent may be suppressed while preserving:
  - Auras;
  - RaidTargetIcon;
  - QuestIcon;
  - PingIconFrame;
  through IgnoreParentAlpha.
- secure Logres target interaction will use a UIParent secure unit button aligned
  with the existing 260x54 Logres target block.
- target existence will use RegisterUnitWatch after OOC configuration.
- target-of-target remains Blizzard-owned.
- Focus/boss target frames remain untouched.
- Party/CompactPartyFrame suppression remains deferred.
- D.3 instance Quiet Mode transition remains environmental deferral.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Implement P0056 Target selective replacement.

Runtime target:
1. create secure `target` interaction button at Logres target block geometry;
2. configure left target / right togglemenu / AnyUp;
3. RegisterUnitWatch while active;
4. snapshot TargetFrame container/main/context alpha;
5. snapshot stock target mouse/click/motion state;
6. snapshot IgnoreParentAlpha for Aura/RaidTarget/Quest/Ping preserved children;
7. apply selective suppression + preserved child overrides;
8. disable stock TargetFrame mouse region;
9. exact Immersion OFF restoration;
10. combat deferral;
11. Target Frame Check diagnostics.

Do not suppress:
- target-of-target;
- FocusFrame;
- boss target frames;
- Party/CompactPartyFrame.

## Success Criteria

P0056 succeeds when:
- conventional stock TargetFrame shell/metadata disappears under immersion;
- Logres target presentation remains;
- secure Logres left/right target interaction works;
- stock target area is not an invisible click zone;
- target auras remain available;
- useful preserved context survives when naturally present;
- OFF restoration is exact;
- combat transitions defer safely;
- no protected/taint/Lua/secret regression occurs.

## Do Not Reopen Without New Evidence

- **D.1–D.3:** complete.
- **D.4 Player selective replacement:** runtime PASS.
- **D.4 Target source review:** complete.
- **Whole PlayerFrame / TargetFrame suppression:** rejected.
- **Target-of-target:** separately Blizzard-owned.
- **Party suppression:** deferred.
- **D.3 instance transition:** environmental deferral.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D4_TARGET_SELECTIVE_SUPPRESSION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-027_TARGET_SELECTIVE_SUPPRESSION.md`
- `docs/memory/investigations/D4_TARGET_RUNTIME_PROOF.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
