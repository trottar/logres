# P0487 — L-030 P0486 quest marker scoped Forever runtime PASS (2026-11-18)

## Authority and evidence

Remote `main` verified at P0486 commit
`2c425251821ea983a033eb6cbf2d4b399eace500`, tree
`2747284339458b651260389f1243023b37860133`.
User supplied `LOGRES_DIAGNOSTICS_LATEST.lua` (514352 bytes) and
`LOGRES_BUG_REPORT_LATEST.zip`, generated 2026-11-18 14:25 Eastern.
Export provenance explicitly reports source, Forever deployment and
capture version `0.0.353-dev` match; no patch/runtime code changes here.
Report Bug screenshot-to-incident pairing is **INFERRED** from file
mtime within 90 seconds; screenshot bytes are included in ZIP.

## Positive runtime scope

- Session170 incidents **17450, 17457, 17470, 17475, 17478, 17480,
  17482**: `questCompassDB.eligibilityQualified=1`,
  `eligibilityFirstQualifiedNPCID=240`,
  `eligibilityFirstQualifiedQuestID=35`,
  `compassNearNPC.dbEligibilityQuestCandidates=1`,
  `availableQuestPoiShown=1`, `dbHistoricalQuestExcluded=7`,
  native `availableQuestNearby=0`/`nativeOfferNearby=0`.
  The quest is admitted through independent player-state eligibility,
  not from native offer corroboration.
- #17450 is prior to NPC dialogue, has available marker1 and focus
  `poi`. #17457 has ordinary greeting, `lastGreetingAvailable=1`;
  #17470 shows Logres `offer-seen` quest ID 35 after native selection.
- User states **"Worked nicely."** Screenshots show the quest marker
  and the quest dialogue. This is **P0486 scoped gameplay PASS** for
  Marshal Dughan (NPC240), **Further Concerns** (quest35).

## Boundaries and prior negative results

- Seven historical candidates were excluded in each recorded instance;
  this is evidence of active filtering, **not** proof that every future,
  completed, mutually exclusive, class/race or conditional quest is
  correctly classified in the live client.
- L-030 remains **PARTIAL** until a different naturally eligible
  quest-giver and explicit future/completed/conditional false-positive
  regression cases receive scoped runtime checks. Do not alter
  P0486 eligibility gates or declare a broad pass from this one NPC.
- P0483 native-only false negative; P0484 missing sparse-field handling;
  P0485 unconditional quest-flags veto; P0486 correction were distinct
  checkpoints. Earlier failures remain recorded in P0483–P0486 evidence.
- L-035 turning/proximity remains user-reported **PARTIAL**; no new
  rotation, proximity, floor or lock test is present in session170.
  L-002 Blizzard transient popup remains independent **OPEN**.
- No Lua/taint assertion of global cleanliness from these quest-only
  captures. No world/combat/PvP/suppression contract validated here.

## Documentation audit negative results

First full source-check run **291/348 FAIL**, all failures from the
historical 9,800-byte CURRENT / 8,000-byte handoff limits or active
checkpoint/handoff mismatch; the draft had P0487 active ahead of
P0486. After compaction and restoring P0486 active, the second run
**343/348 FAIL** because new P0487 chronology was ahead of the P0486
roadmap headings. Moved P0487 below P0486; no checker was weakened.
These are assistant-side documentation failures, not WoW regressions.
After both corrections, full candidate audit **348/348 STATIC PASS**.
Scoped docs applier PREWRITE/POSTWRITE **3/3** each; wrong HEAD,
dirty tree, payload tamper, collision and injected-failure rollback PASS.
No source, runtime, TOC or checker modifications. The final packaged
candidate is re-audited after this validation receipt is recorded.

## Next evidence gate

During ordinary gameplay, sample another currently available quest NPC
before interaction and an NPC with only future/completed quest history.
Capture Report Bug if an incorrect marker is seen. Compare
`eligibilityFirstQualifiedQuestID`, `eligibilityClosestRejectedReason`,
`dbEligibilityQuestCandidates`, `dbHistoricalQuestExcluded`, and
`availableQuestPoiShown`. Preserve secret/unknown fail-open fallback.

## Docs-only checkpoint

P0487 records this verified event in CURRENT, issue ledger, active
investigation, roadmap status, patch index and handoff. No Lua, TOC,
source filter, CVar, polling, protected frame or runtime behavior change;
no WoW redeploy required. GitHub P0487 durability requires user push
and subsequent remote verification; do not infer from this document.
