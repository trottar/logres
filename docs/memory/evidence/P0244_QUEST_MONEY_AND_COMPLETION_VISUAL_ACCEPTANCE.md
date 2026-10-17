# P0244 — P0243 visible completion acceptance and missing money

Date: 2026-10-17. Verified GitHub main P0243 R1 `e8455bc`.

## Observed positive evidence

User reports **"pushed. Text matches blizzard"** and supplies screenshot and latest diagnostics. Screenshot shows Logres source completion text (page 2/2), **Lesser Healing Potion x3**, **1050 XP**, and the separate Blizzard **Complete Quest** button visibly available at the left. Quest title is *In Defense of the King's Lands* (ID 237). The source text and item/XP values are user-confirmed matching for this quest, not a universal reward proof. The screenshot contains **7 silver** in Blizzard's rewards but no cash component in Logres; this is a real **OPEN partial-reward-display defect**, not accepted complete parity. Other quest types, choices, currencies, spells and item metadata timing remain unproven.

Latest `LOGRES_DIAGNOSTICS_LATEST.lua`: `0.0.143-dev`, load count 316, Quest Dialogue Check PASS and Phase 0 Run All complete. A subsequent Quest Interaction Probe captured a naturally occurring QUEST_COMPLETE for quest 237, one reward item, 1050 XP, zero choices, zero read failures, and zero quest mutation calls. Item identity was temporarily missing in the probe's later capture (`name=<empty>, link=nil`) although the visible Logres item was correct; **do not assume stable availability across captures**. Phase F diagnostic ran before the natural completion and logged events=0, so the screenshot and user confirmation, **not** post-event dialogue counters, establish the rendering acceptance. No full external Lua/taint error log was supplied.

## P0244 narrow capability

Use Forever-supported `GetQuestLogRewardMoney(questID)` (returns copper for an active logged quest). Pass only the ordinary positive quest ID already validated for the current NPC completion into a guarded `pcall` through the existing read-number helper. Extend this helper to accept the validated argument, check `issecretvalue` before any number inspection, reject missing/invalid/negative/huge or failed reads and distinguish unavailable from a genuine zero. Show compact `g s c` money for a positive ordinary reward, no fixed 7-silver assumption. Keep existing item and XP, the two-line footer, and all Blizzard Complete/Claim/choice controls. Diagnostic exposes ordinary `moneyCopper` and `moneySource` only. Do not use `GetQuestMoneyToGet()` (required money) as payout. Do not inspect protected Blizzard presentation. No polling, mutation, new UI hiding or automatic completion.

## Runtime gate

`0.0.144-dev` candidate. Check developer panel F — Quest Experience → Quest Dialogue Check, then Phase 0 → Run All. Verify new money source diagnostic fields. A naturally viewed quest completion with positive money must show a matching Logres coin payout while native Complete Quest remains available; if not naturally observed, money display is DEFERRED. If API is absent or returns guarded-unavailable, item and XP remain and stock rewards remain usable. P0243 visual acceptance covers this one ordinary quest only. A player-triggered Logres Complete/Claim action, reward choices and quest-related gossip remain separately OPEN; no new mutation ownership in P0244.
