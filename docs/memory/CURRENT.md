---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.3 — Quiet Mode runtime suppression.**

D.2 is complete.

D.3 first-pass source/design contract is complete; implementation is next.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- P0048 pushed at `ed5af75`.
- P0048 Immersion Controller runtime PASS.
- runtime remains `0.0.21-dev`.
- D-025 Quiet Mode runtime suppression contract accepted.
- direct ChatFrame Hide/Show is rejected because Blizzard scripts persist
  ChatWindowShown state.
- first-pass Quiet Mode will use runtime alpha/mouse suppression.
- chat edit boxes must remain visually usable through ignore-parent-alpha.
- world + immersion ON -> Quiet Mode desired ON.
- instance -> conservative Quiet Mode OFF.
- PvP flag alone does not disable Quiet Mode.
- Player/Target/Party suppression remains capability-gated.
- Primary replacement/routing ownership remains deferred.

## Next Action

Implement D.3 / P0050.

Runtime target:
1. add Quiet Mode module;
2. consume desired Quiet Mode from ImmersionController;
3. snapshot ChatFrame/tab runtime alpha + mouse state;
4. alpha-zero and mouse-disable passive chat/tabs;
5. preserve intentional edit-box visibility with IgnoreParentAlpha;
6. suppress dock overflow/known safe auxiliary chat controls;
7. reconcile after `UPDATE_CHAT_WINDOWS` and
   `UPDATE_FLOATING_CHAT_WINDOWS`;
8. restore exact captured state when Quiet Mode turns OFF;
9. never call `SetChatWindowShown()` or direct ChatFrame Hide/Show;
10. add Quiet Mode diagnostics.

## Success Criteria

D.3 first pass succeeds when:
- passive chat/tabs disappear in world Immersion ON;
- no invisible chat/tab mouse zones remain;
- pressing Enter still gives a visible usable edit box;
- intentional outbound chat works;
- Immersion OFF restores chat;
- instance policy restores chat;
- returning to world reapplies Quiet Mode;
- PvP flag alone keeps Quiet Mode active;
- saved Blizzard chat-window configuration remains unchanged;
- no Lua/taint/secret regression occurs.

## Do Not Reopen Without New Evidence

- **Phase C:** complete.
- **D.1:** complete.
- **D.2:** complete.
- **Direct ChatFrame Hide/Show for Quiet Mode:** rejected.
- **Player/Target/Party blanket suppression:** blocked.
- **Primary replacement/routing ownership:** deferred.
- **Auto replies:** not promised.
- **D-020 live action editing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D2_P0048_IMMERSION_CONTROLLER_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/evidence/D3_QUIET_MODE_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-025_QUIET_MODE_RUNTIME_SUPPRESSION.md`
- `docs/memory/investigations/D3_QUIET_MODE_RUNTIME_SUPPRESSION.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
