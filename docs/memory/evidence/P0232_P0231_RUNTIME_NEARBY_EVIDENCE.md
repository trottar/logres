# P0232 — P0231 runtime nearby-quest candidate evidence (2026-10-17)

## Verified remote

User said `pushed`. GitHub `trottar/logres` `main` commit `968675ac6a10aa7f4f7512975ec8204c964893d2` (short `968675a`) was independently verified. It contains P0231. Parent P0230 `92de16d` remains in history. No assistant remote write.

## Fresh in-game diagnostics, NOT static inference

Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, Logres `0.0.137-dev`, loadCount **306**, `/logres questiedbprobe` at 1792252651, `/logres compasscheck` at 1792252652:

- QuestieDB v1.0.6 registered/loaded `yes/yes`, baked mode, `Forever` flavor, `contract=1`, `provider=contract-compatible` — provider compatibility **PASS**.
- Nearby source: `index=ready map=1432 area=38 scanned=13392 ids=13392 zoneNPCs=153 questNPCs=30 spawns=38 nearby=5 radius=50 truncated=false`. This establishes completed bounded area indexing, 5 historical spawn positions within 50 yards, no truncation in this instance — **RUNTIME PASS for this observed source path**.
- Map trace: `requested=1432 chain=1432 entries=54 failure=- trigger=panel-map-diagnostic`. The current map directly matched an official provider mapping; no parent walk or guessed conversion was needed. This is one tested map, **not** proof of every Forever map.
- Compass source: `provider=ready candidates=4 shown=2` — addon-owned renderer reports two live presentation glyphs in this test; **RUNTIME PASS for addon-owned marker state**. This does not prove visual legibility or accuracy against a real-world NPC without separate observation.
- Native `compasscheck: PASS` verifies existing heading/waypoint/presentation policy, *not* QuestieDB marker accuracy. The existing quest-giver gossip-match probe remains DEFERRED (`gossip=not-observed`); it is independent of nearby candidate discovery.
- No Lua/taint/protected errors were present in these exported diagnostic lines. A full WoW error capture was not provided; do not claim global error-free proof.

## Preserved failure and remaining gap

P0230 loadCount 305 reported `index=map-not-in-provider-zone-table`, `scanned=0`, `candidates=0 shown=0`; that failure remains durable evidence. P0231's existing Phase E **QuestieDB Location Probe** explicitly calls `StartIndex('panel-map-diagnostic')`. The current `trigger=panel-map-diagnostic` shows the successful result **after that panel-triggered retry**. It does *not* establish that index discovery automatically succeeded at login before pressing the panel button, or that it recovers on every zone transition. Do not mark autonomous startup / every-zone coverage PASS based on this result.

An appropriate **nonmutating** follow-up is: on a fresh normal `/reload`, use the existing **E — Compass and Navigation → Compass Check** *before* the QuestieDB Location Probe button. `Compass Check` reports provider/candidate/shown without retriggering the index. If it reports `ready` on its own, autonomous startup is supported; if not, preserve the actual reason and investigate event ordering. Only then run the existing QuestieDB Location Probe if needed for a one-shot recovery comparison. No forced travel, periodic polling, or hardcoded zone conversions.

## Boundaries

These are **possible historical quest-giver locations**, not current eligible quest offers. NPC primary-zone filtering is incomplete for secondary-zone spawns. Native Blizzard minimap is hidden in normal immersion, **not** a visible fallback. No live vendor, herb, ore, service, tracking-blip mirror is claimed. Existing waypoint and focused accepted quest direction remain unchanged.
