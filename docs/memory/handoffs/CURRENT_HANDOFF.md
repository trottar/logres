# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0126 `89b0c563d1ff5e12c61baa3e407725a90d9cefd4`.

Current pushed runtime:
`0.0.58-dev`.

P0126 Active Quest is runtime + visual PASS. The initial hover failure remains
recorded; R1 corrected it and the final R3 composition is the accepted baseline.

## Active work stream

The user has explicitly chosen to finish the approved visual translation sequence
before returning to Camera.

Current objective:
**D-035 NPC quest interaction — source/capability audit before replacement.**

Camera remains frozen, not complete.

## Accepted visual translation checkpoints

- P0120 shared percentage bar — accepted production baseline;
- P0121 player cast cue — runtime + visual PASS; target proof deferred;
- P0122 Context messages — runtime/preview PASS; completion styling deferred;
- P0123 Compass heading/manual waypoint — runtime + visual PASS;
- P0124 organic health tunnel — runtime + visual baseline accepted; broad final
  polish deferred to whole-interface calibration;
- P0126 Active Quest — runtime + visual PASS at `89b0c563` / `0.0.58-dev`;
  count-free objective labels, bar-only progress, hover-only exact detail.

## Camera preservation

P0119 is durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`
on `0.0.49-dev`.

The frame-shaped transition correction is installed, but the normal-Taxi landing
retest has not been durably recorded as PASS. Resume that exact G.5 proof only
after the visual sequence is finished.

No SetCVar, Taxi rotation, or Taxi UI fade is authorized by this handoff.

## Next quest-interaction boundary

D-035 is the accepted future ownership direction, but no Blizzard quest/gossip
surface may be suppressed until its matching Logres information and interaction
are capability-proven.

The next audit must separate narrative/reward information from quest actions,
quest-related gossip transitions, runtime restrictions, and fail-open fallback.
Do not automate quest choices or bundle quest navigation/minimap ownership.

## Key references

- `../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `../investigations/NPC_QUEST_INTERACTION_CAPABILITY.md`
- `../evidence/P0126_ACTIVE_QUEST_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `../decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../evidence/P0124_HEALTH_TUNNEL_RUNTIME_VISUAL_PASS_2026-10-04.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `../architecture/CAMERA.md`
