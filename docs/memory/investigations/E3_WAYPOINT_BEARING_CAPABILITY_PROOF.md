# E.3 — Waypoint-Bearing Capability / Proof

Status: ACTIVE — P0070 PANEL INTEGRATION PREPARED
Opened: 2026-10-01

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

Source/probe evidence:
`../evidence/E3_P0069_WAYPOINT_SOURCE_PROBE_DESIGN_2026-10-01.md`

## Question

Which waypoint/destination sources, coordinate conversions, update events, and
bearing math are actually reliable on the tested WoW Forever client?

## Known starting point

Already proven:
- open-world player map position can be available;
- open-world player facing can be available;
- tested party-instance position/facing can be unavailable;
- P0067 heading-only compass runtime behavior passed the requested validation.

Source-present but behavior-unproven:
- `C_Map.GetUserWaypoint`;
- `C_QuestLog.GetNextWaypoint`;
- `C_SuperTrack.GetSuperTrackedQuestID`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`.

`USER_WAYPOINT_UPDATED` remains an explicit probe candidate rather than an
assumed Forever dependency.

## P0069 probe

Temporary addon:
`tools/probes/LogresWaypointAudit`

It records:
- player map position and map->world conversion;
- user waypoint point/map/world data;
- super-tracked quest ID/state;
- quest next-waypoint map/x/y and map->world conversion;
- candidate event registration + firing counts;
- raw same-continent world delta;
- two candidate north-axis bearing conventions.

It does not mutate navigation state.

## Runtime matrix

### A — no user waypoint

Open world:
- `/lwpa clear`
- `/lwpa snapshot`

Expected evidence:
- player world position if capability is available;
- user waypoint absent without error;
- event registration matrix.

### B — active user waypoint

Set a user waypoint at a visibly known direction on the map:
- `/lwpa snapshot`

Record:
- point present/secret;
- map ID + XY;
- world continent + XY;
- candidate bearings;
- event counts after set/change/clear.

### C — super-tracked quest

Super-track a quest with a visible destination:
- `/lwpa snapshot`

Record:
- quest ID;
- supertracking state;
- `GetNextWaypoint` map/x/y;
- world conversion;
- candidate bearings;
- SuperTrack event counts.

### D — orientation

Compare the visible waypoint direction with the two recorded world-axis
candidates.

Do not promote a candidate until in-game orientation is unambiguous.

## Failure behavior

- absent destination -> no bearing;
- secret input -> branch stops;
- map/world conversion failure -> no bearing;
- different continent/domain -> no bearing;
- unsupported event -> record registration/firing negative result;
- Blizzard navigation remains available.

## Non-scope

Do not implement:
- quest text/objective presentation;
- waypoint UI marker in production;
- route/path guidance;
- minimap suppression;
- generic polling/reassertion without evidence.

## Exit

E.3 closes only when at least one useful destination source has an
evidence-backed Forever retrieval/update/conversion path and bearing orientation
is runtime proven.

If a source is unsupported or unreliable, record that negative result and keep
Blizzard navigation as fallback.

## Validation surface correction

P0069's initial handoff incorrectly made `/lwpa` the primary workflow.

P0070 corrects this:
- use the existing Logres developer panel;
- click `Waypoint Probe`;
- read/copy the result output from the panel;
- `/lwpa` remains fallback only.

This is the canonical E.3 validation workflow.
