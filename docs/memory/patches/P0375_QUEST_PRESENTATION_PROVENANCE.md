# P0375 — Quest presentation provenance (source + issue evidence)

**Baseline:** pushed P0374 `c3412305bae8c32e36184d2f23ed0e7eceb0bbfa`.

**Patch content:** Event-driven observability of the Logres-owned `QuestDialogue` root plus optional, secret-gated native `QUEST_TURNED_IN` signal; bounded bug snapshot augmentation. No change to Blizzard presentation/interaction, reward claim, native fallback, existing timers or configuration. Runtime version increments to `0.0.261-dev`. The canonical issue ledger and P0375 evidence are updated in the same checkpoint.

**Acceptance:** Prewrite shadow 245/245 and postwrite 245/245 checks, unchanged historical P0373/P0374 contracts, repo baseline/blob verification, historical IDs and memory caps, `git diff --check`. These results are **STATIC**. WoW runtime remains **UNVERIFIED** pending natural gameplay evidence. L-002 and L-034 OPEN; L-005 PARTIAL; L-033 OPEN.

**Safety:** No native-frame introspection merely to prove a mutation; only additive Logres root hooks. No secret-capable payload is inspected without successful non-secret check. No polling, protected mutation, automatic claim, or change to restoration-before-native-handler contract. No Git commit or push from the patch script.
