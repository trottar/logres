# P0142 — Navigation / Minimap Source-Capability Audit

Date: 2026-10-05
Result: **SOURCE-CAPABILITY LAYER RESOLVED; RUNTIME PROOF REQUIRED FOR SURVIVING CANDIDATES**
Forever client: `1.60.1.70205`
Source pin: `Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`

## Question

Which D-037 navigation/minimap roles have supported current-Forever source paths,
which are source-blocked or indeterminate, and what is the smallest read-only
runtime proof justified next?

This audit does not mutate runtime state and does not authorize production
navigation expansion or minimap suppression.

## Primary source inspected

Pinned generated API/source files:
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/QuestLogDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/SuperTrackManagerDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/InGameNavigationDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/MinimapDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/MinimapConstantsDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/MapDocumentation.lua`
- `Interface/AddOns/Blizzard_APIDocumentationGenerated/AreaPoiInfoDocumentation.lua`
- `Interface/AddOns/Blizzard_SharedMapDataProviders/QuestDataProvider.lua`
- `Interface/AddOns/Blizzard_SharedMapDataProviders/SuperTrackWaypointDataProvider.lua`
- `Interface/AddOns/Blizzard_Minimap/Mainline/Minimap.lua`

Existing Logres runtime evidence consulted:
- `E3_P0071_RUNTIME_EVIDENCE_2026-10-01.md`
- `F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`

## 1. Quest destination

Generated API source exposes:
- `C_QuestLog.GetNextWaypoint(questID)` -> mapID/x/y or nothing;
- `C_QuestLog.GetNextWaypointForMap(questID, uiMapID)` -> x/y or nothing;
- `C_QuestLog.GetNextWaypointText(questID)`;
- `C_QuestLog.GetDistanceSqToQuest(questID)` -> distanceSq/onContinent or nothing;
- `C_SuperTrack.GetSuperTrackedQuestID()`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `C_Navigation.GetNextWaypointForMap(uiMapID)` -> x/y/description or nothing;
- `C_Navigation.GetDistance()`.

Blizzard source distinguishes the paths:
- `QuestDataProviderMixin` uses
  `C_QuestLog.GetNextWaypointForMap(waypointQuestID, mapID)` for the focused or
  super-tracked quest;
- `SuperTrackWaypointDataProviderMixin` uses
  `C_Navigation.GetNextWaypointForMap(mapID)` when its broader super-tracking
  waypoint path applies.

Therefore `C_Navigation` is a real additional current-navigation source, but it is
not evidence that ordinary quest `C_QuestLog` waypoints should have existed for
the earlier tested quests.

Preserved runtime evidence:
- P0071: two tested super-tracked quest states had no usable
  `C_QuestLog.GetNextWaypoint`;
- P0078: quest 436 had no usable `GetNextWaypoint` or
  `GetNextWaypointForMap`.

Classification:
**SOURCE AVAILABLE / PRIOR TESTED QUEST STATES NEGATIVE / BROADER NAVIGATION PATH RUNTIME-UNPROVEN.**

## 2. Tracking filter selection

Generated `C_Minimap` API exposes:
- `GetNumTrackingTypes`;
- `GetTrackingInfo(index)`;
- `GetTrackingFilter(index)`;
- `MINIMAP_UPDATE_TRACKING`.

`MinimapScriptTrackingInfo` exposes:
- `name`;
- `texture`;
- `active`;
- `type`;
- `subType`;
- optional `spellID`.

Blizzard `Minimap.lua` constructs checkbox entries per tracking index and maintains
a separate selected state for each index. `ClearAllTracking` clears the collection;
individual indexes can then be selected independently.

Result:
**tracking selection is multi-select capable.**

This invalidates the prior unproven assumption that one active tracking mode would
always supply unambiguous semantics for one generic repeated marker family.

## 3. Individual tracking results

The audited public `C_Minimap` API has tracking-filter metadata/state, but no
function that enumerates each detected tracked entity/blip and no return structure
containing per-result map/world coordinates or bearings.

The Blizzard minimap presents those blips internally; public source does not expose
a supported result list for addon-owned presentation.

Classification:
**SOURCE-BLOCKED on the audited public API surface.**

Do not attempt to recover these results by:
- enumerating Blizzard presentation children;
- reading protected/secret presentation state;
- polling the minimap;
- hooking broad internal rendering paths.

A new primary source/API would be required before reopening repeated tracking-result
glyph implementation.

## 4. Local services versus map AreaPOIs

`Enum.MinimapTrackingFilter` includes 26 filter values including:
Auctioneer, Banker, Battlemaster, TaxiNode, VenderFood, Innkeeper, Mailbox,
TrainerProfession, VendorReagent, Repair, Stablemaster, Transmogrifier, POI,
Target, Focus, QuestPOIs, Digsites, Barber, ItemUpgrade, VendorPoison,
AccountCompletedQuests, AccountBanker, TrainerClass, and VendorAmmo.

These values identify filter categories. `GetTrackingInfo` identifies a filter
option and whether it is active. Neither API enumerates the individual banker,
mailbox, repair NPC, trainer, etc. currently drawn on the minimap.

Thus:
**minimap service filters do not provide service-instance coordinates.**

A distinct API family does expose positioned POIs:
- `C_AreaPoiInfo.GetAreaPOIForMap(uiMapID)` -> areaPoiIDs;
- `C_AreaPoiInfo.GetAreaPOIInfo(uiMapID, areaPoiID)` -> `AreaPOIInfo`;
- `AreaPOIInfo.position` and `.name`;
- `AREA_POIS_UPDATED`.

This is source-plausible for a local/map POI role but is not the same source as
town/service tracking blips. Its actual Forever ordinary-zone population and
semantic usefulness are runtime-unproven.

Classification:
- service/townsfolk instances: **SOURCE-BLOCKED**;
- map AreaPOIs: **SOURCE AVAILABLE / RUNTIME-UNPROVEN**.

## 5. Local radius and comparable distance

`C_Minimap.GetViewRadius()` returns `yards`.

`C_Map` exposes:
- `GetBestMapForUnit("player")`;
- `GetPlayerMapPosition(uiMapID, "player")`;
- `GetMapWorldSize(uiMapID)` with documentation that width/height are in yards;
- `GetWorldPosFromMapPos`;
- `GetMapPosFromWorldPos`.

This provides a plausible same-map geometry path:
1. acquire the current player map;
2. acquire ordinary player/POI or waypoint normalized positions;
3. use the map's yard dimensions or common world-position conversion;
4. derive addon-owned physical distance/bearing only after every input is proven
   ordinary and compatible.

P0123 already runtime-proves the existing secret-safe player-map/manual-waypoint
map-space bearing path. P0142 does not infer that the newly proposed world-size /
AreaPOI path is automatically safe.

Classification:
**SOURCE AVAILABLE / SECRET-FIRST RUNTIME PROOF REQUIRED.**

`C_QuestLog.GetDistanceSqToQuest` and `C_Navigation.GetDistance` are not assumed
cross-source-comparable merely because both are numeric.

## 6. Event / stale-data model

Source-available invalidation includes:
- `PLAYER_MAP_CHANGED`;
- `QUEST_LOG_UPDATE`;
- `SUPER_TRACKING_CHANGED`;
- `SUPER_TRACKING_PATH_UPDATED`;
- `AREA_POIS_UPDATED`;
- `MINIMAP_UPDATE_TRACKING`;
- `PLAYER_ENTERING_WORLD`.

This is sufficient to design a read-only event-driven probe without production
polling.

P0143 should discard event payloads and re-query current state.

## 7. Secret / restricted boundary

Multiple audited APIs mark arguments as `AllowedWhenUntainted`. P0143 must retain
the project's stronger secret-first discipline for all returned scalars,
vectors/tables, and selected payload fields before nil/type/value inspection.

`MINIMAP_PING` is explicitly:
- restricted;
- secret-payload-bearing.

P0142 therefore does not authorize consuming ping payload coordinates or replacing
ping interaction.

## 8. Stock minimap responsibilities

Pinned Blizzard minimap source confirms, at minimum:
- zone/subzone text;
- PvP/territory coloring and tooltip context;
- click-to-ping;
- zoom buttons and mouse-wheel zoom;
- tracking-filter configuration;
- Blizzard-rendered tracking/service/quest/target blips and hover behavior;
- target-change blip refresh;
- world-map access from the minimap zone/header control.

Additional expansion/context indicators also live around the minimap cluster.

The D-037 replacement gate is therefore not satisfied by compass bearings alone.

Classification:
**STOCK MINIMAP RETAINED.**

## 9. Exact P0143 probe justified

P0143 may implement one bounded diagnostic-only module that:
- reads current player map, player map position, and map world size;
- reads minimap view radius;
- enumerates tracking types/state only;
- reads current supertracking state;
- reads quest waypoint functions only when a current super-tracked quest exists;
- reads `C_Navigation.GetNextWaypointForMap` for the current map;
- bounded-scans current-map AreaPOI IDs and ordinary name/position fields;
- derives same-map distance only from ordinary proven inputs;
- invalidates from the event list above;
- discards event payloads;
- retains sanitized addon-owned diagnostics only;
- does not mutate tracking, minimap settings, CVars, quest tracking, or presentation.

P0143 must **not** implement an individual tracking-result probe because no
supported source enumerator was found.

## Result

P0142 resolves the source layer and accepts D-043.

Surviving runtime candidates:
- current-navigation waypoint;
- ordinary quest waypoint when naturally available;
- current-map AreaPOI;
- minimap view radius;
- same-map comparable distance.

Source-blocked:
- individual tracking-result positions;
- individual service/townsfolk minimap-blip positions.

Production remains unchanged.
