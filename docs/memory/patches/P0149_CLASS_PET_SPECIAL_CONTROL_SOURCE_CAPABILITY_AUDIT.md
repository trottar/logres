# P0149 — Class / Pet / Special-Control Source-Capability Audit

Date: 2026-10-05
Baseline: `6f381a77f857cb9305cf6870fc2621e6aff826dc`
Runtime: unchanged at `0.0.72-dev`
Result: **PREPARED — SOURCE/CAPABILITY LAYER RESOLVED; P0150 READ-ONLY RUNTIME PROBE NEXT**

## Purpose

Close the accepted P0148 manual-waypoint visual gate in durable memory, then resolve
the source/ownership boundary for the residual class/pet/special-control inventory
without changing runtime behavior.

## P0148 acceptance recorded

P0148 is accepted as the production manual-waypoint depth baseline:
- far observed at depth/render `0.700`;
- medium observed at `0.875`;
- close observed at depth `1.200`, render up to `1.280`;
- integrated `Run All` PASS;
- explicit user visual confirmation that the size cue now works.

Further amplitude tuning is deferred to later whole-interface polish.

## P0149 source audit

Pinned source:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`).

P0149 adds:
- canonical source evidence;
- D-044 source/fallback policy;
- resolved class/pet/special investigation state;
- P0150 bounded read-only probe definition.

No runtime code, frame suppression, action mutation, or WoW deployment is part of
this checkpoint.

## Next

After this checkpoint is committed/pushed and verified, prepare P0150 diagnostic
runtime proof only.
