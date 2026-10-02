# F.6 — Contextual Objective Progress Pulse

Status: ACTIVE — LIVE SOURCE PASS; LIVE PREVIEW PASS; LABEL DUPLICATION FAIL; PRODUCTION PULSE UNPROVEN
Opened: 2026-10-02

Canonical capability contract: `../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

P0090 runtime evidence: `../evidence/F6_P0090_LIVE_PREVIEW_DUPLICATE_COUNT_FAIL_2026-10-02.md`

## Product intent

Present objective progress only when it meaningfully changes. This is a contextual pulse, not a permanent quest/objective tracker.

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

## P0090 live Preview result

P0090 is durable at `afcc37c`, runtime `0.0.36-dev`.

Diagnostics prove:
- Preview returned `shown-current`;
- Immersion OFF returned `suppressed-immersion-off`;
- Immersion ON returned `shown-current`;
- two consecutive Run All executions passed;
- Objective Progress Check reported `secret=false` and no error.

Therefore: **CURRENT-OBJECTIVE PREVIEW PATH PASS.**

## P0090 presentation defect

**FAIL — DUPLICATE COUNT.**

User screenshot showed:
- `4/10 Stonesplinter Skullthumper slain  ·  4/10`;
- `3/10 Stonesplinter Seer slain  ·  3/10`.

Source diagnosis:
- Forever `objective.text` already contains the leading count token;
- `Progress:FormatRow()` appended `fulfilled/required` again;
- Preview and production changed-row presentation both use `FormatRow()`.

## P0091

Runtime target: `0.0.37-dev`.

P0091 changes formatting only:
- if the label starts with the exact current `fulfilled/required` token followed by whitespace, remove that prefix;
- append the canonical Logres count suffix once;
- completed rows use the normalized label before `· Complete`.

No source/event/baseline/change-detection change.

## Production pulse result

**UNPROVEN on P0090.** No natural same-quest objective transition was captured after the new runtime loaded.

## Runtime acceptance

1. Objective Progress Check PASS.
2. Live Preview shows current objective rows.
3. Each objective count appears exactly once.
4. Immersion OFF suppresses Preview; ON restores it.
5. One natural same-quest objective update produces one automatic pulse.
6. The automatic pulse renders the changed count exactly once.
7. Immediately run Objective Progress Check before reload.
8. Quest Probe records the matching updated live count.
9. Unchanged later refresh produces no duplicate pulse.
10. Stock Objective Tracker remains usable.
11. No Lua/taint/protected/secret-value errors.
