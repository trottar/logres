# P0075 — User-Waypoint Compass Marker

Date: 2026-10-02
Result: PREPARED — RUNTIME PROOF PENDING

## Baseline

P0074 verified pushed:
`04d7931764e2b35d68709c4513722637d85f3064`

## Runtime

`0.0.29-dev -> 0.0.30-dev`

## Purpose

Integrate the E.3 runtime-proven manual user-waypoint bearing into the existing
production Compass.

## Changes

- manual user-waypoint marker on the existing compass tape;
- current-player-map bearing only;
- `USER_WAYPOINT_UPDATED` immediate refresh;
- throttled player/destination resampling;
- no stale destination fallback;
- secret-safe map/vector guards;
- extended existing Compass Check;
- updated E.4 static contract;
- synchronized durable memory.

## Non-scope

No:
- quest marker;
- objective text;
- route/path guidance;
- minimap suppression;
- Blizzard navigation mutation.

## Runtime next

Deploy `0.0.30-dev`.

Use the existing developer panel:
- Compass Check;
- Run All.

Perform the E.4 set/move/clear, rotation, movement, and Immersion OFF/ON matrix.

Persist through `/reload`, export with:
`python3 tools/export_panel_diagnostics.py`.
