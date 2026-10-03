# Phase G — Cinematic Camera

Status: ACTIVE — G.5
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

## G.3 — Production World/Combat camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS.**

P0100 supplies the production controller. Final validation on `0.0.42-dev`
proves World transition/no-op, live-combat transition/no-op, fresh World
evaluation after combat, disable interruption, Run All integration, DynamicCam
coexistence blocking, and clean addon-owned diagnostics.

Canonical evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

## G.4 — City camera ownership

**COMPLETE — RUNTIME + INTEGRATION PASS.**

P0104 resolved the camera-only City contract. P0105 at `69560080`, runtime
`0.0.43-dev`, implemented City from resting after live-combat precedence.

Accepted runtime evidence proves:
- automatic real resting -> `context=city`;
- clean City >5 conditional movement from about `13.090` to `5.178`,
  `targetReached=true`;
- City <=5 no-op;
- fresh World evaluation on City exit with no remembered restore;
- Run All integration;
- DynamicCam coexistence;
- `failures=0`, `secret=false`, `error=nil` in accepted diagnostics.

The earlier City `18 -> 0`, `targetReached=false` observation remains preserved
as ambiguous environmental evidence rather than being rewritten as a PASS.

Natural live-combat + resting overlap was not available and remains an
environmental deferral. Static ordering enforces live combat before City.

Canonical runtime evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`.

## G.5 — Taxi camera ownership

**ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET.**

Captured profile facts:
- Taxi situation `160`;
- on-taxi activation;
- priority `1000`;
- enter/exit `5` seconds;
- `zoomType = out`, absolute target `50` only when closer;
- rotation speed `-20`;
- UI hide/fade stored;
- zoom restore `never`.

Current production behavior remains fail-open: Taxi relinquishes Logres camera
ownership.

Before runtime implementation, G.5 must resolve:
- source precedence relative to live combat, City, World, and interaction;
- entry/destination transition semantics;
- target-50 capability and camera-distance CVar boundary;
- whether the first slice is zoom-only or separately capability-gates rotation;
- UI hide/fade scope;
- coexistence/fail-open behavior;
- the smallest runtime proof.

Canonical investigation:
`../investigations/G5_TAXI_CAMERA_OWNERSHIP.md`.

## Parallel future integration direction

D-032 world-first layout/action-role planning, D-033 World Ghost visual planning,
D-034 Selective Hybrid E / component-system direction, and D-035 future NPC
quest-interaction ownership remain valid parallel Phase H+ work. They do not
broaden Phase G runtime scope or waive capability gates.

## Later Phase G Work

After Taxi: Hearth/Teleport, NPC Interaction, Fishing, AFK, Gathering, rotation,
shoulder offsets, UI-hide integration questions, startup instant-transition
parity, and broader camera-CVar ownership remain later slices unless evidence
changes the order.
