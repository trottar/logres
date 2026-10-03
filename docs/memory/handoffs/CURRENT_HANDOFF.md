# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.4.**

Current pushed checkpoint:
P0102 at `20ad55ba`, runtime `0.0.42-dev`.

G.3:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Final `0.0.42-dev` evidence proves World >5 transition, World <=5 no-op,
automatic live-combat transition, combat >=15 no-op, fresh World behavior on
combat exit, disable interruption with `stop=module-disabled`, Run All PASS, and
DynamicCam coexistence blocking. Addon-owned diagnostics ended with
`failures=0`, `secret=false`, and `error=nil`.

Canonical evidence:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`.

The earlier P0100 resting/City observation remains an environmental deferral and
is retained as historical evidence.

Next work item:
**G.4 City camera ownership contract review.**

Use the captured DynamicCam profile and existing resting sensor to define the
smallest City camera slice. Preserve live-combat precedence. Do not silently
import DynamicCam City UI hide/fade into camera ownership; resolve that as an
explicit presentation-policy question first.

P0103 is docs/evidence only. No WoW redeploy is required for P0103.

User performs all commits/pushes.
