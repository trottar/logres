# P0178 R1 — observed client startup failure and repair gate (2026-10-09)

## P0178 failure — FAIL

After applying and deploying original P0178 `0.0.94-dev`, the user reported that `/logres` stopped working. A second addon caught this concrete client compiler failure:

`LUA_WARNING: Interface/AddOns/Logres/Core/Commands.lua:1: Interface/AddOns/Logres/Core/Commands.lua:4921: function at line 4566 has more than 60 upvalues`

The warning refers to the newly expanded `handleCommand` closure. Original P0178 introduced a captured local `runUIOwnershipCheck` function, taking `handleCommand` across the Forever Lua 60-upvalue limit. Because `Commands.lua` does not load, the slash command is never registered. The earlier isolated tests and complete Python static checker suite did not prove whole-file client compilation. The original P0178 is **FAILED**, not installed/runtime-accepted; this negative evidence must remain durable.

## R1 correction — awaiting WoW verification

Replace local diagnostic runner with `Logres:RunUIOwnershipCheck()` and invoke it through `Logres` (already captured by `handleCommand`). Preserve audit source, flags, surface registrations, status semantics, and Blizzard fallback. Bump version `0.0.95-dev`. Tighten P0178 contract to prevent recapturing the local helper. The applier must verify all 0f3f0b7 source baselines or exact original P0178 candidate bytes, validate full static suite on shadow, and write transactionally.

Required in-client evidence: slash registration restored, Phase 0 UI Ownership Check emits 35 rows and totals without Lua error, Run All completes, Immersion OFF/ON appropriately adjusts expected ownership. Note any FAIL/DEFERRED rows without recasting partial/stock coverage as complete. No claim of runtime PASS before test.

Unrelated open items remain: live harmful-aura coverage DEFERRED, unknown hostile-target buff coverage, intermittent ObjectiveTracker flash, and incomplete primary/special/pet/party ownership.
