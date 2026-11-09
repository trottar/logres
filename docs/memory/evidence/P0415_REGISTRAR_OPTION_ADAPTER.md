# P0415 — Guild Registrar on the approved Quest/NPC option pipeline (L-042)

Baseline: verified pushed P0414 main `ae151e66aa7f09b34abeb4e4a6f8db4df17ac486` (2026-11-09). R2 is an author-side candidate; WoW runtime remains UNVERIFIED. Forever 0.0.291 session 70 incident 8350 screenshot at 01:11:20 Eastern still shows a large merchant-style shell with native parchment, duplicate green NPC name, unintegrated controls. The diagnostics contain `npc/guild-registrar-owned` result `registrar-logres-live`, proving controller activation only. This is an observed VISUAL FAIL. P0413 incident 8259 had the same presentation family failure. L-042 stays OPEN.

## Rejected architectural approach

P0413/P0414 resized/reanchored GuildRegistrarFrame, painted trainer/merchant-like chrome, faded Blizzard decorations and recolored/repositioned native service choices. It was a duplicate service frame layered over Blizzard. User correctly identified that the repository already owns an approved quest/gossip NPC option frame. This old native-frame geometry approach is CLOSED; its evidence and tests are retained with explicit supersession rather than erased. P0414 is verified pushed to main; this candidate uses that exact baseline.

## Corrected architecture

The registrar adapter samples ordinary title and two original Blizzard button labels/scripts only while the validated interaction type is 11 and the greeting (not purchase) page is shown. It creates a plain `NPCOptionModel.FromValidated` envelope, then displays through `QuestDialogue.ShowReadOnlyGossip` -> `NPCOptionSession.StartReadOnly` -> `NPCOptionList`. The view contains no native Blizzard parchment or child-frame geometry. Existing `NPCServiceSession` owns the visit and one-shot event readiness. `NPCServiceNativeParking` is extended only with a capability-gated registrar permit and retains the original trainer family guard. After the Logres view is shown, it parks only the native whole root offscreen. Original native controls remain shown, unmodified, and restorable; no invisible native hit region is left in the playable viewport.

A deliberate Logres option click re-samples all rows, requires an ordinary, matching native button script, restores stock first, dismisses current service session, removes Logres, then calls that original native button script once. This is the original Blizzard handler path, not a fabricated charter API. Failure keeps usable stock. A Goodbye first restores stock and then requests native close. Immersion OFF, native close, world transition and deferred combat restoration all return native ownership. No timer, polling, SetParent, native child geometry, protected mutation or secret comparison is added. Any other Dialogue dismissal first restores the parked registrar root, or keeps the Logres view while native restoration is combat-deferred. A failed park with incomplete rollback retains an inert Logres view until restoration is possible; it never clears the only visible controls. Existing merchant, trainer and quest fixtures remain separately owned.

## Supported and unresolved scope

P0415 integrates only the two-service **greeting/list stage** into the already approved compact quest/gossip frame. The native purchase form, name edit, cost, confirmation and guild registration transactions remain stock after selection. This is an explicit safe intermediate boundary, **not completion of every Guild Registrar stage**. D-047 all-NPC continuity remains the goal, with unsupported native forms fail-open until a dedicated data/input adapter is proven. Do not purchase or register a guild just to validate the candidate.

## Validation required

1. WSL exact baseline P0414, reviewed `chat_change.py check` full static suite, guarded apply, `verify-staged`; fail closed on any checker refusal. Synthetic Lua parser validates the new adapter, but no real client validation has been performed here.
2. Forever Immersion ON: Aldwin Laughlin gossip -> two service choices in the usual Quest/NPC Logres frame; no old merchant 896x712 registrar shell, green duplicate name, native parchment, or extra scrollbar. Test click on **Purchase a Guild Charter** opens native purchase form with original name field/cost/cancel, without buying. Test **Register a Guild Charter** only if safe and no registration will occur; otherwise defer that transaction proof. Check service row order, mouse hitboxes and Goodbye.
3. Close/reopen, Immersion OFF, /reload, fallback and restoration without taint/protected/secret errors. Report Bug incident and export bundle on visual/control failure. Verify merchant and quest/gossip interactions were not regressed.
4. No static check and no stock fallback establishes runtime PASS. L-042 remains OPEN until scoped client PASS is recorded and a pushed commit verified.

## Author-preflight refusal preserved

P0415 R1 passed the exact source-anchor stage but refused 278/283 historical checks: its new checker pinned `0.0.292-dev` (version policy), its new checker expected a missing `UNVERIFIED` proof marker, the L-042 status used a noncanonical `OPEN / VISUAL FAIL` token (P0374 and P0412 failures), and the P0317 historical shared visual contract expected the original displayOnly expression. R2 fixes these narrowly, keeps canonical `OPEN` and negative evidence, and authorizes only the registrar service-mode-specific disabled palette. R1 is REFUSED, not applied. The final preflight receipt, if passing, establishes STATIC only.
