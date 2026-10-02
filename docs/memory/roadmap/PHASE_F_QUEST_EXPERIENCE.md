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

## F.3 — Contextual XP pulse

**ACTIVE — RUNTIME + INTEGRATION PASS; VISUAL ACCEPTANCE PENDING.**

P0080 production behavior:
- event-driven safe XP baseline;
- positive same-range XP delta;
- brief `+N XP · progress%` pulse;
- automatic hide;
- Immersion OFF suppression;
- no conventional permanent XP bar;
- no stock XP/quest UI suppression.

P0080 runtime:
- real delta `124`;
- progress `89.1%`;
- pulse count `1`;
- XP Check PASS.

P0080 Run All reproduced the historical TargetFrame restoration failure.

P0081 diagnostic-only follow-up did not reproduce it:
- five Run All PASS;
- one standalone Restoration Check PASS.

The TargetFrame issue remains tracked as intermittent/unreproduced and does not
currently block F.3.

Remaining F.3 item:
**user visual acceptance**.

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
