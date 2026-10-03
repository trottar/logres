# Phase G — Cinematic Camera

Status: ACTIVE — G.4
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres.

## G.1 — Current DynamicCam profile capture

**COMPLETE — PASS.**

Canonical evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`.

## G.2 — World/Combat camera zoom capability

**COMPLETE — RUNTIME + INTEGRATION PASS.**

Correct profile behavior:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transitions 2.5 seconds;
- zoom restore never.

P0096 proved the primary `GetCameraZoom` + `MoveView*Start/Stop` path in two
genuine live-combat probes and proved production combat classification must use
live `UnitAffectingCombat("player")` rather than cached Logres combat state.

Canonical evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## G.3 — Production World/Combat camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS.**

P0100 at `31a2a7f6` implements:
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

Final production validation occurred on P0102 runtime `0.0.42-dev` and proved:
- World >5 transition PASS;
- World <=5 no-op PASS;
- automatic live-combat <15 transition PASS;
- combat >=15 no-op PASS;
- combat exit fresh World evaluation PASS;
- active transition disable interruption PASS (`stop=module-disabled`);
- Run All integration PASS;
- DynamicCam loaded blocks Logres ownership PASS;
- no accepted-sequence addon-owned failure/secret/error result.

Canonical final evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

The earlier resting/City relinquish observation remains retained as expected
environmental deferral evidence:
`../evidence/G3_P0100_RESTING_DEFERRAL_PANEL_OVERFLOW_2026-10-02.md`.

## G.4 — City camera ownership

**ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET.**

Captured profile facts already available:
- City situation is enabled;
- activation meaning is resting;
- priority is 1 in the captured DynamicCam mapping;
- enter transition stored as 2.5 seconds;
- conditional zoom-in target is 5;
- DynamicCam also stores City UI hide/fade behavior at opacity 0.65.

Next step is not implementation. First resolve:
- exact City entry/exit camera semantics;
- precedence with live World (Combat), which must continue to win during combat;
- whether any City UI-hide behavior belongs in Phase G at all, versus remaining a
  separate Logres presentation-policy concern;
- the smallest fail-open/coexistence-gated runtime slice for proof.

Do not broaden G.4 into Taxi, NPC Interaction, fishing, gathering, hearth,
rotation, shoulder offsets, or global camera CVar ownership.

Canonical investigation:
`../investigations/G4_CITY_CAMERA_OWNERSHIP.md`.

## Parallel future integration direction

D-032 world-first layout/action-role planning, D-033 World Ghost visual planning,
and D-034 Selective Hybrid E / component-system direction remain valid parallel
Phase H+ work. They do not broaden Phase G runtime scope or waive capability
gates.

## Later Phase G Work

Taxi, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering, rotation,
shoulder offsets, UI-hide integration questions, and broader camera-CVar
ownership remain later slices unless evidence changes the order.
