# D-002 — Player health presentation

Status: ACCEPTED  
Date: 2026-09-30

## Decision

Logres does not use a conventional player health bar by default.

Player health/danger is communicated by a screen-edge vignette that becomes darker/redder and closes inward as health worsens.

## Intent

The player should feel increasing danger without continuously reading an exact meter.

## Open implementation questions

- exact safe API/data source in Forever;
- curve/threshold mapping;
- texture/mask implementation;
- accessibility alternatives;
- whether any optional numeric health mode exists.

These are not settled by this decision.
