# P0421 — apply user-authored V6 layout refinements

Baseline: GitHub main `bd55e34e823abadd093930aa184fcd14e0f64ab0`.

Translate 15 approved user adjustments into addon-owned runtime anchors,
correctly respecting top/top-right/left semantic binding conventions, and
preserve the four unchanged V5 component centers. Three action-bar centers
move without changing grid, source slots, secure routing, keys, or roles.
The P0420 expected-vs-measured H.2 overlay remains read-only and source-backed.
Add V6 canonical JSON and original user export, a scoped static contract,
and evidence/roadmap/patch history. Version advances one development unit.

WoW Forever runtime UNVERIFIED until user validation. The prior P0417 pet
regression remains scoped PASS only, with L-008 edge tests OPEN; L-009 live
editor DEFERRED.
