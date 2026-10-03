# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.3.**

P0100 is verified pushed at:
`31a2a7f`.

Current pushed runtime:
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

P0100 is verified pushed. Deploy `0.0.41-dev` before WoW validation.

Future Phase H+ D-032 layout, D-033 World Ghost, and D-034 Selective Hybrid E / visual-component work remain parallel and do not alter G.3 acceptance.

User performs all commits/pushes.
