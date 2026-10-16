# P0220 — Available unaccepted quests as local compass POIs: source-backed local POI candidate

Date: 2026-10-16. Verified baseline P0219 GitHub `main` `63a7557e58be5091f7a428e6055f71e173dd2834`; `0.0.128-dev` loadCount 290 developer-panel diagnostics provided by user.

## User design refinement

A nearby available, **unaccepted** quest belongs to the local POI awareness role. It must not be confused with an already accepted/super-tracked quest destination, which retains the major lane above the heading tape. Use POI lane and local-minimap radius; quiet POI-style icon rather than giant quest pennon or invented native `!`. Where an ordinary source provides quest identity, reserve contextual focus identity under D-038; no persistent text row. Several nearby quest offers can coexist as individual bearing-truth POIs and use D-038 collision policy after positions are proven.

## P0219 runtime evidence

The `0.0.128-dev` load count 290 probe reported `compassartpreview on/off: PASS`, `compasscheck: PASS`, and `navigationsourceprobe: PASS`; mapID=1432; player 0.35,0.50; world size 2758.33 x 1839.58; view radius 133.33 yards; 23 tracking filters, four enabled; AreaPOI count=0, positioned=0, within-radius=0; quest supertracked ID 2039 but neither C_Navigation nor C_QuestLog supplied a quest waypoint. Secret skips=0 and failures=0. This does not speak to unaccepted quest-giver locations. Existing probe never called the available-quest-line API.

## API/source hypothesis, NOT in-game validation

WoW Forever 1.60.1 API documentation identifies `C_QuestLine.GetAvailableQuestLines(uiMapID)` with rows containing questID, questName, x, y, isHidden, and inProgress, as well as optional metadata. `C_QuestLog.IsOnQuest(questID)` and `C_QuestLog.IsQuestFlaggedCompleted(questID)` are possible eligibility checks. Sources: `Gethe/wow-ui-source` generated `QuestLineInfoDocumentation.lua`, `QuestLogDocumentation.lua` and Warcraft Wiki Forever API pages. `QuestLineInfo` rows are quest **lines**, not an exhaustive API for every one-off available NPC quest. Map-pin x/y must not be equated with guaranteed precise giver position. Do not call `RequestQuestLinesForMap` merely to force returns without evidence.

## P0220 targeted diagnostic implementation

Extend `NavigationSourceProbe.lua` as an optional source adapter and `Compass.lua` as a limited source consumer. The optional path checks availability of all three APIs, samples up to 24 current-map rows with secret preflight and ordinary-field extraction, uses pcall for both quest-log predicates, rejects accepted, completed, hidden and invalid-coordinate rows, computes distances only from verified ordinary player/map dimensions, and counts only candidates within the live client-provided minimap view radius. Individual ordinary names, quest IDs, coordinates, distances and eligibility are reported for developer inspection. API absence, empty rows, no radius, unknown eligibility and secret fields are recorded without manufacturing eligibility or treating optional absence as a global failure. No protected frame/source inspection, source mutation, or timers. Live quest POI glyphs are rendered only when all ordinary input and local-radius gates pass.

## Runtime requirement and negative-result discipline

This patch is a **capability-gated live compass quest-POI candidate**, not proof of full minimap quest parity. After `/reload`, use developer panel Phase H Navigation Source Probe, Phase E Compass Check, Phase H Layout Check and Phase 0 Run All. Compare with naturally nearby stock offered quests if any. Live source-backed POIs must be visually compared to stock quest positions and bearings before runtime acceptance. If zero data or only quest-line subset, classify as OPEN/CAPABILITY-LIMITED; do not invent NPC coordinates or automatically suppress Blizzard minimap. Prior P0218 R0 shadow contract failure is preserved. No WoW test result is claimed before runtime evidence.

## Live renderer policy and unresolved coverage

Compass consumes only addon-owned `NavigationSourceProbe.availableQuestRows`, revalidates current map/player position/view radius via public API, computes exact bearings, displays at most eight nearest in-radius offers in the local POI lane, and resolves marker overlap with vertical lanes without shifting horizontal bearing. A nearby candidate with a source-provided ordinary title may fade into a centered identity readout. Preview mode and lost position/state hide the live markers. This does not prove that every NPC quest-pin visible on the native minimap is publicly enumerated by `C_QuestLine`; the minimap filter only reports tracking configuration. Complete parity remains OPEN if the client does not return suitable positioned quest-line rows. No bundled quest-coordinate database is introduced.
