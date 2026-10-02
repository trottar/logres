# Phase F — Quest Experience

Status: ACTIVE — F.6

## Product Objective

Create an immersive quest experience that presents only the quest information the player actually needs while preserving Blizzard control surfaces until safe replacements exist.

## Standing Boundaries

Phase F owns passive quest/XP presentation policy and restrained runtime-proven objective updates. Blizzard retains quest interaction controls, watch/super-track mutation, stock quest-log interaction, and the stock Objective Tracker until a safe replacement exists.

## F.1

**COMPLETE — D-031.**

## F.2

**COMPLETE.**

## F.3 — Contextual XP pulse

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.4 — Additive NPC quest detail presentation

**COMPLETE — RUNTIME + INTEGRATION + VISUAL PASS.**

## F.5 — Objective / progress runtime capability proof

**COMPLETE — RUNTIME PASS.**

## F.6 — Contextual objective progress pulse

**ACTIVE — LIVE PREVIEW PASS; DUPLICATE-COUNT VISUAL FAIL; PRODUCTION PULSE UNPROVEN.**

P0090 is durable at `afcc37c`, runtime `0.0.36-dev`. Live current-objective Preview, Immersion suppression/restoration, and two Run All executions passed. Visual output duplicated counts because the source label already contains the count and Logres appended it again.

P0091 target `0.0.37-dev` normalizes only an exact matching leading count prefix. The shared formatter corrects Preview and production pulse text. No source/event/baseline/change-detection change.

Production pulse remains runtime-unproven. Do not add polling/retry/reassertion without evidence of an actual production pulse failure.

## Quest navigation

Quest IDs `436`, `237`, and `1338` remain negative destination samples. Quest compass marker remains unsupported until a real usable destination is runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and every suppressed Blizzard surface has a deliberate replacement and restoration/fallback contract.
