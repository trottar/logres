# P0385 — Quest greeting and native completion provenance

Date: 2026-11-07. Baseline: P0384 `c1c77e288fa295d2001256129096ce7bb57795b1` verified on main. This is a READ-ONLY diagnostic checkpoint; no gameplay resolution is claimed. Build 0.0.269-dev, expected checker #255.

## Observed failures and evidence

- L-002 OPEN: user reports a brief native quest panel during turn-in, too fast for human screenshot. Source `QuestCompletionControl:Click` calls `Restore("claim-invoked")` before `_G.QuestRewardCompleteButton_OnClick`. Historical P0251/P0377 enforce native restoration before native claim, so do not change that order speculatively; trace the actual stock-release request and subsequent event instead.
- L-001 OPEN: previous incident 2963 QUEST_TURNED_IN quest18, screenshots incidents 2967/2971/2975 show native Deputy Willem two-quest list with no Logres equivalent. The live NPC presenter only listens to GOSSIP_SHOW; multi-quest `QUEST_GREETING` is its own QuestFrame event and not handled. Source list model currently reads C_GossipInfo, not QuestFrame greeting APIs. No QuestFrame replacement action or safe parking policy exists. Single-window functionality requires complete native selection and fail-open restoration coverage first.
- L-005 PARTIAL: quest18 `QUEST_TURNED_IN` observed; P0384 quest21 incident 3196 hover falls inside both label and button. No fixed offset proven. L-040 local EST export appears correct.

## Scope and safety

On QUEST_GREETING, one bounded read of GetNumAvailableQuests/GetNumActiveQuests, title lists and GetGreetingText validates ordinary types only. Never retain unvalidated/secret data. Store two bounded counts/status and emit one addon-owned journal event. Report Bug records latest counts/status. Add a completion-stock-restore-requested journal event after the unchanged native restore. No rendered UI, native frame read/mutation, protected state introspection, automatic click, repeat timer, source ownership claim or data migration. Native QuestFrame remains visible and usable.

## Runtime validation

At an NPC offering multiple quests, open the native list naturally, then trigger Report Bug or simply export after leaving. Expect `greeting-observed` with count/status; diagnose missing event or unsafe API as unresolved, not PASS. At an ordinary turn-in, existing Logres click emits `claim-stock-restore-requested` before native claim and eventually QUEST_TURNED_IN if successful. No split-second screenshot required. Do not close L-001 or L-002; separate later functional patches are required after event-based evidence.
