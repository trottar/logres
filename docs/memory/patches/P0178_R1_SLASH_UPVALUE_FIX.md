# P0178 R1 — correct slash-dispatch Lua upvalue overflow

Date: 2026-10-09. Baseline `0f3f0b7` (`0.0.93-dev`), original P0178 `0.0.94-dev` failed, R1 candidate `0.0.95-dev`.

P0178 introduced `local function runUIOwnershipCheck()` and two direct calls, including one inside the already-large `handleCommand` function. The Forever Lua compiler rejected `Commands.lua` with `function at line 4566 has more than 60 upvalues`; it could not register `/logres`. The original static audit contract and isolated Lua mock coverage missed this whole-source compilation limit.

R1 exposes the diagnostic as `function Logres:RunUIOwnershipCheck()` and dispatches via the **already-captured `Logres` namespace** from `handleCommand` and Run All. This removes the extra local function upvalue without changing the 35-surface audit registry, Blizzard/Logres ownership policy, command text, or diagnostic output. Version advances to `0.0.95-dev` so logs distinguish the faulty candidate.

The P0178 static contract is extended to forbid a local `runUIOwnershipCheck` capture and to require namespace dispatch. This targeted guard prevents recurrence of the same failure. New future command helpers must not increase the upvalue load of `handleCommand` without explicit compiler-budget validation; prefer namespaced dispatch.

The one-time R1 applier accepts only source-locked states: pristine `0f3f0b7`, byte-identical original P0178 output, or a byte-level mixture of those states (as after the advised limited rollback), with no staged edits or unrelated tracked changes. It reconstructs the exact candidate in a shadow checkout, validates all static contracts before tracked changes, checks diff whitespace, and rolls back patch-owned files if a postwrite failure occurs. It never commits or pushes.

Runtime verification is **PENDING**: `/reload`, `/logres status`, `/logres uiownershipcheck`, Phase 0 Run All, and Immersion OFF/ON. Any Lua/taint/secret error is FAIL; retain native fallback. The failure and its remedy are recorded in the paired evidence record. This is a corrective patch, **not** runtime acceptance.
