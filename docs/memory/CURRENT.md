---
memory_schema: 1
as_of: 2026-10-08
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** GitHub `main` verified at `996f6099`, P0174 R3 (`0.0.90-dev`) runtime accepted for observed quest/cast scope. The unpushed P0175/R1/R2 local `0.0.91-dev` candidate now has a confirmed preference callback regression: Phase 0 Run All aborts with `StatusAuras.lua:273` and leaves Immersion OFF, hiding the Logres mana resource. Harmful auras still lack populated live-source proof and a one-off loot-associated quest-tracker flash remains OPEN / INTERMITTENT.

## Current Work Item

**P0175 R3 (`0.0.91-dev`, corrective candidate, unpushed).** Fix only the disabled status snapshot shape: provide empty `rows`, `harmfulRows`, and `helpfulRows` to each rendering lane so the existing preference/lifecycle Run All checks do not crash while toggling Immersion OFF. Add a static disabled-snapshot regression contract; preserve all P0175 R2 visual categories, stock aura fallback and previous P0174 source-gated native casts. No speculative polling, aura suppression or objective tracker mutation.

## Verified State

P0174 R3 is on GitHub `main` `996f6099`, user-confirmed cast/quest runtime success for observed scope. P0175 R1 user confirmed player/enemy helpful visuals; harmful/debuff visuals were not confirmed. P0175 R2 preview produced player harmful 2 / target harmful 2 / target helpful 2, but live source was empty (player) and target absent; therefore harmful live coverage remains DEFERRED, not PASS. User then reported mana resource absent after Run All. Uploaded Logres diagnostics `0.0.91-dev`, loadCount 221, show `immersionEnabled=false` and `Logres command error: Interface/AddOns/Logres/HUD/StatusAuras.lua:273: attempt to index local 'rows' (a nil value)` immediately after State and Sensor checks. The missing disabled category tables are verified from R2 source; Run All **FAILED**, and preference was not restored. HUD hides resource intentionally when immersion is false. R3 has NO in-game result. The one-off loot-related quest UI flash remains OPEN/INTERMITTENT; P0174 R1/R2 history remains preserved in prior evidence.

## Next Action

Apply R3 on the exact locally installed P0175+R1+R2 manifests at baseline GitHub main `996f6099`; the applier must run the full repo checker suite and diff check on the shadow candidate before tracked writes. Immediate recovery is `/logres immersion on` (the current broken R2 source may still fail when toggling OFF). Deploy the R3 candidate, `/reload`; use Phase H Status Aura Preview ON, OFF and Status Aura Check, then Phase 0 Run All. Verify its completion, no Lua/protected/secret errors, resource remains visible when Immersion ON and expected stock restoration while OFF. Do not push if this reproduces; treat populated harmful aura proof and loot quest flash as separate unresolved gates.

## Success Criteria

No nil status lane on preference callbacks with Immersion OFF/ON, both target categories receive safe empty arrays, Run All reaches `Logres checkall: complete` with all applicable checks actually executed, and mana/resource HUD returns when Immersion ON. Preview-only harmful rows are never called live-data PASS. Stock aura protection and source-secret rules remain unchanged. P0175 R3 runtime outcome remains pending; Phase H.1 is still open.

## Do Not Reopen Without New Evidence

Preserve deliberate absence of exact player HP and target difficulty. Never inspect secret-capable aura values or `UNIT_AURA` delta payload; never suppress private/group or stock status before replacement coverage. D-041 target priority and D-042 world attachment gating remain authoritative. Do not hide MainActionBar without special/edit secure fallback; do not add polling or general native show hooks. Do not infer WoW runtime PASS from static checker results.

## Relevant References

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
