---
memory_schema: 1
as_of: 2026-10-09
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** Remote `main` verified at `0f3f0b7` (P0177 R1, `0.0.93-dev`), including the full P0177 aura engine and missing-file repair. Uploaded 0.0.93-dev loadCount 226 finished Run All with Immersion ON, HUD visible, five native domains folded, cast gate escapes=0. Harmful aura live source remains DEFERRED. Original P0178 whole-interface ownership checker `0.0.94-dev` **FAILED at client load**: `Commands.lua:4921: function at line 4566 has more than 60 upvalues`, leaving `/logres` unavailable. The defect is a new local captured runner inside `handleCommand`, not an aura or protected-state error.

## Current Work Item

**P0178 R1 (`0.0.95-dev`, corrective candidate, NOT PUSHED).** Preserve P0178's permanent 35-domain Blizzard ↔ Logres ownership matrix, existing per-module diagnostic snapshots and stock/partial policy. Correct command registration by declaring `function Logres:RunUIOwnershipCheck()` and invoking it through `Logres`, which `handleCommand` already captures. Update P0178 contract to forbid the local helper capture. Source-lock against `0f3f0b7` baseline and/or byte-identical original P0178 output; shadow-test all `tools/check_*.py` before write, transactional rollback on failure. Original P0178's load failure is authoritative negative evidence.

## Verified State

Remote main at `0f3f0b7` contains AuraSourceEngine.lua, its contract, both P0177 manifests and checkpoint records. P0177 source comparator observed one ordinary target HELPFUL candidate (priority=0), repeated guarded secret skips, no demonstrated harmful source and no confirmed hostile target buff coverage. Latest loadCount 226 Run All clean before P0178. User-provided screenshot proves original P0178 `Commands.lua` compiler overflow; the original static/mock checks did not prevent it. No R1 client PASS is claimed.

## Next Action

Apply P0178 R1 ZIP against verified baseline, whether the original P0178 files remain applied or the limited rollback restored selected files. Refuse any unexpected tracked/untracked patch-owned edits or staged work. Verify full shadow suite, manifest and `git diff --check`; deploy to Forever, `/reload`, test `/logres status`, `/logres uiownershipcheck`, developer-panel Phase 0 UI Ownership Check and Run All, then Immersion OFF/ON audit. Record failures immediately. Only after clean client validation may user stage, commit and push; verify remote commit before declaring durability.

## Success Criteria

`Commands.lua` loads and `/logres` registers; 35-surface audit reports expected/observed/flags with PASS/FAIL/DEFERRED/STOCK without new protected reads or mutation. Existing Run All and domain checks remain. Immersion OFF/ON does not trigger Lua, taint, or secret errors. Audit entries expand with future Logres features by registration; no blanket Blizzard suppression, no unproven stock visibility claims. Static PASS does not imply WoW PASS.

## Do Not Reopen Without New Evidence

No exact player HP or enemy level/classification/difficulty. Preserve Blizzard auras/ToT/Focus/boss, minimap, stock Main/Override/possess/pet/class/party/full tracker where capability incomplete, and quest/cast safe fallbacks. PvP is modifier not Immersion OFF. Do not inspect protected/secret values or broaden native frame hooks to fix unreproduced flashes. Historical P0175 R2 nil-rows crash, original P0176 prewrite failure, P0177 missing-file push and P0178 over-upvalue failure remain recorded.

## Relevant References

- `docs/memory/evidence/P0178_R1_SLASH_UPVALUE_FIX_2026-10-09.md`
- `docs/memory/patches/P0178_R1_SLASH_UPVALUE_FIX.md`
- `docs/memory/evidence/P0178_UI_OWNERSHIP_MATRIX_2026-10-09.md`
- `docs/memory/patches/P0178_UI_OWNERSHIP_MATRIX.md`
- `docs/memory/evidence/P0177_R1_DURABILITY_REPAIR_2026-10-09.md`
- `docs/memory/patches/P0177_R1_DURABILITY_REPAIR.md`
- `docs/memory/evidence/P0164_BLIZZARD_SURFACE_OWNERSHIP_AUDIT_2026-10-07.md`
- `docs/memory/decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`
- `docs/memory/decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
