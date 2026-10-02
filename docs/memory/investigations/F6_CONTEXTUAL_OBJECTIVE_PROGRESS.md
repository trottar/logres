# F.6 — Contextual Objective Progress Pulse

Status: ACTIVE — RUNTIME/INTEGRATION PASS; VISUAL FAIL; P0089 REPAIR 2 RETEST PENDING
Opened: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

F.5 evidence:
`../evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`

P0088 runtime/visual evidence:
`../evidence/F6_P0088_RUNTIME_VISUAL_FAIL_2026-10-02.md`

## Product intent

Present objective progress only when it meaningfully changes.

This is a contextual pulse, not a permanent quest/objective tracker.

## Passive / baseline contract

Unchanged from P0088:
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

Do not require:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`.

## P0088 result

Runtime/integration:
**PASS within tested scope.**

Real production pulse:
**UNPROVEN** in that session:
`changes=0`, `pulses=0`.

Visual:
**FAIL** because the `0,-205` / 58px presentation overlapped the lower-center
action cluster.

## Possible live freshness issue

A reported Seer count remaining at `1/10` is:
**OPEN / UNPROVEN**.

P0088 Preview itself hardcoded that exact `1/10` sample.

Live source validation must use Quest Probe before and after a natural objective
change.

No polling, delayed reread, broad hook, or periodic reassertion is authorized
without that evidence.

## P0089 Repair 2

Runtime target:
`0.0.35-dev`.

Presentation only:
- width `520`;
- height `32`;
- bottom anchored to top of addon-owned `LogresHUDTarget`;
- 6px gap;
- fallback UI-center `y=-5`;
- Preview begins with `PREVIEW`.

Delivery hardening:
- complete checker supplied as payload;
- multiline anchors checked with whitespace-tolerant regex;
- exact multiline checker self-test before packaging;
- all repository static checkers precompiled in temporary final tree before
  execution.

Two earlier P0089 artifacts failed temporary-tree validation and produced no
tracked mutation or runtime evidence.

## Blizzard ownership

Unchanged:
- stock Objective Tracker remains available;
- no quest-watch mutation;
- no super-track mutation;
- no quest-log selection mutation;
- no quest interaction control mutation.

## Runtime acceptance

Required:
1. Objective Progress Check PASS;
2. corrected Preview placement visual PASS;
3. Preview suppressed while Immersion OFF;
4. Preview visible after Immersion ON recovery;
5. Run All twice, all emitted checks PASS;
6. Quest Probe records actual live objective baseline;
7. one natural same-quest objective update produces one real pulse;
8. Quest Probe records matching updated live count;
9. unchanged later refresh produces no duplicate pulse;
10. stock Objective Tracker remains usable;
11. no Lua/taint/protected/secret-value errors.
