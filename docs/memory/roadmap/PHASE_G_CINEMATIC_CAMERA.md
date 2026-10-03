# Phase G — Cinematic Camera

Status: ACTIVE — G.3
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

## G.2 — World/Combat camera zoom capability

**COMPLETE — RUNTIME + INTEGRATION PASS.**

Correct profile behavior:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transitions 2.5 seconds;
- zoom restore never.

P0096 passed two genuine live-combat probes on `0.0.40-dev` using live
`UnitAffectingCombat("player")`; the retained cached/live mismatch proves cached
Logres combat state is not an equivalent camera-context predicate.

Canonical evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## G.3 — Production World/Combat camera ownership

**ACTIVE — P0100 PUSHED; MOVEMENT PROOF STILL PENDING.**

P0100 is durable at `31a2a7f6`, runtime `0.0.41-dev`, and implements:
- event/state-driven World/Combat selection;
- targeted live-combat reevaluation independent of cached state publication;
- World conditional target 5;
- World (Combat) conditional target 15;
- 2.5-second primary MoveView transition;
- zoom restore never;
- DynamicCam coexistence gate;
- explicit stop/fail-open behavior;
- no temporary-CVar fallback;
- addon-owned diagnostics and Run All integration.

The first P0100 observation occurred while `resting=true`; the controller
reported `outside-slice:resting`, context none, and ownership false. This is an
expected relinquish condition, so movement remains untested rather than failed.

The same screenshot reproduced a developer-panel overflow. P0102 corrects that
presentation with roadmap-phase tabs and removes a redundant exact-runtime pin
from the G.3 feature checker. Camera ownership semantics are unchanged.

Canonical runtime observation:
`../evidence/G3_P0100_RESTING_DEFERRAL_PANEL_OVERFLOW_2026-10-02.md`.

Canonical G.3 investigation:
`../investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`.

## Parallel future integration direction

D-032 world-first layout/action-role planning, D-033 World Ghost visual planning,
and D-034 Selective Hybrid E / component-system direction remain valid parallel
Phase H+ work. They do not broaden G.3 runtime scope or waive camera capability
gates.

## Later Phase G Work

More complex City/NPC/taxi/teleport/fishing/gathering/global settings remain
later slices. Rotation, UI hiding, shoulder offsets, and broader camera CVar
ownership are also outside P0100/P0102.
