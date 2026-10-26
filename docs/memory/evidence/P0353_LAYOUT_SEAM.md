# P0353 — Read-only H.2 layout diagnostic ownership seam

**Verified baseline:** pushed GitHub `main` P0352 `61f0f49c2cf990168c1415dd2100a0f286627a91`, manifest 223/223 PREWRITE/POSTWRITE STATIC PASS, `0.0.241-dev`. WoW runtime UNVERIFIED / DEFERRED. P0321 native GossipFrame stock restoration FIRST contingent client gate; L-022/L-027/L-028 OPEN; L-019 public release BLOCKED.

## Narrow hypothesis and source evidence

The 16-entry addon-frame semantic-anchor inventory `LAYOUT_EXPECTED` and the original `runLayoutCheck` routine still reside in the overgrown Core/Commands dispatcher. Both describe existing Integration/Layout capabilities: cached Bind anchors, approved H.2 placement and read-only H.2 geometry. They are not general command routing. Integration/Layout is already loaded before Commands and exposes the relevant getters. The existing diagnostic only samples Logres-named addon frames and existing layout status APIs; it neither suppresses Blizzard presentation nor modifies geometry.

## Exact extraction

Move the entire original 16-role table and original report body, changing only the report function declaration, into `Layout.RunDevLayoutCheck(emit)` in Integration/Layout. Retain `local function runLayoutCheck()` in Commands as a single delegation using the original `emit` sink. Preserve original status classification, six message formats, H.2 placement line, each geometry row, output order, Run All, help text, slash and Phase H panel route. No new UI mutation, protected/secret inspection, timer, handler, loading unit, preference setting, schema, camera or D-048 selector. Version parity advances to `0.0.242-dev`; 94 Lua load entries, 120 panel actions and 38 P previews stay fixed.

## Historical checker owner migration

Four source-location tests must be changed deliberately without discarding their safety requirements: `check_layout_integration_contract.py` (report strings formerly required inside Commands), `check_h2_unified_placement_contract.py` (16-role count and H.2 placement line), and `check_h2_geometry_audit_contract.py` (geometry output fragments), and `check_native_access_contract.py` (the H.2 native dock role moved out of Commands). Each checks the same report fragments in Integration/Layout and retains separate command routing, layout binding, placement, addon-geometry and read-only safety requirements. New checker #224 guards exact delegation, original output ordering, 16 addon-frame names, unchanged audit/placement calls, four historical migrations, memory continuity and inventoried module/action counts.

## P0353 R0 PREWRITE refusal and R1 corrective action

**P0353 R0 PREWRITE REFUSED 1/224, checker 57/224, `check_native_access_contract.py` (P0172).** On 2026-10-26 the user verified the R0 ZIP hash, extracted it and executed the guarded applier from pushed P0352. The shadow checker expected `{ "LogresNativeAccessDock", "nativeAccess" },` physically in `Core/Commands.lua`, although the proposed move correctly placed the original H.2 role table in `Integration/Layout.lua`. The three planned H.2 migrations missed this independent P0172 contract. **No tracked writes occurred** because refusal was inside PREWRITE. This was an assistant historical-checker audit omission, not a WoW runtime failure. **R0 CLOSED / PREWRITE REFUSED.**

**R1:** Move only the dock-role presence requirement to `Integration/Layout.lua` in the original P0172 checker, retaining its native source, stock fallback, command dispatch, native module, and TOC checks unchanged. Guard the original checker itself by exact Git blob and add a fourth historical-checker migration assertion to checker #224. Require the complete 224-checker PREWRITE/POSTWRITE suite; no static-only client PASS may be inferred. If further historical checks fail, preserve their negative evidence and refuse tracked writes.

## Validation boundary

The guarded exact-commit applier refuses dirty tracked state and wrong Git blobs, assembles the full candidate in shadow, requires 224/224 PREWRITE and POSTWRITE STATIC contracts and `git diff --check`, then writes a manifest. These checks do not execute WoW Lua, prove native interaction or measure performance. In-game H.2 geometry acceptance remains UNVERIFIED until client access returns. Prior P0349 R0, P0347 R0 and all older negative/static refusals remain durable.
