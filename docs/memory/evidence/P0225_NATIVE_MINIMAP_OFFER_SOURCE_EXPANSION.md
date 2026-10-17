# P0225 — Native-first map quest offers and hubs; source vs engine blips

Date: 2026-10-16. GitHub main P0224 `d4a39d1d88b9e1a3111b801eb2f19c30f87b1709`. The user explicitly prefers Blizzard live sources and consistent addon infrastructure to QuestieDB data maintenance. No QuestieDB installation or optional dependency is added.

## Exact Blizzard source finding
Pinned Forever UI source `Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f`:
- `Blizzard_SharedMapDataProviders/QuestOfferDataProvider.lua` obtains quest offers by `C_QuestLine.GetAvailableQuestLines(mapID)`, `C_QuestLine.GetForceVisibleQuests(mapID)` with `GetQuestLineInfo`, and task entries through `GetTasksOnMapCached` (which calls `C_TaskQuest.GetQuestsOnMap`). It separately queries `C_AreaPoiInfo.GetQuestHubsForMap` + `GetAreaPOIInfo`.
- `SharedMapPoiTemplates.lua` caches `C_AreaPoiInfo.GetAreaPOIForMap` and `C_QuestLog.GetQuestsOnMap`; cache wrappers do NOT provide new positions beyond these APIs.
- `MinimapDocumentation.lua` exposes tracking selections and POI *texture coordinates*, not a public accessor for individual rendered service/resource blip positions. `MinimapFrameAPIDocumentation.lua` has `UpdateBlips`, not an enumerator. This is a positive API-boundary finding, not proof of complete UI replication.
- QuestLineInfo has ordinary x/y and isQuestStart; C_TaskQuest.GetQuestsOnMap yields QuestPOIMapInfo; quest-hub AreaPOIInfo has a map position. These are optional and may still yield empty lists in Forever's ordinary zones.

## P0225 mechanics
NavigationSourceProbe only: bounded fixed-index 24 force-visible quests, 24 task-quest starts, 16 quest hubs. Secret preflight precedes semantic reads; pcall isolates optional APIs. Require non-secret numeric questID, ordinary normalized x/y, isQuestStart, explicit non-hidden/non-in-progress state, ordinary IsOnQuest=false/IsQuestFlaggedCompleted=false and real distance within the current C_Minimap.GetViewRadius. Deduplicate quest IDs across existing map/quest-line rows. Quest hubs are separate neutral local-POI objects, not a claim of currently available quest offers. Existing Compass.lua consumes the resulting availableQuestRows/areaPoiRows unchanged. No generic tracking results, DB data, Questie dependency, Blizzard pin enumeration or minimap suppression.

## Validation and acceptance
After deployment, Phase H Navigation Source Probe must display distinct nativeForce/nativeTask/nativeHub scanned/nearby counts and eligible source rows; Phase E Compass Check and Phase H Layout Check; Phase 0 Run All. PASS for a local offer/hub only if actual marker is visible and agrees with a real world/minimap location at a believable bearing. Empty/restricted results are OPEN / SOURCE EMPTY, not PASS. Preserve current P0223 quest/waypoint acceptance and negative P0220–P0221 evidence. No forced travel solely to manufacture data.

## Still OPEN
Engine-rendered tailor/repair/herb/mineral blips remain without a supported public per-detection coordinate enumerator. Their minimap appearance alone does not authorize inspecting Blizzard's protected/secret presentation, fabricating coordinates or declaring the compass complete. Quest-line force-visible and task/hub source coverage require client validation; do not infer universal availability from static API definitions.
