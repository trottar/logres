# P0152 R1 Runtime / Control / Visual Failure — 2026-10-05

Status: **OPEN — CORRECTIVE R2 REQUIRED**
Runtime candidate: `0.0.74-dev`

## Observed failure

The R1 probe was visible in client but did not behave like the established Logres action interface. User screenshots and direct interaction established:
- only one pet action icon rendered correctly despite a populated stock PetActionBar;
- bespoke numeric slot labels were misleading;
- a yellow `A` marker was an inappropriate parallel state language;
- left click on the intended pet command produced no action;
- the stock Blizzard PetActionBar continued to work.

## Cause

P0152 R1 built a second hand-authored secure-button presentation instead of adapting `Logres.ActionButton`, even though Primary and Secondary/Utility already prove the shared secure-button, art, feedback, sizing, and layout infrastructure. It also used generic secure `type/action` attributes rather than explicit left-button `type1/action1`, and did not resolve Blizzard pet texture tokens through their globals.

## Correction

R2 deletes the parallel presentation path. The probe uses `ActionButton.CreateCluster` and `ActionButton.Create`, adds reusable pet registration/presentation helpers to `Actions/Button.lua`, maps left click explicitly through secure `type1="pet"` / `action1=slot`, and adds only the genuinely pet-specific behavior: right-click autocast toggle for ordinary autocast-capable abilities. Stock PetActionBar remains available.
