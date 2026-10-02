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

## F.6 — Contextual objective progress pulse

**ACTIVE — LIVE SOURCE PASS; PREVIEW REGRESSION; PRODUCTION PULSE UNPROVEN.**

P0089 runtime:
- durable at `1781c038`;
- `0.0.35-dev`;
- corrected lower-center placement;
- live quest 237 objective source refreshed Skullthumper `3/10 -> 4/10`;
- QUEST_LOG_UPDATE `85 -> 86`;
- QUEST_WATCH_UPDATE `6 -> 7`;
- stale-source concern closed PASS;
- no post-change Objective Progress Check was captured, so production pulse
  remains unproven;
- generic synthetic Preview is a confirmed usability regression.

P0090:
- runtime target `0.0.36-dev`;
- Preview shows current live objective rows when safely available;
- maximum two rows;
- explicit synthetic fallback only when live rows are unavailable;
- Preview does not mutate the production baseline;
- production source/event/baseline behavior unchanged.

Do not add polling/retry/reassertion without evidence of an actual production
pulse failure.

## Quest navigation

Quest IDs `436`, `237`, and `1338` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and
restoration/fallback contract.
