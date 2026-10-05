# P0143 — Navigation Source Read-Only Runtime Probe

Date: 2026-10-05
Baseline: `82682ece15ad21aa7d5ee2dfaba5e5a3c68c97b6`
Candidate runtime: `0.0.69-dev`
Durable commit: `b9b2f90b37ad9d10b4ce6d55ef932e113172d3b3`
Result: **INSTALLED / PUSHED — RUNTIME PASS WITH ENVIRONMENTAL NAVIGATION/POI DEFERRALS**

## Purpose

Test only the source-plausible navigation inputs accepted by P0142 / D-043 before
any production marker expansion.

## Runtime design

New diagnostic module:
`Logres/Navigation/NavigationSourceProbe.lua`.

The probe is event-driven and re-queries from:
- `MINIMAP_UPDATE_TRACKING`;
- `AREA_POIS_UPDATED`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `QUEST_LOG_UPDATE`;
- `PLAYER_MAP_CHANGED`;
- `PLAYER_ENTERING_WORLD`.

Event payloads are discarded.

Read-only sources:
- `C_Minimap.GetNumTrackingTypes`;
- `C_Minimap.GetTrackingInfo`;
- `C_Minimap.GetTrackingFilter`;
- `C_Minimap.GetViewRadius`;
- `C_Minimap.GetUiMapID`;
- `C_Map.GetBestMapForUnit`;
- `C_Map.GetPlayerMapPosition`;
- `C_Map.GetMapWorldSize`;
- `C_AreaPoiInfo.GetAreaPOIForMap`;
- `C_AreaPoiInfo.GetAreaPOIInfo`;
- `C_SuperTrack` read methods;
- `C_Navigation.GetNextWaypointForMap`;
- `C_QuestLog.GetNextWaypoint`;
- `C_QuestLog.GetNextWaypointForMap`.

Tracking enumeration is bounded to 48 selector rows. AreaPOI enumeration is bounded
to 24 current-map IDs and does not count or iterate the returned table to infer
secret-capable length.

All returned values, structures, vector components, and structure fields are
secret-preflighted before inspection. Same-map distance is computed only from
ordinary numeric player/destination coordinates plus ordinary map world size.

## Explicit non-mutation boundary

P0143 does not:
- call `C_Minimap.SetTracking` or `ClearAllTracking`;
- set/clear user waypoints;
- set/clear supertracking;
- mutate CVars;
- change minimap zoom or send pings;
- enumerate or inspect Blizzard map/minimap pins to recover hidden blips;
- poll or register `OnUpdate`;
- add production navigation markers;
- suppress Blizzard minimap presentation.

## Developer workflow

Phase H adds:
- `Navigation Source Probe`;
- `/logres navigationsourceprobe`.

The contextual probe remains excluded from `Run All`.

## Initial artifact failure preserved

The initial P0143 artifact reached its post-write static-check sequence and passed:
- `tools/check_navigation_source_probe_contract.py`;
- `tools/check_dev_panel_contract.py`.

It then attempted to run nonexistent `tools/check_structure.py`. The authoritative
`82682ece` baseline instead contains `tools/check_addon_structure.py`. Python exited
with status 2, the transactional applier restored all tracked patch-owned files,
removed any partial manifest, and left `P0143_PAYLOAD/` for diagnosis. The user's
post-failure porcelain status showed only the pre-existing diagnostics export and
the untracked payload directory. No tracked P0143 state survived.

Classification: **ARTIFACT VALIDATION FAILURE — ROLLED BACK; NOT A LUA/RUNTIME FAILURE.**

R1 corrects the checker name and adds a pre-write existence check for every
baseline checker invoked by the applier. Probe scope, source policy, runtime version,
and in-client validation requirements are unchanged.

## Validation gate

A diagnostic PASS requires:
- initialized/enabled probe;
- all required event registrations;
- required source API availability;
- secret checker availability;
- zero secret skips;
- zero call/shape failures.

Environmental absence of a current navigation waypoint, ordinary quest waypoint,
or AreaPOI is not a diagnostic failure.

After the probe, integrated `Run All` must remain PASS.

## Runtime result

P0143 is durable at `b9b2f90b37ad9d10b4ce6d55ef932e113172d3b3`.

The recorded `0.0.69-dev` manual probe passes with zero secret skips and zero
failures. Current map/player geometry, map world size, minimap view radius, and
all 23 tested tracking selector rows were ordinary. Four selectors were
independently active.

The tested map had no AreaPOI rows, no current/super-tracked navigation
destination, and no user waypoint. Those branches remain environmental DEFERRED;
the destination-distance branch was not exercised. Integrated `Run All` passed.

Canonical evidence:
`../evidence/P0144_P0143_NAVIGATION_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`.

No P0143 result by itself authorizes repeated tracking-result glyphs or minimap
suppression.
