# P0099 — Close G.2 / Open G.3

Date: 2026-10-02
Result: INSTALLED / PUSHED — DOCS/EVIDENCE ONLY (`10c7255f`)

## Baseline

P0098 verified pushed:
`903e65c88dde36cc31d6f64af8cc6ff3da4623fd`.

Current runtime:
`0.0.40-dev`.

## Purpose

Record the successful P0096 runtime + integration proof, close G.2, and open
G.3 production World/Combat camera ownership.

## Evidence recorded

The captured P0096 diagnostics include two genuine live-combat probes with:
- live combat true;
- lockdown true;
- cached combat false;
- live/cached mismatch true;
- target reached;
- movement observed;
- starting zoom restored;
- no secret/error result.

The out-of-combat and post-combat paths remained clean.

Run All was performed on current `0.0.40-dev` and every emitted check passed
through `checkall: complete`.

Canonical evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## G.2 result

**CLOSED — RUNTIME + INTEGRATION PASS.**

The cached/live combat mismatch is retained as evidence that camera context must
use DynamicCam's live `UnitAffectingCombat("player")` predicate rather than
cached Logres combat state.

## G.3 opened

Production contract:
- World conditional target 5;
- World (Combat) conditional target 15;
- ordinary transition 2.5 seconds;
- zoom restore never;
- live UnitAffectingCombat selects combat;
- InCombatLockdown remains separate;
- primary MoveView path only;
- no temporary-CVar fallback;
- explicit interruption/disable/failure stop;
- no simultaneous DynamicCam and Logres movement ownership.

Canonical investigation:
`../investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`.

## Intervening memory preservation

P0097 D-032 world-first layout direction and P0098 D-033 World Ghost art
direction remain accepted parallel Phase H+ work. This checkpoint does not
supersede or narrow those decisions; it only advances the active camera work.

## Delivery validation failure — R2 correction

The first P0099 delivery reached repository validation and failed in
`tools/check_memory_health.py` because the replacement `CURRENT.md` used the
heading `## G.3 Success Criteria` instead of the repository-required literal
`## Success Criteria`.

Observed result:
- all earlier static checkers in that run passed;
- memory health reported the required heading occurred zero times;
- the applier aborted and restored the tracked tree;
- only the pre-existing untracked `LOGRES_DIAGNOSTICS_LATEST.lua` remained.

Classification:
**CLOSED — DELIVERY STRUCTURE DEFECT.**

R2 restores the required heading without changing G.2 evidence, G.3 scope, or
runtime behavior.

## Runtime

No runtime code changes.
No version bump.

## Deployment

Docs/evidence only.

No WoW redeploy is required.
