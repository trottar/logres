# P0262 — N2 shared NPC narrative pagination view

**Status:** Prepared / WSL full-suite and WoW visual regression UNVERIFIED at handoff. **Expected baseline:** `main` `b439d4f91c5eb4b8c491b976696bfd3451e36d0b` (P0261 verified).

Narrow extraction: relocate the *actual* bounded text splitting, pager position/indicator/chevrons and page body text display from `Quest/Dialogue.lua` into `UI/NarrativePages.lua`. Keep original quest-owned framing, layout, frame factory, controls, action handlers, native restoration, preview registrations, camera source and DynamicCam behavior untouched. The P0261 narrative model and original `PresentText` view remain one shared live/preview path.

The one-time `P0262_APPLY.py` refuses unrelated Git baselines and dirty tracked state; checks each modified original Git blob; constructs candidates entirely before writes; checks CURRENT file size, new static contract, unchanged camera/stock controllers and candidate whitespace; executes **all** `tools/check_*.py` in a full tracked-file shadow tree before write and again after; reverts patch-owned files on any postwrite failure; creates `P0262_MANIFEST.txt`; removes P0262 payload only on success. No commit/push. See `docs/memory/evidence/P0262_N2_NARRATIVE_PAGE_EXTRACTION.md` for exact UI validation and deferred failures.

Historical P0261 R0 memory-size, R1 stale history-label, R2 60-local command limit failures are not overwritten. P0262 changes **no Commands.lua** and prevents the previous P0261 TOC adjacency regression by inserting its new UI file ahead of the Quest section. No independent camera test required beyond checking the working behavior remains unchanged.

## P0262 R0 prewrite static failure (2026-10-18)

User ran the original P0262 applier against verified clean P0261 main. Baseline and 16-candidate preparation both PASS, but full shadow suite FAILS `tools/check_p0255_quest_action_page_contract.py`: it still looked for the exact historical pager positions `-115,78` and `-115,17` inside `Quest/Dialogue.lua`, although N2 moved those statements verbatim into `UI/NarrativePages.lua`. **Result: FAILED STATIC / NO TRACKED WRITE.** R1 updates that historical checker to load and inspect the real shared painter, including original completion/offer/final-page guards and coordinates. The existing P0255 native claim and final-page stock gates remain enforced. This failed attempt is not a WoW runtime finding and is not classified PASS.
