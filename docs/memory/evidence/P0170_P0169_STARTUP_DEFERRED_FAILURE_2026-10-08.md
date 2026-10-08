# P0170 — P0169 first-login failure and post-check recovery

Date: 2026-10-08. Evidence: uploaded `LOGRES_DIAGNOSTICS_LATEST.lua`, verified pushed `trottar/logres@74ff4156376c40d96efc100ed2f33415e6462291` / `0.0.86-dev` source. Status: **OBSERVED STARTUP FAILURE, RECOVERED AFTER DIAGNOSTIC PREFERENCE CYCLE; P0170 RUNTIME UNTESTED**.

### Actual observations

- Immediately after login (`loadCount=207`): `layoutcheck: PASS (anchors=15 binds=17 failures=0 ...)`.
- Initial Phase C Action Check: Bar4 slots 25–36 `shown=false routing=false`, Bar5 slots 37–48 `shown=false routing=false`.
- Initial Phase C Stock Replace Check: **misreported PASS**: `requested=false applied=false pending=false ... error=Bar 4/5 source configuration unreadable`; native Bar 2/3 alpha=1 and Bar4/5 alpha=1, matching native fail-open visibility, not suppression.
- Later `checkall` invokes preference/lifecycle checks before stock; the later Stock Replace Check reports `requested=true applied=true pending=false ... error=nil`, Bar 2–5 alpha=0, stock frame/button mouse off, Bar4/5 routing true, and Layout Check still 15/17 PASS. This is real *post-retry* success, not a clean-login PASS.
- User said "seems okay so far"; no visual screenshot of the new five-cluster geometry or direct native edit-state proof was supplied. Those remain runtime scope limitations.

### Source cause

`SecondaryUtility:RefreshExtraVisibility()` reads native `Settings.GetValue(PROXY_SHOW_ACTIONBAR_4/5)` only if classified boolean; at early login it returned unknown. `StockReplacement:EnableReplacement()` treated unknown as permanent failure and set `requestedEnabled=false`. `StockReplacement:HandleEvent` only responded to `PLAYER_REGEN_ENABLED`. `runStockReplacementCheck()` checked all suppressed properties only conditional on `appliedEnabled`, not that Immersion *required* applied suppression; hence false PASS. A transient source read also nulled the prior Logres bar-visibility state, which could create hidden actions while stock remained suppressed later.

### Narrow fix and gate

Preserve request/pending and usable Blizzard presentation on unknown settings. Retry only on `PLAYER_ENTERING_WORLD`, `EDIT_MODE_LAYOUTS_UPDATED`, and combat release, never timers/polling or blanket hooks. Keep last known presentation when settings are temporarily unreadable. The developer check must fail unless `expected==requested==applied`, `pending=false`, `snapshotReady` matches expected, and `lastError=nil`; all normal suppressed alpha/mouse/routing checks still apply. New addon-owned retry counters record whether a startup retry occurred, never protected Blizzard state.

Test P0170 only after `/reload`: **run Phase C Stock Replace Check first** (before Run All or Immersion flips), then Action, Layout, Run All, OFF/ON restoration and another reload. Require no Lua, taint, secret or protected errors. Record any failure durably instead of marking PASS. P0170 candidate does not suppress unsupported Main/Pet/minimap/tracker/XP/party or other surfaces.

## P0170 R0 delivery failure (2026-10-08)

Status: **CLOSED AS DELIVERY DEFECT; runtime still untested**. On the exact pushed P0169 baseline, the initial P0170 applier aborted inside `edits("Logres/Core/Commands.lua")` because it demanded 12 leading spaces before `tostring(status.initialized)` while the actual source uses eight. The observed failure was `expected 1 occurrences ... got 0`. Shadow candidate checks and tracked writes were not reached; the user's `git status --short` showed only the untracked patch files, previous diagnostics and an unrelated document. P0170 R1 replaces the brittle anchor with the actual verified indentation and keeps all code behavior unchanged from R0. This is NOT evidence that the startup defect is fixed in runtime.
