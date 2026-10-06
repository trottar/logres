# Camera World-Entry Transition Timeout — 2026-10-06

Status: **OPEN / INTERMITTENT / UNREPRODUCED**

## Trigger

The final integrated Run All used to validate the accepted P0152 R12 pet-action result recorded one `Camera World/Combat` transition timeout after `PLAYER_ENTERING_WORLD` on `0.0.74-dev` / Forever `1.60.1.70235`.

## Observed result

The camera diagnostic reported:
- World context owned by Logres;
- transition no longer active when checked;
- last action/stop reason `transition-timeout`;
- requested/effective target `5`;
- start about `6.812`;
- final about `6.753` after about `3.254s`;
- target not reached;
- one failure;
- no secret-value failure;
- error `camera transition timed out before target`.

Prior camera checks in the same project history had passed. P0152 did not modify `Logres/Camera/` runtime files, so no causal link to the pet patch is established.

## Classification

This is a real observed failure but only one occurrence. Per project evidence rules it is not yet a reproduced defect and must remain **OPEN / INTERMITTENT / UNREPRODUCED**.

Do not respond with polling, periodic reassertion, broad hooks, duration inflation, or any other speculative fix without recurrence and a narrow cause.

## Targeted next diagnostic

Use normal world-entry behavior only:
1. `/reload`;
2. developer panel -> Phase G -> **Camera World/Combat Check**;
3. developer panel -> Phase 0 -> **Run All** separately;
4. preserve refreshed diagnostics.

If the timeout recurs, narrow the transition-driver cause using addon-owned diagnostic state before changing runtime code. If the retest is clean, preserve this record as intermittent/unreproduced and continue without a code change.

No travel or contrived gameplay is required solely to reproduce this event.
