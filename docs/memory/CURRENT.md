---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** `main` verified at `c55b6d7` with combined P0175/R1/R2/R3 (`0.0.91-dev`). The P0175 R2 nil-rows / Run All crash was corrected by R3: uploaded loadCount 222 diagnostics reach `Logres checkall: complete` with HUD `immersion=true visible=true` and no Lua errors. Populated live player/target harmful auras remain DEFERRED; brief loot-associated Objective Tracker flash remains OPEN / INTERMITTENT. Blizzard aura and secure action fallbacks stay intact.

## Current Work Item

**P0176 R1 (`0.0.92-dev`, corrective unpushed read-only candidate).** The original P0176 ZIP FAILED safely in the shadow checker before tracked writes: its live-history call altered the disabled-snapshot source shape required by `check_status_aura_disabled_contract.py`. R1 preserves that historical failure, keeps the R3 disabled-snapshot guard unchanged and moves the diagnostic call to the guarded post-snapshot read path. Retain a per-session, preview-excluded history of ordinary aura-row peaks and positive reads for player harmful, target harmful and target helpful on the existing safe `readUnit` event path. Surface these counts through the existing Phase H Status Aura Check, without modifying rendering, source filters, Blizzard aura fallback, native cast gating, target attachment or quest folding. This preserves naturally occurring evidence after the aura or target disappears.

## Verified State

P0175 R3 is durable at `c55b6d7`. Uploaded `0.0.91-dev`, loadCount 222 diagnostics record saved Immersion ON, Phase 0 Run All complete, HUD visible=true, Layout 16/21, native access 5 folded/0 open, cast gate armed with 0 escapes, source and status checks PASS within observed scope. No repeat of `StatusAuras.lua:273` nil-rows error. Status preview yielded 2 player harmful, 2 target harmful and 2 target helpful **preview-only** icons; live check had player harmful 0 and no target, so no harmful-source PASS. R1 user observed buffs but no debuffs; R2 split categories, live proof still missing. Loot quest flash remains intermittent/unreproduced. This evidence does not independently prove the mana bar's visual pixels, only HUD visibility diagnostics.

## Next Action

Apply P0176 R1 at exact verified `main` HEAD `c55b6d7` with clean tracked files; its applier preflights source SHA, all static contracts and diff hygiene in a shadow checkout, then writes transactionally. Deploy and `/reload`; use Phase H Status Aura Preview ON/Check/OFF, then Phase 0 Run All and Status Aura Check. When naturally relevant, observe actual player/target harmful effects, inspect a matching Blizzard debuff vs Logres icon, then check Phase H history after the effect expires/target clears. If live history never captures the visible source or any Lua/taint error occurs, preserve FAIL/deferral and do not push. Do not manufacture gameplay merely for proof.

## Success Criteria

No false preview-as-live PASS. Session history accumulates only bounded ordinary per-category counts after the secret-first source path while active and preview OFF; no aura identifiers retained or UNIT_AURA delta inspection. History survives target disappearance and Immersion OFF/ON within the session, resets on `/reload`. Run All passes and HUD/resource stays available with Immersion ON. Actual debuff rendering and full replacement remain unproven until visually/runtime observed, and stock aura coverage remains intact.

## Do Not Reopen Without New Evidence

Preserve deliberate absence of exact player HP and target difficulty. Never inspect secret-capable aura values or `UNIT_AURA` delta payload; never suppress private/group or stock status before replacement coverage. D-041 target priority and D-042 world attachment gating remain authoritative. Do not hide MainActionBar without special/edit secure fallback; do not add polling or general native show hooks. Do not infer WoW runtime PASS from static checker results.

## Relevant References

- `docs/memory/patches/P0176_R1_LIVE_AURA_CHECKER_COMPAT.md`
- `docs/memory/evidence/P0176_R1_LIVE_AURA_CHECKER_COMPAT_2026-10-08.md`
- `docs/memory/patches/P0176_LIVE_AURA_EVIDENCE.md`
- `docs/memory/evidence/P0176_LIVE_AURA_EVIDENCE_2026-10-08.md`

- `docs/memory/evidence/P0175_R3_PREFS_RESOURCE_RESTORE_2026-10-08.md`
- `docs/memory/patches/P0175_R3_PREFS_RESOURCE_RESTORE.md`

- `docs/memory/patches/P0175_R2_SPLIT_DEBUFF_LANES.md`
- `docs/memory/evidence/P0175_R2_SPLIT_DEBUFF_LANES_2026-10-08.md`

- `docs/memory/patches/P0175_R1_PANEL_TARGET_AURAS.md`
- `docs/memory/evidence/P0175_R1_PANEL_TARGET_AURAS_2026-10-08.md`
- `docs/memory/patches/P0175_PRIORITY_STATUS_LANES.md`
- `docs/memory/evidence/P0175_PRIORITY_STATUS_LANES_2026-10-08.md`
- `docs/memory/evidence/P0174_R3_CAST_NATIVE_GATE_2026-10-08.md`
- `docs/memory/decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`
- `docs/memory/decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
