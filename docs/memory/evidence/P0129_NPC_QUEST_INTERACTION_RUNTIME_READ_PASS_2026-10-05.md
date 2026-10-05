# P0129 — NPC Quest Interaction Read-Only Runtime PASS — 2026-10-05

Status: **PASS FOR OBSERVED OFFER/GOSSIP/REWARD-CHOICE READS; PROGRESS/COMPLETE DEFERRED**

Durable implementation:
`e50676b993b9f5bc544eab610f99c7532dc98148`

Runtime:
`0.0.59-dev`

## Scope

P0129 was the first runtime capability probe for D-035 NPC quest interaction.

It was intentionally read-only:
- no Accept;
- no Decline;
- no Continue;
- no final reward;
- no gossip selection;
- no Blizzard quest/gossip suppression.

## Runtime result

Observed client:
- interface `16001`;
- client version `1.60.1`;
- build `70205`;
- Logres load count `136`;
- runtime `0.0.59-dev`.

The probe action passed on each recorded run.

Final observed event counts:
- `GOSSIP_SHOW = 1`;
- `GOSSIP_CLOSED = 2`;
- `QUEST_DETAIL = 3`;
- `QUEST_PROGRESS = 0`;
- `QUEST_COMPLETE = 0`;
- `QUEST_FINISHED = 6`.

All registered read API groups reported available.

All expected quest/gossip mutation function groups reported present.

Mutation invariant:
`invoked=0`.

No secret value or API-call failure was recorded in the observed
`GOSSIP_SHOW` / `QUEST_DETAIL` snapshots.

## Proven offer/detail samples

Three real quest-detail states were captured.

### Quest 86585 — Banner of the Fallen

Observed ordinary values:
- title;
- narrative body;
- objective text;
- reward XP `1250`;
- two reward choices;
- zero guaranteed rewards;
- zero observed reward currencies;
- zero observed reward spells.

Two selectable reward rows were captured with:
- item name;
- count;
- quality;
- usability;
- item ID;
- item link.

This proves the tested reward-choice metadata is sufficient to identify the
choice to the player.

### Quest 436 — Ironband's Excavation

Observed ordinary values:
- title;
- narrative body;
- objective text;
- reward XP `340`;
- zero reward choices;
- zero guaranteed rewards.

### Quest 255 — Mercenaries

Observed ordinary values:
- title;
- narrative body;
- objective text;
- reward XP `1800`;
- zero reward choices;
- zero guaranteed rewards.

## Gossip read result

The observed `GOSSIP_SHOW` snapshot returned:
- one available quest row;
- quest ID `86585`;
- title `Banner of the Fallen`;
- `repeatable=false`;
- no observed active-quest rows;
- no observed generic gossip options.

The available-quest list therefore has real runtime proof for stable quest ID and
title on the tested NPC flow.

## Integrated regression result

The post-probe `checkall` completed with every recorded integrated check PASS.

Relevant quest continuity:
- `QuestDialogue`: PASS;
- detail events `3`;
- accepted events `3`;
- finished events `6`;
- last quest ID `255`;
- body/objective present;
- `secret=false`;
- `error=nil`.

No Lua, secret-value, taint, protected-action, or unintended quest-state mutation
was reported in the tested scope.

## Environmental deferrals

The following were not naturally observed:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- active gossip quest rows;
- generic gossip-option rows;
- reward currencies;
- reward spells.

These are **DEFERRED**, not PASS or FAIL.

Do not require travel or contrived quest states solely to manufacture those
proofs.

## Capability consequence

The offer/detail narrative path is now runtime-proven strongly enough to replace
the temporary excerpt-style Logres presentation with the approved bounded/paged
narrative reader while Blizzard controls remain fully available.

Reward-choice read metadata is proven for one real two-choice quest, but reward
control ownership remains unproven.

All quest/gossip mutation ownership remains unproven despite function presence.

## Decision

Next:
**P0130 — bounded/paged NPC quest-offer narrative presentation.**

P0130 may:
- consume the already-proven `QUEST_DETAIL` title/body/objective path;
- preserve full source prose through discrete pages rather than truncation;
- add player-driven presentation-only page controls;
- use approved sheet 07 visual treatment;
- retain Blizzard Accept/Decline/reward/gossip controls untouched.

P0130 must not:
- call quest/gossip mutation APIs;
- suppress Blizzard controls;
- claim progress/completion presentation proof;
- claim reward-selection ownership.
