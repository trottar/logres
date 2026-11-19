# P0491 — Secure action alpha on combat entry; all bars rest zero (2026-11-18)

## Observed evidence, authority and regression

Verified P0490 main `054056ba87bc7611191a80bab9f022f3ee04da10`,
Git tree `cdbe9bc1e75a701fd223434265a9029109967598`; locally
reconstructed exact from P0481 author kit plus P0482–P0490 payloads and
GitHub-verified manifest hashes. WoW Forever 0.0.356-dev session174
report #17981 is **out of combat**; no captured combat frame in this
bundle. User reports independently that all bars respond on hover but
**do not return to combat opacity**. Screenshot includes generic
"Interface action failed because of an AddOn"; its protected caller is
unattributed by these diagnostics and is not assigned to Context without
more evidence. Treat P0490 combat as FAIL; P0489 OOC secondary fade PASS
retained, P0490 hover scoped PASS; L-055 remains OPEN.

User additionally changes resting primary from 50% to **0%**, retaining
hover reveal and combat 100% primary/Bar4, 85% secondary/pet,
75% utility/Bar5. All six groups have zero alpha out of combat except while
hovered. Existing button hit regions and keybind feedback remain intact.

## User refinement during validation (2026-11-18)

First revised full audit rejected the exact-8000-byte handoff (old
strict <8000 contract) and missing first-bold **P0486** current
checkpoint, invalidating active-header/historical marker checks (18
checkers total); Lua/runtime fixtures were unaffected. Compacted the
handoff and restored P0486 before repeating all 352 checks; this was
assistant documentation failure, not a WoW result.

Before issuing the P0491 ZIP, user specified **secondary and pet 85%**
when hovered out of combat or while fighting; both still rest at 0%.
Primary and Bar4 continue at 100% on hover/combat; utility and Bar5 at
75%. Bar4 still uses the secondary role for rest, but is explicitly
100% when hovered or fighting. Source policy, secure driver, diagnostics,
three actual-source fixtures and historical context checker requirements
were updated in the same candidate; previous incomplete P0491 PREWRITE/
POSTWRITE run is superseded and does not validate this revised payload.

## Source hypothesis and guarded design

Before P0491, `ActionContext:ApplyPolicy` ran `cluster:SetAlpha` on parents
of SecureActionButtonTemplate children from ordinary state callbacks.
Those callbacks are unsuitable as the sole combat restoration owner and
may trigger protected-action errors or fail to update protected ancestors.
The precise blocked call was NOT logged; this is a source-supported
hypothesis, not definitive in-client provenance. P0491 installs one
`SecureHandlerStateTemplate`/RegisterStateDriver `[combat] combat; rest`
outside lockdown. Restricted `_onstate-logrescombat` restores only the six
addon-owned cluster combat alphas; its `rest` state deliberately does not
write, so it cannot clobber a still-hovered bar after normal OOC callbacks.
No secure action attributes or binding changes.
Normal Lua still owns OOC per-button hover and UIParent sibling feedback.
During lockdown normal Lua skips every protected parent (including pet),
while its unprotected feedback plates receive the current policy.
On module disable out of combat, unregister the secure driver and restore
fully visible controls. Disabling in combat defers this teardown only to
PLAYER_REGEN_ENABLED; never leaves hidden controls without a recovery
path. A missing driver fails open to visible combat-level art.

No timers, OnUpdate, mouse coordinate polling, Blizzard protected-frame
inspection, native-action mutations or new clickable frames. Registration
can be confirmed by addon-owned `secureDriverReady` diagnostic; this does
not constitute proof of in-client execution of the restricted snippet.

## Tests, limitations and deferred future request

P0489/P0490 actual-source fixtures migrated to 0 primary OOC, with secure
state-driver stubs. New P0491 fixture executes the **real** Context/Pet
modules and simulates protected-root SetAlpha refusal in combat; verifies
normal callback never calls it, preconfigured secure transition restores
all six combat alphas, both delivery orders, held hover across combat exit,
sibling feedback, driver unavailability fail-open, and deferred
module-disable/regen teardown. The user
also requests interactive quest-use items near the screenshot's quest HUD;
recorded as a **deferred** feature in POST_P0474_WORKSTREAMS. No item-use
code or native suppression in P0491.

Initial independent audit **298/352 FAIL**: 54 historical checkers rejected
CURRENT.md at 9871 bytes (strict bound 9800); all failures were the
same old memory-size gate, not the alpha Lua fixture. Compacted only
the new active summary to 9791 bytes, preserving older markers.
Re-run the complete suite on these corrected exact bytes. That audit then
passed **352/352**. A follow-up held-mouseover/late-driver `rest` test
failed: the secure `rest` branch overwrote a still-hovered primary alpha.
The new driver now changes protected roots only on `combat`; ordinary OOC
state callbacks retain rest and hover ownership. This failure is retained
as an additional pre-release negative test. Third full corrected candidate audit **352/352 PASS** (all actual-source
Lua, historical contracts and checker-version policy) with no further
source failures. Package guard, PREWRITE/POSTWRITE and live WoW gates
remain separate. Independent
full historical audit plus exact-byte PREWRITE/POSTWRITE ZIP
transaction/refusal/rollback checks remain required before handoff.
User-revised 85% candidate independently repeated **352/352 STATIC PASS**,
including P0489/P0490/P0491 actual-source Lua, memory, and secure-source
contract checks. No source failures after restoring strict handoff/bold
current marker constraints. Packaged PREWRITE, POSTWRITE and rollback
still require separate verification on final ZIP.
P0490 client combat remains FAILED, P0491 in-game result UNVERIFIED.

## Live validation

After deployment/reload, capture out-of-combat all-zero (no hover), hover
primary/side/utility/pet, then normal combat while pointer is elsewhere:
primary and Bar4 must show 100%; secondary/pet 85%; utility/Bar5 75%.
Check secure spell/pet clicks and keyboard bindings and no blocked/taint
warnings. Then leave combat (all-zero at rest) and confirm hover returns.
Use developer panel C **Action Check**, **Pet Action Probe Check** and D
**Context Policy Check**; left-click Report Bug for before/combat/after
screenshots and export. Static PASS is not gameplay PASS.
