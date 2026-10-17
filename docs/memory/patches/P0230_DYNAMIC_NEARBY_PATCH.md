# P0230 — Dynamic current-zone QuestieDB nearby locations

Scope: optional 50-yard cached **possible quest-giver** markers in any provider-mapped map; automatic current-map/parent selection; no Loch Modan special case; no live native minimap blip scraping; no hard dependency. Native data remains first priority.

Depends on P0228 R1 applied locally and P0229 on main. The guarded one-time applier verifies this, prepares a shadow candidate, executes all repository static checkers, runs diff hygiene, writes a manifest, and does not commit or push.

Runtime is UNVERIFIED until Phase E QuestieDB Location Probe and Compass Check are performed in the game and saved diagnostics reviewed. See `docs/memory/evidence/P0230_DYNAMIC_NEARBY_QUEST_CANDIDATES.md`.
