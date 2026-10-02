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

A quest compass marker requires a runtime-proven real destination and must clear
rather than retaining stale state when that destination is unavailable.

## XP boundary

The first production candidate is a brief contextual XP pulse.

It remains gated by runtime proof that current/max/rested XP inputs are usable
on the tested Forever client.

The stock XP surface is not suppressed by the first slice.

## Current work

F.2 runs a passive developer-panel quest/XP capability probe.

Source presence is not runtime proof.
