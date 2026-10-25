# P0337 — L-030 current-offer evidence gate

Status: SOURCE-PREPARED / WoW RUNTIME UNVERIFIED until November 4, 2026.

## Verified repository baseline

GitHub main `d535906efe86d9502b595f884efd3118cc7da724` is pushed P0336, whose manifest reports 207/207 PREWRITE and POSTWRITE static checks. P0336 same-bearing placement remains client UNVERIFIED. P0335 popup ownership remains OPEN.

## Narrow source finding

`QuestieDBNearby:ScanChunk` uses `NpcDB.questStarts` historical provider records and stores an NPC's first quest ID and spawn points with `potential=true`. These are possible *historic* quest giver sites; no observation verifies whether the NPC currently offers a quest, whether prerequisite/level conditions are satisfied, or whether a quest has already been completed. Prior `Compass:RefreshAvailableQuestPOIs` added every nearby historical quest NPC as a candidate regardless of live availability. By contrast, `NavigationSourceProbe` provides secret-classified, ordinary current-map quest-start rows with `role="poi"` or `eligible==true` when the native APIs report corresponding states. These native indications are not proof of a live NPC dialogue but are substantially narrower than QuestieDB history.

## P0337 selection boundary

Build a local set of native-reported current quest-start IDs from these pre-existing ordinary source snapshots. A historical QuestieDB quest-giver glyph may enter the active local-POI pool only when its ordinary quest ID is present in that set. Exclude and count each uncorroborated historical candidate. Keep provider counts and read-only source data, QuestieDB service roles, native-map POIs, vignettes, player waypoint, focus, collision and all Blizzard fallback unchanged. Allow a provider position to backfill a native-confirmed quest whose own position was not usable, by marking duplicates only when `add(...)` accepted a positioned candidate. Native source unavailable means no historical QuestieDB quest-giver glyph, NOT false denial of a quest offer; the Blizzard map/quest log remain accessible. No source API calls from Compass, no scan/poll/hook expansion, no protected-state checks.

## Limits and negative findings

No publicly proven Forever API in this checkpoint confirms the quest NPC's interaction marker actually shows an exclamation point. The native candidate feeds may omit offers or include conditional quests. The first-provider-quest record remains a separate limitation; do not claim complete current-offer coverage, source equivalence, or runtime PASS. No quest eligibility is inferred from merely being unaccepted, NPC level, QuestieDB's historical questStarts, or a previously completed quest. Visual and gameplay validation are DEFERRED until November 4.

## Validation

P0337 checker fixtures cover native-confirmed, historical-only, invalid, absent native list, and duplicate native positions. Required clean P0336 baseline, 208/208 PREWRITE shadow and POSTWRITE static checks, diff hygiene, manifest; these are not client PASS. At reopening, compare map/quest log with available and unavailable/future NPCs, natural quest completion, native-services continuity, and no secret/Lua errors. L-030 remains runtime UNVERIFIED.

## P0337 R0 failed PREWRITE and R1 corrective packaging (2026-10-25)

R0 ZIP checksum verified and extracted, but its guard stopped at **PREWRITE 174/208** in the **new** `check_p0337_quest_giver_eligibility_contract.py`: `AssertionError: native corroboration or positioned dedup absent: if add(row,"poi","db"..tostring(row.npcID)) then`. User output shows **1/208 failed**; all other 207 checks passed within that PREWRITE run. The intended Lua code correctly placed `add(...)` as the second conjunct of `if not seenQuest[row.questID] and add(...) then` under the native corroboration gate. The checker was incorrectly pinned to an unguarded `if add(...) then` spelling that would drop the duplicate check. **No tracked writes occurred**; no commit, runtime validation, or client result is implied.

R1 corrects only the mismatched checker expectation, explicitly verifies the full guard and its ordering, and updates negative evidence/memory in the same patch. Quest eligibility policy, Lua source transformation, and all existing static checks remain unchanged. Complete **208/208 PREWRITE and POSTWRITE** checks in the user WSL checkout are still required. Status: R0 packaging failure CLOSED by corrected candidate; R1 static/runtime verification PENDING, WoW UNVERIFIED.
