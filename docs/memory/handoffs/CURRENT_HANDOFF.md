# Current Handoff — P0240 quest lifecycle audit; P0241 additive progress gate next

Authority: `docs/memory/CURRENT.md` and `docs/memory/evidence/P0240_QUEST_LIFECYCLE_CAPABILITY_AUDIT.md`. GitHub main P0239 `22ba7ab` verified. P0238 settings UI is runtime-accepted within user-observed scope; P0236 broad POI compass remains accepted and its polish deferred.

P0240 is docs/source only. P0128 API source findings and P0129 `QUEST_DETAIL`/available-gossip/reward-choice read proof already exist. Current `QuestInteractionProbe` records `QUEST_PROGRESS`, `QUEST_COMPLETE`, gossip and bounded read sources without mutation, but progress/complete runtime states have not been naturally observed. `QuestDialogue` only renders offer detail; `OfferActionProbe` permits only exact, player-initiated Accept/Decline. `CompleteQuest` advances to reward; `GetQuestReward` finalizes. Unsupported Continue/Complete/choice/gossip remain Blizzard-owned. P0241 candidate: narrow additive/fail-open progress reader/presentation, reusing existing sources; no periodic polling, no automatic action, no stock suppression. Do not require contrived gameplay proof.

No WoW redeploy for P0240.
