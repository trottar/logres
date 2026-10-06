# P0152 R5 Runtime Failure — Protected Pet Click + Resource-Bar Overlap — 2026-10-05

Status: **REAL RUNTIME CONTROL + LAYOUT FAIL — CORRECTED BY P0152 R6 CANDIDATE**

## Observed

After P0152 R5 deployment on candidate runtime `0.0.74-dev`:

- the shared Logres pet-action presentation loaded;
- the temporary row at `y=-120` occupied the same center region as `LogresHUDResourceBar` (`y=-118`);
- hardware left click on a Logres pet button raised Blizzard's protected-action block dialog: the addon attempted an action only available to Blizzard UI;
- stock PetActionBar remained the safe usable fallback.

## Cause

Two integration assumptions were wrong:

1. R5 guessed another absolute Y position instead of using the established HUD layout.
2. The direct addon secure `type1="pet"` / `action1=slot` implementation was treated as runtime-proven from source alone. On Forever 70235 it produced a protected-action failure and therefore cannot be accepted.

## R6 response

- preserve the direct `type1="pet"` result as negative runtime evidence;
- keep Logres `ActionButton` presentation;
- delegate hardware left/right clicks through secure `type="click"` to the corresponding Blizzard `PetActionBar.actionButtons[slot]`;
- let Blizzard own protected cast/command/autocast execution;
- anchor the temporary row below `LogresHUDResourceBar` with an 18px gap, placing it in the known space above the primary action cluster;
- keep stock PetActionBar visible/usable.

No suppression, edit/reorder, binding replacement, or PetFrame ownership is authorized.
