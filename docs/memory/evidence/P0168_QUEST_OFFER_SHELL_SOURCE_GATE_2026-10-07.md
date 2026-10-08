# P0168 — Ordinary quest-offer shell source and capability gate

Date: 2026-10-07
Status: SOURCE-SUPPORTED CANDIDATE — RUNTIME/PLAYABILITY UNKNOWN
Baseline: `f58bccfb91fe8f6165b543c936cea4bb0ac29a06`

## Correction

The user's original request was to remove Blizzard duplication before authored layout. Claiming H.1 closed when the only new hiding was P0165 Accept/Decline was incorrect. P0164's matrix identifies blockers but does not itself implement suppression. This negative project/process finding is retained.

## Exact source

Forever `1.60.1.70245` source pin: `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca`.
`Interface/AddOns/Blizzard_UIPanels_Game/Vanilla/QuestFrame.xml`: `QuestFrameDetailPanel` contains `QuestFrameAcceptButton`, `QuestFrameDeclineButton`, `QuestDetailScrollFrame`; `QuestFrame` retains progress/reward/greeting siblings.
`Mainline/QuestFrame.lua`: `QUEST_DETAIL` shows DetailPanel and native quest panel; `QUEST_PROGRESS`, `QUEST_COMPLETE`, `QUEST_ITEM_UPDATE` update state; `QuestFrameDetailPanel_OnShow/Hide/Update` retain fade/close interactions. Never `HideUIPanel`, `QuestFrame:Hide`, `SetParent` or suppress the event lifecycle.

## Gate

Existing P0130–P0133 Logres offer narrative/paging and Accept/Decline action are runtime proven, and P0165 normal offer button suppression/restoration is accepted. Therefore in that *one ordinary offer state* the redundant stock visual shell can be hidden while keeping the actual QuestFrame shown for Blizzard script handling.

Implementation snapshots root alpha as an opaque restoration token, enumerates a bounded QuestFrame descendant mouse-frame subtree, checks secret-capable state before decision, records ordinary mouse booleans, and suppresses root alpha + all captured mouse regions. Never remove mouse input without exact restoration; no blanket hidden parent or reassertion. Unsupported offers, combat, missing frames, secret inputs, or oversized/unreadable subtree retain Blizzard UI. On confirmed quest state transition and Immersion OFF/actions, restore exact alpha/mouse before Logres controls go away. Emergency restoration uses visible root alpha and captured mouse booleans.

## Exclusions / deferred

Primary MainActionBar remains stock during special/override state because Logres normal primary paging and routing are not a complete secure fallback; pet edit/reorder/bindings remain incomplete; full tracker/log, minimap/tracking results, party/group interaction, player harmful/target auras, permanent XP remain separate incomplete ownership. This P0168 patch does not falsely claim all Blizzard UI is now removable.

## Runtime gate

One naturally available normal offer (not PvP/auto-accept) with a screenshot of the stock frame absent but Logres offer visible, no invisible click zones, Immersion OFF restore and ON suppress, Logres Accept or Decline resolving normally, no Lua/protected/taint/secret errors, and Phase H Quest Offer Stock Check + Phase 0 Run All PASS. Unreproduced/untested cases remain environmental deferrals.

## R1 event-lifecycle correction

`QUEST_ITEM_UPDATE` is handled by Blizzard while `QuestFrameDetailPanel` remains shown, refreshing quest reward/items without ending `QUEST_DETAIL`. R0 erroneously added it as a stock-restoration event, potentially revealing the Blizzard shell during an owned offer. R1 removes only that trigger. The R0 shadow-contract self-mismatch failed before any tracked writes.
