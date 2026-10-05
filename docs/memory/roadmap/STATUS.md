# Roadmap Status

As of 2026-10-05.

## Active work stream

**Approved visual implementation translation — NPC quest interaction read-only runtime probe next.**

The formal roadmap remains capability-gated and Phase G is still open. Camera is
temporarily frozen by explicit user sequencing while the approved D-039/D-040
visual translation sequence is completed.

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | COMPLETE |
| A — Core State Engine | COMPLETE |
| B — Core HUD | COMPLETE |
| C — Action Interface | COMPLETE |
| D — Immersion Controller | COMPLETE |
| E — Compass and Navigation | COMPLETE |
| F — Quest Experience | COMPLETE |
| G — Cinematic Camera | ACTIVE — G.5 OPEN / PAUSED |
| H — Integration and Polish | QUEUED — approved visual translation underway in parallel |

## Phase G / G.5

P0119 is durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
on `0.0.49-dev`.

Its frame-shaped MoveView transition correction is installed, but the normal-Taxi
landing retest has not been durably recorded as PASS. G.5 therefore remains open.

Camera work resumes only after the current approved visual sequence is finished.
No max-distance mutation, Taxi rotation, or Taxi UI fade is authorized.

## Parallel approved visual translation

Accepted checkpoints:

- P0120 shared percentage/resource bar — core runtime + visual PASS; richer
  ornament deferred;
- P0121 cast-state cue — player cast PASS; target runtime proof deferred;
- P0122 Context-message primitive — runtime/preview path PASS; completion styling
  deferred;
- P0123 heading/manual-waypoint Compass — runtime + visual PASS;
- P0124 organic player-health tunnel — runtime + visual baseline accepted;
  whole-interface polish deferred;
- P0126 Active Quest one-focus presentation — runtime + visual PASS at
  `89b0c563` / `0.0.58-dev`; whole-interface polish deferred.

P0128 source audit:
**RESOLVED — API/source layer available; mutation capability not proven.**

P0129:
**PREPARED on `0.0.59-dev` — read-only runtime evidence pending.**

Next:
**Deploy P0129 and collect natural NPC quest/gossip interaction evidence.**

This is implementation translation under D-039/D-040. It does not authorize
Phase-H-only capability expansion, stock minimap suppression, Logres-owned quest
controls, unproven navigation roles, or unrelated Camera changes.
