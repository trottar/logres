# P0091 — Fix Objective Progress Labels

Date: 2026-10-02
Result: PREPARED — RUNTIME + VISUAL RETEST PENDING

## Baseline

P0090 verified pushed: `afcc37c1aedff4120332ddd2a76b8151f6461ce8`.

## Runtime

`0.0.36-dev -> 0.0.37-dev`.

## Trigger

P0090 live Preview works, but output duplicates objective counts because Forever objective text already carries the leading progress token and Logres `FormatRow()` appends it again.

## Change

Add presentation-only label normalization:
- use safe non-secret `row.text`;
- build the exact current `fulfilled/required` token;
- strip it only at the start of the label and only when followed by whitespace;
- trim the remaining label;
- append one canonical Logres count;
- completed rows use the same normalized label.

## Unchanged

No change to active quest identity, objective API, secret handling, production baseline, change comparison, refresh events, timers, Immersion policy, stock Objective Tracker ownership, or polling/retry/hook behavior.

## Static contract

`tools/check_objective_progress_contract.py` requires the normalization path and rejects the old direct `trimText(row.text, TEXT_LIMIT)` formatter.

## Runtime validation

Preview a current count-based quest; confirm each count appears once; make one natural same-quest change; confirm one automatic pulse with one count; immediately run Objective Progress Check and Quest Probe; confirm no duplicate pulse without another change.

WoW redeploy required after verified push.
