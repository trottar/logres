# P0507 — Quest-giver gold and muted service POI colors (2026-11-21)

## Authority and user direction

GitHub `main` P0506 `d7266456ddca93693589c944985366cbeb6310b0` verified before source inspection. User requests the current compass quest-giver NPC icons remain **the same shape and size** but gain a more defined golden color; all other service icons should have duller colors, within the same Logres aesthetic. This supersedes the earlier assistant suggestion to change shape/emphasis. L-060 is an unverified presentation refinement, not a quest eligibility repair.

## Source finding and design

`Logres/Navigation/Compass.lua` uses one `compass_local_poi.tga` texture for both the 8 available-quest/POI glyphs and 32 service glyphs. Quest-giver POIs were not explicitly vertex-tinted; services used saturated per-category RGB in `SERVICE_MARKER_STYLE`. The POI pool also includes non-quest AreaPOI/vignette records, so indiscriminately tinting the whole pool gold would be incorrect. Role classification already derives `questLinked` from an ordinary quest ID in the existing `add(row,role,key)` function.

P0507 adds an addon-owned per-candidate `questGiver` visual discriminator solely when `role=="poi" and questLinked`; explicit role POI without a quest ID stays neutral. The quest-giver palette uses `{1.00,0.86,0.42}` RGB and the neutral POI palette `{0.62,0.63,0.60}` in `Theme.compass.poiPalette`. The sixteen named service RGB values are desaturated/darkened while maintaining category hue, and their original `SetVertexColor(style.r,style.g,style.b,1)` rendering remains intact. Native and QuestieDB eligibility, quest destination marker, tracking, corpse, waypoint, marker texture, dimensions, alpha/edge fade, focus/collision/arrival order, and world bearing are unchanged. No Blizzard frame or protected UI mutation.

## Boundaries and verification

Focused new `tools/check_p0507_compass_palette_contract.py` tests palette hue separation, all sixteen service colors, gated quest-linked classification, neutral POIs, preserved geometry/texture and version parity; older service/compass contracts must remain PASS. The final static checker suite, version policy, memory health, exact-candidate ZIP payload hashing, and transactional applier checks are release gates. No actual in-game contrast assessment was performed. L-060 remains OPEN until user sees quest and service markers together on WoW Forever; tune RGB based on that evidence rather than changing shape/size or sourcing new data.

## Preflight corrections retained

First local edit candidate failed before assembly because an assumed `ISSUE_LEDGER.md` narrative insertion anchor did not exist; the user repository was never touched. The new contrast checker initially required a 0.13 normalized average-channel gap, incorrectly rejecting the deliberately muted flight tint; corrected to 0.10 while preserving the explicit sixteen-service numeric checks. A first handoff note draft measured 8005 bytes, exceeding the 8000-byte source contract; the corrected note is 7992 bytes. The first complete prepared candidate passed 367/367 existing+new static checks and 15/15 archive payload parity. Final audit-bearing candidate must be rechecked before handoff. Neither offline run is client color contrast evidence.
