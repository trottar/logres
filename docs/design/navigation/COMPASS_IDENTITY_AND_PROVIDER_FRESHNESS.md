# Compass focused label and QuestieDB freshness plan (P0426)

2026-11-09 | DOCS-ONLY | baseline P0425 `5af8d14b496f4d96cedc3e09fc3f4dc51a2d64b5`

## Approved focus text contract (P0427 implementation candidate)

For an ordinary, source-backed NPC identity, supported role and compatible
same-map world-yard distance, focus displays:

`<NPC name> [<role>] - <rounded distance> yd`

Examples of **format only**, not claims of currently discovered NPCs:
`Aldwyn [repair] - 27 yd`, `Mira [profession] - 18 yd`,
`Nora [quest] - 35 yd`.

- Use addon-provided ordinary provider/NPC names, not synthesized locations.
- Service role derives from the supported provider flag. A label must not
  claim the NPC is presently available just because QuestieDB lists history.
- Quest role requires a currently qualified native quest offer, as in P0337.
  Do not re-enable every historical quest giver just to solve missing markers.
- Preserve no-distance fallback (`distance unavailable`) rather than inventing
  yards, and preserve waypoint/source marker family and silent ambient labels.
- No native secure/protected read or invented quest ID. Role `profession`
  is presentation vocabulary for the supported trainer role; do not assume
  class/profession type until independently sourced.
- One focused label only. Do not attach permanent text to every POI glyph.

## Provider-health and missing-giver investigation (planned P0428)

Existing data paths: `QuestieDBNearby` reads optional `LibQuestieDB` / `NpcDB`,
validates Forever mode and canonical `UiMapID->AreaID`, indexes NPC IDs 96 per
frame, computes 50-yard local candidates, then limits candidate and marker
pools. `Compass` corroborates historical quest-start candidates against
`NavigationSourceProbe`'s native current-offer IDs; uncorroborated records
are intentionally excluded. Native map positions and tracked quest source
remain separate and take precedence. The provider's `RequireContract(1/4)`
and `/logres questiedbprobe` already expose compatibility/version signals.

Record separate cause counters and status:

1. Provider missing, not loaded, wrong flavor, unsupported contracts, or
   installed version unknown/outdated versus a **manually curated** compatible
   release target (current upstream stable candidate v1.0.13, 2026-11-08).
2. Canonical map unavailable, index unfinished/truncated, NPC record or spawn
   missing, or outside 50-yard radius; no positional guessing.
3. Native current-quest-offer corroboration missing despite a historical
   QuestieDB record, versus a confirmed eligible quest; P0337 false-positive
   rejection must not be removed without positive source evidence.
4. Eligible candidate present but clipped by shared marker pool, bearing
   collision, priority, or instance/visibility rules.
5. Quest giver physically observed but absent from all proven sources:
   log an explicit unknown, preserve deliberate Blizzard map/interaction
   fallback, do not assert no quest exists.

Use addon-owned bounded diagnostics and event-driven source invalidation.
Consider a capability-gated interaction-confirmed NPC cache only if real
quest-offer identity AND ordinary same-map coordinates can be acquired safely.
No synthetic location, no broad polling/reassertion, no secret inspection or
mutating QuestieDB. Installing a newer DB externally can improve coverage but
cannot cure a missing current-offer source or marker collision by itself.

## Evidence gates

- P0426 logs user report, exact source paths, v1.0.13 upstream metadata;
  **no runtime changes**, so neither bug is resolved.
- P0427 mock/source tests: real vs absent name/role, ordinary vs unavailable
  same-map yards, service types and eligibility, preserved rendering/alpha.
- P0428: capture a naturally encountered quest giver with quest/NPC identity,
  map/zone, valid position, current quest offer and provider installed version;
  compare `questiedbnearby`, native candidates and collision counters before
  changing eligibility gates. Test both missing and false-positive cases.
- Current P0425 merchant/trainer screenshots are a visual PASS only. Functional
  purchases, buyback redemption, training, repairs, stock fallback, combat
  and Lua/taint coverage remain unproven.
