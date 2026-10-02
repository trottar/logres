# F.6 P0091 Stable Objective Identity Defect — 2026-10-02

Status: PRODUCTION IDENTITY DEFECT PROVEN
Date: 2026-10-02
P0091 commit: `a2c5e863e37f1b34a014d960e3c7910c8be44ee7`
Runtime: `0.0.37-dev`

## Runtime identity

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Logres:
- runtime `0.0.37-dev`;
- persisted load count `84`.

## P0091 integration evidence

Objective Progress Check:
**PASS.**

Objective Progress Preview:
**PASS — `shown-current`.**

Immersion policy:
- OFF -> `suppressed-immersion-off`;
- ON -> `shown-current`.

Two consecutive Run All executions:
**PASS within tested scope.**

Objective-progress status during those runs:
- quest ID `237`;
- rows `2`;
- `secret=false`;
- `error=nil`;
- baseline count `1`.

## Latest live objective evidence

Final Quest Probe captured quest `237`:
**In Defense of the King's Lands**

Objectives:
1. Stonesplinter Skullthumper slain — `5/10`;
2. Stonesplinter Seer slain — `4/10`.

Event counters:
- QUEST_LOG_UPDATE: `94`;
- QUEST_WATCH_UPDATE: `9`.

No post-change Objective Progress Check was recorded after that probe sequence,
so module `changes` / `pulses` counters for the natural progress are not
available from SavedVariables.

## Source-proven defect

Runtime Quest Probe evidence across this investigation proves Forever
count-based objective text contains the count itself, for example:

`3/10 Stonesplinter Skullthumper slain`

then:

`4/10 Stonesplinter Skullthumper slain`

and later:

`5/10 Stonesplinter Skullthumper slain`.

P0091 current source still performs this gate inside `FindChangedRows()`:

`previous.text == current.text`

before it evaluates `previous.fulfilled ~= current.fulfilled`.

Therefore a count increment changes raw `text` and makes the gate false at the
same time that `fulfilled` changes.

For these count-prefixed objectives, the production count-change branch cannot
run.

Classification:
**PRODUCTION CHANGE-DETECTION DEFECT — PROVEN.**

## Narrow correction

P0092 must:
- reuse the already accepted exact-count-prefix stripping behavior;
- return a full, untruncated stable objective identity;
- compare previous/current stable identity at the same objective index;
- preserve the separate count and finished comparisons;
- preserve baseline-first behavior;
- preserve all event ownership;
- add no polling, delayed reread, ticker, or broad hook.

Display truncation remains presentation-only and must not define identity.

## Visual note

The diagnostic proves the Preview execution path, but SavedVariables do not
record the rendered font-string text.

Therefore P0091 single-count visual acceptance is not claimed from this file
alone and remains part of the P0092 visual retest.
