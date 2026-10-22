# P0295 — Trainer local row input priority repair evidence

Date: 2026-10-22. Baseline: GitHub `main` P0294 `4380239429887a3bb37798f58dbef1b21a7bfcb6` (`0.0.195-dev`). **PREPARED; WSL and WoW verification pending.**

## Observed runtime failure

User provided two in-client screenshots at Briarthorn. With `All sampled`, 64 sampled services appear in Logres, seven at once; with `Available only`, five source-classified available services appear. User confirms local filter toggle and wheel scrolling function. **P0294 local skill clicking does not work**: no row selection/detail update from clicking Logres spells. The initial selected detail reflects Blizzard's selected source and is not evidence of Logres input success. Source-backed names, icons, statuses, requirements, costs and descriptions remain visible. These observations supersede P0294's earlier *prepared / runtime unverified* status for only the actually tested cases. Scrolling beyond seven is user-reported working; no specific scroll-offset screenshot establishes each position.

`Visible services` at left is an inert live category placeholder, not an actual grouped source or selectable mode. This is **OPEN PRESENTATION DEBT**, not a native filter or categorization capability. No arbitrary category source is inferred. Preserve accepted P fixture design; defer category redesign until source capability is established or user explicitly approves a live-only layout adjustment.

## Narrow cause hypothesis and repair

P0294 creates a full-list `wheel` frame and then creates seven `hit` frames as independent siblings under `root`. Each frame enables mouse input and covers the same list area. The code does not establish an explicit input-stack priority. Mouse focus goes to the highest eligible input frame; therefore list-wheel mouse ownership is a concrete overlap hypothesis, **not yet conclusive proof**. P0295 gives only addon-owned frames a bounded deterministic hierarchy: the wheel sits above the inert seven rendered rows, and seven hit regions are children of the wheel and explicitly above it. Positions/sizes and row visibility policy remain unchanged. Row wheel events remain available. No native UI frame is reparented, modified, or hidden.

P0294's local identity/index lookup, selected-detail bindings, invalid row guards, panel teardown, preview isolation and zero native mutation paths are preserved. This patch does not add speculative event hooks, polling, purchases, combat tests or native `SelectTrainerService` calls.

## Validation gates

- WSL: expected exact main commit and each edited source blob, no dirty tracked state, strict transform anchors, full repo `tools/check_*.py` PREWRITE/POSTWRITE, version-policy checker, memory health (CURRENT below 10 KB), prewrite Git whitespace test, postwrite `git diff --check`, and manifest. The new checker enforces hierarchy and native-write prohibitions without hard-coding runtime version.
- WoW: deploy, `/reload`, trainer open, `/logres panel` → H → Live Trainer ON (TEST). Click multiple distinct visible rows and verify immediate icon/title/requirement/description and gold highlight. Wheel directly over rows, use rail arrows and local Available/All; confirm selected identity survives filtered and scrolled windows. Confirm Blizzard's selected row remains unchanged and stock Train/Train All still function when appropriate (no purchase required). H Live Trainer OFF and ordinary trainer close must clear hit regions. Record taint/Lua/secret errors as FAIL and environmental untested transitions as DEFERRED.

No in-client proof exists yet for the P0295 fix. If clicks remain inert, retain failure and use a targeted input-focus diagnostic rather than claiming this hypothesis is confirmed.
