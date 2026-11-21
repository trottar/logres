# P0508 — L-060 actual Forever icon contrast correction (2026-11-21)

## Source and runtime evidence

Remote main P0507 `aacf09d2dfce60d842c879cf57f548d764c2af8a`
verified. User reports P0507 gold versus service icons showed **little
visible difference**. The provided 2026-11-21 14:44 EST Forever bundle has
source/deployed/captured `0.0.372-dev` matched. Session199 incidents
#22267 (14:43:53) and #22269 (14:43:58) screenshot timestamps correlate
by image mtime (INFERRED, not exact client proof). The compass shows
Lieutenant Jocryn Heldric `[quest]` 9yd; diagnostic snapshots show
`availableQuestPoiShown=2`, `dbServiceCandidateShown=3`,
`dbEligibilityQuestCandidates=4`, `poiCollisionHiddenCount=2`, and
QuestieDB eligible quest candidates. User's visual verdict is **P0507
insufficient-contrast FAIL**, retained as real L-060 evidence.

## Narrow cause and remedy

The shared 36x36 `compass_local_poi.tga` has brown/ochre RGB (e.g. central
pixel 171/151/122), with a complex gold-brown shaded border. Vertex tint
multiplies those existing pixels and cannot brighten the brown texture.
At runtime P0507 further scales inferred-provider icon alpha by 0.55,
making a 9px gold icon hard to distinguish from desaturated service art.
Do **not** remove this uncertainty gate: no native quest availability is
proven by the inference.

P0508 supplies two color-remastered variants of **only the RGB pixels** of
the existing icon: brighter warm yellow-gold with original relief for a
quest-giver, grayscale subdued texture for services. Both TGA outputs
retain the exact original per-pixel alpha byte, 36x36 source dimensions,
9x9 Logres rendered geometry, scaling, source/bearing, and original
P0507 vertex palette. The marker pool switches addon-owned texture per
actual rendered POI/service role on each reuse (no stale category bleed).
The unmodified original texture remains the nonquest neutral POI and
safe asset fallback. No changes to alpha, collision, focus, arrival,
quest eligibility, native UI, polling, or protected/secret state.

## Verification and gates

`tools/check_p0508_compass_palette_contrast_contract.py` checks TGA
headers, pixel-exact alpha equality, strong gold-vs-service channel
contrast, asset wiring, per-reuse role selection, and all legacy geometry,
source and alpha contracts. Retain P0507/L-060 static positives and
P0507 actual visual failure; P0508 **runtime UNVERIFIED**. Initial
asset-check parser refusal for a normal 26-byte TGA footer was fixed
without changing icon data. First 368/368 historical checker scripts
PASS with liblua5.4 source fixtures; Lua syntax compilation PASS.
Final exact-candidate payload/ZIP readback and git diff hygiene remain
handoff requirements; applier repeats prewrite/postwrite checks. After deployment compare gold quest and muted service markers
in a naturally populated city, with the existing focus and bearings.
