# P0426 — P0425 visual PASS and compass/provider intake

Date: 2026-11-09. Baseline: verified GitHub `main` P0425
`5af8d14b496f4d96cedc3e09fc3f4dc51a2d64b5`.

## Scoped runtime acceptance

After P0425 R1 was committed and Forever deployed, the user uploaded two
screenshots (Brog Hamfist merchant and Tomas profession trainer) and wrote
"Looks great!". The merchant screenshot shows aligned Merchant/Buyback
sidebar headings and the separate native buyback button no longer crossing
the footer divider. The trainer screenshot shows the compact seven-row
catalogue, lower selected-service detail, reagent/funds region and visible
Blizzard UI/selection controls, without evident clipping. **VISUAL PASS**
within these screenshots only. No receipt of buyback redemption, purchase,
training transaction, repairs, native fallback/recovery, combat, error log,
or close/reopen in this message. Preserve L-003 PARTIAL and L-033 OPEN.

## New observed compass concerns

The user reports a focus label like "Possible repair" instead of
`<Name> [profession, repair, quest, etc.] - <yards away>` and has seen a
physical quest giver without any nearby compass marker. No NPC name, quest ID,
map, installed QuestieDB version or incident snapshot was supplied for the
missing marker. This is a **user-observed missing-glyph case with UNKNOWN
cause**, not proof that QuestieDB is solely responsible.

## Source audit (P0425 main, unchanged)

- `Logres/Navigation/Compass.lua`: `SERVICE_MARKER_STYLE` embeds `Possible
  repair:` and similar role prefixes. The focus renderer formats validated
  world-yard distances as `N yd` or `distance unavailable`. Focus candidate
  names combine the static role prefix with the QuestieDB NPC name.
- `Logres/Navigation/QuestieDBNearby.lua`: optional baked Forever provider,
  `RequireContract(1)` quest starts, `RequireContract(4)` service roles,
  canonical map/zone mapping, bounded index and 50-yard candidate search;
  the historical NPC list alone cannot prove an active offer.
- `Compass.lua` P0337 eligibility gate requires a native current-offer quest ID
  before QuestieDB historical quest-giver coordinates are displayed. A false
  negative may arise from missing DB spawns, missing native corroboration,
  50-yard/canonical map limits, finite glyph slots or bearing collision.
  These are hypotheses until matched to a natural missed-NPC incident.
- `Logres/Navigation/QuestieDBLocationProbe.lua` and `/logres
  questiedbprobe` already report provider flavor, mode, installed TOC
  version, contract and map/gossip sampling; these are diagnostics, not
  proof the latest provider is installed.
- `docs/DEPENDENCIES.md` historically pinned v1.0.6. Official GitHub stable
  v1.0.13 was published 2026-11-08 with Forever asset SHA256
  `f07c6cb18a723c8fba824038ffaaf5de23ab5c8ecd1d9235b122f06a59666f0c`.
  A matching-named CurseForge Forever release is listed 2026-11-08; provider
  compatibility with the player's installed addon is UNVERIFIED.

## Sequence after docs checkpoint

1. **P0427** narrow, sourced focus-label formatting only, preserving P0337
   eligibility gate, diagnostic status and existing protected-safe distance.
2. **P0428** inspect installed QuestieDB version/compatibility and classify
   actual missing-giver reasons. Provide safe external update/backup plan,
   no background game-web fetching or blanket quest-giver enablement.
3. Only after evidence choose a bounded corrective quest-source patch. Preserve
   user-visible Blizzard map fallback and D-037/D-038 distinction between
   historical candidates and verified live interaction.

P0426 is DOCS-ONLY; no WoW redeployment is required, and neither compass
problem is claimed fixed. L-030 PARTIAL, L-043/L-044 OPEN, L-017 packaging
BLOCKED. R0 P0425 static refusal and P0425 R1 corrected release are retained.
