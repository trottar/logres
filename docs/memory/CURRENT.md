---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.5 — Context / PvP / instance orchestration runtime validation.**

P0060 integrated diagnostic implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 complete for supported Player + Target selective replacement.
- Party/CompactPartyFrame suppression remains capability-deferred.
- P0059 pushed at `b245170`.
- runtime before P0060: `0.0.25-dev`.
- P0060 target: `0.0.26-dev`.
- D-028 is canonical.
- P0060 changes diagnostics, not orchestration behavior.
- Context Policy Check validates State + ImmersionController + ActionContext.
- Context Policy Check does not inspect Blizzard protected/secret presentation
  state.
- expected ActionContext precedence remains:
  `combat > PvP > instance > world`.
- Quiet Mode remains world-only while immersion is ON.
- Bar 2–3, Player, and Target replacement remain immersion-preference-owned.
- Party suppression remains false.
- instanceType remains observed but not first-pass policy-bearing.
- TargetFrame intermittent reappearance remains OPEN / UNREPRODUCED.
- future Aura / Status Presentation domain remains deferred.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Install/review/commit/push P0060.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Use the developer panel:
1. Status — confirm `0.0.26-dev`;
2. Context Policy Check;
3. Run All;
4. Immersion OFF;
5. Context Policy Check;
6. Immersion ON;
7. Context Policy Check.

Then where safe:
8. enter combat and run Context Policy Check;
9. leave combat and run it again;
10. if a PvP flag transition is convenient, validate idle PvP policy.

Instance transition may remain environmental if no instance is naturally
available.

## Success Criteria

D.5 runtime validation succeeds when:
- world idle policy passes;
- Immersion OFF policy passes;
- Immersion ON policy passes;
- combat policy resolves to ActionContext combat without replacement ownership
  churn;
- PvP policy resolves to PvP presentation when not in combat;
- world/instance changes only Quiet Mode among supported Phase D suppression
  domains;
- Party remains stock;
- no Lua/taint/secret regression occurs.

## Do Not Reopen Without New Evidence

- **D.1–D.4 supported scope:** complete.
- **D.5 source/design:** complete; D-028 canonical.
- **Party suppression:** capability-deferred.
- **TargetFrame intermittent reappearance:** open/unreproduced.
- **Aura/status suppression:** deferred design domain.
- **Whole PlayerFrame / TargetFrame suppression:** rejected.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D5_P0060_CONTEXT_POLICY_CHECK_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/evidence/D5_CONTEXT_ORCHESTRATION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-028_CONTEXT_ORCHESTRATION_MATRIX.md`
- `docs/memory/investigations/D5_CONTEXT_PVP_INSTANCE_ORCHESTRATION.md`
- `tools/check_context_policy_contract.py`
