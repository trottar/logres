# E.2 — Heading Compass Runtime Validation

Status: ACTIVE — IMPLEMENTATION PREPARED
Opened: 2026-10-01

Canonical decision:
`../decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`

Implementation evidence:
`../evidence/E2_P0067_HEADING_COMPASS_IMPLEMENTATION_2026-10-01.md`

## Runtime target

P0067:
`0.0.28-dev`

## Required proof

### Open world

With Immersion ON:
- compass is visible;
- Compass Check PASS;
- heading moves with player rotation;
- N/E/S/W orientation is correct.

### Preference

- Immersion OFF hides the compass immediately;
- Compass Check PASS in suspended state;
- Immersion ON restores it;
- Compass Check PASS.

### Reload

- persisted Immersion preference still drives compass presentation after
  `/reload`.

### Instance / restricted context

When a natural instance transition is available:
- State context becomes `instance`;
- compass hides;
- heading sampler is inactive;
- Compass Check PASS in suspended state;
- returning to world restores presentation.

Do not require contrived travel solely to manufacture this proof. If no natural
instance is available, record the environmental deferral rather than PASS.

### Regression

- Run All passes for checks actually performed;
- no Lua/taint/secret regression;
- minimap remains stock.

## Exit

E.2 closes when the world heading presentation and orientation are runtime
proven, Immersion restoration is proven, and restricted-context suspension has
either direct runtime proof or an explicitly preserved environmental deferral
consistent with existing I-001 capability evidence.
