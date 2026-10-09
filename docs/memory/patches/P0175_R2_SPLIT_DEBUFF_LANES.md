# P0175 R2 — Independent target harmful/helpful aura lanes

**Baseline:** verified local P0175 + P0175 R1 working tree; remote main `996f6099`.
**Runtime:** `0.0.91-dev`, unchanged corrective revision.
**Status:** candidate, not yet tested in WoW.

The user confirms player and enemy buffs visible, but reports no debuffs. Existing P0175 R1 target presentation multiplexed five icons across harmful and helpful categories, allowing one category to consume capacity intended for the other. P0175 R2 maintains independent bounded target **harmful** and **helpful** rows, target harmful priority first, event-driven refresh, native tooltip, secret-first indexed sources, and the screen-space target fallback. Existing player harmful presentation is unchanged. No Blizzard aura hiding or source completeness claim is made.

The uploaded runtime diagnostics are precise: static preview PASS with 2 player and 3 target icons, whereas live check returned player=0/empty and target=0/unit-absent. They do not establish a populated harmful-source failure. R2 distinguishes preview-only, live-populated, and unproven harmful sources, and separately reports target harmful/helpful slot occupancy. Never mark missing live harmful effects PASS merely because preview passes.

The user also observed a short quest UI flash while looting. Existing R2 ObjectiveTrackerFrame OnShow reconciliation reports at least one combat deferral in the latest P0175 run; the particular loot-triggered source is not established. Preserve OPEN / INTERMITTENT / UNREPRODUCED and the confirmed flash in memory; no speculative polling, blanket Show hooks, alpha/mouse concealment, or extra Hide retries are introduced. Existing quest correction remains unchanged.

Phase H panel retains Status Aura Check, Preview ON, Preview OFF; previously relocated pet probe controls remain in Phase C. Acceptance: full checker suite and Run All, preview split rows, real player harmful and target harmful only when naturally available, clean combat and tooltip behavior, Immersion OFF/ON, no Lua/taint/secret errors. Stock aura and QUESTS fallback remain accessible. Full D-041 suppression, Main/special-mode suppression and world-attached target remain OPEN.
