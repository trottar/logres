# Phase F — Quest Experience

Status: ACTIVE — F.6

## Product Objective

Create an immersive quest experience that presents only the quest information
the player actually needs while preserving Blizzard control surfaces until
safe replacements exist.

## Standing Boundaries

Phase F owns passive quest/XP presentation policy and restrained runtime-proven
objective updates.

Blizzard retains quest interaction controls, watch/super-track mutation, stock
quest-log interaction, and the stock Objective Tracker until a safe replacement
exists.

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

**ACTIVE — PRODUCTION IDENTITY DEFECT PROVEN; P0092 RETEST PENDING.**

P0091 is durable at `a2c5e863`, runtime `0.0.37-dev`.

P0091 runtime integration passed, and the latest quest 237 probe captured
Skullthumper `5/10` and Seer `4/10`.

The remaining production defect is now source-proven:
count-based Forever objective text embeds the changing count, while P0091
production comparison requires raw text equality before comparing numeric
progress.

P0092 target `0.0.38-dev` compares a full, count-prefix-free stable objective
label at the same objective index, then compares count/finished state.

No event/source/baseline/polling change.

Do not add polling/retry/reassertion.

## Quest navigation

Quest IDs `436`, `237`, and `1338` remain negative destination samples.

Quest compass marker remains unsupported until a real usable destination is
runtime-proven.

## Phase F Exit

Phase F completes only when accepted quest/XP presentation is runtime-proven and
every suppressed Blizzard surface has a deliberate replacement and
restoration/fallback contract.
