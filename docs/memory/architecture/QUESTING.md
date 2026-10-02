# Questing Architecture

## Intent

Quest presentation should be world-focused and visually consistent with Logres:
- restrained NPC quest dialogue;
- brief objective updates;
- minimal persistent tracker;
- compass integration where technically possible;
- contextual XP display rather than a permanent conventional bar.

## D-031 capability boundary

Phase F separates:
- passive quest/XP information;
- Blizzard-owned quest interaction/control.

Blizzard retains:
- accept/decline;
- continue/complete;
- reward choice;
- gossip navigation;
- quest-log/watch controls;
- stock objective-tracker interaction.

No stock quest/objective/XP suppression occurs until the corresponding Logres
replacement and restoration/fallback behavior are runtime-proven.

## Destination / compass boundary

Phase F owns quest state and destination discovery.

The existing Compass remains the navigation renderer.

Quest destination APIs may return nothing.

Tested quest IDs `436` and `237` have not produced a usable destination.

A quest compass marker requires a runtime-proven real destination.

## XP boundary

F.3 is complete.

Production contextual XP:
- positive same-range XP delta only;
- `+N XP · progress%`;
- approximately two seconds;
- no permanent XP bar;
- no stock XP suppression.

Runtime, integration, and visual proof are accepted.

## NPC quest detail boundary

F.2 runtime-proved the `QUEST_DETAIL` passive read path.

F.4 uses that path additively.

Production presentation:
- title;
- restrained body excerpt;
- optional objective line;
- temporary world-oriented text;
- no mouse interaction.

Blizzard retains the complete quest interaction frame and every control.

Cleanup is fail-open:
- accepted/finished/world events;
- timeout;
- Immersion OFF.

The Logres presentation does not carry authoritative interaction state.

## Current work

F.4 runtime + visual proof of additive NPC quest detail presentation.

Populated objective rows and quest destination presentation remain deferred.
