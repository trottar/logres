---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.4 — Target selective replacement runtime proof.**

P0056 implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 Player selective replacement runtime PASS.
- D.4 Target source review complete.
- P0055 pushed at `0c46f19`.
- runtime before P0056: `0.0.23-dev`.
- P0056 target: `0.0.24-dev`.
- D-027 remains canonical.
- P0056 adds secure unit-watched Logres target interaction.
- P0056 suppresses Target container/main/contextual parent, not whole TargetFrame.
- P0056 preserves Auras/RaidTargetIcon/QuestIcon/PingIconFrame.
- target-of-target remains Blizzard-owned.
- Focus/boss target frames remain untouched.
- Party/CompactPartyFrame suppression remains deferred.
- D.3 instance Quiet Mode transition remains environmental deferral.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Install/review/commit/push P0056.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Runtime proof:
1. confirm `0.0.24-dev`;
2. Immersion ON + target removes conventional stock TargetFrame shell/metadata;
3. Logres target name/health/cast presentation remains;
4. left-click Logres target block -> target interaction works;
5. right-click Logres target block -> target menu opens;
6. old stock TargetFrame area does not intercept mouse;
7. target auras remain visible/usable when present;
8. Target Frame Check PASS;
9. Immersion Check PASS;
10. Run All PASS;
11. Immersion OFF restores stock TargetFrame + mouse;
12. Target Frame Check PASS;
13. toggle immersion during combat and confirm transition defers;
14. no protected/taint/Lua/secret error.

Natural-only raid marker, quest icon, ping, target-of-target, or unusual aura
paths may be deferred if not encountered.

## Success Criteria

P0056 succeeds when selective target suppression, secure interaction,
preserved context, exact restoration, and combat deferral all work without
touching excluded unit-frame domains.

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

- `docs/memory/evidence/D4_P0056_TARGET_REPLACEMENT_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/evidence/D4_TARGET_SELECTIVE_SUPPRESSION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-027_TARGET_SELECTIVE_SUPPRESSION.md`
- `docs/memory/investigations/D4_TARGET_RUNTIME_PROOF.md`
- `Logres/Immersion/TargetFrameReplacement.lua`
- `tools/check_target_frame_replacement_contract.py`
