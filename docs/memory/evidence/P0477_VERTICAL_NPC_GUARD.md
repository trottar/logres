# P0477 — L-035 vertical-ambiguity correction for NPC compass markers

2026-11-17 EST. Baseline: verified GitHub main P0476
`033fffd1cf58192c8257d00f9c066ed395b0cf17` (tree
`4b4658c7d50c08ae32349729361ce4e7f3e5980a`), runtime
`0.0.343-dev`. P0477 target `0.0.344-dev`.

## Observed negative runtime result — P0476 is not accepted for stacked floors

User: "NPCs vertically above or below others breaks things too." Uploaded
`LOGRES_DIAGNOSTICS_LATEST.lua` and `LOGRES_BUG_REPORT_LATEST.zip`.
Exporter 2026-11-17 22:18:30 EST identifies source, Forever deployment and
latest capture all `0.0.343-dev`; warnings list empty. Latest incident
**#16399**, session158, screenshot timestamp 22:18:21 EST (filesystem
correlation 0s, still inferred), indoors beside an NPC. The screenshot
renders **`Cylina Darkheart [vendor] - 2 yd`** while the nearby character
is a different NPC. Addon-owned `compassNearNPC` at capture:
`serviceNearCenteredCandidates=3`, `dbServiceCandidateCount=4`,
`dbServiceCandidateShown=2`, `poiCollisionHiddenCount=2`,
`focusedMarkerKind=service`, `focusedMarkerDistanceYards=2.233031734865188`.
Exact Z separation is **not observed**; the user reports vertical stacking.
This is a visual failure of the P0476 assumption that a 2D map projection
proves near-range NPC eligibility. The P0476 test used ordinary 2D=2yd and
unconditionally asserted center; it did not represent multi-floor geometry.

`QuestieDBNearby:ScanChunk` retains only x/y spawn coordinates and service
identity; `GetNearbyRows` computes `sqrt(dx^2+dy^2)` using canonical map
width/height. **There is no verified elevation** in that provider row. A
near-source label of 2yd is *horizontal map distance*, not proof that the
specific NPC is reachable on this floor. No direct native NPC 3D location
or height source was recorded by this capture. Native `UnitPosition`/range
APIs have version/capability caveats; do not invent Z, store unit tokens,
inspect secret values, or use broad map suppression.

## Narrow repair: ordinary live identity/range evidence or hide point-blank

For provider-backed NPC rows with ordinary positive NPC template IDs and
`potential=true`, a projected distance below 4yd **must not** center or
show a bogus 2yd focus unless independent live unit evidence is available.
Read ordinary `UnitGUID` for `npc`, `target`, `mouseover`, parse only the
Creature template-ID field after rejecting secret/missing GUIDs, and require
`CheckInteractDistance(unit,3)==true` on the *same* unit token before
qualifying that candidate, **outside combat only** (guard
`InCombatLockdown` before calling the restricted proximity API). Range index3 is a broad proximity gate, NOT
an exact 3yd measurement; 2D<=3 remains the final center threshold. API
unavailable, protected refusal, unknown/secret identity, different NPC or
missing range evidence mean **no auto-centering and no displayed near-floor
provider marker** below 4yd. This fails conservatively and leaves Blizzard
interaction/navigation untouched. Existing 3/4yd hysteresis applies only
when there is live evidence; ordinary native quest-map markers retain the
original policy. Above 4yd existing provider compass behavior is preserved.

This **does not prove complete 3D navigation** and is not a general
multilevel route solver. A marker for an unselected/unhovered NPC may vanish
at point-blank projected distances instead of falsely indicating the wrong
floor; that is an intentional source-confidence fallback, not a claim of
missing world data. No new timers, polling, quest claim, native Show/Hide,
nameplate, action bar, camera, XP, buff or chat policy changes. Add only
addon-owned Report Bug counters `serviceNearUnverifiedHidden` and
`providerNearUnverifiedHidden`; no native frame readback.

L-035 remains OPEN until the new candidate is tested in Forever on normal
same-floor NPCs and a multi-floor stack. L-002 intermittent native popup
remains OPEN/owner unknown. Session158 #16399 has no recorded NPC flash
at capture and cannot validate/resolve L-002.

## Acceptance and validation

Source-backed fixtures must distinguish live ordinary identity+range from
unverified projected geometry, mismatch, secret, combat/protected refusal;
verify 3yd snap, 3-4yd hold and >=4yd release with live proof, and preserve
native quest/POI/waypoint behavior. Compare existing P0476 contract and all
historical checks before release; candidate/installer and rollback separately.
Forever: on the same floor, target/mouseover/interact with a service NPC
within 3 projected yards and confirm a stable center; at an upstairs or
downstairs unrelated NPC with map 2yd but no matching live proof confirm
there is **no false 2yd focus**, and Report Bug ambiguous count increments.
No travel solely for forced proof. WoW runtime P0477 UNVERIFIED.

## Assistant-side audit

Independent full candidate suite 339/339 STATIC PASS, six checker workers;
actual-source P0476/P0477 Lua fixtures PASS; no static failures observed.
ZIP/installer PREWRITE and POSTWRITE, tamper/refusal and rollback remain
separate release gates. P0476 client visual FAIL remains authoritative;
P0477 client UNVERIFIED.
