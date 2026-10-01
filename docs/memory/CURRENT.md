---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.4 — Contextual Visibility / Secure Paging — activation-feedback completion.**

P0039 contextual behavior passed.

P0040 adds the missing action activation feedback required before stock-bar
suppression.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- P0039 pushed at `9ca10a7`.
- P0039 world/context alpha: PASS.
- P0039 combat alpha: PASS.
- P0039 PvP modifier: PASS.
- Utility intentionally remains more subdued and is accepted for now.
- action execution works.
- range/usability feedback works.
- normal GCD/cooldown display works.
- P0039 immediate per-button action-use feedback: MISSING.
- normal primary page switching is not part of the user's workflow.
- stock Blizzard action bars remain visible.

## Next Action

Install/review/commit/push P0040.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Confirm:
- `0.0.18-dev`;
- Run All / Action Check PASS.

Runtime:
1. click Primary action -> visible pressed state + activation pulse;
2. click Secondary action -> same;
3. click Utility action -> same despite lower contextual alpha;
4. enable an already-proven Logres key-routing domain;
5. press a routed key -> activation pulse appears on corresponding button;
6. GCD/cooldown/range behavior remains intact;
7. fight normally and confirm feedback works in combat;
8. report protected/taint/Lua/secret errors.

The pulse does not need to remain for a full cast duration.

The separate cast/channel cue remains responsible for ongoing cast state.

## Success Criteria

P0040 succeeds when:
- mouse activation visibly responds;
- routed-key activation visibly responds;
- all three cluster roles inherit feedback;
- contextual alpha does not make feedback unusable;
- secure action execution remains correct;
- no protected/taint/Lua/secret regression occurs.

Only after this proof should C.4 close and C.5 stock-bar replacement begin.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **C.3:** complete.
- **P0039 context:** passed.
- **Utility fade:** accepted first-pass tuning.
- **Normal page switching:** not a user workflow.
- **D-022:** per-button activation feedback required before suppression.
- **Ongoing button-specific cast highlight:** not claimed by P0040.
- **Stock bars:** remain visible.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/ACTION_ACTIVATION_FEEDBACK_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-022_ACTION_ACTIVATION_FEEDBACK.md`
- `docs/memory/investigations/C4_CONTEXTUAL_VISIBILITY_SECURE_PAGING.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `Logres/Actions/Button.lua`
- `tools/check_action_contract.py`
