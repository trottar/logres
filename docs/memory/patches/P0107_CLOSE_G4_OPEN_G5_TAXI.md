# P0107 — Close G.4 Runtime Proof; Open G.5 Taxi Contract Review

Date: 2026-10-03
Result: **INSTALLED / PUSHED — DOCS/EVIDENCE ONLY**
Commit: `ab83882f28f98b3d90cc6bee65e5d7c45928c536`
Baseline: `b2fce832ef689ebf70732bc8a9f1c07fa11faa35`
Runtime: `0.0.43-dev` unchanged

## Purpose

Record the accepted P0105 City runtime evidence, close G.4 as runtime +
integration PASS, preserve the ambiguous initial City observation, and open G.5
Taxi camera ownership as a source/profile contract review.

## G.4 evidence recorded

Canonical runtime evidence:
`../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`

Accepted proof covers:
- automatic resting -> City selection;
- clean City >5 conditional target-5 transition;
- City <=5 no-op;
- City exit fresh destination evaluation with no remembered restore;
- Run All integration;
- DynamicCam coexistence;
- clean addon-owned failure/secret/error diagnostics.

The first City attempt from zoom 18 ending at reported zoom 0 remains preserved
as ambiguous environmental evidence and is not rewritten as a PASS.

Natural live-combat + resting overlap remains an environmental deferral.

## G.5 opened

Next narrow work item:
**Taxi camera ownership contract review.**

Known captured-profile facts:
- Taxi situation `160`;
- priority `1000`;
- enter/exit `5`;
- conditional-out target `50`;
- rotation speed `-20`;
- UI hide/fade stored;
- restore policy `never`.

G.5 begins with source/profile review. Production runtime code waits until
precedence, transition semantics, target-50 capability/CVar boundaries, rotation
scope, and presentation separation are explicit.

## P0106 synchronization

P0106 is durable at `b2fce832`.

## Deployment

Docs/evidence only. No WoW redeploy required.
