# P0090 — Live Objective Progress Preview

Date: 2026-10-02
Result: PREPARED — RUNTIME RETEST PENDING

## Baseline

P0089 runtime implementation verified pushed:
`1781c038637cef750061e20635e4c1310dcecc96`.

## Runtime

`0.0.35-dev -> 0.0.36-dev`.

## Evidence

P0089 runtime proves:
- quest 237 live objective source refreshed `3/10 -> 4/10`;
- QUEST_LOG_UPDATE advanced;
- QUEST_WATCH_UPDATE advanced;
- stale-source concern is closed PASS.

The same session does not prove the production pulse because no post-change
Objective Progress Check was captured before reload.

P0089 Preview is intentionally generic and the user reports that as a usability
regression.

## Change

Objective Progress Preview now:
- reads the current active quest passively;
- reads current objective rows passively;
- formats at most two current rows through the existing production formatter;
- returns `shown-current` when live rows are shown;
- falls back to `PREVIEW · Objective progress · 3/10` only when current rows
  cannot be safely presented;
- returns `shown-fallback` for that fallback.

Preview does **not**:
- call `Refresh`;
- call `SetBaseline`;
- change `currentQuestID`;
- change `baselineRows`;
- change production counters.

## Unchanged production contract

No change to:
- quest identity policy;
- objective API;
- secret handling;
- first-sample baseline;
- same-quest change comparison;
- QUEST_LOG_UPDATE;
- QUEST_WATCH_UPDATE;
- SUPER_TRACKING_CHANGED rebaseline;
- PLAYER_ENTERING_WORLD rebaseline;
- 3-second timer;
- Immersion policy;
- Blizzard Objective Tracker ownership.

No polling, delayed reread, broad hook, or periodic reassertion.

## Validation

After verified push:
1. deploy `0.0.36-dev`;
2. with a live multi-objective quest, Preview should report `shown-current` and
   display the current objective rows;
3. without usable active objective data, Preview may report `shown-fallback`;
4. natural same-quest objective change should produce one automatic production
   pulse;
5. immediately run Objective Progress Check before reload;
6. Quest Probe should confirm the same updated count;
7. no duplicate pulse without another change.

WoW redeploy required after verified push.
