# P0351 — Preference diagnostic ownership seam

**Baseline:** verified pushed GitHub `main` P0350 `fd2d2676ffb41d509143b398b61b8474ecacf53d`, manifest 221/221 PREWRITE/POSTWRITE STATIC, version `0.0.239-dev`; WoW UNVERIFIED. P0321 native GossipFrame restoration remains FIRST contingent client gate. L-022/L-027/L-028 OPEN; L-019 public distribution BLOCKED.

## Narrow evidence and ownership

The one historical `runPreferenceCheck()` in `Core/Commands.lua` tests independent GetPreferences snapshots, a no-op SetPreference, and a pair of actual changes to `immersionEnabled` followed by restoration. These changes intentionally notify existing preference subscribers and increment the revision twice. The diagnostic is **not** passive, cannot be described as a side-effect-free read, and must never be run automatically. Its implementation belongs to the existing `Core/Preferences.lua` API owner, which loads before the command dispatcher. The original `emit` and `boolText` closures remain supplied by Commands; all historical PASS/FAIL report formatting remains identical. The test includes no direct native frame inspection or UI mutation, though the existing subscriptions can legitimately respond to the temporary preference changes.

## Targeted contract audit and minimal seam

Preserve `local function runPreferenceCheck()` in Commands as a one-call wrapper `Logres:RunDevPreferenceCheck(emit, boolText)`; maintain the historical `Run All`, slash route and phase-0 developer-panel registration unchanged. Move only the original body into `Logres:RunDevPreferenceCheck(emit, boolText)` in Preferences after the existing setter, keeping all original statements and ordering intact. `tools/check_status_aura_disabled_contract.py` (historical P0175 R3) explicitly requires the wrapper and Run All invocation; `tools/check_preference_contract.py` requires the `/logres preferencecheck` documentation and existing SetPreference consumer. Neither historical checker should be relaxed. P0350 State/Sensor and P0349 native ownership seams remain unchanged.

The patch does not change the stored preference schema 3, setting defaults, live D-048 selectors, UI ownership, camera, original 94 Lua modules, 120 developer-panel actions or 38 previews, or add events, timers or polling. Runtime version advances in parity to `0.0.240-dev`. Checker #222 validates wrappers, exact output content, effectful test semantics and order, source ownership, registration stability, preserved historical checker safeguards, and memory continuity.

## Validation and limitations

The guarded applier must refuse any unexpected branch/commit/blob/dirty tracked state, construct a full prewrite shadow candidate, and require all **222/222 PREWRITE** and **222/222 POSTWRITE** STATIC checkers plus whitespace checks before generating the manifest. The source review and historical search did not identify another preference diagnostic owner assertion; the full suite remains the actual acceptance gate for unseen historical dependencies. The candidate is only source-prepared; no WoW runtime PASS or FPS gain is asserted. Any failed static precheck is an explicit REFUSAL before tracked writes, not runtime evidence. P0350 221/221 static acceptance and all earlier failed-attempt records are preserved.
