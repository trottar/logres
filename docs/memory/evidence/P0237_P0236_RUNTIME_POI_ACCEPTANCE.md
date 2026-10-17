# P0237 — P0236 broad compass POI runtime acceptance and deferred polish

Date: 2026-10-17. GitHub `main` verified at P0236 `e6179b8` after user push. Evidence source: user-uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` with `loadCount=311`, `Logres 0.0.139-dev` on Forever 1.60.1, and user's in-world assessment that the broad POI display is working nicely; some visual refinement can be integrated with remaining UI polish rather than done now.

## Observed source and presentation state — PASS within sampled location

- `compass nearby: provider=ready candidates=2 shown=2` on a final Compass Check, and `compass services: provider=ready candidates=4 shown=4`.
- `compass POI proximity: sized=6 scaleMin=0.83657693799736 scaleMax=1.1873768549506`. Earlier same load saw 5 sized with 0.74382100884009 to 1.0527797777068. This is real variation in addon-owned glyph size; precise visual aesthetics and all distance conditions remain outside this sample.
- `compasscheck: PASS` for heading/policy/event/update; no explicit errors in the printed panel lines. **No full WoW Lua/taint/protected error log was supplied**, so no blanket error-free-world claim.
- `questiedbnearby: index=ready map=1432 area=38 scanned=13392 ids=13392 zoneNPCs=153 questNPCs=30 spawns=34 nearby=3 radius=50 truncated=false` (last location-probe snapshot); QuestieDB v1.0.6 Forever baked contract-compatible.
- `questiedbservices: capability=ready enabled=true cached=31 flight=1 inn=1 repair=8 nearby=9 truncated=false`; `questiedbservicecoverage: supportedKinds=13 nearbyKinds=5`. The code offers up to sixteen named role mappings but **only thirteen were available in this provider runtime**. Nine means candidate historical service spawn matches within fifty yards, not necessarily nine distinct visible NPCs or markers.
- The user's report that broader categories look good is **visual acceptance of this iteration**, not evidence of completeness across all maps or NPCs. The screenshot-less diagnostic does not identify individual NPCs or every category rendered while walking.
- The `questiedbprobe` gossip/quest availability result remains `DEFERRED` (`gossip=not-observed`, `map=unvalidated-map-or-stale-gossip`), separate from the compass POI PASS. Historical `questStarts` NPCs still appear when no current quest is offered; this is an OPEN relevance issue, not accepted current-quest eligibility.

## Decision and next work

Accept **P0236 as the working Phase H.3 nearby POI baseline**, with 50-yard provider candidate bound, category/role identity, native source priority, manual/focused quest bearing preservation, and optional QuestieDB contract gating unchanged. Do **not** immediately begin a compass-only follow-up patch; the user explicitly requests refinement together with remaining UI polish.

Defer: historical quest-giver false positives, user-configurable category filters, service priorities and crowding, marker color/tint and scaling aesthetics, and comprehensive category/map coverage. No suppression, radius widening, or guessed live minimap coordinates based on this evidence. Return to the broader approved Phase H integration/polish backlog for the next separate work item. P0230 negative map-resolution evidence and unrelated deferred gossip remain retained.

**Patch type:** documentation/evidence only; no runtime change, no WoW redeploy.

## P0237 R0 pre-write packaging failure; R1 repair

The initial P0237 apply attempt **FAILED before tracked writes** with
`P0237 APPLY FAIL: P0237_MANIFEST.txt: invalid EOF`. The original
applier appended a blank final item to its manifest lines and then added
a final newline, yielding two trailing newlines; its own `check_hygiene`
correctly rejected the manifest. The user-reported `git status --short`
showed only the same three untracked PNG artwork previews and no tracked
changes. This was an assistant-generated artifact defect, **not** a WoW
runtime failure. R1 removes the extra empty list item, retains the
pre-write manifest check and exact pushed-P0236 baseline guards, and
records this failure. Do not reuse the original R0 ZIP.
