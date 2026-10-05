# Future Navigation — Local POI / Tracking Capability Audit

Status: **OPEN — P0143 RUNTIME PASS; MANUAL-WAYPOINT DISTANCE/DEPTH NEXT; QUEST/AREA-POI DEFERRED**
Opened: 2026-10-03
Canonical direction: `../decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
Source/fallback policy: `../decisions/D-043_NAVIGATION_SOURCE_AND_MINIMAP_FALLBACK_POLICY.md`

## Why this exists

D-037 accepts a future four-role navigation system:
- manual waypoint;
- quest destination;
- local radius POI;
- tracking.

Only heading/manual waypoint are currently production-proven.

P0142 resolves the source layer sufficiently to separate three concepts:
1. tracking **filter definitions/state**;
2. positioned map `AreaPOI` rows;
3. engine-rendered minimap tracking/service blips.

They are not interchangeable capabilities.

## P0142 source result

Canonical evidence:
`../evidence/P0142_NAVIGATION_MINIMAP_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`.

Pinned source:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`).

### Quest destination

Source-positive:
- `C_QuestLog.GetNextWaypoint`;
- `C_QuestLog.GetNextWaypointForMap`;
- `C_QuestLog.GetNextWaypointText`;
- `C_SuperTrack.GetSuperTrackedQuestID`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `C_Navigation.GetNextWaypointForMap`.

Blizzard's quest map provider uses `C_QuestLog.GetNextWaypointForMap` for a
focused/super-tracked ordinary quest. The separate super-track waypoint provider
uses `C_Navigation.GetNextWaypointForMap` for broader current-navigation paths
rather than replacing the ordinary quest path.

Therefore the earlier Phase-E runtime result remains authoritative for its tested
scope: those super-tracked quests produced no usable quest waypoint. P0142 does
not reinterpret absence as success.

P0143 may compare both source families read-only in naturally available states.

### Tracking

`C_Minimap` exposes:
- `GetNumTrackingTypes`;
- `GetTrackingInfo`;
- `GetTrackingFilter`;
- `MINIMAP_UPDATE_TRACKING`.

`MinimapScriptTrackingInfo` contains metadata such as name, texture, active state,
type, subtype, and spell ID.

Blizzard's own tracking menu is checkbox/per-index based and retains independent
selected state. Tracking is therefore **multi-select capable**, disproving the
earlier working assumption that one selected mode necessarily supplies all marker
meaning.

The audited public `C_Minimap` surface does **not** expose an enumerator for the
individual detected blips/entities produced by active tracking, nor coordinates
or bearings for those results.

Consequence:
the D-037 repeated generic tracking-result glyph is source-blocked on the current
public API surface. Do not create a runtime probe that polls or inspects Blizzard
presentation to recover those hidden results.

### Local service / POI

`Enum.MinimapTrackingFilter` includes service-like categories such as banker,
taxi node, innkeeper, mailbox, profession/class trainer, repair, stablemaster,
auctioneer, barber, and others.

Those entries are **filter categories**, not enumerable service instances. Their
presence does not establish individual service positions.

A separate source exists:
`C_AreaPoiInfo.GetAreaPOIForMap` plus `GetAreaPOIInfo`.

`AreaPOIInfo` includes a map position and name, and `AREA_POIS_UPDATED` supplies
invalidation.

This makes bounded current-map `AreaPOI` rows a plausible local-POI input, but it
does not prove that Forever ordinary zones expose the service/place semantics
desired by D-037. P0143 must sample real runtime rows before any product mapping.

### Local radius / comparable distance

Source candidates:
- `C_Minimap.GetViewRadius()` -> yards;
- `C_Map.GetBestMapForUnit("player")`;
- `C_Map.GetPlayerMapPosition`;
- `C_Map.GetMapWorldSize` -> map width/height in yards;
- `C_Map.GetWorldPosFromMapPos` / `GetMapPosFromWorldPos`.

These make a same-map physical-distance path source-plausible. P0143 must still
secret-first prove ordinary values and compatible map/position behavior before
D-038 proximity-first focus or depth scaling can use them.

Do not mix arbitrary normalized-map deltas, `C_Navigation.GetDistance`, quest
distance, and POI distance as if their units/frames are automatically comparable.

### Update / staleness model

Candidate event-driven invalidation is available:
- `PLAYER_MAP_CHANGED`;
- `QUEST_LOG_UPDATE`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `AREA_POIS_UPDATED`;
- `MINIMAP_UPDATE_TRACKING`;
- `PLAYER_ENTERING_WORLD`.

P0143 should discard payloads and re-query owned diagnostic state. No polling is
needed to establish the source capability.

### Minimap completeness

Pinned Blizzard minimap source confirms at least these current responsibilities:
- zone/subzone and PvP-territory context;
- click-to-ping;
- zoom controls / mouse wheel;
- tracking-filter management;
- Blizzard-rendered blips and hover interaction;
- target-related blip refresh;
- world-map access from the minimap header/zone control.

`MINIMAP_PING` is explicitly restricted and carries secret payloads.

These responsibilities are not replaced merely because Logres can draw additional
compass markers. D-030/D-037/D-043 keep the stock minimap available.

## P0143 runtime scope

The next justified probe is read-only and bounded:
- current player map/position/map world size;
- minimap view radius;
- tracking type/state metadata only;
- current supertracking + quest/current-navigation waypoint sources;
- bounded current-map AreaPOI rows;
- same-map comparable-distance arithmetic only from ordinary proven inputs.

No individual tracking-result probe exists because the source audit found no
supported result enumerator.

## Current result

**SOURCE LAYER RESOLVED / PRODUCTION EXPANSION STILL GATED.**

Authorized next:
P0143 read-only runtime capability proof.

Not authorized:
- new production quest/POI/tracking marker roles;
- tracking filter mutation;
- minimap CVar mutation;
- engine/minimap blip inspection to infer hidden tracking results;
- stock minimap suppression;
- polling or broad hooks.

## P0143 implementation checkpoint

P0143 prepares an event-driven, read-only runtime probe on candidate
`0.0.69-dev`.

It tests only P0142/D-043 surviving candidates: tracking selector metadata/state,
minimap view radius, current map/player geometry, bounded current-map AreaPOIs,
current super-tracking/navigation, naturally present ordinary quest waypoints, and
same-map comparable-distance arithmetic when all inputs are ordinary.

The probe does not mutate tracking/supertracking/waypoints/minimap state, inspect
Blizzard pins for hidden blips, poll, add production markers, or suppress stock
minimap presentation.

## P0143 runtime result

P0143 is durable at `b9b2f90b` / `0.0.69-dev` and passes its observed read-only
scope:
- current map/player position and map world size are ordinary;
- minimap view radius is ordinary;
- 23/23 tracking selector rows are ordinary, with four independently active;
- secret skips = 0;
- failures = 0;
- integrated `Run All` passes.

The captured map had zero AreaPOI rows and no active user/quest/current-navigation
destination. Those paths remain environmental DEFERRED. Because no destination was
present, actual same-map destination-distance output was not exercised.

`C_Minimap.GetUiMapID()` yielded no value in the sample; current-map ownership
continues to use the proven `C_Map.GetBestMapForUnit("player")` path.

Next:
P0145 may advance only the already-proven manual user-waypoint role into
same-map comparable-distance / bounded D-038 depth behavior, with fail-open
fallback to the current fixed marker treatment.

Quest/current-navigation, AreaPOI, service, and tracking-result production roles
remain gated/blocked exactly as before.
