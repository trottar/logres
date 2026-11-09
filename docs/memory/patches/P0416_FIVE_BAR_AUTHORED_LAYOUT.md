# P0416 — Apply approved five-bar layout without changing action ownership

Baseline: GitHub P0415 `43efc89b8651d278630d48517fb6101ca4d14a74`.
Scope: source config / roles / grid creation / H.2 anchor mapping / OOC
viewport bounds / two historical static contract updates / new checker /
canonical design and memory. No new Lua load entries, UI panels, saved schema,
action slots or keybinds. No changes to the existing pet visibility logic.

Rationale, historical negatives and required client test:
`docs/memory/evidence/P0416_FIVE_BAR_AUTHORED_LAYOUT.md`.

Deliver as `P0416_FIVE_BAR_AUTHORED_LAYOUT.zip`, with a guarded one-time applier
that refuses the wrong main commit, dirty tracked checkout or changed inputs;
preflights a full shadow candidate, all static checkers, syntax, whitespace,
then writes only patch-owned files, verifies the result and produces
`P0416_MANIFEST.txt`. User alone commits/pushes. Static proof is not WoW PASS.
