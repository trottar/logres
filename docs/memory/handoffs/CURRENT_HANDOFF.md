# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0156 `e1be731bd64db2acb62480f62fafaea58515989f` / `0.0.77-dev`.

## P0156 runtime result

LoadCount `187` / Forever `1.60.1.70245` passed the requested normal-world validation.

Phase G **Camera World/Combat Check**:
- PASS;
- context `world`, owns=true;
- current/start/final about `5.0795`;
- requested/effective target `5`;
- targetReached=true;
- failures=0;
- secret=false;
- error=nil;
- one sample;
- armZoom about `5.0795`;
- firstDelay=0.

Separate Phase 0 **Run All** repeated the camera PASS and completed cleanly.

The prior timeout/max-zoom failures remain preserved. This passing sample did not naturally reproduce the prior ~23.5s first-update delay and did not exercise a direction switch, so those branches are not separately runtime-proven.

## P0157 delivery diagnosis

Two P0157 deliveries failed and rolled back before a durable checkpoint:
- initial artifact omitted a required CURRENT schema section;
- R1 added it, but the checker used raw substring matching and also counted an inline prose mention of the same Markdown token.

R2 fixes the checker to count actual heading lines and preflights the complete candidate in a temporary checkout before writing the worktree.

## Exact next gate

Return to the pre-existing G.5 normal-Taxi landing retest from P0119:

1. take one normal Taxi flight;
2. during flight use Phase G -> **Camera World/Combat Check**;
3. after landing and settle, use Phase G -> **Camera World/Combat Check** again;
4. destination City/World must finish near target `5`, not first-person `0`;
5. require failures=0, secret=false, error=nil;
6. run Phase 0 -> **Run All** separately;
7. upload diagnostics.

No WoW redeploy is required for P0157 R2; it changes docs/repository tooling only.

## Key references

- `../CURRENT.md`
- `../evidence/P0157_DELIVERY_FAILURES_2026-10-06.md`
- `../evidence/P0157_P0156_WORLD_ENTRY_CAMERA_PASS_2026-10-06.md`
- `../investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `../patches/P0157_RECORD_P0156_CAMERA_PASS.md`
- `../patches/P0119_FIX_CAMERA_TRANSITION_OVERSHOOT.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
