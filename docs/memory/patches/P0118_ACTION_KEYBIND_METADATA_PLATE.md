# P0118 — Action Keybind Polish

Date: 2026-10-03
Result: **PREPARED — VISUAL PROOF PENDING**
Baseline: `82bdb4f33b8199c6794f486eff0067f99e22b4d0`
Runtime: `0.0.47-dev -> 0.0.48-dev`

## Purpose

Refine the action-button presentation after P0116 core visual acceptance. The
accepted treatment borrows the readability logic of the approved aura
stack/duration metadata plate while preserving action-specific corner roles.

## Runtime change

- default action-button size increases modestly from 38 px to 42 px;
- keybind remains top-right;
- bottom-right count/charge placement remains unchanged;
- non-empty binding labels receive a compact dark inset plate with thin
  weathered-bronze edge and ivory text;
- plate fill is strengthened to near-black for icon-independent readability;
- plate width follows the rendered non-secret binding label;
- modifier labels compact to lowercase modifier + hyphen + uppercase main key
  (`s-Q`, `c-C`, `a-E`);
- empty labels show no plate;
- no new child Frame is introduced under the protected action button; only
  Texture/FontString regions are shown/hidden/resized;
- Primary routing policy is unchanged and remains fail-open/manual while Primary
  stock replacement is not owned;
- Secondary/Utility routing and stock Bar 2–3 replacement are unchanged;
- secure execution, paging, cooldown/count transport, range/usability, cluster
  geometry, contextual alpha, and P0116 state assets are unchanged.

## Evidence synchronization

P0116 is now recorded as core runtime + visual PASS from the user's in-client
validation and exported diagnostics. Specific checked/cooldown/range/resource/
unusable appearances remain coverage-deferred.

P0117 G.5 is verified pushed at `82bdb4f3`; its Taxi runtime proof remains
pending and is not altered by this patch.

## Validation gate

In client, confirm:
- bound buttons show the stronger top-right dark metadata plate;
- modifier bindings render compactly (`s-Q`, `c-C`, `a-E`);
- the 42 px buttons improve readability without excessive crowding;
- the key label is readable over bright and dark icons;
- unbound buttons show no empty plate;
- bottom-right counts remain independent;
- P0116 hover/pressed/activation feedback is unchanged;
- `Action Check` still passes;
- no Lua, taint, protected-action, or secret-value errors occur.

## Active work boundary

Phase G / G.5 remains active. P0118 is parallel visual translation/polish only.


## Context-alpha parity correction

In-client R3 proof showed Primary correct while Secondary/Utility retained the
key-tag geometry but lost the intended black inset because their button regions
inherited contextual cluster alpha (`0.45` / `0.20`).

R4 moves only the key-tag border/fill/text regions onto the already-existing
UIParent activation-feedback frame anchored to each secure button. This uses the
same established alpha-isolation pattern as activation feedback: action buttons
and icons remain contextually subdued, while keybind metadata stays legible.

No secure execution, routing, paging, cluster alpha policy, count placement, or
button geometry changes are introduced.


## Gold-border / black-fill layer correction

R4 restored Secondary/Utility key-tag visibility by isolating the regions from
context alpha, but in-client proof showed the tag still rendering as a mostly
solid gold rectangle instead of a gold border around a black inset.

R5 fixes only the plate layering: the gold border sits at sublevel 0, the black
inset fill at sublevel 1, and the key text at sublevel 2 on the same feedback
frame. This preserves the intended appearance across Primary, Secondary, and
Utility without changing sizing, compact label formatting, routing policy, or
contextual button alpha.
