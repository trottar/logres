# P0418 — apply the approved whole-screen authored map

Pinned source: P0417 main `bc91448bcb3632e493c5c2d9b28dd57baff744c6`.
Version advances to 0.0.295-dev.

Translate the user-approved `LOGRES_SCREEN_MAP_APPROVED.json` into the
addon-owned runtime anchor system. Preserve the P0416 five-bar source/role/grid
profile and P0417 pet readiness repair, but adjust bar 3 / bar 5 placement and
add approved coordinates for quest dialogue, context objective, context XP and
Report Bug. Expand the H.2 plan/audit panel to the full approved map and bind
Report Bug to its own layout anchor. No new secure action logic, no Blizzard
suppression broadening, and no native dock fallback removal.

## R1 guard repair

R0 user-side exact preflight refused 283/286 before apply: phase-roadmap
checkpoint desynchronized from CURRENT (P0381, transitive P0408) and obsolete
Report Bug anchor assumption in P0389. R1 updates both roadmaps and narrows
that historical assertion to independent `reportBug`, without changing P0418
runtime geometry. Evidence retained in `P0418_APPROVED_SCREEN_MAP_TRANSLATION.md`.
