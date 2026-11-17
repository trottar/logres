# P0473 — Focused-quest cycling and native keybinding

2026-11-17. Baseline GitHub main `79bfc5a0500de2b20aa53e42c4e966ac91563fb1`, tree `96712192f0be2981632ce37c91dcbf0cf1b37031`, P0472. User reports chat default works. This is a new capability request, not an existing bug; P0471 crest validation remains OPEN.

## Source review and design

Logres ActiveQuest calls QuestObjectiveProgress:ReadActiveQuestID; native C_SuperTrack.GetSuperTrackedQuestID precedes C_QuestLog.GetSelectedQuest fallback. ActiveQuest and Compass subscribe to SUPER_TRACKING_CHANGED. Keep this single native focus authority, not a divergent saved quest list. MissionFocus and Quest Beacon document next-quest and user-configurable binding patterns; Warcraft Wiki describes native auto-loaded Bindings.xml. Independently implemented; no external addon code copied.

Report Bug captures only addon-owned cycle counters and reasons, not native frame state. One small existing-sheet chevron at focused title right cycles log-order non-header quest IDs via C_QuestLog.GetNumQuestLogEntries and GetQuestIDForLogIndex. Bounded to 128 entries; any unavailable/secret/failing/invalid source refuses whole operation, no partial focus. Fewer than two quests hides button. Existing Progress reader retains native focus precedence; exactly one user-triggered C_SuperTrack.SetSuperTrackedQuestID call, pcall-guarded, with ordinary readback or explicitly unconfirmed event handoff. No change to watches, selection, quest acceptance, quest objective suppression, saved DB or group interactions. In preview and OFF mode, no mutating operation. No timers, broad hooks, secret branching, or native frame changes. Bindings.xml is discovered by WoW, intentionally excluded from TOC; user picks key under Key Bindings > AddOns > Logres. No key is assigned automatically.

The historical F.6 Progress contract forbade every C_SuperTrack.Set mutation when objective progress was strictly a reader. This explicit user-controlled focus operation is a narrow scope expansion; updated legacy checker permits only the named AdvanceFocusedQuest block and keeps all other native/quest writes banned. The existing 96 loaded Lua source inventory remains unchanged.

## External source references

- https://www.curseforge.com/wow/addons/missionfocus (next/previous quest UX)
- https://www.curseforge.com/wow/addons/quest-beacon (next quest binding/command UX)
- https://warcraft.wiki.gg/wiki/Creating_key_bindings (Bindings.xml auto-load; native keybinding UI)
- https://warcraft.wiki.gg/wiki/API:C_SuperTrack.SetSuperTrackedQuestID (native focus change)
- https://warcraft.wiki.gg/wiki/API:C_QuestLog.GetQuestIDForLogIndex (accepted quest rows)

## Validation

Test in Forever with two accepted quests: panel right-chevron changes focus and compass; keybind under Key Bindings > AddOns > Logres performs same action, and last-to-first wraps. Verify no changes to watch flags, quest selection or saved state. One quest or unavailable/secret source hides/blocks cycling. Preview mode must not mutate native focus. Test immersion OFF and chat input handling, keybinding not overriding existing assigned keys. Phase P > Active Quest Check and Preview; use Report Bug and export bundle if failure. Static and fixture PASS are not runtime PASS. Any unsupported client API or protected/taint error keeps P0473 OPEN and preserves stock quest controls.

## Audit

Final full candidate checker/fixture/transactional ZIP results must be recorded in PRE_HANDOFF_AUDIT before delivery. WoW runtime UNVERIFIED.
