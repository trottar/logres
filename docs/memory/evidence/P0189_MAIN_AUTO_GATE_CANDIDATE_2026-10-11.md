# P0189 — automatic normal Main activation candidate evidence

Baseline GitHub `a1e85e7` confirmed with docs-only P0188 R1; P0187 R2 normal manual operation was accepted in the earlier loadCount 238 diagnostic. No P0189 client runtime evidence yet.

Source: `MainReplacement.lua` has tested session-arm `Reconcile`, ordinary preflight, secure parent gate, secure special-mode delegation, and native restoration. `Core/Modules.lua` enables modules in TOC order; `Primary.lua` loads before `MainReplacement.lua`. P0189 moves desired session arm to module enable, preserving explicit OFF opt-out. Startup source may be unavailable before world events; both that and initial special mode must fail open and retry only on native lifecycle/mode events.

Static checks are source-contract only. **OPEN RUNTIME / NO PASS CLAIM** for automatic login activation, edit-path normal fallback, protected special transitions, and natural recovery after initially special startup. Original P0187 R0 runtime regression, R1 delivery failure, P0188 R0 whitespace failure, and post-loot ObjectiveTracker intermittence remain recorded independently.

## P0190 later client acceptance (2026-10-11)

P0189 pushed/verified `bd0c36a`. Uploaded loadCount 239 and user statement “pushed, all worked as expected” support bounded PASS: fresh normal automatic CANDIDATE (1/0), OFF STOCK optOut (1/1), ON CANDIDATE (2/1), final integrated Main 7/6 `error=nil`, Primary 12/12, ownership 17 PASS/18 STOCK/0 FAIL. Original candidate uncertainty is superseded **for observed ordinary scope only**; native special/combat modes remain ENVIRONMENTALLY DEFERRED, and the policy `main_action` STOCK classification is unchanged. H.2 authored layout calibration now active. Canonical `docs/memory/evidence/P0190_P0189_AUTO_MAIN_RUNTIME_2026-10-11.md`.
