# Phase F — Quest Experience

Status: ACTIVE — F.3

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

**COMPLETE.**

Runtime-proven:
- current/max/rested XP normal scalar access;
- `PLAYER_XP_UPDATE`;
- `UPDATE_EXHAUSTION`;
- quest-detail passive reads for quest `436`;
- `QUEST_DETAIL`;
- `QUEST_ACCEPTED`;
- super-tracked quest identity.

Deferred/unproven:
- populated active objective rows;
- quest destination output;
- quest compass marker.

The P0078 Restoration Check failure is retained as intermittent/unreproduced
after P0079 targeted Restoration Check + Run All both passed.

No behavioral workaround was added.

## F.3 — Contextual XP pulse

**ACTIVE — P0080 PREPARED.**

P0080 implements the first production Phase F presentation slice.

Contract:
- event-driven only;
- `UnitXP` / `UnitXPMax` safe sample;
- positive same-range delta;
- brief `+N XP · progress%` pulse;
- approximately two-second lifetime;
- rebaseline on level/range changes;
- Immersion OFF presentation suppression with baseline maintenance;
- no conventional XP bar;
- no stock XP/quest UI suppression.

Diagnostics:
- XP Check;
- XP Preview;
- XP Check included in Run All.

Runtime proof is required before F.3 closes.

## F.4+

Choose only from proven capability.

Quest compass marker remains unavailable until a real quest destination is
runtime-proven.

Populated objective-row presentation remains unavailable until tested.

NPC quest presentation remains additive until interaction/control replacement
is deliberately solved.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and restoration
contract.
