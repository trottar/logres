---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.2 — Immersion Controller runtime foundation.**

P0048 implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- P0047 pushed at `d24fcba`.
- runtime before P0048: `0.0.20-dev`.
- P0048 target: `0.0.21-dev`.
- D-024 remains canonical.
- Phase C Bar 2–3 replacement remains the only action suppression capability
  automatically owned by Phase D.
- full Player/Target/Party suppression remains blocked.
- Primary stock replacement remains unsupported.
- Primary routing remains manual.
- Quiet Mode desired policy is computed in D.2 but not visually applied until
  D.3.

## Next Action

Install/review/commit/push P0048.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Runtime proof:
1. ensure Immersion ON before reload;
2. confirm `0.0.21-dev`;
3. confirm stock Bars 2–3 are automatically replaced after reload;
4. confirm Primary stock bar stays visible;
5. confirm Primary Action Keys remain manual;
6. Immersion Check PASS;
7. Run All PASS;
8. Immersion OFF restores Bars 2–3;
9. Immersion ON automatically replaces them again;
10. in combat, changing immersion safely defers replacement transition;
11. after combat, desired replacement state applies;
12. Player/Target/Party stock frames remain untouched;
13. no protected/taint/Lua/secret error.

## Success Criteria

D.2 succeeds when:
- persisted immersion preference automatically owns supported Bar 2–3
  replacement;
- OFF restoration is reliable;
- combat deferral remains correct;
- controller diagnostics match preference/state/replacement truth;
- Primary routing is not automatically seized;
- unit-frame capability gates remain intact.

## Do Not Reopen Without New Evidence

- **Phase C:** complete.
- **D.1:** complete.
- **PlayerFrame blanket suppression:** blocked.
- **TargetFrame blanket suppression:** blocked.
- **Party-frame blanket suppression:** blocked.
- **Primary replacement/routing ownership:** deferred.
- **Quiet Mode visuals:** D.3.
- **D-020 live action editing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D2_P0048_IMMERSION_CONTROLLER_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/decisions/D-024_IMMERSION_ORCHESTRATION_CONTRACT.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
- `Logres/Immersion/Controller.lua`
- `tools/check_immersion_controller_contract.py`
