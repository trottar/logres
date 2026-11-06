# P0378 — bundle Report Bug screenshots with live diagnostics (2026-11-05)

## Trigger and confirmed defect

P0377 `0.0.263-dev` live user report: reward item selection worked, but the Logres Complete Quest action did not work; Blizzard Continue/quest UI still appeared without the intended Logres alternative. The uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` contains session 20 quest 18 `completion-owned` sequence 1956 and `completion-choice-selected` sequences 1957 and 1960; Report Bug incidents **1947** (`QUEST_PROGRESS`) and **1958** (following reward selection) recorded `screenshot-succeeded`. No `completion-click-result` or `completion-click-deferred` event appears in that bounded session between choice and `goodbye`. **This does not prove the actual button was clicked**; visible geometry and click hit-testing require the screenshot. Quest 18 later has `QUEST_FINISHED` native events, not positive evidence that the Logres Complete Quest button succeeded. L-005 stays PARTIAL/FAIL; L-002 OPEN.

The screenshot itself was NOT inside that uploaded Lua file. `Logres/Dev/Panel.lua` calls the native `Screenshot()` and records the succeeded event, but cannot obtain the image bytes or chosen file name. The prior `tools/export_panel_diagnostics.py` copied only Forever SavedVariables, so it could never give the assistant screenshot pixels. This is an L-020 evidence collection gap and should have been recognized before relying on screenshots for bug triage.

## P0378 scope, method and uncertainty

- **Tooling only; no WoW runtime, quest, camera, protected-frame, or client addon change.** No WoW redeploy or reload required to use the updated script against an already saved session.
- Preserve the P0369 live-only SavedVariables source and atomic `LOGRES_DIAGNOSTICS_LATEST.lua` export. Existing `export()` callers and no-source refusal behavior remain unchanged.
- Running `python3 tools/export_panel_diagnostics.py` also produces `LOGRES_BUG_REPORT_LATEST.zip` next to the Lua copy. The ZIP contains the byte-for-byte diagnostic data, `BUG_REPORT.json`, `README.txt`, and actual screenshot image bytes under `screenshots/` when matched.
- Only files named `WoWScrnShot_*` with recognized image extensions, ordinary files inside `_forever_/Screenshots`, and a modification timestamp within **90 seconds** of a successful incident are eligible. One image is assigned to at most one incident; at most the 12 retained incident records are considered. Correspondence is **inferred** from filesystem mtime, never asserted as an exact screenshot ID. The manifest includes incident IDs, delta seconds and missing-image warnings. Never collect uncorrelated screenshots.
- Parse the bounded top-level incident scalars without executing Lua, ignoring nested snapshot/context keys. Safely refuse a truncated incident table; older diagnostics without an incident journal still yield a diagnostic-only ZIP with warnings.
- Generate the bundle atomically. The ZIP is the single file to upload. It can contain screenshots and game diagnostics, so the user should review it before sharing publicly.

## Evidence / test gates

- Synthetic local fixtures test two matched images, cross-incident assignment, nested snapshots, unrelated images outside the time window, missing images, stale beta/no-live refusal, byte-for-byte original diagnostic payload, and real ZIP member bytes.
- The uploaded November 5 diagnostics parse into 12 retained incidents, including P0377 IDs 1947 and 1958. **Actual screenshots were not uploaded**; screenshot matching in a real WoW directory and P0377 quest completion remain **UNVERIFIED**.
- P0378 is not a fix for L-002 or L-005. Continue to preserve native Blizzard fallback until an in-game remedy is independently validated. No issue is closed by static export tests.
