# P0240 — NPC quest-lifecycle implementation/source gap audit

Date: 2026-10-17. Verified `main` P0239 `22ba7ab`. **Source/repository audit only; no new WoW runtime observation or mutating probe.**

## Authority and prior accepted evidence

D-035 establishes future Logres ownership of player-driven NPC offer/progress/completion/reward/quest-gossip flow, bounded narrative reading, explicit choice, and fail-open Blizzard fallback. D-031 preserves the earlier additive Phase-F boundary. P0128 already audited the Forever 1.60.1 API references; this checkpoint is a delta against **current Logres source and accepted runtime evidence**, not a new claim of API discovery or independently revalidated upstream builds.

P0129 `0.0.59-dev` observed real `GOSSIP_SHOW=1`, `QUEST_DETAIL=3`, and one offer with two named reward choices, ordinary item metadata and stable quest ID/title. It observed `QUEST_PROGRESS=0`, `QUEST_COMPLETE=0`, no active-gossip quest rows and no generic gossip-option rows. These were environmental **DEFERRED**, not failures or PASSES. P0131/32/33 subsequently established player-initiated Accept/Decline and the ordinary offer presentation in their tested scope, including `QUEST_FINISHED` preceding `QUEST_ACCEPTED` on the first Accept attempt. Do not generalize that event sequence to completion/claim.

## Exact implementation boundary on current main

| Lifecycle state | Existing Logres code | What remains unproved / missing |
| --- | --- | --- |
| Ordinary `QUEST_DETAIL` offer | `Quest/Dialogue.lua` renders bounded/paged GetQuestID/GetTitleText/GetQuestText/GetObjectiveText; `Quest/OfferActionProbe.lua` binds identity and invokes only explicit Accept/Decline. Offer suppression is separately gated. | Preserve accepted behavior, no new offer mutation. |
| `QUEST_PROGRESS` / Continue | `Quest/InteractionProbe.lua` already registers `QUEST_PROGRESS`, captures GetQuestID/title/GetProgressText (alongside other read-only interaction calls), and records API presence for `CompleteQuest`. `Quest/Dialogue.lua` has no progress renderer; `OfferActionProbe` rejects action kinds other than accept/decline. | No accepted natural progress-event sample, bound ordinary text/quest ID/eligibility, error feedback, or Continue action call. Stock progress/Continue must remain usable. |
| `QUEST_COMPLETE` / final claim | `InteractionProbe` already registers the event, reads GetRewardText, reward XP, counts, at most four `choice` and `reward` item rows, plus bounded currencies/spells when a safe quest ID exists. It records availability of `GetQuestReward`. | No naturally observed completion read sample, verified full reward choice set, selected-reward identity, transaction/error recovery, or Logres claim call. Four-row cap is diagnostic truncation, not complete reward UI. Stock completion/rewards must remain usable. |
| Quest-related gossip | `InteractionProbe` event-captures read-only GetAvailableQuests/GetActiveQuests/GetOptions (four rows maximum per kind); present APIs include SelectAvailableQuest/SelectActiveQuest/SelectOption/SelectOptionByIndex. | Only a single available quest list was proven in P0129; active quest rows and transition calls lack runtime proof. `AllowedWhenUntainted` references from P0128 are not an ownership authorization. Stock gossip remains usable. |

**API semantics retained from P0128:** `CompleteQuest()` advances the progress interaction to the completion/reward stage. It is not final turn-in. `GetQuestReward(itemChoice)` finalizes the quest; a nonzero required choice must be player-selected and bound to the correct quest before that call. Function existence is not safety proof for a real Forever session. No speculative auto-turn-in, gossip selection, or unsupported permanent Blizzard hide.

## Source observation versus runtime limits

- `Quest/InteractionProbe.lua` already has an event-owned read-only capture for the two missing lifecycle events; do **not** add a timer, duplicate event subscriber, or repeat global quest scans solely to retry them. Its diagnostic `MAX_ROWS=4` and `TEXT_LIMIT=96` cannot establish completeness of a future user-facing choice/narrative renderer. It reads `choice`/`reward`, but does not by itself prove all required quest items, currencies and spells in real final-reward states.
- `Quest/Dialogue.lua` has an event handler for `QUEST_DETAIL`, not for progress/complete. Reusing its approved paging and UI primitives for a new lifecycle state is an integration candidate, not a license to hide stock frames or capture secret-capable values.
- `Quest/OfferActionProbe.lua` explicitly refuses action kinds outside Accept/Decline, and correlates `QUEST_ACCEPTED`/`QUEST_FINISHED` only for offers. Its pending-state correlation must not be reused blindly for reward claims.
- `Quest/OfferStockSuppression.lua` restores on `QUEST_PROGRESS`, `QUEST_COMPLETE`, and other terminal/transition events but owns only explicitly proven **offer** control suppression. Restoration hooks do not imply permission to suppress progress, completion, or gossip.
- Latest P0239 accepted settings evidence (load 312) does not contain a natural `QUEST_PROGRESS`/`QUEST_COMPLETE` sample. Inability to reproduce these without travel or specific quests is **environmental deferral**, not a runtime PASS or FAIL. The existing panel's **H — Quest Interaction Probe** is read-only; its event log is the preferred naturally triggered evidence source. Manual probe may capture no applicable NPC state.

## Narrow next candidate / acceptance gates

**P0241 candidate:** capability-gated, additive progress-state **read/presentation** preparation using the existing event-owned `QuestInteractionProbe` and the established paged quest UI. First, inspect the existing capture/diagnostic contracts and add only the missing safe ordinary identity/text/eligibility evidence if justified; preview may exercise appearance but is explicitly not live data proof. If ordinary progress data is absent, secret, invalid, or ambiguous, render nothing new and leave Blizzard stock controls intact. No mutation API, gossip selection, reward claim, stock suppression, periodic polling, or invented data. Source-only/static results remain UNVERIFIED until a natural event is observed.

After naturally available progress proof, a **separate** explicitly player-triggered Continue diagnostic may be considered with exact bound quest identity and error/fallback behavior, never bundled with reward claim. Complete/reward/choice and quest-gossip each require their own observed source and action gates before any UI takeover. Do not request contrived travel to manufacture proof.

## Status

**P0240 SOURCE AUDIT COMPLETE; runtime unchanged.** Offer controls remain accepted, unsupported progress/complete/gossip behavior remains Blizzard-owned and OPEN / ENVIRONMENTALLY DEFERRED. P0236 compass and P0238 settings untouched. No WoW redeploy required.
