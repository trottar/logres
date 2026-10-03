# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

Current pushed runtime:
`0.0.43-dev` from P0105 at `69560080`.

Current remote baseline before P0107:
`b2fce832ef689ebf70732bc8a9f1c07fa11faa35` (P0106 docs-only).

G.4:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Canonical runtime evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`.

Accepted G.4 proof:
- automatic resting -> City selection;
- clean City >5 -> target 5 transition;
- City <=5 no-op;
- City exit fresh destination evaluation / no remembered restore;
- Run All;
- DynamicCam coexistence;
- clean addon-owned failure/secret/error diagnostics.

The first City `18 -> 0` observation remains preserved as ambiguous environmental
evidence; a later targeted retest from about `13.090` completed near `5.178` with
`targetReached=true`.

Natural combat + resting overlap remains an environmental deferral; static
live-combat-before-City ordering remains enforced.

G.5:
**ACTIVE — TAXI CONTRACT REVIEW; NO RUNTIME CODE YET.**

Known profile starting point:
- Taxi `160`, priority `1000`;
- on-taxi activation;
- enter/exit `5`;
- conditional-out target `50`;
- rotation speed `-20`;
- UI hide/fade stored;
- restore `never`.

Next: audit DynamicCam source + captured profile for Taxi precedence,
transition/exit semantics, target-50 capability/CVar boundaries, rotation scope,
presentation separation, and smallest runtime proof.

The existing Taxi fail-open exclusion remains authoritative until that contract is
resolved.

User performs all commits/pushes.
