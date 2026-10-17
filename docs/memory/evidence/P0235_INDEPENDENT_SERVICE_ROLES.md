# P0235 — Quest-independent flight master, innkeeper and repair POIs

Date: 2026-10-17. Exact pushed baseline: Logres `main` P0234 `e10c79a`. **Runtime implementation prepared; WoW UNVERIFIED.**

## User finding: classification / coverage defect

The user observed that Logres's "possible quest giver" POI markers include flight masters whose NPC records have historical `questStarts`, while flight masters, innkeepers and other services **without any historical quest start** are never marked. This is not primarily a radius issue: the P0230 implementation only reads spawn positions from NPCs in `questStarts`. The user requires a flight master to qualify by being a flight master, regardless of whether that NPC ever had a quest. The identical independent-qualification rule applies to innkeeper and repair roles.

P0233 automatic QuestieDB startup and a real quest-giver route remain accepted in the tested map. A source-level classification failure can coexist with that successful spatial evidence. No claim that the specific original marker was a verified QuestieDB service role is needed.

## Implementation

- The original contract-1 historical quest-giver path is preserved. **Separately**, only when loaded QuestieDB `RequireContract(4)` returns ordinary `true`, read ordinary `LibQuestieDB.Enum.npcFlags` role masks and `NpcDB.npcFlags(id)` in the existing bounded 96-ID-per-frame zone scan. No hardcoded numeric role masks, new zone/global scan or periodic retry.
- A service NPC enters the index from `npcFlags` **without any questStarts requirement**. For multi-role NPCs, use exactly one category in this order: `FLIGHT_MASTER`, `INNKEEPER`, `REPAIR`. A dual-role service/quest NPC has one service candidate and **no duplicate/mislabeled possible quest-giver candidate**. If v4 is absent, retain the original v1 quest feed unmodified.
- Service rows use only the same zone's provider spawn percentages; preserve canonical map mapping and 50-yard distance test. Cache at most 96 spawn points per category, 16 per NPC. Select at most 4 service NPCs in the current 50-yard window, at most 2 per service type. Historic primary-zone-only `NpcDB.zoneID` coverage remains a known limitation; zero matches are not proof of absent services.
- Render separate, finite four-glyph **service POI** pool (using existing local-POI artwork with subdued category tint), so service-only NPCs are not excluded merely because the eight regular quest POI slots fill. The existing native POI pool, focused quest lane, directional placement and waypoint marker are unchanged. Candidate focus captions say `Possible flight master`, `Possible innkeeper`, or `Possible repair`; no real-time service promise.
- `Compass Check` now includes a separate read-only `Logres compass services: provider/candidates/shown`; the existing `QuestieDB Location Probe` (which deliberately retries scanning) exposes `Logres questiedbservices: capability/enabled/cached/flight/inn/repair/nearby/truncated`. No change to dependency optionality, native minimap policy or CurseForge/third-party packaging.

## Runtime validation and negative-result discipline

**WoW UNVERIFIED** until a live client checks startup, v4 capability state, service scan/output and preservation of nearby historical quest-giver and accepted-quest/waypoint behavior. No Lua/protected-state failure was observed in the prior P0233 scope, but P0235 itself may still fail. Static contract checks do not certify service glyphs or physical NPCs.

After guarded apply and mandatory deployment, `/reload`; `/logres panel` → **E — Compass and Navigation** → **Compass Check first** (read-only; expected possible service POIs only if source has nearby candidates). Then only if needed **QuestieDB Location Probe** (one-shot scan retry), followed by Compass Check. Export diagnostics. If first check says `provider=ready candidates=0 shown=0` in the user's current map, record **geographic DEFERRED** for service visual proof, not a FAIL or PASS. Do not force travel to manufacture results.

If `contract4-unavailable`/missing flags, service path must fail open, quest markers continue. If Lua, taint, protected or secret errors occur, preserve exact error and prepare narrow correction before proceeding. Herb/ore live tracking remains source-blocked; other service types deferred.
