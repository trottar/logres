---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** GitHub `main` verified at `5379a9f` (P0176 R1, `0.0.92-dev`). Uploaded loadCount 224 diagnostics prove P0176's preview-excluded live history and clean Run All: target HELPFUL max=1/positiveReads=4, player/target HARMFUL max=0, 456 cumulative secret skips across 53 scan observations. The P0175 R2 nil-rows crash remains a recorded failure corrected by P0175 R3; original P0176 shadow-checker failure is corrected by R1. Stock auras, secure Main/Override fallback and the unresolved loot tracker flash remain guarded.

## Current Work Item

**P0177 (`0.0.93-dev`, local candidate).** Review WeakAuras and Plater source families and build an independent Logres-owned bounded aura reader that compares plain `HARMFUL`/`HELPFUL` with priority filters using secret-first per-index queries. Keep it read-only via the existing Phase H Status Aura Check; never promote the new candidate to the renderer without populated in-client evidence. Do not copy external addon code or adopt unrestricted slot/delta reads. Preserve all P0176/R3 source contracts and Blizzard fallback.

## Verified State

P0176 R1 `5379a9f` is pushed and accepted for its observed source-history scope: loadCount 224, checkall complete, HUD `immersion=true visible=true`, layout 16/21, native UI folded=5/open=0, castGate 0 escapes, session history preview-excluded, target helpful max=1 and positiveReads=4, zero source failures. Player and target harmful remain at max=0 and are DEFERRED. Accumulated secret skips across multiple scans do not identify unique auras. The one-off quest UI flash while looting remains OPEN/INTERMITTENT, not fixed. User requested an independently implemented aura subsystem informed by other addons; this is P0177's source comparison prerequisite, not a suppression authorization.

## Next Action

Apply P0177 against exact `5379a9f` baseline, run full shadow checks, deploy to Forever, `/reload`, Phase H Preview ON/Status Aura Check (source engine DEFERRED), Preview OFF/Status Aura Check (three base vs priority summaries when unit present), Phase 0 Run All (complete, HUD visible). Capture a naturally available harmful target/player effect if present without contrived travel; use the comparison summary to distinguish accessible generic HARMFUL vs priority filtering vs restricted indices. If both inaccessible, do not bypass secret protections or suppress stock frames. Report any Lua/taint/secret fault as FAIL.

## Success Criteria

Only ordinary, per-index guarded candidates enter the independent reader; no secret values are inspected or retained. No production aura display, native status, camera, action or quest control changes. Preview performs no source comparison. The check distinguishes per-filter accessible, secret, empty and failure counts while target absence is DEFERRED; full suite and Run All pass for tested scope. Promotion of a new reader into status visuals remains gated on populated runtime evidence, not source speculation.

## Do Not Reopen Without New Evidence

Preserve deliberate absence of exact player HP and target difficulty. Never inspect secret-capable aura values or `UNIT_AURA` delta payload; never suppress private/group or stock status before replacement coverage. D-041 target priority and D-042 world attachment gating remain authoritative. Do not hide MainActionBar without special/edit secure fallback; do not add polling or general native show hooks. Do not infer WoW runtime PASS from static checker results.

## Relevant References

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
