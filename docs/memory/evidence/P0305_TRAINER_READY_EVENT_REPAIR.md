# P0305 — trainer readiness signals: corrective event handoff

Date: 2026-10-22. Authoritative GitHub main P0304 `a493b9f7208898103146d5f4605c0debdb6fa71f` (0.0.205-dev). **P0305 PREPARED / STATIC AND WOW UNVERIFIED** until checkout checks and client testing.

## Runtime negative evidence

The user reports: "Nothing popped up when going to trainer normally. Panel -> Live Trainer works still." **P0304 automatic trainer presentation FAIL** in the user's tested normal interaction, manual H activation PASS. P0304 was pushed and is durable at the baseline hash above, but its default-on behavior is not validated. No additional diagnostic file was supplied. This is a runtime negative result, not proof that any particular event fired or failed to fire. Do not overwrite earlier successful manual catalogue/purchase results.

## Narrow source hypothesis and targeted repair

The P0304 service-neutral `NPCServiceSession.Reconcile` runs synchronously from Logres's normalized interaction state, and `attach` requires an existing nonprotected `ClassTrainerFrame` to set native OnShow. During lazy loading, the state signal may occur before frame creation or native shown state, the initial OnShow may be missed, and ADDON_LOADED may not coincide with native frame readiness. Current session has no trainer-specific later readiness signal. WoW Forever documents `TRAINER_SHOW` and `TRAINER_UPDATE`; these are source-scoped event signals rather than timers or generalized state reassertion. P0305 calls existing `Session.Reconcile` from each. A callback is still gated by active interaction type 7, native ordinary nonprotected source, native shown state, and combat exclusion. Existing per-visit Goodbye/OFF dismissal remains authoritative. The audit counts received readiness signals and remembers their last type; it does not inspect secret Blizzard payloads.

No native frame is hidden, reparented, made mouse-inert or repositioned. No protected geometry, secret values, transaction API, shared catalogue, preview renderer, camera or stock fallback changes. P0304's generic NPC session architecture stays service-neutral; a future gossip service can add separately scoped readiness events rather than inherit trainer-specific assumption.

## Validation and limits

Apply on clean P0304: candidate preflight including all memory headings and prewrite whitespace, 176+ static checkers in shadow before any tracked write, POSTWRITE suite plus `git diff --check` and manifest. Existing source/checker historical contracts must pass; an R0 failure remains evidence if encountered. In WoW `/reload`, speak to Briarthorn without the H ON action; expect Logres alongside visible stock once. Verify manual H ON/OFF, Goodbye remains hidden until leaving and returning, stock trainer usable on failure. No new purchase needed. If runtime still fails, mark P0305 FAIL, inspect addon-owned `NPCServiceSession.GetAudit()` readinessSignals/lastReadinessEvent and return to targeted evidence, not timers or broad OnShow hooks.

References: D-046, D-047, P0304 evidence, WoW Forever Event TRAINER_SHOW and TRAINER_UPDATE. The presence of an event in documentation does not establish its exact ordering in this client's reported interaction.
