# P0293 — Read-only trainer local browse checkpoint

Date: 2026-10-21. **PREPARED / STATIC CANDIDATE; WSL AND WOW UNVERIFIED.** Baseline: GitHub main P0292 `a58cf781e1c689afd97af5c74d84b9135350a33d`.

## Current client evidence

Two user screenshots of Briarthorn's trainer show P0292 correct live names, ranks, icons, available/unavailable status, source costs, level and ability prerequisites, native trainer identity, funds and selected description. Changing Blizzard's Unavailable setting changes Logres's sampled source from five to twelve while displaying a maximum of seven. The source is filtered by Blizzard BEFORE Logres reads it. This is evidence of source fidelity, not Logres filtering. P0292 screenshot does not prove native clicking/transaction replacement. The prior memory-size, EOF whitespace and developer-panel registry failures remain recorded in their original evidence files.

## Narrow implementation

The one-shot source limit becomes 64 (under existing 384 total native service guard); values are independently secret-gated before copying. Trial conversion retains the original native service index with each addon-owned row and captures an immutable-per-trial catalogue. `TrainerLandscape.Render` exposes only addon-owned bound row widgets; `UpdateLiveRows` updates existing art in place and does not create a new frame for each wheel tick. The local Filters click toggles All sampled / Available only; list mouse wheel scrolls one row and rail arrows shift seven. This view does **not** make Blizzard-hidden rows available; change Blizzard filters first if those rows are needed. Native row selection remains unchanged even when its row is outside current local filter/window. Parent root remains mouse-inert except small Logres-owned interactive regions. The accepted P fixture uses the same original paint states and unchanged content. No native trainer setter, purchase, filter, selection, frame mutation, combat polling, timer or native anchor operation is added.

## Acceptance gates

- WSL: pinned clean P0292 baseline; 164+ static checkers PREWRITE and POSTWRITE; candidate whitespace gate, `git diff --check` and manifest. User owns commit/push; no push by applier.
- WoW: deploy, `/reload`, open normal trainer, H → Live Trainer ON (TEST). With Blizzard Unavailable shown, scroll from rows 1–7 to rows 6–12; use the local Filters control to show only Available, then All sampled. Verify the native stock trainer content and native filters stay unchanged. Use rail arrows and Live Trainer OFF. Read-only remains explicit.
- Deferred: >64-row completeness, fully independent source enum/filter, native selection/click routing, secure Train and Train All, lifecycle recovery under all edge cases, aesthetic polish.

Accepted result is limited to the observed test; do not automatically declare static PASS to be WoW PASS.
