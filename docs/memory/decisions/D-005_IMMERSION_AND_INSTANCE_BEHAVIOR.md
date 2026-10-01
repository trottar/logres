# D-005 — Immersion and instance behavior

Status: ACCEPTED  
Date: 2026-09-30

## Decision

Immersion Mode is a coordinated global presentation state.

The compass is part of Immersion Mode and automatically suspends in instances. Entering an instance does **not** disable Logres as a whole; combat-relevant HUD/action presentation remains available according to instance policy.

Leaving the instance restores eligible immersion presentation smoothly and without unnecessary notification.

## Rationale

World navigation and cinematic exploration are context-specific. Instance gameplay has different information and API requirements.
