# P0403 — Late acceptance during quest progress and rewards

## Evidence

GitHub main P0402 e8be49d786e0468de8acc49de9996765ba46b294. November 8, 2026, WoW Forever 0.0.286-dev, session 60. Report Bug incident 7173 correlates with WoWScrnShot_110826_141639.jpg. The screenshot shows the Blizzard progress panel for Note to William (107), with Continue available and the Logres dialogue absent.

- #7067–7083: Accept for quest 35. The client then presents and Logres owns completion for quest 62 (#7075–7078). QUEST_ACCEPTED for quest 35 dismisses the new presentation (#7081–7083). Reopening allows turn-in of quest 62 at #7099.
- #7159–7173: Accept for quest 61. Logres owns progress for quest 107 (#7166–7168). The older acceptance restores Blizzard progress, hides Logres and confirms quest 61 (#7169–7172), immediately before the incident.
- Later local session 61 shows that quest 107 can be reopened, continued and turned in (#7255–7278). This demonstrates recovery by reopening, while the original single-window handoff failed.
- Incident 7173 also includes a complete retained taxi inventory after the map closed. The 20 direct children are one noninteractive TaxiRouteMap leaf, one interactive close button and TaxiButton1–18, all direct click/motion leaves. This explains why treating the extra children as decorative would be unsafe. L-004 positioning remains open and is outside the quest fix.

## Change

The dialogue event handler already preserved a newer offer or parked greeting. Extend its matching pending-acceptance guard to newer, already-owned progress and completion. The guard consumes the pending acceptance, emits both ordinary IDs and the stage, and keeps the current presentation and its stock restoration owner. Same quest, unavailable or secret event identity, no pending acceptance and unowned or unsupported views keep the existing teardown and fallback. No new native API call, frame, timer or stock suppression. L-001 remains OPEN and transient native flashes remain deferred under L-002.

## Validation

Replay both captured event orderings through the live event callback in isolation. Test same ID, wrong ID, missing pending ID, unowned progress/completion, hidden and secret input paths. Verify normal stage exit still tears down and the existing offer and greeting guards still work. Forever remains UNVERIFIED for P0403. When gameplay naturally presents consecutive quests, verify the next Logres Continue or Complete Quest stays usable. If stock takes over, click Report Bug while it is visible and export after /reload.
