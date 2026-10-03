# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.4.**

Current pushed checkpoint:
P0103 at `4adf400a`, runtime remains `0.0.42-dev`.

G.3:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.4 contract:
**RESOLVED — CITY ZOOM IMPLEMENTATION NEXT.**

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

P0104 is docs/source-evidence only. No WoW redeploy is required.

Next patch: implement the narrow City context in the existing production camera
controller and extend diagnostics/static coverage.

User performs all commits/pushes.
