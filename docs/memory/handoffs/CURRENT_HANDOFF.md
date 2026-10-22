# Current Handoff — P0297 live trainer icon backplate

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0297_TRAINER_ICON_BACKPLATE.md`, D-046/D-047.

P0296 `1a75351` is verified pushed. User states single-spell purchase succeeded; screenshot corroborates native trainer remaining functional, a 6s balance decrease and expected available-list change. **One reported purchase is a limited runtime PASS, not universal authorization.** P0296 live screenshot shows two tan/gold icon squares (Curse of Recklessness, Unending Breath), an **OPEN ICON VISUAL FAIL**. Gold is painted behind *all* trainer icons; transient alpha or rendering makes that backing dominate. Whether the source native texture IDs or icon alpha caused it remains UNPROVEN. Slider drag/track outcome still not established. `Visible services` placeholder still OPEN.

P0297 PREPARED; WSL and client UNVERIFIED: change only the shared `TrainerLandscape.icon` live branch to a dark inset backing with four narrow gold edge rules. P icon painter unchanged. Retain raw guarded native icon source, catalogue indices, click/scroll/filter/purchase controllers and stock UI. No timer, protected writes, callbacks, texture introspection or native purchase changes.

Next: exact clean P0296 apply with full static checks, user commits/pushes, assistant verifies main. Deploy `/reload`, at trainer H → Live Trainer ON (TEST), compare the two previously gold icons under both filters; click rows, wheel/drag scroll, OFF/close, inspect stock. No purchase necessary. If still faded, record visual failure and pursue source-specific read-only diagnostic rather than inventing successful render proof.
