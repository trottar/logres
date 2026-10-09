---
memory_schema: 1
as_of: 2026-10-09
project: logres
---

# Current State

## Active Objective

**Phase H.1 OPEN.** Verified GitHub `main` `8f5d94ff8e8c9e2876dd993765f8865ea54e244c` includes P0179 docs-only acceptance and P0178 R1 (`0.0.95-dev`) UI ownership registry. This permanent 35-surface Blizzard ↔ Logres audit passes its observed Immersion ON/OFF transitions and Run All, but STOCK is ownership policy, **not verified frame visibility**. The original P0178 over-60-upvalue slash load failure is preserved as historical FAIL, corrected by R1.

## Current Work Item

**P0180 — source-locked runtime diagnostic candidate (`0.0.96-dev`), NOT PUSHED/NOT IN-GAME VERIFIED.** Use the existing `StatusAuras` UNIT_AURA/target-change event listener to capture bounded, secret-first canonical vs priority aura source observations, and safely classify ordinary target reaction as attackable/friendly/unknown. No new events, UI mutations, polling, renderer changes or suppression. Keep the UI ownership checker at 35 policy entries and use Run All for regression.

## Verified State

- `main` `8f5d94f` contains P0179 checkpoint and P0178 R1. Uploaded 0.0.95-dev loadCount 229 diagnostics: `/logres` works; Run All completes with no recorded Lua/command errors, HUD visible when ON and hidden when OFF, five native domains folded/restored, cast gate armed/unarmed, `gateEscapes=0`; ownership ON `17 PASS/18 STOCK/0 FAIL`, OFF `16 PASS/19 STOCK/0 FAIL`, restored ON 17/18; lifecycle and preference PASS.
- P0177 canonical target HELPFUL ordinary candidate read (priority zero) was not identified as hostile; player/target HARMFUL naturally populated live source and visual coverage remain DEFERRED, sometimes ordinary empty and sometimes restricted. Secret skips are per-index scan observations, not count of hidden auras.
- P0180 has no in-client result yet. Static checks cannot promote source/renderer runtime claims.

## Next Action

Apply P0180 ZIP against exact `8f5d94f` main; full shadow static contracts and `git diff --check`, then deploy and `/reload`. Test `/logres status`, Phase H Status Aura Preview ON/OFF + Status Aura Check, Phase 0 Run All, and UI Ownership Check. Record event-latched ordinary-empty/restricted/positive/reaction evidence only if naturally encountered. Any Lua, taint or protected/secret error is FAIL and must be repaired before advance. On clean observed scope user commits/pushes, then verify GitHub main. Do not force combat solely for evidence.

## Success Criteria

Event diagnostics are guarded by Immersion ON and preview OFF; no scans mutate Blizzard/UI. Existing aura lanes, mana, stock auras, native cast gate, 35-surface ownership matrix and Run All regressions remain working. `hostileMax` or `baseMax` only establishes an ordinary source candidate, not proven visual or complete replacement. Preserve privacy/restriction skips and environmental DEFERRED outcomes.

## Do Not Reopen Without New Evidence

No exact player HP, exact enemy level/class/difficulty, secret-capable inspection, blanket suppression/reassertion. Stock target/player aura, class/pet, party, Main/Override/possess, minimap, full quest and unsupported interaction fallbacks remain. PvP modifies Immersion rather than turning OFF. Historical FAIL/deferrals: P0175 R2 nil-rows, original P0176 prewrite conflict, P0177 omitted-file push, original P0178 >60-upvalues; intermittent loot ObjectiveTracker flash remains OPEN/INTERMITTENT/UNREPRODUCED.

## Relevant References

- `docs/memory/patches/P0180_AURA_EVENT_HISTORY.md`
- `docs/memory/evidence/P0180_AURA_EVENT_HISTORY_2026-10-09.md`
- `docs/memory/patches/P0179_ACCEPT_P0178_R1_RUNTIME.md`
- `docs/memory/evidence/P0179_ACCEPT_P0178_R1_RUNTIME_2026-10-09.md`
- `docs/memory/decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`
- `docs/memory/decisions/D-042_WORLD_TARGET_ANCHOR_AND_FALLBACK_POLICY.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
