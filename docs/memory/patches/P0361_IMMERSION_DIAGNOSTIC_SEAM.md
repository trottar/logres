# P0361 — ImmersionController diagnostic report ownership

**Source baseline:** verified pushed P0360 main `8963fb1d5ffc32d71291292e9e1192e16b68cf3b`, 231/231 static, `0.0.249-dev`; WoW UNVERIFIED.

The original `runImmersionCheck()` status PASS/FAIL report is extracted unchanged except its method declaration from `Core/Commands.lua` into preloaded `Immersion/Controller.lua`. The original Commands local wrapper delegates with the same `emit` and `boolText` helpers. Run All, slash, D-phase panel action, combat-pending policy, four module ownership status checks, error reporting, native Blizzard safety fallback and D-048 offline-only model remain unchanged. No extra Lua file, protected mutation, secret probe, saved migration, event, polling, or camera behavior.

Historical D.2 checker remains intact because the wrapper is preserved. P0360's exact 231-checker ceiling is narrowly changed to >=231; new checker #232 preserves all prior required fields and command behavior. Candidate `0.0.250-dev`, 94 Lua loads, 120 panel actions/38 previews, schema 3 unchanged.

The guarded one-time applier requires 12 exact Git source blobs and P0360 main baseline, 232/232 PREWRITE shadow and POSTWRITE static tests, diff hygiene and a generated manifest. Any PREWRITE refusal changes zero tracked files; POSTWRITE failure restores patch-owned tracked files. No suite PASS is claimed before the WSL run. P0321 is the FIRST contingent client gate; L-022/L-027/L-028 OPEN, L-019 public release BLOCKED and L-031 deferred. WoW runtime UNVERIFIED. Historical P0354 R0/R1/R2, P0355 R0/R1, P0358 R0 rejected attempts remain preserved.

## R1 revision after rejected handoff

P0361 R0 handoff error: assistant included current client-deployment and in-game test instructions even though the authoritative runtime gate remains deferred. User rejected R0 delivery. R1 is a new ZIP on the identical verified P0360 main SHA; the source extraction remains unchanged. R1 re-verifies exact guarded Git blob hashes, all source anchors, protected/fallback assertions, and the entire static gating design; adds a README deployment-prohibition preflight; updates negative evidence and active pointers; and provides only WSL static apply/commit instructions. There is no R0 WSL result, client test, or verified push. R1 remains PREWRITE/POSTWRITE 232/232 pending execution in the user checkout, WoW UNVERIFIED.
