# Five-bar Logres authored action layout v1 — P0416

Status: **USER-APPROVED SOURCE MAPPING / STATIC CANDIDATE — WOW UNVERIFIED**.
Baseline: main `43efc89b8651d278630d48517fb6101ca4d14a74` (P0415).
Machine-readable user input: `ACTION_BARS_V1.json`.

Centers use `UIParent` width/height, origin top-left, percentages as specified.
Every grid contains 12 supported secure action buttons. Sources and roles are
independent: Bar 1 fixed Primary; Bar 2 and Bar 4 Secondary; Bar 3 and Bar 5
Utility. Each has scale 1. Do not interpret this input as authorization to
rewrite action-slot contents or persistent Blizzard keybindings.

| Source | Role | Grid | Center X% | Center Y% | Scale |
|---|---|---|---:|---:|---:|
| Bar 1 | Primary | 3x4 | 13 | 75 | 1 |
| Bar 2 | Secondary | 2x6 | 5 | 75 | 1 |
| Bar 3 | Utility | 6x2 | 90 | 85 | 1 |
| Bar 4 | Secondary | 6x2 | 10 | 95 | 1 |
| Bar 5 | Utility | 6x2 | 90 | 95 | 1 |

Implementation is **an authored import at patch/deploy time**, not a new
in-game editing surface or live Save action. The source-of-truth table lives in
`Integration/Layout.lua`; the existing Primary, SecondaryUtility and Context
modules consume its independent copies. P0195's 13-region whole-screen map is
unchanged. Supported extra stock bar source availability still gates Bar 4/5.

The out-of-combat viewport gate checks authored frame extents using ordinary
UIParent geometry and Logres theme sizes, including a small border margin and
cluster-to-cluster gap. If dimensions are unreadable or a profile would clip,
layout refuses or restores the legacy static anchors. Resizing, UI scaling, and
combat exit use existing event-driven recomputation; there is no polling.
This fallback may display the legacy layout rather than the requested positions
on a smaller viewport. The actual game client still requires screenshot/click
validation for hitboxes, overlapping non-action UI, and stock fallback.

D-032 limits general-purpose editing; if users want unrestricted future layouts,
that would require a separate design decision, secure editor and input schema.
