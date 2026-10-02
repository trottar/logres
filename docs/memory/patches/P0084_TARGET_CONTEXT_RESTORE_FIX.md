# P0084 — Target Context Restoration Fix

Date: 2026-10-02
Result: INSTALLED / PUSHED — RUNTIME PASS (`a74329a`)

## Baseline

P0083:
`484323bb19e589d4987bbc25d703c856d6cfbf6b`

## Trigger

P0083 captured:
`SetIgnoreParentAlpha` rejecting a secret-capable restoration token.

## Correction

Removed IgnoreParentAlpha mutation from TargetFrame replacement.

Preserved and untouched:
- Auras;
- RaidTargetIcon;
- QuestIcon;
- PingIconFrame.

Alpha-suppressed individually:
- HighLevelTexture;
- LeaderIcon;
- GuideIcon;
- BossIcon;
- PvpIcon;
- PrestigePortrait;
- PrestigeBadge;
- PetBattleIcon;
- NumericalThreat.

The contextual parent is no longer alpha-zeroed.

Runtime:
`0.0.33-dev`.

## Runtime result

PASS:
- Target Frame Check:
  `contextualSuppressed=9`, `preserved=4`;
- standalone Restoration Check twice;
- three consecutive Run All executions;
- no recurrence of the old secret-value setter failure.

The associated restoration investigation is CLOSED.

## Delivery history

Three static delivery/preflight failures occurred while preparing P0084:
1. incorrect Target debug anchor;
2. repair used an invalid prose-state marker;
3. an over-broad checker produced a false positive on unrelated
   `overrides=%s` diagnostics.

All were static delivery failures.
They produced no additional WoW runtime evidence.

The final recovery used exact state classification and temporary-tree validation
before working-tree mutation.

## Non-scope

No:
- retry;
- polling;
- periodic reassertion;
- broad hook;
- target-of-target suppression;
- Focus/boss/party suppression.

The separate TargetFrame reappearance issue remains independently tracked.
