# Phase F — Quest Experience

Status: ACTIVE — F.2

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

## F.1 — Source / capability review

**COMPLETE.**

Canonical:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

Resolved:
- passive quest/XP observation is separate from interaction/control;
- Blizzard keeps accept/decline/continue/complete/reward/gossip/watch controls;
- no stock quest/objective/XP suppression is authorized;
- source availability does not equal runtime proof;
- first production candidate is a contextual XP pulse;
- quest compass integration requires a runtime-proven destination.

## F.2 — Quest / XP runtime capability probe

**ACTIVE — P0078 PREPARED.**

Temporary passive probe:
`tools/probes/LogresQuestAudit`

Developer-panel action:
**Quest Probe**

It tests:
- quest-giver read state;
- selected/super-tracked quest state;
- objectives;
- next waypoint / player-map waypoint;
- map-space quest bearing;
- current/max/rested XP;
- Forever experience preset;
- relevant quest/tracking/XP events.

No stock UI is suppressed.

## F.3+

Implementation opens only from F.2 evidence.

First production candidate:
**contextual XP pulse**.

A quest compass marker extension may move ahead when F.2 proves a usable
destination path; it is not authorized from API presence alone.

NPC quest presentation and objective/helper replacement remain separately
capability-gated.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and restoration
contract.
