# Roadmap Status

As of 2026-10-05.

## Active work stream

**Approved visual implementation translation — aura/status source + priority-policy audit next.**

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
**INSTALLED / PUSHED + READ-ONLY RUNTIME PASS FOR OBSERVED OFFER/GOSSIP SCOPE** at
`e50676b9` / `0.0.59-dev`.

Progress/complete and other unobserved categories remain deferred. Mutation
function presence was proven without invocation.

P0130:
**RUNTIME + VISUAL PASS on `0.0.61-dev`** — bounded/paged offer narrative accepted;
initial immersion-restore failure preserved and corrected in R1.

P0131:
**ACCEPT + DECLINE CAPABILITY PASS** — Decline proven on `0.0.62-dev`; Accept proven
on corrected `0.0.63-dev` with matched `QUEST_ACCEPTED` after intermediate
`QUEST_FINISHED`.

P0132:
**INSTALLED / PUSHED + RUNTIME/CONTROL PASS; VISUAL ORDER CORRECTION REQUIRED** at
`671f9836` / `0.0.64-dev`.

Production Decline/Accept behavior passes and Blizzard fallback remains usable.
Manual review found the Logres horizontal order opposite Blizzard's simultaneous
fallback.

P0133:
**INSTALLED / PUSHED — RUNTIME + VISUAL PASS** at `f2feead6` / `0.0.65-dev`.

Accept-left / Decline-right now matches Blizzard while the fallback remains
visible; preview/final-page behavior and integrated checks pass.

Next:
**P0135 aura/status source + priority-policy audit.**

This is implementation translation under D-039/D-040. It does not authorize
Phase-H-only capability expansion, stock minimap suppression, Logres-owned quest
controls, unproven navigation roles, or unrelated Camera changes.
