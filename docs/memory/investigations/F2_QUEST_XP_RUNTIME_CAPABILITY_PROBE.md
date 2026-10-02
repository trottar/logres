# F.2 — Quest / XP Runtime Capability Probe

Status: ACTIVE — P0078 PROBE PREPARED
Opened: 2026-10-02

Canonical contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Probe:
`../../../tools/probes/LogresQuestAudit`

## Questions

On the tested Forever client:

1. Are quest-giver read APIs usable/non-secret in their expected event windows?
2. Are selected/super-tracked quest IDs usable?
3. Does `C_QuestLog.GetQuestObjectives` return usable objective state?
4. Can any real active/super-tracked quest produce a usable
   `GetNextWaypoint` / `GetNextWaypointForMap` destination?
5. Are XP/max/rested XP values usable without secret-value violations?
6. Which quest/tracking/XP events register and fire during ordinary play?

## Probe policy

Passive only.

No:
- quest acceptance/completion/reward action;
- watch/super-track mutation;
- waypoint mutation;
- stock suppression;
- chat.

The Logres developer panel is the canonical workflow.

Panel output is persisted through the existing diagnostics SavedVariables and
export helper.

## Exit

F.2 closes with runtime evidence sufficient to:
- authorize or reject the contextual XP production slice;
- authorize or reject objective-state presentation inputs;
- authorize or defer quest compass destination integration;
- identify any remaining environmental deferrals.

Negative results remain project knowledge.
