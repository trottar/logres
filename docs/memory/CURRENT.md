---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Complete single-window profession trainer presentation using the proven class-style reversible offscreen native frame parking, and then implement guarded live NPC gossip using existing P previews/Quest shared renderer.

## Current Work Item
**P0314 — guarded profession trainer single-window + visible Blizzard restore fallback; PREPARED / full static and WoW UNVERIFIED.** Verified pushed P0313 R1 GitHub main `5824a1d`. User reports class trainers and tested profession lists/gossip-free source interactions working; P0313 current trainer + Your professions visually accepted. User rejects the continuing duplicate Blizzard profession frame and requests single-window behavior before moving to NPC gossip. P0314 enables single-window parking of the whole native trainer root for ordinary verified profession sessions ONLY after the Logres owned view and an always-available Blizzard UI restoration button are installed. Opaque native anchor restoration, combat guard, class behavior and transaction APIs are preserved. Parked profession Goodbye can now close the native visit after restoring anchors; nonparked profession Goodbye only dismisses Logres. Current trainer copy is refined without inventing an offer.

## Verified State
- P0313 R1 pushed `5824a1d`; user screenshots confirm Enchanting source rows, Fishing empty list with Journeyman 61/150 current trainer and full owned professions sidebar; user reports other professions and class trainers working. Visual/source behavior **PASS within tested scope**; no new transaction retest or proof of stock restoration after parking.
- Enchanting single-skill purchase P0309 user PASS while Blizzard remained visible. Class native parking and native Goodbye from P0308 user PASS. Fishing native 0 service with Blizzard known Journeyman label; Logres now shows independently observed owned Journeyman 61/150, not a native service offer.
- P0311 Enchanting zero-source regression and premature profession native-close were user FAIL/rejected and corrected by P0312; new P0314 guarded native close is a DIFFERENT gated policy and remains UNVERIFIED.

## Next Action
Run guarded P0314 applier on exact clean P0313 main, require **185/185** PREWRITE and POSTWRITE suite, diff --check and manifest; user commits/pushes and main is verified. Deploy and `/reload`, open Cooking/Enchanting/Fishing. Expect only Logres visible after successful parking, including Fishing empty view; press **Blizzard UI** to restore the stock window and dismiss Logres. Reopen and click Goodbye: only a parked profession session requests native close. Confirm class unchanged. A requested training purchase may currently restore Blizzard while the source updates; do not claim postpurchase single-window until tested.

## Success Criteria
A single approved Logres parchment displays current trainer plus the complete character-owned professions, source-backed services or neutral empty data; native trainer frame shown but parked safely, restored before any Logres removal; a persistent explicit Blizzard UI fallback remains mouse-accessible on every profession session; no native invisible click regions; no protected/secret comparisons, no polling, no unguarded transactions. Failed parking leaves usable Blizzard stock; unknown trainer family stays stock. No DynamicCam change.

## Do Not Reopen Without New Evidence
Do not mistake a zero service list for missing profession ownership or offer. The observed Journeyman Fishing rank comes from independently copied owned professions and verified NPC identity. Do not hide Blizzard using alpha-only/invisible interaction. User wants a single visible profession trainer but accepts explicit safe stock fallback. Retain P0311 negative history and P0313 earlier R0 static failures. Quest 237 reserved; no live gossip selection before separate proof.

## Relevant References
- `docs/memory/evidence/P0314_PROFESSION_SINGLE_WINDOW.md`, `docs/memory/patches/P0314_PROFESSION_SINGLE_WINDOW.md`
- `docs/memory/evidence/P0313_TRAINER_FOCUS_ICON_PREVIEW.md`, `docs/memory/evidence/P0312_PROFESSION_CONTEXT_RECOVERY.md`, `docs/memory/evidence/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
