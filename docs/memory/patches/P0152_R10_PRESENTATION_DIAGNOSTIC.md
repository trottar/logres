# P0152 R10 — Pet Presentation Stage Diagnostic

Date: 2026-10-06
Status: **LOCAL DIAGNOSTIC INSTALLED — PANEL HANDOFF SUPERSEDED BY R11**

R9 produced no visible presentation change after deploy and reload. R10 changes no secure pet-action routing and adds no polling, timers, stock suppression, or Blizzard presentation inspection.

It adds `/logrespetstate`, which reports addon-owned presentation/module state, decorated/pet/readable button counts, active/autocast indicator counts, default-arm attempts/results, execution-probe configured/armed/visible state when available, and each tracked button's ordinary `type`/`action` attribute shape plus sanitized pet-state booleans. Secret-capable values are checked before inspection; pet identity payload is ignored.

Interpretation gate:

- `tracked=0`: factory interception/creation path is wrong.
- `tracked>0 pet=0`: secure pet attribute assumption is wrong.
- `pet>0 readable=0`: state-read contract is wrong.
- `activeIndicators=2 autocastIndicators=1` with no visible art: draw-layer/presentation geometry is wrong.
- probe `armed/visible=false` after arm dispatch: default-on lifecycle path is wrong.

R10 is diagnostic only and cannot close P0152.

## R11 correction

The standalone slash presentation was not the accepted validation surface. R11 converts the installed diagnostic to the standard Phase H developer-panel workflow and records the failed R10 panel-delivery baseline assertion separately.
