# P0275 — Native quest-art shell for Blizzard merchant/trainer

Status: PREPARED / WSL & WoW UNVERIFIED. Date 2026-10-19. Pushed baseline: `ac3f199769988cfc08002f8a31f635aac04874d4`.

Deliberate user-approved Stage 1 after P0274's small accent proved insufficient: use actual quest panel/divider media as an additive 640x540 nine-slice frame behind existing native merchant/trainer, full input and native opaque core retained. **Not** the pixel-perfect wide mockup; Stage 2 native child layout/texture feasibility is separately gated. Gossip keeps native placement and stock appearance until accepted guarded Logres live adapter; camera, flight, bank, auction, transactions unchanged.

Guarded one-shot applier checks pinned HEAD/index/worktree, frozen source, owned payload absence, prepares 16 paths, validates all 142 checkers in a shadow candidate, prewrite hygiene, postwrite suite and diff --check, emits P0275_MANIFEST.txt and rolls back patch-owned writes on error. User alone commits/pushes. WSL and WoW results must be appended in a subsequent checkpoint; never predeclare PASS.

Negative result carried forward: P0274 accent activation was detected (3 shows, 0 failures) but the user found it visually identical to Blizzard. No game-state or transaction failure was observed in the provided evidence. Preserve P0272 original WSL proof limitation.
