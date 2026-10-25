# P0335 — L-027 native quest/XP pop-up provenance, source boundary

**Baseline:** P0334 R3 pushed on GitHub main `1b7b1ffe602d3fcd8c914ce03ded344d6c45bc30` (2026-10-25); P0334 static manifest 205/205 PRE/POST. All newly changed runtime code remains **UNVERIFIED** until Forever client reopens (November 4, 2026).

## User observation (OPEN / REPORTED)

Blizzard XP and quest-task pop-ups remain alongside Logres's temporary XP/objective cues. Their exact native frame/mixin has not been identified in a client screenshot with frame ownership. This issue is **not** declared resolved by source reading or an absent popup during testing.

## Source evidence, not runtime attribution

- `Logres/Immersion/NativeAccess.lua` already folds `ObjectiveTrackerFrame` (objectives) and `StatusTrackingBarManager` (progress) with an explicit STOCK/QUESTS/XP dock, manual native restoration and event-driven objective refolds. The folding module reports its *own* domain snapshots, reasons, refold counts, deferrals and errors via `GetDebugStatus`. These do **not** prove the visibility of Blizzard frames in combat and must not be treated as native state inspection.
- `Logres/Quest/XP.lua` is an addon-owned temporary `QuestXP` pulse; `Logres/Quest/Progress.lua` is the addon-owned `QuestObjectiveProgress` pulse. Both expose read-only `GetDebugStatus` counters/reasons. Prior F.3/F.6 evidence explicitly calls those cues *additive*, with stock notification suppression not established by their runtime visual PASS.
- Blizzard's `AddAutoQuestPopUp(questID, type)` is documented for Forever and places OFFER/COMPLETE entries in the Objective Tracker; it is not proof that the observed symptom comes from that API. Other transient quest/XP notification owners remain unidentified. Do not infer `AlertFrame` ownership from a screenshot without verified frame/source evidence.

## P0335 bounded instrumentation

Extend only the already user-invoked `/logres gameplaycapture` / Phase 0 Gameplay Snapshot. It now reads additive, cached Logres-owned `NativeAccess`, `QuestXP` and `QuestObjectiveProgress` debug summaries through the existing `readCaptureStatus` guard, without obtaining or mutating any Blizzard frame, secret health, reward, protected action or quest ID. No new event, hook, polling, P-tab button, aura read or SavedVariable schema. Diagnostics are still bounded by P0329's 120-line/100-run store. The printed `NativeAccess` domain status is **addon-owned requested/folded policy**, not a verified Blizzard visible-state assertion.

## Actual client gate (November 4 or later)

1. Preserve the P0321 gossip-restoration first-boot gate and D-046 visual checks. When the unsolicited XP/quest notification naturally recurs, capture a screenshot/video distinguishing the Logres pulse from each native popup (position/text/icon and duration). Do not deliberately travel/farm to reproduce.
2. Trigger `0 — Gameplay Snapshot` or `/logres gameplaycapture` while the symptom is present, then `/reload` when appropriate to save the bounded diagnostic. Record `NativeAccess domains`, `refolds/nativeShows/failures`, XP pulse count/shown/reason and objective pulse count/shown/reason with contextual screenshot.
3. If native `objectives` and `progress` are both addon-folded but a second toast persists, classify the *other owner* using the client's safe Frame Stack UI (`/fstack`) if available, without reading secret/protected presentation from Logres Lua. Preserve a screenshot and exact frame/source. If the toast carries quest claim/remote-complete interaction, maintain Blizzard access until Logres owns the safe replacement.
4. Only then design a separate capability-gated suppression/restoration patch. Preserve Blizzard native fallback and stock interaction. No blanket `AlertFrame` hiding, global frame OnShow hook, private Blizzard state read or frequent retries.

## Classification

P0335 source capture: static-only contract, **UNVERIFIED** runtime. L-027 popup suppression: **OPEN / REPORTED / OWNER UNCONFIRMED**. P0334 PvP and P0330–P0333 runtime validation still deferred. Source audit found no confirmed specific popup owner; this negative limitation is preserved for the next run.
