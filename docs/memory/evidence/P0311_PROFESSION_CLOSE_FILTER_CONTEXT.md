# P0311 — Profession Goodbye and native filter visibility

2026-10-22. Source baseline pushed P0310 `cb1a83f` (0.0.211-dev). **PREPARED; full WSL static and WoW runtime UNVERIFIED.**

## Observed evidence

- User supplied screenshots showing **P0310 P — Previews → Trainer Empty Preview** and live **Grimnur Stonebrand Fishing** using the same parchment landscape, one disabled informational row, and Blizzard's trainer still accessible: scoped visual/lifecycle PASS.
- The stock Grimnur frame shows `Journeyman Fishing — Already known` while `GetNumTrainerServices()` returned **0** under the existing filters. Logres does not receive that known rank from its current service sample. Native UI cannot yet be removed without an information replacement.
- P0309 user-confirmed Enchanting one-skill purchase PASS; class native-close Goodbye PASS, earlier class Train All and single purchase PASS in separate contexts. Class purchase while native window parked not separately exercised. Cooking purchase, other professions' single transactions, and unowned profession trainer status remain UNVERIFIED.

## Narrow policy and code

P0311 extends the *service-specific close boundary* by adding an independently gated `NPCTrainerProfessionCloseTrial`. One deliberate Logres Goodbye in a confirmed ordinary profession session first runs `Trial.Disable("goodbye")` and its stock anchor restoration. Only when that succeeds is one `CloseTrainer` request issued. Class-only close implementation and transaction controllers are not modified. On a missing/secret/protected/combat API the native Blizzard frame is left available. The close request is not itself proof of completed native teardown.

A separate `NPCTrainerFilterState` copies only ordinary `GetTrainerServiceTypeFilter("used"/"available"/"unavailable")` results. Where the Known category is reliably OFF on a zero-service trainer, Logres explains that Blizzard's current filter excludes known entries; it never asserts the character knows Fishing or is missing a particular profession. UNKNOWN values retain the neutral P0310 text. No filter mutation, source spoofing, timers or native-presentation reads.

## Preserved limitation and next gate

P0311 **does not park or suppress profession Blizzard UI**. Known rank rows are not comprehensively mapped; blindly hiding native controls would discard the already-known information visible at Grimnur. A later capability-gated source adapter must provide equivalent known/acquisition information before replacing stock. The existing P empty fixture remains inert and visually unchanged; no additional P action is needed for this data-only status variation. Subsequent order: trainer family final regression, NPC gossip, merchants, flight masters.

## Runtime test and PASS rules

After guarded WSL PREWRITE/POSTWRITE and push, deploy and `/reload`. Visit Grimnur or any normal profession trainer. Logres should open in the established layout, and clicking Goodbye should close BOTH Logres and the native trainer without a stock flash, then reopen on a new NPC visit. For an empty service list, when Known filter is OFF, the detail text should explicitly state the filter limitation; if not observable, the generic description is correct. Check class trainer opens/Goodbye still works; native stock remains visible for profession sessions before Goodbye. No purchase needed. Any Lua, taint, secret or protected-action error is FAIL. This is not an authorization to call native purchase/Train All on zero-service states.

## Historical failures

Preserve P0303 R0 and P0307 R0 PREWRITE defects, P0304 initial automatic entry failure, P0306 profession-native stock suppression defect fixed by P0308, and P0310 R0 9/181 prewrite failure plus rejected slash-only R1. They are historical project evidence and not cleared by this P0311 static candidate.
