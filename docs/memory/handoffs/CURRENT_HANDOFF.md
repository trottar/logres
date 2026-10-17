# Current Handoff — P0236 all supported service categories and POI proximity size

Authority: `docs/memory/CURRENT.md`; P0235 pushed `5c77b1e` verified. User visually observed flight master, innkeeper, repair service markers (distinct colors). Latest Logres 0.0.138-dev load 310 shows 1/1 historical quest candidate, 1/1 service candidate, basic compasscheck PASS. Do not infer all in one frame.

P0236: broaden QuestieDB optional contract-4 service enum roles beyond the initial three, without minimap filter toggles or arbitrary NPC pins. Retain one service identity per NPC, historical possible labels, 50-yard radius, bounded 32-glyph service pool and existing quest/waypoint paths. Add local POI distance-based sizing (0.74–1.30) without moving bearings. This is deliberately broad discovery before choosing category filters. Does not provide live herbs/ore/tracking blip positions or quest availability. Runtime UNVERIFIED until WoW deployment.

After apply, exact deployment script then `/reload`; `/logres panel` → E — Compass and Navigation → Compass Check (read-only), then QuestieDB Location Probe (may retry index); export diagnostics. Validate category coverage, proximity scaling, and lack of protected/Lua/taint errors. Record negative results.
