# LogresQuestAudit

Temporary passive Phase F quest/XP capability probe.

## Canonical workflow

Use the **Logres developer panel** and click **Quest Probe**.

The panel output is automatically persisted by Logres into
`LogresDiagnosticsDB`, so the normal diagnostics exporter captures the result.

`/lqa` exists only as fallback/debug access.

## Captured capabilities

The probe reads, when available:

- current displayed quest/NPC context:
  - `GetQuestID`;
  - `GetTitleText`;
  - `GetQuestText`;
  - `GetObjectiveText`;
  - `GetProgressText`;
  - `GetRewardText`;
- selected and super-tracked quest IDs;
- `C_QuestLog.GetQuestObjectives`;
- completion/failure/turn-in state;
- `C_QuestLog.GetNextWaypoint`;
- `C_QuestLog.GetNextWaypointForMap`;
- current player-map quest bearing;
- player XP / max XP / rested XP;
- Forever experience preset;
- relevant quest, tracking, and XP event registration/counts.

## Safety

This probe is passive.

It does not:
- accept or decline quests;
- complete quests;
- choose quest rewards;
- select/watch/unwatch quests;
- change super-tracking;
- set/clear map waypoints;
- suppress the objective tracker, quest UI, XP UI, or minimap;
- send chat.

Secret-capable values are checked before type inspection, formatting, counting,
comparison, or arithmetic.

Source presence is not treated as runtime proof.
