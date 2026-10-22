# P0303 — NPC catalogue extraction: first reusable trainer-finalization step

Date: 2026-10-22. Authoritative baseline: GitHub `main` P0302 `05f8afc1970a8383f34c1b1dfdc01fc24696a2a2`. **P0303 R1 PREPARED / WSL full-suite and WoW runtime UNVERIFIED** until the user applies and tests this checkpoint.

## Confirmed user runtime evidence

User reports P0302 highlights work on all trainer interactions and has **successfully purchased all offered spells using Logres Train All**. This is a **scoped bulk purchase PASS** by direct user report, superseding the earlier P0301 quote-only status. Prior visible screenshots showed the P0301 quote of four skills at 39 silver matching Blizzard; the user now confirms actual learning. Do not invent per-spell receipt or native audit counters. P0300 Goodbye, P0299 search/filter, P0298 icons, P0295 local selection, P0296 single-skill training and seven-row scrolling previously passed within their tested scopes. Historical failed visuals and partial/untested combat, slider and long-session cases remain in their canonical evidence.

## Why extraction precedes stock suppression

D-046 requires fixture -> model -> renderer -> guarded adapter -> interaction; D-047 requires common NPC lifecycles and fallback. The trainer has correct source/paint/purchase separation but locally duplicates catalogue filtering/windowing, and future gossip/merchant/flight list presentations must not fork it. P0303 extracts source-neutral `NPCServiceCatalogue.Filter`, `Window`, `Find`. The trainer uses the same conditional All/Available plus case-insensitive name search, seven-slot clamp/rail semantics and captured native service identity; its callbacks still originate only from addon-owned ordinary copied records.

No visual geometry, selection behavior, purchase decision, Blizzard frame, source query, backdrop, Quest UI, NPC camera, or synthetic preview is modified. The shared module does not know about trainers, WoW frames, names/ranks, or money. It is placed before the trainer live adapter in the TOC. The existing quest dialogues are not changed by this patch.

## In-client checks and negative result policy

After WSL static PASS and push verification, `/reload`; at open trainer `/logres panel` -> H - Integration and Polish -> Live Trainer ON (TEST). Compare All sampled and Available results, type `curse`/`CURSE`, select different skills, scroll wheel/slider to final page, search empty and restore selection, verify hover and Goodbye. No purchases needed; do not repeat successful Train All only to manufacture new evidence. If any Lua, protected or secret error occurs, P0303 runtime FAIL; record exact observation before continuing.

Native Blizzard window remains **VISIBLE / STOCK-OWNED**. Default automatic Logres presentation and safe native visual suppression/restoration are **NEXT**, not smuggled into this data extraction. Next service order explicitly accepted by user: native gossip first after trainer, then merchant, then flight master; all must use the *existing* accepted Logres parchment/translucent layout, not generic fantasy mockups. Later flight-map route availability must be source-backed; never invent flight locations or native travel capability.

## R0 prewrite failure and R1 repair

User ran the guarded R0 applier against verified clean P0302 main; exact baseline/hash, source-anchor, EOF and candidate whitespace gates passed, but **2/174 PREWRITE checkers failed**. `check_p0288_trainer_live_trial_contract.py` required the contiguous native skin to live-trial TOC load adjacency; R0 inserted the new catalogue between them. The P0303-specific checker also rejected the evidence because its mandatory uppercase `UNVERIFIED` marker was absent. This is an assistant-authored packaging/contract mismatch, not a WoW failure. **R0 FAIL / CLOSED BY R1 CONTENT REPAIR; R1 STATIC AND RUNTIME UNVERIFIED.** The guard stopped before tracked writes; no user rollback is necessary. R1 loads the shared catalogue just after the native service probe, before the unchanged Components/Motif/Landscape/Skin/Trial chain, and updates this evidence. Re-run all checkers in the candidate shadow tree and actual checkout before commit.
