# P0192 — Phase H.2 authored layout actual-geometry diagnostic candidate

Date: 2026-10-11. Baseline: `57c3112bb3edc2bb9bc27cfd82e65f9b260dbf92` (P0191 committed/pushed/verified). Candidate `0.0.102-dev`.

**Runtime read-only diagnostic**, not a runtime geometry translation. Existing P0166 integration anchor locations remain unchanged. Existing Phase H Layout Check appends a 13-row H.2 normalized addon-owned frame measurement against the exact P0191/D-045 v4 plan, including explicit missing/deferred states. This narrows the risk of blindly converting percent design boxes to runtime anchor offsets or claiming layout COMPLETE from static geometry.

The source audit identifies incompatible current grid shapes (Primary 4×3; Secondary/Utility 3×4), runtime size vs v4 envelopes, anonymous secure native harmful aura containers excluded from the named-frame probe, variable quest height and collision constraints for retained native access/extra actions. Detailed record: `docs/memory/evidence/P0192_H2_GEOMETRY_AUDIT_2026-10-11.md`.

No Blizzard presentation read, polling, protected action mutation, new slash command, new panel control, or stock suppression. Reported source geometry is not visibility/collision/interaction proof; in combat or missing/secret-capable observations defer rather than fail. All old native special and harmful-aura capability fallbacks retained.

Candidate requires full static checker suite in shadow before tracked write, version checker policy, both new H2 checkers, `git diff --check`, manifest, WoW redeploy, `/reload`, **Phase H Layout Check**, **Phase 0 Run All**, diagnostics/screenshots, then user acceptance. Current stage: PREPARED / RUNTIME PENDING, no results yet.

## R0 rejection and R1 delivery repair

The first P0192 ZIP failed during pre-write candidate construction: `P0191 durable status: expected unique anchor, got 0`. The user posted the failure and `git status --short`, showing no tracked modifications. The original script targeted a historical P0191 PATCH_INDEX status string rather than the verified P0191 row. **R0 is a delivery failure, not a runtime test.** P0192 R1 pins the actual row `PREPARED — APPROVED DESIGN GEOMETRY, DOCS ONLY`, preserves the same baseline hash and original audit Lua inserts, and records this error as durable negative evidence. All post-preflight source checks and WoW tests remain pending until R1 is run.
