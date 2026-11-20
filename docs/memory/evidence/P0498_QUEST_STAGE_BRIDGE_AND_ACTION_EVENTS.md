# P0498 — Guarded quest-stage handoff, read-only action combat evidence (2026-11-20)

## Baseline and user evidence

Verified GitHub main P0497 `4a3437ce2716ce6f449e6299640034f565571cdc`, tree
`ed9809900238cdb6cbe19e9803a2b06179708d05`, source `0.0.363-dev`.
Latest Forever bundle, sessions 183, incident #18908, shows quest 88 Progress → Completion:
`progress-owned` → `progress-continue-requested` → `progress-restored`
(`QUEST_FINISHED`) → `completion-presentation` → `completion-owned`, all
at the same-second event boundary. The user reports a very brief stock
Blizzard QuestFrame flash while stages change, visually too fast to capture.
The journal confirms a restoration window but not the pixel-level flash.
Quest 88 claim sequence: `claim-stock-restore-requested` →
`native-handoff-held` → `QUEST_TURNED_IN`. The native claim handler
requires fully restored stock input (P0251/P0377); this patch does not
change the claim ordering or claim suppression and does not guarantee
removal of claim-side stock flashes. L-002 remains OPEN.

User also reports once-only failure of action bars to appear in combat.
Capture #18858/#18860 has `actionContext.policyName=combat` while the
captured shared state shows `combat=false`; this is an event/snapshot
ordering discrepancy, not proof of an alpha-driver or secure-layout defect.
No recurrent failure was captured. L-055 OPEN / INTERMITTENT /
UNREPRODUCED, with past P0491/P0492 failures and positives retained.

## Narrow implementation

At `QUEST_FINISHED`, only an already-owned, pending native Continue
may hold the ORIGINAL pre-progress native presentation snapshot. The
immediately following `ClearActiveDetail(QUEST_FINISHED)` then dismisses
the old Logres view without restoring native alpha/mouse. A one-shot
0.05-second fail-open timer is installed BEFORE detaching the old owner;
no polling. At `QUEST_COMPLETE`, the pending snapshot is adopted only
when current guarded `GetQuestID()` matches the previous ordinary quest,
`CanBridgeVisual` verifies unprotected capability, and fresh READ-ONLY
subtree capture matches original native child identity and order. The
completion controller adopts the ORIGINAL pre-progress alpha and mouse
restoration token, not the already-suppressed alpha at event time; no
second native suppression or new input owner is created. Other lifecycle
events release the token before presenting unrelated stages. On unsupported completion, changed children, changed identity,
failed gate, no replacement view, preference OFF, module disable, or
abandonment, original stock is restored. No secret/protected values are
compared or formatted. Existing native claim handler and its
restore-before-dispatch contract are untouched.

ActionContext records read-only observed `PLAYER_REGEN_DISABLED` and
`PLAYER_REGEN_ENABLED` counts, event-time addon policy, and preexisting
secure-driver setup result, carried into Report Bug snapshots via DevPanel.
Transition events also record addon-owned policy/driver status in the
bounded journal; no secure state interrogation, alpha writes, protected
frame reads, timers, polling, or changed action binding.

## Test and risk gates

`tools/test_p0498_quest_bridge.lua` executes actual QuestDialogue and
CompletionControl source with mocked ordinary native frames. It covers
actual `QUEST_FINISHED` → `QUEST_COMPLETE` ordering, adopted completion
without visual restore gap, exact child-identity refusal, rejected
completion fallback, one-shot abandoned transfer restoration, changed
quest identity and mandatory full stock restoration before claim.
`tools/check_p0498_stage_bridge_action_events_contract.py` protects the
legacy function signature, claim restore order, no new action mutation,
source version, event telemetry and bridge tokens. Historical checkers
remain mandatory; static results must be recorded in PRE_HANDOFF_AUDIT.

**No WoW runtime result exists for P0498.** The user must verify ordinary
Progress → Completion, completion choice claim, unsupported quest fallback,
no invisible Blizzard click regions, and no taint/protected errors. A
native flash specifically during claim remains a known OPEN case and must
not be concealed by hiding clickable stock controls.

## Candidate negative result: too-late bridge arm (not released)

The first P0498 implementation created the bridge only within
`HandleQuestComplete()`. Review of the actual session183 journal showed
`QUEST_FINISHED` had already executed `ClearActiveDetail()` and restored
the stock snapshot before that call. The initial prototype therefore
would not have addressed the reported Progress→Completion flash despite
its helper tests passing. This candidate was **rejected before release**.
The corrected version arms the bridge at `QUEST_FINISHED`, then validates
and consumes it at `QUEST_COMPLETE`; the actual-source fixture tests that
full event order. It still cannot guarantee there was no earlier native
pixel exposure within Blizzard's own event dispatch; runtime remains OPEN.

## Assistant pre-handoff static result

Corrected P0498 source passed 359/359 historical `tools/check_*.py`,
changed Lua syntax, actual-source stage bridge/claim fixture and memory
health. All 18 changed payload files were verified against the P0497
baseline and packaged candidate; rollback and baseline refusal checked.
Static success is not an in-client visual or action-bar runtime PASS.
