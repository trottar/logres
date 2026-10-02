# P0090 — Live Objective Progress Preview

Date: 2026-10-02
Result: INSTALLED / PUSHED — LIVE PREVIEW PASS; VISUAL DUPLICATE-COUNT FAIL (`afcc37c`)

## Baseline

P0089: `1781c038637cef750061e20635e4c1310dcecc96`.

## Runtime

`0.0.35-dev -> 0.0.36-dev`.

## Change

Preview passively reads current active objective rows, shows at most two rows, returns `shown-current`, uses synthetic fallback only when live rows are unavailable, and does not mutate production baseline/change counters.

## Runtime result

Diagnostics prove live current-objective Preview PASS, Immersion suppression/restoration PASS, two consecutive Run All PASS, and no fixed Objective Progress secret/error result.

## Visual failure

Screenshot showed duplicate counts, e.g. `4/10 Stonesplinter Skullthumper slain  ·  4/10`.

Cause: Blizzard objective text already contains the count prefix while shared `FormatRow()` appends the same count. This affects Preview and future production pulse text.

P0091 owns the narrow presentation correction.

Evidence: `../evidence/F6_P0090_LIVE_PREVIEW_DUPLICATE_COUNT_FAIL_2026-10-02.md`.

## Production pulse

Still unproven on P0090 because no natural same-quest objective transition was captured after this runtime loaded.
