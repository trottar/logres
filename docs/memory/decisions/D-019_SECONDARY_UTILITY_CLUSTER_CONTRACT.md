# D-019 — Secondary / utility cluster contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

The first C.3 implementation adds two secure fixed-slot clusters around the
proven Primary Cluster.

### Secondary

Maps:
- action slots `61–72`;
- binding commands `MULTIACTIONBAR1BUTTON1–12`.

### Utility

Maps:
- action slots `49–60`;
- binding commands `MULTIACTIONBAR2BUTTON1–12`.

These mappings are transport contracts, not semantic claims about the actions
the user stores in those slots.

## Geometry

Initial layout:

```text
Secondary      Primary       Utility
   3 x 4         4 x 3         3 x 4
```

Candidate center anchors:
- Secondary `(-190, -260)`;
- Primary `(0, -260)`;
- Utility `(190, -260)`.

Exact positions remain runtime-tunable.

## Shared implementation boundary

C.3 should create a reusable secure action-button presentation primitive.

Share:
- protected button template setup;
- click/release attributes;
- icon construction;
- cooldown construction;
- count text;
- hotkey text;
- checked state;
- action registration;
- icon/count/cooldown/usability/range update helpers.

Do not wholesale replace Primary's proven:
- page orchestration;
- pending page refresh;
- primary binding-routing behavior.

Primary may adopt shared presentation helpers incrementally.

## Binding policy

Default:
- Secondary key routing OFF;
- Utility key routing OFF.

Developer panel exposes explicit:
- Secondary Keys ON/OFF;
- Utility Keys ON/OFF.

This mirrors L-011 fail-open behavior.

Temporary routing uses the stock binding commands for the selected domains.

No saved binding rewrite.

## Visibility policy

C.3 does not own dynamic context visibility.

Static initial weighting is allowed.

C.4 owns:
- world fade policy;
- combat visibility;
- PvP modifier;
- instance policy;
- secure visibility/state drivers where needed.

## Stock UI

No stock multi-bar suppression in C.3.

Bars not yet represented by Logres remain especially non-suppressible.

D-017 remains authoritative.

## Deferred action-bar coverage

Initial C.3 does not represent stock Action Bars 4–8.

Before C.5 suppresses stock bars, Logres must either:
- represent every stock action domain the user depends on;
- or deliberately leave unsupported stock surfaces visible.

No required action may disappear because Logres only implemented part of the
stock bar set.
