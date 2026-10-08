---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 remains open:** eliminate redundant Blizzard presentation only behind a complete Logres control/information replacement and reversible fail-open ownership. The user's 2026-10-08 whole-screen screenshot documents remaining conventional UI; diagnostic PASS is not whole-screen visual proof. Final H.2 layout/art polishing remains secondary to suppression/coexistence.

## Current Work Item

**P0170 candidate `0.0.87-dev` — correct P0169 clean-login stock Bar 4/5 initialization deferral and false-positive Stock Replace Check.** On P0169 `0.0.86-dev`, immediate post-login Bar 4/5 configuration was unreadable: replacement failed, cleared requested state, and stock bars remained available. Later Run All indirectly retried through preference flips and suppression worked. Preserve initial Immersion desired state, retain stock presentation before ownership, and retry only on the relevant `PLAYER_ENTERING_WORLD`, `EDIT_MODE_LAYOUTS_UPDATED`, or deferred-combat `PLAYER_REGEN_ENABLED` events. Preserve last-known Logres extra-bar visibility when settings temporarily read nil. Phase C Stock Replace Check must FAIL rather than PASS when Immersion requires suppressed bars but `requested/applied` is false, pending, or errored. Use addon-owned retry counters for evidence; no protected-state introspection, broad hooks, timers, polling, or new native surface hiding.

## Verified State

Verified GitHub `main` `74ff4156376c40d96efc100ed2f33415e6462291` / `0.0.86-dev` (P0169). Uploaded diagnostic `LOGRES_DIAGNOSTICS_LATEST.lua` shows initial post-login `stockreplacecheck` **PASS incorrectly** with `requested=false applied=false pending=false error=Bar 4/5 source configuration unreadable`; Bar 4/5 Logres clusters initially shown=false. After the diagnostic's temporary Immersion preference flips, `checkall` showed `requested=true applied=true`, Bar 2–5 alpha 0 / mouse disabled, Bar 4/5 routing true, and Layout Check 15 anchors/17 binds/zero failures. User said "seems okay so far"; this is a provisional functional observation, not a clean-login PASS. Preserve both the failure and recovery in `evidence/P0170_P0169_STARTUP_DEFERRED_FAILURE_2026-10-08.md`. P0168 ordinary quest-offer suppression remains accepted for observed scope.

## Next Action

Apply P0170 only after shadow `git diff --check` and the complete `tools/check_*.py` suite PASS; deploy to Forever `_classic_beta_` and `/reload`. **Before touching any Immersion toggle or running Run All**, run Phase C Stock Replace Check and Action Check and Phase H Layout Check; require requested/applied=true, pending=false, error=nil, stock bars 2–5 suppressed, correct Bar 4/5 clusters/bindings, and no Lua/taint/protected/secret errors. Then Phase 0 Run All, manual action click/hotkey, Immersion OFF/ON restoration, and second `/reload` to ensure reproducibility. A failed first check is a failure even if later Run All recovers. After runtime PASS user stages/commits/pushes and assistant verifies main. Otherwise preserve new failure evidence and correct narrowly.

## Success Criteria

Clean login reaches desired stock Bar 2–5 replacement automatically; no diagnostic-induced preference flip is necessary. Pending source configuration holds native UI usable, retries only on real lifecycle events, and never destroys prior safe Logres presentation due a transient nil. Phase C Stock Replace Check truthfully requires requested/applied state matching Immersion, settled/no-error status, correct stock alpha/mouse and matching routing; Run All reports no false-positive PASS. Full default/special Main, pet, minimap, watched quests, XP, micro-menu and other non-replaced Blizzard controls remain available.

## Do Not Reopen Without New Evidence

Player conventional health bar and exact HP remain intentionally absent; enemy target stays sparse; PvP modifies Immersion rather than disabling it. Do not suppress special Main/Override action modes, PetFrame/action editing, full tracker, minimap, persistent XP, party/CompactParty, target auras/ToT or class/rune controls without approved replacement. No secret-value branching, polling, broad hooks, hidden click regions, or mutation in combat. Preserve prior runtime negatives and deferrals.

## Relevant References

- `docs/memory/evidence/P0170_P0169_STARTUP_DEFERRED_FAILURE_2026-10-08.md`
- `docs/memory/patches/P0170_STARTUP_RECOVERY_AND_STOCK_CHECK.md`
- `docs/memory/patches/P0169_STOCK_BAR_4_5_LAYOUT.md`
- `docs/memory/evidence/P0169_SCREENSHOT_GAP_2026-10-08.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/architecture/BLIZZARD_UI_SUPPRESSION.md`
- `docs/ROADMAP.md`
