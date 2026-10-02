# Phase F — Quest Experience

Status: ACTIVE — F.5

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

Runtime-proven:
- XP source/events;
- passive quest-detail reads;
- `QUEST_DETAIL`;
- `QUEST_ACCEPTED`;
- super-tracked quest identity.

Deferred/unproven:
- populated active-objective rows;
- several progress/completion events;
- quest destination output.

## F.3 — Contextual XP pulse

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.4 — Additive NPC quest detail presentation

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

P0083:
- real quest-detail production path proven.

P0084:
- integrated restoration correction runtime-proven;
- three consecutive Run All PASS;
- user visual PASS.

## F.5 — Objective / progress runtime capability proof

**ACTIVE — EXISTING QUEST PROBE; EVIDENCE PENDING.**

Before adding objective/progress presentation, prove populated objective rows and
their update behavior during normal gameplay.

Use the existing Quest Probe.

Do not:
- invent missing objective state;
- treat empty as complete;
- suppress the stock Objective Tracker;
- mutate quest watch/super-track state;
- require contrived gameplay solely for evidence.

Unobserved transitions remain environmental deferrals.

## Quest navigation

Quest IDs `436` and `237` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and
restoration/fallback contract.
