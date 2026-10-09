# P0175 — Additive priority player/target status lanes

Baseline: verified `main` `996f6099270cd0be7d233e6a8f203bdc0396e59e`, runtime `0.0.90-dev`.
Candidate runtime: `0.0.91-dev`. Status: CANDIDATE — NOT IN-GAME TESTED.

## Intent

Build actual screen-space Logres player harmful and enemy status icon visuals without prematurely hiding Blizzard auras. Existing player `HELPFUL|PLAYER` remains untouched. Urgent player `HARMFUL|CROWD_CONTROL`, `HARMFUL|RAID`, then general `HARMFUL`; target player-applied harmful, CC, dispellable helpful, big defensive, important helpful, general harmful. Max five icon slots per lane; render with compact priority glyph, tinted frame, native icon, stacks, and Blizzard tooltip on hover. Deduplicate only when ordinary auraInstanceID is available; no secret comparison. Source failures report explicitly. Public aura reads always per-index secret-preflight. No inferred cooldown or exact timer; no stock aura suppression. Target associates with D-042 screen-space fallback anchor; accessible world anchor remains deferred.

## P0174 acceptance sync

P0174 R3 is pushed/verified at `996f6099` and user reports clean real combat casting; latest diagnostics show `castGate=true/true` with `gateEscapes=0`, five folded native domains, no recorded failures. Preserve R1 static memory failure and R2 combat reappearance as prior negative results. D-041 stock aura fallback remains mandatory.

## Validation

Applier checks main baseline, clean tracked checkout, versions and anchors; prepares full candidate in a disposable local clone; runs all static checkers, diff hygiene, then writes transactionally with rollback and a manifest, without Git staging/commits/push. Runtime test: `/reload`, `/logres statusaurapreview on`, visual scan for left player urgent + right target status and no stock aura mutation, `/logres statusaurapreview off`, `/logres statusauracheck`, Phase 0 Run All. Naturally populated target/player harmful data remains environmentally deferred if absent; on-source failure or Lua/taint/secret error is FAIL. Do not claim full H.1 closure.

## R1 correction reference

Original P0175 omitted the required developer-panel testing controls and lacked an unqualified target HELPFUL fallback. See P0175_R1_PANEL_TARGET_AURAS.md and R1 evidence for corrected panel layout, source limits and continued runtime deferral.
