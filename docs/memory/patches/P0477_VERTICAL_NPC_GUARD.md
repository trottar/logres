# P0477 — Guard projected NPC near-centering against other floors

Verified P0476 `033fffd` / tree `4b4658c`; candidate 0.0.344-dev.
L-035: P0476 #16399 displayed three auto-centered 2D-only service
candidates and false 2yd focused service label in multi-floor context.
Guard QuestieDB provider NPCs below 4yd using ordinary live Creature-ID
and range verification; otherwise omit misleading near marker and label.
Add read-only Report Bug reason counts, update P0476 regression fixture
and checker with the new conditional contract, and add P0477 focused tests.
Native quest markers, stock quests, NPC controls, previously accepted HUD
and native fallback are unchanged. L-002 intermittent popup remains OPEN.
P0476 failure is retained in evidence; P0477 runtime UNVERIFIED.
