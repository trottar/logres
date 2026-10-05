# P0128 — NPC Quest Interaction Source / Capability Audit — 2026-10-05

Status: **SOURCE LAYER RESOLVED — TARGETED READ-ONLY RUNTIME PROBE NEXT**

Baseline:
`ef56075dbea1fdb8c613e3ee88c38e2684ef4170`

Runtime:
unchanged at `0.0.58-dev`

Canonical product decision:
`../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`.

Canonical active investigation:
`../investigations/NPC_QUEST_INTERACTION_CAPABILITY.md`.

## Question

What can current Forever source evidence establish about NPC quest information,
rewards, actions, and gossip transitions before Logres attempts any runtime
replacement?

This is source/API evidence, not proof that mutation calls are safe to invoke from
Logres in every runtime context.

## Prior repo evidence

Phase F already established:
- `QUEST_DETAIL` on Forever;
- current displayed quest ID/title/body/objective passive reads;
- reward XP read;
- `QUEST_ACCEPTED`;
- Blizzard ownership of quest controls.

The current production `QuestDialogue` module still reads only:
- `GetQuestID`;
- `GetTitleText`;
- `GetQuestText`;
- `GetObjectiveText`.

It remains additive and does not suppress Blizzard quest/gossip UI.

P0126 Active Quest is independent and does not claim NPC quest interaction
ownership.

## Current source findings

Warcraft Wiki's current Classic API comparison identifies Forever `1.60.1` as a
distinct supported game type. The pages below were reviewed against that Forever
catalog.

### 1. Narrative and quest-state information

