# P0236 — Expanded possible service POIs and local proximity scaling

Date: 2026-10-17. GitHub main P0235 `5c77b1e` verified after user push. Initial code state Logres 0.0.138-dev.

## Observed evidence and outstanding failures

- Latest uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` loadCount 310 on 0.0.138-dev: `compass nearby: provider=ready candidates=1 shown=1`, `compass services: provider=ready candidates=1 shown=1`; base compasscheck PASS. These counts are from a frame, not all markers seen during movement.
- User **visually confirmed** innkeeper, repair, and flight master service markers, including distinctive category coloring, as well as numerous historical possible quest givers that did not currently offer quests. QuestieDB questStarts captures historical associations, not eligibility. This is an OPEN classification/relevance limitation, not a validated quest offer.
- User reported local POIs did not vary marker size based on proximity and requested all possible POI types for visual review, even if native minimap tracking does not enable them. P0235 source restricted service candidates to only three categories and four visible service slots, regardless of other upstream enum flags. Both service breadth and local-size behavior are missing capabilities.

## P0236 prepared bounded runtime implementation

- Under the existing optional QuestieDB `RequireContract(4)` and loaded provider `Enum.npcFlags`, extend the **same** bounded zone scan to all 16 named service-role flags when present. These are explicit NPC services, not generic gossip, all NPCs, or live minimap tracking results. Unavailable flags are skipped; no numeric flag values are assumed.
- Preserve per-NPC single preferred service role (dual-role quest NPC remains a service), 50-yard source bound, at most two result NPCs per service type, 16 spawns per service NPC, 96 cached per role, 96 NPC IDs per frame and **up to 32 service marker slots** in the viewport. No second global ID scan, no periodic scan or protected Blizzard pin inspection. 32 is a finite exploration cap, not an uncapped promise to render every NPC.
- Local POI, historical quest and service, and ordinary tracked vignette glyphs scale smoothly between 0.74 and 1.30 according to their own validated local distance cap; **exact horizontal bearing is unchanged**. Focused accepted quest and manual waypoint keep their established independent depth policies. Diagnostic shows sizes and supported/nearby provider roles.
- Native tracking filter state is intentionally irrelevant to these QuestieDB *historical possible* service markers. Some minimap POI types (mailboxes, herb/ore tracking nodes, etc.) do not have verified individual positions from this source and are **not** promised by this patch. The native minimap remains hidden during ordinary immersion; its deliberate user access is preserved.

## Status and follow-up

Patch prepared and statically guarded, **WoW RUNTIME UNVERIFIED** until user deploys/tests. The first test is `/reload` → `/logres panel` → E — Compass and Navigation → **Compass Check** (read-only), then optionally **QuestieDB Location Probe** (one-shot retry and category diagnostics). Inspect new `compass POI proximity` sized/min/max and `questiedbservicecoverage` role counts; observe glyphs with normal movement and report Lua/taint errors. A single-position sample with equal scales cannot establish proximity variation. A 0-count service environment is geographic DEFERRED, not PASS or FAIL.

Next checkpoint: use the user's category observations to introduce filter configuration and a deliberate category-priority policy; separately address historic quest giver false positives using evidence, never assume a quest is available from QuestieDB alone.
