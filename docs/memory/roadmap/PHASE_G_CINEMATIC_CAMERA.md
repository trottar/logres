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

**ACTIVE — P0100 PUSHED; RUNTIME PROOF PENDING.**

P0100 is durable at `31a2a7f` and adds the smallest production controller:
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

Canonical G.3 investigation:
`../investigations/G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`.

## Parallel future integration direction

D-032 world-first layout/action-role planning and D-033 World Ghost visual
planning remain valid parallel Phase H+ work. They do not broaden G.3 runtime
scope or waive camera capability gates.

## Later Phase G Work

More complex City/NPC/taxi/teleport/fishing/gathering/global settings remain
later slices. Rotation, UI hiding, shoulder offsets, and broader camera CVar
ownership are also outside P0100.
