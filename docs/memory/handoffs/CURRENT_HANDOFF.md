# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.3.**

P0099 is verified pushed at:
`10c7255f`.

Current pushed runtime:
`0.0.40-dev`.

P0100 runtime target:
`0.0.41-dev`.

G.2:
**CLOSED — RUNTIME + INTEGRATION PASS.**

P0100 adds production World/Combat camera ownership:
- World conditional target 5;
- World (Combat) conditional target 15;
- ordinary transition 2.5 seconds;
- zoom restore never;
- live UnitAffectingCombat combat selection;
- targeted combat/restriction event reevaluation;
- primary MoveView path only;
- no temporary-CVar fallback;
- explicit interruption/disable/failure stop;
- DynamicCam coexistence gate;
- manual G.2 probe mutually gated from production controller;
- developer Check/Reconcile/ON/OFF diagnostics.

P0100 is a runtime-code patch. After verified push it must be deployed before
WoW validation.

Future Phase H+ D-032 layout and D-033 World Ghost art-direction work remains
parallel and does not alter G.3 acceptance.

User performs all commits/pushes.
