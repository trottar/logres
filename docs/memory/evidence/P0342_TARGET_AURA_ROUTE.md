# P0342 — L-028 target aura presentation-path provenance

**Evidence class:** source audit, NOT WoW runtime PASS. Verified remote `main` P0341 R1 `fb3b2658985e7f6d05f7730a3de6eb7b7dca6ad9` on October 25, 2026; its manifest reports 212/212 PREWRITE/POSTWRITE static checks. Current source version is `0.0.233-dev`.

## Reproduced source-level diagnostic ambiguity

`StatusAuras:Refresh` activates the existing Blizzard-backed `NativeDebuffs` AuraContainer when it is available, then renders the ordinary Lua target harmful fallback row **hidden** while native is active. `StatusAuras:GetDebugStatus` correctly distinguishes cached `nativeReady`, `nativeActive`, `targetHarmfulShown` and `targetHarmfulVisible`; the last is the number of ordinary fallback rows, even if that lane is hidden. Yet the one-shot Phase 0 `Gameplay Snapshot` currently reports only `targetHarmful` row count without the native/fallback source route. A positive count is therefore not proof that those icons are displayed. This ambiguity obstructs classification of the user-reported L-028 duplicate/missing target DoTs, especially after P0332 corrected only the ordinary fallback reader. `H — Status Aura Check` already carries the owner details, but reproducing an intermittent symptom benefits from recording them alongside the one-shot diagnostic.

## Narrow correction

Append a single read-only cached route line to `Logres/Core/Commands.lua` inside the existing P0329 `RunGameplayCapture` StatusAuras block. It prints `nativeReady`, `nativeActive`, `ordinaryFallbackShown`, and `ordinaryFallbackRows` from the already returned `StatusAuras:GetDebugStatus`, with an explicit warning that addon-owned status does **not** attest native icon visibility. The pre-existing summary remains byte-identical. It invokes no new WoW API and does not inspect, classify or serialize aura identities, spells or secret-capable Blizzard presentation state. No extra polling, event, secure frame operation, native suppression, user setting or database migration.

The November 4 regression matrix retains P0321 GossipFrame safety as the first client gate. For L-028, correlate the captured route with an actual screenshot and H — Status Aura Check while naturally applying or removing DoTs. Unknown/unreproduced cases remain OPEN; secret aura data is never probed. L-022 quest artifact screenshot, L-027 popup `/fstack` owner and L-019 licensing remain outstanding. Public release is NOT APPROVED.

## Failure and deployment boundary

The previous P0341 R0 package failure was a hardcoded historical version pin in its own checker; it was refused at PREWRITE 27/212 with no tracked writes and repaired by P0341 R1. The earlier assistant also incorrectly issued beta deployment/test instructions while the client was unavailable. This P0342 checker uses only dynamic TOC/Bootstrap version parity; the P0342 applier runs `check_checker_version_policy.py` before the whole candidate test suite. A0/A3 alpha staging and the other unresolved gameplay symptoms remain separate. All **213** PREWRITE-shadow and POSTWRITE checks must pass in user WSL; **WoW runtime remains UNVERIFIED** until contingent November 4 access. Do not request in-game deployment before then.

## P0342 R0 PREWRITE failure / R1 corrective package (2026-10-25)

**Observed:** User verified SHA-256 and extracted the original P0342 ZIP on the pushed P0341 R1 baseline. `P0342_APPLY.py` refused at PREWRITE shadow: 25/213 checkers (positions 129–153, trainer contracts P0292–P0316) all rejected generated `docs/memory/CURRENT.md` for exceeding the **strict 10000-byte maintenance budget**. No tracked write was performed. This is an assistant packaging/contract-preflight failure, not a WoW runtime result.

**Cause:** R0 prepended a verified-P0341 bullet and detailed next-work prose to an already near-limit `CURRENT.md`, duplicating older checkpoint history. The synthetic local fixture was too short to exercise the real memory budget. The applier only discovered the breach inside the full shadow suite, reporting 25 related contract failures.

**R1:** Keep CURRENT authoritative but concise: replace duplicated historical `Verified State` prose with compact references retaining all original P0317–P0341 milestone tokens, verified commits, failures, open issues and release limits; keep full negative history in dedicated evidence and roadmaps. Strip redundant annotations from the CURRENT reference list without dropping paths. Add an exact post-transform UTF-8 **under-9800-byte preflight** before creating the shadow, with the existing <10000-byte repository policy unchanged; run the entire 213-checker shadow/postwrite suite. The companion new contract asserts this tighter candidate budget. WoW remains UNVERIFIED, and **no in-game deployment/test is requested while Forever is unavailable**.

## P0342 R1 PREWRITE failure / R2 corrective package (2026-10-25)

**Observed:** The user verified P0342 R1 ZIP hash, extracted it and ran the guarded applier on clean committed P0341 R1. PREWRITE shadow completed 213 checks with **1/213 failure**, checker **175/213 `check_p0338_focused_compass_yards_contract.py`**. Its existing contract requires the five literal tokens `P0337`, `cfdc07af`, `P0338`, `L-031`, `UNVERIFIED` in both CURRENT and CURRENT_HANDOFF. R1's compact generated CURRENT omitted `L-031`. The applier refused **before any tracked write**, and no WoW validation was attempted.

**Cause:** R1 solved the 10000-byte budget but locally tested only the new P0342 fixture; it did not run the older P0338 checker against the exact generated candidate before handoff. The missing literal is a documented continuity invariant, not a reason to relax the P0338 checker. The previous R0 25/213 budget failures and R1 1/213 continuity failure are both assistant patch-delivery failures, retained independently.

**R2 remedy:** Restore `L-031` explicitly to compact CURRENT's verified P0338 status, preserve its other P0338 literals and existing handoff. In `P0342_APPLY.py`, before preparing the shadow, verify generated CURRENT and handoff contain **all five** P0338 tokens, check CURRENT <9800 UTF-8 bytes, and retain the exact baseline/blob, candidate hygiene, full 213-checker PREWRITE and POSTWRITE, transactional rollback and manifest guards. Extend P0342 checker to protect those literals independently. No additional gameplay or native code is changed beyond the original read-only route diagnostic. In-game behavior still UNVERIFIED until a real client opportunity; L-028 remains OPEN.
