# P0089 — Fix Objective Progress Placement

Date: 2026-10-02
Result: PREPARED — REPAIR 2; RUNTIME + VISUAL RETEST PENDING

## Baseline

P0088 verified pushed:
`228b4676479d211ed61bd0a11c3fea9a8d2f3f52`.

## Runtime

`0.0.34-dev -> 0.0.35-dev`.

## Trigger

P0088 runtime/integration checks passed, but visual inspection showed the F.6
objective-progress text overlapping the lower-center Logres action cluster.

A possible post-kill `1/10` freshness concern remains OPEN / UNPROVEN because
the visible `1/10` was also the hardcoded Objective Progress Preview sample.

## Presentation correction

Presentation only:
- width `520`;
- height `32`;
- bottom of pulse anchored to top of addon-owned `LogresHUDTarget`;
- 6px gap;
- UI-center `y=-5` fallback;
- visibly synthetic Preview:
  `PREVIEW · Objective progress · 3/10`.

Unchanged:
- active quest identity selection;
- objective source;
- secret handling;
- baseline-first behavior;
- same-quest comparison;
- refresh events;
- 3-second lifetime;
- Immersion policy;
- stock Objective Tracker ownership.

No polling, ticker, delayed reread, broad hook, or watch/super-track mutation.

## Delivery history

Two P0089 artifacts were rejected by temporary-tree validation before tracked
mutation:
1. invalid generated Python in the checker;
2. checker false negative caused by demanding single-line SetPoint formatting.

Repair 2 replaces the checker from a validated payload and uses
whitespace-tolerant structural regex for the intended multiline anchors.

Evidence:
`../evidence/P0089_DELIVERY_FAILURE_2026-10-02.md`.

## Runtime retest

After verified push/deploy:
1. Objective Progress Preview placement/readability;
2. Immersion OFF/ON Preview behavior;
3. Run All twice;
4. Quest Probe for actual live objective count;
5. one natural objective change;
6. one real production F.6 pulse;
7. Quest Probe again for updated live count;
8. no duplicate production pulse without another change.

WoW redeploy required after verified push.
