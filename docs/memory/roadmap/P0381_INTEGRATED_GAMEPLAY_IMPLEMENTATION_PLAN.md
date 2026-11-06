# P0381 — coordinated Forever gameplay implementation (next checkpoint)

Authority: `docs/memory/investigations/ISSUE_LEDGER.md`; P0380 evidence; observed client **0.0.264-dev**; verified pushed main **P0379**. This is the **implementation specification**, not evidence of a completed patch or successful in-game fix.

## Scope, priority, code owners

1. **Quest progress / Continue (L-002 and relevant L-005):** `Logres/Quest/Dialogue.lua`, completion lifecycle/offer handling. Add Logres Continue to a real, ordinary `QUEST_PROGRESS` context with an explicit native-progress transition. Only gate native controls when the replacement button, event identity, and restoration are supported. Preserve Blizzard Continue whenever the capability is absent, deferred, or errors. Never confuse progress Continue with reward claim.
2. **Quest reward choice / Complete Quest (L-005):** `Dialogue.lua`, `CompletionControl.lua`, `DecisionVisual.lua` action frame and `RewardVisual.lua`. The 0.0.264-dev incident 2399 records Enter/Leave, but no Down/Up/dispatch and no claim. Inspect actual addon-owned mouse hit geometry, action-root MouseEnabled, siblings/frame level and click lifecycle. Use focused evidence to correct the existing physical button, not a separate visual clone. Validate choice ordinal and native reward invocation with no double claim; confirm turn-in or restore stock. Do not inspect secret/protected native presentation state for proof.
3. **NPC ownership / fail-open (L-001, L-033, L-034):** `NPCGossipPresentation.lua`, `NPCGossipStockParking.lua`, trainer purchase controller, and quest presentation lifecycle. Source-check ownership and intentional interaction before showing quest narrative; retain Blizzard greeting, Continue, choice, Trainer and quest restoration for unsupported contexts. Limit mutation to capability gates; no periodic UI suppression.
4. **Menu / tracker visual collision (L-025, L-029, L-039):** `ActiveQuest.lua`, `Integration/Layout.lua`, action/HUD strata as evidence requires. L-039 screenshot 1321 shows right-side tracker text/icon collision but source owner UNKNOWN. Identify whether Logres or Blizzard frames are colliding, then apply owner-specific row bounds/spacing/clipping and menu priority without hiding required stock quest information. Separate general menu overlap L-025 from internal collision L-039.
5. **Related but gated:** L-038 reward tooltip live support may be included if existing working source and static tests support it. L-007/L-008/L-012/L-027/L-028/L-030/L-035/L-036/L-037 remain tracked; do not claim resolution without their independent evidence.

## Acceptance matrix (report individually)

| Case | PASS criterion | FAIL/DEFERRED gate |
| --- | --- | --- |
| Quest progress | Logres Continue appears on supported natural progress context and advances to completion | No action, wrong stage, or native button inaccessible is FAIL; missing natural quest is DEFERRED |
| Reward selection | Existing reward cards select the intended ordinal | Wrong ordinal or stock choice lost is FAIL |
| Completion input | Logres action receives actual Down/Up/dispatch and invokes guarded controller | Enter/Leave alone is FAIL |
| Claim | Identifiable transaction/turn-in, or explicitly usable native fallback on blocked route | `native-handler-invoked` alone is NOT PASS; dead-end is FAIL |
| Single NPC window | Correct quest/trainer owner; no unexpected ghost panel; stock restoration on unsupported stages | Overlap/dead stock controls is FAIL |
| Tracker / menus | No collided rows/icons; map/menus above gameplay HUD; correct visibility on reload | Any covered mandatory stock control is FAIL |
| Security and state | No Lua/taint/protected/secret errors; immersion OFF restores stock; relevant combat gates respected | Any safety exception stops validation |

## Patch and handoff procedure

Use P0381 ZIP with strict P0380 remote main baseline; patch code plus evidence+memory in a single transactional apply, static checker #251, full checkers PREWRITE and POSTWRITE, git diff --check, one-time manifest and no assistant commits. Deploy only to `_forever_/Interface/AddOns` then `/reload`, use native gameplay Report Bug and `python3 tools/export_panel_diagnostics.py`. Verify pushed commit before reporting durability. Distinguish static PASS from actual Forever client PASS. If one subcase fails, retain FAIL and correct that cause without suppressing stock fallback.
