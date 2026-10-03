# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.4.**

Current pushed checkpoint:
P0104 at `0b676083`, runtime remains `0.0.42-dev`.

P0105 runtime target:
`0.0.43-dev`.

G.3:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4:
**IMPLEMENTATION PREPARED — RUNTIME PROOF PENDING.**

Canonical source/profile audit:
`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

Accepted City camera contract:
- existing `state.resting` selects City;
- live `UnitAffectingCombat("player")` remains higher priority;
- City conditionally targets zoom 5 only when farther than 5;
- ordinary City entry uses 2.5 seconds;
- exit fresh-evaluates the destination; zoom restore remains `never`;
- reuse proven G.3 MoveView/coexistence/fail-open behavior.

Explicitly excluded from the first City runtime slice:
- DynamicCam City UI hide/fade;
- `cameraDistanceMaxZoomFactor = 1` CVar parity;
- reactive-zoom ownership;
- startup instant-transition parity;
- later DynamicCam situations/rotation/shoulder offsets.

P0104 is verified durable at `0b676083`.

P0105 prepares the narrow City context in the existing production controller,
extends diagnostics with resting/City visibility, and adds a dedicated G.4 static
contract checker. Runtime code changes require deployment after verified push.

Next: apply/push P0105, deploy `0.0.43-dev`, then validate automatic City entry,
City transition/no-op, City exit destination evaluation, Run All, and DynamicCam
coexistence.

User performs all commits/pushes.
