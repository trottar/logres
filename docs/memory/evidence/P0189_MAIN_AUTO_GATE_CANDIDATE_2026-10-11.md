# P0189 — automatic normal Main activation candidate evidence

Baseline GitHub `a1e85e7` confirmed with docs-only P0188 R1; P0187 R2 normal manual operation was accepted in the earlier loadCount 238 diagnostic. No P0189 client runtime evidence yet.

Source: `MainReplacement.lua` has tested session-arm `Reconcile`, ordinary preflight, secure parent gate, secure special-mode delegation, and native restoration. `Core/Modules.lua` enables modules in TOC order; `Primary.lua` loads before `MainReplacement.lua`. P0189 moves desired session arm to module enable, preserving explicit OFF opt-out. Startup source may be unavailable before world events; both that and initial special mode must fail open and retry only on native lifecycle/mode events.

Static checks are source-contract only. **OPEN RUNTIME / NO PASS CLAIM** for automatic login activation, edit-path normal fallback, protected special transitions, and natural recovery after initially special startup. Original P0187 R0 runtime regression, R1 delivery failure, P0188 R0 whitespace failure, and post-loot ObjectiveTracker intermittence remain recorded independently.
