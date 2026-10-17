# P0242 — Natural quest-completion evidence and additive narrative

Date: 2026-10-17. Verified P0241 pushed on GitHub `main` at `ee1cbd3`. Proposed runtime `0.0.142-dev`; **new completion renderer runtime UNVERIFIED**.

## Observed Forever session (user-uploaded LOGRES_DIAGNOSTICS_LATEST.lua)

The loadCount 313 / `0.0.141-dev` snapshot (client interface 16001, build 70450) contains `/logres questdialoguecheck` PASS and `Logres questdialogue progress: CANDIDATE (registered=true/true/true events=0 shown=0 skipped=0 complete=0 ... stock=retained actions=none)` before `checkall`. The later `checkall` also passes with no progress events. The user did not report a visible progress dialogue. Thus P0241 source registration and integrated checks are **PASS**, while actual progress presentation is still **DEFERRED / NOT OBSERVED**.

Crucially, a naturally triggered **QUEST_COMPLETE** was recorded by the existing read-only `/logres questinteractionprobe`. `observed=... progress:false complete:true`, `complete=true/1`, `invoked=0`. The event-captured row is quest ID **237**, *In Defense of the King's Lands*: ordinary title, nonempty `GetRewardText` narrative, reward XP **1050**, choices **0**, guaranteed rewards **1**, currencies **0**, spells **0**. The probe reports `secret=false`, `failures=0` for this event. The one reported reward row was **incomplete** for replacement UI: name `<empty>`, count 3, quality 0, usable true, itemID 858 and item link nil. This does not establish reliable reward identity, selection, full reward coverage, or readiness for action ownership. No player-initiated Continue/claim or gossip transition was tested.

## Narrow implementation boundary

P0242 extends the existing QuestDialogue event handler's `QUEST_COMPLETE` branch to read the current ordinary positive finite quest ID, nonempty title and nonempty `GetRewardText()` only, using established secret-safe read helpers. It presents that exact native narrative through the existing paged renderer with **offer controls disabled**, retains all Blizzard completion/reward UI, and clears presentation on QUEST_FINISHED, GOSSIP_CLOSED, fresh quest states, Immersion OFF, or world transition. No currency/reward/item reconstruction, selection control, claim invocation, polling, extra event subscriber, or new suppression.

If any ordinary source read is absent, secret, empty or invalid, the renderer shows nothing and Blizzard remains usable. Diagnostics distinguish observed event, displayed narrative and skipped data. The P0241 progress gate stays unchanged and unproven visually. Static source checks do not prove the P0242 renderer has displayed for a live `QUEST_COMPLETE` event.

## Runtime gate

After deployment/reload, use `/logres panel` -> **F — Quest Experience -> Quest Dialogue Check** and Phase 0 -> **Run All**. The new `Logres questdialogue completion` line should show registered=true and no failed source. A natural completion may be recorded by the existing **H — Integration and Polish -> Quest Interaction Probe** read-only action; if observed, check Logres narrative and all Blizzard rewards/Complete remain accessible, with no Lua/secret/taint/protected error. If not naturally available, record **DEFERRED**, not PASS. Do not request travel solely to manufacture proof. Both runtime completion narration and P0241 progress narration require their own natural positive proof.
