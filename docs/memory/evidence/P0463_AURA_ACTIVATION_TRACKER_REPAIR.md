# P0463 — Aura, activation and native objective tracker repair

Date: 2026-11-16. Baseline main/local `b849955961944b9b62a879b360c6f27612686370`
(P0462). Source/deployed/capture 0.0.331-dev match; session 134 incidents
#13743/#13745/#13748. Export 18:46:41 Eastern, standalone and ZIP diagnostics
SHA-256 `e7b352d318e359a4878de4417b38673f190b7da85f099d7be4e4ef4c72ab2bf4`.
Screenshot matching is inferred, not client-attested. User reports severe
regression and unexpected Blizzard quest UI. Existing L-011/L-028 reopened
evidence; new L-048 distinguishes native objective tracker from NPC dialogs.

## Actual evidence and scope

New screenshots inspected individually: #13743 native selected/secondary bars
while ON pending; #13745 native Forest Spider plus full right-side native
objective tracker during combat; #13748 selected Mangy Wolf Logres HP returns,
native aura icons still crowd its name. No NPC quest dialog is in these images.
Do not claim that the existing L-001/L-002 NPC problems recurred from this
tracker screenshot. Zero Lua/owner counters do not disprove visual failure.

P0462 has safe one-shot pending intent, but ignores already-built display
capability during combat ON. Existing observed plates need not emit another
ADD after a toggle. It also defers an unexecuted OFF that an ON can cancel
without any native mutation. Cancellation requires fresh ordinary selected
role and the same observed ADD epoch; a recycled token cannot retain an owner. P0463 retains these distinctions instead of
repeating setup or tearing down a still-live owner. Replay is bounded to the
HUD's own actual ADD cache, revalidates each ordinary token through the probe,
and never enumerates native plates. P0460 removal identity remains unchanged.
The cumulative capture does not prove every zero secondary attach was caused
by this gap; tests establish the missing replay/prebuilt resume behavior.

## Aura ownership

Reuse Logres.NativeDebuffs for reversible placement of native helpful/harmful
lists. Native engine retains all aura membership, payloads, icons and updates.
Only an ordinary, positively unprotected and non-forbidden list exposing point
APIs can be moved. Ordinary bounded point counts are checked; point values are
captured opaquely and returned directly to SetPoint on restoration. Both lists
are completely captured before mutation. Harmful RIGHT is anchored to owned
bar LEFT -25; helpful LEFT to owned bar RIGHT +25. No reparent, scale, alpha,
unit binding, child enumeration, icon readback or aura-data read is introduced.
This follows the existing guarded stock-player point restoration mechanism.
It fixes arrangement, not native icon artwork. Native icon appearance remains
engine-owned and client visual acceptance is required.

Selected and secondary owners retain separate layout claims. Claims are not
reapplied on steady updates. Partial movement rolls back; refused restoration
keeps opaque tokens and quarantines owner reuse. Unsupported/protected layout
leaves the stock lists usable and reports refusal; no unproven replacement
container is used to justify hiding native information. L-028 remains OPEN.

## Tracker and diagnostics

NativeAccess's existing source-specific OnShow/quest-event refold now permits
combat Hide only for an ordinary, positively unprotected/non-forbidden
ObjectiveTracker root with an existing restoration snapshot. Other surfaces are unchanged. Protected tracker roots use the secure gate
described below; unknown/unavailable capability still defers. No protected mutation or
visibility readback is used. Intentional native access and immersion OFF are
preserved. Report Bug adds tracker reason/pending/manual state and aura layout
claim/restore/refusal metrics; no repeated diagnostic panel checklist required.

## Verification and limits

Seven actual-source fixtures pass: existing P0459 hostile pool, P0460 selected
removal, P0461 native aura ownership, P0462 pending intent; new P0463 aura
point transaction/refusals, prebuilt activation/cache replay/pending OFF cancel,
and tracker combat capability/manual fallback. Lua 5.4 executes source fixtures;
Lua 5.1 parses all client runtime files. Full checker suite, canonical ZIP,
refusal/rollback and exact-byte audit are release gates, not client acceptance.

Initial local Lua linux build failed because optional readline headers were
missing. Generic builds of official Lua 5.1.5/5.4.8 were used instead; no system
package changes. Historical P0461/P0462 aura failures, P0460 HP scoped PASS and
all unrelated NPC failures are retained. Client layout/protection/taint remains
UNVERIFIED; fallback for unavailable tracker gating or a protected aura list is explicit.

## Protected tracker completion

For a positively protected (non-forbidden) tracker, install a native secure
OnShow wrapper out of combat and arm its addon-owned flag when folding.
The post-handler hides the whole tracker after the original OnShow script;
disarm it before manual/immersion restoration. No insecure protected Hide
or attribute update occurs during combat. Unprotected trackers retain the
ordinary guarded direct refold; missing secure capability remains explicit
deferral. Wrapper presence is not visual proof. Source fixture models setup,
protected post-handler, no insecure combat mutation and disarmed restoration;
live secure execution/taint remains UNVERIFIED.

API evidence: Blizzard SecureHandlers implementation, native wrapper and
post-handler dispatch:
https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_RestrictedAddOnEnvironment/SecureHandlers.lua
The API requires an explicitly protected header and pre-handler string;
post dispatch requires a non-nil pre-message. The candidate uses the secure
header template and returns that message. No external addon code copied.

### Release audit results

Seven relevant actual-source fixtures PASS; all three new fixture files FAIL
against unmodified P0462, detecting the missing behavior. Protected tracker
post-handler is modeled from the public native wrapper contract; the model
does not prove client trust/taint execution. Lua 5.1 syntax covers all runtime
Lua. Full exact-candidate checker inventory is 326. Canonical applier audit
requires PREWRITE/POSTWRITE 326/326, exact payload/manifest/cleanup/diff hygiene,
simulated wrong-HEAD refusal and real dirty-source/hash/collision refusals.
Injected POSTWRITE rejection restores all fixture bytes and leaves no manifest.
All applier writes use isolated scratch trees/private fixture indexes. Actual
user HEAD, refs, index bytes and tracked status are checked unchanged.
Final package is rebuilt and this complete audit repeated before delivery.
Client visuals, protected aura-list availability and secure execution remain
UNVERIFIED. No commit/push or runtime deployment by assistant.
