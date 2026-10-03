# G.3 P0100 Resting Deferral / Developer Panel Overflow — 2026-10-02

Runtime:
`0.0.41-dev`.

P0100 commit:
`31a2a7f63298252325938897ba653d33d8e384ec`.

## Camera observation

The first production-controller validation screenshot showed the camera did not
move while addon-owned controller state reported:
- selected context `none`;
- ownership false;
- action/reason `relinquished` / `outside-slice:resting`;
- live combat false;
- DynamicCam false;
- camera API available;
- no secret/error result.

The current G.3 contract intentionally excludes resting/City from the World
slice. Therefore this observation did not exercise the World `>5 -> 5`
transition.

Classification:
**ENVIRONMENTAL DEFERRAL — EXPECTED RESTING RELINQUISH; CAMERA MOVEMENT UNPROVEN.**

Do not record this as camera PASS or FAIL.

## Separate developer-panel defect

The same screenshot proves the flat developer action grid exceeded the fixed
button region after P0100 added camera controls. Buttons overlapped the scrolling
diagnostic output and made the validation surface difficult to use.

Classification:
**RUNTIME UI DEFECT — REPRODUCED.**

Accepted correction:
- organize controls by roadmap phase tabs `0/A/B/C/D/E/F/G/H`;
- render only the selected phase's actions;
- place global Run All / Status under Phase 0;
- default to Phase G while G.3 is active;
- preserve persisted diagnostics independently of tab selection.

P0102 implements that panel correction without changing G.3 camera predicates or
movement behavior.
