# P0373 — Explicit trainer fail-open and quest completion diagnostic seam

Date: 2026-11-05. Baseline P0372 `39f404c0a918a65f297ecd886e5c4f8b9cac53e4`, 242/242 STATIC, 0.0.259-dev. Proposed 0.0.260-dev, 243 checker total. **PREPARED; STATIC and WoW UNVERIFIED until local execution**. User owns commit/push. Avoid installation until latest requested P0372 natural gameplay report has been exported.

## Code / safety boundaries

- Trainer purchase code: preserve explicit selection, native identity, cost, protected/combat checks and one-shot `BuyTrainerService`; on denied user Train click, log source reason, restore native trainer through existing `Trial.Disable` and mark session dismissed so no automatic reopening; print user-visible reason. A successful native call remains request-sent/unconfirmed, not proof that service was learned. Do not alter class Train All, service masks, filters, or scanner.
- Quest completion: record addon-owned `QUEST_COMPLETE` source/render/controller gate and explicit claim result, without forcing hidden Blizzard reward UI for unsupported choice, payment or unknown protected states. Existing completion handler and all fallback semantics remain.
- Incident captures: include read-only trainer and completion controller counters, not Blizzard frame state. Bounded journal capacity and screenshot logic unchanged.

## Evidence and failure discipline

User live defects: L-033 trainer Train unusable without Blizzard fallback and native quest turn-in UI surfaced; P0372 passive diagnostics did not capture trainer guard or completion view gate. Source supports a missing fail-open action and causal logging, not a proven particular trainer rejection or safe blanket completion suppression. Native recipe toasts are a separate L-027 concern. Preserve P0372 R0–R3 static refusals, P0371 historical refusals, unresolved L-001/L-002/L-005 and L-019 BLOCKED. All new runtime mutations require client validation; no WoW PASS claimed.

## Acceptance

Guard exact P0372 SHA, clean git tracked state, nine pinned blobs, unique anchors; compare canonical baseline vs candidate P/L/D markers. Run dynamic checker policy, new direct checker, all 243 PREWRITE shadow checks, then transactional write and all 243 POSTWRITE checks, `git diff --check`; create `P0373_MANIFEST.txt`. Reject and preserve worktree on PREWRITE failure, restore on POSTWRITE failure. After commit/push verify main before runtime deployment; explicit Forever client deployment and natural trainer/quest test only. All source code is assistant-authored. No commits or pushes from applier.

## P0373 R0 prewrite refusal and R1 repair (2026-11-05)

User verified the R0 ZIP SHA-256 and ran its guarded applier against clean P0372 main. The applier passed pinned baseline/source checks but refused **before shadow checks and before tracked writes**: `docs/memory/CURRENT.md: lost baseline memory IDs: ['P0371']`. This is an assistant-caused candidate-memory rewrite failure, not a WoW runtime result. R0 was NOT committed or deployed. R1 restores the `P0371` milestone and the `L-033` issue marker in CURRENT, ahead of full static checks; new positive assertions guard these specific markers. All baseline P/L/D identifiers remain required and no old refusal is erased.

A second P0372 0.0.259-dev export was supplied concurrently (Forever 1.60.1 build 70790, loadCount 22). Journal now reports session 3, sequence 385, 384 stored events and `dropped=1` due to its 384-entry ring buffer. The seven prior Report Bug incident IDs (83, 171, 173, 197, 200, 204, 252) remain with `screenshot=succeeded`. New quest 91741 has the sequence `offer-seen` -> `action-call` -> `action-started` -> `accepted` with `result=event-confirmed`. No later incident or trainer/quest completion ownership decision was recorded. This does NOT establish the cause or fix for the trainer transaction or Blizzard quest turn-in popup; L-033 and L-002/L-005 remain OPEN. The journal drop is a bounded-capacity event, not evidence of a runtime crash.

R1 PREWRITE/POSTWRITE 243-checker suite and WoW remain **UNVERIFIED** until executed in the full WSL repo and in client. Do not claim PASS from this archive's syntax/contract inspection.

## P0373 R1 prewrite refusal and R2 regression repair (2026-11-05)

User verified P0373 R1 archive SHA-256 `2a0e8a43019f72e6de94f43be5cea7a50b9183072b38bd3818873b332b3fd807`, ran its applier on clean P0372, and reached PREWRITE `133/243 REFUSED check_p0296_trainer_scroll_train_contract.py`: `ERROR: missing live slider or explicit train gate: or not browse.localChoiceConfirmed`. **This is an assistant-produced regression in a historical static contract**, not a WoW runtime defect. The R1 train-click refactor replaced the original compound eligibility condition with a separately reported `if not browse.localChoiceConfirmed ...` branch; although the readiness check remained logically present, the historical P0296 checker also requires the literal `or not browse.localChoiceConfirmed` in source. The applier refused before tracked writes; no manifest, commit or WoW deployment.

R2 restores the exact guard token in the active Train-button readiness branch as `if not browse or not browse.localChoiceConfirmed` followed by `or not browse.model.trainEnabled then` without bypassing the new denial report. The explicit click cannot reach a purchase unless the same local selection and availability gates pass. The applier rejects missing P0296 anchors before building shadow and runs P0296/P0309/P0314/P0251/P0372 historical checkers as targeted dependency prechecks before the complete 243-check PREWRITE suite. R2 updates its own contract to verify the exact historical guard. All reported R0/R1 failures remain OPEN negative patch history; this corrective artifact is **STATIC FULL-SUITE UNVERIFIED and WOW UNVERIFIED** until the user's WSL test.
