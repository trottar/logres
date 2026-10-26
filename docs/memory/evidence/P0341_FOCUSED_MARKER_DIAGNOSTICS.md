# P0341 — generic focused-compass-marker diagnostics

**Baseline:** verified GitHub `main` P0340 `27fb9eb69bae6b844433ed4bbf3170cae2542dc2` pushed on October 25, 2026. Its manifest reports 211/211 PREWRITE and POSTWRITE static checks and no client validation; current Logres version `0.0.232-dev`. All P0330–P0338 live visual/functional outcomes remain **WoW UNVERIFIED** until contingent November 4.

## Targeted evidence

P0338 `Logres/Navigation/Compass.lua` already computes and caches three addon-owned, secret-guarded fields from the currently painted/focused marker: `focusedMarkerKind`, `focusedMarkerDistanceAvailable` and `focusedMarkerDistanceYards`. A manual waypoint uses separately validated same-map yard data; no native or protected readback is needed for these fields. `Compass:GetDebugStatus()` already exposes all three. However, `Logres/Core/Commands.lua` Phase E **Compass Check** only prints the older *focused quest* fields; Phase 0 **Gameplay Snapshot** also prints only older quest-distance fields. P0339's source-verified regression matrix explicitly records this missing diagnostic coverage.

## Narrow correction

Add one additive line to the existing Phase E Compass Check and Phase 0 Gameplay Snapshot that prints the already cached focused marker kind, valid-distance boolean and distance in yards, using `GetDebugStatus` from the existing guarded path. Missing focus displays `none`/`false`/`unavailable`. Keep the original quest-specific status lines. Do not sample new map/player/Blizzard data, change focus selection/rendering/update frequency, modify native presentation, create a second HUD or inspect secret-capable values. The saved gameplay snapshot continues to use its existing bounded Logres-owned diagnostic exporter.

P0339's historical static checker must be migrated narrowly: it currently asserts the literal previous absence of this diagnostic in the matrix. Replace that outdated negative assertion with an explicit source + matrix availability requirement; retain all 17 registered panel commands, P0321-first ordering, historical issue states and runtime-gate checks. Update the November 4 matrix to correctly say the new diagnostic is available **after P0341**. Increment TOC and Bootstrap from `0.0.232-dev` to `0.0.233-dev` with no Lua load-list changes.

## Negative evidence, limitations and validation

No new symptom has been reproduced; this is a source-demonstrated **diagnostic omission**, not proof that focused compass distances are visually or geographically correct. `GetDebugStatus()` is an addon-owned *cached* summary and does not attest Blizzard map/source accuracy, UI text visibility or clickability. No L-022 screenshot, L-027 native popup `/fstack` owner, or client-tested target aura/pet/quest outcome has been obtained. The old P0337/P0338 PREWRITE packaging failures are preserved in their original evidence. P0321 native GossipFrame restoration remains the first client safety test. L-019 project-root public distribution license unresolved; alpha/public release not approved.

**Required acceptance:** exact P0340 baseline/blob checks, 212/212 PREWRITE shadow and POSTWRITE static suite, candidate diff hygiene, and no WoW PASS inferred. Client test is **DEFERRED** until Forever beta access: Phase E Compass Check and Phase 0 Gameplay Snapshot while naturally focusing a marker, compare cached values with actual visible marker text and movement, test a manual waypoint/unavailable case; use existing SavedVariables export on `/reload` or logout. Stop on Lua, taint, protected/secret errors. Run this only after P0321 stock restoration safety gate. No contrived gameplay/travel.

## R0 PREWRITE refusal and corrective policy (2026-10-25)

**Observed failure / NOT a WoW outcome:** User WSL verified the original P0341 ZIP SHA-256, extracted it, and executed `P0341_APPLY.py` on the clean P0340 baseline. PREWRITE shadow stopped at checker **27/212** (`tools/check_checker_version_policy.py`), reporting `tools/check_p0341_focus_diagnostic_contract.py` pinned an exact historical runtime version. The applier reported **no WoW PASS** and wrote **no tracked files**.

**Cause:** P0341's own long-lived feature checker combined dynamic TOC/Bootstrap parity with an exact version literal, contrary to `docs/memory/AGENTS.md` and the established `check_checker_version_policy.py` contract. This should have been caught against the exact post-transform candidate *before* handing over R0. This is an assistant patch-delivery validation failure, not a client bug.

**R1 remedy:** The new checker asserts valid, matching TOC/Bootstrap version metadata without freezing a specific value; the applier scans prepared checker text for historical-version literals and runs the repository's checker-version policy first in the shadow and postwrite suites. No game logic change from R0. **PREWRITE/POSTWRITE full 212-checker results remain to be earned in user WSL**; offline local syntax and targeted policy execution are not substitutes.

**Incorrect previous test handoff:** R0's user-facing answer contained deployment and in-game commands even though repository roadmap and current test evidence say the Forever beta is unavailable until contingent November 4. That was contrary to authority and unnecessary. R1 contains only offline patch/application commands; there is **no request to deploy or run a WoW test now**.

Disposition: R0 **REFUSED / CLOSED as package**, preserved here; R1 **PREPARED / WoW UNVERIFIED**.
