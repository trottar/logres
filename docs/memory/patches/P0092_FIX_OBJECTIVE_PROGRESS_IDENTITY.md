# P0092 — Fix Objective Progress Identity

Date: 2026-10-02
Result: INSTALLED / PUSHED — RUNTIME + VISUAL PASS (`5f8e9e96`)

## Baseline

P0091 verified pushed:
`a2c5e863e37f1b34a014d960e3c7910c8be44ee7`.

## Runtime

`0.0.37-dev -> 0.0.38-dev`.

## Trigger

Forever count-based objective text embeds the current count prefix.

P0091 production comparison required raw objective-text equality before checking
numeric progress, so a count increment changed the text identity and blocked its
own change detection.

## Change

P0092 introduced a full, untruncated stable objective identity:
- start from safe addon-owned `row.text`;
- remove only the exact current `fulfilled/required` prefix when followed by
  whitespace;
- keep the remaining full label untruncated for identity;
- keep presentation truncation separate.

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

## Runtime result

P0092 runtime:
`0.0.38-dev`.

Quest `237` baseline:
- two rows;
- `changes=0`;
- `pulses=0`.

After one natural qualifying kill:
- `changes=1`;
- `pulses=1`;
- `sampleReason=QUEST_LOG_UPDATE`;
- `error=nil`.

Immediate Quest Probe:
- Skullthumper `6/10`;
- Seer `4/10`;
- QUEST_LOG_UPDATE `99`;
- QUEST_WATCH_UPDATE `10`.

User visual acceptance:
the mob kill produced the objective popup correctly and the result looked good.

Classification:
**RUNTIME + VISUAL PASS.**

Evidence:
`../evidence/F6_P0092_RUNTIME_VISUAL_PASS_2026-10-02.md`.

WoW redeploy was required for P0092 and has already been validated.
