# P0176 R1 — Restore disabled-snapshot regression-check compatibility

- **Baseline:** `main` `c55b6d7b1801229b7caa1eb1705dbd7100dc7d08` with no tracked changes; previous P0176 applier failed before writing files.
- **Status:** corrective candidate, not WoW runtime validated or pushed. `0.0.92-dev`.
- **Observed failure:** original P0176 shadow prewrite checker `check_status_aura_disabled_contract.py` returned `ERROR: cannot isolate disabled snapshot in StatusAuras:Refresh`. The original source instrumentation inserted `self:RecordLiveSnapshot` inside the `elseif active then` arm, interrupting the P0175 R3 checker-required source shape. Earlier checker passes were not full-suite PASS.
- **Narrow correction:** retain the entire original source history design and move only the recorder call to immediately after `self.last[unit] = snapshot`, protected by `if active and not self.preview then`. This preserves the precise disabled-snapshot adjacency and excludes OFF/preview; the existing R3 checker is untouched. Strengthen the P0176 contract to require post-snapshot guard and adjacency.
- **Impact:** no aura filters, native frame hiding, quest tracker hooks, rendering geometry, or secure interaction changed. History retains only bounded source-read counters, not spell identifiers or payloads.
- **Acceptance:** full repository checkers on exact prepared candidate; WoW Phase H preview/exclusion and Phase 0 Run All; mana HUD remains visible; live harmful evidence remains deferred unless naturally populated and visually checked. Original P0176 failure remains recorded.

## Post-push runtime evidence (verified `5379a9f`)

Uploaded `0.0.92-dev` loadCount 224 completed two Run All checks with HUD visible and session-history mechanics intact. Target helpful max=1, positiveReads=4; harmful categories remain zero and unproven. Preview did not contaminate history. `P0177_AURA_SOURCE_ENGINE_COMPARISON_2026-10-08.md` details the next source comparison.
