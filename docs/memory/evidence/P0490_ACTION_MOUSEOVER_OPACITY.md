# P0490 — Primary 50% resting alpha and combat-opacity mouseover (2026-11-18)

## Verified baseline and new user evidence

GitHub main P0489 `fc821c35250cab7705cbd99019201c610c58750b`, tree `face80af530b5b77d82ad5ab254b6aad45669232`, directly verified. User reports
"Cool, out of combat looks good" for P0489, a **scoped visual PASS** for
nonprimary OOC opacity, not a pet/combat, hover, secure-click or stock
fallback PASS. New request: primary action bar at 50% when out of combat,
100% in combat; mouseover any individual bar/pet cluster should restore
that cluster's existing combat-level opacity. P0488 L-054 intermittent
player-buff recovery remains OPEN; no new buff occurrence is reported.
Protected enemy death target automation L-056 remains BLOCKED.

## Design and implementation boundary

P0489 baseline: secondary/utility/bar4/bar5/pet OOC0, primary OOC1;
combat primary1/secondary1/utility0.75/bar4=secondary1/bar5=utility0.75,
pet1. P0490 makes primary OOC0.5 in world, PvP and instance. Only the
hovered cluster is elevated temporarily to its **combat-level** opacity:
primary1, secondary1, utility0.75, bar4 1, bar5 0.75, pet1. Other clusters
keep their own current policy. On leaving button the cluster returns to
its resting opacity. Combat always retains the original combat policy,
regardless of mouseover. Primary, side and pet sibling keybind/pressed
feedback plates follow their owner alpha, not detached full-bright text.

Only addon-owned existing SecureActionButtonTemplate buttons receive
precreated `HookScript` OnEnter/OnLeave callbacks. No new invisible
hover overlay, mouse focus polling, cursor coordinate reading, OnUpdate,
timer, secure button attribute/binding/click mutation, Blizzard native bar
mutation or action routing change. HookScript setup is refused during
combat lockdown and retried on the next ordinary ActionContext state
transition; no periodic reassertion. Existing tooltip and drag handlers
remain installed and authoritative. The module's disable path disables
hover reactions and restores combat-opacity art. Existing pet arm/layout
fallback, native pet-bar ownership, immersive UI policy and Bar 4/5
source roles are preserved.

Important live caveat: Mouseover eligibility for a visually alpha-zero
secure button must be confirmed in WoW Forever; static event invocation
cannot guarantee physical hit testing. Between individual buttons, a
brief resting-alpha transition may occur; no invisible click-blocking
surface was introduced to eliminate it without runtime evidence.

## Static/source validation and historical contract migration

P0490 actual-source fixture simulates world, PvP, instance, combat,
OnEnter/OnLeave per six clusters, sibling feedback matching, primary
50%/100%, secondary/pet independence, module disable and re-enable.
P0489 source fixture migrated to 50% primary and 60 primary+side
feedback frames (12+48), retaining P0489 OOC0/combat policy. Legacy
P0416, C.4, D-028 and P0489 checkers updated only where they asserted
superseded fixed non-hover alpha; all protected, paging, shape,
version, native fallback and user-authored geometry assertions remain.

Initial full candidate audit **316/351 FAIL**: 35 historical checkers
rejected my over-compacted CURRENT.md (lost literal P0350/P0351/P0352
markers) and a handoff first-line prefix missing the required `# P0486:`
colon. Both are assistant documentation errors, not Lua failures. I
restored all historical markers and the exact handoff prefix without
removing any behavioral/security assertions; targeted former failing
contracts and memory health now PASS. Re-run the entire suite before
releasing final bytes.

The corrected source candidate then passed the complete **351/351 STATIC**
checker audit, including actual-source P0489/P0490 Lua fixtures,
C.4/D-028/P0416 alpha/layout contracts and full historical tests.
No source failures were observed in the corrected audit. First isolated packaged PREWRITE/POSTWRITE **351/351 PASS** and guards,
rollback, ZIP byte parity passed, but canonical `verify-zip` **REFUSED**:
my extra `baseline_tree` SPEC property violated its exact seven-key
schema. This was a packaging-only assistant error. Keep the exact-tree
baseline guard as a separate immutable applier constant, restore the
canonical specification and rebuild. The runtime source was unchanged.
Final rebuilt exact-byte PREWRITE/POSTWRITE, guards, staged parity and
SHA remain required
before handoff. No WoW runtime PASS until user observes mouseover recovery
and combat/stock fallback. L-055 stays OPEN (P0489 OOC scoped PASS).

## Gameplay validation

In WoW Forever, mouse over each existing Logres action/pet button out of
combat. Primary should change 0.5 -> 1, secondary/bar4/pet 0 -> 1,
utility/bar5 0 -> 0.75; exiting returns to rest. Enter combat without
hover, confirm all combat alphas; test button clicks and hotkeys, whether
tooltip/feedback remains usable and no pointer-blocking regions exist.
Developer panel tab C **Action Check** and **Pet Action Probe Check**,
tab D **Context Policy Check**. Capture before/hover/leave/combat via
Report Bug and export diagnostics. Runtime errors or missing hover
remain OPEN and require a corrective patch. P0489 scoped OOC PASS is
retained even if P0490 fails.
