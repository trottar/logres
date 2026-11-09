# P0423 — Pet/party status frame correction; reverse unintended pet-bar movement

Date: 2026-11-09. Exact verified parent baseline:
`b8428a36fd091a7b70ed413afdd3434e082f1767` (P0422).

## Observed failure

The user supplied a P0422 gameplay screenshot and explicitly clarified that
the action bar was moved in error. The intended one-point rightward spacing
adjustment concerned the pet/party **status frame**, not the pet-action bar.
This is a genuine interpretation/regression in P0422 visual placement. It does
not show the separate Blizzard PetFrame/PetActionBar suppression defect.

## Narrow correction

`Logres/Integration/Layout.lua` `H2_APPROVED_ANCHORS`:

- `classPet` / `petActions`: center X=10 -> 9, Y=50 unchanged (restore P0421)
- `allies` / `group`: center X=24 remains, Y=50 unchanged (+1 from P0421)
- All 17 other screen-map regions unchanged from V7.

V8 JSON is the current runtime mapping authority. V7 and P0422 evidence remain
preserved. Static contracts check that V8 differs from V7 in exactly one field,
while preserving existing out-of-combat geometry, action slots, keybinds, pet
suppression and all native fallback boundaries. The only actual gameplay code
change is the addon-owned `classPet` coordinate (plus version/diagnostic tag).

## Acceptance / pending

WoW Forever runtime P0423 **UNVERIFIED**. After deploy and `/reload`, confirm
pet actions return to P0421 location, the party/status frame remains 1% right,
Blizzard pet UI stays suppressed, and Logres pet buttons work. No broader
pet/combat/stock recovery PASS is inferred from a screenshot alone.
