# E.3 — Waypoint-Bearing Capability / Proof

Status: ACTIVE
Opened: 2026-10-01

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

## Question

Which waypoint/destination sources, coordinate conversions, update events, and
bearing math are actually reliable on the tested WoW Forever client?

## Known starting point

Already proven:
- open-world player map position can be available;
- open-world player facing can be available;
- tested party-instance position/facing can be unavailable;
- P0067 heading-only compass runtime behavior passed the requested validation.

Source-present but not yet behavior-proven:
- user waypoint APIs;
- `C_QuestLog.GetNextWaypoint`;
- `C_SuperTrack.GetSuperTrackedQuestID`;
- `SUPER_TRACKING_CHANGED`.

Do not require `USER_WAYPOINT_UPDATED` unless Forever support is separately
confirmed.

## Proof targets

1. User waypoint retrieval
   - determine exact API/result shape on Forever;
   - test no-waypoint and active-waypoint states.

2. Super-tracked quest selection
   - prove current quest selection semantics;
   - distinguish "no tracked destination" from restricted/unavailable data.

3. Quest waypoint output
   - prove `C_QuestLog.GetNextWaypoint` result shape and coordinate domain;
   - do not infer semantics from API presence.

4. Update/invalidation
   - identify reliable Forever event(s);
   - avoid broad polling if an evidence-backed event path exists.

5. Player coordinate source
   - prove the required map ID + player position path for bearing work.

6. Coordinate compatibility
   - determine whether player and destination points share a valid map/world
     domain;
   - prove any required `C_Map` world-position conversion.

7. Bearing math
   - determine X/Y axis orientation;
   - prove clockwise bearing convention in game;
   - verify marker direction relative to P0067 heading.

8. Failure behavior
   - unavailable/restricted/incompatible inputs produce no marker;
   - never retain/fabricate the last destination bearing;
   - Blizzard navigation remains available.

## Non-scope

Do not implement:
- quest text/objective presentation;
- route/path guidance;
- minimap suppression;
- generic polling/reassertion without evidence.

## Exit

E.3 closes only when at least one useful destination source has an evidence-backed
Forever retrieval/update/conversion path and bearing orientation is runtime
proven.

If a source is unsupported or unreliable, record that negative result and keep
Blizzard navigation as fallback.
