# E.3 — Waypoint-Bearing Capability / Proof

Status: ACTIVE — ORIENTATION PROOF REMAINS
Opened: 2026-10-01

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

Latest runtime evidence:
`../evidence/E3_P0071_RUNTIME_EVIDENCE_2026-10-01.md`

## Proven

- open-world player map/world position;
- user waypoint present/absent semantics;
- user waypoint world conversion;
- same-continent compatibility for captured samples;
- clean clear/no-stale-bearing behavior;
- `USER_WAYPOINT_UPDATED` firing;
- `SUPER_TRACKING_CHANGED` firing.

## Negative / incomplete evidence

- `SUPER_TRACKING_PATH_UPDATED` registered but did not fire;
- tested super-tracked quest IDs 436 and 237 returned no usable next waypoint;
- this does not generalize to all quests.

## Bearing samples

Sample 1:
- delta `+295.03, -38.13`;
- +Y-north `97.4`;
- -Y-north `82.6`.

Sample 2:
- delta `+184.18, -785.29`;
- +Y-north `166.8`;
- -Y-north `13.2`.

## Remaining proof

Persisted diagnostics do not encode which cardinal direction the user intended
for each manually placed waypoint.

Therefore the axis convention remains open.

Do not repeat already-proven retrieval/event tests.

## Exit

E.3 closes after the bearing-axis convention is tied to an unambiguous in-game
cardinal reference.

Then production may implement only the proven user-waypoint bearing path, while
quest waypoint support remains capability-gated/fail-open until separately
proven.
