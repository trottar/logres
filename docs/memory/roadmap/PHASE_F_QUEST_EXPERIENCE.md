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

**ACTIVE — RUNTIME/INTEGRATION PASS; VISUAL FAIL; P0089 REPAIR 2 RETEST PENDING.**

P0088:
- implemented passive objective progress;
- Objective Progress Check PASS;
- Preview Immersion policy PASS;
- two consecutive Run All PASS;
- visual FAIL because pulse overlapped action cluster;
- real production pulse not captured in that run.

P0089 Repair 2:
- presentation-only correction;
- frame `520x32`;
- anchor above addon-owned target frame with 6px gap;
- center fallback `y=-5`;
- explicit synthetic Preview;
- passive source/event/baseline contract unchanged.

Possible Seer-count freshness problem:
**OPEN / UNPROVEN**.

Use Quest Probe for live before/after count evidence.
Do not add polling/retry/reassertion without that evidence.

Runtime target:
`0.0.35-dev`.

## Quest navigation

Quest IDs `436`, `237`, and `1338` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and
restoration/fallback contract.
