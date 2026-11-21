# P0505 — L-004 flight-map shell containment (2026-11-21)

## New Forever evidence, P0504

P0504 `0.0.370-dev` Forever bug-report ZIP captured actual flight maps at
12:37:27 (Sentinel Hill) and 13:05:54 EST (Stormwind), not quest windows.
The associated screenshot-file match is inferred from client file mtime, not
claimed as a client-provided image identifier. The Stormwind incident #21941
(session 195) flight audit records `taxi-layout-active`, `hostResult=centered`,
`scaleMatched=true`, 20 native host children, two priced routes and zero
sidebar route requests. Visual screenshot confirms the 580x580 parchment map
protrudes beyond the painted right and bottom edges of the service window.
Past P0404 centered/unclipped PASS is historical and does not refute this
new P0504 failure. The current audit's `centered` label does not check bounds.

## Narrow cause / patch

Current `FlightWindow.lua` borrowed the trainer preview width 820 and height
660 as flight host art; map X/Y/size are 279/100/580. Map right=859 exceeds
host right=820 by 39; map bottom=680 exceeds host bottom=660 by 20. The
left route wash ends at 102+578=680, also 20 beyond its frame.

P0505 gives the **flight-only** addon-owned shell dimensions 900x720, which
leave 41 px at the right and 40 px at the bottom for the unchanged native
580-square map and route lines. Sidebar bottom becomes similarly inset 40 px.
Preserve the trainer/merchant geometry; native TaxiFrame and its 20-child pin
and close ownership, anchor relationships, scale and fare dispatch remain
unchanged. Both centered and recovered layout paths use the same flight-only
shell. Read-only viewport-fit validation uses ordinary UIParent sizes for the
new bounds; smaller viewports fail open to stock. No polling, native API
flight purchase, pin click alteration or new interaction suppression.

## Pre-handoff negative result and correction

First complete candidate sweep **FAILED 361/366** historical checks. Five
P0381/P0408/P0443/P0448/P0449 document contracts require the CURRENT P0486
checkpoint to be the first section in active roadmap records, but the
candidate had prepended P0505. No runtime flight assertion failed. The patch
was withheld; existing P0486 heading was restored to the front and the P0505
record placed immediately after its section, retaining all contracts. The
corrected exact candidate requires a fresh 366-checker pass.

## Release gates and limits

P0505 source checker asserts the prior overflow is impossible by arithmetic,
sidebar containment, unchanged map dimensions, native input and scale/fallback
guards. Complete historical checker suite and exact-candidate ZIP/rollback
inspection are mandatory before handoff. **Actual Forever visual fit,
map-pin hit testing, sidebar route purchase and Goodbye remain UNVERIFIED**
until a normal flight-master visit, including a small-viewport fallback.
L-004 remains PARTIAL / client visual FAIL observed on P0504; not closed.
