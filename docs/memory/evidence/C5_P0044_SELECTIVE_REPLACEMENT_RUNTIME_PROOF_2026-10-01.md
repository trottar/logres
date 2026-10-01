# C.5 P0044 Selective Replacement Runtime Proof — 2026-10-01

Status: VERIFIED
Baseline: `1d4f8119c5df730eb95f72982e238b1e31072701`

## Result

The user tested P0044 and reported that everything worked.

The accepted runtime result covers the first selective replacement scope:

- stock Bar 2 replacement;
- stock Bar 3 replacement;
- Logres Secondary/Utility routing coupling;
- stock restoration;
- Logres action execution/feedback while replacement is active.

No protected-action, taint, Lua, or secret-value error was reported.

## Scope that passed

Replacement ON:
- supported stock Bars 2–3 can be removed from the visible/mouse interaction
  path;
- matching Logres routing becomes the active key path;
- Logres activation feedback remains available.

Replacement OFF:
- supported stock bars can be restored;
- prior routing behavior can be restored.

Unsupported domains remain outside suppression:
- MainActionBar;
- OverrideActionBar;
- Bars 4–5;
- special action surfaces.

## Live editing observation

During validation, the user identified a separate action-layout limitation:

- an action/spell can be added into a Logres-represented action slot;
- Logres does not yet provide a complete direct interaction for removing,
  moving, swapping, or reordering actions from its own action controls.

This is not classified as a C.5 stock-replacement failure.

It is a deferred action-layout/editor capability tracked under D-020 and:
`ACTION_LAYOUT_EDITING_RUNTIME_GAP_2026-10-01.md`.

For the current session-only replacement proof, the stock bars can still be
restored when the player needs the stock editing surface.

Persistent/final replacement must not remove the player's practical editing
path without a Logres replacement editor or explicit stock-edit fallback.

## Conclusion

**C.5 — COMPLETE.**

The first selective stock replacement capability is runtime-proven.

Primary/global/special action-bar suppression remains separately capability-
gated and is not implied by this result.
