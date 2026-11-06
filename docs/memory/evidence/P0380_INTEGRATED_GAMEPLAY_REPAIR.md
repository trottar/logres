# P0380 — integrated Forever gameplay repair: evidence and boundaries

Date: 2026-11-06. **Verified remote main:** `285be5281638ecfa9317c615aa2711d1a649556a` (P0379 R2). `P0379_MANIFEST.txt` reports **249 PREWRITE + 249 POSTWRITE static PASS**; this is not runtime acceptance. Live client: **World of Warcraft Forever**, installation `_forever_/Interface/AddOns`, build 1.60.1 / interface 16001. Logres client journal sessions 24 and 25 identify **0.0.264-dev**.

## Actual received artifacts and correlation limits

User supplied `LOGRES_BUG_REPORT_LATEST.zip` and `LOGRES_DIAGNOSTICS_LATEST.lua` containing 12 screenshot JPEGs and Report Bug journal/snapshot data. The screenshot exporter matches by filesystem mtime within 90 seconds; association is **INFERRED**, not a screenshot filename returned by the game. Incidents 2297, 2388, 2399, 2405 were recorded on `0.0.264-dev`. Prior 1321 (0.0.261-dev) shows right-hand tracker clutter; 2130/2141 (0.0.263-dev) show earlier Continue/claim failures. Screenshots are inspected, not treated as authority for protected state.

- **L-002, 2388:** Quest-progress narrative shown while Blizzard retains Continue. No Logres Continue action exists. `Dialogue:HandleQuestProgress()` calls `PresentText(..., false, false, false)`; native progress currently owns Continue. This is a *known missing feature*, not a claim that an implemented Logres Continue handler failed.
- **L-005, 2399 / session 25:** Completion-owned quest 18 and reward choice selected, followed by Report Bug. P0379 trace has `completion-input-enter` and `completion-input-leave` (one each), **zero** `completion-input-down`, `completion-input-up`, `completion-input-dispatch`, `completion-click-result`, and confirmed claim calls. This proves pointer entry into the existing button but does **not** establish the precise blocker: addon-owned parent input setting, a sibling overlay, frame levels, mouse-down routing, or whether the user clicked over the button must be distinguished.
- **L-025 + L-039, 1321:** Right-side quest tracker labels/objective/icons visually collide. Exact owner is not proven by the screenshot. L-025 remains broader map/menu HUD overlap; L-039 isolates the right-side tracker internal collision. Do not casually disable stock quest information until Logres has a safe owner and fallback.
- **L-001/L-033/L-034:** Existing live reports show native gossip coexistence, failed Logres profession purchase, and unexpected quest GUI. The latest quest-only incident does not prove those three root causes or create new transactions. Their issues remain OPEN. Use supported module source and prior evidence, not polling or broad native suppression.
- **Other tracked defects:** L-007/L-008/L-012/L-022/L-023/L-024/L-027/L-028/L-029/L-030/L-031/L-032/L-035/L-036/L-037/L-038 remain open/partial/deferred according to the ledger. These are not silently closed or treated as P0381 successes.

## Design decisions / negative evidence

1. P0379's instrumentation is real and works for Enter/Leave. It does not repair the button. Record user-reported unchanged UI as **FAIL**, not client PASS; no further generic diagnostic-only patch before implementing the evidenced action and geometry candidates.
2. Implement **supported, explicit Logres Continue** only when the quest-progress stage and its native action are valid; do not call the reward-claim API from Continue. Preserve usable Blizzard native fallback and restore native controls before removing or relinquishing Logres interaction.
3. Repair **Complete Quest hit delivery** on the existing addon-owned action button/root; avoid speculative Blizzard child-frame/protected changes. A click without an ordinary, guarded reward transaction is not accepted. Record actual turn-in confirmation or fail open.
4. Pursue a **single NPC interaction surface** by separating gossip/quest progress/quest claim/trainer native owners. Limit each replacement to a capability-gated scope; unknown/cost/secret contexts remain Blizzard-owned. Unexpected presentations must require an intentional lifecycle trigger.
5. Address **HUD/tracker/menu layering** without hiding a stock control surface behind an opaque Logres surface. For L-039 first establish the owner; use owner-specific fit, row bounds, spacing and layer adjustments, with restoration as needed.
6. Keep D-046 preview-first, D-047 Camera/DynamicCam frozen, D-048 current schema-3 domains, sparse target, and native party/aura/pet/vehicle fallbacks. This package performs **no runtime changes** and cannot be WoW-validated as a fix.

## Three-batch workflow

- **Batch 1 — PLAN:** 2026-11-06 conversation: cross-issue triage and source investigation, complete as planning, not patch acceptance.
- **Batch 2 — P0380 MEMORY:** status reconciliation, P0381 roadmap, issue row L-039, aligned active handoff and evidence, stronger ledger checker, checker #250; documentation / static tooling only.
- **Batch 3 — P0381 CODE:** coherent code implementation across quest progress, completion hit geometry, native fail-open, NPC-gossip ownership and tracker/menu presentation as source evidence permits. Full static suite plus concrete client acceptance required; no repeat of 'diagnostics only' as gameplay resolution.

## P0381 test and stop gate

Run in **Forever** after user-controlled commit/push verification and deployment. On a naturally available progress quest, Logres Continue must cause the expected stage transition without losing Blizzard recovery. On a natural reward-choice quest, selected choice must be honored, Complete Quest must receive Down/Up/dispatch and produce confirmed turn-in, or immediately restore usable stock controls. No double claims. On a natural gossip/trainer session, native and Logres windows must not compete and trainer action must work or fail open. With map/menu and tracker, verify no Logres-owned obstruction and no overlapping tracker rows. Each is PASS/FAIL/DEFERRED separately. Lua, taint, secret or protected-action failures stop further replacement validation. No forced travel/quest farming.

Runtime result at P0380: **UNVERIFIED FIX; observed user FAIL persisted on P0379**. No change in quest UI is expected from this docs-only checkpoint.

## P0380 R0 failed applier; R1 docs-only correction

The user ran the P0380 R0 applier against P0379 main; it refused PREWRITE with
`unexpected baseline blob Logres/Quest/ActiveQuest.lua`. No tracked files
were written. The source-file byte mismatch is not a diagnosed gameplay defect;
the exact reason is UNKNOWN. The R0 applier incorrectly treated four unchanged
runtime files as mandatory raw-byte preconditions for a documentation-only
checkpoint. R1 removes all four runtime-source blob guards while retaining the
verified exact Git HEAD, clean tracked working tree, and blob guards over the
**nine changed existing files only**. The full 250-checker shadow suite still
validates runtime contracts and the untouched runtime version. This is an
applier-scope repair, not a client implementation or a claim of static PASS
until the actual WSL PREWRITE/POSTWRITE suite has run.

## P0380 R1 refused PREWRITE; R2 version-policy correction

R1 passed baseline and initial memory-budget guards, then was **REFUSED at 27/250 PREWRITE** by `tools/check_checker_version_policy.py`. The new P0380 contract checker wrongly contained hardcoded historical runtime-version literals. It was an assistant-authored checker defect, **not** a game failure; zero tracked files were written. R2 removes both exact runtime-version references from the checker, validates TOC and Bootstrap parity dynamically, and independently rejects version-pinned checkers before launching the full 250-checker suite. R0's unrelated `ActiveQuest.lua` baseline refusal remains recorded above. P0380 remains docs-only and requires actual WSL 250/250 PREWRITE and POSTWRITE passes before commit.
