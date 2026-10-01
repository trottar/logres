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

P0053 implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 source review complete.
- P0052 pushed at `f5bda1e`.
- runtime before P0053: `0.0.22-dev`.
- P0053 target: `0.0.23-dev`.
- D-026 remains canonical.
- Player first-pass selective suppression now has a runtime implementation.
- whole PlayerFrame suppression remains forbidden.
- alternate/class/rune/totem/pet direct children remain Blizzard-owned.
- TargetFrame suppression remains gated.
- Party/CompactPartyFrame suppression remains deferred.
- D.3 instance Quiet Mode transition remains environmental deferral.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Install/review/commit/push P0053.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Runtime proof:
1. confirm `0.0.23-dev`;
2. Immersion ON removes the conventional stock PlayerFrame shell;
3. Logres health/resource presentation remains;
4. click the Logres resource percentage near screen center -> target self;
5. right-click the same percentage -> player unit menu opens;
6. old PlayerFrame area does not intercept mouse;
7. Player Frame Check PASS;
8. Immersion Check PASS;
9. Run All PASS;
10. Immersion OFF restores the stock PlayerFrame shell + mouse;
11. Player Frame Check PASS;
12. toggle immersion during combat and confirm PlayerFrame transition defers
    until combat ends;
13. no protected/taint/Lua/secret error.

If class resource/rune/totem/pet/alternate-power states occur naturally, confirm
they remain available. Do not manufacture them solely for proof.

## Success Criteria

P0053 succeeds when:
- selective stock shell suppression works;
- secure Logres player left/right-click interaction works;
- stock mouse region is removed while replaced;
- OFF restoration is exact;
- protected transitions defer safely;
- required direct PlayerFrame children are not intentionally suppressed.

## Do Not Reopen Without New Evidence

- **D.1–D.3:** complete.
- **D.4 source review:** complete.
- **Whole PlayerFrame suppression:** rejected.
- **Target suppression:** later D.4 capability step.
- **Party suppression:** deferred.
- **D.3 instance transition:** environmental deferral.
- **Primary replacement/routing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D4_P0053_PLAYER_SHELL_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/evidence/D4_UNIT_FRAME_SELECTIVE_SUPPRESSION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/investigations/D4_PLAYER_SHELL_RUNTIME_PROOF.md`
- `Logres/Immersion/PlayerFrameReplacement.lua`
- `tools/check_player_frame_replacement_contract.py`
