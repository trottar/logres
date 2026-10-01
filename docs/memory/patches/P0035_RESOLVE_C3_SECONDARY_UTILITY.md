# P0035 — Resolve C.3 secondary / utility architecture

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Trigger

P0034 was pushed at `daf6a56`.

C.3 required slot/binding/reuse resolution before adding more protected code.

## Source result

Initial Secondary:
- slots 61–72;
- MULTIACTIONBAR1BUTTON1–12.

Initial Utility:
- slots 49–60;
- MULTIACTIONBAR2BUTTON1–12.

These are source-derived candidate mappings and require Forever runtime proof.

## Architecture

C.3 will:
- extract reusable secure button/presentation construction;
- preserve Primary's proven page/binding orchestration;
- add fixed-slot Secondary/Utility modules;
- add separate fail-open routing controls;
- keep stock bars visible.

## Scope boundary

Initial C.3 does not cover stock Action Bars 4–8.

C.4 owns context-driven visibility.

## Code changes

None.

## Deployment

No redeploy required.
