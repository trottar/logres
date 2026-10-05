# P0137 — Production Player Helpful Aura Presentation

Date: 2026-10-05
Result: **INSTALLED / PUSHED — RUNTIME + VISUAL PASS** (`2b578759`)
Baseline: `ef769f6df00eea4fd9d0d6686b47c1d99a47e401`
Runtime: `0.0.66-dev -> 0.0.67-dev`

## Purpose

Translate only the runtime-proven P0136 player-helpful aura category into the
approved D-039 status/aura icon primitive.

Canonical capability evidence:
`../evidence/P0136_AURA_STATUS_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`.

Canonical source/priority decision:
`../decisions/D-041_AURA_STATUS_SOURCE_AND_PRIORITY_POLICY.md`.

Canonical visual reference:
`../../design/approved/04_status_aura_icon_primitive.png`.

## Production scope

P0137 owns a small passive player-helpful presentation lane only.

Data source:
`HELPFUL|PLAYER`.

The production surface:
- reads at most six indexed candidates;
- presents at most four icons;
- uses the native WoW aura icon unchanged;
- applies the approved minimal passive frame;
- reserves lower-right metadata space for ordinary stack count;
- shows stack count only when the ordinary application count is greater than one;
- does not show duration in this checkpoint;
- does not add a timer sweep;
- has no hover/click interaction;
- remains peripheral beside the central resource/reaction region.

Duration is intentionally deferred: P0137 is event-driven and does not introduce
periodic polling solely to maintain countdown text.

## Secret-first contract

For every candidate index:

1. require the secret checker and current aura APIs;
2. call `C_Secrets.ShouldUnitAuraIndexBeSecret("player", index,
   "HELPFUL|PLAYER")`;
3. secret-check the predicate result before comparing it;
4. query `C_UnitAuras.GetAuraDataByIndex` only for ordinary `false`;
5. secret-check the returned aura before nil/type inspection;
6. secret-check `icon` before using it;
7. secret-check `applications` before comparing/formatting it.

Secret candidate state is skipped. Predicate/query/shape failure hides the Logres
presentation and leaves Blizzard as the complete fallback.

The `UNIT_AURA` update payload is discarded.

## Blizzard fallback

P0137 does not hide, fade, reparent, disable, or alter Blizzard BuffFrame/debuff
presentation.

Blizzard remains the completeness surface for:
- player helpful auras not selected by this narrow Logres lane;
- all player harmful/urgent status;
- target status;
- private/restricted auras;
- party/group aura and dispel information.

No stock suppression is authorized.

## Visual translation

Production derivatives:
- `Logres/Media/Aura/aura_frame_passive.tga`;
- `Logres/Media/Aura/aura_count_plate.tga`.

`Theme.lua` owns geometry, color tokens, and asset paths.

The native spell icon remains dominant. The frame is restrained bronze/dark
chrome rather than ornate parchment. Stack metadata is compact and subordinate.

## Deterministic preview

Phase H adds:
- `Player Helpful Aura Preview`;
- `/logres helpfulaurapreview [on|off]`.

Preview renders four deterministic icons and sample stack-count states without
reading or changing live aura state.

## Diagnostics

Phase H adds:
- `Player Helpful Aura Check`;
- `/logres helpfulauracheck`.

The check is non-mutating and is included in `Run All`.

It validates:
- module/root/slot construction;
- event registration;
- source availability;
- visibility coherence with Immersion and current ordinary helpful data;
- zero source failures.

## Runtime / visual validation

1. Phase H -> `Player Helpful Aura Preview`.
2. Confirm:
   - four compact native-icon tiles;
   - passive minimal frame;
   - stack metadata sits lower-right and remains subordinate;
   - no timer sweep or invented interaction state;
   - the lane is peripheral and does not crowd the resource/cast area.
3. Phase H -> `Player Helpful Aura Preview` again, or
   `/logres helpfulaurapreview off`, to return to live state.
4. With a naturally available player-origin helpful aura such as the previously
   observed Demon Skin, Phase H -> `Player Helpful Aura Check` -> PASS.
5. Confirm the live Logres icon updates/removes on normal `UNIT_AURA` changes and
   does not remain stale.
6. Confirm Blizzard player buff/debuff presentation remains visible and usable.
7. Phase 0 -> `Run All` -> PASS.

Do not manufacture harmful/target aura evidence for P0137.

Any Lua, secret-value, taint/protected-action, stale-display, or Blizzard-fallback
regression is FAIL.

## Boundary

P0137 does not authorize:
- player harmful/urgent production presentation;
- target aura/status presentation;
- private aura ownership;
- party/group aura replacement;
- stock aura suppression.

Those remain separately capability-gated.

## Final result

Durable commit:
`2b578759e503bdfb5ca27c57d088f15caca79672`.

Canonical evidence:
`../evidence/P0137_PLAYER_HELPFUL_AURA_RUNTIME_VISUAL_PASS_2026-10-05.md`.

Final result:
- runtime `0.0.67-dev`;
- deterministic preview PASS;
- live `HELPFUL|PLAYER` presentation PASS;
- one live ordinary helpful aura shown;
- zero secret skips / secret selected fields / source failures;
- integrated `Run All` PASS;
- user visual acceptance at normal UI scale.

Classification:
**RUNTIME + VISUAL PASS / ACCEPTED PLAYER-HELPFUL PRODUCTION BASELINE.**

This acceptance does not expand harmful/target/private/group ownership and does
not authorize stock aura suppression.
