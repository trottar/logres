---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN:** finish the integrated world-first screen, preserving required Blizzard information and secure controls. User reports P0172 dock buttons work and most native Blizzard presentation is gone, with Main primary action bar still visible. The uploaded post-P0172 diagnostics pass but did not prove every stock domain stayed folded during an uninterrupted normal-world gameplay interval.

## Current Work Item

**P0173 `0.0.89-dev` — Primary action/stock ownership runtime gate:** read-only, source-identified mode/readiness status for MainActionBar and the Logres secure Primary cluster. Add `primaryownershipcheck` (Phase C developer panel, slash command and Run All). No native Main mutation, no automatic Primary key routing, no protected readback, no deletion of special controls. A source-backed normal candidate is not combat-safe suppression authorization. H.1 remains open.

## Verified State

GitHub `main` `3a5028c8f8cbf288a22b80d6de902dc7b2762b4e` contains P0172 `0.0.88-dev`. User confirms most stock elements no longer visible (except Main primary) and the dock controls work. Uploaded diagnostics: `nativeuicheck` PASS with `folded=0 open=4` after manual toggles, `layoutcheck` PASS 16/18, stock Bars 2–5 replacement PASS, `actioncheck` PASS, integrated Run All PASS. This is accepted only as stated; four-open diagnostic is not proof of four-folded persistence. Existing Primary diagnostic shows `keys=false/12` and `primaryRoutingOwned=false`; Main/Override and pet secure controls remain stock. P0171 scope/delivery failures stay recorded.

## Next Action

Apply P0173 after complete shadow static checker suite PASS; deploy and `/reload`. First run Phase C Primary Ownership Check **before Action Keys ON or Run All**; record normal/special mode API coverage and native 12-button presence. Then manually test Action Keys ON with an already-known harmless existing binding and normal mouse execution, Action Keys OFF stock recovery, and any naturally encountered page/special context (unavailable = environmental DEFERRED). Run Primary Ownership Check after each state, then Action Check, Native Access Check, and Run All. Screenshot normal display and inspect accessible stock controls. **Do not fold Main yet.** Next implementation must prove combat-time special-mode route, stock access/editing and restoration before suppressing Main.

## Success Criteria

The read-only mode gate reports truthful ordinary/secret/missing classifications, Phase C command and Run All execute without Lua/taint/secret/protected errors, native stock remains accessible and working, and actual Primary keys/clicks plus OFF restoration are observed. A normal candidate alone never closes Main suppression or H.1.

## Do Not Reopen Without New Evidence

No MainActionBar Hide/alpha/click suppression before secure special-mode and combat transition proof. No automatic override key routing without proof. No blanket hooks, polling, protected readback, secret inspection, binding persistence or user-owned Git writes. Keep pet, party, special controls and target aura/ToT fallbacks. Player exact HP/conventional health bar remains absent, PvP remains a modifier. Preserve P0171 and P0172 negative/unproven evidence.

## Relevant References

- `docs/memory/patches/P0173_PRIMARY_OWNERSHIP_GATE.md`
- `docs/memory/evidence/P0173_PRIMARY_OWNERSHIP_GATE_2026-10-08.md`
- `docs/memory/evidence/P0172_NATIVE_SURFACE_SOURCE_AND_RUNTIME_GATE_2026-10-08.md`
- `docs/memory/evidence/P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/ROADMAP.md`
