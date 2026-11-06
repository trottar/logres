# P0381 — integrated Forever gameplay implementation, candidate evidence

Date: 2026-11-06. Verified GitHub `main`: P0380 R4 `ed11249f4ae798a812c8964bd008dca0016820fe`. This checkpoint is a **code candidate** with targeted static contract #251 and a required full static prewrite/postwrite suite. **WoW Forever runtime UNVERIFIED.** Neither packaging nor static checks close a user-observed gameplay failure.

## Evidence before patch

- L-002 **OPEN**: `0.0.264-dev` incident 2388 displays Blizzard Continue; `Quest/Dialogue.lua` showed `QUEST_PROGRESS` narrative but had no replacement Continue. The correct transition is the native progress `QuestProgressCompleteButton_OnClick()` handler, **not** a reward claim. Progress may be incomplete/secret or native progress controls unavailable; these cases remain native-owned.
- L-005 **PARTIAL / user FAIL**: incident 2399 displayed the existing Logres Complete Quest control and recorded only Enter/Leave, not Down/Up, dispatch, or a successful claim. Specific hit blocker remains unproven; this code changes only the addon-owned original button interaction level and mouse readiness. L-005 requires actual event+turn-in proof, not just native-handler-invoked.
- L-001 **OPEN / user FAIL**: source-supported possible duplicate window: `NPCGossipPresentation.TryShow` displayed Logres read-only gossip before `TryPark` and retained that window even if parking was refused. P0321 restricts parking to full and protected-safe native coverage. The corrective fallback now removes Logres's additive window when it cannot park native gossip; it never disables stock controls.
- L-033 trainer Train fails in live report, but the actual BuyTrainerService denial reason is UNKNOWN. P0373 already implements native restoration on denied physical click. Its transaction gate is not relaxed without new evidence; purchase outcome remains OPEN.
- L-034 unexpected quest GUI: specific visual owner in incident 764 UNKNOWN. Existing addon root show/hide diagnostic preserved; no blind auto-hiding native frames.
- L-025 map/menu overlay, L-029 health-tunnel label layering and L-039 right-side tracker text/icon collision remain PARTIAL/OPEN because screenshot 1321 does not establish which window owns the offending rows/icons. Native quest information is not suppressed. L-038 hover comparison is present source-side, live UNVERIFIED.

## Change and safety contract

1. `QuestDialogue` owns a Logres Continue only when an ordinary quest ID, native progress panel and enabled native Continue, `IsQuestCompletable`, and out-of-combat are confirmed. It captures and suppresses native QuestFrame's mouse subtree/alpha through the existing guarded adapter, rejecting any unknown/protected descendant. Progress click rechecks readiness, restores **all native input and alpha first**, dismisses Logres and calls Blizzard's `QuestProgressCompleteButton_OnClick()` once. Source event `QUEST_COMPLETE`, not a successful call return, establishes transition. Unsupported or unsafe cases show only Blizzard controls.
2. The existing shared Accept/Complete button remains physically the same object. In completion-owned state only, its action root is raised above Logres reward/option sibling visuals and mouse readiness is explicitly enabled. The original Up-click dispatch, P0379 input hooks, reward ordinal checks, native handler and restoration remain intact. Do not diagnose this as the confirmed incident-2399 root cause until retested.
3. Gossip parking commits Logres read-only ownership only after successful guarded native parking. On denied parking it hides Logres, disarms pending retry, retains Blizzard and traces `gossip:stock-owned` with an addon-authored reason. No polling, blanket suppression or new NPC transaction.
4. Runtime revision is `0.0.265-dev`, both Bootstrap and TOC. No saved-variable schema, camera, pet, native group, secret/protected, or quest reward changes. No forced travel or contrived quest completion for proof.

## Acceptance and remaining blockers

Test in `_forever_/Interface/AddOns` only. On a naturally available completable progress quest, expect Logres Continue; pressing once should restore native input and advance to `QUEST_COMPLETE`. On a naturally available reward-choice quest, select a card, press Complete Quest once, confirm `completion-input-down/up/dispatch`, `completion-click-result`, and a matching `QUEST_TURNED_IN` or clear native fallback. Test gossip with both eligible and unsupported stages: one usable window, native restored on Goodbye/choice/immersion OFF. Check ordinary map/menu and quest tracker overlap in the same context; do not call UNKNOWN owner PASS. Test profession Train only if naturally available; otherwise DEFERRED. Confirm no Lua, taint, secret-value or protected-action errors. Report independently PASS, FAIL, DEFERRED or OPEN/UNREPRODUCED. Any client failure requires a narrow corrective checkpoint; do not suppress stock to conceal it.

