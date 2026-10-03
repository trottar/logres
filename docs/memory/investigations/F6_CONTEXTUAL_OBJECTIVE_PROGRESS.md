# F.6 — Contextual Objective Progress Pulse

Status: CLOSED — RUNTIME + VISUAL PASS
Opened: 2026-10-02
Closed: 2026-10-02

Canonical capability contract:
`../decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`

P0090 runtime evidence:
`../evidence/F6_P0090_LIVE_PREVIEW_DUPLICATE_COUNT_FAIL_2026-10-02.md`

P0091 runtime/source evidence:
`../evidence/F6_P0091_STABLE_IDENTITY_DEFECT_2026-10-02.md`

Final P0092 runtime/visual evidence:
`../evidence/F6_P0092_RUNTIME_VISUAL_PASS_2026-10-02.md`

## Product result

F.6 delivers a brief contextual objective-progress pulse after a meaningful
same-quest objective change.

It remains:
- noninteractive;
- temporary;
- baseline-first;
- event-driven;
- fail-open;
- separate from the Blizzard Objective Tracker.

## Final production contract

Quest identity:
- super-tracked quest preferred;
- selected quest fallback.

Objective source:
- passive `C_QuestLog.GetQuestObjectives`;
- secret checks before inspection;
- missing/unusable data does not fabricate state.

Baseline:
- first usable sample baselines without a pulse;
- quest identity change rebaselines;
- world entry rebaselines.

Refresh:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_UPDATE`;
- `SUPER_TRACKING_CHANGED`;
- `PLAYER_ENTERING_WORLD`.

Identity:
- objective index remains part of matching;
- count-prefixed Forever labels are normalized to a full untruncated stable
  objective label;
- presentation truncation is separate from identity.

Presentation:
- current Preview uses live objective rows when available;
- explicit synthetic Preview remains fallback only;
- objective count is rendered once;
- pulse is anchored relative to addon-owned `LogresHUDTarget`;
- lifetime remains three seconds;
- Immersion OFF suppresses presentation while observation continues.

## P0092 final proof

P0092 is durable at:
`5f8e9e96`.

Runtime:
`0.0.38-dev`.

Runtime sequence on quest `237`:
- baseline: two rows, `changes=0`, `pulses=0`;
- Preview: `shown-current`;
- natural objective change;
- post-change Objective Progress Check:
  `changes=1`, `pulses=1`, `sampleReason=QUEST_LOG_UPDATE`, `error=nil`;
- post-change Quest Probe:
  Skullthumper `6/10`, Seer `4/10`.

The user reports the mob kill produced the objective popup correctly and that
the result looked good.

Classification:
**RUNTIME + VISUAL PASS.**

## Closed failures retained

P0088:
visual overlap with the action cluster.

P0089:
generic synthetic Preview was less useful than live rows.

P0090:
live Preview duplicated count labels.

P0091:
raw objective text identity blocked count-change detection because Forever
embeds the changing count prefix.

P0092:
stable count-prefix-free identity resolves the production defect.

These failures remain durable evidence and are not erased by final success.

## Deferred / preserved Blizzard ownership

Unchanged:
- stock Objective Tracker remains Blizzard-owned;
- quest interaction controls remain Blizzard-owned;
- watch/super-track mutation remains Blizzard-owned;
- quest compass marker remains unsupported pending a real destination.

No polling/retry/ticker/broad-hook workaround was required.

## Result

**F.6 CLOSED.**
