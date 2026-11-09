# P0421 — V6 user-authored whole-screen position refinements

Date: 2026-11-09. Source: user-uploaded
`LOGRES_SCREEN_MAP_REFINEMENTS_P0421.json`, schema
`logres-screen-map-adjustment/v2`. Exact baseline pinned to verified P0420
GitHub `main` `bd55e34e823abadd093930aa184fcd14e0f64ab0`.

## Observed input and accepted direction

The user confirmed the corrected P0420 blue/gold overlay comparison but wants
real UI positions refined, not merely corrected diagnostic outlines. The user
then edited the screenshot-backed offline layout map and supplied 15 new center
coordinates. This input is the authority for P0421; no other regions are moved.

| Component ID | Logres anchor | Estimated current center | Approved V6 center | Delta (%) |
| --- | --- | --- | --- | --- |
| `bar2` | `secondaryActions` | (5, 75) | (4, 75.16) | (-1, +0.16) |
| `bar3` | `utilityActions` | (88, 85) | (89, 85) | (+1, +0) |
| `bar5` | `bar5Actions` | (88, 95) | (89, 95) | (+1, +0) |
| `petActions` | `classPet` | (10, 55) | (9, 50) | (-1, -5) |
| `compass` | `navigation` | (50.1, 9.3) | (50, 5) | (-0.1, -4.3) |
| `activeQuest` | `activeQuest` | (87.5, 12.5) | (88, 10) | (+0.5, -2.5) |
| `targetHarmful` | `targetHarmful` | (68.2, 44.5) | (70, 50) | (+1.8, +5.5) |
| `targetFallback` | `targetFallback` | (78.5, 44.5) | (80, 50) | (+1.5, +5.5) |
| `targetHelpful` | `targetHelpful` | (88.8, 44.5) | (90, 50) | (+1.2, +5.5) |
| `allies` | `allies` | (25, 45.65) | (23, 50) | (-2, +4.35) |
| `playerHarmful` | `playerHarmful` | (50.75, 83.9) | (50, 85) | (-0.75, +1.1) |
| `playerReaction` | `playerReaction` | (50.75, 91.3) | (50, 90) | (-0.75, -1.3) |
| `passiveStatus` | `passiveStatus` | (82.4, 75) | (89, 78) | (+6.6, +3) |
| `contextXP` | `contextXP` | (50, 63) | (50, 55) | (+0, -8) |
| `questDialogue` | `questDialogue` | (50, 44.7) | (50, 25) | (+0, -19.7) |

## Translation invariant

The editor's `from` values are screenshot-estimated **frame centers**,
not guaranteed to equal runtime anchor coordinates. The `to` values are the
user's desired **frame centers**. For CENTER-bound widgets the authoring center
sets the H.2 anchor directly; Bar 2/3/5 use immutable `ACTION_BAR_LAYOUT`
profile centers. For four other surfaces, shift the existing semantic H.2
anchor by the center delta `(to − from)`:

- `navigation` (`TOP`) 50.1/6.55 → 50.0/2.25;
- `activeQuest` (`TOPRIGHT`) 97.8/5.4 → 98.3/2.9;
- `questDialogue` (`TOP`) 50.0/28.0 → 50.0/8.3;
- `passiveStatus` (`LEFT`) 77.0/75.0 → 83.6/78.0.

This is source translation; it does not assume all widgets bind at their center.
The approved V5 design envelopes and P0420 intrinsic/expected read-only H.2
projection remain intact. V6 is the new runtime positioning authority;
`SCREEN_MAP_V6_REFINEMENTS.json` retains the exact uploaded data.

## Safety, scope and runtime status

Only `Logres/Integration/Layout.lua` runtime placement constants and the
TOC/Bootstrap version markers change. Five-bar grids, 12 action slots per
bar, secure paging, Blizzard binding identities, contextual alpha, and pet
suppression/restoration are unchanged. Existing P0416 out-of-combat viewport
bounds/overlap gate, recovery and Immersion OFF stock fallback remain in force.
No new pet driver, poller, protected-frame inspection, action mutation, or
live in-game editor is added.

At the reference viewport 1917×1198, and the earlier 1536×960 viewport, the
approved five bar bounding rectangles pass the existing source-equivalent
conservative bounds/non-overlap calculations (see P0421 checker). This is
static geometry, **not** combat/secure-click or actual WoW collision proof.

WoW Forever P0421 validation is **PENDING**. The user should check the new
Quest Dialogue high-center position for interference with the compass and NPC
panels, shifted pet cluster, Active Quest, passive-status lane, and all five
bar keys plus menus. Existing pet suppression was user-observed working before
this patch; P0421 does not claim a fresh pet runtime PASS. L-008 broader
fallback/combat/Edit Mode edge coverage remains OPEN. L-009 live layout
editing remains DEFERRED.

## Author-side negative result retained

The first reconstructed-source checker sweep returned **280/289**, not a PASS:
shortening `CURRENT.md` removed historical marker references used by nine
older contract checkers (P0369, P0372, P0373, P0375, P0376, P0380, P0382,
P0414, P0415). No user repository was modified. Historical tokens were restored
in `CURRENT.md` while staying below the P0381 9,800-byte budget; the full
289/289 checker sweep subsequently passed. This was an author-side contract
repair, not a WoW runtime result.
