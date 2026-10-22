---
memory_schema: 1
as_of: 2026-10-20
project: logres
---

# Current State

## Active Objective
Resolve observed P0289 live-trial runtime **FAIL** without repeating general trainer audits: admit independently ordinary, bounded service names and render explicit withheld-detail placeholders when category/other row fields are incomplete. Keep native trainer session, source secret gates, selected-service index, stock controls and all purchases Blizzard-owned. P0284 visual acceptance remains scoped to the fixture.

## Current Work Item
**P0290 R2 — TRAINER PARTIAL-SOURCE RECOVERY / PREPARED, WSL+WOW UNVERIFIED.** Verified pushed P0289 R1 `aee3f9d`. User WoW screenshot from `0.0.190-dev` proves H Live Trainer ON/OFF first-page actions exist (panel PASS), but repeated ON attempts all returned `unsafe-or-incomplete-service-row` with `shown=false`, `displays=0`, `purchases=0`, `filterWrites=0`, `selectionWrites=0`, and `nativeGeometryWrites=0` (**LIVE PRESENTATION FAIL**). Specific rejected source row state was not exported, so do not assert it was secret. P0290 independently captures a safely gated name even if another tuple field is unavailable and permits four known probe states in the live adapter, displaying explicit placeholders when name/cost is withheld. No trainer frame suppression, polling, native selection or transaction changes.

## Verified State
- **P0289 R1 pushed `aee3f9d` / H panel PASS, live data FAIL:** WoW `0.0.190-dev` shows Live Trainer ON/OFF on H first page. Repeated live ON returned `unsafe-or-incomplete-service-row`, `shown=false`, `displays=0`, increasing deferrals and zero purchases/filter/selection/geometry writes. Which individual row field triggered rejection is UNPROVEN.
- **P0290 R0 PREWRITE FAIL / R1 candidate:** the user verified ZIP SHA and P0289 baseline; 161 checkers ran, with one `check_memory_health.py` failure: the generated `CURRENT.md` exceeded the 20,000-byte hard limit. Refused before any tracked file write. R1 condenses CURRENT and retains detailed negative evidence in append-only memory.
- **P0290 R1 POSTWRITE FAIL / R2 candidate:** 161/161 PREWRITE and POSTWRITE checkers passed, but `git diff --check` rejected a blank EOF line in CURRENT.md; rollback expected. R2 repairs the section writer and adds PREWRITE diff checks. Runtime Lua unchanged. It preserves independently ordinary service names when other fields defer; display safe, bounded indexed placeholders and unknown costs in the approved renderer. Four recognized probe states are nontransactional. Impossible source identity/session and unrecognized states still defer. Blizzard's trainer handles all selection/filtering/training; Logres train controls stay disabled.
- **P0284 visual PASS; P0285–P0288 live work PARTIAL/UNVERIFIED:** approved portrait-free fixture must not be mistaken for a production trainer. P0285–86 established name, selected ID, wallet and Forever numeric category tuple; enum meaning remains unverified. P0287 R0 failed the checker-version policy; R1 is pushed. P0288 added one-shot live display but failed at partial row admission. No evidence authorizes native ownership or purchase controls. See linked evidence and patch history.

## Next Action
Apply P0290 guarded ZIP against verified pushed P0289 R1 `aee3f9d`, requiring PREWRITE/POSTWRITE static-suite and diff PASS. User commits/pushes, verify remote `main`, then deploy to WoW. Open an ordinary trainer, `/logres panel` → H → Live Trainer ON (TEST); inspect named/withheld row presentation and stock controls, then Live Trainer OFF. A screenshot or the specific panel result suffices. No H source/frame audit or trainer purchase needed.

## Success Criteria
A source snapshot with safely known service identity and one or more incomplete row fields renders the accepted mouse-inert landscape, clearly labeling withheld data and unclassified availability. Invalid session/root/combat/secret-capability source remains DEFERRED; no native purchase, filter, selection or geometry writes. The H panel records `live-read-only-visible` or `live-partial-visible`. WoW remains UNVERIFIED until user test.

## Do Not Reopen Without New Evidence
Do not infer addon installation from one guessed filesystem path or the presence/absence of a Lua global alone. No hard QuestieDB dependency, package bundling, unknown CurseForge project ID, global quest ID scans on updates, guessed quest availability, invented coordinates or native pin scraping. Do not hide the Blizzard minimap, alter user-accepted waypoint/focused-quest bearings, or treat missing locations as PASS. Baked flavor must not be guessed from a Source-only indicator. Keep negative and deferred evidence explicit.

## Relevant References
- `docs/memory/handoffs/CURRENT_HANDOFF.md` (current execution handoff)
- `docs/memory/evidence/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md` (P0289 runtime failure, P0290 R0 prewrite failure, correction)
- `docs/memory/patches/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md` (patch detail)
- `docs/memory/evidence/P0289_TRAINER_LIVE_PANEL_ROUTING.md` (historical panel regression and R1 checkers)
- `docs/memory/evidence/P0288_TRAINER_LIVE_READONLY_TRIAL.md` (first live adapter)
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/memory/patches/PATCH_INDEX.md`, `docs/ROADMAP.md` (history and next roadmap gates)
