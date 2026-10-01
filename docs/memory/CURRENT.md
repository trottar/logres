---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.1 — Immersion orchestration contract / source review.**

Phase C is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- P0045 pushed at `e3c8602`.
- C.6 integrated runtime validation PASS on `0.0.20-dev`.
- world/combat/PvP action integration works.
- secure mouse and routed-key action execution works.
- selective stock Bar 2–3 replacement/restoration works.
- Phase B HUD and Phase C action interface coexist in tested play.
- Primary Action Keys reset OFF after reload by design.
- manual Primary routing remains fail-open while MainActionBar replacement is
  unsupported.
- MainActionBar suppression remains deferred.
- Bars 4–5 suppression remains deferred.
- live action move/swap/remove editing remains deferred under D-020.
- cast/channel cue color regression remains open visual debt.

## Next Action

Source/design-resolve D.1 before broad suppression code.

Review exact Forever/Blizzard ownership and safe suppression/restoration for:
1. player frame;
2. target frame;
3. party frames;
4. chat frames/tabs and supported Quiet Mode surfaces;
5. integration of Phase C selective Bar 2–3 replacement;
6. combat-deferred transitions;
7. reload/login initialization ordering;
8. PvP/context/instance exceptions;
9. Immersion OFF restoration;
10. developer recovery/diagnostics.

`immersionEnabled` remains a persisted preference, not observed state.

Do not suppress:
- focus without a justified Logres replacement;
- MainActionBar;
- Bars 4–5;
- minimap/navigation;
- quest/XP surfaces;

outside their capability owners.

## Success Criteria

D.1 succeeds when the repository has a source-backed orchestration contract
covering:
- controller inputs;
- supported suppression targets;
- transition constraints;
- restoration;
- combat deferral;
- context exceptions;
- fail-open recovery.

Only then implement Phase D runtime suppression.

## Do Not Reopen Without New Evidence

- **Phase C:** complete.
- **C.6 manual Primary Action Keys after reload:** expected current behavior.
- **MainActionBar suppression:** deferred.
- **Bars 4–5 suppression:** deferred.
- **D-020 live action editing:** deferred.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C6_ACTION_INTERFACE_INTEGRATION_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/roadmap/PHASE_D_IMMERSION_CONTROLLER.md`
- `docs/memory/investigations/D1_IMMERSION_ORCHESTRATION_SOURCE_REVIEW.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
