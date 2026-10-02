# F.6 P0090 Live Preview PASS / Duplicate Count FAIL — 2026-10-02

Status: CURRENT-OBJECTIVE PREVIEW PASS; PRESENTATION FAIL; PRODUCTION PULSE UNPROVEN
Date: 2026-10-02
P0090 commit: `afcc37c1aedff4120332ddd2a76b8151f6461ce8`
Runtime: `0.0.36-dev`

## Runtime result

Forever client `1.60.1`, build `70170`, interface `16001`; Logres load count `82`.

Objective Progress Preview returned `shown-current`.

Immersion policy:
- OFF -> `suppressed-immersion-off`;
- ON -> `shown-current`.

Two consecutive Run All executions passed within tested scope. Objective Progress Check reported quest `237`, two rows, `secret=false`, and `error=nil`.

Classification: **CURRENT-OBJECTIVE PREVIEW PATH PASS.**

## Visual defect

User screenshot showed:

`4/10 Stonesplinter Skullthumper slain  ·  4/10`

`3/10 Stonesplinter Seer slain  ·  3/10`

Classification: **PRESENTATION FAIL — COUNT DUPLICATED.**

## Cause

Forever `objective.text` already includes a leading progress token such as `4/10`.

`Progress:FormatRow()` took the whole text as the label and appended the separately provided `numFulfilled/numRequired` values again.

Because Preview and production changed-row pulses both call `FormatRow()`, this is a shared presentation bug rather than a Preview-only bug.

## Corrective contract

P0091 may change presentation formatting only:
- recognize only the exact current `fulfilled/required` prefix;
- require whitespace after the prefix before stripping it;
- keep arbitrary objective text unchanged otherwise;
- append one canonical count suffix;
- do not modify source/event/baseline/change-detection behavior.

## Production pulse status

No natural same-quest objective transition was captured after P0090 loaded.

Classification: **PRODUCTION PULSE UNPROVEN.**
