# Current Handoff — P0223 focused quest distance-depth

Authority: `docs/memory/CURRENT.md`.

GitHub P0222 `b1fa844` verified. The 0.0.131-dev loadCount 295 runtime source probe on map 1432 returned 3 accepted positioned quests (IDs 237, 255, 2039), with user-confirmed quest compass glyphs and a correct contextual name. Other POI/tracking source families remain empty. P0222 accepted as first non-waypoint positive evidence, NOT as complete compass navigation.

P0223 candidate keeps only the super-tracked accepted quest glyph (237 in that capture) and sizes it with the proven manual-waypoint depth curve; no new position source, timers, protected UI, or minimap suppression. Developer panel reports focus ID/quest size and band. Apply/validate in WoW and report real focus/scaling evidence; empty POI/tracking sources remain OPEN. Runtime-code patch requires deploy and `/reload`.
