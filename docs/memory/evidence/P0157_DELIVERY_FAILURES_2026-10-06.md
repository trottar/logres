# P0157 — Delivery Failures — 2026-10-06

Status: **TWO STATIC DELIVERY FAILURES — BOTH ROLLED BACK**
Baseline: `e1be731bd64db2acb62480f62fafaea58515989f`

## Initial artifact

Memory health failed because generated `CURRENT.md` omitted a canonical schema
section. The checker reported a zero occurrence count for Success Criteria.

The applier rolled back. No tracked P0157 changes survived.

## R1 artifact

R1 added the missing real heading, but its generated CURRENT prose also quoted
the literal Markdown heading token while describing the initial failure.

At that time `tools/check_memory_health.py` used:

`text.count(heading)`

Therefore the real heading plus the inline prose mention produced a count of two.

Observed result:

`ERROR: CURRENT heading '## Success Criteria' occurs 2 times; expected exactly 1`

The R1 applier also rolled back. The following worktree status again showed only
the pre-existing untracked `LOGRES_DIAGNOSTICS_LATEST.lua`.

## Root cause

This is a repeated generated-memory delivery defect, not camera runtime evidence.

Repository memory already established:
- P0078 failed after omitting canonical CURRENT sections;
- P0087 failed after omitting Success Criteria;
- MAINTENANCE requires each canonical CURRENT section exactly once.

R1 failed because the delivery correction treated a raw substring count as if it
were a Markdown-heading count.

## R2 correction

R2:
- validates the rendered CURRENT candidate against actual heading lines before any write;
- changes memory health to count actual Markdown heading lines;
- runs memory health and applicable repository checks in a temporary `git archive`
  checkout before mutating the real worktree;
- records L-019 as the reusable generated-memory lesson;
- preserves both failed P0157 deliveries.
