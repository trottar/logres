# P0135 — Aura / Status Source + Priority-Policy Audit

Date: 2026-10-05
Result: **SOURCE + POLICY LAYER RESOLVED — P0136 READ-ONLY RUNTIME PROBE NEXT**
Baseline: `93b43d4bed2ff97a07cc0d9687f7d99ed474d0f2`
Runtime: unchanged at `0.0.65-dev`

## Purpose

Resolve the source, secrecy, event, priority, and fallback contract for the next
approved aura/status visual domain before adding any runtime replacement surface.

Canonical evidence:
`../evidence/P0135_AURA_STATUS_SOURCE_PRIORITY_AUDIT_2026-10-05.md`.

Accepted decision:
`../decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`.

## Source pin

Upstream Forever UI source:
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1`, build `70205`).

This matches the tested client generation.

## Result

Source/API layer:
**RESOLVED.**

Secret handling:
**RESOLVED — per-aura preflight is mandatory.**

Priority policy:
**RESOLVED for capability/probe sequencing.**

Production ownership:
**NOT PROVEN.**

Stock suppression:
**NOT AUTHORIZED.**

## Next

P0136 read-only aura/status runtime probe:
- player + target;
- event-driven;
- bounded index scans;
- secret predicate before payload read;
- source-defined semantic filters;
- addon-owned diagnostics only;
- no Blizzard UI mutation/suppression.
