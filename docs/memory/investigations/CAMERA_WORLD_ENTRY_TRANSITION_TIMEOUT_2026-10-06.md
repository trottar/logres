# Camera World-Entry Transition Timeout — 2026-10-06

Status: **REPRODUCED — P0154 DIAGNOSTIC PASS; P0155 DIRECTION-SWITCH CORRECTION PREPARED**

## Initial trigger

The final integrated Run All used to validate P0152 R12 recorded a `Camera World/Combat` transition timeout after `PLAYER_ENTERING_WORLD` on `0.0.74-dev` / Forever `1.60.1.70235`.

Initial observation:
- requested/effective target `5`;
- start about `6.812`;
- final about `6.753` after about `3.254s`;
- target not reached;
- one failure;
- error `camera transition timed out before target`.

P0152 did not modify `Logres/Camera/`, so the initial event was correctly classified as OPEN / INTERMITTENT / UNREPRODUCED pending targeted retest.

## Targeted reproduction

P0153 required one normal `/reload`, Phase G **Camera World/Combat Check**, and a separate Phase 0 **Run All**.

That retest reproduced the failure on loadCount `182`:
- start about `8.524`;
- requested/effective target `5`;
- final/current about `12.632`;
- elapsed about `3.258s`;
- `targetReached=false`;
- `failures=1`;
- no secret-value failure.

Classification became **REPRODUCED RUNTIME FAILURE**.

## P0154 diagnostic result

P0154 is verified durable at `40dec1874a587156c88319a9caed940088e25db7` on `0.0.75-dev`.

After normal `/reload`, loadCount `184` reported:
- start `23.147617340088`;
- requested/effective target `5`;
- final/current `50`;
- elapsed about `3.252s`;
- `145` transition samples;
- `1` sample moved toward target, `1` away, `143` were flat;
- minimum observed zoom `0`, maximum `50`;
- final/max easing position error `45`;
- last command inward;
- `142` inward commands and `1` outward command.

The separate Run All preserved the same camera failure while its other listed checks passed.

This is a **P0154 DIAGNOSTIC PASS** because the intended command-versus-observed evidence was captured without hiding the failure.

## Narrow cause

The original P0154 hypothesis expected inward commands only. Runtime instead produced one outward command because the observed camera crossed below target during the world-entry displacement (`min=0`) before later reaching `50`.

That exposes a concrete P0119 driver defect:

- crossed-target correction is allowed to reverse direction;
- `ApplyTransitionMotion()` starts the new MoveView direction;
- but it does not stop the previous MoveView direction when that reversal occurs;
- the previous direction is otherwise stopped only during full transition cleanup.

Therefore an outward correction can remain active while later inward commands are issued. The `1` outward plus `142` inward command sequence is direct evidence that this path occurred.

The source of the discrete `0/50` world-entry displacement remains unproven and is not attributed to Blizzard, Logres, or another addon without further evidence.

## P0155 corrective contract

P0155 changes only direction-switch hygiene:
- on `in -> out` or `out -> in`, stop/reset the previously active MoveView direction before starting the new one;
- count direction switches in addon-owned diagnostics;
- fail open through existing transition cleanup if the directional stop fails;
- preserve P0154 motion diagnostics;
- preserve all existing targets, durations, timeout policy, context priority, coexistence gates, Taxi semantics, and CVar policy.

Not authorized:
- polling/tickers;
- arbitrary world-entry delay;
- broad event hooks;
- periodic reassertion;
- positional rebasing yet;
- SetCVar;
- Taxi rotation or UI fade.

## Runtime gate

After P0155:
1. normal `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All** separately;
4. preserve diagnostics.

PASS requires convergence near target `5`, `failures=0`, `secret=false`, and no Lua/taint/protected-action failure. If it still times out, the retained motion line and switch count become the next narrowing evidence.
