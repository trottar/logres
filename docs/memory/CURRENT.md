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

First-pass source/design resolution is complete.

Implementation is next.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- C.4 complete.
- P0042 pushed at `8f5326a`.
- P0041 routed-key activation proof remains valid.
- stock Bar 2 source frame: `MultiBarBottomLeft`.
- stock Bar 3 source frame: `MultiBarBottomRight`.
- Bar 2 maps to slots 61–72 / Logres Secondary.
- Bar 3 maps to slots 49–60 / Logres Utility.
- Blizzard retains Show/Hide ownership of multi-bars.
- MainActionBar is reused for special action states and is excluded from first
  suppression.
- Bars 4–5 remain outside current Logres coverage and stay visible.
- D-023 selective replacement contract accepted.
- stock Blizzard action bars are still visible in current runtime.

## Next Action

Implement first selective C.5 runtime proof.

Add session-only developer controls:
- Stock Bars Replace ON;
- Stock Bars Replace OFF.

ON, out of combat:
1. snapshot Bar 2 / Bar 3 alpha and mouse states;
2. enable Secondary and Utility Logres key routing;
3. if routing succeeded, set Bar 2 / Bar 3 alpha to 0;
4. disable mouse input on those stock bars and action buttons.

OFF, out of combat:
1. restore exact stock alpha/mouse snapshots;
2. restore prior Secondary/Utility routing state.

Combat-time requests defer until `PLAYER_REGEN_ENABLED`.

Do not suppress:
- MainActionBar;
- OverrideActionBar;
- Bars 4–5;
- special action surfaces.

First proof defaults replacement OFF after `/reload`.

## Success Criteria

First selective C.5 runtime pass succeeds when:
- Bar 2 and Bar 3 are visually absent when replacement ON;
- no invisible stock mouse zones remain;
- Secondary/Utility keyboard actions route through Logres;
- activation feedback works;
- Primary remains stock-visible;
- Bars 4–5 remain stock-visible;
- replacement OFF restores stock bars exactly;
- prior routing state is restored;
- combat-time transition requests defer safely;
- no protected/taint/Lua/secret regression occurs.

## Do Not Reopen Without New Evidence

- **C.1–C.4:** complete.
- **P0040:** retained real visual failure.
- **P0041:** feedback proof complete.
- **MainActionBar suppression:** explicitly deferred by D-023.
- **Bars 4–5:** remain visible.
- **Stock Settings:** must not be rewritten for suppression.
- **Replacement persistence:** deferred until restoration proof.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C5_STOCK_ACTION_BAR_REPLACEMENT_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/investigations/C5_STOCK_ACTION_BAR_REPLACEMENT.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/decisions/D-020_ACTION_LAYOUT_CUSTOMIZATION_DIRECTION.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
