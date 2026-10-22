# Current Handoff — P0295 trainer row hit priority

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0295_TRAINER_ROW_HIT_PRIORITY.md`, D-046/D-047.

P0294 `43802394` was independently verified on GitHub main. User WoW screenshots and report: All sampled 64 / Available only 5 filter transitions work; wheel scrolling works, but clicking different Logres spell rows does not select them. **P0294 row selection is a runtime FAIL, not a PASS.** The old `Visible services` live category is a noninteractive placeholder; true categories are not yet sourced. Do not claim it works or invent categorical data. Blizzard selection remains independent.

P0295 PREPARED / WSL+WOW UNVERIFIED: overlapping addon-owned wheel and hit frames had no explicit input ordering. The wheel is placed above inert rendered rows; seven row hit regions become wheel children and receive a still-higher frame level. Root remains mouse-inert. All click handling still resolves captured native `serviceIndex`; no native selection/training/filter setters, polling, protected mutation, camera change, or synthetic P interaction.

Next: guarded P0295 application on clean P0294 main, full static checks and push verification. Deploy; `/reload`; at trainer use `/logres panel` → H → Live Trainer ON (TEST). Click multiple different Logres rows, confirm row highlight and selected details change immediately, then scroll, filter and return; verify Blizzard native selected highlight stays put and controls remain usable. H → Live Trainer OFF, close trainer. On failure, report a screenshot and Lua error/diagnostics; record as failure and investigate; do not broaden hooks or fake PASS.
