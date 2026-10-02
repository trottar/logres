# Phase F — Quest Experience

Status: ACTIVE — F.2 BLOCKED BY RESTORATION DIAGNOSTIC

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

Passive observation is separated from Blizzard-owned quest interaction/control.

## F.2 — Quest / XP runtime capability probe

**ACTIVE — CAPABILITY EVIDENCE CAPTURED; INTEGRATED VALIDATION BLOCKED.**

P0078 runtime-proven:
- current/max/rested XP normal scalar access;
- `PLAYER_XP_UPDATE`;
- `UPDATE_EXHAUSTION`;
- quest-detail passive reads for quest `436`;
- `QUEST_DETAIL`;
- `QUEST_ACCEPTED`;
- super-tracked quest identity.

Therefore the data/event prerequisite for a future contextual XP pulse is
proven.

Not proven:
- populated active objective rows.

Negative:
- quest `436` again produced no usable quest destination;
- quest compass marker remains unsupported.

## Integrated validation blocker

The P0078 Run All produced:
`Restoration Check FAIL — opposite preference state did not settle`.

Cleanup succeeded and the final state reconverged.

P0079 adds diagnostic detail only.

Do not advance to F.3 until the targeted restoration evidence is reviewed.

## F.3+

First production candidate remains:
**contextual XP pulse**.

It is ready from a quest/XP capability perspective but remains blocked by the
unresolved integrated Restoration Check failure.

Quest compass integration remains conditional on a usable runtime-proven
destination.

NPC quest presentation and objective/helper replacement remain separately
capability-gated.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and restoration
contract.