Current Forever source references support:
- `GetQuestID`;
- `GetTitleText`;
- `GetQuestText`;
- `GetObjectiveText`;
- `GetProgressText`;
- `GetRewardText`;
- `QUEST_DETAIL`;
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_FINISHED`.

`GetQuestID` is meaningful for the current NPC quest after `QUEST_DETAIL`, and
after `QUEST_PROGRESS` / `QUEST_COMPLETE` for accepted quests, until
`QUEST_FINISHED`.

Source:
- https://warcraft.wiki.gg/wiki/API:GetQuestID
- https://warcraft.wiki.gg/wiki/API:GetTitleText
- https://warcraft.wiki.gg/wiki/API:GetProgressText
- https://warcraft.wiki.gg/wiki/Event:QUEST_DETAIL

Classification:
**SOURCE-AVAILABLE; detail path partly runtime-proven; progress/complete paths still
runtime-unproven.**

### 2. Reward information

Current Forever source references support interaction-context reward inspection
including:
- `GetNumQuestChoices`;
- `GetNumQuestRewards`;
- `GetQuestItemInfo("choice"|"reward"|"required", index)`;
- `GetQuestItemLink(...)`;
- `GetRewardXP`;
- `C_QuestOffer.GetQuestRewardCurrencyInfo`;
- `C_QuestInfoSystem.GetQuestRewardCurrencies`;
- `C_QuestInfoSystem.GetQuestRewardSpells`;
- `C_QuestInfoSystem.GetQuestRewardSpellInfo`.

The existing historical `LogresQuestAudit` probe already contains read-only calls
for:
- `GetRewardText`;
- `GetRewardXP`;
- `GetNumQuestChoices`;
- `GetNumQuestRewards`.

However, canonical Phase-F runtime evidence only establishes reward XP on the
tested detail flow. It does not prove complete reward-choice/item/currency/spell
coverage.

Sources:
- https://warcraft.wiki.gg/wiki/API:GetQuestItemInfo
- https://warcraft.wiki.gg/wiki/API:GetQuestItemLink
- https://warcraft.wiki.gg/wiki/API:GetRewardXP
- https://warcraft.wiki.gg/wiki/API:C_QuestOffer.GetQuestRewardCurrencyInfo
- https://warcraft.wiki.gg/wiki/API:C_QuestInfoSystem.GetQuestRewardCurrencies
- https://warcraft.wiki.gg/wiki/API:C_QuestInfoSystem.GetQuestRewardSpells
- https://warcraft.wiki.gg/wiki/API:C_QuestInfoSystem.GetQuestRewardSpellInfo

Classification:
**SOURCE-AVAILABLE; broad reward presentation still runtime-unproven.**

### 3. Quest actions

Current Forever source references expose:
- `AcceptQuest()` — accepts the currently offered quest after `QUEST_DETAIL`;
- `DeclineQuest()` — declines the currently offered quest;
- `CompleteQuest()` — advances from quest progress to the reward/completion step;
- `GetQuestReward(itemChoice)` — finalizes the quest and selected reward.

Important semantic distinction:
`CompleteQuest()` does not itself finalize the quest; `GetQuestReward()` performs
the final completion/reward claim.

Sources:
- https://warcraft.wiki.gg/wiki/API:AcceptQuest
- https://warcraft.wiki.gg/wiki/API:DeclineQuest
- https://warcraft.wiki.gg/wiki/API:CompleteQuest
- https://warcraft.wiki.gg/wiki/API:GetQuestReward

The reviewed source pages establish function availability and purpose, but this
audit does not have Forever runtime evidence for:
- invoking these functions from Logres;
- taint/protected/hardware-event behavior across all relevant states;
- error/eligibility behavior;
- safe recovery after a rejected or failed action.

Therefore no action call is authorized by P0128.

Classification:
**SOURCE-AVAILABLE; MUTATION CAPABILITY UNPROVEN.**

### 4. Quest-related gossip transitions

Current Forever source references support structured read-only gossip lists:
- `C_GossipInfo.GetAvailableQuests()`;
- `C_GossipInfo.GetActiveQuests()`;
- `C_GossipInfo.GetOptions()`.

They also expose transition functions:
- `C_GossipInfo.SelectAvailableQuest(questID)`;
- `C_GossipInfo.SelectActiveQuest(questID)`;
- `C_GossipInfo.SelectOption(gossipOptionID, ...)`;
- `C_GossipInfo.SelectOptionByIndex(orderIndex, ...)`.

The selection functions reviewed are marked `AllowedWhenUntainted` in the current
API reference.

Sources:
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.GetAvailableQuests
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.GetActiveQuests
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.GetOptions
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.SelectAvailableQuest
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.SelectActiveQuest
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.SelectOption
- https://warcraft.wiki.gg/wiki/API:C_GossipInfo.SelectOptionByIndex

`AllowedWhenUntainted` is not treated as production ownership proof. Logres still
needs runtime evidence for real NPC flows, confirmation states, failures, and
fallback.

Classification:
**READ SOURCES AVAILABLE; TRANSITION MUTATION UNPROVEN.**

## Source-layer capability matrix

| Surface | Source/API status | Existing runtime proof | P0128 result |
| --- | --- | --- | --- |
| Offer title/body/objective | Available | PASS on tested `QUEST_DETAIL` flow | **PROVEN READ BASELINE** |
| Progress text | Available | Not naturally observed | **RUNTIME PROBE REQUIRED** |
| Completion/reward text | Available | Not naturally observed | **RUNTIME PROBE REQUIRED** |
| Reward XP | Available | PASS on tested detail flow | **PARTIAL READ PROOF** |
| Reward items/choices | Available | Not canonically proven | **RUNTIME PROBE REQUIRED** |
| Reward currencies/spells | Available | Not canonically proven | **RUNTIME PROBE REQUIRED** |
| Accept/Decline | Available mutation APIs | Not invoked by Logres | **UNPROVEN — DO NOT CALL YET** |
| Continue (`CompleteQuest`) | Available mutation API | Not invoked by Logres | **UNPROVEN — DO NOT CALL YET** |
| Finalize/reward (`GetQuestReward`) | Available mutation API | Not invoked by Logres | **UNPROVEN — DO NOT CALL YET** |
| Gossip available/active quest lists | Available | Not canonically proven | **RUNTIME PROBE REQUIRED** |
| Gossip quest selection | Available mutation APIs | Not invoked by Logres | **UNPROVEN — DO NOT CALL YET** |
| Generic gossip option selection | Available mutation API | Not invoked by Logres | **UNPROVEN — DO NOT CALL YET** |

## Smallest next runtime slice

The correct next step is **not** quest-control replacement.

Prepare one event-driven, read-only NPC quest-interaction capability probe,
integrated into the developer panel.

It should observe, without mutation:

Events:
- `GOSSIP_SHOW`;
- `GOSSIP_CLOSED`;
- `QUEST_DETAIL`;
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_FINISHED`.

Interaction-context reads:
- quest ID/title/detail/objective/progress/reward text;
- reward XP;
- reward/choice counts;
- bounded reward item/choice metadata;
- reward currency/spell presence where safely available.

Gossip reads:
- available quest list;
- active quest list;
- generic option list.

Mutation capability:
- record only whether the relevant action/selection functions exist;
- do **not** call Accept/Decline/Complete/GetQuestReward or gossip-selection
  functions in this first probe.

Secret discipline:
- secret-check returned containers/rows/scalars before type inspection,
  comparison, formatting, counting, or iteration;
- if a source cannot be inspected safely, record it as secret/unavailable and
  leave Blizzard UI untouched.

## Runtime exit gate for the probe

The read-only probe should establish:
- which interaction states occur naturally;
- which narrative/reward reads are safe ordinary values;
- whether reward-choice metadata is sufficient for an informed replacement;
- whether structured gossip quest rows expose stable quest IDs/titles;
- any missing, secret, invalid, or failed states.

Only after that evidence should the project choose one action-specific mutation
probe, ideally one player-triggered action with Blizzard UI still visible as
fallback.

## Result

**SOURCE LAYER RESOLVED.**

Next:
**P0129 — read-only NPC quest interaction runtime capability probe.**

No Blizzard quest/gossip suppression or quest-state mutation is authorized by
this source audit.
