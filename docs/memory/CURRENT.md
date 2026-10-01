---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.4 — Contextual Visibility / Secure Paging.**

C.3 is complete.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- P0036 pushed at `f192557`.
- Primary secure cluster works.
- Secondary fixed-slot cluster works.
- Utility fixed-slot cluster works.
- three-cluster constellation works together.
- no reported protected/taint/Lua/secret error in C.3.
- stock Blizzard action bars remain visible.
- cast/channel cue color loss remains open visual debt.
- D-020 records future configurable action-layout profiles.
- current hardcoded 3-cluster geometry is explicitly provisional.

## Next Action

Source/design-resolve C.4 before changing protected visibility or paging.

Resolve:
1. presentation-only alpha vs protected Show/Hide boundaries;
2. secure visibility/state-driver APIs and Forever constraints;
3. safe interaction behavior for faded protected buttons;
4. combat/world/PvP/instance visibility policy;
5. PvP as an orthogonal modifier;
6. Primary combat-time page changes;
7. class/form/override/vehicle action-page states;
8. capability gates before stock action-bar suppression;
9. data model that future D-020 layout profiles can consume.

Do not build the full action-layout editor during C.4.

## Success Criteria

C.4 succeeds when:
- Primary remains reliably accessible;
- Secondary/Utility context emphasis is proven;
- combat transitions cause no protected mutation errors;
- PvP modifier behavior is distinct from combat state;
- Primary combat-time paging is secure or precisely capability-gated;
- unsupported special action states keep a safe stock fallback;
- future configurable cluster definitions can reuse the policy model.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **C.3:** complete.
- **P0032 failure:** historical evidence retained.
- **Cast cue colors:** open visual debt.
- **Current 3-cluster geometry:** proof layout, not final product lock.
- **D-020:** future layout customization requirement is canonical.
- **Stock action bars:** remain visible until capability gates are satisfied.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C3_SECONDARY_UTILITY_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/decisions/D-020_ACTION_LAYOUT_CUSTOMIZATION_DIRECTION.md`
- `docs/memory/investigations/C4_CONTEXTUAL_VISIBILITY_SECURE_PAGING.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/decisions/D-018_SECURE_ACTION_INTERFACE_CONTRACT.md`
