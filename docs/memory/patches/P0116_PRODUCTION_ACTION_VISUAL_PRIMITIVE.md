# P0116 — Production Action Visual Primitive

Date: 2026-10-03
Result: **INSTALLED / PUSHED — CORE RUNTIME + VISUAL PASS; STATE-COVERAGE DEFERRED** (`c64fcc97`)
Baseline: `4ba6393193c830e5deb08a63bb82fdaf2543aa8d`
Commit: `c64fcc97698e0dbe98a8d52469444f2ef15a76ec`
Runtime: `0.0.45-dev` -> `0.0.46-dev`

## Purpose

Begin D-039 implementation translation with the lowest-risk runtime slice:
establish the production media/token structure and apply the approved
action-button primitive to the already-proven secure action interface.

## Runtime changes

Adds:
- `Logres/Media/Theme.lua`;
- `Logres/Media/Action/action_frame.tga`;
- `action_hover.tga`;
- `action_pressed.tga`;
- `action_checked.tga`;
- `action_flash.tga`.

`Actions/Button.lua` now consumes the shared action tokens and state textures.

Preserved:
- 38 x 38 secure hit box;
- 5-pixel cluster gap;
- native action icon;
- native cooldown DurationObject path;
- secret-safe count path;
- range/usability coloring;
- secure execution and routing;
- independent activation feedback overlay;
- Primary/Secondary/Utility layout and contextual alpha;
- stock replacement/restoration ownership.

The Blizzard `UI-Quickslot-Depress` pushed texture is removed from the Logres
primitive and replaced by the approved Logres pressed layer.

## Architecture

Adds D-040:
`../decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`.

Production runtime media now lives under `Logres/Media/`, while
`docs/design/approved/` remains the immutable approved design-reference family.

## Validation gate

Static checks can prove only wiring/contract integrity.

In-client validation must confirm:
- base frame is readable but restrained at actual scale;
- native action icons remain dominant;
- hover is subtler than pressed/activation feedback;
- checked/toggled treatment persists without overwhelming the icon;
- Feedback Test remains clearly visible even on subdued Secondary/Utility
  clusters;
- cooldown/range/insufficient-resource/unusable states remain legible;
- no Lua, taint, protected-action, or secret-value errors occur.

The core primitive was subsequently accepted in client: base presentation and
activation feedback are PASS. Specific checked/cooldown/range/resource/unusable
states were not individually demonstrated and remain coverage-deferred.

Canonical evidence:
`../evidence/P0116_ACTION_VISUAL_RUNTIME_PASS_2026-10-03.md`.

## Active work boundary

Phase G / G.5 remains the active roadmap objective.

P0116 is parallel Phase H visual-translation preparation and does not authorize
camera-distance mutation or alter camera behavior.
