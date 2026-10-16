---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3 approved compass sheet-12 runtime and capability completion. GitHub `main` P0219 `63a7557` verified. User adds **nearby available but unaccepted quests** to the local POI semantic role, not the accepted/current quest's major-destination lane. Approved artwork, D-037/D-038 true-bearing geometry, and stock-minimap fail-open remain authoritative.

## Current Work Item
**P0220 candidate (`0.0.129-dev`):** add an optional, bounded available-quest-line source adapter and capability-gated live compass POI rendering to `NavigationSourceProbe.lua` using `C_QuestLine.GetAvailableQuestLines(currentMapID)` and capability-checked `C_QuestLog.IsOnQuest` / `IsQuestFlaggedCompleted`. Record ordinary quest/map positions, accepted/completed/hidden exclusions and actual local-view-radius candidate counts. Compass consumes only ordinary, eligible and same-map source rows, updates player-relative bearings on its existing throttled update, and hides markers outside the live radius. Live behavior remains an unverified candidate. Quest-line rows are only a candidate subset; they cannot be assumed to enumerate every available quest or precise NPC location.

## Verified State
- P0219 pushed `63a7557`, `0.0.128-dev` loadCount 290: developer-panel Compass Art ON/OFF and Compass Check PASS; approved quest/POI/tracking glyph previews do not prove real navigation. Navigation Source Probe PASS with 23 tracking types (4 active), player map 1432 and usable local radius 133.33 yards; zero positioned AreaPOIs and no quest/navigation waypoint in that sample. No source failures or secret skips. Layout and normal check suite completed in the tested out-of-combat world.
- Forever 1.60.1 API documentation exposes `C_QuestLine.GetAvailableQuestLines(uiMapID)` returning QuestLineInfo map x/y, questID and questName. `C_QuestLog.IsOnQuest` and `IsQuestFlaggedCompleted` expose acceptance/completion filters. This is API source evidence only; its actual quest-line population, completeness, distance validity and secret behavior remain unverified in the user's client.
- D-037/D-038/D-039 still govern distinct major quest destinations, POI lane, tracking lane, center focus and source gates. Tracking-result locations remain source-blocked. No stock minimap suppression is authorized.

## Next Action
Apply guarded P0220, deploy, `/reload`. In the developer panel use Phase H **Navigation Source Probe** in an ordinary world area where quest-giver markers naturally exist, then Phase E **Compass Check** and **Compass Art ON/OFF**, Phase H Layout Check, Phase 0 Run All. Inspect the `availableQuestLines=` summary and `availableQuestLine[]` rows. If only empty results occur or the API is unavailable/secret, record DEFERRED, not PASS. Do not travel solely to manufacture a case. Compare naturally visible stock quest offers with live POI glyph bearings and the reported eligible rows; absence of source data is a deferral.

## Success Criteria
- Unaccepted available quests are classified as local POI subtypes, with nearby-only radius and same-map positioning required, distinct from already accepted quest destinations. No quest punctuation or false bearings.
- New source probe is read-only, bounded to 24 rows, secret-safe, preserves previous navigation probes and never treats missing optional APIs as overall probe failure. Ordinary accepted/completed/hidden or off-radius candidates are excluded from the eligible subset.
- Live local POI glyphs may render only for ordinary confirmed eligible quest-line positions; no new minimap, quest controls, pet driver, action paths or screen-map geometry mutation. Full static checker suite, diff hygiene and checked in-game actions show no regression within tested scope; unobserved data remain DEFERRED.

## Do Not Reopen Without New Evidence
Do not infer all available quest givers from quest-line pins, treat map-level positions as NPC coordinates without runtime verification, branch on secret values, add polling or broad hooks, hide the stock minimap, or reopen P0214–P0219 accepted presentation and pet/action behavior.

## Relevant References
- `docs/memory/evidence/P0220_COMPASS_AVAILABLE_QUEST_POI_SOURCE.md`
- `docs/memory/patches/P0220_COMPASS_AVAILABLE_QUEST_POI_SOURCE.md`
- `docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md`
- `docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md`
- `docs/design/approved/12_compass_glyph_and_state_sheet.png`
- `docs/memory/evidence/P0219_COMPASS_SHEET12_AND_CAPABILITY_GAP.md`
