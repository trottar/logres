# Phase F — Quest Experience

Status: ACTIVE — F.4

## Product Objective

Create an immersive quest experience that presents only the quest information
the player actually needs, while preserving Blizzard interaction/control
surfaces until Logres has proven safe replacements.

Phase F must not turn the HUD back into a conventional quest tracker by default.

## Standing Boundaries

Phase F owns:
- NPC quest presentation policy;
- restrained objective updates;
- aesthetic quest-helper data/presentation;
- contextual XP presentation;
- quest destination state supplied to navigation when runtime-proven.

The existing Compass remains the navigation renderer.

The Blizzard minimap remains stock by D-030.

## F.1

**COMPLETE — D-031.**

## F.2

**COMPLETE.**

Runtime-proven:
- current/max/rested XP;
- XP events;
- quest-detail passive reads;
- `QUEST_DETAIL`;
- `QUEST_ACCEPTED`;
- super-tracked quest identity.

Deferred:
- populated active objective rows;
- quest destination output;
- quest compass marker.

## F.3 — Contextual XP pulse

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

Production:
- event-driven safe XP delta;
- brief `+N XP · progress%`;
- auto-hide;
- Immersion OFF suppression;
- no permanent XP bar;
- no stock XP/quest suppression.

User visual validation:
**PASS.**

## F.4 — Additive NPC quest detail presentation

**ACTIVE — P0083 PREPARED.**

P0083 uses the already-proven `QUEST_DETAIL` read path to show:
- quest title;
- restrained body excerpt;
- optional objective line.

Presentation is:
- temporary;
- non-interactive;
- Immersion-gated;
- additive to Blizzard's stock quest frame.

Cleanup:
- accepted;
- finished;
- world entry;
- timeout;
- Immersion OFF.

Diagnostics:
- Quest Dialogue Check;
- Quest Dialogue Preview;
- Run All integration.

No accept/decline/complete/reward/watch/super-track behavior is owned by Logres.

## F.5+

Choose only from runtime-proven capability.

Populated objective rows remain unavailable for production presentation until
proven.

Quest compass markers remain unavailable until a real destination is proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and restoration
contract.
