# Active Investigations

## G.5 — Taxi camera ownership

Status:
**ACTIVE — CONTRACT REVIEW; NO RUNTIME CODE YET**

Canonical:
`G5_TAXI_CAMERA_OWNERSHIP.md`

Known captured-profile facts:
- Taxi situation `160`;
- on-taxi activation;
- priority `1000`;
- enter/exit `5`;
- conditional-out target `50`;
- rotation speed `-20`;
- UI hide/fade stored;
- restore `never`.

Current production behavior:
Taxi remains a fail-open/out-of-slice gate.

Next action:
audit DynamicCam source/profile semantics for precedence, transition/exit
behavior, target-50 capability/CVar boundaries, rotation scope, UI presentation
scope, coexistence, and the smallest runtime proof before authorizing code.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.3 production World/Combat camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.42-dev`.**

G.4 City camera ownership:
**CLOSED — RUNTIME + INTEGRATION PASS on `0.0.43-dev`.**

Canonical G.4 evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`

Natural live-combat + resting overlap remains an environmental deferral. Static
ordering plus the already-proven live-combat path remain authoritative.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
