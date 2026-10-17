# P0241 — Additive quest-progress narrative (candidate)

Date: 2026-10-17. Baseline GitHub `main` P0240 `048cd77` verified. Candidate `0.0.141-dev`; **WoW runtime UNVERIFIED**.

## Source hypothesis and change

P0240 confirms the accepted QuestDialogue renders ordinary `QUEST_DETAIL` offers only. The event-driven InteractionProbe already captures `QUEST_PROGRESS`, but P0129 showed no natural progress event; this is DEFERRED, not a defect. P0241 adds `QUEST_PROGRESS`/`QUEST_COMPLETE`/`GOSSIP_CLOSED` dispatch to the **existing QuestDialogue event frame**, not a new module or polling loop. InteractionProbe remains an independent read-only diagnostic with its own capture history.

On a progress event, QuestDialogue first releases any current offer controls/suppression, clears its cached offer, and checks current quest ID/title/progress text using the established secret-safe readers. A positive finite ID, nonempty ordinary title and nonempty ordinary `GetProgressText()` are required. Only then does it reuse the approved bounded/paged narrative reader. It does not guess objectives. It passes `showOfferActions=false` and `previewMode=false` so Logres never offers an unproven Continue/Complete control; Blizzard's actual progress interaction remains accessible. On invalid/secret/missing data or Immersion OFF, it shows no new progress presentation; the detailed skip reason is diagnostic, not a global runtime FAIL.

A new detail replaces progress, `QUEST_COMPLETE` clears stale progress (completion remains Blizzard-owned), `QUEST_FINISHED`/world transition clear presentation as before, and `GOSSIP_CLOSED` clears an active progress presentation. No progress state is cached for later Immersion ON restoration, avoiding stale NPC identity after a conversation closes while Immersion is OFF. Accepted ordinary offer reading, paging, player-initiated Accept/Decline and existing stock fail-open route remain unchanged.

## Proof / limits

`/logres panel` -> **F — Quest Experience -> Quest Dialogue Check** reports a second `Logres questdialogue progress:` diagnostic with registration, event/shown/skipped counts, source reason and secret status; **H — Integration and Polish -> Quest Interaction Probe** remains the independent read-only natural-event evidence source. The Phase F Quest Dialogue Preview is **offer-only**; it does not prove progress. No artificial travel or fabricated completion expected. If no natural progress event occurs, status is `not-observed` and live appearance remains DEFERRED. A `QUEST_COMPLETE` event is a cleanup gate, NOT a completion renderer or proof of reward-choice coverage.

**Before runtime acceptance:** guarded applier/static checker suite, Lua load, Quest Dialogue Check, existing Quest Interaction Probe only when naturally relevant, stock Continue present/functional if progress happens, no Lua/taint/protected/secret errors, and offer/Immersion ON/OFF regression checks. Preserve complete Blizzard quest/reward/gossip surfaces until separate player-triggered proofs. P0236 compass, P0238 settings, all other visual domains unchanged.
