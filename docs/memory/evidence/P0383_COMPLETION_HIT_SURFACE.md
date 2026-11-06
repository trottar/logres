## P0383 — isolated Logres completion input surface (2026-11-06)

Verified remote P0382 `79fb963` baseline (252/252 STATIC, WoW version 0.0.266-dev). User runtime: **L-002 scoped PASS**, Logres Continue advances without visible Blizzard popup; do not close L-002 broadly. **L-005 FAIL**: incident **2797**, session 29, 15:50:40 Eastern, quest 18 Brotherhood of Thieves. The bundled screenshot confirms a selected Militia Dagger and visible Complete Quest. The addon-owned snapshot shows completion applied, action root and button shown/mouse-enabled, frame level 10, Enter/Leave 2/2, Down/Up/dispatch 0/0/0, clickCount=0 and claimCalls=0. Thus the native claim was **never requested**. No evidence of a reward-ordinal or handler rejection. The root cause of lost mouse-down remains **UNCONFIRMED**. P0383 narrowly tests decoupling the **existing single action button** from `LogresQuestDialogue`'s mouse-disabled parent: create its root as an explicitly gated `UIParent` sibling with the same anchor/strata and guarded relative frame level and add a parent-panel OnHide fail-open hide. No native UI mutation, polling, fabricated click or claim bypass; ordinary quest offer, progress, completion, fallback, and immersion OFF must remain usable. Static contracts are not runtime proof. L-005 remains PARTIAL/FAIL pending new screenshot and event-confirmed quest turn-in; see `docs/memory/evidence/P0383_COMPLETION_HIT_SURFACE.md`.

### Runtime evidence scope

Screenshot `LOGRES_BUG_REPORT_LATEST.zip` `screenshots/WoWScrnShot_110626_155040.jpg`, incident 2797 inferred by mtime within 1s. `LOGRES_DIAGNOSTICS_LATEST.lua` session 29 actions 2782–2802; explicit Enter/Leave without Down/Up/dispatch. No controller call, no `QUEST_TURNED_IN`. Native claim outcome not evaluated. L-005 PARTIAL/FAIL remains OPEN for runtime confirmation.

### Validation required

1. Select reward and click same Complete Quest button; expect Down, Up, dispatch, native request and QUEST_TURNED_IN, and award verified. 2. Offer Accept/Decline and progress Continue retained; no native pop on Continue. 3. Goodbye, module-off, unexpected root hide restore stock and remove Logres action. 4. No native invisible click regions, taint, protected or secret errors.

WoW UNVERIFIED for P0383.
