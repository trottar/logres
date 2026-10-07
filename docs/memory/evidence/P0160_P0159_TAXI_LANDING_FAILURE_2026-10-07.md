# P0160 — P0159 Taxi Landing Failure — 2026-10-07

Status: **REPRODUCED SHARED ZOOM-DRIVER FAILURE**

Durable P0159 R1:
`8ddcf09844961adec7bc90621f0f5ca294f15aef`

Runtime:
`0.0.78-dev`, loadCount `189`.

## Base/profile

Ordinary world Camera Profile Check passed.

Observed profile diagnostics:
- teleport=false;
- afk=false;
- gathering=false;
- interaction=false;
- fishing=false;
- secretSkips=0;
- readFailures=0;
- profileError=nil.

Separate Run All completed cleanly.

## Taxi

Two in-flight checks passed:
- context=taxi;
- current/start/final about `49.755970001221`;
- requested/effective target `50`;
- duration `5`;
- maxFactor `4`;
- maxCeiling `60`;
- targetReached=true;
- failures=0;
- secret=false;
- error=nil.

## Landing

After landing:
- context=city;
- start about `49.755970001221`;
- requested/effective target `5`;
- current at diagnostic `50`;
- final `0`;
- elapsed about `3.2779999999912`;
- targetReached=false;
- failures=1;
- error=`camera transition timed out before target`.

Motion:
- samples=97;
- toward=55;
- away=40;
- flat=2;
- min=0;
- max=50;
- maxAbsPosError about `49.471236100537`;
- inCommands=55;
- outCommands=40;
- direction switches=80.

## Classification

Taxi predicate/priority/target ownership passes.

P0155 stop-before-reverse is now heavily exercised and is not sufficient by itself.

The shared bespoke zoom timing/correction engine fails on the large Taxi-exit destination transition.

This evidence authorizes replacement of that motion path with the audited LibCamera source behavior.
