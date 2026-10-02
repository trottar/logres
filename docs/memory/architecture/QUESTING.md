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

A quest compass marker requires a runtime-proven real destination and must clear
rather than retaining stale state when that destination is unavailable.

## XP boundary

F.2 runtime-proved normal current/max/rested XP inputs and
`PLAYER_XP_UPDATE`.

F.3 implements a brief contextual XP pulse:
- positive same-range XP delta only;
- `+N XP · progress%`;
- approximately two seconds;
- no permanent XP bar;
- no stock XP suppression.

Level/range changes rebaseline rather than fabricating a gain.

Immersion OFF suppresses presentation while the safe baseline continues to
track XP events.

## Current work

F.3 runtime proof of the contextual XP pulse.

Populated objective rows and quest destination presentation remain deferred.
