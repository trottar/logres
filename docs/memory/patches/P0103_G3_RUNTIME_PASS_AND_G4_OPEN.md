# P0103 — Close G.3 Runtime Proof and Open G.4

Date: 2026-10-03
Result: INSTALLED / PUSHED — DOCS/EVIDENCE ONLY (`4adf400a`)

## Baseline

P0102 verified pushed:
`20ad55ba9be6d04fbd8d1eeeaa4e5e8bdb53addc`.

Runtime remains:
`0.0.42-dev`.

## Durable checkpoint

P0103 was pushed as:
`4adf400a4b2ee66a29a398f14364610288a6b4b9`.

## Purpose

Record the final P0102-runtime G.3 production evidence, close G.3 without
changing camera code, and open the next narrow Phase G work item: City camera
ownership contract review.

## G.3 result

Final runtime evidence proves:
- World >5 transition PASS;
- World <=5 no-op PASS;
- automatic live-combat <15 transition PASS;
- combat >=15 no-op PASS;
- fresh World evaluation on combat exit PASS;
- active-transition disable interruption PASS;
- Run All integration PASS;
- DynamicCam coexistence block PASS;
- no observed/reported Lua, taint, protected-action, or secret-value failure in
  the accepted sequence;
- addon-owned diagnostics ended clean (`failures=0`, `secret=false`,
  `error=nil`).

Canonical evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

The earlier resting/City environmental deferral is preserved and not rewritten.

## G.4 opening

G.4 opened as a contract review, not a runtime implementation.

The narrow question was City/resting camera ownership using the captured
DynamicCam profile and proven Logres resting sensor. Live World (Combat) remains
higher priority. DynamicCam City UI hide/fade is explicitly separated from
camera ownership until Logres presentation policy decides whether to adopt an
equivalent behavior.

Canonical investigation:
`../investigations/G4_CITY_CAMERA_OWNERSHIP.md`.

P0104 subsequently resolves that source/profile contract without changing
runtime code.

## Deployment

Docs/evidence only.

**No WoW redeploy was required.**
