# P0503 — NPC interaction handoff and transient native frame audit (2026-11-21)

## Authority, input, and classification

Baseline main P0502 `07f98c56acba726af3ccf5c4a1e00c080372e046`, tracked source `0.0.368-dev`. In Forever session189 (`0.0.368-dev`), user reports P0502 camera pacing/continuity "works really nice" (scoped gameplay PASS; different-NPC and interruption tests not independently established). User reports a very brief Blizzard window **before** Report Bug screenshot; it could not be caught as pixels. The bundle `LOGRES_BUG_REPORT_LATEST.zip` has incident20401 at 2026-11-21 11:33:17 -05:00, screenshot `WoWScrnShot_112126_113317.jpg`, native Logres trainer visible at capture, not the transient native window. No frame identity is inferred from its pixels.

Journal, session189: #20389–20394 11:33:13 native gossip interactionType3, Logres `npc-options-read-only` and gossip park; #20395–20398 11:33:14 `native-choice-handoff` restores offscreen native GossipFrame anchors **before** the selected native option and dismisses Logres; #20399 `GOSSIP_CLOSED` 0.174 seconds afterward; #20400 interactionType7 (class trainer) at the same time. Incident #20401 at 11:33:17 shows the Logres trainer. This makes the pre-selection root restoration a concrete source-supported **exposure window**, not proof of a specific flashed Blizzard frame. Existing L-001 (gossip single-window) is the correct issue identity; L-002 quest claim flashes remain separate.

## NPC ownership matrix (audit scope)

| Route | Current native ownership / Logres gate | Outcome of P0503 |
|---|---|---|
| Gossip options → trainer or another service | `NPCGossipPresentation` + `NPCGossipStockParking` show Logres and park unprotected whole GossipFrame; `NPCGossipChoice.Activate` validates fresh native identity and direct click. Formerly restores stock **before** selection, matching journal #20395 | Change only validated gossip option selections: one 0.8s event-bounded parked handoff; next service frame-show or new gossip stage ends it; timeout/selection exception/OFF return stock. Client UNVERIFIED |
| Gossip options → nested gossip | Same safe native `SelectOption`, next `GOSSIP_SHOW` replaces Logres stage if validated | New stage cancels old ticket, reuses existing stock parking; unsupported next stage returns full native window. Client UNVERIFIED |
| Quest link in gossip / QuestFrame multiquest greeting | `NPCGossipQuestChoice` and `QuestGreetingControl` restore original native quest controls before selection | UNCHANGED native restore-first; preselection quest-only transient remains possible; retain L-001/L-002 where applicable, no proven incident here |
| Quest offer, progress, completion, reward claim | `Dialogue` and `CompletionControl` require independent native handler / stock restoration, protected/secret checks, fail-open; P0501 union bridge restricted to same quest | UNCHANGED. L-002 and L-005 remain OPEN/PARTIAL. Do not suppress native claim/Continue without replacement |
| Class trainer / profession trainer | `NPCServiceNativeParking` capability-gates only verified unprotected trainer root; `TrainerLiveTrial` uses native transactions; profession gate independent | UNCHANGED. New gossip handoff stops at native service show. Training controls and unavailable native fallback preserved |
| Merchant and buyback | Native merchant transactions/pages embedded or styled in Logres, not universally parked | UNCHANGED; native purchase, buyback, quantity and fallback retained |
| Flight master | Native taxi map and route/fare controls embedded or stock fail-open | UNCHANGED; no preemptive suppression or forced route selection |
| Guild registrar | Separately authorized native guild registrar root parking for Logres option adapter; native form restored for actual transaction | UNCHANGED; native protected form/confirm remains available |
| Other/unsupported NPCs | Stock owner retained if Logres cannot prove full source/actions/parking | UNCHANGED; no universal hook, no native frame hiding, no polling |

## Implementation and safety

