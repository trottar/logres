# P0173 — primary stock ownership/runtime mode gate

Baseline GitHub `main` `3a5028c8f8cbf288a22b80d6de902dc7b2762b4e` / P0172 `0.0.88-dev` (verified). Candidate runtime `0.0.89-dev`. **RUNTIME UNTESTED.**

The P0172 user reports dock operations and most Blizzard roots folded; the native Main primary bar remains visible. The installed Logres Primary uses secure ID/actionpage normal pages but current diagnostics show `keys=false/12` and policy `primaryRoutingOwned=false`. A direct MainActionBar Hide would risk inaccessible stock page/vehicle/override controls during combat and break Quick Keybind/Edit Mode, since the full secure fallback/transition has not been reproduced in the actual client. Preserve Main and provide a first-class source- and runtime-backed diagnostic gate rather than fabricate a safety proof.

Implementation:
- Read-only `Primary:GetStockOwnershipGate()` checks exact `MainActionBar.actionButtons[1..12]` existence, classifies five `C_ActionBar` mode APIs after secret preflight, records existing secure paging and optional temporary binding route. Does not inspect native hidden/alpha state or protected action values.
- `/logres primaryownershipcheck`, Phase C developer panel **Primary Ownership Check**, and `Run All` report a separate **PASS** for an ordinary complete read-only source sample or **DEFERRED** for missing/unclassified state. The output explicitly marks `suppressAuthorized=false`; even PASS is NOT a Main suppression pass.
- Version synchronized, durable evidence and current memory in one transaction, new static contract checker.

The one-time applier refuses wrong main baseline or dirty tracked tree, checks exact anchored transformations, builds a local Git shadow checkout and runs every `tools/check_*.py` plus `git diff --check` on the exact combined candidate before touching the user's tracked files, then performs transactional writes/checks and creates P0173_MANIFEST.txt. Never commits, pushes, stages or changes refs. Stop on failure and report status and traceback; do not retry/reset without classifying partial state.

Post-deployment proof: primary ownership first on clean login, user-triggered normal Logres Primary click and existing key after Action Keys ON, stock key restoration after Action Keys OFF, naturally available page changes, special state only if naturally encountered, Run All, screenshot. No travel required to manufacture special contexts. Main remains visible, intentionally; suppression and H.1 closure are not claimed.
