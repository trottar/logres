# P0239 — P0238 limited settings UI runtime acceptance

Date: 2026-10-17. GitHub `main` P0238 commit `0eb1976` verified after the user reported a successful push.

## User observation and in-game diagnostics

- User reports: **"No issues with setting ui"** after using the P0238 implementation. This is positive in-game visual/interaction feedback for the first player-facing settings panel; individual clicks were not separately logged.
- Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`: `LogresDB.meta.loadCount=312`, `Logres 0.0.140-dev` (`status` entry), Forever interface `16001` / build `70450`.
- Saved state at export: `immersionEnabled=true`, `activeQuestEnabled=true`, database schema 3. The exported settings do not preserve the intermediate OFF states.
- The current-load command history includes `/logres settings` followed by `/logres preferencecheck`; that check reports `PASS (snapshot isolation=true, callbacks=2, revision=8, immersionEnabled=true)`. Revision 8 is evidence of preference changes within the load, but does **not** identify which UI control triggered each revision.
- The uploaded diagnostic snapshot contains no reported P0238 command error. A full client Lua/taint/protected-action error log was not provided, so absence of all possible errors cannot be claimed.
- Existing compass/source snapshots in the same upload continue to report `compasscheck: PASS`, near quest candidates 2/2, service candidates 4/4, and local proximity `sized=6` / scale 0.8366–1.1874. The last QuestieDB gossip probe remains **DEFERRED**, separate from settings.

## Acceptance and boundaries

**Accept P0238 as the working first settings-panel slice**: a user-facing UI for exactly the existing persisted Immersion and Active Quest choices, reached through the supported command/developer-panel action and backed by the established preference publisher. No new database schema or stock UI ownership. Positive feedback plus preferencecheck is a bounded runtime PASS, not a proof of every Immersion native restoration transition, inaccessible contexts, combat safety, or accessibility completeness.

**Still OPEN / DEFERRED**: complete visual settings language, accessibility options, coherent optional feature choices, quest-related UI completion, POI category filters/eligibility, whole-screen polish and environmental combat/special-mode checks. Preserve the P0236 compass and its known historical quest-giver relevance limitation; do not re-open compass-only tuning based on this settings checkpoint.

## Next approved distinct work

The Phase H roadmap and accepted D-035 require eventually owning the player-triggered NPC quest lifecycle beyond offer Accept/Decline: progress/Continue, completion/Complete, reward selection and quest-related gossip transitions. Those routes are not yet source/runtime-proven as Logres-owned. **Next P0240 should be a targeted read-only/source capability audit** of those surfaces and the existing `Quest/InteractionProbe.lua` / `Quest/Dialogue.lua` / `Quest/OfferActionProbe.lua` paths, identifying one narrow safe candidate and preserving Blizzard fallbacks. No direct mutation or suppression may follow from static API existence alone. Do not require artificial gameplay or travel merely for environmental evidence.

**Patch type:** documentation-only; no Lua/media/settings changes and no WoW redeploy.