- Native GossipFrame remains `IsShown == true` but its **unprotected whole root** stays offscreen only when Logres already owns its complete, actionable gossip list and direct click is validated against fresh ordinary source, native SelectOption is available, combat is excluded, and a one-shot 0.8s fallback can be armed. No new secret, frame-position inspection, Blizzard action mutation, click region, alpha, or periodic driver is introduced. All unrelated quest and unsupported calls keep the prior `RequestExit` restore-first path.
- The option is invoked once through its existing user-click API. Synchronous new `GOSSIP_SHOW` re-enters Logres without stale selection dismissing it; ordinary new `PLAYER_INTERACTION_MANAGER_FRAME_SHOW` for a non-gossip type returns stock before exiting the old Logres overlay. A native selector exception immediately restores stock; missing timer/capability falls back to restore-before-call. The one-shot expiry restores stock when no successor appears. Combat-locked restore remains handled by existing `PLAYER_REGEN_ENABLED` fail-open recovery.
- `GOSSIP_CLOSED` alone no longer restores the parked native root in the one narrow held interval; it can precede the next service by an event gap, exactly as in this incident. Old Logres presentation remains during that interval. External dialogue exit cancels the hold before ordinary guarded restoration. A timed-out native option may leave old Logres for at most the bound; the native fallback is then returned.
- P0502 camera motion and visit-continuity code untouched. DynamicCam coexistence, stock claim handoff, trainer/merchant/flight/registrar implementations unchanged.


### P0503 R0 release packaging refusal (2026-11-21; not a runtime test)

The first P0503 Chat author-receipt ZIP passed the user's SHA-256 verification,
but `P0503_APPLY.py` immediately returned `REFUSED: Author receipt does not
match the local tree, candidate ZIP or checker count.` The user supplied the
traceback; there is no evidence of a source write. Reinspection found that the
assistant-reconstructed P0502 author kit used to certify R0 omitted the tracked
`P0502_MANIFEST.txt` (GitHub main confirms blob
`0e68de8b54590179918d05dbe8742714d13db5b2`). Thus its archive hash did
not represent the actual P0502 checkout. The author receipt correctly refused;
R0 is **REFUSED / NOT APPLIED**, not a behavior or client result.

**R1 remedy:** use the repository's independent canonical
`build_patch_zip.py` guarded payload route, assembled from the reconstructed
P0502 source plus the verified tracked P0502 manifest. Keep the exact P0503
source behavior and version; ship an ordinary one-time guarded applier, not a
Chat author receipt and not `--local-preflight`. Its apply-time baseline HEAD,
modified-file hashes, full PREWRITE/POSTWRITE checker suite and rollback remain
mandatory. R1 static shadow PASS is not a user apply or WoW runtime PASS.

## Tests / negative results / next runtime gate

The preexisting P0318/P0319/P0321 string contracts originally required a zero-argument presenter action. Those contracts are updated to assert the *two distinct routes* instead of relying on the pre-P0503 signature; their substantive source-revalidation, park/restore, and quest fallback gates are retained. The first new behavioral fixture exposed a candidate defect: fallback `RequestExit`'s second return value was mistaken for a handoff ticket, leaving Logres displayed after restoration; corrected to return `(restored, nil)` and reran all scenarios. The fixture's first no-timer mock incorrectly required stock to stay parked even on fail-open restore; corrected the fixture expectation, no runtime alteration. These were local pre-release failures, not WoW results.

Actual-source Lua test covers: service after GOSSIP_CLOSED, bounded timeout, synchronous new gossip stage, failed native SelectOption, unavailable scheduler, original quest restore-first, and explicit immersion/owner exit. Assistant exact-source candidate audit: 364/364 historical Python checkers PASS (including independent P0503 Lua fixture and existing Lua 5.4 fixtures via installed liblua5.4); no checker output reported an interpreter skip. Full package author audit, transaction/receipt guards and any skipped checks must be reported separately. No client PASS. **P0503 client UNVERIFIED; L-001 OPEN.**

Client validation: first gossip choice to trainer, optionally a second native gossip/service, consecutive quests, purchase/Goodbye, and Immersion OFF. Confirm no transient Blizzard gossip window, functional trainer purchase and stock fallback with no protected-action/taint error. Use Report Bug to capture any failure; pixel flash visibility is not needed for event correlation. Do not mark L-001 resolved based on the static fixture or a single trainer interaction.
