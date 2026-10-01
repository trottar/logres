---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.1 — Secure Action Capability / Source Review.**

Phase B is complete.

P0029's developer/control panel and the complete Phase B HUD passed integrated runtime validation.

## Verified State

- Phase 0 Foundation complete.
- Phase A Core State Engine complete.
- Phase B Core HUD complete.
- P0029 pushed at `90491fe`.
- current runtime version: `0.0.13-dev`.
- B.6 integrated HUD validation: PASS.
- developer/control panel: PASS and preferred recurring validation surface.
- no reported Lua/secret errors in B.6.
- no stale-state regression reported.
- no layout issue severe enough to block continuation.
- current-target cast true-path remains environmentally deferred.
- stock Blizzard UI remains visible intentionally at Phase B close.
- D-017 now explicitly defines later suppression/restoration ownership.

## Next Action

Perform C.1 current-source review before writing secure action-button runtime code.

Resolve:
1. secure action-button template/API available on Forever;
2. action-slot attribute model;
3. combat-lockdown restrictions;
4. secure visibility/state-driver options;
5. cooldown/icon/count/range update sources;
6. keybind handling;
7. drag/drop/edit constraints;
8. protected layout mutation rules;
9. safe stock action-bar suppression/restoration;
10. operations that must defer until combat ends.

Use narrow source evidence before implementation.

Phase C diagnostics should register in the existing developer/control panel.

## Success Criteria

C.1 succeeds when:
- secure action APIs/templates are source-verified;
- protected operations are clearly separated from ordinary presentation updates;
- first primary-cluster architecture is documented;
- combat-time mutation rules are explicit;
- stock action-bar suppression is gated behind proven Logres secure controls;
- no action-interface implementation depends on unverified assumptions.

## Do Not Reopen Without New Evidence

- **Phase A:** complete.
- **Phase B:** complete.
- **Target caster true-path:** deferred until natural opportunity.
- **Developer panel:** keep shared command execution; extend rather than duplicate.
- **Stock UI suppression:** D-017 capability-gated ownership is canonical.
- **Action bars:** do not hide until Phase C secure replacement is proven.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/B6_HUD_INTEGRATION_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/architecture/BLIZZARD_UI_SUPPRESSION.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `docs/memory/investigations/C1_SECURE_ACTION_INTERFACE.md`
- `docs/memory/roadmap/PHASE_C_ACTION_INTERFACE.md`
- `docs/ROADMAP.md`
