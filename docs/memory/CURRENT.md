---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN:** achieve one integrated world-first Immersion screen without redundant Blizzard presentation, while preserving every required stock information and secure-control fallback. User's 2026-10-08 screenshot proves prior selective suppression did not complete this. Diagnostics do not establish visible disappearance.

## Current Work Item

**P0172 `0.0.88-dev` multi-domain native access/folding runtime candidate:** one coordinated Logres stock-access dock for minimap/navigation, all tracked objectives, status/progress bars and micro-menu/bags; fold only source-identified roots in Immersion ON, and restore them on player command or dock click. Keep a native-root show-state restoration snapshot and use `Hide` rather than alpha-only suppression to avoid invisible click regions. Module uses event-gated availability, combat-lockdown deferral, safe fail-open when roots are absent/unreadable or hide fails, and a permanent combat-release restoration route if disabled during combat. Add a semantic layout dock anchor and developer panel check. **MainActionBar/Override, PetFrame/PetActionBar and required special/secure controls remain stock**, because no combat-safe substitution is proven. This is one multi-domain trial, not whole-screen completion.

## Verified State

GitHub main `26fa1ef7844e76e8c91016d0fe56f7f77458225d` contains P0171 docs-only correction; no runtime change after `95aaa593` P0170 `0.0.87-dev`. P0170 first-login Stock Replace Check (expected/requested/applied=true, pending=false, error=nil), one `PLAYER_ENTERING_WORLD` retry, Action Check, Layout Check (15/17) and Run All passed in uploaded diagnostics. Accepted narrow evidence does not replace actual full-screen visual proof. P0171 captured assistant process/scope failures in durable memory.

## Next Action

Apply P0172 only after exact shadow candidate all static checkers + `git diff --check` PASS. Deploy and `/reload`, run Phase H Native Access Check before any Run All or Immersion toggles. Confirm source-proven domains folded and the slim Logres dock is visible; **visually inspect screenshot and click-through**, because stock code may show a root again. Test MAP / QUESTS / XP / MENU / STOCK dock toggles, mouse operation of restored Blizzard controls, Immersion OFF/ON, login, world transitions, and out-of-combat restoration. Phase H Layout Check should report 16 anchors/18 binds; Phase 0 Run All must remain PASS, no Lua, taint, protected or secret errors. On combat restoration deferral, do not call PASS until stock controls are accessible again. If protected roots reject mutation or re-show on events, record failure and correct narrowly. After runtime result, continue secure Main/Pet replacement/fallback and remaining per-surface integration in the same H.1 product objective.

## Success Criteria

The four new domains can be folded and individually restored on demand without invisible clicks, failed native state, lost functionality or runtime errors; the authored access dock is in its semantic anchor, and all previous action/quest/camera behavior remains. Required Main/pet secure controls remain usable. All user-visible and addon-owned tests agree; no premature declaration of H.1 completion from a partial PASS.

## Do Not Reopen Without New Evidence

User owns commits/pushes. No blanket Show hooks, polling, protected-state readback, persistent binding changes or combat-unsafe mutation. Do not hide Main/override or pet secure controls without proven in-combat safety, restore stock before withdrawal of Logres interaction, and fail open if native roots are unsafe. PvP remains a modifier; player exact HP/conventional health bar remains absent; enemy target remains sparse; target auras/ToT and party/compact groups stay stock. Preserve P0171 failure evidence.

## Relevant References

- `docs/memory/patches/P0172_NATIVE_ACCESS_INTEGRATION.md`
- `docs/memory/evidence/P0172_NATIVE_SURFACE_SOURCE_AND_RUNTIME_GATE_2026-10-08.md`
- `docs/memory/evidence/P0171_H1_SCOPE_AND_DELIVERY_FAILURES_2026-10-08.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/architecture/VISUAL_COMPONENT_INVENTORY.md`
- `docs/memory/decisions/D-032_WORLD_FIRST_LAYOUT_AND_ACTION_ROLES.md`
- `docs/ROADMAP.md`
