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

## F.3 — Contextual XP pulse

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.4 — Additive NPC quest detail presentation

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.5 — Objective / progress runtime capability proof

**ACTIVE — DATA SHAPES PASS; SAME-QUEST TRANSITION PENDING.**

Runtime-proven objective states:
- no active quest -> nil;
- completed quest `436` -> empty objective list;
- quest `237` -> two populated incomplete `0/10` rows;
- quest `1338` -> populated completed `1/1` row.

Quest state is also readable:
- `237`: complete=false, ready=false;
- `1338`: complete=true, ready=true.

The active quest identity switch none -> `237` -> `1338` returned fresh data for
each identity, but a same-quest objective transition remains unproven.

Use the existing Quest Probe after a natural objective count or finished-state
change.

Do not:
- invent missing objective state;
- treat empty as complete;
- suppress the stock Objective Tracker;
- mutate quest watch/super-track state;
- require contrived gameplay solely for evidence.

Unobserved progress/completion/turn-in/watch events remain environmental
deferrals.

## Quest navigation

Quest IDs `436`, `237`, and `1338` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and
restoration/fallback contract.
