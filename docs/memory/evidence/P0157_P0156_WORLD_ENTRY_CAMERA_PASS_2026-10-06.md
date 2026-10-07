# P0157 — P0156 World-Entry Camera Pass — 2026-10-06

Status: **OBSERVED NORMAL WORLD-ENTRY RUNTIME PASS**
Runtime: `0.0.77-dev`
Client: Forever `1.60.1.70245`
Durable P0156 commit: `e1be731bd64db2acb62480f62fafaea58515989f`
LoadCount: `187`

## Requested validation

After P0156 deployment:
1. normal `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately;
4. upload diagnostics.

## Phase G result

PASS:
- context `world`;
- owns=true;
- reason `PLAYER_ENTERING_WORLD`;
- current/start/final `5.0794949531555`;
- requested/effective target `5`;
- duration `2.5`;
- elapsed `0`;
- targetReached=true;
- failures=0;
- secret=false;
- error=nil.

Motion line:
- samples=1;
- toward=0, away=0, flat=1;
- min=max=`5.0794949531555`;
- expected=`5.0794949531555`;
- position error=0;
- inCommands=0;
- outCommands=0;
- switches=0;
- armZoom=`5.0794949531555`;
- firstDelay=0.

## Integrated result

Separate Phase 0 Run All repeated the same camera PASS and completed cleanly.

## Interpretation

The user-visible max-zoomed-out failure from P0155 did not recur. The observed normal-world-entry regression is closed for this runtime sample.

The accepted run does not directly exercise:
- the earlier large nonzero first-update delay (`firstDelay=0` here);
- P0155 stop-before-reverse behavior (`switches=0` here).

Those branches remain unexercised, and the earlier failures remain preserved. No speculative additional world-entry camera patch is justified.

## Next gate

Return to P0119's still-pending normal-Taxi landing retest. Production Taxi remains open until one normal Taxi flight proves:
- Taxi ownership/target semantics while airborne;
- destination City/World convergence near target `5`, not `0`;
- failures=0;
- secret=false;
- error=nil;
- separate Run All clean.
