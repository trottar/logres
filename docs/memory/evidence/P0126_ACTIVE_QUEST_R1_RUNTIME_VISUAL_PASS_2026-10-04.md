# P0126 Active Quest R1 Runtime / Visual PASS — 2026-10-04

Status: **R1 HOVER FIX PASS; VISUAL BASELINE APPROVED WITH ONE MINOR FOLLOW-UP**
Runtime: `0.0.56-dev`
Baseline Git HEAD: P0125 `72d2f040`

## Runtime result

The corrective R1 client session confirms:
- Logres `0.0.56-dev` loaded;
- `activequestcheck`: PASS against real super-tracked quest `237`;
- two real objective rows were present;
- normal preview: PASS;
- complete preview: PASS;
- live restore: PASS;
- full `checkall`: PASS, including Active Quest;
- no repeat of the prior hover tooltip Lua failure was reported.

The user also confirmed the hover behavior now works.

## Visual result

The user approved the overall Active Quest presentation as looking and working
well.

One minor follow-up was requested:
remove the persistent percentage text shown to the right of each objective
progress bar.

Rationale:
the bar itself is sufficient for ambient progress, and deliberate hover already
provides exact detail when requested.

## Consequence

P0126 R2 should:
- preserve the progress bars;
- remove persistent `%` labels from Active Quest rows only;
- keep exact objective wording/counts on hover;
- keep the shared percentage-bar visual language otherwise intact;
- make no quest source, focus-policy, control, navigation, or Camera changes.

R1 runtime/hover proof is accepted. R2 requires only a narrow in-client visual
confirmation that the percent labels are gone and hover detail remains available.
