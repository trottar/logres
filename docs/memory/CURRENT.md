---
memory_schema: 1
as_of: 2026-10-21
project: logres
---

# Current State

## Active Objective
Complete live, read-only trainer information in the accepted portrait-free landscape while Blizzard retains trainer filtering, selection, purchase actions and stock fallback. No visual refinements or native replacement at this checkpoint.

## Current Work Item
**P0292 — TRAINER IDENTITY, ABILITY PREREQUISITES AND SOURCE STATUS / PREPARED; WSL AND WOW UNVERIFIED.** GitHub `main` verified at P0291 `0afc236`. User WoW screenshots of `0.0.192-dev` show five Druid skills with real icons, ranks, Level requirements, costs and selected spell description in Logres's live landscape; H panel reports `live-read-only-visible`, `displays=3`, `deferrals=0` and zero reported native purchase/filter/selection/geometry writes. Missing relative to Blizzard: `Wrath (Rank 2)` ability prerequisite `Wrath (Rank 1)`, trainer name `Mardant Strongoak`, and readable source-backed availability status. P0292 adds only bounded independent source reads and model labels, with no trainer transaction authorization.

## Verified State
- **P0291 pushed `0afc236` / WoW LIVE READ-ONLY INFORMATION PASS (tested fields):** five real service names and ranks, spell icon imagery, level requirements, costs and selected description appear; H panel PASS for ON/OFF. Missing Wrath prerequisite and trainer identity remain OPEN; no claim of full native replacement or purchase safety.
- **P0290 R2 pushed `61838ba` / partial source PASS:** five named live services rendered. P0290 R0 memory-health PREWRITE failure and R1 Git EOF whitespace failure remain recorded; R2 corrected packaging. P0285–P0289 misread the Forever tuple and omitted H panel registration; negative evidence remains in historical records.
- **Blizzard Forever source:** its native trainer enumerates ability prerequisites through `GetTrainerServiceNumAbilityReq(index)` / `GetTrainerServiceAbilityReq(index, slot)`, uses `UnitName("npc")` as ordinary trainer heading (pet trainer has separate native logic), and derives status from string service types (`available`, `unavailable`, `used`, `header`). This evidence authorizes descriptive labels only, never Logres training interaction.

## Next Action
Apply P0292 guarded ZIP on verified P0291, require PREWRITE/POSTWRITE full checker suite, prewrite whitespace gate, `git diff --check` and manifest. User commits and pushes, then verify `main`. Deploy to beta and `/reload`; with ordinary Druid trainer open use `/logres panel` → H → Live Trainer ON (TEST); compare heading, `Wrath (Rank 2)` prerequisite and source status against stock. Use Live Trainer OFF. No general audit or training purchase.

## Success Criteria
Trainer heading and ability prerequisites display only when individually secret-safe and bounded; service status is sourced from a recognized native string, not inferred trainability. No new clickable Logres controls, native mutation, polling or suppression. The accepted P and live landscape composition remains unchanged. Runtime UNVERIFIED until user screenshot/panel results.

## Do Not Reopen Without New Evidence
Keep native service indices separate from filtered row order, Blizzard-owned selection/Train/Train All, protected-state restoration and stock fallback. Never inspect secret-capable values. Do not reopen unrelated compass, camera, pet, navigation or quest work.

## Relevant References
- `docs/memory/handoffs/CURRENT_HANDOFF.md`
- `docs/memory/evidence/P0292_TRAINER_INFORMATION_COMPLETENESS.md`, `docs/memory/patches/P0292_TRAINER_INFORMATION_COMPLETENESS.md`
- `docs/memory/evidence/P0291_FOREVER_TRAINER_DATA.md`, `docs/memory/evidence/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/memory/patches/PATCH_INDEX.md`, `docs/ROADMAP.md`
