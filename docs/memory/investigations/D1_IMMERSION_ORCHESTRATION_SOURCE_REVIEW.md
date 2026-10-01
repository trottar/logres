# D.1 — Immersion Orchestration Source Review

Status: ACTIVE
Opened: 2026-10-01

## Question

How should Logres centrally orchestrate immersion ON/OFF and contextual
exceptions while safely suppressing/restoring proven Blizzard surfaces?

## Existing contracts

Use as constraints:
- D-009 observed state;
- D-010 persisted immersion preference;
- D-011 module lifecycle;
- D-017 Blizzard UI suppression/restoration ownership;
- D-020 action layout customization direction;
- D-023 selective stock action replacement;
- Phase C runtime evidence.

## Source review targets

### Blizzard unit frames
Resolve exact frame/module ownership and restoration behavior for:
- player;
- target;
- party;
- focus only if later justified.

Determine:
- protected status;
- combat-lockdown implications;
- Blizzard re-show/update behavior;
- safe suppression mechanism;
- exact restoration snapshot requirements.

### Chat / Quiet Mode
Resolve:
- chat frame/tab visibility mechanics;
- social notification surfaces;
- combat restrictions if any;
- restoration;
- what can be visually silenced without changing communication status.

### Action replacement integration
Phase C proves automatic replacement only for:
- stock Bar 2;
- stock Bar 3.

D.1 must define how immersion orchestration requests that capability without
duplicating its internal routing/snapshot logic.

Primary routing remains manual while Primary stock replacement is unsupported.

### Preference + state orchestration
`immersionEnabled` remains a preference, not observed state.

Controller policy consumes:
- preference snapshot;
- observed state snapshot.

It produces presentation/suppression decisions.

Do not merge preference into State.

### Combat deferral
Resolve whether each suppression target:
- can transition freely in combat;
- must defer until `PLAYER_REGEN_ENABLED`;
- needs a secure driver;
- must remain unchanged until safe.

### Recovery
Developer panel remains independent from immersion suppression during
development.

There must always be a recovery path back to visible Blizzard UI.

## Deliverable

D.1 source/design decision should define:
- controller inputs;
- owned outputs;
- supported suppression targets;
- per-target transition constraints;
- restoration ownership;
- fail-open behavior;
- initial Phase D implementation order.

No broad runtime suppression before this review closes.
