# P0091 — Fix Objective Progress Labels

Date: 2026-10-02
Result: INSTALLED / PUSHED — INTEGRATION PASS; PRODUCTION IDENTITY DEFECT EXPOSED (`a2c5e863`)

## Baseline

P0090 verified pushed:
`afcc37c1aedff4120332ddd2a76b8151f6461ce8`.

## Runtime

`0.0.36-dev -> 0.0.37-dev`.

## Change

Presentation-only label normalization:
- use safe non-secret `row.text`;
- build the exact current `fulfilled/required` token;
- strip it only at the start of the label and only when followed by whitespace;
- trim the remaining label;
- append one canonical Logres count;
- completed rows use the same normalized label.

## Runtime result

P0091 integration checks passed:
- Objective Progress Check PASS;
- current Preview `shown-current`;
- Immersion OFF suppression PASS;
- Immersion ON current Preview PASS;
- two Run All executions PASS;
- no fixed secret/error result.

Final Quest Probe captured quest 237 at:
- Skullthumper `5/10`;
- Seer `4/10`.

Single-count rendered-text acceptance is not provable from SavedVariables alone
and remains a visual retest item.

## Defect exposed

P0091 confirmed that count-based Forever `objective.text` contains the count
prefix.

The production comparator still required raw:

`previous.text == current.text`

before comparing the numeric count fields.

Therefore the raw text identity changes whenever the count changes, making
count-based production pulses unreachable for those rows.

P0092 owns the stable-identity correction.

Evidence:
`../evidence/F6_P0091_STABLE_IDENTITY_DEFECT_2026-10-02.md`.
