# P0036 — C.3 secondary / utility clusters

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.15-dev -> 0.0.16-dev`

Adds:
- Actions/Button.lua shared secure presentation primitive;
- refactored Primary use of shared primitive;
- Secondary 3 x 4 cluster, slots 61–72;
- Utility 3 x 4 cluster, slots 49–60;
- independent temporary key routing;
- expanded Action Check;
- expanded diagnostics panel layout.

## Safety

Primary orchestration is not wholesale redesigned.

New key routing defaults OFF.

Stock Blizzard action bars remain visible.

## Runtime proof

Required:
- Primary regression-free;
- source-derived slot mapping correct on Forever;
- mouse execution on Secondary + Utility;
- keyboard routing where bindings exist;
- routing release;
- combat execution;
- no protected/taint/secret errors;
- usable layout.
