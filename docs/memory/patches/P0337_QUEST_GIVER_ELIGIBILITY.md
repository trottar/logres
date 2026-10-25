# P0337 — native-corroborated QuestieDB quest-giver presentation

Baseline: verified pushed P0336 `d535906efe86d9502b595f884efd3118cc7da724`.

Scope: `Logres/Navigation/Compass.lua` current-offer evidence gating and diagnostic count, version bump `0.0.231-dev`, one new static checker, and authoritative memory checkpoint. Historical provider data and all native interactions/controls unchanged. `QuestieDBNearby` remains optional, retains service markers, and is not modified.

Rationale: historical NPC questStarts did not represent live eligibility. Only current native quest-start source indications authorize historical fallback glyphs, and absent source means no guessed Logres glyph. Quest log/map remain available. No blanket UI suppression or secret/protected mutations.

Validation: 208 PREWRITE shadow + 208 POSTWRITE expected in WSL; WoW preview/runtime UNVERIFIED until November 4. No Git commits/pushes by patch. L-030 remains pending natural gameplay proof.

## R1 correction

The R0 ZIP was rejected safely at PREWRITE checker 174/208: the new checker expected `if add(...) then`, but the source deliberately used `if not seenQuest[...] and add(...) then` to preserve deduplication. R1 migrates this exact self-contract, strengthens native/duplicate guard assertions and records failure evidence; Lua selection logic is unchanged. R1 remains unverified until all 208 PREWRITE and POSTWRITE static checks run in WSL. WoW runtime UNVERIFIED.
