# E.3 P0071 Runtime Evidence — 2026-10-01

Status: PARTIAL RUNTIME PROOF
Date: 2026-10-01
P0071 commit: `7976d34e`

## Captured runtime

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Open-world player position:
- map ID `1432`;
- map position usable/non-secret;
- world conversion succeeds;
- continent ID `0`.

## User waypoint

No waypoint:
- `C_Map.GetUserWaypoint()` call succeeds;
- waypoint is absent rather than errored;
- no bearing is fabricated.

Waypoint sample 1:
- present, non-secret;
- map ID `1432`;
- world conversion succeeds;
- same continent `0`;
- world delta approximately `+295.03, -38.13`;
- candidate bearings:
  - `+Y north`: `97.4`;
  - `-Y north`: `82.6`.

Waypoint sample 2:
- present, non-secret;
- map ID `1432`;
- world conversion succeeds;
- same continent `0`;
- world delta approximately `+184.18, -785.29`;
- candidate bearings:
  - `+Y north`: `166.8`;
  - `-Y north`: `13.2`.

After clear:
- waypoint absent again;
- no stale bearing retained.

## Events

Observed:
- `USER_WAYPOINT_UPDATED` registers and fires;
- count advanced across set/move/clear;
- `SUPER_TRACKING_CHANGED` registers and fires;
- count also advanced during waypoint/super-track activity.

Not observed:
- `SUPER_TRACKING_PATH_UPDATED` remained at zero in this run.

## Quest super-tracking

Two tested super-tracked quests:
- quest ID `436`;
- quest ID `237`.

For both:
- `IsSuperTrackingQuest` was true;
- `C_QuestLog.GetNextWaypoint` produced no usable waypoint in the captured state.

This is negative runtime evidence for those tested quest states, not proof that
all Forever quests lack waypoint output.

## Remaining E.3 proof

User-waypoint retrieval, conversion, absence handling, and update-event behavior
are runtime-proven.

Bearing-axis selection is not closed from the saved diagnostic alone because the
human-intended cardinal direction of the two manually placed waypoints was not
persisted.

Do not silently promote either candidate convention without that orientation
evidence.

## P0071 version defect

The same diagnostic reported `Logres 0.0.28-dev` while the P0071 TOC was
`0.0.29-dev`.

Remote inspection confirmed:
- `Logres.toc`: `0.0.29-dev`;
- `Bootstrap.lua`: `0.0.28-dev`.

P0072 corrects this mismatch and strengthens the structure checker.
