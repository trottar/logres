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

Canonical evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## G.3 — Production World/Combat camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS.**

P0100 at `31a2a7f6` supplies the production controller. Final validation on
P0102 runtime `0.0.42-dev` proves World transition/no-op, live-combat
transition/no-op, fresh World evaluation after combat, disable interruption,
Run All integration, DynamicCam coexistence blocking, and clean addon-owned
failure/secret/error diagnostics.

Canonical evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

## G.4 — City camera ownership

**IMPLEMENTATION PREPARED — RUNTIME PROOF PENDING.**

P0104 source/profile audit resolves the camera-only City slice:
- City activation uses existing resting state from `IsResting()`;
- live World (Combat) remains higher priority than City;
- City conditionally targets zoom 5 only when farther than 5;
- ordinary City entry uses 2.5 seconds;
- City exit fresh-evaluates its destination and never restores remembered zoom;
- proven G.3 MoveView/coexistence/fail-open architecture is reused.

Explicitly outside the first City implementation:
- DynamicCam City UI hide/fade;
- City `cameraDistanceMaxZoomFactor = 1` and broader CVar ownership;
- reactive-zoom implementation;
- DynamicCam's global first-situation instant-transition special case;
- Taxi, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering;
- rotation and shoulder offsets.

Canonical audit:
`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

P0105 prepares runtime `0.0.43-dev`: the existing production controller now
selects `city` after live combat, uses conditional target 5, exposes resting/City
diagnostics, and is guarded by a dedicated G.4 static contract checker. Stable
internal World/Combat command/module identifiers remain for compatibility.

Implementation runtime proof should cover automatic City entry, City >5
transition, City <=5 no-op, fresh destination evaluation on City exit, Run All,
and DynamicCam coexistence. Live combat + resting overlap should not be
manufactured solely for proof; if naturally unavailable, retain static
live-combat-before-City enforcement and record runtime environmental deferral.

## Parallel future integration direction

D-032 world-first layout/action-role planning, D-033 World Ghost visual planning,
and D-034 Selective Hybrid E / component-system direction remain valid parallel
Phase H+ work. They do not broaden Phase G runtime scope or waive capability
gates.

## Later Phase G Work

Taxi, Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering, rotation,
shoulder offsets, UI-hide integration questions, startup instant-transition
parity, and broader camera-CVar ownership remain later slices unless evidence
changes the order.
