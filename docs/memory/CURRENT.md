---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.5 — Stock Action-Bar Replacement.**

C.4 is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- C.4 complete.
- P0041 pushed at `c020ab1`.
- world contextual action weighting: PASS.
- combat contextual weighting: PASS.
- PvP modifier: PASS.
- Utility subdued weighting accepted as first-pass tuning.
- mouse action activation feedback: PASS.
- Logres-routed keyboard activation feedback: PASS.
- stock bindings bypass Logres feedback unless Logres routing is enabled.
- normal Primary page switching is not part of the user's workflow.
- special action states remain capability-gated.
- stock Blizzard action bars are still visible.
- current Logres coverage does not yet represent every stock bar the user uses.

## Next Action

Source/design-resolve C.5 before hiding any Blizzard action surface.

Resolve:
1. exact Forever Blizzard frame ownership for proven action domains;
2. safe suppression/restoration mechanics;
3. combat-lockdown boundaries;
4. replacement-state lifecycle;
5. coupling between suppression and Logres key routing;
6. reload persistence;
7. Immersion OFF restoration;
8. special vehicle/override/form fallback;
9. selective handling of unsupported Bars 4–5;
10. diagnostics for suppression + restoration.

Do not implement global action-bar suppression.

Do not hide Bars 4–5 while they remain outside current Logres coverage.

## Success Criteria

C.5 succeeds when:
- only proven replacement domains are suppressed;
- corresponding Logres key routing is active whenever suppression is active;
- stock bindings/surfaces restore reliably;
- replacement fails open;
- unsupported domains remain accessible;
- special states preserve a safe fallback;
- no protected/taint/Lua/secret regression occurs.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **C.3:** complete.
- **C.4:** complete.
- **P0040:** real visual failure retained as evidence.
- **P0041:** activation feedback runtime-proven.
- **Utility fade:** accepted first-pass tuning.
- **Normal page switching:** not a user workflow.
- **Bars 4–5:** cannot be suppressed yet.
- **Stock bars:** still visible until C.5 capability proof.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/P0041_ACTION_FEEDBACK_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/investigations/C5_STOCK_ACTION_BAR_REPLACEMENT.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/decisions/D-022_ACTION_ACTIVATION_FEEDBACK.md`
- `docs/memory/decisions/D-020_ACTION_LAYOUT_CUSTOMIZATION_DIRECTION.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
