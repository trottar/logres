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

C.4 source/design resolution is complete.

Implementation is next.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- P0037 pushed at `d1a6527`.
- current runtime version remains `0.0.16-dev`.
- Primary/Secondary/Utility secure execution proven.
- D-020 future layout customization direction accepted.
- D-021 context/secure-paging contract accepted.
- protected ordinary Show/Hide/SetAttribute remains forbidden in combat.
- alpha-based emphasis is the selected initial context approach.
- no alpha-zero action state is allowed.
- SecureActionButtonTemplate ID/actionpage is the selected Primary paging path.
- stock Blizzard action bars remain visible.
- cast/channel cue color regression remains open visual debt.

## Next Action

Implement C.4 in a narrow runtime patch.

Part A:
- subscribe action policy to existing state;
- apply role alpha from combat/pvpFlagged/context;
- keep all action buttons interactable.

Part B:
- migrate Primary secure execution toward button ID + actionpage driver;
- synchronize presentation slot/page with secure execution state;
- preserve post-combat fallback until new path is runtime-proven.

Diagnostics:
- extend Action Check with role alpha/policy;
- report secure paging readiness/current presentation page;
- keep stock fallback status explicit.

Runtime proof should cover:
- world idle alpha;
- combat alpha;
- PvP alpha if convenient;
- instance alpha if naturally available;
- Primary normal page switching;
- mouse/key execution after page changes;
- icon/cooldown presentation matches executed action;
- no protected/taint/Lua/secret errors.

Do not force vehicle/override/form scenarios solely for proof.

Record unavailable special states with retry conditions.

## Success Criteria

C.4 succeeds when:
- contextual alpha policy is correct and combat-safe;
- Primary always remains fully legible;
- faded actions remain accessible;
- normal Primary paging executes securely;
- presentation follows the securely selected page;
- no combat-time protected mutation error occurs;
- unsupported special states retain stock fallback;
- no required action becomes inaccessible.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **C.3:** complete.
- **D-020:** current geometry is provisional.
- **D-021:** context/paging contract is canonical.
- **Alpha 0:** rejected for action-context fading.
- **Special action states:** capability-gated until runtime proof.
- **Stock action bars:** remain visible.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C4_CONTEXT_VISIBILITY_SECURE_PAGING_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-021_ACTION_CONTEXT_AND_SECURE_PAGING_CONTRACT.md`
- `docs/memory/investigations/C4_CONTEXTUAL_VISIBILITY_SECURE_PAGING.md`
- `docs/memory/decisions/D-020_ACTION_LAYOUT_CUSTOMIZATION_DIRECTION.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
