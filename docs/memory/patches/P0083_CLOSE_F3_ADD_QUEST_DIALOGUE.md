# P0083 — Close F.3 / Add NPC Quest Detail Presentation

Date: 2026-10-02
Result: INSTALLED / PUSHED — F.4 RUNTIME PASS / RESTORATION FAIL (`484323bb`)

## F.3

Closed:
RUNTIME + INTEGRATION + VISUAL PASS.

## F.4

Added additive QuestDialogue production presentation and developer-panel
diagnostics.

Runtime PASS:
- Preview;
- real quest `436` detail;
- body/objective;
- accepted cleanup;
- Immersion policy;
- Quest Dialogue Check.

Visual acceptance remains pending.

## Integrated result

Run All failed Restoration Check.

P0081 diagnostics captured the exact TargetFrame error:
secret-capable IgnoreParentAlpha restoration token rejected by
`SetIgnoreParentAlpha`.

QuestDialogue itself remained PASS.

## Delivery repair

The first apply attempt failed because the older F.3 checker froze the runtime
at `0.0.31-dev`.

The repair changed feature checkers to validate Bootstrap/TOC version
synchronization instead.

## Next

P0084 corrects the root-caused TargetFrame restoration path.
