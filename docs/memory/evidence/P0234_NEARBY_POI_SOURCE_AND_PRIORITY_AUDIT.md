# P0234 — Nearby POI source and glyph-priority audit

Date: 2026-10-17. Source-only and upstream-contract findings; **no new WoW runtime test**.
Remote baseline: Logres `main` P0233 `27e9e36`, previously verified after user push.

## Observed Logres code and user evidence

- `NavigationSourceProbe:ReadTracking` queries `C_Minimap.GetTrackingInfo` and `GetTrackingFilter`: names, active states and filter IDs. It does not yield instances or their positions. D-043 remains authoritative: do **not** inspect Blizzard minimap blips or claim live tracking positions.
- SourceProbe separately reads native area POIs, quest-map points, and vignettes when ordinary positioned data exists. These are distinct from tracking-filter metadata. Previous native test returned ordinary-empty in one map; this is not a universal failure.
- `Compass:RefreshAvailableQuestPOIs` renders focused accepted quest navigation in the quest lane, native positioned local POIs/vignettes in local lanes and native tracking vignettes in the tracking lane, with bounded pools. Its `nearestFirst` comparator orders **native before historical QuestieDB** when candidate type differs; same-tier points sort nearest first. `QuestieDBNearby` uses a provider-derived canonical map and **50-yard historical quest-start NPC spawn filter**; the observed `candidates=4 shown=2` is a single frame, not all locations in a zone. No evidence supports increasing/decreasing the radius now.
- P0233 user validation: automatic startup without manual provider retry in loadCount 307, and user-followed compass marker reached a physical quest giver. No evidence of actual quest availability or general map coverage. Prior P0230 source failure is retained.

## New upstream QuestieDB v1.0.6 source audit

Read upstream `Questie/QuestieDB` tag `v1.0.6`:

- `src/config.lua` declares `contractVersion = 4`, `minSupportedContract = 1`.
- `src/types/Npc.t.lua`: `NpcDB.npcFlags(id)` returns an NPC role bitmask, `NpcDB.spawns(id)` returns zone-grouped spawn percentages, `NpcDB.zoneID(id)` is only the *most common* zone, and `NpcDB.friendlyToFaction(id)` may report `A`, `H`, or `AH`.
- `src/types/LibQuestieDB.t.lua` and `docs/api.md`: `LibQuestieDB.Enum.npcFlags` publishes the active-flavor NPC flag names and numeric masks and is guaranteed only after `RequireContract(4)`. Forever uses its Classic rules flags; absent keys must remain absent.
- `src/corrections/enum/expansions.lua` defines service names `FLIGHT_MASTER`, `INNKEEPER`, `REPAIR`, `VENDOR`, `TRAINER`, `BANKER`, etc. A future consumer must resolve these masks from the **loaded provider Enum**, not assume constant bit values or invent availability.

These are **API/source findings**, not proof that any particular service NPC exists nearby or that all historical service entries are currently interactable.

## Bounded next runtime work item: P0235

Add only a capability-gated QuestieDB historical **service-candidate** layer to the existing finite per-zone index, beginning with flight master, innkeeper and repair categories. Require `RequireContract(4)`, ordinary positive provider flag masks and ordinary NPC spawn coordinates. No additional full-table scans, no per-frame provider scanning, no guessed AreaID, no mandatory dependency and no Blizzard presentation inspection. Service candidates should be distinctly identified as *possible*; they must not overwrite native positioned POIs, focused accepted quest directions or existing quest-giver priorities. Keep initial 50-yard scope, per-category/per-frame caps, and fail open if unavailable. Do not infer real-time service state from the flag database.

Before making code changes, verify the exact upcoming index/presentation shape and add a static contract checker. WoW proof after deployment must independently report compatible v4 source, service spawn counts, visible service glyph count, and absence of regressions to the previously accepted quest marker, waypoint and hidden-minimap policy. Use the existing Phase E panel actions, not a slash-only probe.

## Deferred / not to implement from this audit

- Live herb/ore dots and minimap detection: **source-blocked** without ordinary public per-result coordinates.
- Other QuestieDB services (vendor, trainer, banker, etc.): **later coverage**, subject to density and contextual presentation tests.
- Quest-availability/eligibility claims, other-zone reliability, questgiver radius tuning: **unproven**, not fixed by service flags.
- The Blizzard minimap remains **hidden in normal immersion**, with deliberate dock access retained; it is not a visible substitute.
