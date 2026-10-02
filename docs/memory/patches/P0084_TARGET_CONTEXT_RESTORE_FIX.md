# P0084 — Target Context Restoration Fix

Date: 2026-10-02
Result: PREPARED — RUNTIME RETEST PENDING

## Baseline

P0083 verified pushed:
`484323bb19e589d4987bbc25d703c856d6cfbf6b`

## Trigger

P0083 captured:
`SetIgnoreParentAlpha` rejecting a secret-capable restoration token.

## Correction

Remove IgnoreParentAlpha mutation from TargetFrame replacement.

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

Each suppressed child's alpha is captured/restored as an opaque token.

The contextual parent is no longer alpha-zeroed.

## Diagnostics

Track:
`contextualSuppressedCount`.

Expected:
- active `9`;
- restored `0`.

## Non-scope

No retry, polling, periodic reassertion, broad hook, target-of-target
suppression, Focus/boss/party suppression, or QuestDialogue behavior change.

## Runtime

`0.0.32-dev -> 0.0.33-dev`.

Runtime retest required.

## Delivery recovery

Three static delivery/preflight failures occurred before a valid P0084 checkpoint:

1. `Target debug count anchor mismatch`;
2. repair preflight used a prose marker that did not exist in the exact partial
   P0084 CURRENT payload;
3. temporary-tree validation exposed an over-broad checker that treated
   unrelated action-binding `overrides=%s` diagnostics as obsolete TargetFrame
   state.

Neither failure produced new WoW runtime evidence.

The final recovery applier is deliberately different:
- exact byte-state classification;
- no prose-marker assumptions;
- runtime files reconstructed from verified P0083 HEAD;
- complete intended tree validated in a temporary `git archive` before working
  tree mutation;
- unknown patch-owned state refused before writes.

Recovery v2 scopes the obsolete-label check to
`restorationMismatchSummary` and requires the intended label replacement
to occur exactly once before validation.

Evidence:
`../evidence/P0084_DELIVERY_FAILURE_2026-10-02.md`.

