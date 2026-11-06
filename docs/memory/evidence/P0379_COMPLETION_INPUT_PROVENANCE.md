# P0379 — L-005 completion input provenance; L-002 native Continue gap

Date: 2026-11-06. Verified GitHub main baseline P0378 `4ffbe3ba44749243a90acc49051377cd9fd3e242`, 248 static contracts, runtime `0.0.263-dev`.

## Incoming live evidence (NOT resolution)

The November 5 `LOGRES_BUG_REPORT_LATEST.zip` contains the actual twelve screenshot image bytes; all twelve retained incident IDs (969, 1081, 1083, 1085, 1321, 1416, 1418, 1721, 1947, 1958, 2130, 2141) have one inferred mtime match each, none missing. Inferred association is not a client-confirmed filename binding; 90-second exporter policy remains in force.

- Incident **2130**, screenshot `WoWScrnShot_110526_225151.jpg`: native Blizzard progress panel with Continue and Cancel remains on the left, while Logres narrative panel shows quest text without a Logres Continue control. L-002 confirmed visual gap, still OPEN. Source `Quest/Dialogue.lua` explicitly says Blizzard owns Continue, and its `HandleQuestProgress()` calls `PresentText()` with `showOfferActions=false`; this is not a currently broken Logres Continue handler.
- Incident **2141**, screenshot `WoWScrnShot_110526_225156.jpg`: five Logres reward cards; Militia Dagger selected; Complete Quest label visibly painted near bottom. The journal in session 22 has choice event 2140 and no `completion-click-result`, `completion-click-deferred`, or `completion-choice-required` event before goodbye; controller snapshot reports `clickCount=0` and `claimCalls=0` at this incident. L-005 input delivery is suspect, but no hit-test owner or root cause is proved by a static screenshot.
- Incident **1958** is a second runtime reward-selection screenshot, similarly absent positive claim dispatch. Neither `QUEST_FINISHED` nor native-handler-invoked alone proves a reward was granted.
- This confirms L-020 real image bundle works **in the scope of this upload** (not exact screenshot-to-incident identity or every environment).

## Narrow diagnostic hypothesis

Either (a) pointer never reaches the existing Logres Complete Quest button, (b) it enters/down/up but does not fire OnClick, or (c) click dispatches and is rejected before claim. P0377 journal only includes case (c) when controller `Click()` runs. Missing button input-chain telemetry is the specific gap. No blanket suppression, native frame read, protected ownership claim, or speculative UI layering change is warranted yet.

## Candidate implementation

- Add `RecordCompletionInput(phase)` called **before** the existing shared visual click dispatcher and additive `HookScript` observers on **only the existing Accept/Complete button** for Enter, Leave, MouseDown, MouseUp. Record only during live `completionActive`, never preview/offer. No handler replacement, new interaction button, `OnUpdate`, polling, or secure/native state probing.
- Add `CompletionInputStatus()` with cumulative per-session counts, last phase, and **guarded addon-owned** button/action-root visible/shown/mouse-enabled/bounds/frame-level getters. Every potentially secret-capable method result is classified with `pcall(issecretvalue, value)` before type, comparison, formatting, or use. No native frame geometry inspected.
- Include this limited status in the existing `Report Bug` incident snapshot. It will distinguish no-enter/no-down, event-but-no-click, dispatch-without-controller and stock fallback. The screenshot exporter remains unchanged.
- Keep `Quest/CompletionControl.lua`, Blizzard Continue and native reward handler unchanged. TOC/Bootstrap bump to `0.0.264-dev` for clean client attribution. Add static checker #249 and synchronized memory/issue ledger.

## Runtime validation gate

On a natural non-quest-237 multi-choice quest, select one reward, hover over **Complete Quest**, press and release it once, use **Report Bug before Goodbye**, then if necessary use Blizzard stock controls to complete. Check `completionInput.enterCount`, `.downCount`, `.upCount`, `.dispatchCount`, `.lastInput`, `.buttonShown`, `.buttonVisible`, `.buttonMouseEnabled`, `.buttonLeft/.buttonRight/.buttonTop/.buttonBottom`, `.buttonLevel`, `.actionRootShown`, `.actionRootMouseEnabled`, and the bounded journal `quest:completion-input-*`, `completion-click-*`, and optional `turnin-event`. Take a second Report Bug in a naturally observed quest progress/Continue screen as available; do not deliberately manufacture progress or complete quest 237.

After `/reload` (or game exit to flush SavedVariables), run `python3 tools/export_panel_diagnostics.py` and upload `LOGRES_BUG_REPORT_LATEST.zip`. If the input trace never occurs despite cursor over painted action, investigate hit-testing or competing addon-owned overlays in a subsequent evidence-gated fix. If click dispatches, correlate guard/transaction reason before changing handler. If testing unavailable, outcome is DEFERRED. Do not count no-error or static PASS as client success.

## Disposition

L-005 PARTIAL / user FAIL; L-002 OPEN; L-020 PARTIAL (uploaded screenshot bundle scope PASS). No WoW runtime PASS, no gameplay fix claim. Native fallback intentionally preserved. Explicitly do not change Blizzard Continue until a separate safe ownership/click path is established. Unrelated known issues L-001/L-033/L-034 and L-019 release block remain unchanged.

## P0379 R1 correction (2026-11-06)

P0379 R0 was refused at 129/249 PREWRITE by `check_p0292_trainer_information_contract.py`: `CURRENT over 10KB soft target`. The proposed R0 `CURRENT.md` reached approximately 10,521 bytes (9,780-byte baseline). Its transactional shadow validation correctly produced **zero tracked writes**. The refusal is real repository knowledge, not PASS or a client outcome.

R1 replaces the verbose new CURRENT status with concise current work/action/verification and folds two redundant historical summary lines into the already-linked patch index/evidence trail, preserving referenced IDs and outstanding statuses. An explicit UTF-8 `CURRENT.md` <10000-byte guard runs before the shadow checker suite. No quest control logic changes from R0. R1 requires the full 249 PREWRITE/POSTWRITE checkers in WSL, and WoW evidence remains UNVERIFIED until actual play.

## P0379 R2 correction — second failed candidate and comprehensive guard (2026-11-06)

R1 was **REFUSED at 191/249 PREWRITE** by `check_p0354_hud_diagnostic_seam_contract.py`: `CURRENT_HANDOFF.md` exceeded the historical 8,000-byte constraint. Baseline handoff is 7,991 **UTF-8 bytes** (7,975 codepoints); R1 prepended 410 bytes, reaching approximately 8,401 bytes. No tracked files were written. R0 (129/249, `CURRENT.md` over 10 KB) also remains REFUSED; neither is a gameplay PASS or a quest-code defect.

R2 preserves the same Logres-only input probes and native claim path as R0/R1. Corrective scope: compact historical repeated `CURRENT.md` summaries and three repeated `CURRENT_HANDOFF.md` sections; **archive their exact original text** in `docs/memory/handoffs/P0379_ACTIVE_MEMORY_COMPACTION_ARCHIVE.md`. All historical milestone markers and failure signals remain in the live handoff, with original evidence in the issue ledger and archive. `CURRENT.md` must stay **<9800 UTF-8 bytes** and handoff **<8000 UTF-8 bytes**, enforced explicitly before the first checker and again by the P0379 checker. Candidate must still pass all 249 PREWRITE and all 249 POSTWRITE static checkers in WSL, followed by `git diff --check`, before any commit. WoW input validation and quest action success remain **UNVERIFIED**; L-005 PARTIAL/FAIL and L-002 OPEN.
