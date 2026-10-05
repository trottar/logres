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
**P0129 read-only NPC quest interaction runtime capability probe.**

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

P0128 resolves the source layer: the needed narrative/reward/gossip APIs exist,
and the quest-action APIs exist, but mutation ownership remains runtime-unproven.

P0129 must be read-only:
- observe interaction events;
- capture safe narrative/reward/gossip values;
- record mutation-function presence only;
- never call Accept/Decline/Complete/GetQuestReward or gossip-selection APIs;
- leave Blizzard UI fully available.

Do not automate quest choices or bundle quest navigation/minimap ownership.

## Key references

- `../evidence/P0128_NPC_QUEST_INTERACTION_SOURCE_AUDIT_2026-10-05.md`
- `../decisions/D-035_QUEST_INTERACTION_OWNERSHIP.md`
- `../investigations/NPC_QUEST_INTERACTION_CAPABILITY.md`
- `../evidence/P0126_ACTIVE_QUEST_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `../decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../evidence/P0124_HEALTH_TUNNEL_RUNTIME_VISUAL_PASS_2026-10-04.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `../architecture/CAMERA.md`
