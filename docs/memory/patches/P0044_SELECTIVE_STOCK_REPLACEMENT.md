# P0044 — Selective stock action replacement

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Runtime

Version:
`0.0.19-dev -> 0.0.20-dev`

Adds:
- `Actions/StockReplacement.lua`;
- Stock Replace Check;
- Stock Replace ON/OFF;
- combat-deferred requests;
- routing ownership guard;
- replacement static checker.

## Scope

Only stock Bars 2–3.

MainActionBar, OverrideActionBar, Bars 4–5, and special action surfaces remain
visible.

## Safety

Replacement defaults OFF after reload.

Matching Logres routing is enabled before suppression.

OFF restores stock state and prior routing.

No Blizzard stock settings are modified.
