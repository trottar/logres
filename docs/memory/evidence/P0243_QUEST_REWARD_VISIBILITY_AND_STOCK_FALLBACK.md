# P0243 — Natural completion with missing Logres rewards/Complete UI

Date: 2026-10-17. User verifies P0242 pushed `18b0fa0` and reports: **"Logres quest shows up no complete or quest rewards"**. This is a meaningful incomplete capability, not accepted visual proof of reward replacement.

## New observed session

Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`: `0.0.142-dev`, loadCount 315, both P0241 progress and P0242 completion event registration true. Dialogue checks were captured before a natural event, and showed complete events=0, completion shown=0. Later `questinteractionprobe` captured natural QUEST_COMPLETE for quest 237, `In Defense of the King's Lands`, with ordinary reward narrative, XP=1050, 0 choices, one guaranteed reward `Lesser Healing Potion x3`, valid item link ID 858, secret=false, failures=0, mutations invoked=0. This is stronger item metadata than the earlier loadCount 313 where name and link were unavailable. Crucially **there is no post-event QuestDialogue diagnostic**; whether the new completion prose was rendered, or stock UI obscured, cannot be concluded from the probe. The user confirms Logres quest UI appears, but no Logres Complete/Claim or reward details appear.

## Classification

The missing Logres reward and Complete controls are an **OPEN product-integration gap**. P0242 was narrative only, not reward or action implementation. This does not prove stock Blizzard controls were hidden; this must be evaluated separately before stock UI ownership can change. Do not declare the quest completion flow finished from the P0242 source check.

## P0243 capability boundary

Add a brief reward readout only during ordinary QUEST_COMPLETE, gated by safe `GetRewardXP`, `GetNumQuestChoices`, `GetNumQuestRewards`, and a single guaranteed item's `GetQuestItemInfo`, with secret checks before any inspection. When choices are present, multiple item rewards exist, or data are secret/incomplete, show native-review fallback text rather than fabricate identity/choices. Always instruct completing/claiming via Blizzard. No `GetQuestReward`, `CompleteQuest`, reward selection, gossip mutation, new suppression, protected/frame introspection, or polling. Use the existing 50px objective footer with a REWARDS heading. This is intentionally not a complete rewards/choice interface; more complicated rewards require their own safe layout and source gates.

## Runtime acceptance gate

After deployment, Phase F Quest Dialogue Check and Phase 0 Run All must pass. Only call reward readout RUNTIME PASS if a natural QUEST_COMPLETE is followed by visible Logres reward text **and** native completion controls are available. Report missing controls or visual obstruction as an OPEN FAILURE for correction before extending ownership. If no event, mark DEFERRED; no contrived gameplay.

## P0243 R0 pre-write static regression — FAIL (2026-10-17)

The user applied `P0243_QUEST_REWARD_SUMMARY.zip` (SHA-256
`497bc7333c2411ae03b60e8fe8c52925ae88722a317e5d25b6fed621f1fdeec7`).
The applier stopped in the SHADOW static suite at
`tools/check_p0242_quest_completion_contract.py`:
`ERROR: missing completion.title, completion.body, "", "QUEST_COMPLETE",`.
P0243 correctly passed `rewardSummary` as the narrative footer instead of the
old empty string; the P0242 checker still required an exact empty-footer string.
**FAIL = PREWRITE CONTRACT COMPATIBILITY**, not evidence of WoW runtime breakage.
Only the three existing ignored/untracked PNG previews were shown by `git status`; tracked
changes and the P0243 manifest were not written. No user commit/push was performed.

## P0243 R1 repair — prepared, runtime unverified

P0243 R1 guards the current P0242 checker Git blob and updates its narrow
completion call-site rule. Both the original empty footer and the new exact
`completion.title, completion.body, rewardSummary, "QUEST_COMPLETE",` call
remain permitted; the latter requires the existing source-gated
`ReadCompletionRewardSummary()` helper and the exact `false,false,false`
presentation action flags. All P0242 restrictions against mutations,
polling, frame hide, and unsupported quest ownership remain.
The new P0243 checker also verifies backward-compatible gate presence.
R1 records the R0 checker failure without reclassifying runtime as PASS.
