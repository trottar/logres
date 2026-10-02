# Phase F — Quest Experience

Status: ACTIVE — F.6

## Product Objective

Create an immersive quest experience that presents only the quest information
the player actually needs while preserving Blizzard control surfaces until
safe replacements exist.

## Standing Boundaries

Phase F owns:
- passive quest/XP presentation policy;
- restrained objective updates when runtime-proven;
- contextual XP;
- quest destination state only when runtime-proven.

Blizzard retains:
- quest accept/decline/continue/complete/reward controls;
- gossip navigation;
- quest watch/super-track mutation;
- stock quest-log interaction;
- stock Objective Tracker interaction until a safe replacement exists.

## F.1

**COMPLETE — D-031.**

## F.2

**COMPLETE.**

## F.3 — Contextual XP pulse

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.4 — Additive NPC quest detail presentation

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.5 — Objective / progress runtime capability proof

**COMPLETE — RUNTIME PASS.**

Proven:
- nil/no-active objective state;
- empty objective list;
- populated incomplete rows;
- populated completed row;
- same-quest objective count transition (`0/10 -> 1/10`);
- fresh repeated same-quest recapture;
- `QUEST_WATCH_UPDATE` observed.

Environmental deferrals:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`.

## F.6 — Contextual objective progress pulse

**ACTIVE — IMPLEMENTED; RUNTIME + VISUAL PROOF PENDING.**

P0088 implementation:
- module `QuestObjectiveProgress`;
- safe super-tracked identity with selected-quest fallback;
- passive objective recapture;
- baseline-first/no-false-pulse policy;
- same-quest count/finished comparison;
- `QUEST_LOG_UPDATE` and `QUEST_WATCH_UPDATE` refresh;
- super-track/world rebaseline-only behavior;
- 3-second, maximum-two-row text pulse;
- Immersion OFF suppression while baseline remains current;
- Objective Progress Check/Preview;
- Run All integration.

P0088 does not:
- suppress the stock Objective Tracker;
- mutate watch/super-track state;
- persist real objective content;
- require unobserved progress/complete/turn-in events.

Runtime target:
`0.0.34-dev`.

## Quest navigation

Quest IDs `436`, `237`, and `1338` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and
restoration/fallback contract.
