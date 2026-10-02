# F.6 — Contextual Objective Progress Pulse

Status: ACTIVE — LIVE SOURCE PASS; LIVE PREVIEW PASS; PRODUCTION IDENTITY DEFECT
PROVEN; PULSE FIX RETEST PENDING
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

P0090 runtime evidence:
`../evidence/F6_P0090_LIVE_PREVIEW_DUPLICATE_COUNT_FAIL_2026-10-02.md`

P0091 runtime/source evidence:
`../evidence/F6_P0091_STABLE_IDENTITY_DEFECT_2026-10-02.md`

## Product intent

Present objective progress only when it meaningfully changes.

This is a contextual pulse, not a permanent quest/objective tracker.

## Passive / baseline contract

Unchanged:
- safe super-tracked/selected quest identity;
- passive `C_QuestLog.GetQuestObjectives`;
- secret checks before inspection;
- first usable sample baselines without a pulse;
- identity changes rebaseline;
- same-quest count/finished changes may pulse;
- missing/empty/unusable data does not fabricate progress.

## Refresh contract

Unchanged:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_UPDATE`;
- `SUPER_TRACKING_CHANGED` rebaseline;
- `PLAYER_ENTERING_WORLD` rebaseline.

No polling/retry/broad-hook workaround is authorized.

## P0091 runtime result

P0091 is durable at:
`a2c5e863`.

Runtime:
`0.0.37-dev`.

Diagnostics prove:
- Objective Progress Check PASS;
- Preview `shown-current`;
- Immersion OFF `suppressed-immersion-off`;
- Immersion ON `shown-current`;
- two consecutive Run All executions PASS;
- quest 237 available with two rows;
- no fixed secret/error result.

Final Quest Probe:
- Skullthumper `5/10`;
- Seer `4/10`;
- QUEST_LOG_UPDATE `94`;
- QUEST_WATCH_UPDATE `9`.

No Objective Progress Check was captured after that natural progress, so the
runtime pulse counters for those transitions are unavailable.

## Production identity defect

**PROVEN FROM RUNTIME SOURCE SHAPE + CURRENT CODE.**

Forever count-based objective text includes its current count:
- `3/10 Stonesplinter ...`;
- `4/10 Stonesplinter ...`;
- `5/10 Stonesplinter ...`.

P0091 display normalization correctly recognizes that count prefix.

But P0091 production change detection still gates on:

`previous.text == current.text`

before checking whether `fulfilled` or `required` changed.

Therefore the same objective's raw text changes at the exact moment its count
changes, preventing the count-change branch from running.

This is not evidence for polling or another event source.
It is a stable-identity bug.

## P0092

Runtime target:
`0.0.38-dev`.

P0092 factors the existing count-prefix stripping into a full, untruncated
stable objective identity.

Production comparison remains:
- same quest;
- same objective index;
- same stable objective label.

Only after stable identity matches does Logres compare count/finished fields.

Presentation still truncates separately to `TEXT_LIMIT`.

No source/event/baseline/timer/Immersion/polling change.

## Runtime acceptance

1. Objective Progress Check PASS after reload/baseline.
2. Preview shows current rows with each count exactly once.
3. One natural same-quest count change produces exactly one automatic pulse.
4. The automatic pulse renders the changed count exactly once.
5. Immediately run Objective Progress Check before reload; `changes` and
   `pulses` must advance.
6. Immediately run Quest Probe; the same live count must be present.
7. No second pulse without another objective change.
8. Run All once with no failures.
9. Stock Objective Tracker remains usable.
10. No Lua/taint/protected/secret-value errors.
