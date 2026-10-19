# P0270 — Native service frame metadata capability audit

Date: 2026-10-19. Baseline: verified pushed main P0269 `1588fb9e64f94ea9870354726cf47f29a59f3828`.

## Prior client evidence and question

User confirmed P0269 synthetic catalogue previews removed and remaining controls work. Uploaded `0.0.167-dev` diagnostics report `nativeservicepolicycheck` `mode=native-stock`, `families=7`, `ownership=Blizzard-owned`, `nativeMutations=0`, `identity=not-observed`; Quest Dialogue Check, Quest Offer Controls Check (`probeCallOK=false`), and Run All no reported errors. This is not evidence that MerchantFrame or any trainer/flight frame is loaded, restylable, relocatable or safely controllable in combat.

The narrow P0270 question is: **what native frame-name candidates and read-only method/protection metadata exist in this exact Forever client, at rest and during an ordinary accessible service session?** Not: can Logres replace or move native frames yet?

## Source evidence, limits, and implementation

`Logres/Camera/ProfileContexts.lua` already names MerchantFrame, ClassTrainerFrame, BankFrame, AuctionHouseFrame, GossipFrame and others as context hints, while explicitly excluding FlightMapFrame from its NPC-interaction predicate. These are source strings, NOT proof they are loaded or presentation-safe on this client. `Logres/Core/State.lua` supplies an addon-owned normalized interaction flag/type from events; it does not resolve specific service identity. D-047 requires Blizzard control/transactions retained and camera untouched.

P0270 adds `Quest/NativeServiceCapabilities.lua`, a passive (no subscriptions), **developer-invoked** inspector, plus H `Native Service Frame Audit` action. It checks only `_G` candidate reference availability; an ordinary, safely readable `IsProtected()` boolean if available; and whether `GetPoint`/`SetPoint` METHOD MEMBERS exist (never calls either). It does not read visible native geometry, positions, sizes, scripts, children, controls, input, inventory, prices or character state; does not read or mutate secret values. Absent secret-value API, invalid/restricted access or combat yields `deferred`, not a guessed PASS. Mere method presence is NOT mutation permission. It never mutates frames, registers hooks/events, opens panels or triggers native transactions. It reports candidate load hints and normalized Logres state separately, without inferring which service is actually open.

Candidate list: GossipFrame, MerchantFrame, ClassTrainerFrame, FlightMapFrame, BankFrame, AuctionHouseFrame, PetStableFrame and TabardFrame. Merchant inventory, repair and sale all share native MerchantFrame; unique Sell Junk shortcut is client-unverified. All other D-047 families remain Blizzard-owned. Bank/auction light integration is still separately DEFERRED.

## Tests, success and deferrals

Apply is guarded to P0269 `1588fb9` main, clean tracked index+worktree; sources/frozen camera and native policy checked byte-for-byte against HEAD. Candidate shadow overlays all generated files, runs the **entire** `tools/check_*.py` checker inventory, checks whitespace and frozen files before tracked writes. Repeat full suite postwrite, rollback on error, create manifest.

In client: H Native NPC Services Check first, then H Native Service Frame Audit at idle. If accessible normally, open an ordinary merchant **without purchasing/selling/repairing** and repeat audit while native window is visible; trainer optional if already conveniently available (no travel required). Finish 0 Run All. Record all candidate statuses, protected metadata and deferred results. If no merchant accessible this session, mark actual open-session assessment DEFERRED, not PASS/FAIL. Runtime evidence is PENDING as this patch is prepared.

No safe native placement/styling has been demonstrated, no camera change authorized. A future native-backed design must be reversible and fail open; do not infer it from `GetPoint`/`SetPoint` method presence.

## R0 prewrite failure / R1 correction (2026-10-19)

The user applied P0270 R0 from verified pushed P0269. Baseline and 14-path
candidate preparation passed, but the prewrite shadow check suite failed
**1/137**, in `check_p0256_preview_hub_contract.py`:
`ERROR: unexpected total action registrations: 104`. The new H-panel
`nativeServiceFrameAudit` increases global action registrations from 103 to
104, while P preview action count remains 34. R0 neglected to update the
P0256 checker and the dependent P0261/P0269 historical contract references.

**Classification:** ASSISTANT PATCH CONSTRUCTION FAILURE / CLOSED by R1
subject to shadow/static re-execution; no tracked changes were written
because the applier stopped at the prewrite gate. R1 guards all three checkers
and updates them together in one prepared candidate; the
P0270 checker also asserts parity. R1 continues to require all 137
prewrite and postwrite static checks, without relaxing safety constraints.
WoW frame capabilities remain CLIENT UNVERIFIED until user testing.
