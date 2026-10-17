# P0231 — P0230 runtime failure: dynamic MapID to QuestieDB AreaID bridge

Date: 2026-10-17. Evidence: user-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` following P0230 push, Logres 0.0.136-dev loadCount 305.

## Observed

- GitHub main commit `92de16d` verified and contains P0230 and P0228 changes. P0228 compatibility remains valid: QuestieDB 1.0.6, registered/loaded yes, packaged Baked Forever, `contract=1`, `provider=contract-compatible`.
- Phase E `QuestieDB Location Probe`: `questiedbnearby: index=map-not-in-provider-zone-table map=- area=- scanned=0 ids=0 zoneNPCs=0 questNPCs=0 spawns=0 nearby=0 radius=50 truncated=false`.
- `Compass Check`: `compass nearby: provider=map-not-in-provider-zone-table candidates=0 shown=0`; separate base `compasscheck: PASS` for heading/waypoint policy. The PASS is **not nearby-source PASS**.
- The index never started; `nearby=0` is not evidence there are zero nearby quest givers. Normal immersion folds the native minimap: it cannot fill a visible compass gap. No Lua/taint error appeared in these selected diagnostic lines; no comprehensive WoW error dump was supplied.
- Source explains missing evidence: P0230 matches `C_Map.GetBestMapForUnit("player")` and first five `C_Map.GetMapInfo(...).parentMapID` hops against QuestieDB's **canonical** UiMap→Area map. On any mismatch it calls `Unavailable()`, which clears map and area, and the probe prints only `map=- area=-`; it does not preserve the observed map or ancestor chain. Exact runtime map ID therefore cannot be recovered from this export.

## Narrow correction / diagnostic

P0231 extends bounded parent checking from five to twelve hops, preserving the provider's canonical AreaID acceptance gate. It records only already-ordinary player `UiMapID` and parent numeric IDs, an explicit chain termination reason, and the number of canonical entries parsed. It adds `ZONE_CHANGED_NEW_AREA` invalidation (in addition to existing player map/world events) and makes the existing Phase E button deliberately retry the map bridge once to ensure evidence reflects the current context. No native pin reads, no guessed AreaID, no broad re-scan, no polling, no hardcoded zone, and no extra minimap fallback. Existing 50-yard cached index and compass glyph behavior remain unchanged.

## Status and next evidence

P0230 nearby feature **FAIL / source map unresolved** in tested character context; P0231 runtime **UNVERIFIED**. A single new Phase E `QuestieDB Location Probe` must report `questiedbmap requested=<id> chain=<ids> entries=<n> failure=<reason>` plus existing index state. If P0231 reaches a canonical zone, index completion and live markers still require independent proof. If unmapped, use actual chain and upstream QuestieDB map evidence for a later narrow fix; do not guess conversion or demand travel.
