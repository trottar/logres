# P0512 — Selected trainer lesson: crafted-item statistics

Date: 2026-11-23. Verified main P0511 `80813b22ad90aa1c0c0e8f0add0161ef553eceac`,
tree `f0a4d36e4f6350eaa10ee0a2e0656b92917e189e`; source
`0.0.376-dev`, intended candidate `0.0.377-dev`. User-provided
trainer screenshots show the approved bottom-left detail text region and
correct Train/reagent controls. User's previous unrelated natural-occurrence
test has **not occurred**. It remains PENDING, not PASS or FAIL; no
contrived test or unrelated camera/compass work is added here.

## Supported provenance / ownership

`Quest/NativeTrainerServiceProbe.lua` already observes exact native
trainer service indices from a bound `GetNumTrainerServices` count and
six-field `GetTrainerServiceInfo` tuple. On each non-header service the
same source snapshot now optionally reads `GetTrainerServiceItemLink(index)`;
only a separately ordinary, bounded, well-formed `item:` link is copied.
There is **no inference by tooltip name, icon, filtered position, recipe
spell name, or learned cost**. Missing/unusable links leave native lesson
description or Logres' existing explicit no-description fallback untouched.

`Quest/NativeTrainerServiceProbe.lua` also exposes the independent
`Logres.NPCTrainerItemPreview` read-only data adapter. It is co-located
with its native source to keep the historical 96-Lua-module inventory.
For an exact item link, `C_TooltipInfo.GetHyperlink(link)` is called
under protected `pcall` and independent `issecretvalue` gates. It reads
bounded client-authored tooltip lines, excluding the item name, binding
labels and sell-price footer, with at most three inline fact lines plus
a full-tooltip hover hint. A synthetic fixture verifies actual-style
item slot, armor and stamina text. It does not fabricate numerical stats,
look up a different recipe output, or inspect Blizzard protected/secret
presentation. An item-specific `C_Item.RequestLoadItemDataByID(id)` is
attempted once per trainer visit only when data is loading. A matching
successful `ITEM_DATA_LOAD_RESULT` refreshes the current selected source;
stale/unrelated events do nothing. No timeouts, periodic polling or
native selection/purchase are introduced.

`Quest/TrainerLiveTrial.lua` maps this independently sourced item link
into its existing copied catalogue; selection and filter logic still
operate on captured service indices. `Quest/TrainerLandscape.lua` is the
same fixture/live renderer as before. A mouse-only hit region occupies
its **existing** selected detail text box (local x=6,y=73,w=460,h=63),
with the actual Blizzard item tooltip on hover. No Train click, pricing,
wallet, scroll, search, reagents, native parking, or layout geometry
changes. Non-item services stay as before; unknown item-data paths show
an explicit unavailable/loading statement rather than guessed stats.

The baseline contained an existing invalid Lua escape in its live
trainer slider texture string (`Interface\Buttons\WHITE8x8`). This
changed file normalizes it to the valid double-escaped texture path,
with unchanged intended asset. Source compilation is checked separately.

## Static candidate history (negative results retained)

The first prototype inserted a 97th Lua load entry and changed the
historical `snapshotForeverRow` signature. Focused historical checks
P0285/P0291/P0292 refused the changed adjacent TOC and required source
signature. P0323/P0372 and other historical ownership contracts also
refused 97 modules where the accepted baseline has exactly 96. The
corrected source keeps the original service-probe signature and
adjacency; the independent item-preview adapter is now exposed as a
separate addon namespace table inside that existing read-only source
file. Historical contracts were **not** weakened to accept inventory
drift. These were static candidate failures; no user installation or
client regression occurred. Final audit status is recorded in
`docs/memory/PRE_HANDOFF_AUDIT.md` and the generated ZIP receipt.

## Regression constraints and evidence

- D-046: existing synthetic `TrainerLandscape.Fixture()` and live
  `Landscape.Render` share their exact layout; new synthetic source
  fixture `tools/p0512_trainer_item_preview_fixture.lua` checks cached
  output facts, full hover, missing cache/API, request and secret links.
- D-047: camera and interaction timing unchanged.
- Native trainer and `L-033` purchase/confirmation fallback remain
  separate and OPEN unless actual client interaction demonstrates PASS.
- Existing `P0510` event/quest and `P0511` tracker natural-occurrence
  tests remain UNVERIFIED/PENDING; no inferred PASS, no broadened vetoes.
- Known limitation: some client services do not expose item links; some
  client tooltip APIs may be absent or deferred. Those do not authorize
  an invented crafted-item mapping. Item-link semantics and actual
  appearance still require a targeted Forever client observation.

## Required client gate (UNVERIFIED)

Deploy candidate to Forever; `/reload`; visit a naturally accessible
profession trainer; choose an unlearned recipe which creates an item.
Verify lower-left detail shows real item-slot/armor/attribute/effect
lines (as available), and hovering there shows that **same item** in the
full native tooltip, before any purchase. Repeat on an uncached item if
naturally possible; verify loading/refresh, selection switching, search,
filter, scroll, non-item lesson fallback, and no overlap with reagent,
cost and Train. Deliberately click Train only when willing to learn the
recipe; confirm native transaction and rollback/stock path as appropriate.
If a defect occurs, use in-game **Report Bug** and export existing
`LOGRES_BUG_REPORT_LATEST.zip`/`LOGRES_DIAGNOSTICS_LATEST.lua`.
No actual WoW runtime validation is claimed by this file.
