# P0425 — Compact NPC presentation corrections

Date 2026-11-09, verified baseline `80b46f49dd71feb3a499b1885499b82ce744a2dd`.

## Observed runtime regression

Uploaded `LOGRES_BUG_REPORT_LATEST.zip` contains incident screenshots:
- 9547 (20:44:40 EST): compact merchant, native buyback-item icon crosses the
  horizontal footer divider; merchant audit `live=true`, tabs/pager styled.
- 9549 (20:44:49 EST): Buyback tab selected; the sidebar tab row is too low.
- 9565 (20:45:02 EST): trainer still 896×712; audit `shown=true`,
  `displays=2`, `last=live-native-parking-requested`.

P0424 deliberately left trainer at 896×712, contrary to user's expectation
for the modular NPC shell. The buyback item root was not included in P0424's
reversible native-geometry capture. User-reported visual symptoms are directly
supported by the screenshots; transactions are not newly verified.

## Correction

Raise both Merchant/Buyback tabs to the same top Y=128; separately capture and
reposition `MerchantBuyBackItem` to Y405 in the vendor catalogue above the
Y468 footer rule. Require known native ownership and ordinary mutable
geometry; preserve the original points as opaque restoration tokens. Stock
remains available on any inability to capture/mutate. Native scripts remain
Blizzard-owned. Use the shared `TrainerPanelConfig` and `PanelSurface` to
reflow the addon-owned seven-row trainer at 820×660; keep every row and native
training handoff, scrollbar, filters and controls. No HUD V8 changes.

## Static and runtime boundary

Static contracts test geometry, exact seven-row bounds, native restoration,
no transaction calls, version parity, issue ledger and rollout docs. The
gameplay state remains **UNVERIFIED** until a live merchant/trainer retest.
L-003 remains PARTIAL/OPEN. L-033 is a separate training issue and remains OPEN.

## R0 prewrite refusal and R1 corrective packaging (2026-11-09)

User ran P0425 R0 guard on clean P0424 baseline. Guard returned **248/293
STATIC PASS / PREWRITE REFUSED; no tracked writes**. Failures included
`check_checker_version_policy.py` rejecting an exact runtime-version pin in the
new P0425 contract, historical P0281 geometry tokens not fully translated,
multiple CURRENT.md maintenance-budget checks (candidate exceeded 9800 bytes),
and the new P0425 contract expecting a P0425 marker in its design doc. These
are author-side preflight omissions, not demonstrated WoW runtime failures.
P0425 R1 removes the version pin, updates historical source tokens only where
trainer geometry deliberately changes, reduces CURRENT.md below the budget,
and repairs the design-doc marker. Retain this negative result after success.
