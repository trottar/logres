---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** Remote `main` verified at `a2eed84` (`0.0.93-dev` tracked P0177 changes), but the P0177 new source module, checker, patch/evidence and manifest were OMITTED from that commit. This is a durable repository defect even though the user's local client successfully ran the P0177 source comparator. P0177 R1 reconstructs those exact missing files. Live target HELPFUL source was observed; player/target HARMFUL remain unproven. Blizzard aura, action and quest fallback policy stays unchanged.

## Current Work Item

**P0177 R1 (`0.0.93-dev`, source/durability repair, not pushed).** Restore only original P0177's four omitted files and original manifest, plus explicit corrective memory. Require exact `a2eed84` tracked baseline; accept matching preexisting untracked files, refuse mismatches, shadow-test full static suite before writing. The read-only aura comparison and all UI rendering remain unchanged. The earlier original P0177 commit contained only 12 modifications and left the TOC referencing a noncommitted file.

## Verified State

Uploaded `0.0.93-dev` client diagnostics loadCount 225: Phase H preview excluded the source engine (`DEFERRED`); preview OFF returned empty ordinary HARMFUL for player and present target in checked moments, with zero source failures. The target `HELPFUL` base scan returned one ordinary candidate while two priority filters returned zero; live history retained targetHelpful max=1/positiveReads=5. Later checks showed base filters with 12 secret index skips and priority totals of 24 per group; these are repeated scan results, not unique hidden auras, and their triggering context is not established. Phase 0 Run All reached completion with Immersion ON, HUD visible, native UI folded=5/open=0 and cast gate escapes=0. User saw buffs on player and target but could not establish if the target was hostile; do not classify enemy-buff coverage as proven. The distinct earlier nil-row crash and original P0176 prewrite checker failure remain historical. Loot-linked quest tracker flash remains OPEN/INTERMITTENT.

## Next Action

Apply P0177 R1 repair at exact `a2eed84`, confirm full checker suite/manifest, and stage *all new P0177 files* explicitly. Git commit and push only by user; verify GitHub `main` contains the real engine and checker before advancing. P0177 already ran in WoW from local files; this repair does not change runtime Lua, so no WoW redeploy is required. Next aura investigation remains targeted: get naturally populated harmful-source evidence and distinguish friendly from hostile targets when encountered, without forcing gameplay or inspecting secret values.

## Success Criteria

Remote main must contain P0177's original AuraSourceEngine.lua, static checker, patch/evidence and manifest, plus R1 repair evidence. Full repo checkers pass, `git diff --check` clean, no changes to existing runtime behavior. After the push, verify the new files on main. Distinguish live ordinary HELPFUL from DEFERRED harmful/hostile coverage; do not infer success from structural PASS or repeated secret skips.

## Do Not Reopen Without New Evidence

Preserve deliberate absence of exact player HP and target difficulty. Never inspect secret-capable aura values or `UNIT_AURA` delta payload; never suppress private/group or stock status before replacement coverage. D-041 target priority and D-042 world attachment gating remain authoritative. Do not hide MainActionBar without special/edit secure fallback; do not add polling or general native show hooks. Do not infer WoW runtime PASS from static checker results.

## Relevant References

- `docs/memory/patches/P0177_R1_DURABILITY_REPAIR.md`
- `docs/memory/evidence/P0177_R1_DURABILITY_REPAIR_2026-10-09.md`

- `docs/memory/patches/P0177_AURA_SOURCE_ENGINE_COMPARISON.md`
- `docs/memory/evidence/P0177_AURA_SOURCE_ENGINE_COMPARISON_2026-10-08.md`

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
