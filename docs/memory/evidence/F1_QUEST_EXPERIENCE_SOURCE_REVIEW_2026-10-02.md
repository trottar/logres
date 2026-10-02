# F.1 Quest Experience Source / Capability Review — 2026-10-02

Status: COMPLETE — D-031 ACCEPTED
Date: 2026-10-02
Baseline: P0077 / `bf73fcf49e31177e9305652e509fd46a4aad12dc`

## Scope

Review Forever-facing sources for:
- NPC quest interaction;
- quest log/objectives;
- selected/super-tracked quest state;
- quest destination output;
- XP/rested XP;
- stock ownership and suppression boundaries.

This record is source/API evidence, not runtime proof except where explicitly
linked to prior runtime evidence.

## Forever source findings

Current Warcraft Wiki API references identify the following as available on
Forever `1.60.1`:

### Quest log / objective data

- `C_QuestLog.GetInfo`;
- `C_QuestLog.GetQuestObjectives`;
- `C_QuestLog.GetNextWaypoint`;
- `C_QuestLog.GetNextWaypointForMap`;
- `C_QuestLog.GetQuestIDForQuestWatchIndex`;
- selected/super-tracked quest APIs in the Forever API catalog.

`C_QuestLog.GetQuestObjectives` is `AllowedWhenUntainted`, may return nothing,
and may require quest data to be cached.

`C_QuestLog.GetNextWaypoint` and `GetNextWaypointForMap` are
`AllowedWhenUntainted` and may return nothing.

Sources:
- https://warcraft.wiki.gg/wiki/API:C_QuestLog.GetQuestObjectives
- https://warcraft.wiki.gg/wiki/API:C_QuestLog.GetNextWaypoint
- https://warcraft.wiki.gg/wiki/API:C_QuestLog.GetNextWaypointForMap
- https://warcraft.wiki.gg/wiki/World_of_Warcraft_API/Classic

### Quest-giver interaction state

Forever source references include:
- `GetQuestID`;
- `GetTitleText`;
- `GetQuestText`;
- `GetObjectiveText`;
- `GetProgressText`;
- `GetRewardText`;
- quest interaction events including:
  - `QUEST_DETAIL`;
  - `QUEST_PROGRESS`;
  - `QUEST_COMPLETE`;
  - `QUEST_FINISHED`.

`GetQuestID` is meaningful in the displayed quest-giver context after the
relevant quest interaction event and before `QUEST_FINISHED`.

Sources:
- https://warcraft.wiki.gg/wiki/API:GetQuestID
- https://warcraft.wiki.gg/wiki/API:GetTitleText
- https://warcraft.wiki.gg/wiki/API:GetProgressText
- https://warcraft.wiki.gg/wiki/API:GetRewardText
- https://warcraft.wiki.gg/wiki/Event:QUEST_DETAIL
- https://warcraft.wiki.gg/wiki/Event:QUEST_PROGRESS

### Quest lifecycle events

Forever source references include:
- `QUEST_ACCEPTED`;
- `QUEST_TURNED_IN`;
- `QUEST_LOG_UPDATE`;
- watch/update events.

`QUEST_TURNED_IN` supplies quest ID, XP reward, and money reward.

Sources:
- https://warcraft.wiki.gg/wiki/Event:QUEST_TURNED_IN
- https://warcraft.wiki.gg/wiki/Events/W

### XP

Forever source references identify:
- `UnitXP`;
- `UnitXPMax`;
- `GetXPExhaustion`;
- `PLAYER_XP_UPDATE`;
- `UPDATE_EXHAUSTION`.

`UnitXP` and `UnitXPMax` are `AllowedWhenUntainted`.
`GetXPExhaustion` returns nil when no rested XP is present.

Sources:
- https://warcraft.wiki.gg/wiki/API:UnitXP
- https://warcraft.wiki.gg/wiki/API:UnitXPMax
- https://warcraft.wiki.gg/wiki/API:GetXPExhaustion
- https://warcraft.wiki.gg/wiki/Event:PLAYER_XP_UPDATE
- https://warcraft.wiki.gg/wiki/Event:UPDATE_EXHAUSTION

## Prior runtime evidence that still constrains F.1

E.3 runtime-proved:
- `C_SuperTrack.GetSuperTrackedQuestID` works on Forever;
- `SUPER_TRACKING_CHANGED` fires;
- tested super-tracked quest IDs `436` and `237` produced no usable
  `C_QuestLog.GetNextWaypoint` result.

Therefore source availability does not authorize a quest compass marker.

## Ownership classification

### Logres may observe after runtime proof

- quest identity/title;
- objective state;
- quest interaction text;
- completion/turn-in readiness;
- XP/max/rested XP;
- quest destination when available.

### Blizzard remains owner of controls

- accept/decline;
- continue/complete;
- reward selection;
- gossip navigation;
- quest-log selection/watch controls;
- objective-tracker interaction.

### Stock surfaces remain visible

- quest/gossip interaction UI;
- quest log;
- objective tracker;
- XP presentation;
- minimap.

No F.1 source finding authorizes suppression.

## First production candidate

Select:
**contextual XP pulse**.

Reason:
- passive information only;
- no quest-control replacement required;
- directly aligned with Phase F product intent;
- can be implemented without suppressing the stock XP surface;
- runtime proof can be narrow.

This choice remains gated by F.2 runtime evidence.

## F.2

F.2 uses one temporary passive developer-panel probe.

It captures:
- NPC quest interaction state;
- selected/super-tracked quest ID;
- objectives;
- quest destination output and map-space bearing when available;
- current/max/rested XP;
- Forever XP preset;
- quest/tracking/XP event registration and counts.

The probe performs no quest/navigation mutation.
