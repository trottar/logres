# P0047 — Resolve D.1 immersion orchestration

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Baseline

P0046 verified pushed at `8ad0f01`.

Runtime remains:
`0.0.20-dev`

## Result

D.1 source review complete.

D-024 accepted.

Immediate Phase D safe domains:
- persisted immersion preference orchestration;
- proven stock Bar 2–3 replacement;
- runtime-only Quiet Mode chat/tab suppression.

## Important capability blocks

### Player

Do not suppress the full PlayerFrame.

Blizzard parents class-resource/rune/totem/pet surfaces to it that Logres does
not fully replace.

### Target

Do not suppress the full TargetFrame yet.

It provides secure target/menu interaction and target aura/context
presentation beyond the current Logres target block.

### Party

Do not suppress normal or compact party frames yet.

Their members are secure unit buttons; current Logres ally rows are not.

## Next

D.2:
Immersion Controller runtime foundation + automatic orchestration of proven
Bar 2–3 replacement.

No runtime code in P0047.

No redeploy required.
