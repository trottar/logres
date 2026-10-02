# P0092 — Fix Objective Progress Identity

Date: 2026-10-02
Result: PREPARED — RUNTIME + VISUAL RETEST PENDING

## Baseline

P0091 verified pushed:
`a2c5e863e37f1b34a014d960e3c7910c8be44ee7`.

## Runtime

`0.0.37-dev -> 0.0.38-dev`.

## Trigger

P0091 established that Forever count-based objective text embeds the current
count prefix.

Current production comparison still requires raw objective-text equality before
checking the numeric count fields.

That means a real count increment changes the text identity and blocks its own
change detection.

## Change

Introduce a full, untruncated stable objective identity:
- start from safe addon-owned `row.text`;
- if the text begins with the exact current `fulfilled/required` token followed
  by whitespace, remove that token and leading whitespace;
- return the remaining full label without presentation truncation.

`NormalizeObjectiveLabel()` now truncates that stable label only for display.

`FindChangedRows()` compares:
- same objective index;
- previous stable label == current stable label;
- then numeric count and finished-state changes.

## Unchanged

No change to:
- active quest identity;
- objective API;
- secret handling;
- baseline-first behavior;
- refresh events;
- super-track/watch ownership;
- presentation timer;
- Immersion policy;
- stock Objective Tracker ownership;
- polling/retry/hook behavior.

## Static contract

The F.6 checker now:
- requires `StableObjectiveText`;
- requires previous/current stable-identity comparison;
- rejects raw `previous.text == current.text` production identity.

## Runtime validation

After verified push:
1. establish baseline;
2. Preview current objectives and confirm one count per row;
3. make one natural same-quest objective count change;
4. confirm exactly one automatic pulse;
5. immediately run Objective Progress Check;
6. immediately run Quest Probe;
7. confirm no duplicate pulse without another change;
8. Run All once.

WoW redeploy required after verified push.
