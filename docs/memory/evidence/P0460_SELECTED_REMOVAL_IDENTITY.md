# P0460 — Selected nameplate removal attribution after P0459 regression (2026-11-16)

## Runtime incident and exact source

Verified P0459 GitHub main `0cbc8cc7a9f9db14a308f9e24a556a66023e30ab`,
tree `64af7ead1f4ce638b3779c719a38d952edb310af`.
Forever bundle source/deployed/capture all `0.0.328-dev`; incident #13499
session 131, 2026-11-16 10:41:32 EST. User reports P0459 "worked for a
little then broke". The screenshot shows Mangy Wolf's native-looking
selected nameplate, including level decoration, after activity; the
image/incident correspondence is file-mtime inferred (0-second delta),
not a client-attested screenshot association. Selected 4 attaches/4
detaches, 4 native transfers/4 restores, zero restore failures; last
detach `nameplate-removed`, removal result `unknown-attached-unit`.
Secondary 3 attaches/3 detaches/3 restores, 0 active, last `secondary-removed`;
4 nameplate additions and 3 removals. Earlier 10:41:26 status recorded
selected 3/2 and secondary active=1, indicating initial functionality;
10:41:35 status recorded 4/4 and 0 secondary owners. Event counters do
not independently prove which exact nameplate each removal concerned.

## Narrow source defect and P0460 correction

In P0459 `RefreshLiveWorldEnemy` acquires the selected anchor through
`C_NamePlate.GetNamePlateForUnit("target")` for manual/target-change
updates, returning no event unit; `worldEnemyLiveAnchorUnit=nil`.
`IsLiveEnemyRemovalRelevant(eventUnit,nil)` unconditionally returns
`true,"unknown-attached-unit"`; every unrelated secondary plate removal
can restore the selected Blizzard artwork and withdraw the Logres overlay.
The P0457 steady path never repairs an initially unknown token.
This is a directly demonstrated source-level false-positive mechanism,
consistent with #13499, not an independently recorded event-unit trace.

P0460 records only validated ordinary nameplate ADD tokens and an
addon-owned generation while the HUD event frame is enabled, including
before the user turns World Enemy ON. At selected target-query attachment,
a fresh ordinary `UnitIsUnit(token,"target")` role check of the
bounded observed tokens uniquely resolves the selected owner. A later
ordinary event can upgrade an initially unknown selected claim without
restoring/reanchoring. REMOVED unrelated token does not detach selected;
REMOVED matching token does restore native. Fresh ADD of the same token
establishes a new generation and forces structural reanchor, avoiding
reuse of a stale selected owner. World transitions clear the registry
and restore; an absent, ambiguous or restricted role leaves the
existing fail-open unknown-removal fallback intact.

Native nameplate frame identity is never inspected/compared; only
ordinary event tokens and gated role booleans are used. No polling,
timers, CVar changes, protected writes, secret comparisons or blanket
suppression. P0456/P0459 historical roadmap checks preserve negative evidence
without requiring stale newest-phase order.
P0459 secondary threat-independent visual owner remains
unchanged; native casts/auras/click and opaque restoration are retained.

## Tests and outstanding limitations

P0460 actual-source mocked Lua behavioral gate covers selected owner
resolution, other-unit remove, matching remove, same-token ADD reuse,
target change, unknown identity fallback, unsafe anchor, refused OFF
restoration and world transitions. Exact candidate 323 static checkers,
Lua compile, diff hygiene, baseline/payload/dirty refusal and rollback
are required before ZIP release. Client remains **VISUAL FAIL for P0459;
P0460 runtime UNVERIFIED**. L-011 remains OPEN/PARTIAL; L-028 OPEN.
Unobserved or secret nameplate tokens remain native fallback on unsafe
removal. Do not declare all native nameplates eliminated without scoped
in-game proof. P0454/P0455 and P0458 visual failures retained.
