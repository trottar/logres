# P0122 — Context Message Visual Translation

Date: 2026-10-04
Result: **INSTALLED / PUSHED — RUNTIME + PREVIEW PATH PASS; COMPLETION VARIANT DEFERRED**
Baseline: `fc928d9972d6eef43586b1d852281a7b95c229a4`
Commit: `62353ecfc6eb3c3adc61b8d11af251f05637a6a3`
Runtime: `0.0.51-dev -> 0.0.52-dev`

## Purpose

Translate approved D-039 sheet `09_context_message_component.png` into one
reusable production Context-message surface for the already-proven XP and
objective-progress producers.

This patch intentionally freezes Camera work. It does not modify Camera source,
Phase G/G.5 investigations/evidence, `CURRENT.md`, or `CURRENT_HANDOFF.md`.

## Production visual primitive

P0122 adds:
- a restrained horizontal line asset;
- a small center diamond asset;
- a subtle completion glow asset;
- shared `ContextVisual` runtime construction/styling;
- Theme-owned geometry and normal/completion palettes.

The presentation remains transient, centered/world-first, and mouse-transparent.
The approved visual language is applied without changing XP or objective source
ownership.

## Existing producer behavior preserved

XP remains:
- positive same-range XP delta only;
- `+N XP · progress%`;
- approximately two seconds;
- no permanent XP bar.

Objective progress remains:
- event-driven from the existing active-quest/objective snapshot logic;
- up to two transient lines;
- no Objective Tracker replacement;
- no quest action/control ownership.

## Completion treatment

A warmer/brighter Context treatment is used only when the existing objective
producer proves a real `finished` transition (`previous.finished ~= current.finished`
and `current.finished == true`).

P0122 does not invent completion from count thresholds, text parsing, quest turn-in
events, or player-facing quest controls.

## P0121 synchronization

P0121 is durable at `fc928d99`. Player cast visual/runtime behavior is accepted.
Target cast/channel proof remains environmentally deferred because no nearby enemy
caster was naturally available. Individual player channel/interrupted state
coverage is not over-claimed.

## Validation gate

In client:
1. Phase F -> XP Preview shows the approved Context line/diamond treatment.
2. Phase F -> Objective Progress Preview shows the same shared visual language.
3. A live XP pulse preserves its existing data/timing behavior.
4. A live objective update preserves existing producer behavior and placement.
5. A naturally occurring `finished` objective transition, if available, may prove
   the warmer completion treatment; lack of one is DEFERRED, not FAIL.
6. Immersion OFF/ON continues to suppress/restore transient Context surfaces.
7. No Lua, secret-value, taint, or protected-action error occurs.

The completion variant does not require contrived gameplay solely for proof.

## Runtime / preview result

Captured `0.0.52-dev` diagnostics show:

- XP Preview PASS (`state=shown`);
- XP Check PASS with real XP events/pulses;
- Objective Progress Preview PASS (`state=shown-current`);
- Objective Progress Check PASS with real objective changes/pulses;
- full `checkall` completion with no reported Lua/secret/taint failure.

The dedicated warmer objective-completion visual state was not separately
observed and remains **DEFERRED** until a natural `finished -> true` transition is
available.

Canonical evidence:
`../evidence/P0122_CONTEXT_MESSAGE_RUNTIME_PREVIEW_PASS_2026-10-04.md`.