The last observed runtime outcomes remain: **L-002 OPEN; L-005 PARTIAL/FAIL; L-001 OPEN; L-025/L-029 PARTIAL; L-033/L-034/L-038/L-039 OPEN**. Static candidate result requires actual WSL applier execution; no live result yet.

## P0381 R0 refusal and R2 contract reconciliation

The original P0381 R0 **REFUSED PREWRITE at 77/251** on P0241 due to a direct
`pcall(CompleteQuest)` call in the dialogue source; zero tracked writes. R2
removes this direct quest mutation. Its guarded Continue uses the Blizzard
progress handler and restores native UI first. The historical P0379 checker
expected a completely stock-owned progress presentation; P0380
explicitly authorized a Logres Continue replacement. R2 changes that checker
to require the guarded native handoff without removing its direct-mutation
ban. Full static candidate validation is REQUIRED and not claimed here.

## P0381 R2 PREWRITE refusal and R3 correction (2026-11-06)

R2 verified the ZIP SHA-256, extracted and passed the baseline, anchors, budgets,
and first 216 of 251 static checkers. It **REFUSED PREWRITE at 217/251** on
`check_p0381_integrated_gameplay_contract.py`; zero tracked files were written.
The R2 checker compared a global first occurrence of `active = true`, which
matched the module-level `local enabled, pending, active = true, false, false`
declaration before `Live.TryShow`. That declaration is not a gossip ownership
commit. The generated `TryShow` actually places `if not parked then` and its
stock fallback before `active = true; opens = opens + 1`. This was a checker
scope defect, not a client observation or proof of correct gameplay.

R3 scopes the ownership ordering assertion strictly to `function Live.TryShow`
and tests the exact consecutive `active = true` / `opens = opens + 1` statements,
requiring native parking and fail-open before the success branch. It does not
remove any existing native-safety assertion. A targeted regression fixture
includes the declaration that caused the false match, and a negative fixture
reorders the success assignment to ensure the corrected checker refuses it.
The full 251 PREWRITE/POSTWRITE static runs remain mandatory. R3 client
runtime is UNVERIFIED, including L-001, L-002, and L-005.

## R3 assistant-side pre-handoff scope

The R3 release ZIP was expanded in an isolated test and its genuine new
`tools/check_p0381_integrated_gameplay_contract.py` executed against a
source-fragment candidate that deliberately retained the module-level
`active = true` declaration. It **PASSed**; a second run with the success
assignment moved before `if not parked then` **REFUSED** as expected.
An isolated, generated Git test worktree exercised the actual packaged
`P0381_R3_APPLY.py` baseline/anchor/16-file preparation, candidate
whitespace checks, manifest, and postwrite rollback under injected static-suite
callbacks. Both success and rollback assertions passed with a clean tracked
baseline restored on failure. Those injected callbacks **do not** execute the
250 historical checkers. R2's user-side PREWRITE completed 216 tests and
failed at #217; all 251 real checkers are still REQUIRED on the R3 exact
prepared candidate in the user's WSL repository before tracked writes.
No WoW PASS or complete static PASS has been claimed in this record.

## P0381 R3 PREWRITE refusal / R4 reconciliation (2026-11-06)

The user verified and extracted P0381 R3; its guarded applier passed baseline,
anchors, memory budgets, and 216 static checkers, then **REFUSED PREWRITE at
217/251** on `check_p0381_integrated_gameplay_contract.py`. The candidate
patch record omitted uppercase `UNVERIFIED`, a marker the assistant's new checker
required. No tracked files were written, and no manifest was created. R3's
assistant-side fixture had substituted `P0381 UNVERIFIED L-005` for the actual
packaged record and therefore falsely passed. This was an assistant handoff/test
construction error, NOT a WoW or WSL error. **R4** uses the actual evidence
and patch-record payloads in its checker fixture, checks every remaining new
checker assertion, and requires the unchanged all-checker PREWRITE/POSTWRITE
gate. L-001/L-002 OPEN, L-005 PARTIAL/FAIL; runtime remains UNVERIFIED.

Prior successful handoffs retained: baseline/hash gates, prewrite static check
before mutation, transactional postwrite validation, `git diff --check`,
manifest, user-controlled commit/push, then verified GitHub `main` and explicit
Forever deployment/runtime test. This iteration must not substitute invented
records for prepared candidate output.
