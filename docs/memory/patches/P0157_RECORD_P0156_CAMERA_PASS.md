# P0157 — Record P0156 Camera Pass

Date: 2026-10-06
Baseline: `e1be731bd64db2acb62480f62fafaea58515989f`
Result: **R2 PREPARED — DOCS / EVIDENCE + MEMORY-SCHEMA CHECKER HARDENING**

## Purpose

Record the accepted P0156 normal-world-entry runtime result without changing WoW runtime code, preserve two rolled-back P0157 delivery failures, and harden CURRENT-schema validation.

Runtime evidence:
`../evidence/P0157_P0156_WORLD_ENTRY_CAMERA_PASS_2026-10-06.md`.

Delivery evidence:
`../evidence/P0157_DELIVERY_FAILURES_2026-10-06.md`.

## Accepted observation

On `0.0.77-dev` / loadCount `187`:
- Phase G Camera World/Combat Check PASS;
- world start/current/final about `5.0795`;
- requested/effective target `5`;
- targetReached=true;
- failures=0;
- secret=false;
- error=nil;
- motion `armZoom≈5.0795`, `firstDelay=0`, `switches=0`;
- separate Run All clean.

## Delivery correction

Initial P0157 omitted a required CURRENT schema section.

R1 restored the real heading but the checker used raw substring counting and also counted an inline prose mention, producing a duplicate-count failure.

R2:
- counts actual Markdown heading lines in memory health;
- pre-validates the rendered CURRENT candidate;
- validates the whole candidate in a temporary `git archive` checkout before working-tree mutation;
- records the reusable lesson in MAINTENANCE and LEARNINGS.

## Scope

P0157 R2:
- marks P0156 installed/pushed and accepted for observed normal-world-entry scope;
- closes the reproduced world-entry regression for current evidence;
- preserves P0154/P0155 failures;
- explicitly does not claim runtime proof of a large first-delay branch or direction switch;
- returns Phase G.5 to the pending P0119 normal-Taxi landing retest.

No WoW runtime files are changed. No WoW redeploy is required.
