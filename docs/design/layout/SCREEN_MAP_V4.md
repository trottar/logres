# Phase H.2 — User-approved screen map, draft v4

Status: **APPROVED DESIGN BASELINE — NOT YET RUNTIME-IMPLEMENTED**
Accepted: 2026-10-11
Source: user-supplied interactive map export, with explicitly agreed Main Bar Y correction 60.3% → 60.4%.
Machine-readable authority: [`SCREEN_MAP_V4.json`](SCREEN_MAP_V4.json).
Decision: `../../memory/decisions/D-045_H2_SCREEN_MAP_V4.md`.

## Coordinate convention

- Rectangles specify **left x, top y, width w, height h**, each as a **percentage** of full screen extent.
- Origin (0,0) is upper-left; x increases rightward and y increases downward. Screen extends to (100,100).
- Reference canvas is **16:9**; x/w are percentages of viewport width, y/h of viewport height. These are normalized *planning boxes*, not pixel sizes or WoW UIParent coordinates.
- This baseline is for one authored whole-screen composition, not a generic end-user layout editor or a promise of pixel-perfect geometry at every UI scale.
- All values below are literal accepted percentages; do not silently move or resize boxes when translating to Lua. Any changes require an explicit documented calibration decision.

## Approved rectangles

| ID | Component | X% | Y% | W% | H% |
| --- | --- | ---: | ---: | ---: | ---: |
| `compass` | Compass | 31.4 | 4.8 | 37.4 | 6.9 |
| `quest` | Quest Tracker | 80.0 | 5.0 | 19.6 | 19.2 |
| `enemy-debuff` | Enemy Debuffs | 65.2 | 40.0 | 6.0 | 9.0 |
| `enemy` | Enemy Frame | 72.0 | 40.0 | 13.0 | 9.0 |
| `enemy-buff` | Enemy Buffs | 85.8 | 40.0 | 6.0 | 9.0 |
| `group` | Group / Pet Frame | 21.0 | 32.7 | 9.0 | 25.9 |
| `class` | Class / Totems / etc | 5.1 | 53.5 | 12.0 | 5.0 |
| `secondary` | Secondary Bars | 5.1 | 60.4 | 12.0 | 38.0 |
| `main` | Main Bar | 18.2 | 60.4 | 12.0 | 38.0 |
| `player-debuff` | Player Debuffs | 39.5 | 81.0 | 22.5 | 5.8 |
| `resource` | Player Resource | 39.5 | 88.3 | 22.5 | 6.0 |
| `player-buff` | Player Buffs | 76.0 | 80.5 | 23.4 | 6.2 |
| `utility` | Utility | 76.0 | 88.2 | 23.4 | 9.3 |

## Approved relationships and meanings

- **Target fallback** is deliberately **right of center**; it is not centered on the screen. Left: enemy debuffs (`x=65.2`, `w=6`), target (`x=72`, `w=13`), right: enemy buffs (`x=85.8`, `w=6`), all at `y=40`, `h=9`. There is exactly **0.8% screen-width gap** on either side. Buffs and debuffs remain associated with the enemy frame. This geometry is for the **screen-space target fallback**, not authorization to abandon D-032's future world-attached target direction.
- **Actions** occupy the lower-left: Secondary `x=5.1`, Main `x=18.2`; both `y=60.4`, `w=12`, `h=38`, separated by 1.1% horizontal screen width. “Main Bar” is the design label for the Logres-owned primary control group, not a request to retain the Blizzard `MainActionBar` stock shell.
- **Player class/totem/etc** strip is above the left action clusters, at `(5.1,53.5,12,5)`. Class/pet/stance/totem controls remain separate capability domains; this box is not an authorization to replace native special controls.
- **Group/Pet Frame** at `(21,32.7,9,25.9)` remains a conceptual planning territory. Preserve Blizzard Party/CompactPartyFrame and pet fallbacks until interaction/information replacement is independently proven.
- **Player debuffs** `(39.5,81,22.5,5.8)` sit **directly above** **Player Resource** `(39.5,88.3,22.5,6)`, both centered on the lower screen, with 1.5% vertical gap. Do not move this stack above the left action bars. Player resource is **not player HP**; player health remains the peripheral health tunnel, never a conventional health bar.
- **Player Buffs** `(76,80.5,23.4,6.2)` appear above **Utility** `(76,88.2,23.4,9.3)` on the lower right, with 1.5% vertical gap.
- **Compass** top-center; **Quest Tracker** upper-right. The “Quest Tracker” box represents the optional Logres Active Quest current-focus presentation; it does **not** authorize suppressing the Blizzard full tracker or quest log without dedicated capability and fallback.
- Every box is a *design envelope*, not proof of runtime density, native fallback fit, hit areas, or readability. Test real 12-button Primary/Secondary/Utility densities and UI scaling. Extra Bar 4–5 and native/special controls retain their separate proven ownership semantics and safe fallback.

## Runtime translation gate (next H.2 work)

`Logres/Integration/Layout.lua` still uses P0166's preexisting pixel-offset semantic anchors. This file **does not** change those anchors. Next work: inventory actual Logres widget extent and in-game layout at ordinary density/scale, map each v4 planning rectangle to its corresponding eligible integration anchor, check collision/interaction against required native stock fallbacks, and propose bounded, out-of-combat/fail-open changes. Do not infer WoW anchor pixel offsets from a percentage-only sketch without accounting for UI scale and widget point/size.

## Evidence limits / historical errors

This visual planning exercise initially misplaced Player Resource/Debuffs near the left action cluster and incorrectly centered the target. Those were **rejected interpretations**, not authoritative design choices. This v4 JSON supersedes those layouts and the v3 Main Y of 60.3%. No runtime positioning or collision test was performed in this docs-only checkpoint; H.2 runtime validation remains **OPEN**.
