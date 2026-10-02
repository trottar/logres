# Phase F — Quest Experience

Status: ACTIVE — F.1

## Product Objective

Create an immersive quest experience that presents only the quest information
the player actually needs, while preserving Blizzard interaction/control
surfaces until Logres has proven safe replacements.

Phase F must not turn the HUD back into a conventional quest tracker by default.

## Standing Boundaries

Phase F owns:
- NPC quest presentation;
- restrained objective updates;
- aesthetic quest-helper presentation;
- contextual XP presentation;
- stock quest/objective/XP suppression only after replacement proof.

Phase E retains ownership of:
- heading compass;
- proven manual user-waypoint direction.

The Blizzard minimap remains stock by D-030.

## F.1 — Quest-experience source / capability review

**ACTIVE.**

Before implementation, review the tested Forever client for:

### NPC interaction
- quest offer;
- quest progress;
- quest reward;
- gossip/quest interaction boundaries;
- secure/protected behavior.

### Quest state
- quest log sources;
- selected/super-tracked quest state;
- objective/task updates;
- completion/failure state;
- secret-capable values.

### World/helper presentation
- objective direction sources where independently proven;
- world-map ownership;
- POI/helper boundaries;
- relationship to the stock objective tracker.

### XP
- current/max XP;
- rested XP where available;
- level-cap behavior;
- event/update sources.

### Stock ownership
Inventory which stock quest/objective/XP surfaces provide:
- information only;
- required interaction/control;
- fallback presentation.

No suppression is authorized during F.1.

## F.1 Exit

Produce an explicit capability contract that:
- chooses the first safe production presentation slice;
- separates observed data from presentation policy;
- identifies protected/secret risks;
- defines fail-open behavior;
- lists stock surfaces that remain Blizzard-owned;
- states the runtime proof needed before suppression.

## F.2+

Implementation slices are opened only after F.1 resolves their capability and
ownership boundaries.

Likely domains:
- NPC quest presentation;
- restrained objective updates/helper;
- contextual XP;
- selective stock suppression where replacement is proven.

Do not pre-authorize those implementations from roadmap intent alone.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and restoration
contract.
