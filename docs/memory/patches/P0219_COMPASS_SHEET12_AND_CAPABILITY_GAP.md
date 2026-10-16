# P0219 — H.3 sheet-12 compass art roles and capability correction

Baseline P0218 `157e09c`, candidate version `0.0.128-dev`.

- Three small approved-geometry TGA glyphs: quest pennon, local POI roundel, tracking faceted pip.
- Register distinct Theme compass visual role dimensions and production media assets.
- Developer-only Compass Art Preview ON/OFF via Phase E; no newly sampled or fabricated real navigation source and no changes to heading or manual waypoint path.
- Persist planning correction, explicit missing navigation capabilities and current source gate. Static contract prevents direct source API expansion in `Compass.lua`; production continuation must be separately proven.
- Guarded applier verifies exact baseline blobs, runs all checkers on a shadow worktree and `git diff --check`, emits manifest; no Git write.

Outcomes: PREPARED — WoW runtime visual evidence PENDING. Do not infer full compass capability from preview.
