# P0294 — Local trainer skill selection evidence

Date: 2026-10-21. Baseline: pushed GitHub `main` P0293 `5e50fd2` (`0.0.194-dev`). **PREPARED — WSL and WoW runtime unverified.**

## Pre-patch observations and limits

User-confirmed P0293: sampled trainer rows display with correct source-backed names, ranks, costs, icons, requirements, descriptions and availability labels. Local Filters (All sampled / Available only) work and seven visible rows fit the accepted portrait-free landscape. Blizzard selection correspondence was observed when its current selection was sampled. Beyond-seven scrolling was not conclusively demonstrated in screenshots; native-to-Logres click ownership, purchases and final trainer replacement remain UNVERIFIED. The source catalogue remains constrained by Blizzard's active native filter and the 64-service snapshot cap.

## Narrow hypothesis and implementation

The shared renderer already has reusable seven-row bindings, but detail fields are painted once. Add live-only reusable icon/title/requirements/description references to the existing detail panel. The standalone live controller adds one narrow transparent addon-owned mouse region per row, with wheel handling preserved on those regions. A row slot is resolved against the currently displayed model only at click time and validated by its stored native service index against the captured catalogue; filtered position is never used as native identity. This is local selection and does not call `SelectTrainerService`, `BuyTrainerService`, or any native filter setter. Hidden filtered selections retain their detail and regain highlight when scrolled back into view. Non-service placeholder positions lose their click region. Preview P remains inert, and the parent surface remains mouse-inert. Existing trainer-close, combat, world-entry, and panel-OFF hide paths continue to remove input via parent hiding; controller state is discarded. Stock trainer remains visible and functional.

## Static and WoW gates

Guarded P0294 candidate: exact Git SHA and per-file Git blob checks; clean tracked state; source-anchor checks; full PREWRITE and POSTWRITE `tools/check_*.py` suite; version-policy and memory-health checks; prewrite whitespace on every edited/new file; final `git diff --check`; manifest. Failure results must be preserved; no WoW outcome is claimed by code inspection alone.

WoW: deploy and `/reload`. At an ordinary trainer, `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Click several Logres rows and verify immediate highlight, detail icon, title, requirements and description while Blizzard's current native selection/Train/Train All do not change. Wheel through rows 8+, toggle All sampled / Available only and ensure a hidden local selection still appears in detail and recovers highlight upon return. Check an empty filter state, local scroll arrows, Live Trainer OFF and trainer close; confirm no invisible click regions, purchase or taint. Repeat in a normal interaction without an actual purchase. Combat/world-entry teardown is code guarded but remains client-unverified until a natural opportunity; do not engineer combat to claim PASS. Record any Lua/protection/secret error as FAIL.

## Deferred

Native selection synchronization after Logres clicks, protected training purchases/Train All, independent enumeration outside Blizzard source filters, over-64-row completeness, scrolling beyond seven as an *observed* fact until user verification, and aesthetic polish remain separate gates. No failures observed in the source inspection scope; WSL and runtime outcomes pending.
